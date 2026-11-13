import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../calibration/engine.dart';
import '../calibration/level.dart';
import '../calibration/params.dart';
import '../content_pack/models.dart';
import '../db/database.dart';
import '../db/tables.dart';
import '../subject/subject.dart';

/// 做题闭环的本地服务：开题 → 作答 → 证据落库 → 校准 → 等级聚合。
///
/// 全程不联网。LLM 只负责讲解，不参与任何等级计算。
///
/// 一个实例只服务一个学科：内容包、数据库、等级、成就都在该学科内闭环。
/// 对外方法接受可选的 `subject` 参数，一旦与档案不一致就抛
/// [SubjectMismatchException]，绝不静默切换。
class PracticeService {
  PracticeService({
    required this.db,
    required this.pack,
    required this.engine,
    required this.aggregator,
    required this.subject,
    this.learnerId = 'local',
  });

  final AppDatabase db;
  final ContentPack pack;
  final CalibrationEngine engine;
  final LevelAggregator aggregator;

  /// 档案绑定的学科
  final Subject subject;
  final String learnerId;
  final _uuid = const Uuid();

  CalibrationParams get params => engine.params;

  /// 校验调用方传入的学科；不一致直接抛 subject_mismatch
  void ensureSubject(Object? requested, String operation) {
    requireSameSubject(
      current: subject,
      requested: requested,
      operation: operation,
    );
  }

  /// 校验某个节点归属本学科，否则抛错（防止拿外语节点来查）
  void ensureOwnsNode(String nodeId, String operation) {
    if (!subject.ownsNode(nodeId)) {
      throw SubjectMismatchException(
        expected: subject.id,
        actual: '${subject.other.id}:$nodeId',
        operation: operation,
      );
    }
  }

  // ---------------- 开题 ----------------

  Future<AttemptRow> startAttempt(ItemDef item, {Object? subject}) async {
    ensureSubject(subject, 'start_attempt');
    ensureOwnsNode(item.nodeId, 'start_attempt');
    final open = await db.openAttempt(item.id);
    if (open != null) return open;
    final id = _uuid.v4();
    await db.insertAttempt(AttemptsCompanion.insert(
      id: id,
      itemId: item.id,
      nodeId: item.nodeId,
      mode: AttemptMode.independent,
      startedAt: DateTime.now(),
    ));
    final row = await db.openAttempt(item.id);
    if (row != null) return row;
    throw StateError('作答会话创建失败：${item.id}');
  }

  /// 记一次攻略请求：写 hint_events，并推进 attempt 的 assisted 轨迹。
  Future<int> recordHintRequest({
    required AttemptRow attempt,
    required String selectedText,
    required String selectionType,
    required String intent,
    required int level,
    required bool answerRevealed,
    required bool outOfScope,
    required bool explainMode,
    required bool filtered,
    required bool servedOffline,
    int latencyMs = 0,
    Object? subject,
  }) async {
    ensureSubject(subject, 'hint');
    ensureOwnsNode(attempt.nodeId, 'hint');
    await db.insertHintEvent(HintEventsCompanion.insert(
      id: _uuid.v4(),
      itemId: attempt.itemId,
      nodeId: attempt.nodeId,
      selectedText: selectedText,
      selectionType: selectionType,
      intent: intent,
      hintLevel: Value(level),
      answerRevealed: Value(answerRevealed),
      outOfScope: Value(outOfScope),
      explainMode: Value(explainMode),
      filtered: Value(filtered),
      servedOffline: Value(servedOffline),
      latencyMs: Value(latencyMs),
      createdAt: DateTime.now(),
    ));

    final count = await db.hintCountForItem(attempt.itemId);
    final mode = explainMode
        ? AttemptMode.explain
        : (count > 0 ? AttemptMode.assisted : AttemptMode.independent);
    await db.updateAttempt(
      attempt.id,
      AttemptsCompanion(
        hintLevel: Value(level),
        hintRequestCount: Value(count),
        assisted: Value(count > 0),
        answerRevealed: Value(answerRevealed),
        mode: Value(mode),
      ),
    );
    return count;
  }

  Future<int> hintCount(String itemId) => db.hintCountForItem(itemId);

  // ---------------- 作答 ----------------

  Future<AttemptResult> submitAttempt({
    required ItemDef item,
    required AttemptRow attempt,
    required bool correct,
    required String selectedAnswer,
    required int elapsedSeconds,
    required int hintLevel,
    required int hintRequestCount,
    required bool answerRevealed,
    EvidenceKind kind = EvidenceKind.attempt,
    Object? subject,
  }) async {
    ensureSubject(subject, 'submit_attempt');
    ensureOwnsNode(item.nodeId, 'submit_attempt');
    final now = DateTime.now();
    final nodeState = await db.nodeState(item.nodeId);
    final itemRow = await db.itemDifficultyFor(item.id);

    final snapshot = NodeSnapshot(
      nodeId: item.nodeId,
      theta: nodeState?.theta ?? 0,
      mastery: nodeState?.mastery,
      attempts: nodeState?.attempts ?? 0,
      lastSeenAt: nodeState?.lastSeenAt,
    );
    final itemSnapshot = ItemSnapshot(
      itemId: item.id,
      difficulty: itemRow?.difficulty ?? item.difficulty,
      discrimination: itemRow?.discrimination ?? item.discrimination,
    );

    final outcome = engine.apply(
      node: snapshot,
      item: itemSnapshot,
      evidence: EvidenceInput(
        score: correct ? 1.0 : 0.0,
        independent: hintRequestCount == 0 && !answerRevealed,
        hintLevel: hintLevel,
        hintRequestCount: hintRequestCount,
        at: now,
        elapsedSeconds: elapsedSeconds.toDouble(),
        expectedSeconds: item.expectedSeconds.toDouble(),
      ),
      now: now,
    );

    final evidenceId = _uuid.v4();
    await db.insertEvidence(EvidenceEventsCompanion.insert(
      id: evidenceId,
      learnerId: Value(learnerId),
      nodeId: item.nodeId,
      itemId: Value(item.id),
      kind: kind,
      score: correct ? 1.0 : 0.0,
      effectiveScore: Value(outcome.effectiveScore),
      predicted: Value(outcome.predicted),
      independent: Value(outcome.countsAsIndependent),
      hintLevel: Value(hintLevel),
      hintRequestCount: Value(hintRequestCount),
      explainMode: Value(outcome.explainMode),
      difficulty: Value(itemSnapshot.difficulty),
      thetaAfter: Value(outcome.theta),
      masteryAfter: Value(outcome.mastery),
      elapsedSeconds: Value(elapsedSeconds),
      payload: Value(jsonEncode({
        'selected': selectedAnswer,
        'predicted': double.parse(outcome.predicted.toStringAsFixed(3)),
        'effective': double.parse(outcome.effectiveScore.toStringAsFixed(3)),
        'explain': outcome.explainMode,
      })),
      createdAt: now,
    ));

    final prevAttempts = nodeState?.attempts ?? 0;
    final prevIndependent = nodeState?.independentAttempts ?? 0;
    final prevIndependentCorrect = nodeState?.independentCorrect ?? 0;

    await db.upsertNodeState(NodeStatesCompanion.insert(
      nodeId: item.nodeId,
      learnerId: Value(learnerId),
      mastery: Value(outcome.mastery),
      theta: Value(outcome.theta),
      attempts: Value(prevAttempts + 1),
      independentAttempts: Value(
          prevIndependent + (outcome.countsAsIndependent ? 1 : 0)),
      independentCorrect: Value(prevIndependentCorrect +
          (outcome.countsAsIndependent && correct ? 1 : 0)),
      assistedAttempts: Value((nodeState?.assistedAttempts ?? 0) +
          (!outcome.countsAsIndependent && !outcome.explainMode ? 1 : 0)),
      explainAttempts: Value((nodeState?.explainAttempts ?? 0) +
          (outcome.explainMode ? 1 : 0)),
      streak: Value(outcome.countsAsIndependent && correct
          ? (nodeState?.streak ?? 0) + 1
          : 0),
      engineVersion: Value(params.engineVersion),
      lastSeenAt: Value(now),
      updatedAt: now,
    ));

    await db.upsertItemDifficulty(ItemDifficultyCompanion.insert(
      itemId: item.id,
      nodeId: item.nodeId,
      difficulty: Value(outcome.itemDifficulty),
      discrimination: Value(itemSnapshot.discrimination),
      exposure: Value((itemRow?.exposure ?? 0) + 1),
      correctCount:
          Value((itemRow?.correctCount ?? 0) + (correct ? 1 : 0)),
      updatedAt: now,
    ));

    await db.updateAttempt(
      attempt.id,
      AttemptsCompanion(
        correct: Value(correct),
        selectedAnswer: Value(selectedAnswer),
        elapsedSeconds: Value(elapsedSeconds),
        hintLevel: Value(hintLevel),
        hintRequestCount: Value(hintRequestCount),
        assisted: Value(hintRequestCount > 0),
        answerRevealed: Value(answerRevealed),
        mode: Value(outcome.explainMode
            ? AttemptMode.explain
            : (hintRequestCount > 0
                ? AttemptMode.assisted
                : AttemptMode.independent)),
        finishedAt: Value(now),
      ),
    );

    final today = DateTime(now.year, now.month, now.day);
    await db.bumpDaily(
      dayStart: today,
      evidence: 1,
      independent: outcome.countsAsIndependent ? 1 : 0,
      hints: hintRequestCount > 0 ? 1 : 0,
      minutes: (elapsedSeconds / 60).ceil(),
    );

    return AttemptResult(
      outcome: outcome,
      correct: correct,
      explain: item.explain,
      evidenceId: evidenceId,
      answerLabel: item.answerLabel,
    );
  }

  // ---------------- 复习 ----------------

  /// 复习证据：只进 evidence_events（kind=review），不掺进节点能力估计。
  Future<void> recordVocabReview({
    required VocabStateRow word,
    required String rating,
    required int quality,
    Object? subject,
  }) async {
    ensureSubject(subject, 'vocab_review');
    if (word.clusterId.isNotEmpty) {
      ensureOwnsNode(word.clusterId, 'vocab_review');
    }
    final now = DateTime.now();
    final score = quality >= 3 ? 1.0 : 0.0;
    await db.insertEvidence(EvidenceEventsCompanion.insert(
      id: _uuid.v4(),
      learnerId: Value(learnerId),
      nodeId: word.clusterId.isEmpty
          ? '${this.subject.packPrefix}.vocab.adhoc'
          : word.clusterId,
      itemId: Value(word.wordId),
      kind: EvidenceKind.review,
      score: score,
      effectiveScore: Value(score),
      independent: const Value(true),
      payload: Value(jsonEncode({
        'rating': rating,
        'box': word.box,
        'subject': this.subject.id,
      })),
      createdAt: now,
    ));
    await db.bumpDaily(
      dayStart: DateTime(now.year, now.month, now.day),
      evidence: 1,
      reviews: 1,
    );
  }

  // ---------------- 等级 ----------------

  Future<LevelSummary> levelSummary({DateTime? now, Object? subject}) async {
    ensureSubject(subject, 'get_level');
    final states = await db.allNodeStates();
    final stats = await db.evidenceStats();
    final views = <NodeLevelView>[];
    for (final row in states) {
      final node = pack.nodeById[row.nodeId];
      final band = params.bandFor(row.mastery);
      views.add(NodeLevelView(
        nodeId: row.nodeId,
        title: node?.title ?? row.nodeId,
        clusterId: node?.clusterId ?? '',
        mastery: row.mastery,
        level: band.level,
        levelLabel: band.label,
        theta: row.theta,
        attempts: row.attempts,
        independentAttempts: row.independentAttempts,
        independentCorrect: row.independentCorrect,
        lastSeenAt: row.lastSeenAt,
      ));
    }
    // 没碰过的节点也要出现在看板上（等级 0），否则看板会「缺块」
    final touched = views.map((e) => e.nodeId).toSet();
    for (final node in pack.nodes) {
      if (touched.contains(node.id)) continue;
      views.add(NodeLevelView(
        nodeId: node.id,
        title: node.title,
        clusterId: node.clusterId,
        mastery: 0,
        level: 0,
        levelLabel: params.bandFor(0).label,
        theta: 0,
        attempts: 0,
        independentAttempts: 0,
        independentCorrect: 0,
      ));
    }

    return aggregator.aggregate(
      pack: pack,
      nodes: views,
      evidenceCount: stats.total,
      independentCount: stats.independent,
      independentCorrect: stats.independentCorrect,
      engineVersion: params.engineVersion,
      now: now,
    );
  }

  /// 诊断选题：本地算法（信息量最大 + 难度带贴合），LLM 只做解释性补充
  Future<ItemDef?> nextDiagnosticItem({
    required Set<String> excludeItemIds,
    String? clusterId,
    Object? subject,
  }) async {
    ensureSubject(subject, 'diagnose_next');
    final states = await db.allNodeStates();
    final theta = states.isEmpty
        ? 0.0
        : states.map((e) => e.theta).reduce((a, b) => a + b) / states.length;
    final difficulties = await db.allItemDifficulties();
    final exposure = {for (final d in difficulties) d.itemId: d.exposure};

    // 内容包已按学科拆分，这里是防御层：非本学科节点一律不进候选池
    final ownItems = [
      for (final item in pack.items)
        if (this.subject.ownsNode(item.nodeId)) item,
    ];
    if (ownItems.isEmpty) return null;

    var pool = ownItems;
    if (clusterId != null) {
      final nodeIds = pack
          .nodesOfCluster(clusterId)
          .where((n) => this.subject.ownsNode(n.id))
          .map((e) => e.id)
          .toSet();
      pool = ownItems.where((i) => nodeIds.contains(i.nodeId)).toList();
    }
    if (pool.isEmpty) pool = ownItems;

    return NextItemSelector(engine).pick(
      candidates: pool,
      theta: theta,
      exposure: exposure,
      excludeItemIds: excludeItemIds,
    );
  }

  /// 卡住了就回退：返回掌握度不足的前置节点。
  ///
  /// 只在本学科图谱内回退，跨学科前置一律剔除——这是规格里明确禁止的。
  Future<List<NodeDef>> prerequisiteFallback(
    String nodeId, {
    Object? subject,
  }) async {
    ensureSubject(subject, 'prerequisite_fallback');
    ensureOwnsNode(nodeId, 'prerequisite_fallback');
    final chain = pack
        .prereqChain(nodeId)
        .where((n) => this.subject.ownsNode(n.id))
        .toList();
    final states = {for (final s in await db.allNodeStates()) s.nodeId: s};
    return chain
        .where((n) => (states[n.id]?.mastery ?? 0) < 0.38)
        .toList();
  }

  /// 给 LLM 的等级摘要：只含当前学科，且不含原始作答事件。
  ///
  /// `scope` 字段显式声明学科边界，代理侧据此拒绝跨学科引用。
  Future<Map<String, dynamic>> summaryForLlm({DateTime? now}) async {
    final level = await levelSummary(now: now);
    return {
      'subject': subject.id,
      'subjectLabel': subject.label,
      'scope': '${subject.id}-only',
      'overallLevel': level.overallLevel,
      'overallLabel': level.overallLabel,
      'overallMastery': double.parse(level.overallMastery.toStringAsFixed(3)),
      'evidenceCount': level.evidenceCount,
      'independentRatio':
          double.parse(level.independentRatio.toStringAsFixed(3)),
      'clusters': [
        for (final cluster in level.clusters)
          {
            'id': cluster.clusterId,
            'title': cluster.title,
            'level': cluster.level,
            'levelLabel': cluster.levelLabel,
          },
      ],
      'weakNodes': level.weakNodeIds.take(6).toList(),
      'engineVersion': level.engineVersion,
    };
  }
}

class AttemptResult {
  const AttemptResult({
    required this.outcome,
    required this.correct,
    required this.explain,
    required this.evidenceId,
    required this.answerLabel,
  });

  final CalibrationOutcome outcome;
  final bool correct;
  final String explain;
  final String evidenceId;
  final String answerLabel;
}
