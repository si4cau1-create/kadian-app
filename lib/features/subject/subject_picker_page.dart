import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/settings/settings_store.dart';
import '../../core/subject/subject.dart';

/// 首次启动的学科选择闸门。
///
/// 单学科实例：一个档案只服务一个学科，等级、证据、成就、词库都只在该
/// 学科的目录下沉淀。未选择学科时不允许进入学习界面，避免产生混合档案。
class SubjectPickerPage extends ConsumerStatefulWidget {
  const SubjectPickerPage({super.key, required this.settings});

  final SettingsStore settings;

  @override
  ConsumerState<SubjectPickerPage> createState() => _SubjectPickerPageState();
}

class _SubjectPickerPageState extends ConsumerState<SubjectPickerPage> {
  Subject? _picking;

  Future<void> _choose(Subject subject) async {
    if (_picking != null) return;
    setState(() => _picking = subject);
    widget.settings.subject = subject;
    // 整条服务栈按新学科重建：内容包、数据库路径、成就定义全部换掉
    ref.invalidate(bootProvider);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      backgroundColor: KadianColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '卡点',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: KadianColors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '先确定这一档要学哪一科。',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: KadianColors.text2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '一个档案只学一个学科：证据、等级、成就、词库都独立存放，'
                    '不会互相污染。之后可以在设置里切换，另一科的进度会原样保留。',
                    style: KadianTheme.body.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 26),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _card(Subject.japanese)),
                        const SizedBox(width: 14),
                        Expanded(child: _card(Subject.english)),
                      ],
                    )
                  else ...[
                    _card(Subject.japanese),
                    const SizedBox(height: 14),
                    _card(Subject.english),
                  ],
                  const SizedBox(height: 22),
                  const Row(
                    children: [
                      Icon(Icons.lock_outline,
                          size: 14, color: KadianColors.faint),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '选择后不可在本档案内混入另一学科；复习、诊断、成就都只在本学科图谱内进行。',
                          style: TextStyle(
                            fontSize: 12,
                            color: KadianColors.faint,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(Subject subject) {
    final busy = _picking == subject;
    final disabled = _picking != null && !busy;

    return Material(
      color: KadianColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled || busy ? null : () => _choose(subject),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: busy ? KadianColors.accent : KadianColors.line,
              width: busy ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    subject.label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: KadianColors.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: KadianColors.accentSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      subject == Subject.japanese ? 'N3' : 'B1',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: KadianColors.accentInk,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                subject == Subject.japanese
                    ? '语法 / 词汇 / 阅读 / 听力 / 写作，五条轨道一起算等级。'
                    : '阅读为主线，语法与分词作支撑，按信息量选下一题。',
                style: KadianTheme.body.copyWith(height: 1.6),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '选择${subject.label} →',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: KadianColors.accentInk,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
