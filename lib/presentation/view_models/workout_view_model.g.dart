// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutRepositoryHash() => r'd7eff30573ca9492bfc9ef4574270854d6a94765';

/// See also [workoutRepository].
@ProviderFor(workoutRepository)
final workoutRepositoryProvider =
    AutoDisposeProvider<WorkoutRepository>.internal(
  workoutRepository,
  name: r'workoutRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutRepositoryRef = AutoDisposeProviderRef<WorkoutRepository>;
String _$workoutMenusHash() => r'ae0c337a6a58becb5a6a20aad8e3275f658c7a9b';

/// See also [workoutMenus].
@ProviderFor(workoutMenus)
final workoutMenusProvider =
    AutoDisposeStreamProvider<List<WorkoutMenu>>.internal(
  workoutMenus,
  name: r'workoutMenusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$workoutMenusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutMenusRef = AutoDisposeStreamProviderRef<List<WorkoutMenu>>;
String _$workoutHistoryHash() => r'1ae8ad93ab98480272aad66ed61b8c89540f072a';

/// See also [workoutHistory].
@ProviderFor(workoutHistory)
final workoutHistoryProvider =
    AutoDisposeStreamProvider<List<WorkoutSession>>.internal(
  workoutHistory,
  name: r'workoutHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutHistoryRef = AutoDisposeStreamProviderRef<List<WorkoutSession>>;
String _$workoutViewModelHash() => r'56010b1c83d195a052dcde9835d0974c349f2a92';

/// See also [WorkoutViewModel].
@ProviderFor(WorkoutViewModel)
final workoutViewModelProvider =
    AutoDisposeNotifierProvider<WorkoutViewModel, WorkoutState>.internal(
  WorkoutViewModel.new,
  name: r'workoutViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutViewModel = AutoDisposeNotifier<WorkoutState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
