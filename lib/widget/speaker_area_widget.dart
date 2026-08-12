
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeakerAreaWidget extends ConsumerWidget {
  const SpeakerAreaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.read(storyUsecaseProvider);
    final allStory = storyState.allStory;

    return Positioned(
      left: 10,
      bottom: 218,
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.amber.withAlpha(200),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.circular(20)
          )
        ),
        child: Text(
          allStory[storyState.currentIndex].speaker
        ),
      ),
    );
  }
}