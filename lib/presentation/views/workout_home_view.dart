import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/view_models/workout_view_model.dart';
import 'package:gain_to_do/presentation/widgets/feature/workout_timer.dart';
import 'package:gain_to_do/presentation/widgets/feature/workout_menu_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WorkoutHomeView extends ConsumerStatefulWidget {
  const WorkoutHomeView({super.key});

  @override
  ConsumerState<WorkoutHomeView> createState() => _WorkoutHomeViewState();
}

class _WorkoutHomeViewState extends ConsumerState<WorkoutHomeView> {
  YoutubePlayerController? _youtubeController;

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializeYoutubePlayer(String url, {bool preservePlaybackPosition = false}) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      if (_youtubeController != null) {
        // 既存のコントローラーがある場合
        final currentVideoId = _youtubeController!.metadata.videoId;
        if (currentVideoId == videoId && preservePlaybackPosition) {
          // 同じ動画で再生位置を保持する場合は何もしない
          return;
        }
        // 異なる動画をロード
        _youtubeController!.load(videoId);
        _youtubeController!.play();
      } else {
        // 新しいコントローラーを作成
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }
      setState(() {});
    }
  }

  void _showYoutubeUrlDialog(BuildContext context, WorkoutViewModel viewModel) async {
    final previousUrlsWithLabels = await viewModel.getUniqueYoutubeUrlsWithLabels();
    final urlController = TextEditingController(
      text: viewModel.state.currentSession?.youtubeUrl ?? '',
    );
    final labelController = TextEditingController(
      text: viewModel.state.currentSession?.youtubeUrlLabel ?? '',
    );

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('YouTube URL'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=...',
                  border: OutlineInputBorder(),
                  labelText: 'URLを入力',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  hintText: '例: 胸トレ、脚トレ',
                  border: OutlineInputBorder(),
                  labelText: 'ラベル（任意）',
                ),
              ),
              if (previousUrlsWithLabels.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '過去に使用したURL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: previousUrlsWithLabels.length,
                    itemBuilder: (context, index) {
                      final item = previousUrlsWithLabels[index];
                      final url = item['url']!;
                      final label = item['label']!;
                      final displayText = label != url ? label : url;

                      return ListTile(
                        title: Text(
                          displayText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: label != url ? Text(
                          url,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ) : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('確認'),
                                    content: Text('「$displayText」を削除しますか？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('キャンセル'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('削除'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  await viewModel.deleteYoutubeUrl(url);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    _showYoutubeUrlDialog(context, viewModel);
                                  }
                                }
                              },
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                        onTap: () {
                          urlController.text = url;
                          labelController.text = label != url ? label : '';
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              final label = labelController.text.trim();
              viewModel.setYoutubeUrl(url, label: label.isNotEmpty ? label : null);
              if (url.isNotEmpty) {
                _initializeYoutubePlayer(url);
              } else {
                _youtubeController?.dispose();
                _youtubeController = null;
                setState(() {});
              }
              Navigator.of(context).pop();
            },
            child: const Text('設定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(workoutViewModelProvider);
    final viewModelNotifier = ref.read(workoutViewModelProvider.notifier);
    final menusAsync = ref.watch(workoutMenusProvider);

    final youtubePlayer = _youtubeController != null
        ? YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
          )
        : null;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController ?? YoutubePlayerController(
          initialVideoId: '',
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('GainToDo'),
          ),
          body: Column(
            children: [
              // タイマー表示
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: WorkoutTimer(
                  elapsedSeconds: viewModelState.elapsedTime,
                ),
              ),
              const Divider(),

              // YouTube再生エリア
              if (_youtubeController != null)
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      player,
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: '動画リンクを変更',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _showYoutubeUrlDialog(context, viewModelNotifier);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // 動画未セット時は最後の動画を再生
                          final recentUrlsWithLabels = await viewModelNotifier.getUniqueYoutubeUrlsWithLabels();
                          if (recentUrlsWithLabels.isNotEmpty && context.mounted) {
                            final firstItem = recentUrlsWithLabels.first;
                            final url = firstItem['url']!;
                            final label = firstItem['label'];
                            viewModelNotifier.setYoutubeUrl(url, label: label);
                            _initializeYoutubePlayer(url);
                          }
                        },
                        child: Container(
                          color: Colors.black12,
                          child: Center(
                            child: viewModelState.currentSession?.youtubeUrl != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline,
                                        size: 64,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          viewModelState.currentSession!.youtubeUrl!,
                                          style: TextStyle(color: Colors.grey[600]),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    Icons.play_circle_outline,
                                    size: 64,
                                    color: Colors.grey[600],
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: '動画リンクを変更',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _showYoutubeUrlDialog(context, viewModelNotifier);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),

          // メニューリスト
          Expanded(
            child: menusAsync.when(
              data: (menus) {
                // 現在の曜日を取得 (1=月曜, 7=日曜)
                final now = DateTime.now();
                final currentDay = now.weekday; // 1=月曜, 7=日曜

                // 現在の曜日に該当するメニューをフィルタ
                final todayMenus = menus.where((menu) {
                  return menu.scheduleDays.contains(0) || // 毎日
                         menu.scheduleDays.contains(currentDay);
                }).toList();

                if (todayMenus.isEmpty) {
                  return const Center(
                    child: Text('今日のメニューがありません'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: todayMenus.length,
                        itemBuilder: (context, index) {
                          final menu = todayMenus[index];
                          final remainingSets = viewModelState.remainingSets[menu.id] ?? menu.totalSets;

                          return WorkoutMenuItem(
                            menu: menu,
                            remainingSets: remainingSets,
                            onToggle: () async {
                              if (!viewModelState.isWorkoutActive) {
                                // ワークアウト開始確認ダイアログ
                                final shouldStart = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('確認'),
                                    content: const Text('筋トレを開始しますか？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('キャンセル'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('開始'),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldStart == true) {
                                  // ワークアウト開始処理
                                  final repository = ref.read(workoutRepositoryProvider);
                                  final menus = await repository.getWorkoutMenus();
                                  final hasCompletedMenus = menus.any((m) => m.isCompleted);

                                  if (hasCompletedMenus && context.mounted) {
                                    final result = await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('確認'),
                                        content: const Text('すでに完了済みのものはリセットして始めますか？'),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () => Navigator.of(context).pop('keep'),
                                                  child: const Text('そのまま始める'),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () => Navigator.of(context).pop('reset'),
                                                  child: const Text('リセットする'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result == 'reset') {
                                      await viewModelNotifier.uncheckAllMenus();
                                    } else if (result == null) {
                                      return;
                                    }
                                  }

                                  // ワークアウト開始
                                  await viewModelNotifier.startWorkout();

                                  // 動画が既に再生中の場合は再生位置を保持
                                  if (_youtubeController != null && viewModelState.currentSession?.youtubeUrl != null) {
                                    _initializeYoutubePlayer(viewModelState.currentSession!.youtubeUrl!, preservePlaybackPosition: true);
                                  } else {
                                    // 動画が未設定の場合は最新の動画を読み込む
                                    final recentUrlsWithLabels = await viewModelNotifier.getUniqueYoutubeUrlsWithLabels();
                                    if (recentUrlsWithLabels.isNotEmpty) {
                                      final firstItem = recentUrlsWithLabels.first;
                                      final url = firstItem['url']!;
                                      final label = firstItem['label'];
                                      viewModelNotifier.setYoutubeUrl(url, label: label);
                                      _initializeYoutubePlayer(url);
                                    }
                                  }
                                  viewModelNotifier.startTimer();

                                  // セット数を減らす
                                  viewModelNotifier.decrementSet(menu);
                                }
                              } else {
                                viewModelNotifier.decrementSet(menu);
                              }
                            },
                            onReset: viewModelState.isWorkoutActive
                                ? () {
                                    viewModelNotifier.resetSet(menu);
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('エラー: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (viewModelState.isWorkoutActive) {
            viewModelNotifier.endWorkout();
            // 動画を停止
            _youtubeController?.pause();
            _youtubeController?.dispose();
            _youtubeController = null;
            setState(() {});
          } else {
            // チェック済みのメニューがあるか確認
            final repository = ref.read(workoutRepositoryProvider);
            final menus = await repository.getWorkoutMenus();
            final hasCompletedMenus = menus.any((menu) => menu.isCompleted);

            if (hasCompletedMenus && context.mounted) {
              // ダイアログを表示
              final result = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('確認'),
                  content: const Text('すでに完了済みのものはリセットして始めますか？'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop('keep'),
                            child: const Text('そのまま始める'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop('reset'),
                            child: const Text('リセットする'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              if (result == 'reset') {
                await viewModelNotifier.uncheckAllMenus();
              }
            }

            // 既存のセッションがあればそれを使用、なければ新規作成
            if (viewModelState.currentSession == null) {
              // 最近使用した動画を自動設定
              await viewModelNotifier.startWorkout();
              final recentUrlsWithLabels = await viewModelNotifier.getUniqueYoutubeUrlsWithLabels();
              if (recentUrlsWithLabels.isNotEmpty) {
                final firstItem = recentUrlsWithLabels.first;
                final url = firstItem['url']!;
                final label = firstItem['label'];
                viewModelNotifier.setYoutubeUrl(url, label: label);
                _initializeYoutubePlayer(url);
              }
            } else {
              // URL設定済みのセッションがある場合
              await viewModelNotifier.startWorkout();
              // 動画が既に再生中の場合は再生位置を保持
              if (_youtubeController != null && viewModelState.currentSession!.youtubeUrl != null) {
                _initializeYoutubePlayer(viewModelState.currentSession!.youtubeUrl!, preservePlaybackPosition: true);
              } else if (viewModelState.currentSession!.youtubeUrl != null && viewModelState.currentSession!.youtubeUrl!.isNotEmpty) {
                // コントローラーがない場合は作成
                _initializeYoutubePlayer(viewModelState.currentSession!.youtubeUrl!);
              }
            }
            viewModelNotifier.startTimer();
          }
        },
        icon: Icon(
          viewModelState.isWorkoutActive ? Icons.stop : Icons.play_arrow,
        ),
        label: Text(
          viewModelState.isWorkoutActive ? '筋トレ終了' : '筋トレ開始',
        ),
      ),
        );
      },
    );
  }
}
