import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/providers.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/app_info.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, required this.services});

  final AppServices services;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _proxy;
  late final TextEditingController _token;
  late final TextEditingController _byokBase;
  late final TextEditingController _byokKey;
  late final TextEditingController _byokModel;
  late final TextEditingController _packPath;

  bool _testing = false;
  String _testResult = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final settings = widget.services.settings;
    _proxy = TextEditingController(text: settings.proxyBaseUrl);
    _token = TextEditingController(text: settings.deviceToken);
    _byokBase = TextEditingController(text: settings.byokBaseUrl);
    _byokKey = TextEditingController(text: settings.byokApiKey);
    _byokModel = TextEditingController(text: settings.byokModel);
    _packPath = TextEditingController();
  }

  @override
  void dispose() {
    _proxy.dispose();
    _token.dispose();
    _byokBase.dispose();
    _byokKey.dispose();
    _byokModel.dispose();
    _packPath.dispose();
    super.dispose();
  }

  void _saveNetwork() {
    final settings = widget.services.settings;
    settings.proxyBaseUrl = _proxy.text;
    settings.deviceToken = _token.text;
    settings.byokBaseUrl = _byokBase.text;
    settings.byokApiKey = _byokKey.text;
    settings.byokModel = _byokModel.text;
    widget.services.llm.updateConfig(settings.proxyConfig);
    _snack('已保存。攻略请求会走新配置。');
    setState(() {});
  }

  Future<void> _test() async {
    _saveNetwork();
    setState(() {
      _testing = true;
      _testResult = '';
    });
    final ok = await widget.services.llm.health();
    if (!mounted) return;
    setState(() {
      _testing = false;
      _testResult = ok ? '代理可达（/healthz 200）' : '连不上代理：检查地址、令牌与网络';
    });
  }

  Future<void> _importPack() async {
    final path = _packPath.text.trim();
    if (path.isEmpty) {
      _snack('先填内容包 ZIP 的绝对路径');
      return;
    }
    setState(() => _busy = true);
    try {
      final loaded = await widget.services.packService.installZip(path);
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('内容包 ${loaded.pack.manifest.version} 安装成功，重启后生效');
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('安装失败：$error');
    }
  }

  Future<void> _rollbackPack() async {
    await widget.services.packService.rollback();
    if (!mounted) return;
    _snack('已回滚到内置内容包，重启后生效');
  }

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final data = await widget.services.db.exportAll();
      final dir = await getApplicationDocumentsDirectory();
      final stamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '')
          .split('.')
          .first;
      final file = File(p.join(dir.path, 'kadian-export-$stamp.json'));
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('已导出到 ${file.path}');
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('导出失败：$error');
    }
  }

  Future<void> _wipe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除全部本地数据？'),
        content: const Text(
          '证据、等级、成就、复习进度会全部清空，无法撤销。\n'
          '内容包不受影响。建议先导出备份。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: KadianColors.danger,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.services.db.wipeAll();
    if (!mounted) return;
    ref.read(refreshTickProvider.notifier).state++;
    _snack('已清空本地数据');
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services;
    final settings = services.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Section(
                    title: '在线攻略（LLM 代理）',
                    description:
                        '客户端不存 Provider Key。所有攻略请求经你自己的代理服务转发，'
                        '代理只做鉴权限流与转发，不落等级数据。',
                    children: [
                      _Field(
                        controller: _proxy,
                        label: '代理地址',
                        hint: 'https://your-proxy.example.com',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 10),
                      _Field(
                        controller: _token,
                        label: '设备令牌',
                        hint: '由代理 /v1/auth/anonymous 下发',
                        obscure: true,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilledButton(onPressed: _saveNetwork, child: const Text('保存')),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _testing ? null : _test,
                            child: Text(_testing ? '测试中…' : '测试连接'),
                          ),
                        ],
                      ),
                      if (_testResult.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _testResult,
                          style: TextStyle(
                            fontSize: 12,
                            color: _testResult.startsWith('代理可达')
                                ? KadianColors.ok
                                : KadianColors.warn,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: '自带 Key（BYOK，默认关闭）',
                    description:
                        '开启后攻略直连你自己的模型服务，不经过代理。Key 存在本机；'
                        '真实分发版本应写入 Android Keystore / Windows DPAPI，'
                        '当前为 SharedPreferences 明文，风险自担。',
                    children: [
                      _Field(
                        controller: _byokBase,
                        label: 'OpenAI 兼容地址',
                        hint: 'https://api.example.com/v1',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 10),
                      _Field(
                        controller: _byokKey,
                        label: 'API Key',
                        hint: 'sk-...',
                        obscure: true,
                      ),
                      const SizedBox(height: 10),
                      _Field(
                        controller: _byokModel,
                        label: '模型名',
                        hint: '例如 gpt-4o-mini',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        services.llm.config.byokEnabled
                            ? '当前：BYOK 已启用（攻略直连）'
                            : '当前：走代理',
                        style: TextStyle(
                          fontSize: 12,
                          color: services.llm.config.byokEnabled
                              ? KadianColors.warn
                              : KadianColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: '内容包',
                    description:
                        '题库、图谱、成就定义与校准参数都在内容包里，可单独 OTA；'
                        '算法随客户端版本发布。安装失败会自动回滚到上一版。',
                    children: [
                      _KeyValue('当前包', services.pack.manifest.packId),
                      _KeyValue('版本', services.pack.manifest.version),
                      _KeyValue(
                        '来源',
                        services.loaded.source == 'asset' ? '内置' : services.loaded.source,
                      ),
                      _KeyValue(
                        '校验',
                        services.loaded.validation.ok ? '通过' : '有错误',
                      ),
                      _KeyValue('最低客户端', services.pack.manifest.minAppVersion),
                      const SizedBox(height: 10),
                      _Field(
                        controller: _packPath,
                        label: 'ZIP 绝对路径',
                        hint: 'D:\\pack\\kadian-base-2026.12.zip',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: _busy ? null : _importPack,
                            child: const Text('导入内容包'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _rollbackPack,
                            child: const Text('回滚到内置'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: '隐私与数据',
                    description:
                        '作答原文默认不出设备。诊断上传仅在你打开开关后，'
                        '随攻略请求带上局部的等级摘要（不含原始事件）。',
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: settings.uploadDiagnostics,
                        onChanged: (value) {
                          setState(() => settings.uploadDiagnostics = value);
                        },
                        title: const Text(
                          '允许上传诊断上下文',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Text(
                          '关闭时，攻略请求只带选中文本与题目，不带任何统计数据。',
                          style: TextStyle(fontSize: 11.5),
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: settings.encryptDb,
                        onChanged: (value) {
                          setState(() => settings.encryptDb = value);
                          _snack('DB 加密需要 SQLCipher 变体，当前版本仅记录偏好，重启不生效');
                        },
                        title: const Text(
                          '本地数据库加密（预留）',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Text(
                          '写作原文、录音等敏感数据建议开启；需换成 SQLCipher 构建。',
                          style: TextStyle(fontSize: 11.5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _busy ? null : _export,
                            icon: const Icon(Icons.download_outlined, size: 17),
                            label: const Text('导出全部数据'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: KadianColors.danger,
                              side: const BorderSide(color: Color(0xFFE3B4B1)),
                            ),
                            onPressed: _wipe,
                            icon: const Icon(Icons.delete_outline, size: 17),
                            label: const Text('清空本地数据'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: '关于',
                    description: '卡点 · 本地优先的做题流学习工具',
                    children: [
                      const _KeyValue('客户端', 'v$kAppVersion ($kAppBuild)'),
                      const _KeyValue('包名', kAppId),
                      _KeyValue('校准引擎', services.params.engineVersion),
                      _KeyValue('数据库 schema', 'v${services.db.schemaVersion}'),
                      _KeyValue(
                        '题目 / 词条',
                        '${services.pack.items.length} / ${services.pack.vocab.length}',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '等级、证据、校准、成就全部在本机 SQLite 里；'
                        '网络只用于攻略。数据可导出、可删除。',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.6,
                          color: KadianColors.faint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: KadianColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.6,
              color: KadianColors.faint,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: KadianColors.faint),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: KadianColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
