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

  @JsonKey('speaker')
  TextColumn get speaker => text()();

  @JsonKey('description')
  TextColumn get description => text()();

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
  IntColumn get choiceGroup => integer()(); // 選択肢グループ
  IntColumn get nextStoryId => integer()(); // 選択した場合に表示を開始するstory_id
  IntColumn get returnStoryId => integer()(); // 選択した場合に表示を終了するstory_id
  IntColumn get warpStoryId => integer()(); // 選択肢に応じた物語が終わり、通常ルートに戻る先のstory_id
}

@DataClassName('ChoiceLog')
class ChoiceLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saveId => integer().nullable()();
  IntColumn get choiceId => integer()(); // 選択した選択肢ID
}

@DataClassName('ChoiceLogSelect')
class ChoiceLogSelectTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get choiceLogId => integer().customConstraint('REFERENCES choice_log_table(id) ON DELETE CASCADE NOT NULL')(); // ChoiceLog.Id
  IntColumn get order => integer()(); // 選択肢の表示順
}

@DriftDatabase(tables: [StoryTable, SaveTable, ChoiseTable, ChoiceLogTable, ChoiceLogSelectTable])
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
    // index - 1なので、選択肢を出したいStoryId - 1にすること（例StoryId35で選択肢を出したい場合、34と入力）
    // nextStoryIdも同様
    ChoiseTableCompanion.insert(storyId: 34, word: 'ヒロインAを選ぶ', choiceGroup: 1, nextStoryId: 35, returnStoryId: 57, warpStoryId: 1)
  );

  // 選択肢B // 最後の場合retunStoryId - 1に設定
  await db.into(db.choiseTable).insert(
    ChoiseTableCompanion.insert(storyId: 34, word: 'ヒロインBを選ぶ', choiceGroup: 1, nextStoryId: 57, returnStoryId: 84, warpStoryId: 1)
  );

  print('初期データ挿入完了');
}