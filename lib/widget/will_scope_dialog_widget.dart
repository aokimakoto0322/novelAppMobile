import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:provider/provider.dart';

class WillPopScopeDialogWidget extends StatelessWidget {
  final Widget child;

  const WillPopScopeDialogWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            final database = innerContext.read<MyDatabase>();
            final allStory = innerContext.read<List<Story>>();
            final storyUsecase = innerContext.read<StoryUsecase>();
            final saveUsecase = innerContext.read<SaveUsecase>();

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
                        saveUsecase.saveStory(database, allStory[storyUsecase.currentIndex].id);
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