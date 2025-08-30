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
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
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
  List<GeneratedColumn> get $columns => [
    id,
    sortId,
    word,
    speaker,
    description,
    imageName,
  ];
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
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
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
      speaker:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}speaker'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
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
  final String speaker;
  final String description;
  final String imageName;
  const Story({
    required this.id,
    required this.sortId,
    required this.word,
    required this.speaker,
    required this.description,
    required this.imageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sort_id'] = Variable<String>(sortId);
    map['word'] = Variable<String>(word);
    map['speaker'] = Variable<String>(speaker);
    map['description'] = Variable<String>(description);
    map['image_name'] = Variable<String>(imageName);
    return map;
  }

  StoryTableCompanion toCompanion(bool nullToAbsent) {
    return StoryTableCompanion(
      id: Value(id),
      sortId: Value(sortId),
      word: Value(word),
      speaker: Value(speaker),
      description: Value(description),
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
      speaker: serializer.fromJson<String>(json['speaker']),
      description: serializer.fromJson<String>(json['description']),
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
      'speaker': serializer.toJson<String>(speaker),
      'description': serializer.toJson<String>(description),
      'image_name': serializer.toJson<String>(imageName),
    };
  }

  Story copyWith({
    int? id,
    String? sortId,
    String? word,
    String? speaker,
    String? description,
    String? imageName,
  }) => Story(
    id: id ?? this.id,
    sortId: sortId ?? this.sortId,
    word: word ?? this.word,
    speaker: speaker ?? this.speaker,
    description: description ?? this.description,
    imageName: imageName ?? this.imageName,
  );
  Story copyWithCompanion(StoryTableCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      sortId: data.sortId.present ? data.sortId.value : this.sortId,
      word: data.word.present ? data.word.value : this.word,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      description:
          data.description.present ? data.description.value : this.description,
      imageName: data.imageName.present ? data.imageName.value : this.imageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('sortId: $sortId, ')
          ..write('word: $word, ')
          ..write('speaker: $speaker, ')
          ..write('description: $description, ')
          ..write('imageName: $imageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sortId, word, speaker, description, imageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.sortId == this.sortId &&
          other.word == this.word &&
          other.speaker == this.speaker &&
          other.description == this.description &&
          other.imageName == this.imageName);
}

class StoryTableCompanion extends UpdateCompanion<Story> {
  final Value<int> id;
  final Value<String> sortId;
  final Value<String> word;
  final Value<String> speaker;
  final Value<String> description;
  final Value<String> imageName;
  const StoryTableCompanion({
    this.id = const Value.absent(),
    this.sortId = const Value.absent(),
    this.word = const Value.absent(),
    this.speaker = const Value.absent(),
    this.description = const Value.absent(),
    this.imageName = const Value.absent(),
  });
  StoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String sortId,
    required String word,
    required String speaker,
    required String description,
    required String imageName,
  }) : sortId = Value(sortId),
       word = Value(word),
       speaker = Value(speaker),
       description = Value(description),
       imageName = Value(imageName);
  static Insertable<Story> custom({
    Expression<int>? id,
    Expression<String>? sortId,
    Expression<String>? word,
    Expression<String>? speaker,
    Expression<String>? description,
    Expression<String>? imageName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sortId != null) 'sort_id': sortId,
      if (word != null) 'word': word,
      if (speaker != null) 'speaker': speaker,
      if (description != null) 'description': description,
      if (imageName != null) 'image_name': imageName,
    });
  }

  StoryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? sortId,
    Value<String>? word,
    Value<String>? speaker,
    Value<String>? description,
    Value<String>? imageName,
  }) {
    return StoryTableCompanion(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      word: word ?? this.word,
      speaker: speaker ?? this.speaker,
      description: description ?? this.description,
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
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
          ..write('speaker: $speaker, ')
          ..write('description: $description, ')
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

class $ChoiseTableTable extends ChoiseTable
    with TableInfo<$ChoiseTableTable, Choice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChoiseTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextStoryIdMeta = const VerificationMeta(
    'nextStoryId',
  );
  @override
  late final GeneratedColumn<int> nextStoryId = GeneratedColumn<int>(
    'next_story_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnStoryIdMeta = const VerificationMeta(
    'returnStoryId',
  );
  @override
  late final GeneratedColumn<int> returnStoryId = GeneratedColumn<int>(
    'return_story_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warpStoryIdMeta = const VerificationMeta(
    'warpStoryId',
  );
  @override
  late final GeneratedColumn<int> warpStoryId = GeneratedColumn<int>(
    'warp_story_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storyId,
    word,
    nextStoryId,
    returnStoryId,
    warpStoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'choise_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Choice> instance, {
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
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('next_story_id')) {
      context.handle(
        _nextStoryIdMeta,
        nextStoryId.isAcceptableOrUnknown(
          data['next_story_id']!,
          _nextStoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextStoryIdMeta);
    }
    if (data.containsKey('return_story_id')) {
      context.handle(
        _returnStoryIdMeta,
        returnStoryId.isAcceptableOrUnknown(
          data['return_story_id']!,
          _returnStoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_returnStoryIdMeta);
    }
    if (data.containsKey('warp_story_id')) {
      context.handle(
        _warpStoryIdMeta,
        warpStoryId.isAcceptableOrUnknown(
          data['warp_story_id']!,
          _warpStoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warpStoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Choice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Choice(
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
      word:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}word'],
          )!,
      nextStoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}next_story_id'],
          )!,
      returnStoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}return_story_id'],
          )!,
      warpStoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}warp_story_id'],
          )!,
    );
  }

  @override
  $ChoiseTableTable createAlias(String alias) {
    return $ChoiseTableTable(attachedDatabase, alias);
  }
}

class Choice extends DataClass implements Insertable<Choice> {
  final int id;
  final int storyId;
  final String word;
  final int nextStoryId;
  final int returnStoryId;
  final int warpStoryId;
  const Choice({
    required this.id,
    required this.storyId,
    required this.word,
    required this.nextStoryId,
    required this.returnStoryId,
    required this.warpStoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['story_id'] = Variable<int>(storyId);
    map['word'] = Variable<String>(word);
    map['next_story_id'] = Variable<int>(nextStoryId);
    map['return_story_id'] = Variable<int>(returnStoryId);
    map['warp_story_id'] = Variable<int>(warpStoryId);
    return map;
  }

  ChoiseTableCompanion toCompanion(bool nullToAbsent) {
    return ChoiseTableCompanion(
      id: Value(id),
      storyId: Value(storyId),
      word: Value(word),
      nextStoryId: Value(nextStoryId),
      returnStoryId: Value(returnStoryId),
      warpStoryId: Value(warpStoryId),
    );
  }

  factory Choice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Choice(
      id: serializer.fromJson<int>(json['id']),
      storyId: serializer.fromJson<int>(json['storyId']),
      word: serializer.fromJson<String>(json['word']),
      nextStoryId: serializer.fromJson<int>(json['nextStoryId']),
      returnStoryId: serializer.fromJson<int>(json['returnStoryId']),
      warpStoryId: serializer.fromJson<int>(json['warpStoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storyId': serializer.toJson<int>(storyId),
      'word': serializer.toJson<String>(word),
      'nextStoryId': serializer.toJson<int>(nextStoryId),
      'returnStoryId': serializer.toJson<int>(returnStoryId),
      'warpStoryId': serializer.toJson<int>(warpStoryId),
    };
  }

  Choice copyWith({
    int? id,
    int? storyId,
    String? word,
    int? nextStoryId,
    int? returnStoryId,
    int? warpStoryId,
  }) => Choice(
    id: id ?? this.id,
    storyId: storyId ?? this.storyId,
    word: word ?? this.word,
    nextStoryId: nextStoryId ?? this.nextStoryId,
    returnStoryId: returnStoryId ?? this.returnStoryId,
    warpStoryId: warpStoryId ?? this.warpStoryId,
  );
  Choice copyWithCompanion(ChoiseTableCompanion data) {
    return Choice(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      word: data.word.present ? data.word.value : this.word,
      nextStoryId:
          data.nextStoryId.present ? data.nextStoryId.value : this.nextStoryId,
      returnStoryId:
          data.returnStoryId.present
              ? data.returnStoryId.value
              : this.returnStoryId,
      warpStoryId:
          data.warpStoryId.present ? data.warpStoryId.value : this.warpStoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Choice(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('word: $word, ')
          ..write('nextStoryId: $nextStoryId, ')
          ..write('returnStoryId: $returnStoryId, ')
          ..write('warpStoryId: $warpStoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storyId, word, nextStoryId, returnStoryId, warpStoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Choice &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.word == this.word &&
          other.nextStoryId == this.nextStoryId &&
          other.returnStoryId == this.returnStoryId &&
          other.warpStoryId == this.warpStoryId);
}

class ChoiseTableCompanion extends UpdateCompanion<Choice> {
  final Value<int> id;
  final Value<int> storyId;
  final Value<String> word;
  final Value<int> nextStoryId;
  final Value<int> returnStoryId;
  final Value<int> warpStoryId;
  const ChoiseTableCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.word = const Value.absent(),
    this.nextStoryId = const Value.absent(),
    this.returnStoryId = const Value.absent(),
    this.warpStoryId = const Value.absent(),
  });
  ChoiseTableCompanion.insert({
    this.id = const Value.absent(),
    required int storyId,
    required String word,
    required int nextStoryId,
    required int returnStoryId,
    required int warpStoryId,
  }) : storyId = Value(storyId),
       word = Value(word),
       nextStoryId = Value(nextStoryId),
       returnStoryId = Value(returnStoryId),
       warpStoryId = Value(warpStoryId);
  static Insertable<Choice> custom({
    Expression<int>? id,
    Expression<int>? storyId,
    Expression<String>? word,
    Expression<int>? nextStoryId,
    Expression<int>? returnStoryId,
    Expression<int>? warpStoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (word != null) 'word': word,
      if (nextStoryId != null) 'next_story_id': nextStoryId,
      if (returnStoryId != null) 'return_story_id': returnStoryId,
      if (warpStoryId != null) 'warp_story_id': warpStoryId,
    });
  }

  ChoiseTableCompanion copyWith({
    Value<int>? id,
    Value<int>? storyId,
    Value<String>? word,
    Value<int>? nextStoryId,
    Value<int>? returnStoryId,
    Value<int>? warpStoryId,
  }) {
    return ChoiseTableCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      word: word ?? this.word,
      nextStoryId: nextStoryId ?? this.nextStoryId,
      returnStoryId: returnStoryId ?? this.returnStoryId,
      warpStoryId: warpStoryId ?? this.warpStoryId,
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
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (nextStoryId.present) {
      map['next_story_id'] = Variable<int>(nextStoryId.value);
    }
    if (returnStoryId.present) {
      map['return_story_id'] = Variable<int>(returnStoryId.value);
    }
    if (warpStoryId.present) {
      map['warp_story_id'] = Variable<int>(warpStoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChoiseTableCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('word: $word, ')
          ..write('nextStoryId: $nextStoryId, ')
          ..write('returnStoryId: $returnStoryId, ')
          ..write('warpStoryId: $warpStoryId')
          ..write(')'))
        .toString();
  }
}

class $ChoiceLogTableTable extends ChoiceLogTable
    with TableInfo<$ChoiceLogTableTable, ChoiceLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChoiceLogTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _saveIdMeta = const VerificationMeta('saveId');
  @override
  late final GeneratedColumn<int> saveId = GeneratedColumn<int>(
    'save_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choiceIdMeta = const VerificationMeta(
    'choiceId',
  );
  @override
  late final GeneratedColumn<int> choiceId = GeneratedColumn<int>(
    'choice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, saveId, choiceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'choice_log_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoiceLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_id')) {
      context.handle(
        _saveIdMeta,
        saveId.isAcceptableOrUnknown(data['save_id']!, _saveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saveIdMeta);
    }
    if (data.containsKey('choice_id')) {
      context.handle(
        _choiceIdMeta,
        choiceId.isAcceptableOrUnknown(data['choice_id']!, _choiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_choiceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChoiceLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoiceLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      saveId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}save_id'],
          )!,
      choiceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}choice_id'],
          )!,
    );
  }

  @override
  $ChoiceLogTableTable createAlias(String alias) {
    return $ChoiceLogTableTable(attachedDatabase, alias);
  }
}

class ChoiceLog extends DataClass implements Insertable<ChoiceLog> {
  final int id;
  final int saveId;
  final int choiceId;
  const ChoiceLog({
    required this.id,
    required this.saveId,
    required this.choiceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_id'] = Variable<int>(saveId);
    map['choice_id'] = Variable<int>(choiceId);
    return map;
  }

  ChoiceLogTableCompanion toCompanion(bool nullToAbsent) {
    return ChoiceLogTableCompanion(
      id: Value(id),
      saveId: Value(saveId),
      choiceId: Value(choiceId),
    );
  }

  factory ChoiceLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoiceLog(
      id: serializer.fromJson<int>(json['id']),
      saveId: serializer.fromJson<int>(json['saveId']),
      choiceId: serializer.fromJson<int>(json['choiceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveId': serializer.toJson<int>(saveId),
      'choiceId': serializer.toJson<int>(choiceId),
    };
  }

  ChoiceLog copyWith({int? id, int? saveId, int? choiceId}) => ChoiceLog(
    id: id ?? this.id,
    saveId: saveId ?? this.saveId,
    choiceId: choiceId ?? this.choiceId,
  );
  ChoiceLog copyWithCompanion(ChoiceLogTableCompanion data) {
    return ChoiceLog(
      id: data.id.present ? data.id.value : this.id,
      saveId: data.saveId.present ? data.saveId.value : this.saveId,
      choiceId: data.choiceId.present ? data.choiceId.value : this.choiceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceLog(')
          ..write('id: $id, ')
          ..write('saveId: $saveId, ')
          ..write('choiceId: $choiceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saveId, choiceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoiceLog &&
          other.id == this.id &&
          other.saveId == this.saveId &&
          other.choiceId == this.choiceId);
}

class ChoiceLogTableCompanion extends UpdateCompanion<ChoiceLog> {
  final Value<int> id;
  final Value<int> saveId;
  final Value<int> choiceId;
  const ChoiceLogTableCompanion({
    this.id = const Value.absent(),
    this.saveId = const Value.absent(),
    this.choiceId = const Value.absent(),
  });
  ChoiceLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int saveId,
    required int choiceId,
  }) : saveId = Value(saveId),
       choiceId = Value(choiceId);
  static Insertable<ChoiceLog> custom({
    Expression<int>? id,
    Expression<int>? saveId,
    Expression<int>? choiceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveId != null) 'save_id': saveId,
      if (choiceId != null) 'choice_id': choiceId,
    });
  }

  ChoiceLogTableCompanion copyWith({
    Value<int>? id,
    Value<int>? saveId,
    Value<int>? choiceId,
  }) {
    return ChoiceLogTableCompanion(
      id: id ?? this.id,
      saveId: saveId ?? this.saveId,
      choiceId: choiceId ?? this.choiceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveId.present) {
      map['save_id'] = Variable<int>(saveId.value);
    }
    if (choiceId.present) {
      map['choice_id'] = Variable<int>(choiceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceLogTableCompanion(')
          ..write('id: $id, ')
          ..write('saveId: $saveId, ')
          ..write('choiceId: $choiceId')
          ..write(')'))
        .toString();
  }
}

class $ChoiceLogSelectTableTable extends ChoiceLogSelectTable
    with TableInfo<$ChoiceLogSelectTableTable, ChoiceLogSelect> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChoiceLogSelectTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _choiceLogIdMeta = const VerificationMeta(
    'choiceLogId',
  );
  @override
  late final GeneratedColumn<int> choiceLogId = GeneratedColumn<int>(
    'choice_log_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, choiceLogId, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'choice_log_select_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoiceLogSelect> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('choice_log_id')) {
      context.handle(
        _choiceLogIdMeta,
        choiceLogId.isAcceptableOrUnknown(
          data['choice_log_id']!,
          _choiceLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_choiceLogIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChoiceLogSelect map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoiceLogSelect(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      choiceLogId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}choice_log_id'],
          )!,
      order:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}order'],
          )!,
    );
  }

  @override
  $ChoiceLogSelectTableTable createAlias(String alias) {
    return $ChoiceLogSelectTableTable(attachedDatabase, alias);
  }
}

class ChoiceLogSelect extends DataClass implements Insertable<ChoiceLogSelect> {
  final int id;
  final int choiceLogId;
  final int order;
  const ChoiceLogSelect({
    required this.id,
    required this.choiceLogId,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['choice_log_id'] = Variable<int>(choiceLogId);
    map['order'] = Variable<int>(order);
    return map;
  }

  ChoiceLogSelectTableCompanion toCompanion(bool nullToAbsent) {
    return ChoiceLogSelectTableCompanion(
      id: Value(id),
      choiceLogId: Value(choiceLogId),
      order: Value(order),
    );
  }

  factory ChoiceLogSelect.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoiceLogSelect(
      id: serializer.fromJson<int>(json['id']),
      choiceLogId: serializer.fromJson<int>(json['choiceLogId']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'choiceLogId': serializer.toJson<int>(choiceLogId),
      'order': serializer.toJson<int>(order),
    };
  }

  ChoiceLogSelect copyWith({int? id, int? choiceLogId, int? order}) =>
      ChoiceLogSelect(
        id: id ?? this.id,
        choiceLogId: choiceLogId ?? this.choiceLogId,
        order: order ?? this.order,
      );
  ChoiceLogSelect copyWithCompanion(ChoiceLogSelectTableCompanion data) {
    return ChoiceLogSelect(
      id: data.id.present ? data.id.value : this.id,
      choiceLogId:
          data.choiceLogId.present ? data.choiceLogId.value : this.choiceLogId,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceLogSelect(')
          ..write('id: $id, ')
          ..write('choiceLogId: $choiceLogId, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, choiceLogId, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoiceLogSelect &&
          other.id == this.id &&
          other.choiceLogId == this.choiceLogId &&
          other.order == this.order);
}

class ChoiceLogSelectTableCompanion extends UpdateCompanion<ChoiceLogSelect> {
  final Value<int> id;
  final Value<int> choiceLogId;
  final Value<int> order;
  const ChoiceLogSelectTableCompanion({
    this.id = const Value.absent(),
    this.choiceLogId = const Value.absent(),
    this.order = const Value.absent(),
  });
  ChoiceLogSelectTableCompanion.insert({
    this.id = const Value.absent(),
    required int choiceLogId,
    required int order,
  }) : choiceLogId = Value(choiceLogId),
       order = Value(order);
  static Insertable<ChoiceLogSelect> custom({
    Expression<int>? id,
    Expression<int>? choiceLogId,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (choiceLogId != null) 'choice_log_id': choiceLogId,
      if (order != null) 'order': order,
    });
  }

  ChoiceLogSelectTableCompanion copyWith({
    Value<int>? id,
    Value<int>? choiceLogId,
    Value<int>? order,
  }) {
    return ChoiceLogSelectTableCompanion(
      id: id ?? this.id,
      choiceLogId: choiceLogId ?? this.choiceLogId,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (choiceLogId.present) {
      map['choice_log_id'] = Variable<int>(choiceLogId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChoiceLogSelectTableCompanion(')
          ..write('id: $id, ')
          ..write('choiceLogId: $choiceLogId, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $StoryTableTable storyTable = $StoryTableTable(this);
  late final $SaveTableTable saveTable = $SaveTableTable(this);
  late final $ChoiseTableTable choiseTable = $ChoiseTableTable(this);
  late final $ChoiceLogTableTable choiceLogTable = $ChoiceLogTableTable(this);
  late final $ChoiceLogSelectTableTable choiceLogSelectTable =
      $ChoiceLogSelectTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storyTable,
    saveTable,
    choiseTable,
    choiceLogTable,
    choiceLogSelectTable,
  ];
}

typedef $$StoryTableTableCreateCompanionBuilder =
    StoryTableCompanion Function({
      Value<int> id,
      required String sortId,
      required String word,
      required String speaker,
      required String description,
      required String imageName,
    });
typedef $$StoryTableTableUpdateCompanionBuilder =
    StoryTableCompanion Function({
      Value<int> id,
      Value<String> sortId,
      Value<String> word,
      Value<String> speaker,
      Value<String> description,
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

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
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

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
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

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

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
                Value<String> speaker = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> imageName = const Value.absent(),
              }) => StoryTableCompanion(
                id: id,
                sortId: sortId,
                word: word,
                speaker: speaker,
                description: description,
                imageName: imageName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sortId,
                required String word,
                required String speaker,
                required String description,
                required String imageName,
              }) => StoryTableCompanion.insert(
                id: id,
                sortId: sortId,
                word: word,
                speaker: speaker,
                description: description,
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
typedef $$ChoiseTableTableCreateCompanionBuilder =
    ChoiseTableCompanion Function({
      Value<int> id,
      required int storyId,
      required String word,
      required int nextStoryId,
      required int returnStoryId,
      required int warpStoryId,
    });
typedef $$ChoiseTableTableUpdateCompanionBuilder =
    ChoiseTableCompanion Function({
      Value<int> id,
      Value<int> storyId,
      Value<String> word,
      Value<int> nextStoryId,
      Value<int> returnStoryId,
      Value<int> warpStoryId,
    });

class $$ChoiseTableTableFilterComposer
    extends Composer<_$MyDatabase, $ChoiseTableTable> {
  $$ChoiseTableTableFilterComposer({
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

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextStoryId => $composableBuilder(
    column: $table.nextStoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnStoryId => $composableBuilder(
    column: $table.returnStoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warpStoryId => $composableBuilder(
    column: $table.warpStoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChoiseTableTableOrderingComposer
    extends Composer<_$MyDatabase, $ChoiseTableTable> {
  $$ChoiseTableTableOrderingComposer({
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

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextStoryId => $composableBuilder(
    column: $table.nextStoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnStoryId => $composableBuilder(
    column: $table.returnStoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warpStoryId => $composableBuilder(
    column: $table.warpStoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChoiseTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $ChoiseTableTable> {
  $$ChoiseTableTableAnnotationComposer({
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

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<int> get nextStoryId => $composableBuilder(
    column: $table.nextStoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get returnStoryId => $composableBuilder(
    column: $table.returnStoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warpStoryId => $composableBuilder(
    column: $table.warpStoryId,
    builder: (column) => column,
  );
}

class $$ChoiseTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $ChoiseTableTable,
          Choice,
          $$ChoiseTableTableFilterComposer,
          $$ChoiseTableTableOrderingComposer,
          $$ChoiseTableTableAnnotationComposer,
          $$ChoiseTableTableCreateCompanionBuilder,
          $$ChoiseTableTableUpdateCompanionBuilder,
          (Choice, BaseReferences<_$MyDatabase, $ChoiseTableTable, Choice>),
          Choice,
          PrefetchHooks Function()
        > {
  $$ChoiseTableTableTableManager(_$MyDatabase db, $ChoiseTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChoiseTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ChoiseTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ChoiseTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> storyId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<int> nextStoryId = const Value.absent(),
                Value<int> returnStoryId = const Value.absent(),
                Value<int> warpStoryId = const Value.absent(),
              }) => ChoiseTableCompanion(
                id: id,
                storyId: storyId,
                word: word,
                nextStoryId: nextStoryId,
                returnStoryId: returnStoryId,
                warpStoryId: warpStoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int storyId,
                required String word,
                required int nextStoryId,
                required int returnStoryId,
                required int warpStoryId,
              }) => ChoiseTableCompanion.insert(
                id: id,
                storyId: storyId,
                word: word,
                nextStoryId: nextStoryId,
                returnStoryId: returnStoryId,
                warpStoryId: warpStoryId,
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

typedef $$ChoiseTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $ChoiseTableTable,
      Choice,
      $$ChoiseTableTableFilterComposer,
      $$ChoiseTableTableOrderingComposer,
      $$ChoiseTableTableAnnotationComposer,
      $$ChoiseTableTableCreateCompanionBuilder,
      $$ChoiseTableTableUpdateCompanionBuilder,
      (Choice, BaseReferences<_$MyDatabase, $ChoiseTableTable, Choice>),
      Choice,
      PrefetchHooks Function()
    >;
typedef $$ChoiceLogTableTableCreateCompanionBuilder =
    ChoiceLogTableCompanion Function({
      Value<int> id,
      required int saveId,
      required int choiceId,
    });
typedef $$ChoiceLogTableTableUpdateCompanionBuilder =
    ChoiceLogTableCompanion Function({
      Value<int> id,
      Value<int> saveId,
      Value<int> choiceId,
    });

class $$ChoiceLogTableTableFilterComposer
    extends Composer<_$MyDatabase, $ChoiceLogTableTable> {
  $$ChoiceLogTableTableFilterComposer({
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

  ColumnFilters<int> get saveId => $composableBuilder(
    column: $table.saveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get choiceId => $composableBuilder(
    column: $table.choiceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChoiceLogTableTableOrderingComposer
    extends Composer<_$MyDatabase, $ChoiceLogTableTable> {
  $$ChoiceLogTableTableOrderingComposer({
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

  ColumnOrderings<int> get saveId => $composableBuilder(
    column: $table.saveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get choiceId => $composableBuilder(
    column: $table.choiceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChoiceLogTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $ChoiceLogTableTable> {
  $$ChoiceLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saveId =>
      $composableBuilder(column: $table.saveId, builder: (column) => column);

  GeneratedColumn<int> get choiceId =>
      $composableBuilder(column: $table.choiceId, builder: (column) => column);
}

class $$ChoiceLogTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $ChoiceLogTableTable,
          ChoiceLog,
          $$ChoiceLogTableTableFilterComposer,
          $$ChoiceLogTableTableOrderingComposer,
          $$ChoiceLogTableTableAnnotationComposer,
          $$ChoiceLogTableTableCreateCompanionBuilder,
          $$ChoiceLogTableTableUpdateCompanionBuilder,
          (
            ChoiceLog,
            BaseReferences<_$MyDatabase, $ChoiceLogTableTable, ChoiceLog>,
          ),
          ChoiceLog,
          PrefetchHooks Function()
        > {
  $$ChoiceLogTableTableTableManager(_$MyDatabase db, $ChoiceLogTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChoiceLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ChoiceLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ChoiceLogTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saveId = const Value.absent(),
                Value<int> choiceId = const Value.absent(),
              }) => ChoiceLogTableCompanion(
                id: id,
                saveId: saveId,
                choiceId: choiceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saveId,
                required int choiceId,
              }) => ChoiceLogTableCompanion.insert(
                id: id,
                saveId: saveId,
                choiceId: choiceId,
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

typedef $$ChoiceLogTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $ChoiceLogTableTable,
      ChoiceLog,
      $$ChoiceLogTableTableFilterComposer,
      $$ChoiceLogTableTableOrderingComposer,
      $$ChoiceLogTableTableAnnotationComposer,
      $$ChoiceLogTableTableCreateCompanionBuilder,
      $$ChoiceLogTableTableUpdateCompanionBuilder,
      (
        ChoiceLog,
        BaseReferences<_$MyDatabase, $ChoiceLogTableTable, ChoiceLog>,
      ),
      ChoiceLog,
      PrefetchHooks Function()
    >;
typedef $$ChoiceLogSelectTableTableCreateCompanionBuilder =
    ChoiceLogSelectTableCompanion Function({
      Value<int> id,
      required int choiceLogId,
      required int order,
    });
typedef $$ChoiceLogSelectTableTableUpdateCompanionBuilder =
    ChoiceLogSelectTableCompanion Function({
      Value<int> id,
      Value<int> choiceLogId,
      Value<int> order,
    });

class $$ChoiceLogSelectTableTableFilterComposer
    extends Composer<_$MyDatabase, $ChoiceLogSelectTableTable> {
  $$ChoiceLogSelectTableTableFilterComposer({
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

  ColumnFilters<int> get choiceLogId => $composableBuilder(
    column: $table.choiceLogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChoiceLogSelectTableTableOrderingComposer
    extends Composer<_$MyDatabase, $ChoiceLogSelectTableTable> {
  $$ChoiceLogSelectTableTableOrderingComposer({
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

  ColumnOrderings<int> get choiceLogId => $composableBuilder(
    column: $table.choiceLogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChoiceLogSelectTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $ChoiceLogSelectTableTable> {
  $$ChoiceLogSelectTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get choiceLogId => $composableBuilder(
    column: $table.choiceLogId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$ChoiceLogSelectTableTableTableManager
    extends
        RootTableManager<
          _$MyDatabase,
          $ChoiceLogSelectTableTable,
          ChoiceLogSelect,
          $$ChoiceLogSelectTableTableFilterComposer,
          $$ChoiceLogSelectTableTableOrderingComposer,
          $$ChoiceLogSelectTableTableAnnotationComposer,
          $$ChoiceLogSelectTableTableCreateCompanionBuilder,
          $$ChoiceLogSelectTableTableUpdateCompanionBuilder,
          (
            ChoiceLogSelect,
            BaseReferences<
              _$MyDatabase,
              $ChoiceLogSelectTableTable,
              ChoiceLogSelect
            >,
          ),
          ChoiceLogSelect,
          PrefetchHooks Function()
        > {
  $$ChoiceLogSelectTableTableTableManager(
    _$MyDatabase db,
    $ChoiceLogSelectTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChoiceLogSelectTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ChoiceLogSelectTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ChoiceLogSelectTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> choiceLogId = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => ChoiceLogSelectTableCompanion(
                id: id,
                choiceLogId: choiceLogId,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int choiceLogId,
                required int order,
              }) => ChoiceLogSelectTableCompanion.insert(
                id: id,
                choiceLogId: choiceLogId,
                order: order,
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

typedef $$ChoiceLogSelectTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDatabase,
      $ChoiceLogSelectTableTable,
      ChoiceLogSelect,
      $$ChoiceLogSelectTableTableFilterComposer,
      $$ChoiceLogSelectTableTableOrderingComposer,
      $$ChoiceLogSelectTableTableAnnotationComposer,
      $$ChoiceLogSelectTableTableCreateCompanionBuilder,
      $$ChoiceLogSelectTableTableUpdateCompanionBuilder,
      (
        ChoiceLogSelect,
        BaseReferences<
          _$MyDatabase,
          $ChoiceLogSelectTableTable,
          ChoiceLogSelect
        >,
      ),
      ChoiceLogSelect,
      PrefetchHooks Function()
    >;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$StoryTableTableTableManager get storyTable =>
      $$StoryTableTableTableManager(_db, _db.storyTable);
  $$SaveTableTableTableManager get saveTable =>
      $$SaveTableTableTableManager(_db, _db.saveTable);
  $$ChoiseTableTableTableManager get choiseTable =>
      $$ChoiseTableTableTableManager(_db, _db.choiseTable);
  $$ChoiceLogTableTableTableManager get choiceLogTable =>
      $$ChoiceLogTableTableTableManager(_db, _db.choiceLogTable);
  $$ChoiceLogSelectTableTableTableManager get choiceLogSelectTable =>
      $$ChoiceLogSelectTableTableTableManager(_db, _db.choiceLogSelectTable);
}
