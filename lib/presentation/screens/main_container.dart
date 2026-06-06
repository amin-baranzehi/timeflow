// lib/presentation/screens/main_container.dart
import 'package:flutter/material.dart';
import 'package:timeflow/features/time_tracker/screens/tracker_screen.dart';
import 'package:timeflow/features/time_tracker/widgets/new_activity_sheet.dart';

import 'timeline_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const TrackerScreen(),
    const TimelineScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'TimeFlow',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _DrawerItem(
                icon: Icons.play_circle_outline,
                label: 'Tracker',
                selected: _selectedIndex == 0,
                onTap: () => _selectFromDrawer(0),
              ),
              _DrawerItem(
                icon: Icons.timeline_outlined,
                label: 'Timeline',
                selected: _selectedIndex == 1,
                onTap: () => _selectFromDrawer(1),
              ),
              _DrawerItem(
                icon: Icons.bar_chart_outlined,
                label: 'Analytics',
                selected: _selectedIndex == 2,
                onTap: () => _selectFromDrawer(2),
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                selected: _selectedIndex == 3,
                onTap: () => _selectFromDrawer(3),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.015),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'New activity',
        onPressed: () => showNewActivitySheet(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle),
              label: 'Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined),
              activeIcon: Icon(Icons.timeline),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _selectFromDrawer(int index) {
    Navigator.of(context).pop();
    _onItemTapped(index);
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}
