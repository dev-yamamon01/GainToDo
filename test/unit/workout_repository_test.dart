import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gain_to_do/data/repositories/workout_repository.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';
import 'package:isar/isar.dart';

@GenerateMocks([Isar, IsarCollection])
import 'workout_repository_test.mocks.dart';

void main() {
  group('WorkoutRepository Tests', () {
    late MockIsar mockIsar;
    late MockIsarCollection<WorkoutMenu> mockMenuCollection;
    late MockIsarCollection<WorkoutSession> mockSessionCollection;
    late WorkoutRepository repository;

    setUp(() {
      mockIsar = MockIsar();
      mockMenuCollection = MockIsarCollection<WorkoutMenu>();
      mockSessionCollection = MockIsarCollection<WorkoutSession>();
      repository = WorkoutRepository(mockIsar);
    });

    group('Workout Menu Tests', () {
      test('メニューを追加できること', () async {
        final menu = WorkoutMenu(
          id: 1,
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime(2025, 1, 1),
        );

        when(mockIsar.workoutMenus).thenReturn(mockMenuCollection);
        when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);

        await repository.addWorkoutMenu(menu);

        verify(mockIsar.writeTxn(any)).called(1);
      });

      test('メニューリストを取得できること', () async {
        final menus = [
          WorkoutMenu(
            id: 1,
            title: 'プッシュアップ',
            isCompleted: false,
            createdAt: DateTime(2025, 1, 1),
          ),
          WorkoutMenu(
            id: 2,
            title: 'スクワット',
            isCompleted: false,
            createdAt: DateTime(2025, 1, 1),
          ),
        ];

        when(mockIsar.workoutMenus).thenReturn(mockMenuCollection);
        when(mockMenuCollection.where()).thenReturn(any);
        when(mockMenuCollection.where().findAll()).thenAnswer((_) async => menus);

        final result = await repository.getWorkoutMenus();

        expect(result, isA<List<WorkoutMenu>>());
        expect(result.length, 2);
      });

      test('メニューを削除できること', () async {
        when(mockIsar.workoutMenus).thenReturn(mockMenuCollection);
        when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);

        await repository.deleteWorkoutMenu(1);

        verify(mockIsar.writeTxn(any)).called(1);
      });

      test('メニューを更新できること', () async {
        final menu = WorkoutMenu(
          id: 1,
          title: 'プッシュアップ',
          isCompleted: false,
          createdAt: DateTime(2025, 1, 1),
        );

        when(mockIsar.workoutMenus).thenReturn(mockMenuCollection);
        when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);

        final updatedMenu = menu.copyWith(isCompleted: true);
        await repository.updateWorkoutMenu(updatedMenu);

        verify(mockIsar.writeTxn(any)).called(1);
      });
    });

    group('Workout Session Tests', () {
      test('セッションを保存できること', () async {
        final session = WorkoutSession(
          id: 1,
          date: DateTime(2025, 1, 1),
          totalDuration: 3600,
          youtubeUrl: 'https://www.youtube.com/watch?v=test',
        );

        when(mockIsar.workoutSessions).thenReturn(mockSessionCollection);
        when(mockIsar.writeTxn(any)).thenAnswer((_) async => null);

        await repository.saveWorkoutSession(session);

        verify(mockIsar.writeTxn(any)).called(1);
      });

      test('セッション履歴を取得できること', () async {
        final sessions = [
          WorkoutSession(
            id: 1,
            date: DateTime(2025, 1, 1),
            totalDuration: 3600,
            youtubeUrl: null,
          ),
          WorkoutSession(
            id: 2,
            date: DateTime(2025, 1, 2),
            totalDuration: 2400,
            youtubeUrl: null,
          ),
        ];

        when(mockIsar.workoutSessions).thenReturn(mockSessionCollection);
        when(mockSessionCollection.where()).thenReturn(any);
        when(mockSessionCollection.where().findAll()).thenAnswer((_) async => sessions);

        final result = await repository.getWorkoutHistory();

        expect(result, isA<List<WorkoutSession>>());
        expect(result.length, 2);
      });

      test('特定のセッションを取得できること', () async {
        final session = WorkoutSession(
          id: 1,
          date: DateTime(2025, 1, 1),
          totalDuration: 3600,
          youtubeUrl: null,
        );

        when(mockIsar.workoutSessions).thenReturn(mockSessionCollection);
        when(mockSessionCollection.get(1)).thenAnswer((_) async => session);

        final result = await repository.getWorkoutSession(1);

        expect(result, isNotNull);
        expect(result?.id, 1);
        verify(mockSessionCollection.get(1)).called(1);
      });

      test('日付範囲でセッションを取得できること', () async {
        final sessions = [
          WorkoutSession(
            id: 1,
            date: DateTime(2025, 1, 5),
            totalDuration: 3600,
            youtubeUrl: null,
          ),
        ];

        when(mockIsar.workoutSessions).thenReturn(mockSessionCollection);
        when(mockSessionCollection.where()).thenReturn(any);
        when(mockSessionCollection.where().filter()).thenReturn(any);
        when(mockSessionCollection.where().filter().dateBetween(any, any)).thenReturn(any);
        when(mockSessionCollection.where().filter().dateBetween(any, any).findAll())
            .thenAnswer((_) async => sessions);

        final result = await repository.getSessionsByDateRange(
          DateTime(2025, 1, 1),
          DateTime(2025, 1, 31),
        );

        expect(result, isA<List<WorkoutSession>>());
        expect(result.length, 1);
      });
    });
  });
}
