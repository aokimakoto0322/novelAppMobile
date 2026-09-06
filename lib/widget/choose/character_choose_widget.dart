import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';

class CharacterChooseWidget extends StatefulWidget {
  final StoryUsecase storyUsecase;
  final List<Story> allStory;
  final bool showContent;

  const CharacterChooseWidget({
    super.key,
    required this.storyUsecase,
    required this.allStory,
    required this.showContent,
  });

  @override
  State<CharacterChooseWidget> createState() => _CharacterChooseWidgetState();
}

class _CharacterChooseWidgetState extends State<CharacterChooseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundController;
  final PageController _pageController = PageController();

  // データ定義（これらも別ファイルや定数に持たせるとより綺麗です）
  final List<String> characters = [
    'images/character/seiso_smile.png',
    'images/character/gal_smile.png'
  ];
  final List<String> descriptions = [
    "キャラクター１あいうえお\nかきくけこ\nここに説明文が入ります\n...",
    "キャラクター２あいうえお\nかきくけこ\nここに説明文が入ります\n..."
  ];
  final List<String> backgroundImages = [
    'images/background/background_book.png',
    'images/background/background_flower.png',
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.showContent ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1500),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              return _buildCharacterPage(index);
            },
          ),
          _buildNavigationArrows(),
        ],
      ),
    );
  }

  // 各ページの構築
  Widget _buildCharacterPage(int index) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      return ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.white),
            _buildScrollingBackground(index, height),
            _buildCharacterImage(index),
            _buildDescriptionBox(index),
            _buildSelectButton(index),
          ],
        ),
      );
    });
  }

  // --- 以下、各パーツのモジュール化 ---

  Widget _buildScrollingBackground(int index, double height) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final offset = _backgroundController.value * height;
        return Stack(
          children: [
            Transform.translate(offset: Offset(0, offset), child: child),
            Transform.translate(offset: Offset(0, -height + offset), child: child),
          ],
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: height, // LayoutBuilderから受け取った高さをしっかり指定
        child: Opacity(
          opacity: 0.25,
          child: Image.asset(
            backgroundImages[index],
            fit: BoxFit.cover, // 画像を引き伸ばして隙間をなくす
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterImage(int index) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      bottom: 0, left: 0, right: 0,
      child: Center(
        child: Image.asset(characters[index], fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildDescriptionBox(int index) {
    return Positioned(
      left: 20, bottom: 250,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(126),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          descriptions[index],
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildSelectButton(int index) {
    return Positioned(
      right: 20, bottom: 100,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: ElevatedButton(
          onPressed: () => _showConfirmationDialog(index),
          child: Text(
            widget.storyUsecase.currentChoice.length > index
                ? widget.storyUsecase.currentChoice[index].word
                : '',
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(int index) {
    final choice = widget.storyUsecase.currentChoice[index];
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      desc: 'このキャラクターを選択しますか？',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        widget.storyUsecase.tabSelect(choice, widget.allStory);
      },
    ).show();
  }

  Widget _buildNavigationArrows() {
    return Stack(
      children: [
        _arrowButton(Icons.arrow_left, Alignment.centerLeft, () {
          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }),
        _arrowButton(Icons.arrow_right, Alignment.centerRight, () {
          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }),
      ],
    );
  }

  Widget _arrowButton(IconData icon, Alignment alignment, VoidCallback onPressed) {
    return Align(
      alignment: alignment,
      child: IconButton(
        iconSize: 48,
        color: Colors.grey,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}