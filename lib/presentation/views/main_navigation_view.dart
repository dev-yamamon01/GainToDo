import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/views/workout_home_view.dart';
import 'package:gain_to_do/presentation/views/menu_edit_view.dart';
import 'package:gain_to_do/presentation/views/history_view.dart';

class MainNavigationView extends ConsumerStatefulWidget {
  const MainNavigationView({super.key});

  @override
  ConsumerState<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends ConsumerState<MainNavigationView> {
  int _selectedIndex = 0;

  // ページをキャッシュして状態を保持
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const WorkoutHomeView(),
      const MenuEditView(),
      const HistoryView(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'ワークアウト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'メニュー編集',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '履歴',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
