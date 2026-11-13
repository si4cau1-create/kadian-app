import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/content_pack/loader.dart';
import 'package:kadian_app/core/subject/subject.dart';

/// 打包实测：仓库里真实的内容包必须能通过客户端校验。
///
/// 这一层比单元测试更狠——它检查的是「等一下要装进 APK 的那份数据」，
/// 校验和、字段名、引用完整性只要有一处对不上，这里就红。
///
/// 单学科实例下还多一条硬约束：每份包只能含自己学科的节点，
/// 一个 ja.* 混进英语包，或者反过来，都直接判失败。
void main() {
  const loader = ContentPackLoader();
  const appVersion = '4.0.0';

  Map<String, String> readDir(Directory dir) => {
        for (final file in dir.listSync().whereType<File>())
          if (file.path.endsWith('.json'))
            file.uri.pathSegments.last: file.readAsStringSync(),
      };

  const knownMetrics = {
    'evidence_total',
    'independent_correct',
    'hint_free_items',
    'independent_streak_max',
    'diagnostic_sessions',
    'vocab_reviews',
    'explain_sessions',
    'nodes_at_level_3',
    'nodes_at_level_4',
    'streak_days',
  };

  for (final subject in Subject.values) {
    final dir = Directory('assets/content_pack/${subject.id}');

    group('${subject.label}内容包', () {
      test('目录存在且能通过校验和与版本门槛', () {
        expect(dir.existsSync(), isTrue, reason: '缺少 ${dir.path}');
        final loaded = loader.parse(
          readDir(dir),
          source: dir.path,
          verifyChecksum: true,
          currentAppVersion: appVersion,
          expectedSubject: subject,
        );
        expect(loaded.validation.ok, isTrue,
            reason: loaded.validation.errors.join('；'));
        expect(loaded.validation.errors, isEmpty);
      });

      test('规模与结构符合预期', () {
        final pack = loader.parse(
          readDir(dir),
          verifyChecksum: true,
          currentAppVersion: appVersion,
          expectedSubject: subject,
        ).pack;

        expect(pack.subject, subject);
        expect(pack.subjects.map((e) => e.id), [subject.packPrefix]);
        expect(pack.nodes, isNotEmpty);
        expect(pack.items, isNotEmpty);
        expect(pack.achievements, isNotEmpty);

        for (final node in pack.nodes) {
          expect(subject.ownsNode(node.id), isTrue,
              reason: '${subject.id} 包里混入了外来节点 ${node.id}');
        }

        for (final item in pack.items) {
          expect(pack.nodeById.containsKey(item.nodeId), isTrue,
              reason: '${item.id} 的节点 ${item.nodeId} 不存在');
          expect(subject.ownsNode(item.nodeId), isTrue,
              reason: '${item.id} 指向了外学科节点 ${item.nodeId}');
          if (item.options.isNotEmpty) {
            expect(
                item.answerIndex, inInclusiveRange(0, item.options.length - 1),
                reason: '${item.id} 的 answerIndex 越界');
          }
          expect(item.answerKeywords, isNotEmpty,
              reason: '${item.id} 没有 answerKeywords，一级提示无从过滤');
        }

        for (final achievement in pack.achievements) {
          expect(achievement.id, startsWith('${subject.id}.'),
              reason: '成就 id 缺少学科命名空间：${achievement.id}');
          expect(Subject.tryParse(achievement.subjectId), subject,
              reason: '${achievement.id} 的 subjectId 不是 ${subject.id}');
          expect(knownMetrics, contains(achievement.metric),
              reason: '${achievement.id} 用了未实现的指标 ${achievement.metric}');
          expect(achievement.stages, isNotEmpty);
        }
      });

      test('零跨学科内容', () {
        final pack = loader.parse(
          readDir(dir),
          verifyChecksum: true,
          currentAppVersion: appVersion,
          expectedSubject: subject,
        ).pack;

        expect(pack.foreignNodeIds(subject), isEmpty);
        expect(pack.foreignItemIds(subject), isEmpty);
        expect(pack.foreignClusterIds(subject), isEmpty);
        expect(pack.foreignAchievementIds(subject), isEmpty);
      });
    });
  }

  test('两份包的节点集合互不重叠', () {
    Set<String> nodesOf(Subject subject) => loader
        .parse(
          readDir(Directory('assets/content_pack/${subject.id}')),
          verifyChecksum: true,
          currentAppVersion: appVersion,
          expectedSubject: subject,
        )
        .pack
        .nodes
        .map((e) => e.id)
        .toSet();

    final ja = nodesOf(Subject.japanese);
    final en = nodesOf(Subject.english);
    expect(ja.intersection(en), isEmpty,
        reason: '两份内容包共用节点，单学科隔离被破坏');
  });

  test('加载器拒收学科不符的内容包', () {
    // 拿英语包冒充日语档案：必须在校验阶段就失败
    final loaded = loader.parse(
      readDir(Directory('assets/content_pack/english')),
      verifyChecksum: true,
      currentAppVersion: appVersion,
      expectedSubject: Subject.japanese,
    );
    expect(loaded.validation.ok, isFalse);
    expect(
      loaded.validation.errors.join('；'),
      anyOf(contains('跨学科'), contains('拒绝加载')),
    );
  });

  test('calibration_params 的等级带从 0 覆盖到 1', () {
    final loaded = loader.parse(
      readDir(Directory('assets/content_pack/japanese')),
      verifyChecksum: true,
      currentAppVersion: appVersion,
      expectedSubject: Subject.japanese,
    );
    final bands = loaded.calibration.levelBands;
    expect(bands.first.min, 0.0);
    expect(bands.last.min, greaterThan(0.8));
    expect(loaded.calibration.engineVersion, isNotEmpty);
  });

  test('打好的 OTA ZIP（若已生成）能被客户端解析', () {
    final dist = Directory('dist/content_pack');
    if (!dist.existsSync()) {
      return; // 未跑 build_content_pack.py 时跳过
    }
    final zips = dist
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.zip'))
        .toList();
    if (zips.isEmpty) return;

    for (final zip in zips) {
      final subject = Subject.values.firstWhere(
        (s) => zip.path.toLowerCase().contains(s.id),
        orElse: () => Subject.japanese,
      );
      final archive = ZipDecoder().decodeBytes(zip.readAsBytesSync());
      final files = <String, String>{};
      for (final entry in archive) {
        if (!entry.isFile) continue;
        final data = entry.content;
        if (data is List<int>) {
          files[entry.name] = utf8.decode(data, allowMalformed: true);
        }
      }
      final loaded = loader.parse(
        files,
        source: zip.path,
        verifyChecksum: true,
        currentAppVersion: appVersion,
        expectedSubject: subject,
      );
      expect(loaded.validation.ok, isTrue,
          reason: '${zip.path}：${loaded.validation.errors.join('；')}');
      expect(loaded.pack.manifest.version, isNotEmpty);
    }
  });
}
