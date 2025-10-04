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
                isRunning: false,
                onStart: () {},
                onStop: () {},
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
                isRunning: false,
                onStart: () {},
                onStop: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('01:01:05'), findsOneWidget);
    });

    testWidgets('停止中は開始ボタンが表示されること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 0,
                isRunning: false,
                onStart: () {},
                onStop: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsNothing);
    });

    testWidgets('実行中は停止ボタンが表示されること', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 10,
                isRunning: true,
                onStart: () {},
                onStop: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('開始ボタンをタップするとコールバックが呼ばれること', (tester) async {
      var startCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 0,
                isRunning: false,
                onStart: () => startCalled = true,
                onStop: () {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      expect(startCalled, true);
    });

    testWidgets('停止ボタンをタップするとコールバックが呼ばれること', (tester) async {
      var stopCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WorkoutTimer(
                elapsedSeconds: 10,
                isRunning: true,
                onStart: () {},
                onStop: () => stopCalled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();

      expect(stopCalled, true);
    });
  });
}
