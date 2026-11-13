import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/calibration/level.dart';

/// 等级看板：不是「总分 87」，而是「哪一块会、哪一块不会」。
class LevelPage extends ConsumerWidget {
  const LevelPage({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(levelSummaryProvider);

    return summary.when(
      loading: () => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Center(child: Text('等级算不出来：$error')),
      data: (data) => _LevelBody(
        services: services,
        summary: data,
        onRefresh: () async => ref.invalidate(refreshTickProvider),
      ),
    );
  }
}

class _LevelBody extends StatelessWidget {
  const _LevelBody({
    required this.services,
    required this.summary,
    required this.onRefresh,
  });

  final AppServices services;
  final LevelSummary summary;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: wide ? 900 : 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OverallCard(summary: summary),
                  const SizedBox(height: 12),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _ClustersCard(summary: summary)),
                        const SizedBox(width: 12),
                        Expanded(flex: 6, child: _NodesCard(summary: summary)),
                      ],
                    )
                  else ...[
                    _ClustersCard(summary: summary),
                    const SizedBox(height: 12),
                    _NodesCard(summary: summary),
                  ],
                  const SizedBox(height: 12),
                  _ExplainCard(services: services, summary: summary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.summary});

  final LevelSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: KadianColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KadianColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'L${summary.overallLevel}',
                style: const TextStyle(
                  fontSize: 44,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: KadianColors.accentInk,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  summary.overallLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: KadianColors.text,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '总掌握度 ${(summary.overallMastery * 100).round()}%',
                style: const TextStyle(fontSize: 12, color: KadianColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.overallMastery.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: KadianColors.accentSoft,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(KadianColors.accent),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _Metric(
                label: '证据总数',
                value: '${summary.evidenceCount}',
              ),
              _Metric(
                label: '独立正确率',
                value: summary.independentRatio == 0
                    ? '—'
                    : '${(summary.independentRatio * 100).round()}%',
              ),
              _Metric(
                label: '已练节点',
                value:
                    '${summary.nodes.where((e) => e.attempts > 0).length}/${summary.nodes.length}',
              ),
              _Metric(
                label: '薄弱节点',
                value: '${summary.weakNodeIds.length}',
                color: summary.weakNodeIds.isEmpty
                    ? KadianColors.ok
                    : KadianColors.warn,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: color ?? KadianColors.text,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11.5, color: KadianColors.faint)),
      ],
    );
  }
}

class _ClustersCard extends StatelessWidget {
  const _ClustersCard({required this.summary});

  final LevelSummary summary;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '分轨等级',
      child: Column(
        children: [
          for (final cluster in summary.clusters)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cluster.title,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: KadianColors.text,
                          ),
                        ),
                      ),
                      Text(
                        'L${cluster.level} ${cluster.levelLabel}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: KadianColors.accentInk,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: cluster.mastery.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: KadianColors.sink,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _levelColor(cluster.level),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cluster.touchedNodes}/${cluster.nodeCount} 个节点有记录 · '
                    '薄弱 ${cluster.weakNodeIds.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: KadianColors.faint,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NodesCard extends StatelessWidget {
  const _NodesCard({required this.summary});

  final LevelSummary summary;

  @override
  Widget build(BuildContext context) {
    final sorted = [...summary.nodes]
      ..sort((a, b) {
        if (a.clusterId == b.clusterId) return b.mastery.compareTo(a.mastery);
        return a.clusterId.compareTo(b.clusterId);
      });

    return _Card(
      title: '节点明细',
      child: Column(
        children: [
          for (final node in sorted)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _levelColor(node.level).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'L${node.level}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _levelColor(node.level),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      node.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: KadianColors.text2,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 84,
                    child: Text(
                      node.attempts == 0
                          ? '未练'
                          : '${(node.mastery * 100).round()}% · ${node.attempts}次',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 11,
                        color: KadianColors.faint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ExplainCard extends StatelessWidget {
  const _ExplainCard({required this.services, required this.summary});

  final AppServices services;
  final LevelSummary summary;

  @override
  Widget build(BuildContext context) {
    final params = services.params;
    return _Card(
      title: '等级怎么算的',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '掌握度 = BKT 掌握概率 × ${params.masteryBktWeight.toStringAsFixed(1)} '
            '+ IRT 能力值 × ${(1 - params.masteryBktWeight).toStringAsFixed(1)}；'
            '看过提示的证据按 ${(params.assistedDiscount * 100).round()}% 折算，'
            '并按 ${params.decayHalfLifeDays} 天半衰期随时间回落。',
            style: KadianTheme.body,
          ),
          const SizedBox(height: 8),
          Text(
            '等级全部在本机算，断网照常更新；内容包里只有题库与参数，没有你的作答记录。',
            style: KadianTheme.body.copyWith(fontSize: 12.5, color: KadianColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Tag('引擎 ${summary.engineVersion}'),
              _Tag('内容包 ${services.pack.manifest.version}'),
              _Tag('DB v${services.db.schemaVersion}'),
              const _Tag('客户端 v3.0.0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: KadianColors.sink,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: KadianColors.muted),
      ),
    );
  }
}

Color _levelColor(int level) {
  if (level >= 5) return KadianColors.ok;
  if (level >= 3) return KadianColors.accentInk;
  if (level >= 1) return KadianColors.warn;
  return KadianColors.faint;
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KadianTheme.sectionTitle),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
