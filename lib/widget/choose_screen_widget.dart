
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';

class ChooseScreenWidget extends StatelessWidget {
  final StoryUsecase usecase;
  final List<Story> allStory;
  
  const ChooseScreenWidget({
    super.key,
    required this.usecase,
    required this.allStory
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: usecase.isChoice ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: IgnorePointer(
        ignoring: !usecase.isChoice,
        child: Container(
          color: Colors.black.withAlpha(180),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...usecase.currentChoice.map((choice) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        usecase.tabSelect(choice, allStory);
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