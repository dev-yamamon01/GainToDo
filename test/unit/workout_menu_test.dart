import 'package:flutter_test/flutter_test.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';

void main() {
  group('WorkoutMenu Model Tests', () {
    test('WorkoutMenuが正しく生成されること', () {
      final workoutMenu = WorkoutMenu(
        id: 1,
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      expect(workoutMenu.id, 1);
      expect(workoutMenu.title, 'プッシュアップ');
      expect(workoutMenu.isCompleted, false);
      expect(workoutMenu.createdAt, DateTime(2025, 1, 1));
    });

    test('copyWithで値を更新できること', () {
      final workoutMenu = WorkoutMenu(
        id: 1,
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      final updatedMenu = workoutMenu.copyWith(isCompleted: true);

      expect(updatedMenu.id, 1);
      expect(updatedMenu.title, 'プッシュアップ');
      expect(updatedMenu.isCompleted, true);
      expect(updatedMenu.createdAt, DateTime(2025, 1, 1));
    });

    test('等価性チェックが正しく動作すること', () {
      final menu1 = WorkoutMenu(
        id: 1,
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      final menu2 = WorkoutMenu(
        id: 1,
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      expect(menu1, equals(menu2));
    });

    test('異なる値のインスタンスは等しくないこと', () {
      final menu1 = WorkoutMenu(
        id: 1,
        title: 'プッシュアップ',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      final menu2 = WorkoutMenu(
        id: 1,
        title: 'スクワット',
        isCompleted: false,
        createdAt: DateTime(2025, 1, 1),
      );

      expect(menu1, isNot(equals(menu2)));
    });
  });
}
