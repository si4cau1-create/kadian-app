import 'dart:math' as math;

import 'params.dart';

/// 一个节点的当前状态快照（来自 node_states 表）
class NodeSnapshot {
  const NodeSnapshot({
    required this.nodeId,
    this.theta = 0,
    this.mastery,
    this.attempts = 0,
    this.lastSeenAt,
  });

  final String nodeId;
  final double theta;

  /// null 表示从未测过，用 bktInit 作为先验
  final double? mastery;
  final int attempts;
  final DateTime? lastSeenAt;
}

/// 题目参数（来自 item_difficulty 表或内容包默认值）
class ItemSnapshot {
  const ItemSnapshot({
    required this.itemId,
    required this.difficulty,
    this.discrimination = 1.0,
  });

  final String itemId;

  /// IRT b：越大越难
  final double difficulty;

  /// IRT a：区分度，1PL 下暂不参与更新，留给 2PL 升级
  final double discrimination;
}

/// 一次作答/复习产生的原始证据
class EvidenceInput {
  const EvidenceInput({
    required this.score,
    this.independent = true,
    this.hintLevel = 0,
    this.hintRequestCount = 0,
    this.outOfScope = false,
    this.at,
    this.elapsedSeconds,
    this.expectedSeconds,
  });

  /// 0..1：单选对错即 1/0，主观题按 rubric 折算
  final double score;

  /// 是否独立完成（无提示、无答案揭示、非讲解模式）
  final bool independent;
  final int hintLevel;
  final int hintRequestCount;

  /// 超纲证据：只记录不晋级（例如 N5 学习者做 N1 题）
  final bool outOfScope;
  final DateTime? at;
  final double? elapsedSeconds;
  final double? expectedSeconds;
}

class CalibrationOutcome {
  const CalibrationOutcome({
    required this.theta,
    required this.mastery,
    required this.predicted,
    required this.itemDifficulty,
    required this.effectiveScore,
    required this.countsAsIndependent,
    required this.explainMode,
    required this.decayedMastery,
    required this.wasOutOfScope,
  });

  final double theta;
  final double mastery;
  final double predicted;
  final double itemDifficulty;
  final double effectiveScore;
  final bool countsAsIndependent;

  /// 同题请求次数超阈值 → 讲解模式，不计成功率
  final bool explainMode;

  /// 按遗忘曲线衰减后的旧掌握度（展示与结算用）
  final double decayedMastery;
  final bool wasOutOfScope;

  CalibrationOutcome copyWith({double? mastery, double? theta}) =>
      CalibrationOutcome(
        theta: theta ?? this.theta,
        mastery: mastery ?? this.mastery,
        predicted: predicted,
        itemDifficulty: itemDifficulty,
        effectiveScore: effectiveScore,
        countsAsIndependent: countsAsIndependent,
        explainMode: explainMode,
        decayedMastery: decayedMastery,
        wasOutOfScope: wasOutOfScope,
      );
}

double _sigmoid(double x) => 1 / (1 + math.exp(-x));

double _logit(double p) {
  final v = p.clamp(1e-6, 1 - 1e-6);
  return math.log(v / (1 - v));
}

/// 本地校准引擎：IRT（能力/难度）+ BKT（掌握概率）+ 规则层（提示折扣、衰减、超纲）。
///
/// 全部纯函数式，无 IO 依赖，可在 dart test 里直接跑。
class CalibrationEngine {
  CalibrationEngine(this.params);

  final CalibrationParams params;

  /// 遗忘衰减：mastery 按半衰期向 0 回落，返回衰减后的值。
  double decay(double mastery, DateTime? lastSeenAt, DateTime now) {
    if (lastSeenAt == null) return mastery;
    final days = now.difference(lastSeenAt).inMinutes / (60 * 24);
    if (days <= 0) return mastery;
    final retained = math.pow(0.5, days / params.decayHalfLifeDays) as double;
    return mastery * retained;
  }

  /// 预测答对概率（诊断选题与难度带用）
  double predict({required double theta, required double difficulty}) =>
      _sigmoid(theta - difficulty);

  CalibrationOutcome apply({
    required NodeSnapshot node,
    required ItemSnapshot item,
    required EvidenceInput evidence,
    DateTime? now,
  }) {
    final at = evidence.at ?? now ?? DateTime.now();
    final explainMode =
        evidence.hintRequestCount >= params.explainModeHintThreshold;

    final priorMastery = node.mastery ?? params.bktInit;
    final decayed = decay(priorMastery, node.lastSeenAt, at);

    // ---- 规则层：把原始分数折算成「有效证据」 ----
    var effective = evidence.score.clamp(0.0, 1.0);
    if (!evidence.independent) {
      effective *= params.assistedDiscount;
    }
    effective *= params.hintFactor(evidence.hintLevel);

    // 速度修正：明显快于预期且正确 → 略微加成；慢很多 → 略微折扣。
    final expected = evidence.expectedSeconds;
    final elapsed = evidence.elapsedSeconds;
    if (expected != null && elapsed != null && expected > 0 && elapsed > 0) {
      final ratio = elapsed / expected;
      if (ratio < 0.5) {
        effective = math.min(1.0, effective * 1.05);
      } else if (ratio > 2.5) {
        effective *= 0.9;
      }
    }

    if (evidence.outOfScope) {
      // 超纲：不推进能力，只把「见过」记在掌握度上做极小扰动
      return CalibrationOutcome(
        theta: node.theta,
        mastery: decayed,
        predicted: predict(theta: node.theta, difficulty: item.difficulty),
        itemDifficulty: item.difficulty,
        effectiveScore: 0,
        countsAsIndependent: false,
        explainMode: explainMode,
        decayedMastery: decayed,
        wasOutOfScope: true,
      );
    }

    final predicted = predict(theta: node.theta, difficulty: item.difficulty);

    // ---- IRT：能力与题目难度双向增量更新 ----
    double theta = node.theta;
    double itemB = item.difficulty;
    if (!explainMode) {
      final gradient = effective - predicted;
      theta = (theta + params.irtLearningRate * gradient)
          .clamp(params.irtThetaMin, params.irtThetaMax);
      // 难度反向更新：题被做对 → b 变小（更容易）
      itemB = (itemB - params.irtItemLearningRate * gradient)
          .clamp(params.irtThetaMin, params.irtThetaMax);
    }

    // ---- BKT：掌握概率后验 + 学习转移 ----
    final correct = effective >= 0.5;
    final pCorrectGivenKnown = 1 - params.bktSlip;
    final pCorrectGivenUnknown = params.bktGuess;
    final numerator = correct
        ? pCorrectGivenKnown * decayed
        : params.bktSlip * decayed;
    final denominator = correct
        ? (pCorrectGivenKnown * decayed +
            pCorrectGivenUnknown * (1 - decayed))
        : (params.bktSlip * decayed + (1 - params.bktGuess) * (1 - decayed));
    var posterior = denominator <= 0 ? decayed : numerator / denominator;
    posterior = posterior.clamp(0.0, 1.0);

    // 辅助/讲解模式的证据只部分参与转移，防止「一路点提示也算学会」
    final learnGain = explainMode
        ? params.bktLearn * 0.15
        : params.bktLearn *
            (evidence.independent ? 1.0 : params.assistedDiscount + 0.3);
    var next = posterior + (1 - posterior) * learnGain;

    // 答错时掌握度不应因为「转移」反而上升
    if (!correct) {
      next = math.min(next, math.max(posterior, decayed * 0.98));
    }

    // θ=0 表示「平均能力」，不能直接当成 50% 掌握度：
    // 以先验掌握度的对数几率做基线偏移，保证全新节点 mastery == bktInit。
    final mastery = (params.masteryBktWeight * next +
            (1 - params.masteryBktWeight) * masteryFromTheta(theta))
        .clamp(0.0, 1.0);

    return CalibrationOutcome(
      theta: theta,
      mastery: mastery,
      predicted: predicted,
      itemDifficulty: itemB,
      effectiveScore: effective,
      countsAsIndependent:
          evidence.independent && !explainMode && evidence.hintLevel == 0,
      explainMode: explainMode,
      decayedMastery: decayed,
      wasOutOfScope: false,
    );
  }

  /// 诊断选题信息量：p(1-p)，越接近 0.5 越大；再叠加未曝光与目标难度带偏好。
  double itemInformation({
    required double theta,
    required double difficulty,
    int exposure = 0,
    double targetBandWidth = 0.8,
  }) {
    final p = predict(theta: theta, difficulty: difficulty);
    final info = p * (1 - p);
    final bandBonus = (difficulty - theta).abs() <= targetBandWidth ? 1.0 : 0.55;
    final exposurePenalty = 1 / (1 + exposure * 0.35);
    return info * bandBonus * exposurePenalty;
  }

  /// θ → 掌握度的基线映射：θ = 0 时恰好等于先验掌握度
  double masteryFromTheta(double theta) {
    final offset = math.log(params.bktInit / (1 - params.bktInit));
    return _sigmoid(theta + offset);
  }

  /// 掌握度归一化到 0..1 的等级带
  LevelBand bandOf(double mastery) => params.bandFor(mastery.clamp(0.0, 1.0));

  /// 从证据流估算「当前能力」的对数几率形式，便于和 theta 对照（调试/报告用）
  double abilityFromAccuracy(double accuracy, {double prior = 0.5}) {
    final shrunk = (accuracy * 0.85) + (prior * 0.15);
    return _logit(shrunk);
  }
}
