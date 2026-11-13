import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  EvidenceEvents,
  NodeStates,
  ItemDifficulty,
  VocabStates,
  AchievementStates,
  HintEvents,
  Attempts,
  ContentPackVersions,
  SyncQueue,
  DailyStats,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// 测试/工具用：传入自定义执行器
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndices();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await _upgradeV1ToV2(m);
          }
          await _createIndices();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode = WAL');
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// v1 → v2：只加表、加列，绝不重建，保证证据不丢。
  Future<void> _upgradeV1ToV2(Migrator m) async {
    final existing = await _tableNames();

    Future<void> ensureTable(TableInfo table) async {
      if (!existing.contains(table.actualTableName)) {
        await m.createTable(table);
      }
    }

    await ensureTable(hintEvents);
    await ensureTable(attempts);
    await ensureTable(contentPackVersions);
    await ensureTable(syncQueue);
    await ensureTable(dailyStats);

    final vocabColumns = await _columnNames('vocab_states');
    if (vocabColumns.isNotEmpty && !vocabColumns.contains('cluster_id')) {
      await m.addColumn(vocabStates, vocabStates.clusterId);
    }

    final evidenceColumns = await _columnNames('evidence_events');
    if (evidenceColumns.isNotEmpty) {
      if (!evidenceColumns.contains('effective_score')) {
        await m.addColumn(evidenceEvents, evidenceEvents.effectiveScore);
      }
      if (!evidenceColumns.contains('predicted')) {
        await m.addColumn(evidenceEvents, evidenceEvents.predicted);
      }
      if (!evidenceColumns.contains('explain_mode')) {
        await m.addColumn(evidenceEvents, evidenceEvents.explainMode);
      }
    }

    final nodeColumns = await _columnNames('node_states');
    if (nodeColumns.isNotEmpty) {
      if (!nodeColumns.contains('assisted_attempts')) {
        await m.addColumn(nodeStates, nodeStates.assistedAttempts);
      }
      if (!nodeColumns.contains('explain_attempts')) {
        await m.addColumn(nodeStates, nodeStates.explainAttempts);
      }
      if (!nodeColumns.contains('streak')) {
        await m.addColumn(nodeStates, nodeStates.streak);
      }
      if (!nodeColumns.contains('engine_version')) {
        await m.addColumn(nodeStates, nodeStates.engineVersion);
      }
    }
  }

  Future<Set<String>> _tableNames() async {
    final rows = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    ).get();
    return rows.map((r) => r.read<String>('name')).toSet();
  }

  Future<Set<String>> _columnNames(String table) async {
    final tables = await _tableNames();
    if (!tables.contains(table)) return <String>{};
    final rows = await customSelect('PRAGMA table_info($table)').get();
    return rows.map((r) => r.read<String>('name')).toSet();
  }

  Future<void> _createIndices() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS idx_evidence_node ON evidence_events(node_id)',
      'CREATE INDEX IF NOT EXISTS idx_evidence_created ON evidence_events(created_at)',
      'CREATE INDEX IF NOT EXISTS idx_evidence_item ON evidence_events(item_id)',
      'CREATE INDEX IF NOT EXISTS idx_hint_item ON hint_events(item_id)',
      'CREATE INDEX IF NOT EXISTS idx_hint_created ON hint_events(created_at)',
      'CREATE INDEX IF NOT EXISTS idx_vocab_due ON vocab_states(due_at)',
      'CREATE INDEX IF NOT EXISTS idx_attempt_item ON attempts(item_id)',
    ];
    for (final sql in statements) {
      await customStatement(sql);
    }
  }

  // ---------------- 证据 ----------------

  Future<void> insertEvidence(EvidenceEventsCompanion row) =>
      into(evidenceEvents).insert(row);

  Future<int> evidenceCount() async {
    final count = evidenceEvents.id.count();
    final row = await (selectOnly(evidenceEvents)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  Future<EvidenceStats> evidenceStats() async {
    final total = evidenceEvents.id.count();
    final independent = evidenceEvents.id.count(
      filter: evidenceEvents.independent.equals(true),
    );
    final independentCorrect = evidenceEvents.id.count(
      filter: evidenceEvents.independent.equals(true) &
          evidenceEvents.score.isBiggerOrEqualValue(0.5),
    );
    final row = await (selectOnly(evidenceEvents)
          ..addColumns([total, independent, independentCorrect]))
        .getSingle();
    return EvidenceStats(
      total: row.read(total) ?? 0,
      independent: row.read(independent) ?? 0,
      independentCorrect: row.read(independentCorrect) ?? 0,
    );
  }

  Future<List<EvidenceEventRow>> recentEvidence({int limit = 50}) =>
      (select(evidenceEvents)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  Future<List<EvidenceEventRow>> evidenceForNode(String nodeId,
          {int limit = 200}) =>
      (select(evidenceEvents)
            ..where((t) => t.nodeId.equals(nodeId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  // ---------------- 节点状态 ----------------

  Future<NodeStateRow?> nodeState(String nodeId) =>
      (select(nodeStates)..where((t) => t.nodeId.equals(nodeId)))
          .getSingleOrNull();

  Future<List<NodeStateRow>> allNodeStates() => select(nodeStates).get();

  Future<void> upsertNodeState(NodeStatesCompanion row) =>
      into(nodeStates).insertOnConflictUpdate(row);

  // ---------------- 题目难度 ----------------

  Future<ItemDifficultyRow?> itemDifficultyFor(String itemId) =>
      (select(itemDifficulty)..where((t) => t.itemId.equals(itemId)))
          .getSingleOrNull();

  Future<List<ItemDifficultyRow>> allItemDifficulties() =>
      select(itemDifficulty).get();

  Future<void> upsertItemDifficulty(ItemDifficultyCompanion row) =>
      into(itemDifficulty).insertOnConflictUpdate(row);

  // ---------------- 作答会话 ----------------

  Future<void> insertAttempt(AttemptsCompanion row) =>
      into(attempts).insert(row);

  Future<AttemptRow?> openAttempt(String itemId) =>
      (select(attempts)
            ..where((t) => t.itemId.equals(itemId) & t.finishedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> updateAttempt(String id, AttemptsCompanion row) =>
      (update(attempts)..where((t) => t.id.equals(id))).write(row);

  Future<List<AttemptRow>> attemptsForItem(String itemId) =>
      (select(attempts)..where((t) => t.itemId.equals(itemId))).get();

  Future<int> todayAttemptCount(DateTime dayStart) async {
    final count = attempts.id.count();
    final row = await (selectOnly(attempts)
          ..addColumns([count])
          ..where(attempts.startedAt.isBiggerOrEqualValue(dayStart)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  // ---------------- 攻略事件 ----------------

  Future<void> insertHintEvent(HintEventsCompanion row) =>
      into(hintEvents).insert(row);

  Future<int> hintCountForItem(String itemId) async {
    final count = hintEvents.id.count();
    final row = await (selectOnly(hintEvents)
          ..addColumns([count])
          ..where(hintEvents.itemId.equals(itemId)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<HintEventRow>> recentHints({int limit = 100}) =>
      (select(hintEvents)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  // ---------------- 词汇 ----------------

  Future<void> upsertVocab(VocabStatesCompanion row) =>
      into(vocabStates).insertOnConflictUpdate(row);

  Future<List<VocabStateRow>> dueVocab(DateTime now, {int limit = 40}) =>
      (select(vocabStates)
            ..where((t) => t.dueAt.isSmallerOrEqualValue(now))
            ..orderBy([(t) => OrderingTerm.asc(t.dueAt)])
            ..limit(limit))
          .get();

  Future<List<VocabStateRow>> allVocab() => select(vocabStates).get();

  Future<int> vocabCount() async {
    final count = vocabStates.wordId.count();
    final row = await (selectOnly(vocabStates)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  // ---------------- 成就 ----------------

  Future<List<AchievementStateRow>> allAchievementStates() =>
      select(achievementStates).get();

  Future<void> upsertAchievement(AchievementStatesCompanion row) =>
      into(achievementStates).insertOnConflictUpdate(row);

  // ---------------- 内容包版本 ----------------

  Future<void> recordPackVersion(ContentPackVersionsCompanion row) async {
    await transaction(() async {
      await (update(contentPackVersions)
            ..where((t) => t.active.equals(true)))
          .write(const ContentPackVersionsCompanion(active: Value(false)));
      await into(contentPackVersions).insertOnConflictUpdate(row);
    });
  }

  Future<List<ContentPackVersionRow>> packVersions() =>
      select(contentPackVersions).get();

  // ---------------- 同步队列（预留） ----------------

  Future<void> enqueueSync(SyncQueueCompanion row) =>
      into(syncQueue).insert(row);

  Future<List<SyncQueueRow>> pendingSync({int limit = 200}) =>
      (select(syncQueue)
            ..where((t) => t.synced.equals(false))
            ..limit(limit))
          .get();

  // ---------------- 每日统计 ----------------

  Future<void> bumpDaily({
    required DateTime dayStart,
    int evidence = 0,
    int independent = 0,
    int hints = 0,
    int reviews = 0,
    int minutes = 0,
  }) async {
    final existing = await (select(dailyStats)
          ..where((t) => t.day.equals(dayStart)))
        .getSingleOrNull();
    if (existing == null) {
      await into(dailyStats).insert(DailyStatsCompanion.insert(
        day: dayStart,
        evidenceCount: Value(evidence),
        independentCount: Value(independent),
        hintCount: Value(hints),
        reviewCount: Value(reviews),
        minutes: Value(minutes),
      ));
      return;
    }
    await (update(dailyStats)..where((t) => t.day.equals(dayStart))).write(
      DailyStatsCompanion(
        evidenceCount: Value(existing.evidenceCount + evidence),
        independentCount: Value(existing.independentCount + independent),
        hintCount: Value(existing.hintCount + hints),
        reviewCount: Value(existing.reviewCount + reviews),
        minutes: Value(existing.minutes + minutes),
      ),
    );
  }

  Future<DailyStatRow?> dailyStat(DateTime dayStart) =>
      (select(dailyStats)..where((t) => t.day.equals(dayStart)))
          .getSingleOrNull();

  Future<List<DailyStatRow>> recentDaily({int days = 14}) =>
      (select(dailyStats)
            ..orderBy([(t) => OrderingTerm.desc(t.day)])
            ..limit(days))
          .get();

  // ---------------- 数据主权 ----------------

  /// 导出全部本地数据（用户主动触发，不含任何密钥/令牌）
  Future<Map<String, dynamic>> exportAll() async {
    final evidence = await select(evidenceEvents).get();
    final nodes = await select(nodeStates).get();
    final items = await select(itemDifficulty).get();
    final vocab = await select(vocabStates).get();
    final achievements = await select(achievementStates).get();
    final hints = await select(hintEvents).get();
    final attemptsRows = await select(attempts).get();
    final daily = await select(dailyStats).get();

    return {
      'exported_at': DateTime.now().toIso8601String(),
      'schema_version': schemaVersion,
      'evidence_events': [
        for (final row in evidence)
          {
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
            'difficulty': row.difficulty,
            'theta_after': row.thetaAfter,
            'mastery_after': row.masteryAfter,
            'created_at': row.createdAt.toIso8601String(),
            'payload': row.payload,
          }
      ],
      'node_states': [
        for (final row in nodes)
          {
            'node_id': row.nodeId,
            'mastery': row.mastery,
            'theta': row.theta,
            'attempts': row.attempts,
            'independent_attempts': row.independentAttempts,
            'independent_correct': row.independentCorrect,
            'assisted_attempts': row.assistedAttempts,
            'explain_attempts': row.explainAttempts,
            'engine_version': row.engineVersion,
            'last_seen_at': row.lastSeenAt?.toIso8601String(),
          }
      ],
      'item_difficulty': [
        for (final row in items)
          {
            'item_id': row.itemId,
            'node_id': row.nodeId,
            'difficulty': row.difficulty,
            'exposure': row.exposure,
            'correct_count': row.correctCount,
          }
      ],
      'vocab_states': [
        for (final row in vocab)
          {
            'word_id': row.wordId,
            'lemma': row.lemma,
            'box': row.box,
            'ease': row.ease,
            'reps': row.reps,
            'due_at': row.dueAt.toIso8601String(),
          }
      ],
      'achievement_states': [
        for (final row in achievements)
          {
            'achievement_id': row.achievementId,
            'tier': row.tier,
            'progress': row.progress,
            'xp': row.xpAwarded,
          }
      ],
      'hint_events': [
        for (final row in hints)
          {
            'item_id': row.itemId,
            'intent': row.intent,
            'hint_level': row.hintLevel,
            'filtered': row.filtered,
            'served_offline': row.servedOffline,
            'created_at': row.createdAt.toIso8601String(),
          }
      ],
      'attempts': [
        for (final row in attemptsRows)
          {
            'item_id': row.itemId,
            'mode': row.mode.name,
            'correct': row.correct,
            'hint_request_count': row.hintRequestCount,
            'elapsed_seconds': row.elapsedSeconds,
          }
      ],
      'daily_stats': [
        for (final row in daily)
          {
            'day': row.day.toIso8601String(),
            'evidence': row.evidenceCount,
            'independent': row.independentCount,
            'hints': row.hintCount,
            'reviews': row.reviewCount,
            'minutes': row.minutes,
          }
      ],
    };
  }

  /// 删除全部本地数据（UI 必须二次确认）
  Future<void> wipeAll() async {
    await transaction(() async {
      await delete(evidenceEvents).go();
      await delete(nodeStates).go();
      await delete(itemDifficulty).go();
      await delete(vocabStates).go();
      await delete(achievementStates).go();
      await delete(hintEvents).go();
      await delete(attempts).go();
      await delete(contentPackVersions).go();
      await delete(syncQueue).go();
      await delete(dailyStats).go();
    });
  }

  /// 连续打卡天数（从今天/昨天往前数）
  Future<int> streakDays(DateTime now) async {
    final rows = await recentDaily(days: 400);
    if (rows.isEmpty) return 0;
    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    final byDay = {
      for (final r in rows) DateTime(r.day.year, r.day.month, r.day.day): r
    };
    if (!byDay.containsKey(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!byDay.containsKey(cursor)) return 0;
    }
    while (byDay.containsKey(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

class EvidenceStats {
  const EvidenceStats({
    required this.total,
    required this.independent,
    required this.independentCorrect,
  });

  final int total;
  final int independent;
  final int independentCorrect;

  double get independentAccuracy =>
      independent == 0 ? 0 : independentCorrect / independent;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Android 上先保证 sqlite3 可用（sqlite3_flutter_libs 随包分发的动态库）
    try {
      applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    } catch (_) {
      // 桌面端/非 Android 平台忽略
    }
    await _prepareAndroidSqliteTempDir();

    final dir = await getApplicationSupportDirectory();
    final dbDir = Directory(p.join(dir.path, 'databases'));
    if (!dbDir.existsSync()) {
      dbDir.createSync(recursive: true);
    }
    final file = File(p.join(dbDir.path, 'kadian.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// 桌面端不需要，Android 上给 sqlite3 一个可写的临时目录
Future<void> _prepareAndroidSqliteTempDir() async {
  if (!Platform.isAndroid) return;
  try {
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'sqlite3_temp');
    final dir = Directory(tempPath);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    sqlite3.tempDirectory = tempPath;
  } catch (_) {
    // 尽力而为，失败不阻塞启动
  }
}
