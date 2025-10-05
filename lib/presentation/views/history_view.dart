import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/view_models/workout_view_model.dart';
import 'package:gain_to_do/presentation/views/history_detail_view.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours}時間${minutes}分${secs}秒';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('筋トレ履歴'),
      ),
      body: historyAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(
              child: Text('履歴がありません'),
            );
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(
                    '${session.date.year}/${session.date.month}/${session.date.day}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('時間: ${_formatDuration(session.totalDuration)}'),
                      if (session.youtubeUrl != null)
                        Text('YouTube: ${session.youtubeUrl}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailView(session: session),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('エラー: $error'),
        ),
      ),
    );
  }
}
