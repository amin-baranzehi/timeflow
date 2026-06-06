import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:timeflow/core/app/app_state.dart';
import 'package:timeflow/core/database/app_database.dart';
import 'package:timeflow/core/theme/app_colors.dart';
import 'package:timeflow/features/time_tracker/providers/timer_provider.dart';
import 'package:timeflow/features/time_tracker/widgets/new_activity_sheet.dart';
import 'package:timeflow/shared/duration_format.dart';
import 'package:timeflow/shared/models/activity.dart';
import 'package:timeflow/shared/models/activity_type.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.watch<AppDatabase>();
    final selectedDate = context.watch<AppState>().selectedDate;

    return SafeArea(
      child: StreamBuilder<List<Activity>>(
        stream: database.activitiesDao.watchActivitiesForDay(selectedDate),
        builder: (context, snapshot) {
          final activities = snapshot.data ?? const <Activity>[];

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                sliver: SliverList.list(
                  children: [
                    const _TopBar(),
                    const SizedBox(height: 22),
                    _DateHeader(date: selectedDate),
                    const SizedBox(height: 18),
                    _StatsGrid(activities: activities),
                    const SizedBox(height: 18),
                    const _TimerPanel(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Menu',
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu_rounded),
        ),
        const Spacer(),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
            children: const [
              TextSpan(text: 'Time'),
              TextSpan(
                text: 'Flow',
                style: TextStyle(color: AppColors.goldenYellow),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Calendar',
          onPressed: () => _pickDate(context),
          icon: const Icon(Icons.calendar_month_rounded),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Previous day',
          onPressed: () => appState.shiftSelectedDate(-1),
          icon: const Icon(Icons.chevron_left_rounded, size: 30),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => _pickDate(context),
          child: Column(
            children: [
              Text(
                DateFormat('MMM d, y').format(date),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('EEEE').format(date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Next day',
          onPressed: () => appState.shiftSelectedDate(1),
          icon: const Icon(Icons.chevron_right_rounded, size: 30),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.activities});

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    final focus = activities
        .where((a) => a.type == ActivityType.work)
        .fold(Duration.zero, (total, a) => total + a.duration);
    final breaks = activities
        .where((a) => a.type == ActivityType.break_)
        .fold(Duration.zero, (total, a) => total + a.duration);
    final runningCount = activities.where((a) => a.isRunning).length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: [
        _StatCard(
          icon: Icons.timer_outlined,
          color: AppColors.skyBlue,
          value: formatShortDuration(focus),
          label: 'Focus Time',
        ),
        _StatCard(
          icon: Icons.coffee_outlined,
          color: AppColors.vibrantOrange,
          value: formatShortDuration(breaks),
          label: 'Break Time',
        ),
        _StatCard(
          icon: Icons.bolt_outlined,
          color: AppColors.goldenYellow,
          value: '$runningCount',
          label: 'Running',
        ),
        _StatCard(
          icon: Icons.event_note_outlined,
          color: AppColors.skyBlueLight,
          value: '${activities.length}',
          label: 'Events',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _TimerPanel extends StatelessWidget {
  const _TimerPanel();

  Future<void> _stopActivity(BuildContext context) async {
    final database = context.read<AppDatabase>();
    final timerProvider = context.read<TimerProvider>();
    final running = timerProvider.runningActivity;

    if (running?.id == null) return;

    await database.activitiesDao.stopActivity(running!.id!, DateTime.now());
    timerProvider.stopTracking();
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final running = timer.runningActivity;
    final isRunning = timer.isRunning;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRunning ? running!.title : 'Ready for a new activity',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                formatClockDuration(timer.elapsed),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: isRunning
                  ? () => _stopActivity(context)
                  : () => showNewActivitySheet(context),
              icon: Icon(isRunning ? Icons.stop_rounded : Icons.add_rounded),
              label: Text(isRunning ? 'Stop Activity' : 'New Activity'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _pickDate(BuildContext context) async {
  final appState = context.read<AppState>();
  final picked = await showDatePicker(
    context: context,
    initialDate: appState.selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );

  if (picked == null) return;
  appState.selectDate(picked);
}
