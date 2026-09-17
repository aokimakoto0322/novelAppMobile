import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_nobel_app/database/database.dart';


class StoryRepository {
  final MyDatabase db;

  StoryRepository(
    this.db
  );

  // 全件データ取得
  Future<List<Story>> fetchAllStory() async {
    List<Story> result = await db.select(db.storyTable).get();
    result.sort((a, b) {
      final numA = num.tryParse(a.sortId);
      final numB = num.tryParse(b.sortId);
      if (numA != null && numB != null) {
        return numA.compareTo(numB);
      }
      return a.sortId.compareTo(b.sortId);
    });
    return result;
  }

  // データをリストで取得し、storyテーブルに格納
  Future<void> insertStory(MyDatabase db, List<Story> storyList) async {
    await db.batch((batch) {
      for(final story in storyList) {
        batch.insert(
          db.storyTable,
          StoryTableCompanion.insert(
            id: Value(story.id),
            sortId: story.sortId,
            word: story.word,
            speaker: story.speaker,
            description: story.description,
            imageName: story.imageName,
            character1: story.character1,
            character1EffectIn: story.character1EffectIn,
            character1EffectOut: story.character1EffectOut,
            bgm: story.bgm
          ),
          onConflict: DoNothing()
        );
      }
    });
  }

  Future<void> deleteAllStory() async {
    await db.delete(db.storyTable).go();
  }
}

