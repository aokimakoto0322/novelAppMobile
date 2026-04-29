import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/constants/const.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_nobel_app/widget/choose/area_choose_widget.dart';
import 'package:flutter_nobel_app/widget/choose/character_choose_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseScreenWidget extends ConsumerStatefulWidget {
  const ChooseScreenWidget({super.key});

  @override
  ConsumerState<ChooseScreenWidget> createState() => _ChooseScreenWidgetState();
}
class _ChooseScreenWidgetState extends ConsumerState<ChooseScreenWidget>
    with TickerProviderStateMixin {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();

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

          // 2. 黒画面になった後、コンテンツ(_showContentがtrueになったら)をゆっくり表示
          // キャラ選択画面デザインの条件分岐
          child: _selectChooseWidget(storyState, storyUsecase, allStory)
        ),
      ),
    );
  }

  // 選択肢画面表示の出し分けロジック
  Widget _selectChooseWidget(StoryState storyState, StoryUsecase storyUsecase, List<Story> allStory){
    var currentSelectList = storyState.allChoiceList.where((x) => x.storyId == storyState.currentIndex).toList();

    // 選択肢リストが空の場合は何も表示しない（RangeError防止）
    if (currentSelectList.isEmpty) {
      return const SizedBox.shrink();
    }

    final saveDiv = currentSelectList.first.saveDiv;
    if (saveDiv == Const.SAVEDIV['キャラクター選択画面']) {
      return CharacterChooseWidget(
        storyUsecase: storyUsecase,
        allStory: allStory,
        showContent: _showContent,
      );
    } else if (saveDiv == Const.SAVEDIV['場所選択画面']) {
      return const AreaChooseWidget();
    }

    return SizedBox.shrink();
  }
}