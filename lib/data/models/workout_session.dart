import 'package:isar/isar.dart';

part 'workout_session.g.dart';

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late int totalDuration;
  String? youtubeUrl;
  String? youtubeUrlLabel;
  late List<int> completedMenuIds;

  WorkoutSession({
    this.id = Isar.autoIncrement,
    required this.date,
    required this.totalDuration,
    this.youtubeUrl,
    this.youtubeUrlLabel,
    this.completedMenuIds = const [],
  });

  // copyWith for immutability pattern
  WorkoutSession copyWith({
    int? id,
    DateTime? date,
    int? totalDuration,
    String? youtubeUrl,
    String? youtubeUrlLabel,
    List<int>? completedMenuIds,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      date: date ?? this.date,
      totalDuration: totalDuration ?? this.totalDuration,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      youtubeUrlLabel: youtubeUrlLabel ?? this.youtubeUrlLabel,
      completedMenuIds: completedMenuIds ?? this.completedMenuIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutSession &&
        other.id == id &&
        other.date == date &&
        other.totalDuration == totalDuration &&
        other.youtubeUrl == youtubeUrl &&
        other.youtubeUrlLabel == youtubeUrlLabel &&
        _listEquals(other.completedMenuIds, completedMenuIds);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      totalDuration.hashCode ^
      youtubeUrl.hashCode ^
      youtubeUrlLabel.hashCode ^
      completedMenuIds.hashCode;
}
