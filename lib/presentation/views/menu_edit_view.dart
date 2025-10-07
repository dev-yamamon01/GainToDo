import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/view_models/workout_view_model.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:isar/isar.dart';

class MenuEditView extends ConsumerStatefulWidget {
  const MenuEditView({super.key});

  @override
  ConsumerState<MenuEditView> createState() => _MenuEditViewState();
}

class _MenuEditViewState extends ConsumerState<MenuEditView> {
  void _showMenuDialog({WorkoutMenu? menu}) {
    final titleController = TextEditingController(text: menu?.title ?? '');
    final setsController = TextEditingController(text: (menu?.totalSets ?? 3).toString());
    final selectedDays = <int>{...(menu?.scheduleDays ?? [0])};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(menu == null ? 'メニュー追加' : 'メニュー編集'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'メニュー名を入力',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: setsController,
                  decoration: const InputDecoration(
                    hintText: 'セット数',
                    border: OutlineInputBorder(),
                    labelText: 'セット数',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '実施する曜日',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('毎日', style: TextStyle(fontSize: 14)),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      selected: selectedDays.contains(0),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.clear();
                            selectedDays.add(0);
                          }
                        });
                      },
                    ),
                    ...List.generate(7, (index) {
                      final day = index + 1;
                      final dayNames = ['月', '火', '水', '木', '金', '土', '日'];
                      return ChoiceChip(
                        label: Text(dayNames[index], style: const TextStyle(fontSize: 14)),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        selected: selectedDays.contains(day),
                        onSelected: (selected) {
                          setState(() {
                            selectedDays.remove(0); // 毎日を解除
                            if (selected) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                            if (selectedDays.isEmpty) {
                              selectedDays.add(0); // 何も選択されていない場合は毎日
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;

                final sets = int.tryParse(setsController.text) ?? 3;

                final updatedMenu = WorkoutMenu(
                  id: menu?.id ?? Isar.autoIncrement,
                  title: titleController.text.trim(),
                  isCompleted: menu?.isCompleted ?? false,
                  createdAt: menu?.createdAt ?? DateTime.now(),
                  scheduleDays: selectedDays.toList()..sort(),
                  totalSets: sets > 0 ? sets : 3,
                );

                if (menu == null) {
                  ref.read(workoutViewModelProvider.notifier).addMenu(updatedMenu);
                } else {
                  ref.read(workoutViewModelProvider.notifier).updateMenu(updatedMenu);
                }

                Navigator.of(context).pop();
              },
              child: Text(menu == null ? '追加' : '更新'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menusAsync = ref.watch(workoutMenusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メニュー編集'),
      ),
      body: Column(
        children: [
          // メニュー追加ボタン
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMenuDialog(),
                icon: const Icon(Icons.add),
                label: const Text('メニューを追加'),
              ),
            ),
          ),
          const Divider(),

          // メニューリスト
          Expanded(
            child: menusAsync.when(
              data: (menus) {
                if (menus.isEmpty) {
                  return const Center(
                    child: Text('メニューがありません\n上のフォームから追加してください'),
                  );
                }
                return ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    final dayNames = ['毎日', '月', '火', '水', '木', '金', '土', '日'];
                    final scheduleText = menu.scheduleDays
                        .map((day) => dayNames[day])
                        .join('・');

                    return ListTile(
                      title: Text(menu.title),
                      subtitle: Text('実施日: $scheduleText'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showMenuDialog(menu: menu),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .read(workoutViewModelProvider.notifier)
                                  .deleteMenu(menu.id.toString());
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('エラー: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
