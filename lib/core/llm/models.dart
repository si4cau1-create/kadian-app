/// 与后端代理的所有数据契约。
///
/// 客户端只发「局部等级摘要 + 用户选中的文本 + 意图」，
/// 原始作答事件、语篇全文、账号身份都不出设备。
library;

class HintRequest {
  const HintRequest({
    required this.requestId,
    required this.itemId,
    required this.nodeId,
    required this.selectedText,
    required this.selectionKind,
    required this.intent,
    required this.hintLevel,
    required this.hintRequestCount,
    required this.subject,
    required this.learnerLevelSummary,
    this.question = '',
    this.options = const [],
    this.passageExcerpt = '',
    this.explainMode = false,
    this.outOfScope = false,
    this.answerRevealed = false,
    this.answerKeywords = const [],
    this.answerLabel = '',
  });

  final String requestId;
  final String itemId;
  final String nodeId;
  final String selectedText;
  final String selectionKind;
  final String intent;
  final int hintLevel;
  final int hintRequestCount;
  final String subject;
  final Map<String, dynamic> learnerLevelSummary;
  final String question;
  final List<String> options;
  final String passageExcerpt;
  final bool explainMode;
  final bool outOfScope;
  final bool answerRevealed;

  /// 答案关键词与正确选项原文：代理侧做一二级提示的防泄漏过滤需要
  final List<String> answerKeywords;
  final String answerLabel;

  Map<String, dynamic> toJson() => {
        'request_id': requestId,
        'item_id': itemId,
        'node_id': nodeId,
        'selected_text': selectedText,
        'selection_kind': selectionKind,
        'intent': intent,
        'hint_level': hintLevel,
        'hint_request_count': hintRequestCount,
        'subject': subject,
        'learner_level_summary': learnerLevelSummary,
        'question': question,
        'options': options,
        'passage_excerpt': passageExcerpt,
        'explain_mode': explainMode,
        'out_of_scope': outOfScope,
        'answer_revealed': answerRevealed,
        'answer_keywords': answerKeywords,
        'answer_label': answerLabel,
      };
}

class HintChunk {
  const HintChunk({
    required this.text,
    this.done = false,
    this.level,
    this.filtered = false,
    this.error,
    this.requestId = '',
  });

  final String text;
  final bool done;
  final int? level;
  final bool filtered;
  final String? error;
  final String requestId;

  bool get isError => error != null && error!.isNotEmpty;

  factory HintChunk.fromJson(Map<String, dynamic> json) => HintChunk(
        text: json['delta'] as String? ?? json['text'] as String? ?? '',
        done: json['done'] as bool? ?? false,
        level: (json['level'] as num?)?.toInt(),
        filtered: json['filtered'] as bool? ?? false,
        error: json['error'] as String?,
        requestId: json['request_id'] as String? ?? '',
      );
}

class DiagnoseRequest {
  const DiagnoseRequest({
    required this.learnerLevelSummary,
    required this.subject,
    required this.recentItemIds,
    this.count = 1,
  });

  final Map<String, dynamic> learnerLevelSummary;
  final String subject;
  final List<String> recentItemIds;
  final int count;

  Map<String, dynamic> toJson() => {
        'learner_level_summary': learnerLevelSummary,
        'subject': subject,
        'recent_item_ids': recentItemIds,
        'count': count,
      };
}

class DiagnoseResponse {
  const DiagnoseResponse({required this.itemIds, this.rationale = ''});

  final List<String> itemIds;
  final String rationale;

  factory DiagnoseResponse.fromJson(Map<String, dynamic> json) =>
      DiagnoseResponse(
        itemIds: (json['item_ids'] as List?)?.map((e) => '$e').toList() ??
            const [],
        rationale: json['rationale'] as String? ?? '',
      );
}

class AttributeRequest {
  const AttributeRequest({
    required this.itemId,
    required this.nodeId,
    required this.selectedText,
    required this.question,
    this.studentAnswer = '',
  });

  final String itemId;
  final String nodeId;
  final String selectedText;
  final String question;
  final String studentAnswer;

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'node_id': nodeId,
        'selected_text': selectedText,
        'question': question,
        'student_answer': studentAnswer,
      };
}

/// 归因官输出：错因标签，用于卡点库分组（不做等级计算）
class Attribution {
  const Attribution({
    required this.tags,
    required this.summary,
    this.confidence = 0,
  });

  final List<String> tags;
  final String summary;
  final double confidence;

  factory Attribution.fromJson(Map<String, dynamic> json) => Attribution(
        tags: (json['tags'] as List?)?.map((e) => '$e').toList() ?? const [],
        summary: json['summary'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      );
}

class ProxyConfig {
  const ProxyConfig({
    required this.baseUrl,
    this.deviceToken = '',
    this.byokBaseUrl = '',
    this.byokApiKey = '',
    this.byokModel = '',
    this.timeoutSeconds = 45,
  });

  final String baseUrl;
  final String deviceToken;

  /// BYOK：用户自带 Key 直连（默认关闭，设置里明确风险提示）
  final String byokBaseUrl;
  final String byokApiKey;
  final String byokModel;
  final int timeoutSeconds;

  bool get byokEnabled =>
      byokBaseUrl.isNotEmpty && byokApiKey.isNotEmpty && byokModel.isNotEmpty;

  ProxyConfig copyWith({
    String? baseUrl,
    String? deviceToken,
    String? byokBaseUrl,
    String? byokApiKey,
    String? byokModel,
    int? timeoutSeconds,
  }) =>
      ProxyConfig(
        baseUrl: baseUrl ?? this.baseUrl,
        deviceToken: deviceToken ?? this.deviceToken,
        byokBaseUrl: byokBaseUrl ?? this.byokBaseUrl,
        byokApiKey: byokApiKey ?? this.byokApiKey,
        byokModel: byokModel ?? this.byokModel,
        timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      );
}

class ProxyException implements Exception {
  ProxyException(this.message, {this.statusCode, this.offline = false});

  final String message;
  final int? statusCode;
  final bool offline;

  @override
  String toString() => 'ProxyException($statusCode): $message';
}
