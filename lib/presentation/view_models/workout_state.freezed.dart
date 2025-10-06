// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutState {
  WorkoutSession? get currentSession => throw _privateConstructorUsedError;
  bool get isWorkoutActive => throw _privateConstructorUsedError;
  bool get isTimerRunning => throw _privateConstructorUsedError;
  int get elapsedTime => throw _privateConstructorUsedError;
  Map<int, int> get remainingSets => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkoutStateCopyWith<WorkoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutStateCopyWith<$Res> {
  factory $WorkoutStateCopyWith(
          WorkoutState value, $Res Function(WorkoutState) then) =
      _$WorkoutStateCopyWithImpl<$Res, WorkoutState>;
  @useResult
  $Res call(
      {WorkoutSession? currentSession,
      bool isWorkoutActive,
      bool isTimerRunning,
      int elapsedTime,
      Map<int, int> remainingSets});
}

/// @nodoc
class _$WorkoutStateCopyWithImpl<$Res, $Val extends WorkoutState>
    implements $WorkoutStateCopyWith<$Res> {
  _$WorkoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSession = freezed,
    Object? isWorkoutActive = null,
    Object? isTimerRunning = null,
    Object? elapsedTime = null,
    Object? remainingSets = null,
  }) {
    return _then(_value.copyWith(
      currentSession: freezed == currentSession
          ? _value.currentSession
          : currentSession // ignore: cast_nullable_to_non_nullable
              as WorkoutSession?,
      isWorkoutActive: null == isWorkoutActive
          ? _value.isWorkoutActive
          : isWorkoutActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isTimerRunning: null == isTimerRunning
          ? _value.isTimerRunning
          : isTimerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      elapsedTime: null == elapsedTime
          ? _value.elapsedTime
          : elapsedTime // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSets: null == remainingSets
          ? _value.remainingSets
          : remainingSets // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutStateImplCopyWith<$Res>
    implements $WorkoutStateCopyWith<$Res> {
  factory _$$WorkoutStateImplCopyWith(
          _$WorkoutStateImpl value, $Res Function(_$WorkoutStateImpl) then) =
      __$$WorkoutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WorkoutSession? currentSession,
      bool isWorkoutActive,
      bool isTimerRunning,
      int elapsedTime,
      Map<int, int> remainingSets});
}

/// @nodoc
class __$$WorkoutStateImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$WorkoutStateImpl>
    implements _$$WorkoutStateImplCopyWith<$Res> {
  __$$WorkoutStateImplCopyWithImpl(
      _$WorkoutStateImpl _value, $Res Function(_$WorkoutStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSession = freezed,
    Object? isWorkoutActive = null,
    Object? isTimerRunning = null,
    Object? elapsedTime = null,
    Object? remainingSets = null,
  }) {
    return _then(_$WorkoutStateImpl(
      currentSession: freezed == currentSession
          ? _value.currentSession
          : currentSession // ignore: cast_nullable_to_non_nullable
              as WorkoutSession?,
      isWorkoutActive: null == isWorkoutActive
          ? _value.isWorkoutActive
          : isWorkoutActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isTimerRunning: null == isTimerRunning
          ? _value.isTimerRunning
          : isTimerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      elapsedTime: null == elapsedTime
          ? _value.elapsedTime
          : elapsedTime // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSets: null == remainingSets
          ? _value._remainingSets
          : remainingSets // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

/// @nodoc

class _$WorkoutStateImpl implements _WorkoutState {
  const _$WorkoutStateImpl(
      {this.currentSession,
      this.isWorkoutActive = false,
      this.isTimerRunning = false,
      this.elapsedTime = 0,
      final Map<int, int> remainingSets = const {}})
      : _remainingSets = remainingSets;

  @override
  final WorkoutSession? currentSession;
  @override
  @JsonKey()
  final bool isWorkoutActive;
  @override
  @JsonKey()
  final bool isTimerRunning;
  @override
  @JsonKey()
  final int elapsedTime;
  final Map<int, int> _remainingSets;
  @override
  @JsonKey()
  Map<int, int> get remainingSets {
    if (_remainingSets is EqualUnmodifiableMapView) return _remainingSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_remainingSets);
  }

  @override
  String toString() {
    return 'WorkoutState(currentSession: $currentSession, isWorkoutActive: $isWorkoutActive, isTimerRunning: $isTimerRunning, elapsedTime: $elapsedTime, remainingSets: $remainingSets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutStateImpl &&
            (identical(other.currentSession, currentSession) ||
                other.currentSession == currentSession) &&
            (identical(other.isWorkoutActive, isWorkoutActive) ||
                other.isWorkoutActive == isWorkoutActive) &&
            (identical(other.isTimerRunning, isTimerRunning) ||
                other.isTimerRunning == isTimerRunning) &&
            (identical(other.elapsedTime, elapsedTime) ||
                other.elapsedTime == elapsedTime) &&
            const DeepCollectionEquality()
                .equals(other._remainingSets, _remainingSets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentSession,
      isWorkoutActive,
      isTimerRunning,
      elapsedTime,
      const DeepCollectionEquality().hash(_remainingSets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
      __$$WorkoutStateImplCopyWithImpl<_$WorkoutStateImpl>(this, _$identity);
}

abstract class _WorkoutState implements WorkoutState {
  const factory _WorkoutState(
      {final WorkoutSession? currentSession,
      final bool isWorkoutActive,
      final bool isTimerRunning,
      final int elapsedTime,
      final Map<int, int> remainingSets}) = _$WorkoutStateImpl;

  @override
  WorkoutSession? get currentSession;
  @override
  bool get isWorkoutActive;
  @override
  bool get isTimerRunning;
  @override
  int get elapsedTime;
  @override
  Map<int, int> get remainingSets;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
