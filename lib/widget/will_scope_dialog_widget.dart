import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';

class WillPopScopeDialogWidget extends StatelessWidget {
  final Widget child;
  final MyDatabase database;
  final List<Story> allStory;
  final StoryUsecase storyUsecase;
  final SaveUsecase saveUsecase;

  const WillPopScopeDialogWidget({
    super.key,
    required this.child,
    required this.database,
    required this.allStory,
    required this.storyUsecase,
    required this.saveUsecase,
    });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('確認'),
              content: const Text('セーブしてホーム画面に戻りますか？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('セーブしないで戻る'),
                ),
                TextButton(
                  onPressed: () {
                    saveUsecase.saveStory(database, allStory[storyUsecase.currentIndex].id);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          if ((shouldExit ?? false) && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}