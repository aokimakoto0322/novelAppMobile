import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseScreenWidget extends ConsumerWidget {
  const ChooseScreenWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    return AnimatedOpacity(
      opacity: storyState.isChoice ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: IgnorePointer(
        ignoring: !storyState.isChoice,
        child: Container(
          color: Colors.black.withAlpha(180),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...storyUsecase.currentChoice.map((choice) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        storyUsecase.tabSelect(choice, allStory);
                      },
                      child: Text(choice.word)
                    ),
                  );
                })
              ]
            ),
          ),
        ),
      ),
    );
  }
}