import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_info.dart';
import 'providers.dart';
import 'shell.dart';
import 'theme.dart';

class KadianApp extends StatelessWidget {
  const KadianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: KadianTheme.light(),
      home: const BootstrapGate(),
    );
  }
}

/// 启动闸门：装配本地服务 → 首页。
/// 装配失败会给出可读原因（内容包/数据库问题都在这里暴露），而不是白屏。
class BootstrapGate extends ConsumerWidget {
  const BootstrapGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    return services.when(
      loading: () => const _SplashScreen(),
      error: (error, stack) => _BootstrapError(
        message: '$error',
        onRetry: () => ref.invalidate(servicesProvider),
      ),
      data: (value) => HomeShell(services: value),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '卡点',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: KadianColors.text,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '正在装载本地题库与等级',
              style: TextStyle(fontSize: 13, color: KadianColors.muted),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _BootstrapError extends StatelessWidget {
  const _BootstrapError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本地服务没起来',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(message, style: KadianTheme.body),
                const SizedBox(height: 18),
                FilledButton(onPressed: onRetry, child: const Text('重试')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
