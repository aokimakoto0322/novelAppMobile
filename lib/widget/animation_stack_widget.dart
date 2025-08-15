import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/widget/fab_icon_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationStackWidget extends ConsumerWidget {
  final Widget foregroundWidget;
  const AnimationStackWidget({super.key, required this.foregroundWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final saveUsecase = ref.read(saveUsecaseProvider);
    final storyState = ref.read(storyUsecaseProvider);
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
      fabBackgroundColor: Color(0xffEB456F),
      bottomWidget: SizedBox.shrink(),
      columnWidget: Column(
        children: [
          FabIconWidget(
            width: 100,
            height: 60,
            iconData: Icons.save,
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
            iconData: Icons.image,
            onPressed: () {
              print('アイコンテスト画像');
            },
          ),
          SizedBox(height: 20),
          FabIconWidget(
            width: 60,
            height: 60,
            iconData: Icons.camera_alt,
            onPressed: () {
              print('アイコンテストカメラ');
            },
          ),
        ],
      ),
      foregroundWidget: foregroundWidget,
    ); 
  }
}