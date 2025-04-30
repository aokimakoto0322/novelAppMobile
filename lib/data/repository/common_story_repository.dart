import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_nobel_app/database/database.dart';


class CommonStoryRepository {
  // 全件データ取得
  Future<List<CommonStory>> fetchAllStory(MyDatabase db) async {
    List<CommonStory> result = await db.select(db.commonStoryTable).get();
    return result;
  }

  Future<int> getStoryCount(MyDatabase db) async {
    var count = await db.select(db.commonStoryTable).get().then((rows) => rows.length);
    return count;
  }

  // データをリストで取得し、common_storyテーブルに格納
  Future<void> insertStory(MyDatabase db, List<CommonStory> storyList) async {
    await db.batch((batch) {
      for(final story in storyList) {
        batch.insert(
          db.commonStoryTable,
          CommonStoryTableCompanion.insert(
            id: Value(story.id),
            sortId: story.sortId,
            word: story.word,
            imageName: story.imageName
          ),
          onConflict: DoNothing()
        );
      }
    });
  }
}

