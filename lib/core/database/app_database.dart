// lib/core/database/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'activities_table.dart';
import '../../shared/models/activity_type.dart';
import 'activities_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Activities], daos: [ActivitiesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'timeflow.db'));
    return NativeDatabase(file);
  });
}
