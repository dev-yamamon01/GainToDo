import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/view_models/workout_view_model.dart';
import 'package:gain_to_do/data/repositories/workout_repository.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';

@GenerateMocks([WorkoutRepository])
import 'workout_view_model_test.mocks.dart';

void main() {
  group('WorkoutViewModel Tests', () {
    late MockWorkoutRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockWorkoutRepository();
      container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Workout Menu Management', () {
      test('メニューを追加できること', () async {
        final menu = WorkoutMenu(
          id: 1,
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        when(mockRepository.addWorkoutMenu(menu))
            .thenAnswer((_) async => Future.value());

        await container.read(workoutViewModelProvider.notifier).addMenu(menu);

        verify(mockRepository.addWorkoutMenu(menu)).called(1);
      });

      test('メニューを完了状態に更新できること', () async {
        final menu = WorkoutMenu(
          id: 1,
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        when(mockRepository.updateWorkoutMenu(any))
            .thenAnswer((_) async => Future.value());

        await container
            .read(workoutViewModelProvider.notifier)
            .toggleMenuCompletion(menu);

        verify(mockRepository.updateWorkoutMenu(
          argThat(predicate<WorkoutMenu>((m) => m.isCompleted == true)),
        )).called(1);
      });

      test('メニューを削除できること', () async {
        when(mockRepository.deleteWorkoutMenu(1))
            .thenAnswer((_) async => Future.value());

        await container
            .read(workoutViewModelProvider.notifier)
            .deleteMenu('1');

        verify(mockRepository.deleteWorkoutMenu(1)).called(1);
      });
    });

    group('Workout Session Management', () {
      test('ワークアウトセッションを開始できること', () {
        container.read(workoutViewModelProvider.notifier).startWorkout();

        final state = container.read(workoutViewModelProvider);
        expect(state.isWorkoutActive, true);
        expect(state.currentSession, isNotNull);
      });

      test('ワークアウトセッションを終了して保存できること', () async {
        when(mockRepository.getWorkoutMenus())
            .thenAnswer((_) async => []);
        when(mockRepository.saveWorkoutSession(any))
            .thenAnswer((_) async => Future.value());

        final notifier = container.read(workoutViewModelProvider.notifier);
        notifier.startWorkout();
        await notifier.endWorkout();

        final state = container.read(workoutViewModelProvider);
        expect(state.isWorkoutActive, false);
        verify(mockRepository.saveWorkoutSession(any)).called(1);
      });

      test('YouTube URLを設定できること', () {
        final url = 'https://www.youtube.com/watch?v=test';

        final notifier = container.read(workoutViewModelProvider.notifier);
        notifier.startWorkout();
        notifier.setYoutubeUrl(url);

        final state = container.read(workoutViewModelProvider);
        expect(state.currentSession?.youtubeUrl, url);
      });
    });

    group('Timer Management', () {
      test('タイマーを開始できること', () {
        final notifier = container.read(workoutViewModelProvider.notifier);
        notifier.startWorkout();
        notifier.startTimer();

        final state = container.read(workoutViewModelProvider);
        expect(state.isTimerRunning, true);
      });

      test('タイマーを停止できること', () {
        final notifier = container.read(workoutViewModelProvider.notifier);
        notifier.startWorkout();
        notifier.startTimer();
        notifier.stopTimer();

        final state = container.read(workoutViewModelProvider);
        expect(state.isTimerRunning, false);
      });

      // Note: タイマーの経過時間テストは実際のTimer動作に依存するため、
      // 統合テストで検証する方が適切
    });
  });
}
