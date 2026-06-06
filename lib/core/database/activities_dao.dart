// lib/core/database/activities_dao.dart
import 'package:drift/drift.dart';

import '../../shared/models/activity.dart';
import 'app_database.dart';
import 'activities_table.dart';

part 'activities_dao.g.dart';

@DriftAccessor(tables: [Activities])
class ActivitiesDao extends DatabaseAccessor<AppDatabase>
    with _$ActivitiesDaoMixin {
  ActivitiesDao(super.db);

  /// رویدادهای یک روز مشخص، مرتب‌شده بر اساس زمان شروع.
  Stream<List<Activity>> watchActivitiesForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final query = select(activities)
      ..where(
        (t) =>
            t.startTime.isBiggerOrEqualValue(start) &
            t.startTime.isSmallerThanValue(end),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.startTime)]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// رویداد در حال اجرا (بدون endTime)، اگر وجود داشته باشد.
  Future<Activity?> getRunningActivity() async {
    final row =
        await (select(activities)
              ..where((t) => t.endTime.isNull())
              ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<int> insertActivity(Activity activity) {
    return into(activities).insert(_toCompanion(activity));
  }

  Future<int> stopActivity(int id, DateTime endTime) {
    return (update(activities)..where((t) => t.id.equals(id))).write(
      ActivitiesCompanion(endTime: Value(endTime)),
    );
  }

  Future<int> deleteActivity(int id) {
    return (delete(activities)..where((t) => t.id.equals(id))).go();
  }

  Activity _toDomain(ActivityRow row) {
    return Activity(
      id: row.id,
      title: row.title,
      type: row.type,
      startTime: row.startTime,
      endTime: row.endTime,
      note: row.note,
      createdAt: row.createdAt,
    );
  }

  ActivitiesCompanion _toCompanion(Activity a) {
    return ActivitiesCompanion(
      id: a.id == null ? const Value.absent() : Value(a.id!),
      title: Value(a.title),
      type: Value(a.type),
      startTime: Value(a.startTime),
      endTime: Value(a.endTime),
      note: Value(a.note),
      createdAt: Value(a.createdAt),
    );
  }
}
