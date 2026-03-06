import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ChooseScreenWidget extends ConsumerStatefulWidget {
  const ChooseScreenWidget({super.key});

  @override
  ConsumerState<ChooseScreenWidget> createState() => _ChooseScreenWidgetState();
}
class _ChooseScreenWidgetState extends ConsumerState<ChooseScreenWidget>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;
  late final AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // スクロール速度（秒数が多いほど遅くなります）
    )..repeat();

    // 初期状態でisChoiceがtrueの場合（ロード時など）、コンテンツを表示する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(storyUsecaseProvider).isChoice) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    // isChoice の状態を監視して、コンテンツ表示のタイミングを制御します。
    ref.listen(storyUsecaseProvider.select((s) => s.isChoice),
        (previous, next) {
      if (next == true && (previous == false || previous == null)) {
        // isChoiceがtrueになったら、黒画面へのフェード(2秒)を待ってからコンテンツを表示します。
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) { // ウィジェットがまだツリーに存在するか確認
            setState(() {
              _showContent = true;
            });
          }
        });
      } else if (next == false) {
        // isChoiceがfalseになったら、即座にコンテンツを非表示にします。
        if (mounted) {
          setState(() {
            _showContent = false;
          });
        }
      }
    });

    final PageController _controller = PageController();

    final List<String> characters = [
      'images/character/seiso_smile.png',
      'images/character/gal_smile.png'
    ];

    final List<String> descriptions = [
      "キャラクター１あいうえお\nかきくけこ\nここに説明文が入ります\nここに説明文が入ります\nここに説明文が入ります",
      "キャラクター２あいうえお\nかきくけこ\nここに説明文が入ります\nここに説明文が入ります\nここに説明文が入ります"
    ];

    // 動かす背景画像リスト
    final List<String> backgroundImages = [
      'images/background/background_book.png',
      'images/background/background_flower.png',
    ];

    // 1. isChoiceに応じて、まず黒い画面を2秒かけてフェードインさせます。
    return AnimatedOpacity(
      opacity: storyState.isChoice ? 1.0 : 0.0,
      duration: const Duration(seconds: 2),
      child: IgnorePointer(
        ignoring: !storyState.isChoice,
        child: Container(
          // 背景を黒にすることで、GameScreenを覆い隠します。
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          // 2. 黒画面になった後、コンテンツ(_showContentがtrueになったら)をゆっくり表示させます。
          child: AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500), // コンテンツのフェードイン時間
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    return LayoutBuilder(builder: (context, constraints) {
                      final height = constraints.maxHeight;
                      return ClipRect(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // 一番後ろに白背景を配置
                            Container(color: Colors.white),

                            // 無限スクロールする背景
                            // 2つの画像をそれぞれ動かすことで、継ぎ目のない無限スクロールを実現します
                            AnimatedBuilder(
                              animation: _backgroundController,
                              builder: (context, child) {
                                final offset = _backgroundController.value * height;
                                return Stack(
                                  children: [
                                    // 1枚目の画像
                                    Transform.translate(
                                      offset: Offset(0, offset),
                                      child: child,
                                    ),
                                    // 2枚目の画像（1枚目の真上に配置）
                                    Transform.translate(
                                      offset: Offset(0, -height + offset),
                                      child: child,
                                    ),
                                  ],
                                );
                              },
                              // アニメーションさせる子ウィジェット（1枚の画像）
                              child: SizedBox(
                                width: double.infinity,
                                height: height,
                                child: Opacity(
                                  opacity: 0.25,
                                  child: Image.asset(
                                    backgroundImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // キャラ表示
                            Positioned(
                              // ステータスバーの領域を避けるため、上からの位置を指定します。
                              top: MediaQuery.of(context).padding.top,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.asset(
                                  characters[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // 説明エリア
                            Positioned(
                              left: 20,
                              bottom: 250,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(126),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  descriptions[index],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),

                            // 選択確認ボタン
                            Positioned(
                              right: 20,
                              bottom: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    final choice = storyUsecase.currentChoice[index];
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.bottomSlide,
                                      desc: 'このキャラクターを選択しますか？',
                                      descTextStyle: const TextStyle(fontSize: 16),
                                      btnCancelText: "いいえ",
                                      btnOkText: "はい",
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        storyUsecase.tabSelect(
                                            choice,
                                            allStory);
                                      },
                                    ).show();
                                  },
                                  child: Text(
                                      storyUsecase.currentChoice.length > index
                                          ? storyUsecase.currentChoice[index].word
                                          : ''),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  },
                ),

                // ← 左ボタン
                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: IconButton(
                    iconSize: 48,
                    color: Colors.grey,
                    onPressed: () {
                      final page = _controller.page?.round() ?? 0;
                      if (page > 0) {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_left),
                  ),
                ),

                // → 右ボタン
                Positioned(
                  right: 10,
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: IconButton(
                    iconSize: 48,
                    color: Colors.grey,
                    onPressed: () {
                      final page = _controller.page?.round() ?? 0;
                      if (page < characters.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_right),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }
}