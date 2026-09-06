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
    required this.storyState,
  });

  @override
  State<AreaChooseWidget> createState() => _AreaChooseWidgetState();
}

class _AreaChooseWidgetState extends State<AreaChooseWidget> with TickerProviderStateMixin {
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
        List<Choice> currentChoiceList = widget.storyUsecase.currentChoice
            .where((x) => x.storyId == widget.storyState.currentIndex)
            .toList();

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background/m_map_school.png',
                fit: BoxFit.fill,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
            ...currentChoiceList.map((choice) {
              double x = constraints.maxWidth * (choice.bottonX ?? 0.5);
              double y = constraints.maxHeight * (choice.bottonY ?? 0.5);

              return Positioned(
                left: x,
                top: y,
                child: PyokoButton(
                  choice: choice,
                  buttonController: _buttonController,
                  buttonAnimation: _buttonAnimation,
                ),
              );
            })
          ],
        );
      },
    );
  }
}

class PyokoButton extends StatefulWidget {
  final Choice choice;
  final AnimationController buttonController;
  final Animation<double> buttonAnimation;

  const PyokoButton({
    super.key,
    required this.choice,
    required this.buttonController,
    required this.buttonAnimation,
  });

  @override
  State<PyokoButton> createState() => _PyokoButtonState();
}

class _PyokoButtonState extends State<PyokoButton> with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tapAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.buttonController, _tapController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.buttonAnimation.value + _tapAnimation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _tapController.forward(),
        onTapUp: (_) => _tapController.reverse(),
        onTapCancel: () => _tapController.reverse(),
        onTap: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            body: Center(
              child: Text(
                widget.choice.word,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        },
        child: widget.choice.buttonImgName != null && widget.choice.buttonImgName!.isNotEmpty
            ? Image.asset(
                'images/icons/${widget.choice.buttonImgName}',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              )
            : const Icon(Icons.location_on, size: 80),
      ),
    );
  }
}