import 'package:flutter/material.dart';

class WorkoutTimer extends StatelessWidget {
  final int elapsedSeconds;

  const WorkoutTimer({
    super.key,
    required this.elapsedSeconds,
  });

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(elapsedSeconds),
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
