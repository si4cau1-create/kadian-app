/// 旧混合档案 → 单学科档案 迁移。
///
/// 3.x 之前所有学科共用一个 `databases/kadian.sqlite`，证据按 `ja.*` / `en.*`
/// 前缀混在一起。4.0 起一个学科一个数据库文件，启动时检测旧库并按学科拆分：
///
/// - 能按 id 归属（`ja.` / `en.` / `p.ja.` / `japanese.` 前缀）→ 导入对应学科库；
/// - 无法归属的行标 `legacy_mixed`，强制 `independent=false`，归档到
///   `learners/<learnerId>/legacy_mixed.json`，**不进入任何学科库**，
///   从物理上排除出独立成功率与核心成就；
/// - 迁移完成后旧库改名 `kadian.sqlite.migrated`，不再重复迁移。
///
/// [LegacyMode.reset] 对应规格「首期建议直接重置单学科档案」：全部归档、
/// 一条不导入，两个学科都从零开始，但数据仍可导出核对。
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../subject/subject.dart';
import 'database.dart';

/// 迁移策略。
enum LegacyMode {
  /// 按学科拆分导入；无法归属的归档（默认）
  split,

  /// 一键重置：全部归档，不导入任何学科库
  reset,
}

/// 迁移结果。没有旧库时 [LegacyMigrator.migrateIfPresent] 返回 null。
class LegacyMigrationResult {
  const LegacyMigrationResult({
    required this.mode,
    required this.importedBySubject,
    required this.archivedByTable,
    required this.importedTotal,
    required this.archivedTotal,
    required this.archivePath,
    required this.oldDbPath,
  });

  final LegacyMode mode;

  /// 各学科导入的行数，如 `{'japanese': 12, 'english': 3}`
  final Map<String, int> importedBySubject;

  /// 各表归档（legacy_mixed）的行数
  final Map<String, int> archivedByTable;

  final int importedTotal;
  final int archivedTotal;
  final String archivePath;
  final String oldDbPath;

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'imported_by_subject': importedBySubject,
        'archived_by_table': archivedByTable,
        'imported_total': importedTotal,
        'archived_total': archivedTotal,
        'archive_path': archivePath,
        'old_db_path': oldDbPath,
      };
}

class LegacyMigrator {
  LegacyMigrator._();

  static const String _legacyFileName = 'kadian.sqlite';
  static const String _migratedSuffix = '.migrated';

  /// 旧库不存在则什么都不做；存在则迁移并把旧库改名，防止重复导入。
  ///
  /// [baseDir] 仅测试注入用，默认取应用支持目录。
  static Future<LegacyMigrationResult?> migrateIfPresent({
    required String learnerId,
    LegacyMode mode = LegacyMode.split,
    Directory? baseDir,
  }) async {
    final base = baseDir ?? await getApplicationSupportDirectory();
    final oldFile = File(p.join(base.path, 'databases', _legacyFileName));
    if (!oldFile.existsSync()) return null;

    final result = await _migrate(
      base: base,
      learnerId: learnerId,
      oldFile: oldFile,
      mode: mode,
    );

    // 迁移后必须把旧库挪走，否则下次启动会重复导入。
    await _archiveOldDb(oldFile);
    return result;
  }

  static Future<void> _archiveOldDb(File oldFile) async {
    final target = File('${oldFile.path}$_migratedSuffix');
    if (target.existsSync()) target.deleteSync();
    oldFile.renameSync(target.path);
  }

  static Future<LegacyMigrationResult> _migrate({
    required Directory base,
    required String learnerId,
    required File oldFile,
    required LegacyMode mode,
  }) async {
    final oldDb = AppDatabase.withExecutor(NativeDatabase(oldFile));

    // key → 归属学科；null = 无法归属（legacy_mixed）
    final archived = <String, List<Map<String, dynamic>>>{};
    final importedBySubject = {for (final s in Subject.values) s.id: 0};
    final archivedByTable = <String, int>{};

    void archive(String table, Map<String, dynamic> row) {
      archived.putIfAbsent(table, () => []).add(row);
    }

    // ---- 证据 ----
    final evidenceRows = await oldDb.select(oldDb.evidenceEvents).get();
    final targetDbs = <Subject, AppDatabase>{};
    Future<AppDatabase> targetFor(Subject subject) async {
      final existing = targetDbs[subject];
      if (existing != null) return existing;
      final db = AppDatabase(
        learnerId: learnerId,
        subject: subject,
        baseDir: base,
      );
      targetDbs[subject] = db;
      return db;
    }

    for (final row in evidenceRows) {
      final subject = mode == LegacyMode.split
          ? _subjectOf(row.nodeId) ?? _subjectOf(row.itemId ?? '')
          : null;
      if (subject == null) {
        archive('evidence_events', {
          ..._evidenceToJson(row),
          // 规格：无法归属的证据标 legacy_mixed、强制 independent=false，
          // 排除出独立成功率与核心成就
          'legacy_mixed': true,
          'independent': false,
          'source': 'legacy_mixed',
        });
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.evidenceEvents).insertOnConflictUpdate(
            EvidenceEventsCompanion.insert(
              id: row.id,
              learnerId: Value(row.learnerId),
              nodeId: row.nodeId,
              itemId: Value(row.itemId),
              kind: row.kind,
              score: row.score,
              effectiveScore: Value(row.effectiveScore),
              predicted: Value(row.predicted),
              independent: Value(row.independent),
              hintLevel: Value(row.hintLevel),
              hintRequestCount: Value(row.hintRequestCount),
              outOfScope: Value(row.outOfScope),
              explainMode: Value(row.explainMode),
              difficulty: Value(row.difficulty),
              thetaAfter: Value(row.thetaAfter),
              masteryAfter: Value(row.masteryAfter),
              elapsedSeconds: Value(row.elapsedSeconds),
              source: Value(row.source),
              payload: Value(row.payload),
              createdAt: row.createdAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 节点状态 ----
    for (final row in await oldDb.select(oldDb.nodeStates).get()) {
      final subject =
          mode == LegacyMode.split ? _subjectOf(row.nodeId) : null;
      if (subject == null) {
        archive('node_states', {'node_id': row.nodeId, 'legacy_mixed': true});
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.nodeStates).insertOnConflictUpdate(
            NodeStatesCompanion.insert(
              nodeId: row.nodeId,
              learnerId: Value(row.learnerId),
              mastery: Value(row.mastery),
              theta: Value(row.theta),
              attempts: Value(row.attempts),
              independentAttempts: Value(row.independentAttempts),
              independentCorrect: Value(row.independentCorrect),
              assistedAttempts: Value(row.assistedAttempts),
              explainAttempts: Value(row.explainAttempts),
              streak: Value(row.streak),
              engineVersion: Value(row.engineVersion),
              lastSeenAt: Value(row.lastSeenAt),
              updatedAt: row.updatedAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 题目难度 ----
    for (final row in await oldDb.select(oldDb.itemDifficulty).get()) {
      final subject = mode == LegacyMode.split
          ? _subjectOf(row.itemId) ?? _subjectOf(row.nodeId)
          : null;
      if (subject == null) {
        archive('item_difficulty', {'item_id': row.itemId, 'legacy_mixed': true});
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.itemDifficulty).insertOnConflictUpdate(
            ItemDifficultyCompanion.insert(
              itemId: row.itemId,
              nodeId: row.nodeId,
              difficulty: Value(row.difficulty),
              exposure: Value(row.exposure),
              correctCount: Value(row.correctCount),
              updatedAt: row.updatedAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 词表状态 ----
    for (final row in await oldDb.select(oldDb.vocabStates).get()) {
      final subject = mode == LegacyMode.split
          ? _subjectOf(row.wordId) ?? _subjectOf(row.clusterId)
          : null;
      if (subject == null) {
        archive('vocab_states', {'word_id': row.wordId, 'legacy_mixed': true});
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.vocabStates).insertOnConflictUpdate(
            VocabStatesCompanion.insert(
              wordId: row.wordId,
              lemma: row.lemma,
              reading: Value(row.reading),
              gloss: Value(row.gloss),
              dimension: Value(row.dimension),
              clusterId: Value(row.clusterId),
              box: Value(row.box),
              ease: Value(row.ease),
              reps: Value(row.reps),
              lapses: Value(row.lapses),
              lastRating: Value(row.lastRating),
              dueAt: row.dueAt,
              createdAt: row.createdAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 提示事件 ----
    for (final row in await oldDb.select(oldDb.hintEvents).get()) {
      final subject = mode == LegacyMode.split
          ? _subjectOf(row.nodeId) ?? _subjectOf(row.itemId)
          : null;
      if (subject == null) {
        archive('hint_events', {
          'id': row.id,
          'node_id': row.nodeId,
          'legacy_mixed': true,
        });
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.hintEvents).insertOnConflictUpdate(
            HintEventsCompanion.insert(
              id: row.id,
              learnerId: Value(row.learnerId),
              itemId: row.itemId,
              nodeId: row.nodeId,
              selectedText: row.selectedText,
              selectionType: row.selectionType,
              intent: row.intent,
              hintLevel: Value(row.hintLevel),
              answerRevealed: Value(row.answerRevealed),
              outOfScope: Value(row.outOfScope),
              explainMode: Value(row.explainMode),
              filtered: Value(row.filtered),
              servedOffline: Value(row.servedOffline),
              latencyMs: Value(row.latencyMs),
              createdAt: row.createdAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 作答会话 ----
    for (final row in await oldDb.select(oldDb.attempts).get()) {
      final subject = mode == LegacyMode.split
          ? _subjectOf(row.nodeId) ?? _subjectOf(row.itemId)
          : null;
      if (subject == null) {
        archive('attempts', {'id': row.id, 'node_id': row.nodeId, 'legacy_mixed': true});
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.attempts).insertOnConflictUpdate(
            AttemptsCompanion.insert(
              id: row.id,
              itemId: row.itemId,
              nodeId: row.nodeId,
              mode: row.mode,
              hintLevel: Value(row.hintLevel),
              hintRequestCount: Value(row.hintRequestCount),
              assisted: Value(row.assisted),
              answerRevealed: Value(row.answerRevealed),
              correct: Value(row.correct),
              selectedAnswer: Value(row.selectedAnswer),
              elapsedSeconds: Value(row.elapsedSeconds),
              startedAt: row.startedAt,
              finishedAt: Value(row.finishedAt),
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    // ---- 成就状态：按 id 命名空间归属（japanese.xxx / english.xxx）----
    for (final row in await oldDb.select(oldDb.achievementStates).get()) {
      final subject =
          mode == LegacyMode.split ? _subjectOf(row.achievementId) : null;
      if (subject == null) {
        archive('achievement_states', {
          'achievement_id': row.achievementId,
          'legacy_mixed': true,
        });
        continue;
      }
      final db = await targetFor(subject);
      await db.into(db.achievementStates).insertOnConflictUpdate(
            AchievementStatesCompanion.insert(
              achievementId: row.achievementId,
              tier: Value(row.tier),
              progress: Value(row.progress),
              independent: Value(row.independent),
              xpAwarded: Value(row.xpAwarded),
              unlockedAt: Value(row.unlockedAt),
              updatedAt: row.updatedAt,
            ),
          );
      importedBySubject[subject.id] = importedBySubject[subject.id]! + 1;
    }

    for (final db in targetDbs.values) {
      await db.close();
    }
    await oldDb.close();

    // 归档落盘
    var archivedTotal = 0;
    for (final entry in archived.entries) {
      archivedByTable[entry.key] = entry.value.length;
      archivedTotal += entry.value.length;
    }
    final archiveFile =
        File(p.join(base.path, 'learners', learnerId, 'legacy_mixed.json'));
    await archiveFile.parent.create(recursive: true);
    await archiveFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'migrated_at': DateTime.now().toIso8601String(),
        'mode': mode.name,
        'reason': 'legacy_mixed',
        'note': '旧混合档案中无法归属到单一学科的行；已排除出独立成功率与核心成就，'
            'evidence 行强制 independent=false、source=legacy_mixed。',
        'tables': archived,
      }),
    );

    final importedTotal =
        importedBySubject.values.fold<int>(0, (sum, v) => sum + v);

    return LegacyMigrationResult(
      mode: mode,
      importedBySubject: importedBySubject,
      archivedByTable: archivedByTable,
      importedTotal: importedTotal,
      archivedTotal: archivedTotal,
      archivePath: archiveFile.path,
      oldDbPath: oldFile.path,
    );
  }

  /// 实体 id → 学科。识别 `ja.` / `en.` 前缀、`p.ja.` 这类中缀、
  /// 以及成就的 `japanese.` 全名前缀；认不出来返回 null（= legacy_mixed）。
  static Subject? _subjectOf(String id) {
    if (id.isEmpty) return null;
    for (final subject in Subject.values) {
      if (id.startsWith('${subject.packPrefix}.') ||
          id.startsWith('${subject.id}.') ||
          id.contains('.${subject.packPrefix}.')) {
        return subject;
      }
    }
    return null;
  }

  static Map<String, dynamic> _evidenceToJson(EvidenceEventRow row) => {
        'id': row.id,
        'node_id': row.nodeId,
        'item_id': row.itemId,
        'kind': row.kind.name,
        'score': row.score,
        'effective_score': row.effectiveScore,
        'independent': row.independent,
        'hint_level': row.hintLevel,
        'hint_request_count': row.hintRequestCount,
        'explain_mode': row.explainMode,
        'source': row.source,
        'created_at': row.createdAt.toIso8601String(),
        'payload': row.payload,
      };
}
