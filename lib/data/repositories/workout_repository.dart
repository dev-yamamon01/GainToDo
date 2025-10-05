import 'package:isar/isar.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';

class WorkoutRepository {
  final Isar _isar;

  WorkoutRepository(this._isar);

  // Workout Menu operations
  Future<void> addWorkoutMenu(WorkoutMenu menu) async {
    await _isar.writeTxn(() async {
      await _isar.workoutMenus.put(menu);
    });
  }

  Future<List<WorkoutMenu>> getWorkoutMenus() async {
    return await _isar.workoutMenus.where().findAll();
  }

  Future<void> updateWorkoutMenu(WorkoutMenu menu) async {
    await _isar.writeTxn(() async {
      await _isar.workoutMenus.put(menu);
    });
  }

  Future<void> deleteWorkoutMenu(int id) async {
    await _isar.writeTxn(() async {
      await _isar.workoutMenus.delete(id);
    });
  }

  // Workout Session operations
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    await _isar.writeTxn(() async {
      await _isar.workoutSessions.put(session);
    });
  }

  Future<List<WorkoutSession>> getWorkoutHistory() async {
    return await _isar.workoutSessions.where().sortByDateDesc().findAll();
  }

  Future<WorkoutSession?> getWorkoutSession(int id) async {
    return await _isar.workoutSessions.get(id);
  }

  Future<List<WorkoutSession>> getSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _isar.workoutSessions
        .where()
        .filter()
        .dateBetween(startDate, endDate)
        .findAll();
  }
}
