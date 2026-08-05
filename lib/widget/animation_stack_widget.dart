import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/widget/fab_icon_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnimationStackWidget extends ConsumerWidget {
  final Widget foregroundWidget;
  const AnimationStackWidget({super.key, required this.foregroundWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final saveUsecase = ref.read(saveUsecaseProvider);
    final storyState = ref.read(storyUsecaseProvider);
    final backlogUsecase = ref.read(backlogUsecaseProvider);
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final allStory = storyState.allStory;

    return AnimatedStack(
      buttonIcon: Icons.menu,
      fabIconColor: Colors.white,
      animateButton: false,
      enableClickToDismiss: true,
      preventForegroundInteractions: true,
      slideAnimationDuration: const Duration(milliseconds: 600),
      buttonAnimationDuration: const Duration(milliseconds: 600),
      backgroundColor: Colors.black,
      fabBackgroundColor: Colors.orangeAccent,
      bottomWidget: SizedBox.shrink(),
      columnWidget: Column(
        children: [
          FabIconWidget(
            width: 100,
            height: 60,
            iconData: Icons.save,
            label: 'セーブ',
            onPressed: () {
              saveUsecase.saveStory(database, allStory[storyState.currentIndex].id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ストーリーを保存しました'))
              );
            },
          ),
          SizedBox(height: 20),
          FabIconWidget(
            width: 60,
            height: 60,
            iconData: Icons.low_priority,
            label: 'バックログ',
            onPressed: () {
              context.push('/backlog');
            },
          ),
          SizedBox(height: 20),
          FabIconWidget(
            width: 60,
            height: 60,
            label: 'TOP',
            iconData: Icons.home,
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('確認'),
                  content: const Text('ホーム画面に戻りますか？'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // ダイアログを閉じる
                      },
                      child: const Text('いいえ'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // ダイアログを閉じる
                        backlogUsecase.deleteBackLog();
                        storyUsecase.stopBgm();
                        
                        context.go('/title');
                      },
                      child: const Text('はい'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      foregroundWidget: foregroundWidget,
    ); 
  }
}