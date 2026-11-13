import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/content_pack/loader.dart';

/// 打包实测：仓库里真实的内容包必须能通过客户端校验。
///
/// 这一层比单元测试更狠——它检查的是「等一下要装进 APK 的那份数据」，
/// 校验和、字段名、引用完整性只要有一处对不上，这里就红。
void main() {
  final packDir = Directory('assets/content_pack');
  const loader = ContentPackLoader();

  Map<String, String> readDir(Directory dir) => {
        for (final file in dir.listSync().whereType<File>())
          if (file.path.endsWith('.json'))
            file.uri.pathSegments.last: file.readAsStringSync(),
      };

  test('内置内容包能通过校验和与版本门槛', () {
    expect(packDir.existsSync(), isTrue, reason: '缺少 assets/content_pack');
    final loaded = loader.parse(
      readDir(packDir),
      source: packDir.path,
      verifyChecksum: true,
      currentAppVersion: '3.0.0',
    );
    expect(loaded.validation.ok, isTrue,
        reason: loaded.validation.errors.join('；'));
    expect(loaded.validation.errors, isEmpty);
  });

  test('内置内容包的规模与结构符合预期', () {
    final pack = loader.parse(
      readDir(packDir),
      verifyChecksum: true,
      currentAppVersion: '3.0.0',
    ).pack;

    expect(pack.subjects.map((e) => e.id), containsAll(['ja', 'en']));
    expect(pack.clusters.length, greaterThanOrEqualTo(5));
    expect(pack.nodes.length, greaterThanOrEqualTo(15));
    expect(pack.items.length, greaterThanOrEqualTo(15));
    expect(pack.passages.length, greaterThanOrEqualTo(2));
    expect(pack.vocab.length, greaterThanOrEqualTo(20));
    expect(pack.achievements.length, greaterThanOrEqualTo(6));

    // 每道题都必须能落地：有节点、有选项、答案下标合法
    for (final item in pack.items) {
      expect(pack.nodeById.containsKey(item.nodeId), isTrue,
          reason: '${item.id} 的节点 ${item.nodeId} 不存在');
      if (item.options.isNotEmpty) {
        expect(item.answerIndex, inInclusiveRange(0, item.options.length - 1),
            reason: '${item.id} 的 answerIndex 越界');
      }
      expect(item.answerKeywords, isNotEmpty,
          reason: '${item.id} 没有 answerKeywords，一级提示无从过滤');
    }

    // 每个成就指标都得在结算引擎里存在
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
    for (final achievement in pack.achievements) {
      expect(knownMetrics, contains(achievement.metric),
          reason: '${achievement.id} 用了未实现的指标 ${achievement.metric}');
      expect(achievement.stages, isNotEmpty);
    }
  });

  test('calibration_params 的等级带从 0 覆盖到 1', () {
    final loaded = loader.parse(
      readDir(packDir),
      verifyChecksum: true,
      currentAppVersion: '3.0.0',
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

    final bytes = zips.first.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
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
      source: zips.first.path,
      verifyChecksum: true,
      currentAppVersion: '3.0.0',
    );
    expect(loaded.validation.ok, isTrue,
        reason: loaded.validation.errors.join('；'));
    expect(loaded.pack.manifest.version, isNotEmpty);
  });
}
