import 'package:flutter/material.dart';

import 'models/activity_type.dart';

extension ActivityTypeView on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.work:
        return 'Work';
      case ActivityType.break_:
        return 'Break';
      case ActivityType.meeting:
        return 'Meeting';
      case ActivityType.personal:
        return 'Personal';
      case ActivityType.other:
        return 'Other';
    }
  }

  String get defaultTitle {
    switch (this) {
      case ActivityType.work:
        return 'Focus Session';
      case ActivityType.break_:
        return 'Break';
      case ActivityType.meeting:
        return 'Meeting';
      case ActivityType.personal:
        return 'Personal Time';
      case ActivityType.other:
        return 'Activity';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.work:
        return Icons.code_rounded;
      case ActivityType.break_:
        return Icons.coffee_rounded;
      case ActivityType.meeting:
        return Icons.groups_rounded;
      case ActivityType.personal:
        return Icons.self_improvement_rounded;
      case ActivityType.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case ActivityType.work:
        return const Color(0xFF55D98B);
      case ActivityType.break_:
        return const Color(0xFFF97316);
      case ActivityType.meeting:
        return const Color(0xFF4A9EFF);
      case ActivityType.personal:
        return const Color(0xFFFFB800);
      case ActivityType.other:
        return const Color(0xFF38BDF8);
    }
  }
}
