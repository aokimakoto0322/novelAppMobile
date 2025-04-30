// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoryTableTable extends StoryTable
    with TableInfo<$StoryTableTable, Story> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sortIdMeta = const VerificationMeta('sortId');
  @override
  late final GeneratedColumn<String> sortId = GeneratedColumn<String>(
    'sort_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageNameMeta = const VerificationMeta(
    'imageName',
  );
  @override
  late final GeneratedColumn<String> imageName = GeneratedColumn<String>(
    'image_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sortId, word, imageName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Story> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sort_id')) {
      context.handle(
        _sortIdMeta,
        sortId.isAcceptableOrUnknown(data['sort_id']!, _sortIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('image_name')) {
      context.handle(
        _imageNameMeta,
        imageName.isAcceptableOrUnknown(data['image_name']!, _imageNameMeta),
      );
    } else if (isInserting) {
      context.missing(_imageNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Story map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Story(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sortId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sort_id'],
          )!,
      word:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}word'],
          )!,
      imageName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}image_name'],
          )!,
    );
  }

  @override
  $StoryTableTable createAlias(String alias) {
    return $StoryTableTable(attachedDatabase, alias);
  }
}

class Story extends DataClass implements Insertable<Story> {
  final int id;
  final String sortId;
  final String word;
  final String imageName;
  const Story({
    required this.id,
    required this.sortId,
    required this.word,
    required this.imageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sort_id'] = Variable<String>(sortId);
    map['word'] = Variable<String>(word);
    map['image_name'] = Variable<String>(imageName);
    return map;
  }

  StoryTableCompanion toCompanion(bool nullToAbsent) {
    return StoryTableCompanion(
      id: Value(id),
      sortId: Value(sortId),
      word: Value(word),
      imageName: Value(imageName),
    );
  }

  factory Story.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Story(
      id: serializer.fromJson<int>(json['story_id']),
      sortId: serializer.fromJson<String>(json['sort_id']),
      word: serializer.fromJson<String>(json['word']),
      imageName: serializer.fromJson<String>(json['image_name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'story_id': serializer.toJson<int>(id),
      'sort_id': serializer.toJson<String>(sortId),
      'word': serializer.toJson<String>(word),
      'image_name': serializer.toJson<String>(imageName),
    };
  }

  Story copyWith({int? id, String? sortId, String? word, String? imageName}) =>
      Story(
        id: id ?? this.id,
        sortId: sortId ?? this.sortId,
        word: word ?? this.word,
        imageName: imageName ?? this.imageName,
      );
  Story copyWithCompanion(StoryTableCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      sortId: data.sortId.present ? data.sortId.value : this.sortId,
      word: data.word.present ? data.word.value : this.word,
      imageName: data.imageName.present ? data.imageName.value : this.imageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('sortId: $sortId, ')
          ..write('word: $word, ')
          ..write('imageName: $imageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sortId, word, imageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.sortId == this.sortId &&
          other.word == this.word &&
          other.imageName == this.imageName);
}

class StoryTableCompanion extends UpdateCompanion<Story> {
  final Value<int> id;
  final Value<String> sortId;
  final Value<String> word;
  final Value<String> imageName;
  const StoryTableCompanion({
    this.id = const Value.absent(),
    this.sortId = const Value.absent(),
    this.word = const Value.absent(),
    this.imageName = const Value.absent(),
  });
  StoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String sortId,
    required String word,
    required String imageName,
  }) : sortId = Value(sortId),
       word = Value(word),
       imageName = Value(imageName);
  static Insertable<Story> custom({
    Expression<int>? id,
    Expression<String>? sortId,
    Expression<String>? word,
    Expression<String>? imageName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sortId != null) 'sort_id': sortId,
      if (word != null) 'word': word,
      if (imageName != null) 'image_name': imageName,
    });
  }

  StoryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? sortId,
    Value<String>? word,
    Value<String>? imageName,
  }) {
    return StoryTableCompanion(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      word: word ?? this.word,
      imageName: imageName ?? this.imageName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sortId.present) {
      map['sort_id'] = Variable<String>(sortId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (imageName.present) {
      map['image_name'] = Variable<String>(imageName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryTableCompanion(')
          ..write('id: $id, ')
          ..write('sortId: $sortId, ')
          ..write('word: $word, ')
          ..write('imageName: $imageName')
          ..write(')'))
        .toString();
  }
}

class $SaveTableTable extends SaveTable with TableInfo<$SaveTableTable, Save> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaveTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<int> storyId = GeneratedColumn<int>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saveDateMeta = const VerificationMeta(
    'saveDate',
  );
  @override
  late final GeneratedColumn<String> saveDate = GeneratedColumn<String>(
    'save_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, storyId, saveDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'save_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Save> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('save_date')) {
      context.handle(
        _saveDateMeta,
        saveDate.isAcceptableOrUnknown(data['save_date']!, _saveDateMeta),
      );
    } else if (isInserting) {
      context.missing(_saveDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Save map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Save(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      storyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}story_id'],
          )!,
      saveDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}save_date'],
          )!,
    );
  }

  @override
  $SaveTableTable createAlias(String alias) {
    return $SaveTableTable(attachedDatabase, alias);
  }
}

class Save extends DataClass implements Insertable<Save> {
  final int id;
  final int storyId;
  final String saveDate;
  const Save({required this.id, required this.storyId, required this.saveDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['story_id'] = Variable<int>(storyId);
    map['save_date'] = Variable<String>(saveDate);
    return map;
  }

  SaveTableCompanion toCompanion(bool nullToAbsent) {
    return SaveTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      saveDate: Value(saveDate),
    );
  }

  factory Save.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Save(
      id: serializer.fromJson<int>(json['id']),
      storyId: serializer.fromJson<int>(json['storyId']),
      saveDate: serializer.fromJson<String>(json['saveDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storyId': serializer.toJson<int>(storyId),
      'saveDate': serializer.toJson<String>(saveDate),
    };
  }

  Save copyWith({int? id, int? storyId, String? saveDate}) => Save(
    id: id ?? this.id,
    storyId: storyId ?? this.storyId,
    saveDate: saveDate ?? this.saveDate,
  );
  Save copyWithCompanion(SaveTableCompanion data) {
    return Save(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      saveDate: data.saveDate.present ? data.saveDate.value : this.saveDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Save(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('saveDate: $saveDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, saveDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Save &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.saveDate == this.saveDate);
}

class SaveTableCompanion extends UpdateCompanion<Save> {
  final Value<int> id;
  final Value<int> storyId;
  final Value<String> saveDate;
  const SaveTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.saveDate = const Value.absent(),
  });
  SaveTableCompanion.insert({
    this.id = const Value.absent(),
    required int storyId,
    required String saveDate,
  }) : storyId = Value(storyId),
       saveDate = Value(saveDate);
  static Insertable<Save> custom({
    Expression<int>? id,
    Expression<int>? storyId,
    Expression<String>? saveDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (saveDate != null) 'save_date': saveDate,
    });
  }

  SaveTableCompanion copyWith({
    Value<int>? id,
    Value<int>? storyId,
    Value<String>? saveDate,
  }) {
    return SaveTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      saveDate: saveDate ?? this.saveDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<int>(storyId.value);
    }
    if (saveDate.present) {
      map['save_date'] = Variable<String>(saveDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaveTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('saveDate: $saveDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $StoryTableTable storyTable = $StoryTableTable(this);
  late final $SaveTableTable saveTable = $SaveTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storyTable, saveTable];
}

typedef $$StoryTableTableCreateCompanionBuilder =
    StoryTableCompanion Function({
      Value<int> id,
      required String sortId,
      required String word,
      required String imageName,
    });
typedef $$StoryTableTableUpdateCompanionBuilder =
    StoryTableCompanion Function({
      Value<int> id,
      Value<String> sortId,
      Value<String> word,
      Value<String> imageName,
    });

class $$StoryTableTableFilterComposer
    extends Composer<_$MyDatabase, $StoryTableTable> {
  $$StoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortId => $composableBuilder(
    column: $table.sortId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageName => $composableBuilder(
    column: $table.imageName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoryTableTableOrderingComposer
    extends Composer<_$MyDatabase, $StoryTableTable> {
  $$StoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortId => $composableBuilder(
    column: $table.sortId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageName => $composableBuilder(
    column: $table.imageName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoryTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $StoryTableTable> {
  $$StoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sortId =>
      $composableBuilder(column: $table.sortId, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get imageName =>
      $composableBuilder(column: $table.imageName, builder: (column) => column);
}

class $$StoryTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $StoryTableTable,
          Story,
          $$StoryTableTableFilterComposer,
          $$StoryTableTableOrderingComposer,
          $$StoryTableTableAnnotationComposer,
          $$StoryTableTableCreateCompanionBuilder,
          $$StoryTableTableUpdateCompanionBuilder,
          (Story, BaseReferences<_$MyDatabase, $StoryTableTable, Story>),
          Story,
          PrefetchHooks Function()
        > {
  $$StoryTableTableTableManager(_$MyDatabase db, $StoryTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$StoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sortId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> imageName = const Value.absent(),
              }) => StoryTableCompanion(
                id: id,
                sortId: sortId,
                word: word,
                imageName: imageName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sortId,
                required String word,
                required String imageName,
              }) => StoryTableCompanion.insert(
                id: id,
                sortId: sortId,
                word: word,
                imageName: imageName,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $StoryTableTable,
      Story,
      $$StoryTableTableFilterComposer,
      $$StoryTableTableOrderingComposer,
      $$StoryTableTableAnnotationComposer,
      $$StoryTableTableCreateCompanionBuilder,
      $$StoryTableTableUpdateCompanionBuilder,
      (Story, BaseReferences<_$MyDatabase, $StoryTableTable, Story>),
      Story,
      PrefetchHooks Function()
    >;
typedef $$SaveTableTableCreateCompanionBuilder =
    SaveTableCompanion Function({
      Value<int> id,
      required int storyId,
      required String saveDate,
    });
typedef $$SaveTableTableUpdateCompanionBuilder =
    SaveTableCompanion Function({
      Value<int> id,
      Value<int> storyId,
      Value<String> saveDate,
    });

class $$SaveTableTableFilterComposer
    extends Composer<_$MyDatabase, $SaveTableTable> {
  $$SaveTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saveDate => $composableBuilder(
    column: $table.saveDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaveTableTableOrderingComposer
    extends Composer<_$MyDatabase, $SaveTableTable> {
  $$SaveTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saveDate => $composableBuilder(
    column: $table.saveDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaveTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $SaveTableTable> {
  $$SaveTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<String> get saveDate =>
      $composableBuilder(column: $table.saveDate, builder: (column) => column);
}

class $$SaveTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $SaveTableTable,
          Save,
          $$SaveTableTableFilterComposer,
          $$SaveTableTableOrderingComposer,
          $$SaveTableTableAnnotationComposer,
          $$SaveTableTableCreateCompanionBuilder,
          $$SaveTableTableUpdateCompanionBuilder,
          (Save, BaseReferences<_$MyDatabase, $SaveTableTable, Save>),
          Save,
          PrefetchHooks Function()
        > {
  $$SaveTableTableTableManager(_$MyDatabase db, $SaveTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SaveTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SaveTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SaveTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> storyId = const Value.absent(),
                Value<String> saveDate = const Value.absent(),
              }) => SaveTableCompanion(
                id: id,
                storyId: storyId,
                saveDate: saveDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int storyId,
                required String saveDate,
              }) => SaveTableCompanion.insert(
                id: id,
                storyId: storyId,
                saveDate: saveDate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaveTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $SaveTableTable,
      Save,
      $$SaveTableTableFilterComposer,
      $$SaveTableTableOrderingComposer,
      $$SaveTableTableAnnotationComposer,
      $$SaveTableTableCreateCompanionBuilder,
      $$SaveTableTableUpdateCompanionBuilder,
      (Save, BaseReferences<_$MyDatabase, $SaveTableTable, Save>),
      Save,
      PrefetchHooks Function()
    >;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$StoryTableTableTableManager get storyTable =>
      $$StoryTableTableTableManager(_db, _db.storyTable);
  $$SaveTableTableTableManager get saveTable =>
      $$SaveTableTableTableManager(_db, _db.saveTable);
}
