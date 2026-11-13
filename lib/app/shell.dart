import 'package:flutter/material.dart';

import '../core/app_info.dart';
import '../features/achievements/achievements_page.dart';
import '../features/level/level_page.dart';
import '../features/practice/practice_page.dart';
import '../features/settings/settings_page.dart';
import '../features/today/today_page.dart';
import '../features/vocab_review/review_page.dart';
import 'services.dart';
import 'theme.dart';

/// 应用外壳：窄屏底部胶囊导航，≥900px 自动换成左侧导航栏。
///
/// 桌面端不是「把手机界面拉宽」：导航左置、内容限宽、余量留白。
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.services});

  final AppServices services;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['今日', '做题', '复习', '等级', '成就'];

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final pages = [
      TodayPage(services: widget.services, onNavigate: _goTo),
      PracticePage(services: widget.services, onNavigate: _goTo),
      ReviewPage(services: widget.services),
      LevelPage(services: widget.services),
      AchievementsPage(services: widget.services),
    ];

    final content = IndexedStack(index: _index, children: pages);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_titles[_index]),
            const SizedBox(width: 10),
            if (_index == 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: KadianColors.accentSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '本地优先 · v$kAppVersion',
                  style: TextStyle(
                    fontSize: 11,
                    color: KadianColors.accentInk,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '设置',
            icon: const Icon(Icons.settings_outlined, size: 21),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SettingsPage(services: widget.services),
              ));
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: _goTo,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 18),
                    child: Text(
                      '卡点',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                        color: KadianColors.text,
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.wb_sunny_outlined),
                      selectedIcon: Icon(Icons.wb_sunny),
                      label: Text('今日'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_note_outlined),
                      selectedIcon: Icon(Icons.edit_note),
                      label: Text('做题'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.refresh_outlined),
                      selectedIcon: Icon(Icons.refresh),
                      label: Text('复习'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights),
                      label: Text('等级'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events),
                      label: Text('成就'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, color: KadianColors.line),
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _goTo,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.wb_sunny_outlined),
                  selectedIcon: Icon(Icons.wb_sunny),
                  label: '今日',
                ),
                NavigationDestination(
                  icon: Icon(Icons.edit_note_outlined),
                  selectedIcon: Icon(Icons.edit_note),
                  label: '做题',
                ),
                NavigationDestination(
                  icon: Icon(Icons.refresh_outlined),
                  selectedIcon: Icon(Icons.refresh),
                  label: '复习',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: '等级',
                ),
                NavigationDestination(
                  icon: Icon(Icons.emoji_events_outlined),
                  selectedIcon: Icon(Icons.emoji_events),
                  label: '成就',
                ),
              ],
            ),
    );
  }
}
