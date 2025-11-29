import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class CharacterWidget extends StatefulWidget {
  final String character1;

  const CharacterWidget({
    super.key,
    required this.character1,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  String? _previousCharacter;
  String? _currentCharacter;

  @override
  void didUpdateWidget(covariant CharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousCharacter = oldWidget.character1;
    _currentCharacter = widget.character1;
  }

  @override
  void initState() {
    super.initState();
    _currentCharacter = widget.character1;
    _previousCharacter = ""; // 初期は空
  }

  @override
  Widget build(BuildContext context) {
    final isAppearing =
        (_previousCharacter?.isEmpty ?? true) && (_currentCharacter?.isNotEmpty ?? false);
    final isDisappearing =
        (_previousCharacter?.isNotEmpty ?? false) && (_currentCharacter?.isEmpty ?? true);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -40,
          left: 0,
          right: 0,
          child: PageTransitionSwitcher(
            duration: isAppearing || isDisappearing
                ? const Duration(milliseconds: 400)
                : const Duration(milliseconds: 200),
            transitionBuilder: (child, animation, secondaryAnimation) {
              if (isAppearing) {
                // 非表示→表示（右から登場）
                // TODO: ほかのアニメーションを追加させたいときは変数で追加して条件分岐させること
                final inAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ));
                return SlideTransition(
                  position: inAnimation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              } else if (isDisappearing) {
                // 表示→非表示（左へ退場）
                // TODO: ほかのアニメーションを追加させたいときは変数で追加して条件分岐させること
                final outAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeInOut,
                ));
                return SlideTransition(
                  position: outAnimation,
                  child: FadeTransition(opacity: secondaryAnimation, child: child),
                );
              } else {
                // 表示→表示（クロスフェード）
                return FadeTransition(opacity: animation, child: child);
              }
            },
            child: _currentCharacter?.isNotEmpty == true
                ? Image.asset(
                    'images/character/${_currentCharacter!}',
                    key: ValueKey(_currentCharacter),
                    fit: BoxFit.contain,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}