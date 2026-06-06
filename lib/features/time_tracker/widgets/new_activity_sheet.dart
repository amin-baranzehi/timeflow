import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeflow/core/database/app_database.dart';
import 'package:timeflow/features/time_tracker/providers/timer_provider.dart';
import 'package:timeflow/shared/activity_type_view.dart';
import 'package:timeflow/shared/models/activity.dart';
import 'package:timeflow/shared/models/activity_type.dart';

Future<void> showNewActivitySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: context.read<AppDatabase>()),
        ChangeNotifierProvider<TimerProvider>.value(
          value: context.read<TimerProvider>(),
        ),
      ],
      child: const NewActivitySheet(),
    ),
  );
}

class NewActivitySheet extends StatefulWidget {
  const NewActivitySheet({super.key});

  @override
  State<NewActivitySheet> createState() => _NewActivitySheetState();
}

class _NewActivitySheetState extends State<NewActivitySheet> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  ActivityType _selectedType = ActivityType.work;

  @override
  void initState() {
    super.initState();
    _titleController.text = _selectedType.defaultTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _startActivity() async {
    final database = context.read<AppDatabase>();
    final timerProvider = context.read<TimerProvider>();
    final now = DateTime.now();
    final title = _titleController.text.trim().isEmpty
        ? _selectedType.defaultTitle
        : _titleController.text.trim();
    final note = _noteController.text.trim();

    final activity = Activity(
      title: title,
      type: _selectedType,
      startTime: now,
      note: note.isEmpty ? null : note,
      createdAt: now,
    );

    final insertedId = await database.activitiesDao.insertActivity(activity);
    timerProvider.startTracking(activity.copyWith(id: insertedId));

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = context.watch<TimerProvider>().isRunning;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'New Activity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            enabled: !isRunning,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            enabled: !isRunning,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Note',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ActivityType.values.map((type) {
              final selected = _selectedType == type;

              return ChoiceChip(
                selected: selected,
                label: Text(type.label),
                avatar: Icon(type.icon, size: 18),
                onSelected: isRunning
                    ? null
                    : (_) {
                        setState(() {
                          _selectedType = type;
                          if (_titleController.text.trim().isEmpty ||
                              ActivityType.values.any(
                                (item) =>
                                    _titleController.text == item.defaultTitle,
                              )) {
                            _titleController.text = type.defaultTitle;
                          }
                        });
                      },
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: isRunning ? null : _startActivity,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(isRunning ? 'Activity Already Running' : 'Start'),
          ),
        ],
      ),
    );
  }
}
