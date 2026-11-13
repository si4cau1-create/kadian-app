/// 内容包数据模型：知识图谱、题目、词表、成就定义、校准参数。
///
/// 内容包与算法严格分离：这里只描述「学什么/考什么/奖励什么」，
/// 不出现任何 IRT/BKT 计算逻辑，算法变更随客户端版本走。
library;

import '../subject/subject.dart';

class ContentManifest {
  const ContentManifest({
    required this.packId,
    required this.version,
    required this.minAppVersion,
    required this.engineVersion,
    required this.createdAt,
    required this.checksum,
    this.subject = '',
    this.fileHashes = const {},
    this.notes = '',
  });

  final String packId;
  final String version;
  final String minAppVersion;
  final String engineVersion;
  final String createdAt;
  final String checksum;

  /// 该内容包所属学科（`japanese` / `english`）。旧版混合包为空。
  final String subject;
  final Map<String, String> fileHashes;
  final String notes;

  factory ContentManifest.fromJson(Map<String, dynamic> json) {
    final rawHashes = json['fileHashes'];
    final hashes = <String, String>{};
    if (rawHashes is Map) {
      rawHashes.forEach((k, v) => hashes['$k'] = '$v');
    }
    return ContentManifest(
      packId: json['packId'] as String? ?? 'unknown',
      version: json['version'] as String? ?? '0.0.0',
      minAppVersion: json['minAppVersion'] as String? ?? '0.0.0',
      engineVersion: json['engineVersion'] as String? ?? '1.0.0',
      createdAt: json['createdAt'] as String? ?? '',
      checksum: json['checksum'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      fileHashes: hashes,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'packId': packId,
        'version': version,
        'minAppVersion': minAppVersion,
        'engineVersion': engineVersion,
        'createdAt': createdAt,
        'checksum': checksum,
        'subject': subject,
        'fileHashes': fileHashes,
        'notes': notes,
      };
}

class SubjectDef {
  const SubjectDef({
    required this.id,
    required this.title,
    this.beta = false,
    this.trackIds = const [],
  });

  final String id;
  final String title;
  final bool beta;
  final List<String> trackIds;

  factory SubjectDef.fromJson(Map<String, dynamic> json) => SubjectDef(
        id: json['id'] as String,
        title: json['title'] as String? ?? json['id'] as String,
        beta: json['beta'] as bool? ?? false,
        trackIds: (json['trackIds'] as List?)?.map((e) => '$e').toList() ??
            const [],
      );
}

class TrackDef {
  const TrackDef({
    required this.id,
    required this.subjectId,
    required this.title,
    this.clusterIds = const [],
  });

  final String id;
  final String subjectId;
  final String title;
  final List<String> clusterIds;

  factory TrackDef.fromJson(Map<String, dynamic> json) => TrackDef(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String? ?? '',
        title: json['title'] as String? ?? json['id'] as String,
        clusterIds: (json['clusterIds'] as List?)?.map((e) => '$e').toList() ??
            const [],
      );
}

class ClusterDef {
  const ClusterDef({
    required this.id,
    required this.subjectId,
    required this.title,
    this.nodeIds = const [],
    this.trackId = '',
  });

  final String id;
  final String subjectId;
  final String title;
  final List<String> nodeIds;
  final String trackId;

  ClusterDef copyWith({List<String>? nodeIds}) => ClusterDef(
        id: id,
        subjectId: subjectId,
        title: title,
        nodeIds: nodeIds ?? this.nodeIds,
        trackId: trackId,
      );

  factory ClusterDef.fromJson(Map<String, dynamic> json) => ClusterDef(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String? ?? '',
        title: json['title'] as String? ?? json['id'] as String,
        nodeIds:
            (json['nodeIds'] as List?)?.map((e) => '$e').toList() ?? const [],
        trackId: json['trackId'] as String? ?? '',
      );
}

class NodeDef {
  const NodeDef({
    required this.id,
    required this.clusterId,
    required this.title,
    this.prereqIds = const [],
    this.weight = 1.0,
    this.tags = const [],
    this.gloss = '',
  });

  final String id;
  final String clusterId;
  final String title;
  final List<String> prereqIds;
  final double weight;
  final List<String> tags;
  final String gloss;

  factory NodeDef.fromJson(Map<String, dynamic> json) => NodeDef(
        id: json['id'] as String,
        clusterId: json['clusterId'] as String? ?? '',
        title: json['title'] as String? ?? json['id'] as String,
        prereqIds:
            (json['prereqIds'] as List?)?.map((e) => '$e').toList() ?? const [],
        weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
        tags: (json['tags'] as List?)?.map((e) => '$e').toList() ?? const [],
        gloss: json['gloss'] as String? ?? '',
      );
}

class PassageDef {
  const PassageDef({
    required this.id,
    required this.title,
    required this.text,
    this.subjectId = 'ja',
    this.lang = 'ja',
    this.source = '',
  });

  final String id;
  final String title;
  final String text;
  final String subjectId;
  final String lang;
  final String source;

  factory PassageDef.fromJson(Map<String, dynamic> json) => PassageDef(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        text: json['text'] as String? ?? '',
        subjectId: json['subjectId'] as String? ?? 'ja',
        lang: json['lang'] as String? ?? 'ja',
        source: json['source'] as String? ?? '',
      );
}

enum ItemType { choice, fill, short }

class ItemDef {
  const ItemDef({
    required this.id,
    required this.nodeId,
    required this.stem,
    this.type = ItemType.choice,
    this.options = const [],
    this.answerIndex = 0,
    this.answerText = '',
    this.difficulty = 0,
    this.discrimination = 1.0,
    this.passageId = '',
    this.answerKeywords = const [],
    this.explain = '',
    this.expectedSeconds = 60,
    this.tags = const [],
  });

  final String id;
  final String nodeId;
  final String stem;
  final ItemType type;
  final List<String> options;
  final int answerIndex;
  final String answerText;
  final double difficulty;
  final double discrimination;
  final String passageId;

  /// 一级提示的禁词：出现在提示里即视为答案泄露
  final List<String> answerKeywords;
  final String explain;
  final int expectedSeconds;
  final List<String> tags;

  String get answerLabel =>
      type == ItemType.choice
          ? (answerIndex >= 0 && answerIndex < options.length
              ? options[answerIndex]
              : '')
          : answerText;

  factory ItemDef.fromJson(Map<String, dynamic> json) => ItemDef(
        id: json['id'] as String,
        nodeId: json['nodeId'] as String? ?? '',
        stem: json['stem'] as String? ?? '',
        type: switch (json['type'] as String?) {
          'fill' => ItemType.fill,
          'short' => ItemType.short,
          _ => ItemType.choice,
        },
        options:
            (json['options'] as List?)?.map((e) => '$e').toList() ?? const [],
        answerIndex: (json['answerIndex'] as num?)?.toInt() ?? 0,
        answerText: json['answerText'] as String? ?? '',
        difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0,
        discrimination: (json['discrimination'] as num?)?.toDouble() ?? 1.0,
        passageId: json['passageId'] as String? ?? '',
        answerKeywords: (json['answerKeywords'] as List?)
                ?.map((e) => '$e')
                .toList() ??
            const [],
        explain: json['explain'] as String? ?? '',
        expectedSeconds: (json['expectedSeconds'] as num?)?.toInt() ?? 60,
        tags: (json['tags'] as List?)?.map((e) => '$e').toList() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nodeId': nodeId,
        'stem': stem,
        'type': type.name,
        'options': options,
        'answerIndex': answerIndex,
        'answerText': answerText,
        'difficulty': difficulty,
        'discrimination': discrimination,
        'passageId': passageId,
        'answerKeywords': answerKeywords,
        'explain': explain,
        'expectedSeconds': expectedSeconds,
        'tags': tags,
      };
}

class VocabDef {
  const VocabDef({
    required this.id,
    required this.lemma,
    required this.gloss,
    this.reading = '',
    this.pos = '',
    this.clusterId = '',
    this.dimension = 'reading',
    this.example = '',
    this.tags = const [],
  });

  final String id;
  final String lemma;
  final String reading;
  final String gloss;
  final String pos;
  final String clusterId;

  /// 词簇维度：recognition / reading / listening / writing / speaking
  final String dimension;
  final String example;
  final List<String> tags;

  factory VocabDef.fromJson(Map<String, dynamic> json) => VocabDef(
        id: json['id'] as String,
        lemma: json['lemma'] as String,
        gloss: json['gloss'] as String? ?? '',
        reading: json['reading'] as String? ?? '',
        pos: json['pos'] as String? ?? '',
        clusterId: json['clusterId'] as String? ?? '',
        dimension: json['dimension'] as String? ?? 'reading',
        example: json['example'] as String? ?? '',
        tags: (json['tags'] as List?)?.map((e) => '$e').toList() ?? const [],
      );
}

class AchievementStage {
  const AchievementStage({
    required this.tier,
    required this.target,
    this.xp = 0,
    this.label = '',
  });

  /// bronze / silver / gold
  final String tier;
  final double target;
  final int xp;
  final String label;

  factory AchievementStage.fromJson(Map<String, dynamic> json) =>
      AchievementStage(
        tier: json['tier'] as String? ?? 'bronze',
        target: (json['target'] as num?)?.toDouble() ?? 1,
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        label: json['label'] as String? ?? '',
      );
}

class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.title,
    required this.description,
    required this.metric,
    required this.stages,
    this.subjectId = '',
    this.independentOnly = true,
    this.xpEligible = false,
    this.icon = '●',
  });

  /// 学科命名空间化的成就 id，形如 `japanese.first_step`
  final String id;
  final String title;
  final String description;

  /// 归属学科（`japanese` / `english`）。成就墙只展示当前学科的成就。
  final String subjectId;

  /// 结算指标，见 AchievementMetric
  final String metric;
  final List<AchievementStage> stages;
  final bool independentOnly;

  /// XP 只奖励诊断行为，非诊断指标即便达成也给 0
  final bool xpEligible;
  final String icon;

  factory AchievementDef.fromJson(Map<String, dynamic> json) => AchievementDef(
        id: json['id'] as String,
        title: json['title'] as String? ?? json['id'] as String,
        description: json['description'] as String? ?? '',
        subjectId: json['subjectId'] as String? ?? '',
        metric: json['metric'] as String? ?? '',
        stages: (json['stages'] as List?)
                ?.whereType<Map>()
                .map((e) => AchievementStage.fromJson(e.cast<String, dynamic>()))
                .toList() ??
            const [],
        independentOnly: json['independentOnly'] as bool? ?? true,
        xpEligible: json['xpEligible'] as bool? ?? false,
        icon: json['icon'] as String? ?? '●',
      );
}

/// 内容包内存形态
class ContentPack {
  ContentPack({
    required this.manifest,
    required this.subjects,
    required this.tracks,
    required this.clusters,
    required this.nodes,
    required this.passages,
    required this.items,
    required this.vocab,
    required this.achievements,
    required this.calibrationJson,
    this.sourcePath = '',
  });

  final ContentManifest manifest;
  final List<SubjectDef> subjects;
  final List<TrackDef> tracks;
  final List<ClusterDef> clusters;
  final List<NodeDef> nodes;
  final List<PassageDef> passages;
  final List<ItemDef> items;
  final List<VocabDef> vocab;
  final List<AchievementDef> achievements;
  final Map<String, dynamic> calibrationJson;
  final String sourcePath;

  late final Map<String, NodeDef> nodeById = {for (final n in nodes) n.id: n};
  late final Map<String, ClusterDef> clusterById = {
    for (final c in clusters) c.id: c
  };
  late final Map<String, ItemDef> itemById = {for (final i in items) i.id: i};
  late final Map<String, PassageDef> passageById = {
    for (final p in passages) p.id: p
  };
  late final Map<String, VocabDef> vocabById = {for (final v in vocab) v.id: v};
  late final Map<String, AchievementDef> achievementById = {
    for (final a in achievements) a.id: a
  };

  ContentManifest get manifestInfo => manifest;

  /// 该内容包所属学科。优先读 manifest.subject，旧包回落到 subjects[0].id。
  Subject? get subject {
    final declared = Subject.tryParse(manifest.subject);
    if (declared != null) return declared;
    if (subjects.isEmpty) return null;
    return Subject.tryParse(subjects.first.id);
  }

  /// 不属于 [expected] 学科的节点（正常应为空）
  List<String> foreignNodeIds(Subject expected) => [
        for (final node in nodes)
          if (!expected.ownsNode(node.id)) node.id,
      ];

  /// 指向外学科节点的题目（正常应为空）
  List<String> foreignItemIds(Subject expected) => [
        for (final item in items)
          if (!expected.ownsNode(item.nodeId)) item.id,
      ];

  /// 不属于 [expected] 学科的簇（正常应为空）
  List<String> foreignClusterIds(Subject expected) => [
        for (final cluster in clusters)
          if (Subject.tryParse(cluster.subjectId) != expected) cluster.id,
      ];

  /// 归属其他学科的成就（正常应为空）
  List<String> foreignAchievementIds(Subject expected) => [
        for (final def in achievements)
          if (def.subjectId.isNotEmpty &&
              Subject.tryParse(def.subjectId) != expected)
            def.id,
      ];

  List<NodeDef> nodesOfCluster(String clusterId) =>
      nodes.where((n) => n.clusterId == clusterId).toList();

  List<ItemDef> itemsOfNode(String nodeId) =>
      items.where((i) => i.nodeId == nodeId).toList();

  List<ItemDef> itemsOfPassage(String passageId) =>
      items.where((i) => i.passageId == passageId).toList();

  /// 前置节点闭包（用于「卡住了就回退」）
  List<NodeDef> prereqChain(String nodeId, {int depth = 3}) {
    final result = <NodeDef>[];
    final seen = <String>{nodeId};
    var frontier = <String>[nodeId];
    for (var d = 0; d < depth; d++) {
      final next = <String>[];
      for (final id in frontier) {
        final node = nodeById[id];
        if (node == null) continue;
        for (final p in node.prereqIds) {
          if (seen.add(p)) {
            final pn = nodeById[p];
            if (pn != null) {
              result.add(pn);
              next.add(p);
            }
          }
        }
      }
      if (next.isEmpty) break;
      frontier = next;
    }
    return result;
  }
}
