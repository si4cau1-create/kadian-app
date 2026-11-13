import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/selection/selection_intent.dart';

/// 长按/右键选中后弹出的意图菜单。
///
/// Android 与 Windows 共用一套：菜单项按选中类型过滤，
/// 不用系统默认工具栏（Android 13+ 会与自定义菜单打架）。
Widget buildIntentMenu({
  required TextSelectionToolbarAnchors anchors,
  required String selectedText,
  required SelectionKind kind,
  required ValueChanged<HintIntent> onIntent,
  required VoidCallback onCopy,
}) {
  const classifier = SelectionClassifier();
  final intents = classifier.intentsFor(kind);
  final preview = selectedText.length > 24
      ? '${selectedText.substring(0, 24)}…'
      : selectedText;

  return AdaptiveTextSelectionToolbar(
    anchors: anchors,
    children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Material(
          color: KadianColors.card,
          elevation: 6,
          shadowColor: const Color(0x1A000000),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      classifier.labelOf(kind),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: KadianColors.accentInk,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: KadianColors.faint,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final intent in intents)
                      _IntentButton(
                        intent: intent,
                        onTap: () => onIntent(intent),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      foregroundColor: KadianColors.muted,
                    ),
                    onPressed: onCopy,
                    child: const Text('复制', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _IntentButton extends StatelessWidget {
  const _IntentButton({required this.intent, required this.onTap});

  final HintIntent intent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: KadianColors.accentSoft,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFCFE3F7)),
        ),
        child: Text(
          intent.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: KadianColors.accentInk,
          ),
        ),
      ),
    );
  }
}
