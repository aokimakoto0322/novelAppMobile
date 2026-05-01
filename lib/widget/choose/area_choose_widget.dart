import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';

class AreaChooseWidget extends StatefulWidget {
  final StoryUsecase storyUsecase;
  final StoryState storyState;

  const AreaChooseWidget({
    super.key,
    required this.storyUsecase,
    required this.storyState
  });

  @override
  State<AreaChooseWidget> createState() => _AreaChooseWidgetState();
}

class _AreaChooseWidgetState extends State<AreaChooseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _buttonController;
  late final Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Choice> currentChoiceList = widget.storyUsecase.currentChoice.where((x) => x.storyId == widget.storyState.currentIndex).toList();

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset('images/background/school_sample.png', fit: BoxFit.fill, width: constraints.maxWidth, height: constraints.maxHeight),
            ),
            
            ...currentChoiceList.map((choice) {
              double x = constraints.maxWidth * (choice.bottonX ?? 0.5);
              double y = constraints.maxHeight * (choice.bottonY ?? 0.5);

              return Positioned(
                left: x,
                top: y,
                child: _buildPyokoButton(choice), // 引数にchoiceを渡すと個別に制御しやすくなります
              );
            })
          ],
        );
      }
      
    );
  }

  Widget _buildPyokoButton(Choice choice) {
    return Container(
      // ボタンのところに少し黒い影をつける
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // ボタンの色
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          elevation: 0, // Containerの影を使うため、こちらは0に
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 丸いボタン
          ),
        ),
        onPressed: () {
          // ボタンが押されたときの処理
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            body: Center(
            child: Text(
              choice.word, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
            btnCancelOnPress: () {},
            btnOkOnPress: () {} // TODO: ボタンを押した後の分岐を後で実装すること(storyUseCase.tabSelect)
          ).show();
        },
        // ★ここがポイント： AnimatedBuilderで中身だけを動かす
        child: AnimatedBuilder(
          animation: _buttonAnimation,
          builder: (context, child) {
            // Tweenで定義した値 (0.0 ～ -10.0) をY軸の移動量に適用
            return Transform.translate(
              offset: Offset(0, _buttonAnimation.value),
              child: child, // 実際の中身（下のRow）
            );
          },
          // 動かしたい中身（アイコンとテキスト）
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 28), // 場所のアイコン
              const SizedBox(width: 10),
              Text(
                choice.buttonLabel ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}