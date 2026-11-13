import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/core/calibration/engine.dart';
import 'package:kadian_app/core/calibration/params.dart';

void main() {
  const params = CalibrationParams(engineVersion: 'test');
  final engine = CalibrationEngine(params);

  const freshNode = NodeSnapshot(nodeId: 'n1');
  const item = ItemSnapshot(itemId: 'i1', difficulty: 0);

  group('IRT + BKT 校准', () {
    test('独立答对：能力上升、掌握度高于先验、计入独立', () {
      final out = engine.apply(
        node: freshNode,
        item: item,
        evidence: const EvidenceInput(score: 1),
      );
      expect(out.theta, greaterThan(0));
      expect(out.mastery, greaterThan(params.bktInit));
      expect(out.countsAsIndependent, isTrue);
      expect(out.explainMode, isFalse);
      expect(out.effectiveScore, closeTo(1.0, 1e-9));
    });

    test('答错：掌握度不应上升', () {
      final out = engine.apply(
        node: freshNode,
        item: item,
        evidence: const EvidenceInput(score: 0),
      );
      expect(out.mastery, lessThanOrEqualTo(params.bktInit + 1e-9));
      expect(out.theta, lessThan(0));
    });

    test('看过一级提示：有效分按折减计算，且不计独立', () {
      final assisted = engine.apply(
        node: freshNode,
        item: item,
        evidence: const EvidenceInput(
          score: 1,
          independent: false,
          hintLevel: 1,
          hintRequestCount: 1,
        ),
      );
      expect(assisted.effectiveScore, lessThan(1.0));
      expect(assisted.countsAsIndependent, isFalse);
      // 0.35 折扣 × 0.8 提示因子
      expect(assisted.effectiveScore, closeTo(0.28, 1e-6));
    });

    test('同题三次提示 → 讲解模式，不计成功率、能力不推进', () {
      final out = engine.apply(
        node: freshNode,
        item: item,
        evidence: const EvidenceInput(
          score: 1,
          independent: false,
          hintLevel: 3,
          hintRequestCount: 3,
        ),
      );
      expect(out.explainMode, isTrue);
      expect(out.countsAsIndependent, isFalse);
      expect(out.theta, 0);
    });

    test('超纲证据：能力与掌握度都不推进', () {
      final out = engine.apply(
        node: freshNode,
        item: item,
        evidence: const EvidenceInput(score: 1, outOfScope: true),
      );
      expect(out.wasOutOfScope, isTrue);
      expect(out.theta, 0);
      expect(out.mastery, params.bktInit);
    });

    test('遗忘衰减：30 天未复习，掌握度按半衰期回落', () {
      final lastSeen = DateTime(2026, 1, 1);
      final decayed = engine.decay(0.8, lastSeen, DateTime(2026, 1, 31));
      final expected = 0.8 * math.pow(0.5, 30 / params.decayHalfLifeDays);
      expect(decayed, closeTo(expected, 1e-6));
      expect(decayed, lessThan(0.8));
    });

    test('难度反向更新：题目被做对后 b 变小', () {
      final out = engine.apply(
        node: freshNode,
        item: const ItemSnapshot(itemId: 'i2', difficulty: 1.0),
        evidence: const EvidenceInput(score: 1),
      );
      expect(out.itemDifficulty, lessThan(1.0));
    });

    test('选题信息量在难度接近能力时最大', () {
      final easy = engine.itemInformation(theta: 0, difficulty: -2.5);
      final fit = engine.itemInformation(theta: 0, difficulty: 0);
      expect(fit, greaterThan(easy));
    });

    test('等级带边界', () {
      expect(engine.bandOf(0.0).level, 0);
      expect(engine.bandOf(0.58).level, 3);
      expect(engine.bandOf(0.95).level, 5);
    });
  });
}
