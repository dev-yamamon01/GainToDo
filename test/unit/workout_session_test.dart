import 'package:flutter_test/flutter_test.dart';
import 'package:gain_to_do/data/models/workout_session.dart';
import 'package:gain_to_do/data/models/workout_menu.dart';

void main() {
  group('WorkoutSession Model Tests', () {
    test('WorkoutSessionが正しく生成されること', () {
      final session = WorkoutSession(
        id: 1,
        date: DateTime(2025, 1, 1),
        totalDuration: 0,
        youtubeUrl: null,
      );

      expect(session.id, 1);
      expect(session.date, DateTime(2025, 1, 1));
      expect(session.totalDuration, 0);
      expect(session.youtubeUrl, isNull);
    });

    test('copyWithでYouTube URLを更新できること', () {
      final session = WorkoutSession(
        id: 1,
        date: DateTime(2025, 1, 1),
        totalDuration: 0,
        youtubeUrl: null,
      );

      final updatedSession = session.copyWith(
        youtubeUrl: 'https://www.youtube.com/watch?v=test',
      );

      expect(updatedSession.youtubeUrl, 'https://www.youtube.com/watch?v=test');
    });

    test('copyWithで総時間を更新できること', () {
      final session = WorkoutSession(
        id: 1,
        date: DateTime(2025, 1, 1),
        totalDuration: 0,
        youtubeUrl: null,
      );

      final updatedSession = session.copyWith(totalDuration: 3600);

      expect(updatedSession.totalDuration, 3600);
      expect(updatedSession.id, 1);
    });

    test('等価性チェックが正しく動作すること', () {
      final session1 = WorkoutSession(
        id: 1,
        date: DateTime(2025, 1, 1),
        totalDuration: 3600,
        youtubeUrl: 'https://www.youtube.com/watch?v=test',
      );

      final session2 = WorkoutSession(
        id: 1,
        date: DateTime(2025, 1, 1),
        totalDuration: 3600,
        youtubeUrl: 'https://www.youtube.com/watch?v=test',
      );

      expect(session1, equals(session2));
    });
  });
}
