import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WillPopScopeDialogWidget extends ConsumerWidget {
  final Widget child;

  const WillPopScopeDialogWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final storyState = ref.read(storyUsecaseProvider); // StoryState
    final saveUsecase = ref.read(saveUsecaseProvider);
    final allStory = storyState.allStory;


    return Builder(
      builder: (innerContext) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (!didPop) {
              final shouldExit = await showDialog<bool>(
                context: innerContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('確認'),
                  content: const Text('セーブしてホーム画面に戻りますか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('セーブしないで戻る'),
                    ),
                    TextButton(
                      onPressed: () {
                        saveUsecase.saveStory(database, allStory[storyState.currentIndex].id);
                        Navigator.of(dialogContext).pop(true);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
        
              if ((shouldExit ?? false) && innerContext.mounted) {
                Navigator.of(innerContext).pop();
              }
            }
          },
          child: child,
        );
      },
    );
  }
}