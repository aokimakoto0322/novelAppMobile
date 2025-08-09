
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';

class SpeakerAreaWidget extends StatelessWidget {
  final List<Story> allStory;
  final StoryUsecase storyUsecase;

  const SpeakerAreaWidget({
    super.key,
    required this.allStory,
    required this.storyUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 155,
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
          allStory[storyUsecase.currentIndex].speaker
        ),
      ),
    );
  }
}