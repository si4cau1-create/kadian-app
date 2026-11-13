import 'dart:math' as math;

/// SM-2（简化版）：三档自评 → 下次到期时间。
///
/// 三档对应 quality：忘记=2、模糊=3、记得=5。
/// 忘记不是「失败」，只是把盒子打回 1 并缩短间隔——卡点的复习不惩罚人。
class Sm2Result {
  const Sm2Result({
    required this.box,
    required this.ease,
    required this.dueAt,
    required this.reps,
    required this.lapses,
  });

  final int box;
  final double ease;
  final DateTime dueAt;
  final int reps;
  final int lapses;
}

class Sm2 {
  const Sm2();

  /// 盒子 → 基础间隔（天）
  static const List<int> boxIntervals = [0, 1, 2, 4, 7, 15, 30, 60];

  Sm2Result review({
    required int box,
    required double ease,
    required int reps,
    required int lapses,
    required int quality,
    DateTime? now,
  }) {
    final at = now ?? DateTime.now();
    final q = quality.clamp(0, 5);

    if (q < 3) {
      const nextBox = 1;
      final intervalHours = box >= 3 ? 8 : 4;
      return Sm2Result(
        box: nextBox,
        ease: math.max(1.3, ease - 0.2),
        dueAt: at.add(Duration(hours: intervalHours)),
        reps: 0,
        lapses: lapses + 1,
      );
    }

    final delta = 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02);
    final nextEase = math.max(1.3, ease + delta);
    final nextBox = math.min(boxIntervals.length - 1, box + 1);
    final base = boxIntervals[nextBox];
    final days = math.max(1, (base * nextEase / 2.5).round());

    return Sm2Result(
      box: nextBox,
      ease: nextEase,
      dueAt: at.add(Duration(days: days)),
      reps: reps + 1,
      lapses: lapses,
    );
  }

  /// 三档按钮映射
  static int qualityOf(String rating) {
    switch (rating) {
      case 'again':
        return 2;
      case 'hard':
        return 3;
      default:
        return 5;
    }
  }
}
