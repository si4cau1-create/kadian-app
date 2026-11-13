import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/db/database.dart';
import 'sm2.dart';

/// 复习：词簇 × 维度，三档自评，SM-2 排期。
///
/// 复习只产生 review 证据，不参与能力估计——背词和做题是两条轨道。
class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key, required this.services});

  final AppServices services;

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  static const Sm2 _sm2 = Sm2();
  bool _revealed = false;
  bool _busy = false;
  int _doneToday = 0;

  Future<void> _rate(VocabStateRow word, String rating) async {
    if (_busy) return;
    setState(() => _busy = true);

    final quality = Sm2.qualityOf(rating);
    final next = _sm2.review(
      box: word.box,
      ease: word.ease,
      reps: word.reps,
      lapses: word.lapses,
      quality: quality,
    );

    await widget.services.db.upsertVocab(VocabStatesCompanion.insert(
      wordId: word.wordId,
      lemma: word.lemma,
      reading: Value(word.reading),
      gloss: Value(word.gloss),
      dimension: Value(word.dimension),
      clusterId: Value(word.clusterId),
      box: Value(next.box),
      ease: Value(next.ease),
      reps: Value(next.reps),
      lapses: Value(next.lapses),
      lastRating: Value(quality),
      dueAt: next.dueAt,
      createdAt: word.createdAt,
    ));
    await widget.services.practice
        .recordVocabReview(word: word, rating: rating, quality: quality);

    if (!mounted) return;
    setState(() {
      _busy = false;
      _revealed = false;
      _doneToday++;
    });
    ref.read(refreshTickProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final due = ref.watch(dueVocabProvider);
    final total = ref.watch(vocabTotalProvider);

    return due.when(
      loading: () => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Center(child: Text('复习队列打不开：$error')),
      data: (queue) {
        if (queue.isEmpty) {
          return _EmptyReview(
            total: total.valueOrNull ?? 0,
            doneToday: _doneToday,
          );
        }
        final word = queue.first;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '待复习 ${queue.length}',
                          style: KadianTheme.sectionTitle,
                        ),
                        const Spacer(),
                        if (_doneToday > 0)
                          Text(
                            '本次已过 $_doneToday',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: KadianColors.ok,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _WordCard(
                      word: word,
                      revealed: _revealed,
                      onReveal: () => setState(() => _revealed = true),
                    ),
                    const SizedBox(height: 12),
                    if (_revealed)
                      Row(
                        children: [
                          Expanded(
                            child: _RateButton(
                              label: '忘记',
                              hint: '4 小时后',
                              color: KadianColors.danger,
                              onTap: _busy ? null : () => _rate(word, 'again'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _RateButton(
                              label: '模糊',
                              hint: '短间隔',
                              color: KadianColors.warn,
                              onTap: _busy ? null : () => _rate(word, 'hard'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _RateButton(
                              label: '记得',
                              hint: '长间隔',
                              color: KadianColors.accentInk,
                              onTap: _busy ? null : () => _rate(word, 'good'),
                            ),
                          ),
                        ],
                      )
                    else
                      FilledButton(
                        onPressed: () => setState(() => _revealed = true),
                        child: const Text('显示释义'),
                      ),
                    const SizedBox(height: 14),
                    const Text(
                      '复习记录只进 review 轨道：它影响「该不该再见面」，不影响知识点等级。',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.6,
                        color: KadianColors.faint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.revealed,
    required this.onReveal,
  });

  final VocabStateRow word;
  final bool revealed;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: KadianColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KadianColors.line),
      ),
      child: Column(
        children: [
          Text(
            word.lemma,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: KadianColors.text,
            ),
          ),
          if (word.reading.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              word.reading,
              style: const TextStyle(
                fontSize: 14,
                color: KadianColors.muted,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: KadianColors.line),
          const SizedBox(height: 16),
          if (revealed)
            Column(
              children: [
                Text(
                  word.gloss.isEmpty ? '（这条是临时词条，暂无释义）' : word.gloss,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: KadianColors.text2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '盒子 ${word.box} · 复习 ${word.reps} 次 · 遗忘 ${word.lapses} 次',
                  style: const TextStyle(
                    fontSize: 11,
                    color: KadianColors.faint,
                  ),
                ),
              ],
            )
          else
            TextButton(
              onPressed: onReveal,
              child: const Text('想不起来？点这里看'),
            ),
        ],
      ),
    );
  }
}

class _RateButton extends StatelessWidget {
  const _RateButton({
    required this.label,
    required this.hint,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String hint;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hint,
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.75)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyReview extends StatelessWidget {
  const _EmptyReview({required this.total, required this.doneToday});

  final int total;
  final int doneToday;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 38, color: KadianColors.ok),
              const SizedBox(height: 12),
              Text(
                doneToday > 0 ? '今天的复习清完了' : '现在没有到期的卡',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KadianColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                total == 0
                    ? '在做题页选中不认识的词，点「加入复习」，它就会出现这里。'
                    : '词库共 $total 条，按遗忘曲线排期，到期自动出现。',
                textAlign: TextAlign.center,
                style: KadianTheme.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
