import 'package:flutter_test/flutter_test.dart';
import 'package:kadian_app/features/vocab_review/sm2.dart';

void main() {
  const sm2 = Sm2();
  final now = DateTime(2026, 11, 8, 9);

  group('SM-2 排期', () {
    test('记得：盒子前进、间隔变长', () {
      final first = sm2.review(
        box: 1,
        ease: 2.5,
        reps: 0,
        lapses: 0,
        quality: 5,
        now: now,
      );
      expect(first.box, 2);
      expect(first.reps, 1);
      expect(first.dueAt.isAfter(now), isTrue);
      expect(first.lapses, 0);

      final second = sm2.review(
        box: first.box,
        ease: first.ease,
        reps: first.reps,
        lapses: first.lapses,
        quality: 5,
        now: first.dueAt,
      );
      final firstInterval = first.dueAt.difference(now).inHours;
      final secondInterval = second.dueAt.difference(first.dueAt).inHours;
      expect(secondInterval, greaterThan(firstInterval));
    });

    test('忘记：盒子回到 1、ease 下降、lapses 增加、当日复现', () {
      final result = sm2.review(
        box: 5,
        ease: 2.5,
        reps: 8,
        lapses: 1,
        quality: 2,
        now: now,
      );
      expect(result.box, 1);
      expect(result.ease, lessThan(2.5));
      expect(result.ease, greaterThanOrEqualTo(1.3));
      expect(result.lapses, 2);
      expect(result.reps, 0);
      expect(result.dueAt.difference(now).inHours, lessThan(24));
    });

    test('模糊：间隔短于记得', () {
      final hard = sm2.review(
        box: 6,
        ease: 2.5,
        reps: 4,
        lapses: 0,
        quality: 3,
        now: now,
      );
      final good = sm2.review(
        box: 6,
        ease: 2.5,
        reps: 4,
        lapses: 0,
        quality: 5,
        now: now,
      );
      expect(
        hard.dueAt.difference(now).inHours,
        lessThan(good.dueAt.difference(now).inHours),
      );
    });

    test('ease 不会低于 1.3', () {
      var ease = 2.5;
      for (var i = 0; i < 10; i++) {
        ease = sm2.review(
          box: 1,
          ease: ease,
          reps: 0,
          lapses: i,
          quality: 2,
          now: now,
        ).ease;
      }
      expect(ease, greaterThanOrEqualTo(1.3));
    });

    test('三档映射', () {
      expect(Sm2.qualityOf('again'), 2);
      expect(Sm2.qualityOf('hard'), 3);
      expect(Sm2.qualityOf('good'), 5);
    });
  });
}
