import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/constants/const.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_nobel_app/widget/choose/area_choose_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseScreenWidget extends ConsumerStatefulWidget {
  const ChooseScreenWidget({super.key});

  @override
  ConsumerState<ChooseScreenWidget> createState() => _ChooseScreenWidgetState();
}
class _ChooseScreenWidgetState extends ConsumerState<ChooseScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);

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

          // 2. 黒画面になった後、コンテンツを表示
          // 選択肢画面デザインの条件分岐
          child: _selectChooseWidget(storyState, storyUsecase),
        ),
      ),
    );
  }

  // 選択肢画面表示の出し分けロジック
  Widget _selectChooseWidget(StoryState storyState, StoryUsecase storyUsecase) {
    var currentSelectList = storyState.allChoiceList.where((x) => x.storyId == storyState.currentIndex).toList();

    // 選択肢リストが空の場合は何も表示しない（RangeError防止）
    if (currentSelectList.isEmpty) {
      return const SizedBox.shrink();
    }

    final saveDiv = currentSelectList.first.saveDiv;
    if (saveDiv == Const.SAVEDIV['場所選択画面']) {
      return AreaChooseWidget(
        storyUsecase: storyUsecase,
        storyState: storyState,
      );
    }

    return const SizedBox.shrink();
  }
}