import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gain_to_do/data/repositories/workout_repository.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';
import 'package:gain_to_do/presentation/view_models/workout_state.dart';
import 'package:gain_to_do/data/providers/isar_provider.dart';

part 'workout_view_model.g.dart';

// Repository provider
@riverpod
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  final isar = ref.watch(isarProvider);
  return WorkoutRepository(isar);
}

// Stream providers for real-time data
@riverpod
Stream<List<WorkoutMenu>> workoutMenus(WorkoutMenusRef ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return Stream.periodic(const Duration(milliseconds: 100)).asyncMap((_) async {
    return await repository.getWorkoutMenus();
  });
}

@riverpod
Stream<List<WorkoutSession>> workoutHistory(WorkoutHistoryRef ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return Stream.periodic(const Duration(milliseconds: 100)).asyncMap((_) async {
    return await repository.getWorkoutHistory();
  });
}

// ViewModel for workout session management
@riverpod
class WorkoutViewModel extends _$WorkoutViewModel {
  Timer? _timer;

  @override
  WorkoutState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const WorkoutState();
  }

  // Menu operations
  Future<void> addMenu(WorkoutMenu menu) async {
    final repository = ref.read(workoutRepositoryProvider);
    await repository.addWorkoutMenu(menu);
    // Streamが自動で更新を通知
  }

  Future<void> updateMenu(WorkoutMenu menu) async {
    final repository = ref.read(workoutRepositoryProvider);
    await repository.updateWorkoutMenu(menu);
    // Streamが自動で更新を通知
  }

  Future<void> toggleMenuCompletion(WorkoutMenu menu) async {
    final repository = ref.read(workoutRepositoryProvider);
    final updatedMenu = menu.copyWith(isCompleted: !menu.isCompleted);
    await repository.updateWorkoutMenu(updatedMenu);
    // Streamが自動で更新を通知
  }

  Future<void> deleteMenu(String id) async {
    final repository = ref.read(workoutRepositoryProvider);
    await repository.deleteWorkoutMenu(int.parse(id));
    // Streamが自動で更新を通知
  }

  Future<void> uncheckAllMenus() async {
    final repository = ref.read(workoutRepositoryProvider);
    final menus = await repository.getWorkoutMenus();
    final completedMenus = menus.where((menu) => menu.isCompleted);

    for (final menu in completedMenus) {
      final uncheckedMenu = menu.copyWith(isCompleted: false);
      await repository.updateWorkoutMenu(uncheckedMenu);
    }
    // Streamが自動で更新を通知
  }

  // Session operations
  void startWorkout() {
    final currentSession = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch,
      date: DateTime.now(),
      totalDuration: 0,
      youtubeUrl: null,
    );

    state = state.copyWith(
      isWorkoutActive: true,
      currentSession: currentSession,
    );
  }

  Future<void> endWorkout() async {
    final repository = ref.read(workoutRepositoryProvider);

    if (state.currentSession != null) {
      // 完了したメニューのIDリストを取得
      final menus = await repository.getWorkoutMenus();
      final completedMenuIds = menus
          .where((menu) => menu.isCompleted)
          .map((menu) => menu.id)
          .toList();

      final session = state.currentSession!.copyWith(
        totalDuration: state.elapsedTime,
        completedMenuIds: completedMenuIds,
        youtubeUrl: state.currentSession!.youtubeUrl,
      );
      await repository.saveWorkoutSession(session);
      // Streamが自動で更新を通知
    }

    stopTimer();
    state = state.copyWith(
      isWorkoutActive: false,
      currentSession: null,
      elapsedTime: 0,
    );
  }

  void setYoutubeUrl(String url, {String? label}) {
    if (state.currentSession != null) {
      state = state.copyWith(
        currentSession: state.currentSession!.copyWith(
          youtubeUrl: url,
          youtubeUrlLabel: label,
        ),
      );
    } else {
      // ワークアウト開始前でもURLを設定できるようにする
      final session = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch,
        date: DateTime.now(),
        totalDuration: 0,
        youtubeUrl: url,
        youtubeUrlLabel: label,
      );
      state = state.copyWith(currentSession: session);
    }
  }

  Future<List<String>> getUniqueYoutubeUrls() async {
    final repository = ref.read(workoutRepositoryProvider);
    final sessions = await repository.getWorkoutHistory();
    final urls = sessions
        .where((session) => session.youtubeUrl != null && session.youtubeUrl!.isNotEmpty)
        .map((session) => session.youtubeUrl!)
        .toSet()
        .toList();
    return urls;
  }

  Future<List<Map<String, String>>> getUniqueYoutubeUrlsWithLabels() async {
    final repository = ref.read(workoutRepositoryProvider);
    final sessions = await repository.getWorkoutHistory();

    // URLごとに最新のラベルを保持
    final Map<String, String> urlLabelMap = {};
    for (final session in sessions.reversed) {
      if (session.youtubeUrl != null && session.youtubeUrl!.isNotEmpty) {
        if (!urlLabelMap.containsKey(session.youtubeUrl)) {
          urlLabelMap[session.youtubeUrl!] = session.youtubeUrlLabel ?? session.youtubeUrl!;
        }
      }
    }

    return urlLabelMap.entries
        .map((entry) => {'url': entry.key, 'label': entry.value})
        .toList();
  }

  Future<void> deleteYoutubeUrl(String url) async {
    final repository = ref.read(workoutRepositoryProvider);
    final sessions = await repository.getWorkoutHistory();

    // 指定されたURLを持つすべてのセッションを更新
    for (final session in sessions) {
      if (session.youtubeUrl == url) {
        final updatedSession = WorkoutSession(
          id: session.id,
          date: session.date,
          totalDuration: session.totalDuration,
          youtubeUrl: null,
          youtubeUrlLabel: null,
          completedMenuIds: session.completedMenuIds,
        );
        await repository.saveWorkoutSession(updatedSession);
      }
    }
  }

  // Timer operations
  void startTimer() {
    state = state.copyWith(isTimerRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedTime: state.elapsedTime + 1);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isTimerRunning: false);
  }
}
