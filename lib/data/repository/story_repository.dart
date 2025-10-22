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

