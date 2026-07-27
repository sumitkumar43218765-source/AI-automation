import 'package:flutter/material.dart';

enum ColorOption {
  blue,
  green,
  red,
  purple,
  orange,
  teal,
}

class Habit {
  final String id;
  final String name;
  final String description;
  final TimeOfDay reminderTime;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final ColorOption color;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.reminderTime,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    this.color = ColorOption.blue,
  })  : completedDates = completedDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  bool isCompletedForDate(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  int get streak {
    if (completedDates.isEmpty) return 0;
    DateTime check = DateTime.now();
    check = DateTime(check.year, check.month, check.day);

    if (!isCompletedForDate(check)) {
      check = check.subtract(const Duration(days: 1));
      if (!isCompletedForDate(check)) return 0;
    }

    int count = 0;
    while (isCompletedForDate(check)) {
      count++;
      check = check.subtract(const Duration(days: 1));
    }
    return count;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'reminderHour': reminderTime.hour,
      'reminderMinute': reminderTime.minute,
      'completedDates':
          completedDates.map((d) => d.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'color': color.index,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      reminderTime: TimeOfDay(
        hour: json['reminderHour'] ?? 9,
        minute: json['reminderMinute'] ?? 0,
      ),
      completedDates: (json['completedDates'] as List?)
              ?.map((d) => DateTime.parse(d))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      color: ColorOption.values[json['color'] ?? 0],
    );
  }

  Habit copyWith({
    String? name,
    String? description,
    TimeOfDay? reminderTime,
    List<DateTime>? completedDates,
    ColorOption? color,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt,
      color: color ?? this.color,
    );
  }
}
