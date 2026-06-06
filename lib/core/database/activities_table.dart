// lib/core/database/activities_table.dart
import 'package:drift/drift.dart';

import '../../shared/models/activity_type.dart';

@DataClassName('ActivityRow')
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get type => textEnum<ActivityType>()();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get endTime => dateTime().nullable()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}
