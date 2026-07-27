import 'dart:html' as html;
import '../models/habit.dart';

/// Web implementation using browser Notification API.
class _WebNotificationHelper {
  static final Map<String, int> _timers = {};

  static void requestPermission() {
    try {
      if (html.Notification.permission == 'default') {
        html.Notification.requestPermission();
      }
    } catch (_) {}
  }

  static void schedule(Habit habit) {
    cancel(habit);

    final now = DateTime.now();
    var scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime.hour,
      habit.reminderTime.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final delay = scheduled.difference(now).inMilliseconds;

    final timerId = html.window.setTimeout(() {
      _show('Habit Reminder', 'Time to complete: ${habit.name}');
      schedule(habit); // Reschedule for next day
    }, delay);

    _timers[habit.id] = timerId;
  }

  static void _show(String title, String body) {
    try {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body);
      }
    } catch (_) {}
  }

  static void cancel(Habit habit) {
    if (_timers.containsKey(habit.id)) {
      html.window.clearTimeout(_timers[habit.id]);
      _timers.remove(habit.id);
    }
  }

  static void cancelAll() {
    for (final id in _timers.keys.toList()) {
      html.window.clearTimeout(_timers[id]);
    }
    _timers.clear();
  }
}
