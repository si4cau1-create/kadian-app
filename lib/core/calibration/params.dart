/// 校准参数：随内容包 OTA 热更新，算法本身随客户端版本发布。
///
/// 参数含义集中在这一处，引擎（engine.dart）只读参数不写死常量，
/// 这样调参不需要改代码，也不会让算法与参数互相污染。
class LevelBand {
  const LevelBand({
    required this.level,
    required this.label,
    required this.min,
    required this.hint,
  });

  /// 0..5
  final int level;

  /// 展示名，如「半会」
  final String label;

  /// 该等级的下界（含），取 mastery 归一化值 0..1
  final double min;

  /// 面向学习者的释义
  final String hint;

  static const List<LevelBand> defaults = [
    LevelBand(level: 0, label: '陌生', min: 0.00, hint: '见过但说不清，等于不会'),
    LevelBand(level: 1, label: '认得', min: 0.18, hint: '有印象，靠提示才能用'),
    LevelBand(level: 2, label: '半会', min: 0.38, hint: '独立能做对一部分，还不稳'),
    LevelBand(level: 3, label: '会用', min: 0.58, hint: '独立做对为主，偶有失误'),
    LevelBand(level: 4, label: '熟练', min: 0.76, hint: '稳定独立正确，速度也够'),
    LevelBand(level: 5, label: '自动化', min: 0.90, hint: '不需要想，直接反应'),
  ];

  factory LevelBand.fromJson(Map<String, dynamic> json) => LevelBand(
        level: (json['level'] as num).toInt(),
        label: json['label'] as String? ?? 'L${json['level']}',
        min: (json['min'] as num?)?.toDouble() ?? 0,
        hint: json['hint'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'label': label,
        'min': min,
        'hint': hint,
      };
}

class CalibrationParams {
  const CalibrationParams({
    required this.engineVersion,
    this.bktInit = 0.15,
    this.bktLearn = 0.15,
    this.bktSlip = 0.10,
    this.bktGuess = 0.20,
    this.irtLearningRate = 0.35,
    this.irtItemLearningRate = 0.20,
    this.irtThetaMin = -3.0,
    this.irtThetaMax = 3.0,
    this.masteryBktWeight = 0.5,
    this.assistedDiscount = 0.35,
    this.hintFactors = const [1.0, 0.8, 0.55, 0.30],
    this.decayHalfLifeDays = 35,
    this.explainModeHintThreshold = 3,
    this.levelBands = LevelBand.defaults,
  });

  /// 算法版本号：写入 node_states / level summary，升级时据此决定重算或迁移。
  final String engineVersion;

  // ---- BKT ----
  final double bktInit; // 先验掌握概率
  final double bktLearn; // 学习转移概率 T
  final double bktSlip; // 会却做错 S
  final double bktGuess; // 不会却做对 G

  // ---- IRT（Rasch / 1PL 增量估计）----
  final double irtLearningRate;
  final double irtItemLearningRate;
  final double irtThetaMin;
  final double irtThetaMax;

  /// mastery 合成权重：BKT 占多少，剩下的给 sigmoid(theta)
  final double masteryBktWeight;

  // ---- 规则层 ----
  /// 辅助作答（看过提示）的证据折扣
  final double assistedDiscount;

  /// hintFactors[level] ：0 级无提示为 1.0，逐级递减
  final List<double> hintFactors;
  final double decayHalfLifeDays;

  /// 同题请求次数达到该值 → 强制讲解模式，本题不计成功率
  final int explainModeHintThreshold;

  final List<LevelBand> levelBands;

  static const CalibrationParams fallback =
      CalibrationParams(engineVersion: '1.0.0');

  double hintFactor(int hintLevel) {
    if (hintLevel <= 0) return hintFactors.first;
    final i = hintLevel.clamp(0, hintFactors.length - 1);
    return hintFactors[i];
  }

  LevelBand bandFor(double mastery) {
    var band = levelBands.first;
    for (final b in levelBands) {
      if (mastery >= b.min) band = b;
    }
    return band;
  }

  factory CalibrationParams.fromJson(Map<String, dynamic> json) {
    List<double> doubles(String key, List<double> fallbackValue) {
      final raw = json[key];
      if (raw is List) {
        final list = raw.map((e) => (e as num).toDouble()).toList();
        if (list.isNotEmpty) return list;
      }
      return fallbackValue;
    }

    double d(String key, double fallbackValue) =>
        (json[key] as num?)?.toDouble() ?? fallbackValue;

    int i(String key, int fallbackValue) =>
        (json[key] as num?)?.toInt() ?? fallbackValue;

    final bandsRaw = json['levelBands'];
    final bands = bandsRaw is List
        ? bandsRaw
            .whereType<Map>()
            .map((e) => LevelBand.fromJson(e.cast<String, dynamic>()))
            .toList()
        : LevelBand.defaults;

    return CalibrationParams(
      engineVersion: json['engineVersion'] as String? ?? '1.0.0',
      bktInit: d('bktInit', 0.15),
      bktLearn: d('bktLearn', 0.15),
      bktSlip: d('bktSlip', 0.10),
      bktGuess: d('bktGuess', 0.20),
      irtLearningRate: d('irtLearningRate', 0.35),
      irtItemLearningRate: d('irtItemLearningRate', 0.20),
      irtThetaMin: d('irtThetaMin', -3.0),
      irtThetaMax: d('irtThetaMax', 3.0),
      masteryBktWeight: d('masteryBktWeight', 0.5),
      assistedDiscount: d('assistedDiscount', 0.35),
      hintFactors: doubles('hintFactors', const [1.0, 0.8, 0.55, 0.30]),
      decayHalfLifeDays: d('decayHalfLifeDays', 35),
      explainModeHintThreshold: i('explainModeHintThreshold', 3),
      levelBands: bands.isEmpty ? LevelBand.defaults : bands,
    );
  }

  Map<String, dynamic> toJson() => {
        'engineVersion': engineVersion,
        'bktInit': bktInit,
        'bktLearn': bktLearn,
        'bktSlip': bktSlip,
        'bktGuess': bktGuess,
        'irtLearningRate': irtLearningRate,
        'irtItemLearningRate': irtItemLearningRate,
        'irtThetaMin': irtThetaMin,
        'irtThetaMax': irtThetaMax,
        'masteryBktWeight': masteryBktWeight,
        'assistedDiscount': assistedDiscount,
        'hintFactors': hintFactors,
        'decayHalfLifeDays': decayHalfLifeDays,
        'explainModeHintThreshold': explainModeHintThreshold,
        'levelBands': levelBands.map((e) => e.toJson()).toList(),
      };
}
