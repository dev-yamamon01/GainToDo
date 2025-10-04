import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gain_to_do/presentation/widgets/feature/workout_menu_item.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';

void main() {
  group('WorkoutMenuItem Widget Tests', () {
    testWidgets('メニューアイテムが正しく表示されること', (tester) async {
      final menu = WorkoutMenu(
        id: '1',
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutMenuItem(
                menu: menu,
                onToggle: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('プッシュアップ'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('未完了のメニューのチェックボックスがOFFであること', (tester) async {
      final menu = WorkoutMenu(
        id: '1',
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutMenuItem(
                menu: menu,
                onToggle: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('完了済みのメニューのチェックボックスがONであること', (tester) async {
      final menu = WorkoutMenu(
        id: '1',
        title: 'プッシュアップ',
        isCompleted: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutMenuItem(
                menu: menu,
                onToggle: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('チェックボックスをタップするとコールバックが呼ばれること', (tester) async {
      var toggleCalled = false;
      final menu = WorkoutMenu(
        id: '1',
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutMenuItem(
                menu: menu,
                onToggle: () => toggleCalled = true,
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggleCalled, true);
    });

    testWidgets('削除ボタンをタップするとコールバックが呼ばれること', (tester) async {
      var deleteCalled = false;
      final menu = WorkoutMenu(
        id: '1',
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutMenuItem(
                menu: menu,
                onToggle: () {},
                onDelete: () => deleteCalled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(deleteCalled, true);
    });
  });
}
