import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeflow/core/app/app_state.dart';
import 'package:timeflow/core/database/app_database.dart';
import 'package:timeflow/core/theme/app_colors.dart';
import 'package:timeflow/shared/activity_type_view.dart';
import 'package:timeflow/shared/duration_format.dart';
import 'package:timeflow/shared/models/activity.dart';
import 'package:timeflow/shared/models/activity_type.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.watch<AppDatabase>();
    final selectedDate = context.watch<AppState>().selectedDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: StreamBuilder<List<Activity>>(
        stream: database.activitiesDao.watchActivitiesForDay(selectedDate),
        builder: (context, snapshot) {
          final activities = snapshot.data ?? const <Activity>[];
          final stats = _DayStats.fromActivities(activities);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _HeroMetric(stats: stats),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.track_changes_rounded,
                      label: 'Focus Ratio',
                      value: '${stats.focusRatio}%',
                      color: AppColors.skyBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.event_available_rounded,
                      label: 'Sessions',
                      value: '${activities.length}',
                      color: AppColors.goldenYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _BreakdownCard(stats: stats),
              const SizedBox(height: 14),
              _LongestActivityCard(activity: stats.longestActivity),
            ],
          );
        },
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.stats});

  final _DayStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              formatShortDuration(stats.total),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: ActivityType.values
                      .map((type) {
                        final value = stats.durationFor(type).inSeconds;
                        final flex = value == 0 ? 0 : value;

                        return Expanded(
                          flex: flex,
                          child: ColoredBox(color: type.accentColor),
                        );
                      })
                      .where((segment) => segment.flex > 0)
                      .toList(),
                ),
              ),
            ),
            if (stats.total == Duration.zero)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Track your first activity to see insights here.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.stats});

  final _DayStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            ...ActivityType.values.map((type) {
              final duration = stats.durationFor(type);
              final ratio = stats.total == Duration.zero
                  ? 0.0
                  : duration.inSeconds / stats.total.inSeconds;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(type.icon, color: type.accentColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(type.label)),
                        Text(formatShortDuration(duration)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor: Theme.of(context).colorScheme.outline,
                        color: type.accentColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LongestActivityCard extends StatelessWidget {
  const _LongestActivityCard({required this.activity});

  final Activity? activity;

  @override
  Widget build(BuildContext context) {
    final activity = this.activity;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              activity?.type.icon ?? Icons.emoji_events_outlined,
              color: activity?.type.accentColor ?? AppColors.goldenYellow,
              size: 34,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity?.title ?? 'No longest session yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity == null
                        ? 'Your best session will appear here.'
                        : 'Longest today: ${formatShortDuration(activity.duration)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayStats {
  const _DayStats({
    required this.total,
    required this.byType,
    required this.longestActivity,
  });

  final Duration total;
  final Map<ActivityType, Duration> byType;
  final Activity? longestActivity;

  int get focusRatio {
    if (total == Duration.zero) return 0;
    return (durationFor(ActivityType.work).inSeconds / total.inSeconds * 100)
        .round();
  }

  Duration durationFor(ActivityType type) {
    return byType[type] ?? Duration.zero;
  }

  factory _DayStats.fromActivities(List<Activity> activities) {
    final byType = {
      for (final type in ActivityType.values) type: Duration.zero,
    };
    Activity? longest;

    for (final activity in activities) {
      byType[activity.type] = byType[activity.type]! + activity.duration;

      if (longest == null || activity.duration > longest.duration) {
        longest = activity;
      }
    }

    final total = byType.values.fold(
      Duration.zero,
      (sum, duration) => sum + duration,
    );

    return _DayStats(total: total, byType: byType, longestActivity: longest);
  }
}
