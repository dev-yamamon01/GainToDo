import 'package:flutter/material.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';

class WorkoutMenuItem extends StatelessWidget {
  final WorkoutMenu menu;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final bool showCheckbox;

  const WorkoutMenuItem({
    super.key,
    required this.menu,
    this.onToggle,
    this.onDelete,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: showCheckbox
          ? Checkbox(
              value: menu.isCompleted,
              onChanged: onToggle != null ? (_) => onToggle!() : null,
            )
          : null,
      title: Text(
        menu.title,
        style: TextStyle(
          decoration: showCheckbox && menu.isCompleted
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            )
          : null,
      onTap: showCheckbox && onToggle != null ? onToggle : null,
    );
  }
}
