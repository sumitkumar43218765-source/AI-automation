import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../utils/notification_helper.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  HabitProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('habits');
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      _habits = jsonList.map((j) => Habit.fromJson(j)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _habits.map((h) => h.toJson()).toList();
    await prefs.setString('habits', json.encode(jsonList));
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _saveHabits();
    await NotificationHelper.scheduleReminder(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      await NotificationHelper.cancelReminder(_habits[index]);
      _habits[index] = updatedHabit;
      await _saveHabits();
      await NotificationHelper.scheduleReminder(updatedHabit);
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return; // Habit not found, no-op
    await NotificationHelper.cancelReminder(_habits[index]);
    _habits.removeAt(index);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> toggleCompletion(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final today = DateTime.now();
      final completed = List<DateTime>.from(habit.completedDates);

      final alreadyDone = habit.isCompletedForDate(today);
      if (alreadyDone) {
        completed.removeWhere((d) =>
            d.year == today.year && d.month == today.month && d.day == today.day);
      } else {
        completed.add(today);
      }

      _habits[index] = habit.copyWith(completedDates: completed);
      await _saveHabits();
      notifyListeners();
    }
  }

  int get todayCompleted {
    return _habits.where((h) => h.isCompletedForDate(DateTime.now())).length;
  }

  int get totalHabits => _habits.length;
}
