import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/calibration/engine.dart';
import 'package:kadian_app/core/calibration/level.dart';
import 'package:kadian_app/core/content_pack/loader.dart';
import 'package:kadian_app/core/content_pack/models.dart';
import 'package:kadian_app/core/db/database.dart';
import 'package:kadian_app/core/db/tables.dart';
import 'package:kadian_app/core/services/practice_service.dart';
import 'package:kadian_app/core/subject/subject.dart';
import 'package:kadian_app/features/achievements/achievement_engine.dart';
import 'package:sqlite3/open.dart';

/// 单学科实例的验收标准（规格第 8 条）：
/// 1. 英语档案下调用日语节点报错 subject_mismatch；
/// 2. 日语档案下看不到英语题；
/// 3. 等级摘要与成就墙只含当前学科；
/// 4. 跨学科前置回退被禁止；
/// 5. legacy_mixed 证据不计入独立成功率。
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

  Map<String, String> readPackOf(Subject subject) {
    final dir = Directory('assets/content_pack/${subject.id}');
    return {
      for (final file in dir.listSync().whereType<File>())
        if (file.path.endsWith('.json'))
          file.uri.pathSegments.last: file.readAsStringSync(),
    };
  }

  ContentPack loadPackOf(Subject subject) => const ContentPackLoader()
      .parse(
        readPackOf(subject),
        verifyChecksum: true,
        currentAppVersion: '4.0.0',
        expectedSubject: subject,
      )
      .pack;

  PracticeService serviceOf(AppDatabase db, ContentPack pack, Subject subject) {
    final params = const ContentPackLoader()
        .parse(
          readPackOf(subject),
          verifyChecksum: true,
          currentAppVersion: '4.0.0',
          expectedSubject: subject,
        )
        .calibration;
    return PracticeService(
      db: db,
      pack: pack,
      engine: CalibrationEngine(params),
      aggregator: LevelAggregator(params),
      learnerId: 'test',
      subject: subject,
    );
  }

  group('内容包纯度', () {
    test('日语档案下看不到英语题，反之亦然', () {
      final ja = loadPackOf(Subject.japanese);
      final en = loadPackOf(Subject.english);

      expect(ja.items, isNotEmpty);
      expect(en.items, isNotEmpty);
      for (final item in ja.items) {
        expect(item.id.startsWith('en.'), isFalse, reason: '日语包含英语题 ${item.id}');
        expect(item.nodeId.startsWith('en.'), isFalse);
      }
      for (final item in en.items) {
        expect(item.id.startsWith('ja.'), isFalse, reason: '英语包含日语题 ${item.id}');
        expect(item.nodeId.startsWith('ja.'), isFalse);
      }
      // 图谱与词条同样只含本学科
      for (final node in ja.nodes) {
        expect(Subject.japanese.ownsNode(node.id), isTrue);
      }
      for (final word in en.vocab) {
        expect(word.id.startsWith('ja.'), isFalse);
      }
    });
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');

  group('跨学科调用报错', () {
    late AppDatabase enDb;
    late AppDatabase jaDb;

    setUp(() {
      enDb = AppDatabase.withExecutor(
        NativeDatabase.memory(),
        subject: Subject.english,
      );
      jaDb = AppDatabase.withExecutor(NativeDatabase.memory());
    });

    tearDown(() async {
      await enDb.close();
      await jaDb.close();
    });

    test('英语档案下调用日语节点报 subject_mismatch', () async {
      final service = serviceOf(enDb, loadPackOf(Subject.english), Subject.english);
      await expectLater(
        service.prerequisiteFallback('ja.g.masu'),
        throwsA(isA<SubjectMismatchException>()
            .having((e) => e.code, 'code', 'subject_mismatch')
            .having((e) => e.operation, 'operation', 'prerequisite_fallback')),
      );
    });

    test('调用方传入不同学科一律报错，不静默切换', () async {
      final service = serviceOf(enDb, loadPackOf(Subject.english), Subject.english);
      await expectLater(
        service.levelSummary(subject: Subject.japanese),
        throwsA(isA<SubjectMismatchException>()),
      );
      await expectLater(
        service.nextDiagnosticItem(
          excludeItemIds: const {},
          subject: 'japanese',
        ),
        throwsA(isA<SubjectMismatchException>()),
      );
      // 传当前学科或不传都合法（要等 Future 真正完成，不能只测同步返回）
      await expectLater(service.levelSummary(subject: Subject.english), completes);
      await expectLater(service.levelSummary(), completes);
    });

    test('跨学科前置回退被禁止', () async {
      final jaService =
          serviceOf(jaDb, loadPackOf(Subject.japanese), Subject.japanese);
      // 英语节点在日语图谱里根本不存在，且 ensureOwnsNode 先拦下
      await expectLater(
        jaService.prerequisiteFallback('en.r.infer'),
        throwsA(isA<SubjectMismatchException>()),
      );
    });

    test('等级摘要与成就墙只含当前学科', () async {
      final jaPack = loadPackOf(Subject.japanese);
      final jaService = serviceOf(jaDb, jaPack, Subject.japanese);

      // 造一条日语证据，让等级摘要里有内容
      final item = jaPack.items.first;
      final attempt = await jaService.startAttempt(item);
      await jaService.submitAttempt(
        item: item,
        attempt: attempt,
        correct: true,
        selectedAnswer: item.answerLabel,
        elapsedSeconds: 10,
        hintLevel: 0,
        hintRequestCount: 0,
        answerRevealed: false,
      );

      final summary = await jaService.levelSummary();
      for (final view in summary.nodes) {
        expect(view.nodeId.startsWith('en.'), isFalse);
      }
      final llm = await jaService.summaryForLlm();
      expect(llm['subject'], 'japanese');
      expect(llm['scope'], 'japanese-only');

      final engine = AchievementEngine(
        db: jaDb,
        pack: jaPack,
        requiredEngineVersion: '1.0.0',
        subject: Subject.japanese,
      );
      for (final def in engine.definitions) {
        expect(def.id.startsWith('english.'), isFalse);
        expect(def.id, startsWith('japanese.'));
      }
      final snapshot = await engine.settle();
      for (final view in snapshot.views) {
        expect(view.def.id.startsWith('english.'), isFalse);
      }
    });
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');

  group('legacy_mixed 不进独立统计', () {
    test('标了 legacy_mixed 的证据不计入独立成功率', () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      // 两条独立答对，其中一条是 legacy_mixed 残留
      await db.insertEvidence(EvidenceEventsCompanion.insert(
        id: 'normal',
        nodeId: 'ja.g.masu',
        kind: EvidenceKind.attempt,
        score: 1,
        independent: const Value(true),
        createdAt: DateTime(2026, 1, 1),
      ));
      await db.insertEvidence(EvidenceEventsCompanion.insert(
        id: 'legacy',
        nodeId: 'ja.g.masu',
        kind: EvidenceKind.attempt,
        score: 1,
        independent: const Value(true), // 即便误标 true 也要被过滤
        source: const Value('legacy_mixed'),
        createdAt: DateTime(2026, 1, 2),
      ));

      final stats = await db.evidenceStats();
      expect(stats.independent, 1, reason: 'legacy_mixed 不进独立分轨');
      expect(stats.independentCorrect, 1);
      await db.close();
    });
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');
}
