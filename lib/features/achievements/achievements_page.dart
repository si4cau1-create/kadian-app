import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import 'achievement_engine.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(achievementsProvider);

    return snapshot.when(
      loading: () => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Center(child: Text('成就结算失败：$error')),
      data: (data) {
        final independent =
            data.views.where((v) => v.def.independentOnly).toList();
        final assisted =
            data.views.where((v) => !v.def.independentOnly).toList();
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(refreshTickProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(snapshot: data),
                      const SizedBox(height: 12),
                      _Section(
                        title: '独立区',
                        subtitle: '只认无提示、无揭示的作答。辅助区的成绩不会串到这里。',
                        views: independent,
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: '辅助区',
                        subtitle: '看过提示、进过讲解模式也算数——那是学习，不是作弊。',
                        views: assisted,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: KadianColors.tint,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: KadianColors.line),
                        ),
                        child: const Text(
                          'XP 只发给诊断行为：诊断是唯一主动「暴露自己不会」的动作，'
                          '值得奖励。刷题、看提示、复习都不发 XP，避免为分数而刷。',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.7,
                            color: KadianColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.snapshot});

  final AchievementSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: KadianColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KadianColors.line),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('诊断 XP', style: KadianTheme.sectionTitle),
              const SizedBox(height: 4),
              Text(
                '${snapshot.totalXp}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: KadianColors.accentInk,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '已解锁 ${snapshot.unlockedCount}/${snapshot.views.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: KadianColors.text2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '三段式：铜 / 银 / 金',
                style: TextStyle(fontSize: 11, color: KadianColors.faint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.views,
  });

  final String title;
  final String subtitle;
  final List<AchievementView> views;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: KadianTheme.sectionTitle),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11.5, color: KadianColors.faint),
        ),
        const SizedBox(height: 10),
        for (final view in views)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _AchievementCard(view: view),
          ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.view});

  final AchievementView view;

  @override
  Widget build(BuildContext context) {
    final next = view.currentStage;
    final tierLabel = _tierLabel(view.tier);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: KadianColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: view.unlocked ? const Color(0xFFCFE3BF) : KadianColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: view.unlocked
                      ? KadianColors.okSoft
                      : KadianColors.sink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  view.def.icon,
                  style: TextStyle(
                    fontSize: 14,
                    color: view.unlocked
                        ? KadianColors.ok
                        : KadianColors.faint,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          view.def.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: KadianColors.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (view.unlocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 1),
                            decoration: BoxDecoration(
                              color: KadianColors.okSoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              tierLabel,
                              style: const TextStyle(
                                fontSize: 10,
                                color: KadianColors.ok,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      view.def.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.5,
                        color: KadianColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (view.xp > 0)
                Text(
                  '+${view.xp} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: KadianColors.accentInk,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: view.unlocked && next == null ? 1 : view.progressToNext,
              minHeight: 5,
              backgroundColor: KadianColors.sink,
              valueColor: AlwaysStoppedAnimation<Color>(
                view.unlocked ? KadianColors.ok : KadianColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            next == null
                ? '已达成全部阶段 · ${view.progress.toStringAsFixed(0)}'
                : '${_fmt(view.progress)} / ${_fmt(next.target)} → ${_tierLabel(next.tier)}',
            style: const TextStyle(fontSize: 10.5, color: KadianColors.faint),
          ),
        ],
      ),
    );
  }

  String _fmt(double value) =>
      value >= 100 || value == value.roundToDouble()
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1);

  String _tierLabel(String tier) => switch (tier) {
        'bronze' => '铜',
        'silver' => '银',
        'gold' => '金',
        _ => '未解锁',
      };
}
