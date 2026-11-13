import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/calibration/level.dart';
import 'package:kadian_app/core/calibration/params.dart';
import 'package:kadian_app/core/content_pack/loader.dart';

Map<String, String> minimalFiles({String manifestExtra = ''}) => {
      'manifest.json': jsonEncode({
        'packId': 'test.pack',
        'version': '1.0.0',
        'minAppVersion': '3.0.0',
        'engineVersion': '1.0.0',
        'createdAt': '2026-01-01',
        'checksum': '',
      }),
      'graph.json': jsonEncode({
        'subjects': [
          {'id': 'ja', 'title': '日语', 'trackIds': ['ja.n3']}
        ],
        'tracks': [
          {'id': 'ja.n3', 'subjectId': 'ja', 'title': 'N3', 'clusterIds': ['c1']}
        ],
        'clusters': [
          {'id': 'c1', 'subjectId': 'ja', 'title': '语法', 'nodeIds': ['n1', 'n2']}
        ],
        'nodes': [
          {
            'id': 'n1',
            'clusterId': 'c1',
            'title': 'て形',
            'prereqIds': [],
            'weight': 1.0
          },
          {
            'id': 'n2',
            'clusterId': 'c1',
            'title': 'た形',
            'prereqIds': ['n1'],
            'weight': 1.0
          }
        ],
      }),
      'items.json': jsonEncode({
        'passages': [
          {'id': 'p1', 'title': '语篇', 'text': 'テストの文章です。'}
        ],
        'items': [
          {
            'id': 'i1',
            'nodeId': 'n1',
            'passageId': 'p1',
            'type': 'choice',
            'stem': '毎日、日本語を＿＿います。',
            'options': ['勉強して', '勉強する'],
            'answerIndex': 0,
            'answerKeywords': ['勉強して'],
            'difficulty': -0.5
          }
        ],
      }),
      'achievements.json': jsonEncode({
        'achievements': [
          {
            'id': 'a1',
            'title': '第一步',
            'description': 'x',
            'metric': 'evidence_total',
            'stages': [
              {'tier': 'bronze', 'target': 1, 'xp': 0}
            ]
          }
        ]
      }),
      'calibration_params.json': jsonEncode({
        'engineVersion': '1.0.0',
        'assume': manifestExtra,
      }),
    };

void main() {
  const loader = ContentPackLoader();

  group('内容包解析', () {
    test('最小内容包可解析出图谱/题目/词表/成就', () {
      final loaded = loader.parse(minimalFiles());
      expect(loaded.validation.ok, isTrue);
      expect(loaded.pack.nodes.length, 2);
      expect(loaded.pack.items.length, 1);
      expect(loaded.pack.passages.length, 1);
      expect(loaded.pack.achievements.length, 1);
      expect(loaded.pack.nodeById['n1']?.title, 'て形');
      expect(loaded.pack.prereqChain('n2').map((e) => e.id), contains('n1'));
    });

    test('索引构建正确：按簇取节点、按语篇取题', () {
      final pack = loader.parse(minimalFiles()).pack;
      expect(pack.nodesOfCluster('c1').length, 2);
      expect(pack.itemsOfPassage('p1').length, 1);
      expect(pack.itemsOfNode('n1').length, 1);
    });

    test('缺 manifest 直接抛错', () {
      final files = minimalFiles()..remove('manifest.json');
      expect(() => loader.parse(files), throwsA(isA<ContentPackException>()));
    });

    test('校验和不匹配被标记为错误', () {
      final files = minimalFiles();
      final manifest = jsonDecode(files['manifest.json']!) as Map<String, dynamic>;
      manifest['checksum'] = 'deadbeef';
      files['manifest.json'] = jsonEncode(manifest);
      final loaded = loader.parse(files);
      expect(loaded.validation.ok, isFalse);
      expect(loaded.validation.errors.join(), contains('校验和不匹配'));
    });

    test('最低客户端版本不足被标记为错误', () {
      final files = minimalFiles();
      final manifest = jsonDecode(files['manifest.json']!) as Map<String, dynamic>;
      manifest['minAppVersion'] = '9.0.0';
      files['manifest.json'] = jsonEncode(manifest);
      final loaded =
          loader.parse(files, currentAppVersion: '3.0.0');
      expect(loaded.validation.ok, isFalse);
      expect(loaded.validation.errors.join(), contains('需要客户端'));
    });

    test('题目引用不存在的节点只告警，不阻塞加载', () {
      final files = minimalFiles();
      final items = jsonDecode(files['items.json']!) as Map<String, dynamic>;
      (items['items'] as List).first['nodeId'] = 'ghost';
      files['items.json'] = jsonEncode(items);
      final loaded = loader.parse(files);
      expect(loaded.validation.ok, isTrue);
      expect(loaded.validation.warnings.join(), contains('ghost'));
    });

    test('manifest 自身不参与校验和计算', () {
      final files = minimalFiles();
      final before = ContentPackLoader.computeChecksum(files);
      files['manifest.json'] = jsonEncode({'packId': 'changed'});
      expect(ContentPackLoader.computeChecksum(files), before);
    });

    test('校验和算法对文件顺序不敏感', () {
      final files = minimalFiles();
      final reversed = Map.fromEntries(files.entries.toList().reversed);
      expect(
        ContentPackLoader.computeChecksum(files),
        ContentPackLoader.computeChecksum(reversed),
      );
    });
  });

  group('等级聚合', () {
    test('簇掌握度按节点权重平均，未练节点计 0', () {
      final pack = loader.parse(minimalFiles()).pack;
      const params = CalibrationParams.fallback;
      const aggregator = LevelAggregator(params);
      final summary = aggregator.aggregate(
        pack: pack,
        nodes: [
          const NodeLevelView(
            nodeId: 'n1',
            title: 'て形',
            clusterId: 'c1',
            mastery: 0.8,
            level: 4,
            levelLabel: '熟练',
            theta: 1,
            attempts: 3,
            independentAttempts: 3,
            independentCorrect: 2,
          ),
        ],
        evidenceCount: 3,
        independentCount: 3,
        independentCorrect: 2,
        engineVersion: '1.0.0',
      );
      // (0.8 + 0) / 2 = 0.4
      expect(summary.clusters.first.mastery, closeTo(0.4, 1e-9));
      expect(summary.overallMastery, closeTo(0.4, 1e-9));
      expect(summary.overallLevel, 2);
      expect(summary.independentRatio, closeTo(2 / 3, 1e-6));
      expect(summary.weakNodeIds, contains('n2'));
    });

    test('上传给代理的摘要不含原始事件与原文', () {
      final pack = loader.parse(minimalFiles()).pack;
      final summary = const LevelAggregator(CalibrationParams.fallback).aggregate(
        pack: pack,
        nodes: const [],
        evidenceCount: 10,
        independentCount: 8,
        independentCorrect: 6,
        engineVersion: '1.0.0',
      );
      final prompt = summary.toPromptSummary();
      expect(prompt.keys, isNot(contains('evidence')));
      expect(prompt.keys, isNot(contains('text')));
      expect(prompt['independent_ratio'], 0.75);
    });
  });
}
