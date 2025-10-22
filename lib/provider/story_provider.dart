import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/choice_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/common_story_api_provider.dart';
import 'package:flutter_nobel_app/provider/story_repository_provider.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final storyUsecaseProvider = StateNotifierProvider<StoryUsecase, StoryState>((ref) {
  final db = ref.watch(databaseProvider);
  final choiceRepository = ref.watch(choiceRepositoryProvider);
  final storyRepository = ref.watch(storyRepositoryProvider);
  final storyApi = ref.watch(commonStoryApiProvider);
  final backlogUsecase = ref.watch(backlogUsecaseProvider);

  final audioPlayer = AudioPlayer();

  return StoryUsecase(
    db: db,
    choiceRepository: choiceRepository,
    storyRepository: storyRepository,
    commonStoryApi: storyApi,
    backlogUsecase: backlogUsecase,
    audioPlayer: audioPlayer
  );
});