import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_nobel_app/widget/fab_icon_widget.dart';
import 'package:provider/provider.dart';

class AnimationStackWidget extends StatelessWidget {
  final Widget foregroundWidget;
  const AnimationStackWidget({super.key, required this.foregroundWidget});

  @override
  Widget build(BuildContext context) {
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
              final database = context.read<MyDatabase>();
              final allStory = context.read<List<Story>>();
              final storyUsecase = context.read<StoryUsecase>();
              final saveUsecase = context.read<SaveUsecase>();

              saveUsecase.saveStory(database, allStory[storyUsecase.currentIndex].id);
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