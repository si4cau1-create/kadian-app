import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/content_pack/models.dart';
import '../../core/db/database.dart';
import '../../core/db/tables.dart';
import '../../core/selection/selection_intent.dart';
import '../../core/services/practice_service.dart';
import 'selection_menu.dart';

/// 做题页：语篇 + 题干 + 选项 + 就地精讲。
///
/// 桌面端（≥1000px）右侧固定检查器；移动端精讲卡就地插在语篇下方，
/// 不弹全屏、不跳页——这是产品存在的理由，不能被布局妥协掉。
class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({
    super.key,
    required this.services,
    required this.onNavigate,
    this.diagnostic = false,
  });

  final AppServices services;
  final void Function(int index) onNavigate;

  /// 阶梯诊断：证据记为 diagnostic，XP 只认这条轨
  final bool diagnostic;

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  final ScrollController _scroll = ScrollController();
  final Set<String> _seen = <String>{};
  final SelectionClassifier _classifier = const SelectionClassifier();
  final HintLevelPolicy _policy = const HintLevelPolicy();

  ItemDef? _item;
  PassageDef? _passage;
  AttemptRow? _attempt;
  DateTime? _startedAt;
  int? _selected;
  AttemptResult? _result;
  bool _loading = true;

  int _hintLevel = 0;
  int _hintCount = 0;
  bool _answerRevealed = false;
  bool _explainMode = false;
  String _hintText = '';
  bool _hintStreaming = false;
  String? _hintError;
  String _hintTitle = '';
  bool _hintFiltered = false;
  HintIntent? _lastIntent;

  String _selectionText = '';
  SelectionKind _selectionKind = SelectionKind.word;
  Map<String, dynamic> _summaryJson = const {};
  List<String> _prereqTitles = const [];

  @override
  void initState() {
    super.initState();
    _loadNext();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadNext({bool keepSeen = true}) async {
    setState(() {
      _loading = true;
      _item = null;
      _result = null;
      _selected = null;
      _prereqTitles = const [];
      _resetHintState();
    });

    final services = widget.services;
    final item = await services.practice.nextDiagnosticItem(
      excludeItemIds: keepSeen ? _seen : <String>{},
    );
    if (!mounted) return;
    if (item == null) {
      setState(() => _loading = false);
      return;
    }
    _seen.add(item.id);
    final attempt = await services.practice.startAttempt(item);
    final summary = await services.practice.levelSummary();
    if (!mounted) return;
    setState(() {
      _item = item;
      _passage = item.passageId.isEmpty
          ? null
          : services.pack.passageById[item.passageId];
      _attempt = attempt;
      _startedAt = DateTime.now();
      _summaryJson = summary.toPromptSummary();
      _loading = false;
    });
  }

  void _resetHintState() {
    _hintLevel = 0;
    _hintCount = 0;
    _answerRevealed = false;
    _explainMode = false;
    _hintText = '';
    _hintStreaming = false;
    _hintError = null;
    _hintTitle = '';
    _hintFiltered = false;
    _lastIntent = null;
    _selectionText = '';
  }

  SelectionKind _classify(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return SelectionKind.word;
    final options = _item?.options ?? const <String>[];
    if (options.any((o) => o.trim() == trimmed)) return SelectionKind.option;
    final stem = _item?.stem ?? '';
    if (stem.isNotEmpty && stem.contains(trimmed) && trimmed.length > 12) {
      return SelectionKind.stem;
    }
    return _classifier.classify(trimmed);
  }

  Future<void> _ask(HintIntent intent, {bool escalate = false}) async {
    final item = _item;
    final attempt = _attempt;
    if (item == null || attempt == null || _hintStreaming) return;
    if (_selectionText.trim().isEmpty) return;

    final threshold = widget.services.params.explainModeHintThreshold;
    final nextCount = _hintCount + 1;
    final forcedExplain = nextCount >= threshold;
    final level = escalate
        ? (_hintLevel + 1).clamp(1, 4)
        : nextCount.clamp(1, 4);

    setState(() {
      _lastIntent = intent;
      _hintCount = nextCount;
      _hintLevel = level;
      _explainMode = forcedExplain || _hintLevel >= 4;
      _hintStreaming = true;
      _hintText = '';
      _hintError = null;
      _hintFiltered = false;
      _hintTitle = '${intent.label} · ${_policy.levelLabel(level)}';
    });

    if (forcedExplain) {
      _snack('同题已问 $nextCount 次：进入讲解模式，本题不计成功率');
    }

    final excerpt = _passage == null
        ? ''
        : (_passage!.text.length > 600
            ? _passage!.text.substring(0, 600)
            : _passage!.text);

    try {
      await for (final event in widget.services.hints.request(
        item: item,
        attempt: attempt,
        selectedText: _selectionText,
        kind: _selectionKind,
        intent: intent,
        level: level,
        requestCount: nextCount,
        learnerSummary: _summaryJson,
        explainMode: _explainMode,
        answerRevealed: _answerRevealed,
        passageExcerpt: excerpt,
      )) {
        if (!mounted) return;
        setState(() {
          if (event.error != null && event.error!.isNotEmpty) {
            _hintError = event.error;
          }
          if (event.text.isNotEmpty) _hintText = event.text;
          if (event.filtered) _hintFiltered = true;
          if (event.done) _hintStreaming = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hintError = '$error';
        _hintStreaming = false;
      });
    } finally {
      if (mounted && _hintStreaming) {
        setState(() => _hintStreaming = false);
      }
    }
  }

  Future<void> _revealAnswer() async {
    final item = _item;
    final attempt = _attempt;
    if (item == null || attempt == null) return;
    setState(() {
      _answerRevealed = true;
      _hintLevel = 4;
      _explainMode = true;
    });
    await widget.services.practice.recordHintRequest(
      attempt: attempt,
      selectedText: _selectionText,
      selectionType: _selectionKind.name,
      intent: 'reveal',
      level: 4,
      answerRevealed: true,
      outOfScope: false,
      explainMode: true,
      filtered: false,
      servedOffline: false,
    );
    _snack('已揭示答案：本题按讲解模式记录，不计成功率');
  }

  Future<void> _submit() async {
    final item = _item;
    final attempt = _attempt;
    if (item == null || attempt == null || _result != null) return;
    if (_selected == null) {
      _snack('先选一个答案');
      return;
    }
    final correct = _selected == item.answerIndex;
    final elapsed = DateTime.now().difference(_startedAt!).inSeconds;

    final result = await widget.services.practice.submitAttempt(
      item: item,
      attempt: attempt,
      correct: correct,
      selectedAnswer: item.options.isEmpty ? '' : item.options[_selected!],
      elapsedSeconds: elapsed,
      hintLevel: _hintLevel,
      hintRequestCount: _hintCount,
      answerRevealed: _answerRevealed,
      kind: widget.diagnostic ? EvidenceKind.diagnostic : EvidenceKind.attempt,
    );
    final snapshot = await widget.services.achievements.settle();
    if (!mounted) return;

    setState(() => _result = result);
    ref.read(refreshTickProvider.notifier).state++;

    final fallback =
        await widget.services.practice.prerequisiteFallback(item.nodeId);
    if (mounted) {
      setState(() =>
          _prereqTitles = fallback.take(2).map((e) => e.title).toList());
    }

    if (snapshot.newlyUnlocked.isNotEmpty) {
      final names = snapshot.newlyUnlocked.map((e) => e.title).join('、');
      _snack('成就解锁：$names');
    }
  }

  Future<void> _addSelectionToReview() async {
    final text = _selectionText.trim();
    if (text.isEmpty) return;
    final pack = widget.services.pack;
    final existing = pack.vocab.where((v) => v.lemma == text).toList();
    final known = existing.isEmpty ? null : existing.first;
    final id = known?.id ??
        'adhoc:${base64Url.encode(utf8.encode(text)).replaceAll('=', '')}';
    final now = DateTime.now();
    await widget.services.db.upsertVocab(VocabStatesCompanion.insert(
      wordId: id,
      lemma: text,
      reading: Value(known?.reading ?? ''),
      gloss: Value(known?.gloss ?? ''),
      dimension: Value(known?.dimension ?? 'reading'),
      clusterId: Value(known?.clusterId ?? ''),
      box: const Value(1),
      ease: const Value(2.5),
      reps: const Value(0),
      lapses: const Value(0),
      lastRating: const Value(0),
      dueAt: now,
      createdAt: now,
    ));
    if (!mounted) return;
    ref.read(refreshTickProvider.notifier).state++;
    _snack(known == null ? '已加入复习队列（临时词条）' : '「$text」已加入复习队列');
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final item = _item;
    if (item == null) {
      return _EmptyPractice(onReload: () => _loadNext(keepSeen: false));
    }

    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final body = ListView(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(16, 8, 16, wide ? 28 : 110),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: wide ? 720 : 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(item),
                const SizedBox(height: 10),
                if (_passage != null) _buildPassage(_passage!),
                if (_passage != null) const SizedBox(height: 12),
                _buildStem(item),
                const SizedBox(height: 10),
                _buildOptions(item),
                if (!wide) ...[
                  const SizedBox(height: 12),
                  _buildHintPanel(),
                ],
                if (_result != null) ...[
                  const SizedBox(height: 12),
                  _buildResult(item),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SelectionArea(
            onSelectionChanged: (content) {
              final text = content?.plainText ?? '';
              setState(() {
                _selectionText = text;
                _selectionKind = _classify(text);
              });
            },
            contextMenuBuilder: (context, state) {
              if (_selectionText.trim().isEmpty) {
                return const SizedBox.shrink();
              }
              return buildIntentMenu(
                anchors: state.contextMenuAnchors,
                selectedText: _selectionText,
                kind: _selectionKind,
                onIntent: (intent) {
                  state.hideToolbar();
                  _ask(intent);
                },
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: _selectionText));
                  state.hideToolbar();
                },
              );
            },
            child: body,
          ),
        ),
        if (wide) ...[
          const VerticalDivider(width: 1, color: KadianColors.line),
          SizedBox(
            width: 360,
            child: Container(
              color: KadianColors.tint,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
                child: _buildHintPanel(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(ItemDef item) {
    final node = widget.services.pack.nodeById[item.nodeId];
    final cluster =
        node == null ? null : widget.services.pack.clusterById[node.clusterId];
    final subject = cluster == null
        ? ''
        : widget.services.pack.subjects
            .where((s) => s.id == cluster.subjectId)
            .map((s) => s.title)
            .join();

    return Row(
      children: [
        Flexible(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (widget.diagnostic)
                const _Pill(
                  text: '阶梯诊断',
                  color: KadianColors.warnSoft,
                  foreground: KadianColors.warn,
                ),
              if (subject.isNotEmpty)
                _Pill(text: subject, color: KadianColors.accentSoft),
              if (node != null) _Pill(text: node.title),
              if (_hintCount > 0)
                _Pill(
                  text: _explainMode ? '讲解模式' : '已用提示 $_hintCount 次',
                  color: KadianColors.warnSoft,
                  foreground: KadianColors.warn,
                ),
            ],
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _loadNext(),
          icon: const Icon(Icons.skip_next, size: 18),
          label: const Text('换一题'),
        ),
      ],
    );
  }

  Widget _buildPassage(PassageDef passage) {
    final isJa = passage.lang == 'ja';
    return _Panel(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                passage.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: KadianColors.text2,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '长按 / 拖选文字 → 意图菜单',
                  style: TextStyle(fontSize: 11, color: KadianColors.faint),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText.rich(
            TextSpan(
              text: passage.text,
              style:
                  isJa ? KadianTheme.passageJa : KadianTheme.passageEn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStem(ItemDef item) {
    return _Panel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('题目', style: KadianTheme.sectionTitle),
          const SizedBox(height: 8),
          SelectableText.rich(
            TextSpan(
              text: item.stem,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                fontWeight: FontWeight.w500,
                color: KadianColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(ItemDef item) {
    if (item.options.isEmpty) {
      return _Panel(
        child: Text('开放题：${item.answerText}', style: KadianTheme.body),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < item.options.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == item.options.length - 1 ? 0 : 8),
            child: _OptionTile(
              index: i,
              text: item.options[i],
              selected: _selected == i,
              revealed: _result != null,
              correct: i == item.answerIndex,
              onTap: _result == null ? () => setState(() => _selected = i) : null,
            ),
          ),
        if (_result == null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('提交答案'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _revealAnswer,
                child: const Text('不会，看答案'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildResult(ItemDef item) {
    final result = _result!;
    final before = (result.outcome.decayedMastery * 100).round();
    final after = (result.outcome.mastery * 100).round();
    final predicted = (result.outcome.predicted * 100).round();

    return _Panel(
      borderColor:
          result.correct ? const Color(0xFFCFE3BF) : const Color(0xFFF0C9C6),
      background:
          result.correct ? KadianColors.okSoft : KadianColors.dangerSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.correct ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: result.correct ? KadianColors.ok : KadianColors.danger,
              ),
              const SizedBox(width: 6),
              Text(
                result.correct ? '答对了' : '答错了',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: result.correct ? KadianColors.ok : KadianColors.danger,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '正确答案：${result.answerLabel}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: KadianColors.text2,
                  ),
                ),
              ),
            ],
          ),
          if (result.explain.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(result.explain, style: KadianTheme.body),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              Text(
                '掌握度 $before% → $after%',
                style: const TextStyle(
                  fontSize: 12,
                  color: KadianColors.muted,
                ),
              ),
              Text(
                '作答前预测正确率 $predicted%',
                style: const TextStyle(
                  fontSize: 12,
                  color: KadianColors.muted,
                ),
              ),
              Text(
                result.outcome.countsAsIndependent ? '计入独立区' : '计入辅助区',
                style: TextStyle(
                  fontSize: 12,
                  color: result.outcome.countsAsIndependent
                      ? KadianColors.ok
                      : KadianColors.warn,
                ),
              ),
            ],
          ),
          if (_prereqTitles.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '这道题的前置（${_prereqTitles.join('、')}）还不稳。先补前置，这题会自然通。',
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.6,
                color: KadianColors.warn,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              FilledButton(
                onPressed: () => _loadNext(),
                child: const Text('下一题'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => widget.diagnostic
                    ? Navigator.of(context).maybePop()
                    : widget.onNavigate(3),
                child: Text(widget.diagnostic ? '结束诊断' : '看等级变化'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHintPanel() {
    final hasContent = _hintText.isNotEmpty || _hintError != null;
    return _Panel(
      background: KadianColors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 16, color: KadianColors.accentInk),
              const SizedBox(width: 6),
              const Text('就地精讲', style: KadianTheme.sectionTitle),
              const Spacer(),
              if (_hintFiltered)
                const _Pill(
                  text: '已过滤答案',
                  color: KadianColors.warnSoft,
                  foreground: KadianColors.warn,
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (!hasContent && !_hintStreaming)
            const Text(
              '选中语篇里的词或句子，长按（Windows 拖选后右键）选择意图，讲解会出现在这里——不跳页。',
              style: KadianTheme.body,
            ),
          if (_hintTitle.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    _hintTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: KadianColors.accentInk,
                    ),
                  ),
                ),
                if (_hintStreaming)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 1.6),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (_hintText.isNotEmpty)
            SelectableText(
              _hintText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.75,
                color: KadianColors.text2,
              ),
            ),
          if (_hintError != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: KadianColors.warnSoft,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFF0DCBB)),
              ),
              child: Text(
                _hintError!,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.6,
                  color: KadianColors.warn,
                ),
              ),
            ),
          ],
          if (_answerRevealed && _item != null) ...[
            const SizedBox(height: 10),
            Text(
              '答案：${_item!.answerLabel}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: KadianColors.danger,
              ),
            ),
          ],
          if (hasContent) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_hintLevel < 4)
                  OutlinedButton(
                    onPressed: _hintStreaming || _lastIntent == null
                        ? null
                        : () => _ask(_lastIntent!, escalate: true),
                    child: Text('再看一层（L${(_hintLevel + 1).clamp(1, 4)}）'),
                  ),
                if (_selectionText.trim().isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: _addSelectionToReview,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('加入复习'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.text,
    required this.selected,
    required this.revealed,
    required this.correct,
    this.onTap,
  });

  final int index;
  final String text;
  final bool selected;
  final bool revealed;
  final bool correct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color border = KadianColors.line;
    Color background = KadianColors.card;
    if (selected) {
      border = KadianColors.accent;
      background = KadianColors.accentSoft;
    }
    if (revealed && correct) {
      border = const Color(0xFFB9D79B);
      background = KadianColors.okSoft;
    } else if (revealed && selected && !correct) {
      border = const Color(0xFFE3B4B1);
      background = KadianColors.dangerSoft;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected || (revealed && correct)
                    ? KadianColors.accent
                    : KadianColors.sink,
              ),
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: selected || (revealed && correct)
                      ? Colors.white
                      : KadianColors.muted,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: KadianColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    this.color = KadianColors.sink,
    this.foreground = KadianColors.muted,
  });

  final String text;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11.5, color: foreground),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.background = KadianColors.card,
    this.borderColor = KadianColors.line,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class _EmptyPractice extends StatelessWidget {
  const _EmptyPractice({required this.onReload});

  final VoidCallback onReload;

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
              const Text('题库空了', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                '当前内容包里没有可出的题。可以在设置里导入新的内容包（ZIP）。',
                textAlign: TextAlign.center,
                style: KadianTheme.body,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onReload, child: const Text('重新选题')),
            ],
          ),
        ),
      ),
    );
  }
}
