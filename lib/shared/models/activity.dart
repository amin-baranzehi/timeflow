// lib/shared/models/activity.dart
import 'activity_type.dart';

class Activity {
  final int? id;
  final String title;
  final ActivityType type;
  final DateTime startTime;
  final DateTime? endTime;
  final String? note;
  final DateTime createdAt;

  const Activity({
    this.id,
    required this.title,
    required this.type,
    required this.startTime,
    this.endTime,
    this.note,
    required this.createdAt,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  bool get isRunning => endTime == null;

  Activity copyWith({
    int? id,
    String? title,
    ActivityType? type,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
