import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitDialog extends StatefulWidget {
  final Habit? existingHabit;

  const AddHabitDialog({super.key, this.existingHabit});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TimeOfDay _selectedTime;
  late ColorOption _selectedColor;

  bool get isEditing => widget.existingHabit != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingHabit?.name ?? '');
    _descController =
        TextEditingController(text: widget.existingHabit?.description ?? '');
    _selectedTime = widget.existingHabit?.reminderTime ??
        const TimeOfDay(hour: 9, minute: 0);
    _selectedColor = widget.existingHabit?.color ?? ColorOption.blue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = TimeOfDay(hour: time.hour, minute: time.minute));
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<HabitProvider>();
      final habit = Habit(
        id: isEditing ? widget.existingHabit!.id : const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        reminderTime: _selectedTime,
        completedDates: isEditing ? widget.existingHabit!.completedDates : [],
        createdAt: isEditing ? widget.existingHabit!.createdAt : null,
        color: _selectedColor,
      );

      if (isEditing) {
        provider.updateHabit(habit);
      } else {
        provider.addHabit(habit);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Habit' : 'Add New Habit'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Reminder:'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Color:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ColorOption.values.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getColorValue(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Color _getColorValue(ColorOption color) {
    switch (color) {
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
}
