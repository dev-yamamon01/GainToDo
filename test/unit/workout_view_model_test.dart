import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gain_to_do/presentation/view_models/workout_view_model.dart';
import 'package:gain_to_do/data/repositories/workout_repository.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';

@GenerateMocks([WorkoutRepository])
import 'workout_view_model_test.mocks.dart';

void main() {
  group('WorkoutViewModel Tests', () {
    late MockWorkoutRepository mockRepository;
    late WorkoutViewModel viewModel;

    setUp(() {
      mockRepository = MockWorkoutRepository();
      viewModel = WorkoutViewModel(mockRepository);
    });

    group('Workout Menu Management', () {
      test('メニューを追加できること', () async {
        final menu = WorkoutMenu(
          id: '1',
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        when(mockRepository.addWorkoutMenu(menu))
            .thenAnswer((_) async => Future.value());

        await viewModel.addMenu(menu);

        verify(mockRepository.addWorkoutMenu(menu)).called(1);
      });

      test('メニューリストを取得できること', () async {
        final menus = [
          WorkoutMenu(
            id: '1',
            title: 'プッシュアップ',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          WorkoutMenu(
            id: '2',
            title: 'スクワット',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];

        when(mockRepository.getWorkoutMenus())
            .thenAnswer((_) async => menus);

        await viewModel.loadMenus();

        expect(viewModel.menus.length, 2);
        verify(mockRepository.getWorkoutMenus()).called(1);
      });

      test('メニューを完了状態に更新できること', () async {
        final menu = WorkoutMenu(
          id: '1',
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        when(mockRepository.updateWorkoutMenu(any))
            .thenAnswer((_) async => Future.value());

        await viewModel.toggleMenuCompletion(menu);

        verify(mockRepository.updateWorkoutMenu(
          argThat(predicate<WorkoutMenu>((m) => m.isCompleted == true)),
        )).called(1);
      });

      test('メニューを削除できること', () async {
        when(mockRepository.deleteWorkoutMenu('1'))
            .thenAnswer((_) async => Future.value());

        await viewModel.deleteMenu('1');

        verify(mockRepository.deleteWorkoutMenu('1')).called(1);
      });
    });

    group('Workout Session Management', () {
      test('ワークアウトセッションを開始できること', () async {
        viewModel.startWorkout();

        expect(viewModel.isWorkoutActive, true);
        expect(viewModel.currentSession, isNotNull);
      });

      test('ワークアウトセッションを終了して保存できること', () async {
        final session = WorkoutSession(
          id: 'session1',
          date: DateTime.now(),
          menus: [],
          totalDuration: 3600,
          youtubeUrl: null,
        );

        when(mockRepository.saveWorkoutSession(any))
            .thenAnswer((_) async => Future.value());

        viewModel.startWorkout();
        await viewModel.endWorkout();

        expect(viewModel.isWorkoutActive, false);
        verify(mockRepository.saveWorkoutSession(any)).called(1);
      });

      test('YouTube URLを設定できること', () async {
        final url = 'https://www.youtube.com/watch?v=test';

        viewModel.startWorkout();
        viewModel.setYoutubeUrl(url);

        expect(viewModel.currentSession?.youtubeUrl, url);
      });

      test('ワークアウト履歴を取得できること', () async {
        final sessions = [
          WorkoutSession(
            id: 'session1',
            date: DateTime(2025, 1, 1),
            menus: [],
            totalDuration: 3600,
            youtubeUrl: null,
          ),
          WorkoutSession(
            id: 'session2',
            date: DateTime(2025, 1, 2),
            menus: [],
            totalDuration: 2400,
            youtubeUrl: null,
          ),
        ];

        when(mockRepository.getWorkoutHistory())
            .thenAnswer((_) async => sessions);

        await viewModel.loadHistory();

        expect(viewModel.history.length, 2);
        verify(mockRepository.getWorkoutHistory()).called(1);
      });
    });

    group('Timer Management', () {
      test('タイマーを開始できること', () {
        viewModel.startWorkout();
        viewModel.startTimer();

        expect(viewModel.isTimerRunning, true);
      });

      test('タイマーを停止できること', () {
        viewModel.startWorkout();
        viewModel.startTimer();
        viewModel.stopTimer();

        expect(viewModel.isTimerRunning, false);
      });

      test('経過時間が記録されること', () async {
        viewModel.startWorkout();
        viewModel.startTimer();

        await Future.delayed(Duration(seconds: 2));
        viewModel.stopTimer();

        expect(viewModel.elapsedTime, greaterThan(0));
      });
    });
  });
}
