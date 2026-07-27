import '../models/habit.dart';

/// Stub implementation for non-web platforms (mobile/desktop).
/// Notifications on mobile should use flutter_local_notifications.
class WebNotificationHelper {
  static void requestPermission() {}
  static void schedule(Habit habit) {}
  static void cancel(Habit habit) {}
  static void cancelAll() {}
}
