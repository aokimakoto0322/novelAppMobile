import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/widget/fab_icon_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AnimationStackWidget extends ConsumerStatefulWidget {
  final Widget foregroundWidget;
  const AnimationStackWidget({super.key, required this.foregroundWidget});

  @override
  ConsumerState<AnimationStackWidget> createState() => _AnimationStackWidgetState();
}

class _AnimationStackWidgetState extends ConsumerState<AnimationStackWidget> {
  // メニューの開閉状態を管理します
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.read(databaseProvider);
    final saveUsecase = ref.read(saveUsecaseProvider);
    final storyState = ref.read(storyUsecaseProvider);
    final backlogUsecase = ref.read(backlogUsecaseProvider);
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final allStory = storyState.allStory;

    return Stack(
      children: [
        // 1. メイン画面
        widget.foregroundWidget,

        // 2. メニューが開いている時の背景タップ領域
        if (_isMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

        // 3. 右上のメインFABと、その下にふわっと展開するメニュー群
        Positioned(
          top: 40,   // 上からの位置
          right: 16,  // 右からの位置
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // メインの右FAB（明るい紫に変更したい場合はここも Colors.purpleAccent に変更できます！）
              FloatingActionButton(
                backgroundColor: Colors.orangeAccent,
                onPressed: _toggleMenu,
                child: Icon(
                  _isMenuOpen ? Icons.close : Icons.menu,
                  color: Colors.white,
                ),
              ),

              // FABの下に表示されるボタン群
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0,
                      child: child,
                    ),
                  );
                },
                child: _isMenuOpen
                    ? Padding(
                        key: const ValueKey('menu_items'),
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Material(
                          color: Colors.transparent,
                          // 👈 配下のアイコン色と文字色を強制的に固定・変更します！
                          child: IconTheme(
                            data: const IconThemeData(color: Colors.purpleAccent), // 明るい紫色のアイコン
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.white), // 白色テキスト
                              child: Column(
                                children: [
                                  FabIconWidget(
                                    width: 60,
                                    height: 60,
                                    iconData: Icons.save,
                                    label: 'セーブ',
                                    onPressed: () async {
                                      _toggleMenu();
                                      final newSaveId = await saveUsecase.saveStory(
                                        database,
                                        allStory[storyState.currentIndex].id,
                                        storyState.saveId,
                                      );
                                      storyUsecase.initGameScreen(
                                        storyState.currentIndex,
                                        newSaveId,
                                      );
                                      Fluttertoast.showToast(
                                        msg: "ストーリーを保存しました",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[800],
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  FabIconWidget(
                                    width: 60,
                                    height: 60,
                                    iconData: Icons.low_priority,
                                    label: 'バックログ',
                                    onPressed: () {
                                      _toggleMenu();
                                      context.push('/backlog');
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  FabIconWidget(
                                    width: 60,
                                    height: 60,
                                    label: 'TOP',
                                    iconData: Icons.home,
                                    onPressed: () {
                                      _toggleMenu();
                                      showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          title: const Text('確認'),
                                          content: const Text('ホーム画面に戻りますか？'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                              },
                                              child: const Text('いいえ'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                                backlogUsecase.deleteBackLog();
                                                storyUsecase.stopBgm();
                                                context.go('/title');
                                              },
                                              child: const Text('はい'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}