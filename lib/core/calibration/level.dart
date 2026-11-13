import 'engine.dart';
import 'params.dart';
import '../content_pack/models.dart';

/// 节点等级聚合结果
class NodeLevelView {
  const NodeLevelView({
    required this.nodeId,
    required this.title,
    required this.clusterId,
    required this.mastery,
    required this.level,
    required this.levelLabel,
    required this.theta,
    required this.attempts,
    required this.independentAttempts,
    required this.independentCorrect,
    this.lastSeenAt,
  });

  final String nodeId;
  final String title;
  final String clusterId;
  final double mastery;
  final int level;
  final String levelLabel;
  final double theta;
  final int attempts;
  final int independentAttempts;
  final int independentCorrect;
  final DateTime? lastSeenAt;

  double get independentAccuracy =>
      independentAttempts == 0 ? 0 : independentCorrect / independentAttempts;

  Map<String, dynamic> toJson() => {
        'nodeId': nodeId,
        'title': title,
        'clusterId': clusterId,
        'mastery': double.parse(mastery.toStringAsFixed(3)),
        'level': level,
        'levelLabel': levelLabel,
        'theta': double.parse(theta.toStringAsFixed(3)),
        'attempts': attempts,
        'independentAttempts': independentAttempts,
        'independentCorrect': independentCorrect,
        'lastSeenAt': lastSeenAt?.toIso8601String(),
      };
}

class ClusterLevelView {
  const ClusterLevelView({
    required this.clusterId,
    required this.title,
    required this.level,
    required this.levelLabel,
    required this.mastery,
    required this.nodeCount,
    required this.touchedNodes,
    required this.weakNodeIds,
  });

  final String clusterId;
  final String title;
  final int level;
  final String levelLabel;
  final double mastery;
  final int nodeCount;
  final int touchedNodes;
  final List<String> weakNodeIds;

  Map<String, dynamic> toJson() => {
        'clusterId': clusterId,
        'title': title,
        'level': level,
        'levelLabel': levelLabel,
        'mastery': double.parse(mastery.toStringAsFixed(3)),
        'nodeCount': nodeCount,
        'touchedNodes': touchedNodes,
        'weakNodeIds': weakNodeIds,
      };
}

/// 给客户端的「局部等级摘要」——上传给代理的只有这个，不含原始作答事件。
class LevelSummary {
  const LevelSummary({
    required this.overallLevel,
    required this.overallLabel,
    required this.overallMastery,
    required this.nodes,
    required this.clusters,
    required this.independentRatio,
    required this.evidenceCount,
    required this.engineVersion,
    required this.generatedAt,
    this.weakNodeIds = const [],
  });

  final int overallLevel;
  final String overallLabel;
  final double overallMastery;
  final List<NodeLevelView> nodes;
  final List<ClusterLevelView> clusters;
  final double independentRatio;
  final int evidenceCount;
  final String engineVersion;
  final DateTime generatedAt;
  final List<String> weakNodeIds;

  /// 上传给 LLM 代理的压缩摘要（无原始事件、无原文）
  Map<String, dynamic> toPromptSummary() => {
        'overall': {'level': overallLevel, 'label': overallLabel},
        'clusters': [
          for (final c in clusters)
            {'id': c.clusterId, 'level': c.level, 'mastery': c.mastery}
        ],
        'weak_nodes': weakNodeIds.take(8).toList(),
        'independent_ratio': double.parse(independentRatio.toStringAsFixed(2)),
        'engine_version': engineVersion,
      };

  Map<String, dynamic> toJson() => {
        'overallLevel': overallLevel,
        'overallLabel': overallLabel,
        'overallMastery': double.parse(overallMastery.toStringAsFixed(3)),
        'nodes': nodes.map((e) => e.toJson()).toList(),
        'clusters': clusters.map((e) => e.toJson()).toList(),
        'independentRatio': double.parse(independentRatio.toStringAsFixed(3)),
        'evidenceCount': evidenceCount,
        'engineVersion': engineVersion,
        'generatedAt': generatedAt.toIso8601String(),
        'weakNodeIds': weakNodeIds,
      };

  bool get isEmpty => evidenceCount == 0;
}

/// 把 node_states 行 + 图谱聚合成等级看板
class LevelAggregator {
  const LevelAggregator(this.params);

  final CalibrationParams params;

  LevelSummary aggregate({
    required ContentPack pack,
    required List<NodeLevelView> nodes,
    required int evidenceCount,
    required int independentCount,
    required int independentCorrect,
    required String engineVersion,
    DateTime? now,
  }) {
    final byId = {for (final n in nodes) n.nodeId: n};

    final clusters = <ClusterLevelView>[];
    for (final cluster in pack.clusters) {
      final clusterNodes = pack.nodesOfCluster(cluster.id);
      if (clusterNodes.isEmpty) continue;

      var weighted = 0.0;
      var weightSum = 0.0;
      var touched = 0;
      final weak = <String>[];
      for (final def in clusterNodes) {
        final view = byId[def.id];
        final mastery = view?.mastery ?? 0;
        final w = def.weight <= 0 ? 1.0 : def.weight;
        weighted += mastery * w;
        weightSum += w;
        if (view != null && view.attempts > 0) touched++;
        if (mastery < 0.4) weak.add(def.id);
      }
      final mastery = weightSum == 0 ? 0.0 : weighted / weightSum;
      final band = bandOf(mastery);
      clusters.add(ClusterLevelView(
        clusterId: cluster.id,
        title: cluster.title,
        level: band,
        levelLabel: labelOf(band),
        mastery: mastery,
        nodeCount: clusterNodes.length,
        touchedNodes: touched,
        weakNodeIds: weak,
      ));
    }

    var weighted = 0.0;
    var weightSum = 0.0;
    for (final def in pack.nodes) {
      final view = byId[def.id];
      final w = def.weight <= 0 ? 1.0 : def.weight;
      weighted += (view?.mastery ?? 0) * w;
      weightSum += w;
    }
    final overallMastery = weightSum == 0 ? 0.0 : weighted / weightSum;

    final ratio =
        independentCount == 0 ? 0.0 : independentCorrect / independentCount;

    final weak = <NodeLevelView>[
      for (final node in pack.nodes)
        if ((byId[node.id]?.mastery ?? 0) < 0.4)
          byId[node.id] ??
              NodeLevelView(
                nodeId: node.id,
                title: node.title,
                clusterId: node.clusterId,
                mastery: 0,
                level: 0,
                levelLabel: labelOf(0),
                theta: 0,
                attempts: 0,
                independentAttempts: 0,
                independentCorrect: 0,
              ),
    ]..sort((a, b) => a.mastery.compareTo(b.mastery));

    return LevelSummary(
      overallLevel: bandOf(overallMastery),
      overallLabel: labelOf(bandOf(overallMastery)),
      overallMastery: overallMastery,
      nodes: [...nodes]..sort((a, b) => b.mastery.compareTo(a.mastery)),
      clusters: clusters,
      independentRatio: ratio,
      evidenceCount: evidenceCount,
      engineVersion: engineVersion,
      generatedAt: now ?? DateTime.now(),
      weakNodeIds: weak.map((e) => e.nodeId).toList(),
    );
  }

  int bandOf(double mastery) => params.bandFor(mastery.clamp(0.0, 1.0)).level;

  String labelOf(int level) {
    final match = params.levelBands.where((b) => b.level == level);
    if (match.isNotEmpty) return match.first.label;
    return 'L$level';
  }

  /// 下一步该学什么：掌握度最低 + 前置已过 + 未被近期覆盖
  List<NodeDef> recommendNext({
    required ContentPack pack,
    required Map<String, double> masteryByNode,
    int limit = 3,
  }) {
    final candidates = <NodeDef>[];
    for (final node in pack.nodes) {
      final mastery = masteryByNode[node.id] ?? 0;
      if (mastery >= 0.58) continue;
      final prereqOk = node.prereqIds.every(
        (p) => (masteryByNode[p] ?? 0) >= 0.38,
      );
      if (prereqOk) candidates.add(node);
    }
    candidates.sort((a, b) {
      final ma = masteryByNode[a.id] ?? 0;
      final mb = masteryByNode[b.id] ?? 0;
      return ma.compareTo(mb);
    });
    return candidates.take(limit).toList();
  }
}

/// 诊断模式下的「下一题」选择：最大信息量 + 难度带贴合 + 未曝光
class NextItemSelector {
  const NextItemSelector(this.engine);

  final CalibrationEngine engine;

  ItemDef? pick({
    required List<ItemDef> candidates,
    required double theta,
    Map<String, int> exposure = const {},
    Set<String> excludeItemIds = const {},
  }) {
    ItemDef? best;
    var bestScore = -1.0;
    for (final item in candidates) {
      if (excludeItemIds.contains(item.id)) continue;
      final score = engine.itemInformation(
        theta: theta,
        difficulty: item.difficulty,
        exposure: exposure[item.id] ?? 0,
      );
      if (score > bestScore) {
        bestScore = score;
        best = item;
      }
    }
    return best;
  }
}
