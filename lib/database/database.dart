import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

int? stringToInt(String value) {
  return int.tryParse(value);
}

@DataClassName('CommonStory')
class CommonStoryTable extends Table {
  
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

@DriftDatabase(tables: [CommonStoryTable, SaveTable])
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
