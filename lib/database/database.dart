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

  @JsonKey('is_common')
  BoolColumn get isCommon => boolean().nullable()(); // 共通ストーリーかそうでないかを判定、falseの場合は個別ストーリーとなる
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
