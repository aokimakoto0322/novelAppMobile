import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('Story')
class StoryTable extends Table {
  
  @JsonKey('story_id')
  IntColumn get id => integer().autoIncrement()();

  @JsonKey('sort_id')
  TextColumn get sortId => text()();

  @JsonKey('word')
  TextColumn get word => text()();

  @JsonKey('image_name')
  TextColumn get imageName => text()();
}

@DataClassName('Save')
class SaveTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer()();
  TextColumn get saveDate => text()();
}

@DataClassName('Choice')
class ChoiseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer()(); // 選択肢を表示するstory_id
  TextColumn get word => text()();
  IntColumn get nextStoryId => integer()(); // 選択した場合に表示を開始するstory_id
  IntColumn get returnStoryId => integer()(); // 選択肢を選んで、選択を選んだのちに戻るstory_id
}

@DriftDatabase(tables: [StoryTable, SaveTable, ChoiseTable])
class MyDatabase extends _$MyDatabase {

  MyDatabase(): super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        // データベースが新規作成される際に、すべてのテーブルを作成
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // schemaVersionが上がった際の処理

        // 例: バージョン1からバージョン2へのアップグレード時に初期データを投入
        // if (from < 2 && to >= 2) {
        //   final count = await (select(choiseTable)..limit(1)).getSingleOrNull();
        //   if (count == null) {
        //     await _initDataInsert(this);
        //   }
        // }
      },
      beforeOpen: (details) async {
        // 初期データ（選択肢）のカウントを行い、なかったら選択肢初期データを挿入
        final choiceCount = await (select(choiseTable)..limit(1)).getSingleOrNull();

        if (choiceCount == null) {
          await _initChoiceDataInsert(this);
        }
      } 
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // PCの場合はドキュメントフォルダに"db.sqlite"が作成される
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

Future<void> _initChoiceDataInsert(MyDatabase db) async {
  print('初期データ投入');

  // 選択肢A
  await db.into(db.choiseTable).insert(
    // index - 1なので、選択肢を出したいStoryId + 1にすること
    ChoiseTableCompanion.insert(storyId: 5, word: '選択肢A', nextStoryId: 588, returnStoryId: 605)
  );

  // 選択肢B // 最後の場合retunStoryId - 1に設定
  await db.into(db.choiseTable).insert(
    ChoiseTableCompanion.insert(storyId: 5, word: '選択肢B', nextStoryId: 605, returnStoryId: 623)
  );

  print('初期データ挿入完了');
}