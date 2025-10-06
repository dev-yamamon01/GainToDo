import 'package:flutter/material.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';

class WorkoutMenuItem extends StatelessWidget {
  final WorkoutMenu menu;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final bool showCheckbox;
  final int? remainingSets;

  const WorkoutMenuItem({
    super.key,
    required this.menu,
    this.onToggle,
    this.onDelete,
    this.onReset,
    this.showCheckbox = true,
    this.remainingSets,
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
      title: Row(
        children: [
          Expanded(
            child: Text(
              menu.title,
              style: TextStyle(
                decoration: showCheckbox && menu.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          if (remainingSets != null) ...[
            Text(
              '残り${remainingSets}セット',
              style: TextStyle(
                fontSize: 14,
                color: remainingSets == 0 ? Colors.green : Colors.grey[600],
                fontWeight: remainingSets == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (onReset != null)
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onReset,
                tooltip: 'セット数をリセット',
              ),
          ],
        ],
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
