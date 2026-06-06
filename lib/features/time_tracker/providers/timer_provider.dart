import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../shared/models/activity.dart';

class TimerProvider extends ChangeNotifier {
  Activity? _runningActivity;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  // Getters
  Activity? get runningActivity => _runningActivity;
  Duration get elapsed => _elapsed;
  bool get isRunning => _runningActivity != null;

  void startTracking(Activity activity) {
    _runningActivity = activity;
    _updateElapsed();
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateElapsed();
    });

    notifyListeners();
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _runningActivity = null;
    _elapsed = Duration.zero;
    notifyListeners();
  }

  void _updateElapsed() {
    if (_runningActivity != null) {
      _elapsed = DateTime.now().difference(_runningActivity!.startTime);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
