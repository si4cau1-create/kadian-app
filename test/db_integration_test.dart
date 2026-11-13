import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/calibration/engine.dart';
import 'package:kadian_app/core/calibration/level.dart';
import 'package:kadian_app/core/calibration/params.dart';
import 'package:kadian_app/core/content_pack/loader.dart';
import 'package:kadian_app/core/content_pack/models.dart';
import 'package:kadian_app/core/db/database.dart';
import 'package:kadian_app/core/services/practice_service.dart';
import 'package:kadian_app/features/achievements/achievement_engine.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

/// 端到端（无设备）验证本地闭环：开题 → 作答 → 证据 → 校准 → 等级 → 成就 → 导出/清空
/// 以及 v1→v2 迁移不丢证据。
///
/// 依赖 `.test_deps/sqlite3.dll`（Windows）。缺失时整组跳过，不阻塞 CI（Linux/macOS 自带 sqlite3）。
void main() {
  final dll = File('.test_deps/sqlite3.dll');
  final canRun = !Platform.isWindows || dll.existsSync();

  setUpAll(() {
    if (Platform.isWindows && dll.existsSync()) {
      open.overrideFor(
        OperatingSystem.windows,
        () => DynamicLibrary.open(dll.absolute.path),
      );
    }
  });

  Map<String, String> readPack() {
    final dir = Directory('assets/content_pack');
    return {
      for (final file in dir.listSync().whereType<File>())
        if (file.path.endsWith('.json'))
          file.uri.pathSegments.last: file.readAsStringSync(),
    };
  }

  ContentPack loadPack() => const ContentPackLoader()
      .parse(readPack(), verifyChecksum: true, currentAppVersion: '3.0.0')
      .pack;

  group('本地闭环', () {
    late AppDatabase db;
    late ContentPack pack;
    late PracticeService practice;
    const params = CalibrationParams.fallback;

    setUp(() {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
      pack = loadPack();
      practice = PracticeService(
        db: db,
        pack: pack,
        engine: CalibrationEngine(params),
        aggregator: const LevelAggregator(params),
      );
    });

    tearDown(() async => db.close());

    test('独立答对：一条证据、节点状态推进、等级可聚合', () async {
      final item = pack.items.firstWhere((i) => i.options.isNotEmpty);
      final attempt = await practice.startAttempt(item);

      final result = await practice.submitAttempt(
        item: item,
        attempt: attempt,
        correct: true,
        selectedAnswer: item.options[item.answerIndex],
        elapsedSeconds: 40,
        hintLevel: 0,
        hintRequestCount: 0,
        answerRevealed: false,
      );

      expect(result.outcome.countsAsIndependent, isTrue);
      expect(await db.evidenceCount(), 1);
      expect(await db.hintCountForItem(item.id), 0);

      final state = await db.nodeState(item.nodeId);
      expect(state, isNotNull);
      expect(state!.attempts, 1);
      expect(state.independentAttempts, 1);
      expect(state.independentCorrect, 1);
      expect(state.mastery, greaterThan(params.bktInit));

      final summary = await practice.levelSummary();
      expect(summary.evidenceCount, 1);
      expect(summary.nodes.length, pack.nodes.length);
      expect(summary.clusters, isNotEmpty);
      expect(summary.independentRatio, 1.0);

      // 题目难度被本地更新过
      final difficulty = await db.itemDifficultyFor(item.id);
      expect(difficulty, isNotNull);
      expect(difficulty!.exposure, 1);
    });

    test('三次提示：hint_events 三条，进入讲解模式，辅助轨计数', () async {
      final item = pack.items.lastWhere((i) => i.options.isNotEmpty);
      final attempt = await practice.startAttempt(item);

      for (var i = 1; i <= 3; i++) {
        await practice.recordHintRequest(
          attempt: attempt,
          selectedText: item.stem.substring(0, 4),
          selectionType: 'phrase',
          intent: 'grammar',
          level: i,
          answerRevealed: false,
          outOfScope: false,
          explainMode: i >= 3,
          filtered: i == 1,
          servedOffline: false,
          latencyMs: 120,
        );
      }

      expect(await db.hintCountForItem(item.id), 3);
      final hints = await db.recentHints();
      expect(hints.length, 3);
      // 三条事件时间戳可能同毫秒，断言集合而不是顺序
      expect(hints.map((h) => h.hintLevel), containsAll([1, 2, 3]));
      expect(hints.where((h) => h.filtered).length, 1);

      final result = await practice.submitAttempt(
        item: item,
        attempt: attempt,
        correct: true,
        selectedAnswer: item.options[item.answerIndex],
        elapsedSeconds: 120,
        hintLevel: 3,
        hintRequestCount: 3,
        answerRevealed: false,
      );

      expect(result.outcome.explainMode, isTrue);
      expect(result.outcome.countsAsIndependent, isFalse);

      final state = await db.nodeState(item.nodeId);
      expect(state!.explainAttempts, 1);
      expect(state.independentAttempts, 0);
      expect(state.assistedAttempts, 0);
    });

    test('成就结算：XP 只来自诊断轨，独立成就只认独立证据', () async {
      final item = pack.items.firstWhere((i) => i.options.isNotEmpty);
      final attempt = await practice.startAttempt(item);
      await practice.submitAttempt(
        item: item,
        attempt: attempt,
        correct: true,
        selectedAnswer: item.options[item.answerIndex],
        elapsedSeconds: 30,
        hintLevel: 0,
        hintRequestCount: 0,
        answerRevealed: false,
      );

      final engine = AchievementEngine(
        db: db,
        pack: pack,
        requiredEngineVersion: '1.0.0',
      );
      final snapshot = await engine.settle();

      final firstStep =
          snapshot.views.firstWhere((v) => v.def.id == 'first_step');
      expect(firstStep.tier, 'bronze');

      // 只做了一道题：诊断 XP 仍为 0
      final diagnostic = snapshot.views
          .firstWhere((v) => v.def.id == 'diagnostic_finish');
      expect(diagnostic.tier, 'none');
      expect(snapshot.totalXp, 0);

      // 再跑一次结算必须幂等（不重复解锁）
      final again = await engine.settle();
      expect(again.newlyUnlocked, isEmpty);
    });

    test('导出包含全部证据，清空后归零', () async {
      final item = pack.items.firstWhere((i) => i.options.isNotEmpty);
      final attempt = await practice.startAttempt(item);
      await practice.submitAttempt(
        item: item,
        attempt: attempt,
        correct: false,
        selectedAnswer: 'x',
        elapsedSeconds: 30,
        hintLevel: 0,
        hintRequestCount: 0,
        answerRevealed: false,
      );

      final exported = await db.exportAll();
      expect((exported['evidence_events'] as List), hasLength(1));
      expect((exported['node_states'] as List), isNotEmpty);
      expect(exported.keys, contains('attempts'));

      await db.wipeAll();
      expect(await db.evidenceCount(), 0);
      expect(await db.allNodeStates(), isEmpty);
    });

    test('复习证据不进节点能力估计', () async {
      final vocab = pack.vocab.first;
      await db.upsertVocab(VocabStatesCompanion.insert(
        wordId: vocab.id,
        lemma: vocab.lemma,
        reading: Value(vocab.reading),
        gloss: Value(vocab.gloss),
        clusterId: Value(vocab.clusterId),
        dueAt: DateTime.now(),
        createdAt: DateTime.now(),
      ));
      final word = (await db.dueVocab(DateTime.now())).first;

      await practice.recordVocabReview(
        word: word,
        rating: 'good',
        quality: 5,
      );

      expect(await db.evidenceCount(), 1);
      expect(await db.allNodeStates(), isEmpty);
    });
  });

  group('数据库迁移', () {
    test('v1 → v2：旧证据不丢，新表新列补齐', () async {
      final dir = Directory.systemTemp.createTempSync('kadian-migrate');
      final file = File('${dir.path}/kadian.sqlite');

      // 手工造一个 v1 库（没有 hint_events/attempts，也没有 v2 新增列）
      final legacy = sqlite3.open(file.path);
      legacy.execute('''
        CREATE TABLE evidence_events (
          id TEXT NOT NULL PRIMARY KEY,
          learner_id TEXT NOT NULL DEFAULT 'local',
          node_id TEXT NOT NULL,
          item_id TEXT NULL,
          kind TEXT NOT NULL,
          score REAL NOT NULL,
          independent INTEGER NOT NULL DEFAULT 1,
          hint_level INTEGER NOT NULL DEFAULT 0,
          hint_request_count INTEGER NOT NULL DEFAULT 0,
          out_of_scope INTEGER NOT NULL DEFAULT 0,
          difficulty REAL NOT NULL DEFAULT 0,
          theta_after REAL NOT NULL DEFAULT 0,
          mastery_after REAL NOT NULL DEFAULT 0,
          elapsed_seconds INTEGER NULL,
          source TEXT NOT NULL DEFAULT 'app',
          payload TEXT NOT NULL DEFAULT '{}',
          created_at INTEGER NOT NULL
        );
        CREATE TABLE node_states (
          node_id TEXT NOT NULL PRIMARY KEY,
          learner_id TEXT NOT NULL DEFAULT 'local',
          mastery REAL NOT NULL DEFAULT 0,
          theta REAL NOT NULL DEFAULT 0,
          attempts INTEGER NOT NULL DEFAULT 0,
          independent_attempts INTEGER NOT NULL DEFAULT 0,
          independent_correct INTEGER NOT NULL DEFAULT 0,
          assisted_attempts INTEGER NOT NULL DEFAULT 0,
          explain_attempts INTEGER NOT NULL DEFAULT 0,
          last_seen_at INTEGER NULL,
          updated_at INTEGER NOT NULL
        );
        CREATE TABLE item_difficulty (
          item_id TEXT NOT NULL PRIMARY KEY,
          node_id TEXT NOT NULL,
          difficulty REAL NOT NULL DEFAULT 0,
          discrimination REAL NOT NULL DEFAULT 1,
          exposure INTEGER NOT NULL DEFAULT 0,
          correct_count INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL
        );
        CREATE TABLE vocab_states (
          word_id TEXT NOT NULL PRIMARY KEY,
          lemma TEXT NOT NULL,
          reading TEXT NOT NULL DEFAULT '',
          gloss TEXT NOT NULL DEFAULT '',
          dimension TEXT NOT NULL DEFAULT 'reading',
          box INTEGER NOT NULL DEFAULT 1,
          ease REAL NOT NULL DEFAULT 2.5,
          reps INTEGER NOT NULL DEFAULT 0,
          lapses INTEGER NOT NULL DEFAULT 0,
          last_rating INTEGER NOT NULL DEFAULT 0,
          due_at INTEGER NOT NULL,
          created_at INTEGER NOT NULL
        );
        CREATE TABLE achievement_states (
          achievement_id TEXT NOT NULL PRIMARY KEY,
          tier TEXT NOT NULL DEFAULT 'none',
          progress REAL NOT NULL DEFAULT 0,
          independent INTEGER NOT NULL DEFAULT 1,
          xp_awarded INTEGER NOT NULL DEFAULT 0,
          unlocked_at INTEGER NULL,
          updated_at INTEGER NOT NULL
        );
        INSERT INTO evidence_events
          (id, node_id, kind, score, created_at)
        VALUES ('legacy-1', 'ja.g.te', 'attempt', 1.0, 1700000000);
        PRAGMA user_version = 1;
      ''');
      legacy.dispose();

      final db = AppDatabase.withExecutor(NativeDatabase(file));
      final count = await db.evidenceCount();
      expect(count, 1, reason: '迁移不得丢失已有证据');

      final recent = await db.recentEvidence();
      expect(recent.single.id, 'legacy-1');

      // 新表可用
      expect(await db.recentHints(), isEmpty);
      expect(await db.allAchievementStates(), isEmpty);
      expect(await db.packVersions(), isEmpty);

      // 新列可用
      final columns = await db
          .customSelect("PRAGMA table_info('evidence_events')")
          .get();
      final names = columns.map((r) => r.read<String>('name')).toSet();
      expect(names, containsAll(['effective_score', 'predicted', 'explain_mode']));

      final vocabColumns =
          await db.customSelect("PRAGMA table_info('vocab_states')").get();
      expect(
        vocabColumns.map((r) => r.read<String>('name')).toSet(),
        contains('cluster_id'),
      );

      await db.close();
      dir.deleteSync(recursive: true);
    });
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');
}
