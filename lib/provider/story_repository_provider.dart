import 'package:flutter_nobel_app/data/repository/story_repository.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StoryRepository(db);
});