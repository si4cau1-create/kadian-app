import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/db/database.dart';
import 'package:kadian_app/core/db/legacy_migration.dart';
import 'package:kadian_app/core/db/tables.dart';
import 'package:kadian_app/core/subject/subject.dart';
import 'package:sqlite3/open.dart';

/// 旧混合档案 → 单学科档案迁移。
///
/// 造一个 3.x 风格的混合库（ja./en./无法归属三种行都有），验证：
/// - 按 id 前缀拆进两个学科库；
/// - 无法归属的行标 legacy_mixed、强制 independent=false 并归档，不进任何学科库；
/// - 旧库改名 .migrated，不会重复迁移；
/// - reset 模式一键重置：全部归档、一条不导入。
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

  Future<Directory> makeMixedDb({required String name}) async {
    final tmp = await Directory.systemTemp.createTemp(name);
    final dbDir = Directory('${tmp.path}${Platform.pathSeparator}databases')
      ..createSync(recursive: true);
    final oldFile =
        File('${dbDir.path}${Platform.pathSeparator}kadian.sqlite');
    final old = AppDatabase.withExecutor(NativeDatabase(oldFile));

    // 证据：日语一条、英语一条、无法归属一条
    Future<void> evidence(String nodeId, String id, bool independent) {
      return old.insertEvidence(EvidenceEventsCompanion.insert(
        id: id,
        nodeId: nodeId,
        kind: EvidenceKind.attempt,
        score: 1,
        independent: Value(independent),
        createdAt: DateTime(2026, 1, 1),
      ));
    }

    await evidence('ja.g.masu', 'ev-ja', true);
    await evidence('en.r.infer', 'ev-en', true);
    await evidence('vocab.adhoc', 'ev-orphan', true);

    await old.upsertNodeState(NodeStatesCompanion.insert(
      nodeId: 'ja.g.masu',
      mastery: const Value(0.4),
      updatedAt: DateTime(2026, 1, 1),
    ));
    await old.upsertNodeState(NodeStatesCompanion.insert(
      nodeId: 'orphan.node',
      mastery: const Value(0.2),
      updatedAt: DateTime(2026, 1, 1),
    ));

    await old.into(old.achievementStates).insert(
          AchievementStatesCompanion.insert(
            achievementId: 'japanese.level_up',
            updatedAt: DateTime(2026, 1, 1),
          ),
        );
    // 旧式无命名空间成就：无法归属学科，应进 legacy_mixed 归档
    await old.into(old.achievementStates).insert(
          AchievementStatesCompanion.insert(
            achievementId: 'first_step',
            updatedAt: DateTime(2026, 1, 1),
          ),
        );

    await old.close();
    return tmp;
  }

  test('拆分导入：ja/en 各归各家，无法归属的进 legacy_mixed 归档',
      () async {
    final tmp = await makeMixedDb(name: 'legacy_split_');
    final result = await LegacyMigrator.migrateIfPresent(
      learnerId: 'learner-1',
      mode: LegacyMode.split,
      baseDir: tmp,
    );

    expect(result, isNotNull);
    expect(result!.importedBySubject['japanese'], 3); // 证据 + 节点态 + 成就
    expect(result.importedBySubject['english'], 1); // 英语证据
    expect(result.archivedByTable['evidence_events'], 1);
    expect(result.archivedTotal, 3); // 孤儿证据 + 孤儿节点 + 旧式成就

    // 日语库：只有 ja 行
    final jaDb = AppDatabase(
      learnerId: 'learner-1', subject: Subject.japanese, baseDir: tmp);
    final jaEvidence = await jaDb.select(jaDb.evidenceEvents).get();
    expect(jaEvidence.map((e) => e.nodeId), ['ja.g.masu']);
    expect((await jaDb.allNodeStates()).map((e) => e.nodeId), ['ja.g.masu']);
    expect((await jaDb.allAchievementStates()).map((e) => e.achievementId),
        contains('japanese.level_up'));
    await jaDb.close();

    // 英语库：只有 en 行
    final enDb = AppDatabase(
      learnerId: 'learner-1', subject: Subject.english, baseDir: tmp);
    final enEvidence = await enDb.select(enDb.evidenceEvents).get();
    expect(enEvidence.map((e) => e.nodeId), ['en.r.infer']);
    await enDb.close();

    // 归档文件：无法归属的证据标 legacy_mixed、强制 independent=false
    final archive = File(result.archivePath);
    expect(archive.existsSync(), isTrue);
    final text = archive.readAsStringSync();
    expect(text, contains('legacy_mixed'));
    expect(text, contains('vocab.adhoc'));
    expect(text, contains('"independent": false'));

    // 旧库已改名，再次调用不会重复迁移
    expect(File('${result.oldDbPath}.migrated').existsSync(), isTrue);
    expect(
      await LegacyMigrator.migrateIfPresent(
        learnerId: 'learner-1',
        baseDir: tmp,
      ),
      isNull,
    );

    await tmp.delete(recursive: true);
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');

  test('reset 模式：全部归档，一条都不导入', () async {
    final tmp = await makeMixedDb(name: 'legacy_reset_');
    final result = await LegacyMigrator.migrateIfPresent(
      learnerId: 'learner-2',
      mode: LegacyMode.reset,
      baseDir: tmp,
    );

    expect(result, isNotNull);
    expect(result!.importedTotal, 0);
    expect(result.archivedTotal, greaterThan(0));

    final jaDb = AppDatabase(
      learnerId: 'learner-2', subject: Subject.japanese, baseDir: tmp);
    expect(await jaDb.evidenceCount(), 0);
    await jaDb.close();
    final enDb = AppDatabase(
      learnerId: 'learner-2', subject: Subject.english, baseDir: tmp);
    expect(await enDb.evidenceCount(), 0);
    await enDb.close();

    await tmp.delete(recursive: true);
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');

  test('没有旧库时什么都不做', () async {
    final tmp = await Directory.systemTemp.createTemp('legacy_none_');
    expect(
      await LegacyMigrator.migrateIfPresent(
        learnerId: 'learner-3',
        baseDir: tmp,
      ),
      isNull,
    );
    await tmp.delete(recursive: true);
  }, skip: canRun ? null : '缺少 .test_deps/sqlite3.dll');
}
