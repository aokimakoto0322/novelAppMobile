import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseScreenWidget extends ConsumerWidget {
  const ChooseScreenWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    // ① isChoice が false のときは UI を一切作らない
    if (!storyState.isChoice) {
      return const SizedBox.shrink();
    }

    // ② ここから先は isChoice = true のときだけ実行される
    final PageController _controller = PageController();


    final List<String> characters = [
      'images/character/seiso_smile.png',
      'images/character/gal_smile.png'
    ];

    final List<String> descriptions = [
      "キャラクター１あいうえお\nかきくけこ\nここに説明文が入ります\nここに説明文が入ります\nここに説明文が入ります",
      "キャラクター２あいうえお\nかきくけこ\nここに説明文が入ります\nここに説明文が入ります\nここに説明文が入ります"
    ];

    return AnimatedOpacity(
      opacity: storyState.isChoice ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 2000),
      child: IgnorePointer(
        ignoring: !storyState.isChoice,
        child: Container(
          color: Colors.lightGreenAccent,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final bgColor = index == 0
                    ? Colors.amber.withAlpha(125)
                    : Colors.lightBlueAccent.withAlpha(125);

                  return Container(
                    color: bgColor,
                    child: Stack(
                      children: [
                        // キャラ表示
                        Positioned.fill(
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
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              descriptions[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("確認"),
                                      content: Text('このキャラクターを選択しますか？'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("キャンセル"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            storyUsecase.tabSelect(storyUsecase.currentChoice[index], allStory);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"),
                                        )
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Text(storyUsecase.currentChoice[index].word),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),

              // ← 左ボタン
              Positioned(
                left: 10,
                top: MediaQuery.of(context).size.height * 0.45,
                child: IconButton(
                  iconSize: 48,
                  color: Colors.white,
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
                  color: Colors.white,
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
    );
  }
}