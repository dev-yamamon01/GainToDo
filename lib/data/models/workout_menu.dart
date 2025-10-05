import 'package:isar/isar.dart';

part 'workout_menu.g.dart';

@collection
class WorkoutMenu {
  Id id = Isar.autoIncrement;
  late String title;
  late bool isCompleted;
  late DateTime createdAt;
  // スケジュール: 0=毎日, 1=月曜, 2=火曜, 3=水曜, 4=木曜, 5=金曜, 6=土曜, 7=日曜
  late List<int> scheduleDays;

  WorkoutMenu({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.scheduleDays = const [0], // デフォルトは毎日
  });

  // copyWith for immutability pattern
  WorkoutMenu copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    List<int>? scheduleDays,
  }) {
    return WorkoutMenu(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      scheduleDays: scheduleDays ?? this.scheduleDays,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutMenu &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        _listEquals(other.scheduleDays, scheduleDays);
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
      id.hashCode ^ title.hashCode ^ isCompleted.hashCode ^ createdAt.hashCode ^ scheduleDays.hashCode;
}
