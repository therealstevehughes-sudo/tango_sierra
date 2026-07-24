// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskSubmissionsTable extends TaskSubmissions
    with TableInfo<$TaskSubmissionsTable, TaskSubmissionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskSubmissionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _taskTitleMeta = const VerificationMeta(
    'taskTitle',
  );
  @override
  late final GeneratedColumn<String> taskTitle = GeneratedColumn<String>(
    'task_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedByMeta = const VerificationMeta(
    'completedBy',
  );
  @override
  late final GeneratedColumn<String> completedBy = GeneratedColumn<String>(
    'completed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numericValueMeta = const VerificationMeta(
    'numericValue',
  );
  @override
  late final GeneratedColumn<String> numericValue = GeneratedColumn<String>(
    'numeric_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoAttachedMeta = const VerificationMeta(
    'photoAttached',
  );
  @override
  late final GeneratedColumn<bool> photoAttached = GeneratedColumn<bool>(
    'photo_attached',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("photo_attached" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskTitle,
    status,
    completedBy,
    completedAt,
    numericValue,
    photoAttached,
    photoPath,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_submissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskSubmissionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_title')) {
      context.handle(
        _taskTitleMeta,
        taskTitle.isAcceptableOrUnknown(data['task_title']!, _taskTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTitleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('completed_by')) {
      context.handle(
        _completedByMeta,
        completedBy.isAcceptableOrUnknown(
          data['completed_by']!,
          _completedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedByMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('numeric_value')) {
      context.handle(
        _numericValueMeta,
        numericValue.isAcceptableOrUnknown(
          data['numeric_value']!,
          _numericValueMeta,
        ),
      );
    }
    if (data.containsKey('photo_attached')) {
      context.handle(
        _photoAttachedMeta,
        photoAttached.isAcceptableOrUnknown(
          data['photo_attached']!,
          _photoAttachedMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskSubmissionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskSubmissionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      completedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_by'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      numericValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numeric_value'],
      ),
      photoAttached: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}photo_attached'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TaskSubmissionsTable createAlias(String alias) {
    return $TaskSubmissionsTable(attachedDatabase, alias);
  }
}

class TaskSubmissionEntity extends DataClass
    implements Insertable<TaskSubmissionEntity> {
  final int id;
  final String taskTitle;
  final String status;
  final String completedBy;
  final DateTime completedAt;
  final String? numericValue;
  final bool photoAttached;
  final String? photoPath;
  final String? notes;
  const TaskSubmissionEntity({
    required this.id,
    required this.taskTitle,
    required this.status,
    required this.completedBy,
    required this.completedAt,
    this.numericValue,
    required this.photoAttached,
    this.photoPath,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_title'] = Variable<String>(taskTitle);
    map['status'] = Variable<String>(status);
    map['completed_by'] = Variable<String>(completedBy);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || numericValue != null) {
      map['numeric_value'] = Variable<String>(numericValue);
    }
    map['photo_attached'] = Variable<bool>(photoAttached);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TaskSubmissionsCompanion toCompanion(bool nullToAbsent) {
    return TaskSubmissionsCompanion(
      id: Value(id),
      taskTitle: Value(taskTitle),
      status: Value(status),
      completedBy: Value(completedBy),
      completedAt: Value(completedAt),
      numericValue: numericValue == null && nullToAbsent
          ? const Value.absent()
          : Value(numericValue),
      photoAttached: Value(photoAttached),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory TaskSubmissionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskSubmissionEntity(
      id: serializer.fromJson<int>(json['id']),
      taskTitle: serializer.fromJson<String>(json['taskTitle']),
      status: serializer.fromJson<String>(json['status']),
      completedBy: serializer.fromJson<String>(json['completedBy']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      numericValue: serializer.fromJson<String?>(json['numericValue']),
      photoAttached: serializer.fromJson<bool>(json['photoAttached']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskTitle': serializer.toJson<String>(taskTitle),
      'status': serializer.toJson<String>(status),
      'completedBy': serializer.toJson<String>(completedBy),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'numericValue': serializer.toJson<String?>(numericValue),
      'photoAttached': serializer.toJson<bool>(photoAttached),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TaskSubmissionEntity copyWith({
    int? id,
    String? taskTitle,
    String? status,
    String? completedBy,
    DateTime? completedAt,
    Value<String?> numericValue = const Value.absent(),
    bool? photoAttached,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => TaskSubmissionEntity(
    id: id ?? this.id,
    taskTitle: taskTitle ?? this.taskTitle,
    status: status ?? this.status,
    completedBy: completedBy ?? this.completedBy,
    completedAt: completedAt ?? this.completedAt,
    numericValue: numericValue.present ? numericValue.value : this.numericValue,
    photoAttached: photoAttached ?? this.photoAttached,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    notes: notes.present ? notes.value : this.notes,
  );
  TaskSubmissionEntity copyWithCompanion(TaskSubmissionsCompanion data) {
    return TaskSubmissionEntity(
      id: data.id.present ? data.id.value : this.id,
      taskTitle: data.taskTitle.present ? data.taskTitle.value : this.taskTitle,
      status: data.status.present ? data.status.value : this.status,
      completedBy: data.completedBy.present
          ? data.completedBy.value
          : this.completedBy,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      numericValue: data.numericValue.present
          ? data.numericValue.value
          : this.numericValue,
      photoAttached: data.photoAttached.present
          ? data.photoAttached.value
          : this.photoAttached,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskSubmissionEntity(')
          ..write('id: $id, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('status: $status, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('numericValue: $numericValue, ')
          ..write('photoAttached: $photoAttached, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskTitle,
    status,
    completedBy,
    completedAt,
    numericValue,
    photoAttached,
    photoPath,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskSubmissionEntity &&
          other.id == this.id &&
          other.taskTitle == this.taskTitle &&
          other.status == this.status &&
          other.completedBy == this.completedBy &&
          other.completedAt == this.completedAt &&
          other.numericValue == this.numericValue &&
          other.photoAttached == this.photoAttached &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes);
}

class TaskSubmissionsCompanion extends UpdateCompanion<TaskSubmissionEntity> {
  final Value<int> id;
  final Value<String> taskTitle;
  final Value<String> status;
  final Value<String> completedBy;
  final Value<DateTime> completedAt;
  final Value<String?> numericValue;
  final Value<bool> photoAttached;
  final Value<String?> photoPath;
  final Value<String?> notes;
  const TaskSubmissionsCompanion({
    this.id = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.status = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.numericValue = const Value.absent(),
    this.photoAttached = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TaskSubmissionsCompanion.insert({
    this.id = const Value.absent(),
    required String taskTitle,
    required String status,
    required String completedBy,
    required DateTime completedAt,
    this.numericValue = const Value.absent(),
    this.photoAttached = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
  }) : taskTitle = Value(taskTitle),
       status = Value(status),
       completedBy = Value(completedBy),
       completedAt = Value(completedAt);
  static Insertable<TaskSubmissionEntity> custom({
    Expression<int>? id,
    Expression<String>? taskTitle,
    Expression<String>? status,
    Expression<String>? completedBy,
    Expression<DateTime>? completedAt,
    Expression<String>? numericValue,
    Expression<bool>? photoAttached,
    Expression<String>? photoPath,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskTitle != null) 'task_title': taskTitle,
      if (status != null) 'status': status,
      if (completedBy != null) 'completed_by': completedBy,
      if (completedAt != null) 'completed_at': completedAt,
      if (numericValue != null) 'numeric_value': numericValue,
      if (photoAttached != null) 'photo_attached': photoAttached,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
    });
  }

  TaskSubmissionsCompanion copyWith({
    Value<int>? id,
    Value<String>? taskTitle,
    Value<String>? status,
    Value<String>? completedBy,
    Value<DateTime>? completedAt,
    Value<String?>? numericValue,
    Value<bool>? photoAttached,
    Value<String?>? photoPath,
    Value<String?>? notes,
  }) {
    return TaskSubmissionsCompanion(
      id: id ?? this.id,
      taskTitle: taskTitle ?? this.taskTitle,
      status: status ?? this.status,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      numericValue: numericValue ?? this.numericValue,
      photoAttached: photoAttached ?? this.photoAttached,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskTitle.present) {
      map['task_title'] = Variable<String>(taskTitle.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedBy.present) {
      map['completed_by'] = Variable<String>(completedBy.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (numericValue.present) {
      map['numeric_value'] = Variable<String>(numericValue.value);
    }
    if (photoAttached.present) {
      map['photo_attached'] = Variable<bool>(photoAttached.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskSubmissionsCompanion(')
          ..write('id: $id, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('status: $status, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('numericValue: $numericValue, ')
          ..write('photoAttached: $photoAttached, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskSubmissionsTable taskSubmissions = $TaskSubmissionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskSubmissions];
}

typedef $$TaskSubmissionsTableCreateCompanionBuilder =
    TaskSubmissionsCompanion Function({
      Value<int> id,
      required String taskTitle,
      required String status,
      required String completedBy,
      required DateTime completedAt,
      Value<String?> numericValue,
      Value<bool> photoAttached,
      Value<String?> photoPath,
      Value<String?> notes,
    });
typedef $$TaskSubmissionsTableUpdateCompanionBuilder =
    TaskSubmissionsCompanion Function({
      Value<int> id,
      Value<String> taskTitle,
      Value<String> status,
      Value<String> completedBy,
      Value<DateTime> completedAt,
      Value<String?> numericValue,
      Value<bool> photoAttached,
      Value<String?> photoPath,
      Value<String?> notes,
    });

class $$TaskSubmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskSubmissionsTable> {
  $$TaskSubmissionsTableFilterComposer({
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

  ColumnFilters<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get photoAttached => $composableBuilder(
    column: $table.photoAttached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskSubmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskSubmissionsTable> {
  $$TaskSubmissionsTableOrderingComposer({
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

  ColumnOrderings<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get photoAttached => $composableBuilder(
    column: $table.photoAttached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskSubmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskSubmissionsTable> {
  $$TaskSubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskTitle =>
      $composableBuilder(column: $table.taskTitle, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get photoAttached => $composableBuilder(
    column: $table.photoAttached,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TaskSubmissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskSubmissionsTable,
          TaskSubmissionEntity,
          $$TaskSubmissionsTableFilterComposer,
          $$TaskSubmissionsTableOrderingComposer,
          $$TaskSubmissionsTableAnnotationComposer,
          $$TaskSubmissionsTableCreateCompanionBuilder,
          $$TaskSubmissionsTableUpdateCompanionBuilder,
          (
            TaskSubmissionEntity,
            BaseReferences<
              _$AppDatabase,
              $TaskSubmissionsTable,
              TaskSubmissionEntity
            >,
          ),
          TaskSubmissionEntity,
          PrefetchHooks Function()
        > {
  $$TaskSubmissionsTableTableManager(
    _$AppDatabase db,
    $TaskSubmissionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskSubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskSubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskSubmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskTitle = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> completedBy = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> numericValue = const Value.absent(),
                Value<bool> photoAttached = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => TaskSubmissionsCompanion(
                id: id,
                taskTitle: taskTitle,
                status: status,
                completedBy: completedBy,
                completedAt: completedAt,
                numericValue: numericValue,
                photoAttached: photoAttached,
                photoPath: photoPath,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskTitle,
                required String status,
                required String completedBy,
                required DateTime completedAt,
                Value<String?> numericValue = const Value.absent(),
                Value<bool> photoAttached = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => TaskSubmissionsCompanion.insert(
                id: id,
                taskTitle: taskTitle,
                status: status,
                completedBy: completedBy,
                completedAt: completedAt,
                numericValue: numericValue,
                photoAttached: photoAttached,
                photoPath: photoPath,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskSubmissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskSubmissionsTable,
      TaskSubmissionEntity,
      $$TaskSubmissionsTableFilterComposer,
      $$TaskSubmissionsTableOrderingComposer,
      $$TaskSubmissionsTableAnnotationComposer,
      $$TaskSubmissionsTableCreateCompanionBuilder,
      $$TaskSubmissionsTableUpdateCompanionBuilder,
      (
        TaskSubmissionEntity,
        BaseReferences<
          _$AppDatabase,
          $TaskSubmissionsTable,
          TaskSubmissionEntity
        >,
      ),
      TaskSubmissionEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskSubmissionsTableTableManager get taskSubmissions =>
      $$TaskSubmissionsTableTableManager(_db, _db.taskSubmissions);
}
