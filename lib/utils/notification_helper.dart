import 'package:flutter/foundation.dart';
import '../models/habit.dart';

// Conditional import: web → dart:html notifications, mobile → stub
import 'notification_helper_stub.dart'
    if (dart.library.html) 'notification_helper_web.dart'
    if (dart.library.js_interop) 'notification_helper_web.dart';

class NotificationHelper {
  static Future<void> initialize() async {
    if (kIsWeb) {
      try {
        WebNotificationHelper.requestPermission();
      } catch (_) {}
    }
  }

  static Future<void> requestPermissions() async {
    if (kIsWeb) {
      try {
        WebNotificationHelper.requestPermission();
      } catch (_) {}
    }
  }

  static Future<void> scheduleReminder(Habit habit) async {
    if (kIsWeb) {
      try {
        WebNotificationHelper.schedule(habit);
      } catch (_) {}
    }
  }

  static Future<void> cancelReminder(Habit habit) async {
    if (kIsWeb) {
      try {
        WebNotificationHelper.cancel(habit);
      } catch (_) {}
    }
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) {
      try {
        WebNotificationHelper.cancelAll();
      } catch (_) {}
    }
  }
}
