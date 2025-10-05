import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';
import 'package:gain_to_do/data/models/workout_session.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in main()');
});

Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [WorkoutMenuSchema, WorkoutSessionSchema],
    directory: dir.path,
  );
}
