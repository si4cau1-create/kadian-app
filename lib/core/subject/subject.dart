/// 学科：一个学习实例只属于一个学科。
///
/// 产品层是「单学科学习实例」，不是「双语混合学习器」。学科在首次启动时
/// 二选一确定，之后内容包加载、数据库路径、等级聚合、成就结算、词簇复习
/// 都只在该学科内进行。
///
/// 跨学科调用一律抛 [SubjectMismatchException]（错误码 `subject_mismatch`），
/// 绝不静默切换到调用方传入的另一个学科。
library;

enum Subject {
  japanese('japanese', 'ja', '日语'),
  english('english', 'en', '英语');

  const Subject(this.id, this.packPrefix, this.label);

  /// 配置值与持久化路径用：`learners/<learnerId>/<subject.id>/`
  final String id;

  /// 内容包里的学科标识前缀。节点、词簇、题目的 id 形如 `ja.g.masu` / `en.r.infer`。
  final String packPrefix;

  /// 界面展示名
  final String label;

  /// 宽松解析：接受 [Subject] 枚举本身，或 `japanese` / `ja` / `JA` 等写法。
  /// 无法识别返回 null。
  static Subject? tryParse(Object? raw) {
    if (raw == null) return null;
    // 枚举实例直接认。toString() 是 'Subject.english'，按字符串解析会误判。
    if (raw is Subject) return raw;
    final value = raw.toString().trim().toLowerCase();
    if (value.isEmpty) return null;
    for (final subject in values) {
      if (subject.id == value || subject.packPrefix == value) return subject;
    }
    return null;
  }

  /// 严格解析：无法识别即抛错。
  static Subject parse(Object? raw) {
    final parsed = tryParse(raw);
    if (parsed == null) {
      throw SubjectMismatchException(
        expected: values.map((e) => e.id).join('|'),
        actual: raw?.toString() ?? 'null',
        operation: 'parse',
      );
    }
    return parsed;
  }

  /// 节点/词簇是否归属本学科（按 id 前缀判断）
  bool ownsNode(String nodeId) => nodeId.startsWith('$packPrefix.');

  Subject get other => this == Subject.japanese ? Subject.english : Subject.japanese;
}

/// 学科不匹配。调用方传入了与当前档案不同的学科，或当前档案尚未选择学科。
///
/// 对应规格里的 `subject_mismatch` 错误码；客户端与后端代理共用同一语义。
class SubjectMismatchException implements Exception {
  SubjectMismatchException({
    required this.expected,
    required this.actual,
    this.operation = '',
  });

  /// 当前档案绑定的学科（`japanese` / `english`），未选择时为 `unset`
  final String expected;

  /// 调用方传入的学科
  final String actual;

  /// 出错的操作名，便于定位：`diagnose_next` / `get_level` 等
  final String operation;

  String get code => 'subject_mismatch';

  Map<String, dynamic> toJson() => {
        'error': code,
        'expected': expected,
        'actual': actual,
        'operation': operation,
      };

  @override
  String toString() =>
      'subject_mismatch($operation): 期望 $expected，实际 $actual';
}

/// 校验调用方传入的学科与当前档案一致，不一致直接抛 [SubjectMismatchException]。
///
/// [requested] 为 null 表示调用方未指定学科，视为使用当前档案的学科（合规）。
Subject requireSameSubject({
  required Subject current,
  required Object? requested,
  required String operation,
}) {
  if (requested == null) return current;
  final parsed = Subject.tryParse(requested);
  if (parsed == null || parsed != current) {
    throw SubjectMismatchException(
      expected: current.id,
      actual: requested.toString(),
      operation: operation,
    );
  }
  return current;
}
