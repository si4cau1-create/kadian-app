import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/calibration/level.dart';
import '../core/db/database.dart';
import '../core/settings/settings_store.dart';
import '../features/achievements/achievement_engine.dart';
import 'services.dart';

/// 启动状态：要么还没选学科，要么服务栈已装好。
sealed class BootState {
  const BootState();
}

/// 首次启动（或重置档案后）：必须先选学科，未选择不进入学习界面。
class BootNeedsSubject extends BootState {
  const BootNeedsSubject(this.settings);

  final SettingsStore settings;
}

class BootReady extends BootState {
  const BootReady(this.services, this.settings);

  final AppServices services;
  final SettingsStore settings;
}

/// 读设置 → 有学科就装配服务栈，没有就停在选择页。
///
/// 切换学科时 invalidate 本 provider 即可：整条服务栈（内容包、数据库）
/// 都会按新学科重建，旧档案的数据原样保留在自己的目录里。
final bootProvider = FutureProvider<BootState>((ref) async {
  final settings = await SettingsStore.load();
  final subject = settings.subject;
  if (subject == null) return BootNeedsSubject(settings);
  final services = await AppServices.bootstrap(
    subject: subject,
    settingsStore: settings,
  );
  return BootReady(services, settings);
});

final servicesProvider = FutureProvider<AppServices>((ref) async {
  final boot = await ref.watch(bootProvider.future);
  if (boot is BootReady) return boot.services;
  throw StateError('尚未选择学科：请先确定要学的科目');
});

/// 任何写操作完成后 bump 一次，让看板/成就/复习队列自动重算。
final refreshTickProvider = StateProvider<int>((ref) => 0);

final levelSummaryProvider = FutureProvider<LevelSummary>((ref) async {
  ref.watch(refreshTickProvider);
  final services = await ref.watch(servicesProvider.future);
  return services.practice.levelSummary();
});

final achievementsProvider = FutureProvider<AchievementSnapshot>((ref) async {
  ref.watch(refreshTickProvider);
  final services = await ref.watch(servicesProvider.future);
  return services.achievements.settle();
});

final dueVocabProvider = FutureProvider<List<VocabStateRow>>((ref) async {
  ref.watch(refreshTickProvider);
  final services = await ref.watch(servicesProvider.future);
  return services.db.dueVocab(DateTime.now());
});

final vocabTotalProvider = FutureProvider<int>((ref) async {
  ref.watch(refreshTickProvider);
  final services = await ref.watch(servicesProvider.future);
  return services.db.vocabCount();
});

class TodayOverview {
  const TodayOverview({
    required this.todayEvidence,
    required this.todayHints,
    required this.todayReviews,
    required this.todayMinutes,
    required this.streakDays,
    required this.dueReviews,
    required this.weakNodeTitles,
  });

  final int todayEvidence;
  final int todayHints;
  final int todayReviews;
  final int todayMinutes;
  final int streakDays;
  final int dueReviews;
  final List<String> weakNodeTitles;

  bool get isEmpty => todayEvidence == 0;

  static const empty = TodayOverview(
    todayEvidence: 0,
    todayHints: 0,
    todayReviews: 0,
    todayMinutes: 0,
    streakDays: 0,
    dueReviews: 0,
    weakNodeTitles: [],
  );
}

final todayOverviewProvider = FutureProvider<TodayOverview>((ref) async {
  ref.watch(refreshTickProvider);
  final services = await ref.watch(servicesProvider.future);
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final daily = await services.db.dailyStat(dayStart);
  final streak = await services.db.streakDays(now);
  final due = await services.db.dueVocab(now);
  final summary = await services.practice.levelSummary(now: now);

  return TodayOverview(
    todayEvidence: daily?.evidenceCount ?? 0,
    todayHints: daily?.hintCount ?? 0,
    todayReviews: daily?.reviewCount ?? 0,
    todayMinutes: daily?.minutes ?? 0,
    streakDays: streak,
    dueReviews: due.length,
    weakNodeTitles: [
      for (final id in summary.weakNodeIds.take(3))
        services.pack.nodeById[id]?.title ?? id
    ],
  );
});
