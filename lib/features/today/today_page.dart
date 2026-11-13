import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/calibration/level.dart';
import '../../core/content_pack/models.dart';
import '../practice/practice_page.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({
    super.key,
    required this.services,
    required this.onNavigate,
  });

  final AppServices services;
  final void Function(int index) onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(todayOverviewProvider);
    final summary = ref.watch(levelSummaryProvider);

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
                  _MainLineCard(
                    overview: overview.valueOrNull,
                    onDiagnose: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: const Text('阶梯诊断')),
                          body: PracticePage(
                            services: services,
                            onNavigate: (_) {},
                            diagnostic: true,
                          ),
                        ),
                      ),
                    ),
                    onPractice: () => onNavigate(1),
                  ),
                  const SizedBox(height: 12),
                  _StatRow(overview: overview.valueOrNull),
                  const SizedBox(height: 12),
                  _WeakNodesCard(
                    summary: summary.valueOrNull,
                    services: services,
                    onStart: () => onNavigate(1),
                  ),
                  const SizedBox(height: 12),
                  _LoopCard(onReview: () => onNavigate(2)),
                  if (!services.contentPackHealthy) ...[
                    const SizedBox(height: 12),
                    _WarnCard(
                      title: '内容包有问题',
                      lines: services.loaded.validation.errors,
                    ),
                  ] else if (services.contentPackWarnings.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _WarnCard(
                      title: '内容包提示',
                      lines: services.contentPackWarnings.take(3).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainLineCard extends StatelessWidget {
  const _MainLineCard({
    required this.overview,
    required this.onDiagnose,
    required this.onPractice,
  });

  final TodayOverview? overview;
  final VoidCallback onDiagnose;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final data = overview ?? TodayOverview.empty;
    final headline = data.todayEvidence == 0
        ? '今天还没开始'
        : '今天已留下 ${data.todayEvidence} 条证据';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [KadianColors.accent, KadianColors.accentInk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '今日主线',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.6,
                  color: Color(0xCCFFFFFF),
                ),
              ),
              const Spacer(),
              if (data.streakDays > 0)
                Text(
                  '连续 ${data.streakDays} 天',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xE6FFFFFF),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 24,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '做题 → 不会 → 就地精讲 → 学会。不跳页、不掏手机。',
            style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xE6FFFFFF)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: KadianColors.accentInk,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                onPressed: onDiagnose,
                child: Text(data.todayEvidence == 0 ? '开始诊断' : '再诊断一轮'),
              ),
              const SizedBox(width: 12),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: onPractice,
                child: const Text('自由做题'),
              ),
              const Spacer(),
              if (data.todayMinutes > 0)
                Text(
                  '今日 ${data.todayMinutes} 分钟',
                  style: const TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.overview});

  final TodayOverview? overview;

  @override
  Widget build(BuildContext context) {
    final data = overview ?? TodayOverview.empty;
    final tiles = [
      ('今日证据', '${data.todayEvidence}', '做题与复习都算'),
      ('待复习', '${data.dueReviews}', '到期的词卡'),
      ('提示次数', '${data.todayHints}', '越少越好，但不丢人'),
    ];
    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: KadianColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: KadianColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tiles[i].$1, style: KadianTheme.sectionTitle),
                  const SizedBox(height: 6),
                  Text(
                    tiles[i].$2,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: KadianColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tiles[i].$3,
                    style: const TextStyle(
                      fontSize: 11,
                      color: KadianColors.faint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WeakNodesCard extends StatelessWidget {
  const _WeakNodesCard({
    required this.summary,
    required this.services,
    required this.onStart,
  });

  final LevelSummary? summary;
  final AppServices services;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final weakIds = summary?.weakNodeIds ?? const <String>[];
    final weak = weakIds
        .map((id) => services.pack.nodeById[id])
        .whereType<NodeDef>()
        .take(4)
        .toList();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('现在最该补的', style: KadianTheme.sectionTitle),
              const Spacer(),
              TextButton(onPressed: onStart, child: const Text('去做题')),
            ],
          ),
          const SizedBox(height: 4),
          if (weak.isEmpty)
            const Text(
              '还没有短板记录，先做几道诊断题，等级才长得出来。',
              style: KadianTheme.body,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final node in weak)
                  Chip(
                    label: Text(node.title),
                    avatar: const Icon(Icons.arrow_outward, size: 14),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LoopCard extends StatelessWidget {
  const _LoopCard({required this.onReview});

  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('闭环怎么走', style: KadianTheme.sectionTitle),
          const SizedBox(height: 10),
          const _Step(index: '1', text: '做题时遇到不会的词/句，直接长按选中（Windows 右键拖选）。'),
          const _Step(index: '2', text: '弹出意图菜单，选「什么意思 / 语法点 / 解题思路」。'),
          const _Step(index: '3', text: '精讲就地展开，不跳页；看完点「学会」入库。'),
          const _Step(index: '4', text: '到期后复习队列会把它找上你，按遗忘曲线走。'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onReview,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('去复习'),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.text});

  final String index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: KadianColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              index,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: KadianColors.accentInk,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: KadianTheme.body)),
        ],
      ),
    );
  }
}

class _WarnCard extends StatelessWidget {
  const _WarnCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KadianColors.warnSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0DCBB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: KadianColors.warn,
            ),
          ),
          const SizedBox(height: 6),
          for (final line in lines)
            Text(
              '· $line',
              style: const TextStyle(fontSize: 12, color: KadianColors.text2),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: KadianColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KadianColors.line),
      ),
      child: child,
    );
  }
}
