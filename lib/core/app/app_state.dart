import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  DateTime _selectedDate = _dateOnly(DateTime.now());
  bool _smartReminders = true;
  bool _autoStopLongSessions = false;
  bool _compactTimeline = false;
  double _dailyGoalHours = 6;
  double _minGapMinutes = 2.0;

  ThemeMode get themeMode => _themeMode;
  DateTime get selectedDate => _selectedDate;
  bool get smartReminders => _smartReminders;
  bool get autoStopLongSessions => _autoStopLongSessions;
  bool get compactTimeline => _compactTimeline;
  double get dailyGoalHours => _dailyGoalHours;
  double get minGapMinutes => _minGapMinutes;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
  }

  void setMinGapMinutes(double value) {
    if (_minGapMinutes == value) return;
    _minGapMinutes = value;
    notifyListeners();
  }

  void selectDate(DateTime value) {
    final date = _dateOnly(value);
    if (_selectedDate == date) return;
    _selectedDate = date;
    notifyListeners();
  }

  void shiftSelectedDate(int days) {
    selectDate(_selectedDate.add(Duration(days: days)));
  }

  void goToToday() {
    selectDate(DateTime.now());
  }

  void setSmartReminders(bool value) {
    _smartReminders = value;
    notifyListeners();
  }

  void setAutoStopLongSessions(bool value) {
    _autoStopLongSessions = value;
    notifyListeners();
  }

  void setCompactTimeline(bool value) {
    _compactTimeline = value;
    notifyListeners();
  }

  void setDailyGoalHours(double value) {
    _dailyGoalHours = value;
    notifyListeners();
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
