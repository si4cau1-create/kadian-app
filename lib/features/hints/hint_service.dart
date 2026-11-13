import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import '../../core/llm/models.dart';
import '../../core/llm/proxy_client.dart';
import '../../core/selection/selection_intent.dart';
import '../../core/services/practice_service.dart';
import '../../core/content_pack/models.dart';

class HintStreamEvent {
  const HintStreamEvent({
    this.text = '',
    this.replace = false,
    this.done = false,
    this.error,
    this.filtered = false,
    this.offline = false,
    this.level = 0,
  });

  final String text;

  /// true 表示用 text 覆盖已有内容（用于最终防泄漏替换）
  final bool replace;
  final bool done;
  final String? error;
  final bool filtered;
  final bool offline;
  final int level;
}

/// 攻略服务：意图菜单 → 代理流式请求 → 客户端二次防泄漏 → hint_events 落库。
///
/// 离线时不做任何假装：直接告诉用户攻略不可用，本地做题/复习/等级照常。
class HintService {
  HintService({
    required this.practice,
    required this.llm,
    required this.pack,
    required this.policy,
  });

  final PracticeService practice;
  final LlmProxyClient llm;
  final ContentPack pack;
  final HintLevelPolicy policy;
  final _uuid = const Uuid();
  final _guard = const HintLeakGuard();

  Future<HintStreamEvent> offlineEvent({
    required AttemptRow attempt,
    required String selectedText,
    required SelectionKind kind,
    required int level,
    required bool explainMode,
  }) async {
    await practice.recordHintRequest(
      attempt: attempt,
      selectedText: selectedText,
      selectionType: kind.name,
      intent: 'offline',
      level: level,
      answerRevealed: false,
      outOfScope: false,
      explainMode: explainMode,
      filtered: false,
      servedOffline: true,
    );
    return HintStreamEvent(
      error: '当前离线：攻略需要联网。做题、复习、等级看板不受影响，先自己啃一下。',
      offline: true,
      level: level,
      done: true,
    );
  }

  Stream<HintStreamEvent> request({
    required ItemDef item,
    required AttemptRow attempt,
    required String selectedText,
    required SelectionKind kind,
    required HintIntent intent,
    required int level,
    required int requestCount,
    required Map<String, dynamic> learnerSummary,
    required bool explainMode,
    required bool answerRevealed,
    required String passageExcerpt,
  }) async* {
    final started = DateTime.now();

    if (!llm.isConfigured) {
      yield await offlineEvent(
        attempt: attempt,
        selectedText: selectedText,
        kind: kind,
        level: level,
        explainMode: explainMode,
      );
      return;
    }

    final request = HintRequest(
      requestId: _uuid.v4(),
      itemId: item.id,
      nodeId: item.nodeId,
      selectedText: selectedText,
      selectionKind: kind.name,
      intent: intent.id,
      hintLevel: level,
      hintRequestCount: requestCount,
      subject: _subjectOf(item),
      learnerLevelSummary: learnerSummary,
      question: item.stem,
      options: item.options,
      passageExcerpt: passageExcerpt,
      explainMode: explainMode,
      outOfScope: false,
      answerRevealed: answerRevealed,
      answerKeywords: item.answerKeywords,
      answerLabel: item.answerLabel,
    );

    final buffer = StringBuffer();
    var filteredAny = false;
    var servedOffline = false;

    try {
      await for (final chunk in llm.streamHint(request)) {
        if (chunk.isError) {
          yield HintStreamEvent(
            error: chunk.error,
            level: level,
            done: true,
            offline: (chunk.error ?? '').contains('离线'),
          );
          break;
        }
        if (chunk.filtered) filteredAny = true;
        if (chunk.text.isNotEmpty) {
          buffer.write(chunk.text);
          final live = policy.mustHideAnswer(level)
              ? _guard.maskLive(
                  buffer.toString(),
                  item.answerKeywords,
                  item.answerLabel,
                )
              : buffer.toString();
          yield HintStreamEvent(
            text: live,
            replace: true,
            level: level,
          );
        }
        if (chunk.done) {
          final verdict = _guard.check(
            text: buffer.toString(),
            hintLevel: level,
            answerKeywords: item.answerKeywords,
            answerLabel: item.answerLabel,
          );
          if (!verdict.safe) {
            filteredAny = true;
            yield HintStreamEvent(
              text: verdict.text,
              replace: true,
              done: true,
              filtered: true,
              level: level,
            );
          } else {
            yield HintStreamEvent(
              text: buffer.toString(),
              replace: true,
              done: true,
              level: level,
            );
          }
          break;
        }
      }
    } on ProxyException catch (e) {
      servedOffline = e.offline;
      await practice.recordHintRequest(
        attempt: attempt,
        selectedText: selectedText,
        selectionType: kind.name,
        intent: intent.id,
        level: level,
        answerRevealed: answerRevealed,
        outOfScope: false,
        explainMode: explainMode,
        filtered: false,
        servedOffline: e.offline,
        latencyMs: DateTime.now().difference(started).inMilliseconds,
      );
      yield HintStreamEvent(
        error: e.offline ? '离线模式：攻略暂时不可用。' : e.message,
        offline: e.offline,
        done: true,
        level: level,
      );
      return;
    }

    if (!servedOffline) {
      await practice.recordHintRequest(
        attempt: attempt,
        selectedText: selectedText,
        selectionType: kind.name,
        intent: intent.id,
        level: level,
        answerRevealed: answerRevealed,
        outOfScope: false,
        explainMode: explainMode,
        filtered: filteredAny,
        servedOffline: false,
        latencyMs: DateTime.now().difference(started).inMilliseconds,
      );
    }
  }

  String _subjectOf(ItemDef item) {
    final node = pack.nodeById[item.nodeId];
    if (node == null) return 'ja';
    final cluster = pack.clusterById[node.clusterId];
    return cluster?.subjectId ?? 'ja';
  }
}
