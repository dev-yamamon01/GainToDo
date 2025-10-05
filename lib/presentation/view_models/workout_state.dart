import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gain_to_do/data/models/workout_session.dart';

part 'workout_state.freezed.dart';

@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState({
    WorkoutSession? currentSession,
    @Default(false) bool isWorkoutActive,
    @Default(false) bool isTimerRunning,
    @Default(0) int elapsedTime,
  }) = _WorkoutState;
}
