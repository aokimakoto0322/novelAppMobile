import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyUsecaseProvider =
    NotifierProvider<StoryUsecase, StoryState>(StoryUsecase.new);
