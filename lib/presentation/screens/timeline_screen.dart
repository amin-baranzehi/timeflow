import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:timeflow/core/app/app_state.dart';
import 'package:timeflow/core/database/app_database.dart';
import 'package:timeflow/core/theme/app_colors.dart';
import 'package:timeflow/shared/activity_type_view.dart';
import 'package:timeflow/shared/duration_format.dart';
import 'package:timeflow/shared/models/activity.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.watch<AppDatabase>();
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        actions: [
          IconButton(
            tooltip: 'Today',
            onPressed: context.read<AppState>().goToToday,
            icon: const Icon(Icons.today_rounded),
          ),
        ],
      ),
      body: StreamBuilder<List<Activity>>(
        stream: database.activitiesDao.watchActivitiesForDay(
          appState.selectedDate,
        ),
        builder: (context, snapshot) {
          final activities = snapshot.data ?? const <Activity>[];

          if (activities.isEmpty) {
            return Center(
              child: Text(
                'No activities for ${DateFormat('MMM d').format(appState.selectedDate)}.',
              ),
            );
          }

          final entries = _TimelineEntry.fromActivities(activities);

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            itemCount: entries.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: appState.compactTimeline ? 6 : 10),
            itemBuilder: (context, index) {
              final entry = entries[index];

              return switch (entry) {
                ActivityEntry(:final activity) => _TimelineTile(
                  activity: activity,
                  compact: appState.compactTimeline,
                ),
                GapEntry(:final start, :final end) => _GapTile(
                  start: start,
                  end: end,
                  compact: appState.compactTimeline,
                ),
              };
            },
          );
        },
      ),
    );
  }
}

sealed class _TimelineEntry {
  const _TimelineEntry();

  static List<_TimelineEntry> fromActivities(List<Activity> activities) {
    final sorted = [...activities]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final entries = <_TimelineEntry>[];

    for (var index = 0; index < sorted.length; index++) {
      if (index > 0) {
        final previousEnd = sorted[index - 1].endTime;
        final currentStart = sorted[index].startTime;

        if (previousEnd != null && currentStart.isAfter(previousEnd)) {
          entries.add(GapEntry(start: previousEnd, end: currentStart));
        }
      }

      entries.add(ActivityEntry(sorted[index]));
    }

    return entries;
  }
}

class ActivityEntry extends _TimelineEntry {
  const ActivityEntry(this.activity);

  final Activity activity;
}

class GapEntry extends _TimelineEntry {
  const GapEntry({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.activity, required this.compact});

  final Activity activity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = activity.type.accentColor;
    final endTime = activity.endTime == null
        ? 'Running'
        : DateFormat('HH:mm').format(activity.endTime!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineRail(color: color, compact: compact),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(compact ? 12 : 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      DateFormat('HH:mm').format(activity.startTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _TypePill(activity: activity),
                            Text(
                              endTime,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              formatShortDuration(activity.duration),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(activity.type.icon, color: color),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GapTile extends StatelessWidget {
  const _GapTile({
    required this.start,
    required this.end,
    required this.compact,
  });

  final DateTime start;
  final DateTime end;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final duration = end.difference(start);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineRail(color: AppColors.skyBlueLight, compact: compact),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(compact ? 10 : 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.skyBlueLight,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Untracked gap',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(formatShortDuration(duration)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.color, required this.compact});

  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(height: compact ? 42 : 58),
          Container(
            width: 1,
            height: compact ? 16 : 24,
            color: color.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final color = activity.type.accentColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          activity.type.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
