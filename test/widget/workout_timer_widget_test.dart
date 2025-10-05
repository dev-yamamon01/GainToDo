import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/widgets/feature/workout_timer.dart';

void main() {
  group('WorkoutTimer Widget Tests', () {
    testWidgets('タイマーが初期状態で00:00:00を表示すること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 0,
              ),
            ),
          ),
        ),
      );

      expect(find.text('00:00:00'), findsOneWidget);
    });

    testWidgets('経過時間が正しくフォーマットされて表示されること', (tester) async {
      // 3665秒 = 1時間1分5秒
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 3665,
              ),
            ),
          ),
        ),
      );

      expect(find.text('01:01:05'), findsOneWidget);
    });
  });
}
