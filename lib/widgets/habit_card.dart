import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getColor() {
    switch (habit.color) {
      case ColorOption.blue:
        return Colors.blue;
      case ColorOption.green:
        return Colors.green;
      case ColorOption.red:
        return Colors.red;
      case ColorOption.purple:
        return Colors.purple;
      case ColorOption.orange:
        return Colors.orange;
      case ColorOption.teal:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedForDate(DateTime.now());
    final color = _getColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted ? color : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? Colors.grey : null,
                    ),
                  ),
                  if (habit.description.isNotEmpty)
                    Text(
                      habit.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        habit.reminderTime.format(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: habit.streak > 0 ? Colors.orange : Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.streak} day${habit.streak == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: habit.streak > 0 ? Colors.orange : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
