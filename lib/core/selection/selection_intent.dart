import 'dart:convert';

/// 长按选中的文本类型：决定意图菜单给哪些项
enum SelectionKind { word, phrase, sentence, paragraph, option, stem }

/// 意图：一级菜单就是这 5 个，不搞二级藏猫猫
enum HintIntent {
  meaning('meaning', '什么意思', '释义与用法'),
  grammar('grammar', '语法点', '这里是什么语法'),
  translate('translate', '翻译', '整句翻译'),
  approach('approach', '解题思路', '该往哪想'),
  contrast('contrast', '辨析', '和相近的有什么区别');

  const HintIntent(this.id, this.label, this.description);

  final String id;
  final String label;
  final String description;

  static HintIntent? fromId(String? id) {
    for (final v in HintIntent.values) {
      if (v.id == id) return v;
    }
    return null;
  }
}

/// 选中文本分类 + 菜单项过滤（Android/Windows 共用）
class SelectionClassifier {
  const SelectionClassifier();

  static const int phraseMaxCjk = 8;
  static const int phraseMaxWord = 4;

  SelectionKind classify(String raw, {bool isOption = false, bool isStem = false}) {
    final text = raw.trim();
    if (isOption) return SelectionKind.option;
    if (isStem) return SelectionKind.stem;
    if (text.isEmpty) return SelectionKind.word;

    final hasCjk = _cjk.hasMatch(text);
    if (hasCjk) {
      final visible = text.replaceAll(RegExp(r'\s'), '').length;
      if (visible <= 1) return SelectionKind.word;
      if (visible <= phraseMaxCjk) {
        // 没有句末标点、没有明显断句 → 词/短语
        if (!_sentenceEnd.hasMatch(text)) return SelectionKind.phrase;
      }
      if (visible <= 40 && _sentenceEnd.hasMatch(text)) {
        return SelectionKind.sentence;
      }
      return SelectionKind.paragraph;
    }

    final words = text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (words.length <= 1 && text.length <= 24) return SelectionKind.word;
    if (words.length <= phraseMaxWord) return SelectionKind.phrase;
    if (_sentenceEnd.hasMatch(text) && words.length <= 40) {
      return SelectionKind.sentence;
    }
    return SelectionKind.paragraph;
  }

  /// 按选中类型过滤意图：句子/段落不提供「辨析」，选项不提供「翻译」
  List<HintIntent> intentsFor(SelectionKind kind) {
    switch (kind) {
      case SelectionKind.word:
        return const [
          HintIntent.meaning,
          HintIntent.grammar,
          HintIntent.contrast,
        ];
      case SelectionKind.phrase:
        return const [
          HintIntent.meaning,
          HintIntent.grammar,
          HintIntent.contrast,
          HintIntent.translate,
        ];
      case SelectionKind.sentence:
        return const [
          HintIntent.grammar,
          HintIntent.translate,
          HintIntent.approach,
        ];
      case SelectionKind.paragraph:
        return const [HintIntent.approach, HintIntent.translate];
      case SelectionKind.option:
        return const [
          HintIntent.meaning,
          HintIntent.grammar,
          HintIntent.contrast,
          HintIntent.approach,
        ];
      case SelectionKind.stem:
        return const [HintIntent.approach, HintIntent.grammar];
    }
  }

  String labelOf(SelectionKind kind) => switch (kind) {
        SelectionKind.word => '单词',
        SelectionKind.phrase => '短语',
        SelectionKind.sentence => '句子',
        SelectionKind.paragraph => '段落',
        SelectionKind.option => '选项',
        SelectionKind.stem => '题干',
      };

  static final RegExp _cjk = RegExp(r'[\u3040-\u30ff\u4e00-\u9fff]');
  static final RegExp _sentenceEnd = RegExp(r'[。！？!?\.]\s*$');
}

/// 一级提示防泄漏：答案关键词/正确选项原文不得出现在 hint_level == 1 的输出里。
///
/// 客户端先过滤一遍，代理侧再过滤一遍（双重执行，验收要求 <1% 泄露率）。
class HintLeakGuard {
  const HintLeakGuard();

  /// 返回 (是否安全, 过滤后文本, 命中的禁词)
  LeakCheck check({
    required String text,
    required int hintLevel,
    required List<String> answerKeywords,
    String answerLabel = '',
  }) {
    // 一、二两级都必须隐藏答案原文；三级起才允许对照讲解
    if (hintLevel > 2) {
      return LeakCheck(safe: true, text: text, hits: const []);
    }

    final forbidden = <String>{
      ...answerKeywords.where((e) => e.trim().isNotEmpty),
      if (answerLabel.trim().isNotEmpty) answerLabel.trim(),
    };
    if (forbidden.isEmpty) {
      return LeakCheck(safe: true, text: text, hits: const []);
    }

    // 只对「长度 ≥2」的禁词做包含匹配，避免把「は」「の」这类助词误杀
    final effective = forbidden.where((e) => e.length >= 2).toList();
    final hits = effective.where(text.contains).toList();
    if (hits.isEmpty) {
      return LeakCheck(safe: true, text: text, hits: const []);
    }

    // 按句切分，丢掉含禁词的整句；如果全被丢光，退化为通用引导语
    final sentences = _splitSentences(text);
    final kept = sentences.where((s) => !effective.any(s.contains)).toList();
    var cleaned = kept.join();
    if (cleaned.trim().isEmpty) {
      cleaned = '这一级只给方向：先看空格前后的词性和搭配，再判断需要哪种形式；'
          '具体答案在你点「再看一层」后才出现。';
    }
    return LeakCheck(safe: false, text: cleaned, hits: hits);
  }

  /// 流式阶段的即时遮蔽：把答案词/正确选项原文替换成占位符，
  /// 避免「边流边漏」——最终还会再走一次整句过滤。
  String maskLive(String text, List<String> answerKeywords, String answerLabel) {
    final forbidden = <String>{
      ...answerKeywords.where((e) => e.trim().length >= 2),
      if (answerLabel.trim().length >= 2) answerLabel.trim(),
    };
    if (forbidden.isEmpty) return text;
    var result = text;
    for (final word in forbidden) {
      if (result.contains(word)) {
        result = result.replaceAll(word, '＿' * word.length);
      }
    }
    return result;
  }

  List<String> _splitSentences(String text) {
    final result = <String>[];
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(ch);
      if ('。！？!?\n'.contains(ch)) {
        result.add(buffer.toString());
        buffer.clear();
      }
    }
    if (buffer.isNotEmpty) result.add(buffer.toString());
    return result;
  }
}

class LeakCheck {
  const LeakCheck({
    required this.safe,
    required this.text,
    required this.hits,
  });

  final bool safe;
  final String text;
  final List<String> hits;

  Map<String, dynamic> toJson() => {
        'safe': safe,
        'hits': hits,
      };
}

/// 提示分级：1 方向 / 2 结构 / 3 对照讲解 / 4 完整讲解（含答案）
class HintLevelPolicy {
  const HintLevelPolicy({this.maxLevel = 4, this.forceExplainAt = 3});

  final int maxLevel;

  /// 同题请求次数达到该值 → 强制讲解模式（不计成功率）
  final int forceExplainAt;

  int nextLevel(int current, {required bool answerRevealed}) {
    if (answerRevealed) return maxLevel;
    return (current + 1).clamp(1, maxLevel);
  }

  bool forcesExplain(int requestCount) => requestCount >= forceExplainAt;

  /// 该级别是否必须隐藏答案原文
  bool mustHideAnswer(int level) => level <= 2;

  String levelLabel(int level) => switch (level) {
        1 => '方向提示',
        2 => '结构提示',
        3 => '对照讲解',
        _ => '完整讲解',
      };
}

String prettyJson(Object? value) =>
    const JsonEncoder.withIndent('  ').convert(value);
