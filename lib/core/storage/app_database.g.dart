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

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleTierMeta = const VerificationMeta(
    'roleTier',
  );
  @override
  late final GeneratedColumn<String> roleTier = GeneratedColumn<String>(
    'role_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    jobTitle,
    roleTier,
    pinHash,
    pinSalt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_jobTitleMeta);
    }
    if (data.containsKey('role_tier')) {
      context.handle(
        _roleTierMeta,
        roleTier.isAcceptableOrUnknown(data['role_tier']!, _roleTierMeta),
      );
    } else if (isInserting) {
      context.missing(_roleTierMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      )!,
      roleTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_tier'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final int id;
  final String name;
  final String jobTitle;
  final String roleTier;
  final String pinHash;
  final String pinSalt;
  const UserEntity({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    required this.pinHash,
    required this.pinSalt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['job_title'] = Variable<String>(jobTitle);
    map['role_tier'] = Variable<String>(roleTier);
    map['pin_hash'] = Variable<String>(pinHash);
    map['pin_salt'] = Variable<String>(pinSalt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      jobTitle: Value(jobTitle),
      roleTier: Value(roleTier),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
    );
  }

  factory UserEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      jobTitle: serializer.fromJson<String>(json['jobTitle']),
      roleTier: serializer.fromJson<String>(json['roleTier']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String>(json['pinSalt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'jobTitle': serializer.toJson<String>(jobTitle),
      'roleTier': serializer.toJson<String>(roleTier),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String>(pinSalt),
    };
  }

  UserEntity copyWith({
    int? id,
    String? name,
    String? jobTitle,
    String? roleTier,
    String? pinHash,
    String? pinSalt,
  }) => UserEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    jobTitle: jobTitle ?? this.jobTitle,
    roleTier: roleTier ?? this.roleTier,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt ?? this.pinSalt,
  );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      roleTier: data.roleTier.present ? data.roleTier.value : this.roleTier,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('roleTier: $roleTier, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, jobTitle, roleTier, pinHash, pinSalt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.jobTitle == this.jobTitle &&
          other.roleTier == this.roleTier &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> jobTitle;
  final Value<String> roleTier;
  final Value<String> pinHash;
  final Value<String> pinSalt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.roleTier = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String jobTitle,
    required String roleTier,
    required String pinHash,
    required String pinSalt,
  }) : name = Value(name),
       jobTitle = Value(jobTitle),
       roleTier = Value(roleTier),
       pinHash = Value(pinHash),
       pinSalt = Value(pinSalt);
  static Insertable<UserEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? jobTitle,
    Expression<String>? roleTier,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (jobTitle != null) 'job_title': jobTitle,
      if (roleTier != null) 'role_tier': roleTier,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? jobTitle,
    Value<String>? roleTier,
    Value<String>? pinHash,
    Value<String>? pinSalt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      roleTier: roleTier ?? this.roleTier,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (roleTier.present) {
      map['role_tier'] = Variable<String>(roleTier.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('roleTier: $roleTier, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTypesTable extends EquipmentTypes
    with TableInfo<$EquipmentTypesTable, EquipmentTypeEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTypesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentTypeEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentTypeEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentTypeEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $EquipmentTypesTable createAlias(String alias) {
    return $EquipmentTypesTable(attachedDatabase, alias);
  }
}

class EquipmentTypeEntity extends DataClass
    implements Insertable<EquipmentTypeEntity> {
  final int id;
  final String name;
  const EquipmentTypeEntity({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  EquipmentTypesCompanion toCompanion(bool nullToAbsent) {
    return EquipmentTypesCompanion(id: Value(id), name: Value(name));
  }

  factory EquipmentTypeEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentTypeEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  EquipmentTypeEntity copyWith({int? id, String? name}) =>
      EquipmentTypeEntity(id: id ?? this.id, name: name ?? this.name);
  EquipmentTypeEntity copyWithCompanion(EquipmentTypesCompanion data) {
    return EquipmentTypeEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentTypeEntity(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentTypeEntity &&
          other.id == this.id &&
          other.name == this.name);
}

class EquipmentTypesCompanion extends UpdateCompanion<EquipmentTypeEntity> {
  final Value<int> id;
  final Value<String> name;
  const EquipmentTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  EquipmentTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<EquipmentTypeEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  EquipmentTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return EquipmentTypesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $LegalLimitReferencesTable extends LegalLimitReferences
    with TableInfo<$LegalLimitReferencesTable, LegalLimitReferenceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalLimitReferencesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalMinMeta = const VerificationMeta(
    'legalMin',
  );
  @override
  late final GeneratedColumn<double> legalMin = GeneratedColumn<double>(
    'legal_min',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _legalMaxMeta = const VerificationMeta(
    'legalMax',
  );
  @override
  late final GeneratedColumn<double> legalMax = GeneratedColumn<double>(
    'legal_max',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    legalMin,
    legalMax,
    unit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_limit_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalLimitReferenceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('legal_min')) {
      context.handle(
        _legalMinMeta,
        legalMin.isAcceptableOrUnknown(data['legal_min']!, _legalMinMeta),
      );
    }
    if (data.containsKey('legal_max')) {
      context.handle(
        _legalMaxMeta,
        legalMax.isAcceptableOrUnknown(data['legal_max']!, _legalMaxMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegalLimitReferenceEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalLimitReferenceEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      legalMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}legal_min'],
      ),
      legalMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}legal_max'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
    );
  }

  @override
  $LegalLimitReferencesTable createAlias(String alias) {
    return $LegalLimitReferencesTable(attachedDatabase, alias);
  }
}

class LegalLimitReferenceEntity extends DataClass
    implements Insertable<LegalLimitReferenceEntity> {
  final int id;
  final String category;
  final double? legalMin;
  final double? legalMax;
  final String unit;
  const LegalLimitReferenceEntity({
    required this.id,
    required this.category,
    this.legalMin,
    this.legalMax,
    required this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || legalMin != null) {
      map['legal_min'] = Variable<double>(legalMin);
    }
    if (!nullToAbsent || legalMax != null) {
      map['legal_max'] = Variable<double>(legalMax);
    }
    map['unit'] = Variable<String>(unit);
    return map;
  }

  LegalLimitReferencesCompanion toCompanion(bool nullToAbsent) {
    return LegalLimitReferencesCompanion(
      id: Value(id),
      category: Value(category),
      legalMin: legalMin == null && nullToAbsent
          ? const Value.absent()
          : Value(legalMin),
      legalMax: legalMax == null && nullToAbsent
          ? const Value.absent()
          : Value(legalMax),
      unit: Value(unit),
    );
  }

  factory LegalLimitReferenceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalLimitReferenceEntity(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      legalMin: serializer.fromJson<double?>(json['legalMin']),
      legalMax: serializer.fromJson<double?>(json['legalMax']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'legalMin': serializer.toJson<double?>(legalMin),
      'legalMax': serializer.toJson<double?>(legalMax),
      'unit': serializer.toJson<String>(unit),
    };
  }

  LegalLimitReferenceEntity copyWith({
    int? id,
    String? category,
    Value<double?> legalMin = const Value.absent(),
    Value<double?> legalMax = const Value.absent(),
    String? unit,
  }) => LegalLimitReferenceEntity(
    id: id ?? this.id,
    category: category ?? this.category,
    legalMin: legalMin.present ? legalMin.value : this.legalMin,
    legalMax: legalMax.present ? legalMax.value : this.legalMax,
    unit: unit ?? this.unit,
  );
  LegalLimitReferenceEntity copyWithCompanion(
    LegalLimitReferencesCompanion data,
  ) {
    return LegalLimitReferenceEntity(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      legalMin: data.legalMin.present ? data.legalMin.value : this.legalMin,
      legalMax: data.legalMax.present ? data.legalMax.value : this.legalMax,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalLimitReferenceEntity(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('legalMin: $legalMin, ')
          ..write('legalMax: $legalMax, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, legalMin, legalMax, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalLimitReferenceEntity &&
          other.id == this.id &&
          other.category == this.category &&
          other.legalMin == this.legalMin &&
          other.legalMax == this.legalMax &&
          other.unit == this.unit);
}

class LegalLimitReferencesCompanion
    extends UpdateCompanion<LegalLimitReferenceEntity> {
  final Value<int> id;
  final Value<String> category;
  final Value<double?> legalMin;
  final Value<double?> legalMax;
  final Value<String> unit;
  const LegalLimitReferencesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.legalMin = const Value.absent(),
    this.legalMax = const Value.absent(),
    this.unit = const Value.absent(),
  });
  LegalLimitReferencesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    this.legalMin = const Value.absent(),
    this.legalMax = const Value.absent(),
    required String unit,
  }) : category = Value(category),
       unit = Value(unit);
  static Insertable<LegalLimitReferenceEntity> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<double>? legalMin,
    Expression<double>? legalMax,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (legalMin != null) 'legal_min': legalMin,
      if (legalMax != null) 'legal_max': legalMax,
      if (unit != null) 'unit': unit,
    });
  }

  LegalLimitReferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<double?>? legalMin,
    Value<double?>? legalMax,
    Value<String>? unit,
  }) {
    return LegalLimitReferencesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      legalMin: legalMin ?? this.legalMin,
      legalMax: legalMax ?? this.legalMax,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (legalMin.present) {
      map['legal_min'] = Variable<double>(legalMin.value);
    }
    if (legalMax.present) {
      map['legal_max'] = Variable<double>(legalMax.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalLimitReferencesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('legalMin: $legalMin, ')
          ..write('legalMax: $legalMax, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $TaskTemplatesTable extends TaskTemplates
    with TableInfo<$TaskTemplatesTable, TaskTemplateEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _templateGroupIdMeta = const VerificationMeta(
    'templateGroupId',
  );
  @override
  late final GeneratedColumn<int> templateGroupId = GeneratedColumn<int>(
    'template_group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousVersionIdMeta = const VerificationMeta(
    'previousVersionId',
  );
  @override
  late final GeneratedColumn<int> previousVersionId = GeneratedColumn<int>(
    'previous_version_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_templates (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _segmentMeta = const VerificationMeta(
    'segment',
  );
  @override
  late final GeneratedColumn<String> segment = GeneratedColumn<String>(
    'segment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _applicableRoleTiersMeta =
      const VerificationMeta('applicableRoleTiers');
  @override
  late final GeneratedColumn<String> applicableRoleTiers =
      GeneratedColumn<String>(
        'applicable_role_tiers',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiresPhotoMeta = const VerificationMeta(
    'requiresPhoto',
  );
  @override
  late final GeneratedColumn<bool> requiresPhoto = GeneratedColumn<bool>(
    'requires_photo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_photo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiresNotesMeta = const VerificationMeta(
    'requiresNotes',
  );
  @override
  late final GeneratedColumn<bool> requiresNotes = GeneratedColumn<bool>(
    'requires_notes',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_notes" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _customFieldsJsonMeta = const VerificationMeta(
    'customFieldsJson',
  );
  @override
  late final GeneratedColumn<String> customFieldsJson = GeneratedColumn<String>(
    'custom_fields_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minLimitMeta = const VerificationMeta(
    'minLimit',
  );
  @override
  late final GeneratedColumn<double> minLimit = GeneratedColumn<double>(
    'min_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxLimitMeta = const VerificationMeta(
    'maxLimit',
  );
  @override
  late final GeneratedColumn<double> maxLimit = GeneratedColumn<double>(
    'max_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _legalLimitCategoryMeta =
      const VerificationMeta('legalLimitCategory');
  @override
  late final GeneratedColumn<String> legalLimitCategory =
      GeneratedColumn<String>(
        'legal_limit_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isCriticalMeta = const VerificationMeta(
    'isCritical',
  );
  @override
  late final GeneratedColumn<bool> isCritical = GeneratedColumn<bool>(
    'is_critical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_critical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiresCorrectiveActionOnFailMeta =
      const VerificationMeta('requiresCorrectiveActionOnFail');
  @override
  late final GeneratedColumn<bool> requiresCorrectiveActionOnFail =
      GeneratedColumn<bool>(
        'requires_corrective_action_on_fail',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_corrective_action_on_fail" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _fixInstructionsMeta = const VerificationMeta(
    'fixInstructions',
  );
  @override
  late final GeneratedColumn<String> fixInstructions = GeneratedColumn<String>(
    'fix_instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentTypeIdMeta = const VerificationMeta(
    'equipmentTypeId',
  );
  @override
  late final GeneratedColumn<int> equipmentTypeId = GeneratedColumn<int>(
    'equipment_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment_types (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<int> createdByUserId = GeneratedColumn<int>(
    'created_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateGroupId,
    versionNumber,
    previousVersionId,
    title,
    segment,
    applicableRoleTiers,
    method,
    requiresPhoto,
    requiresNotes,
    customFieldsJson,
    minLimit,
    maxLimit,
    unit,
    legalLimitCategory,
    isCritical,
    requiresCorrectiveActionOnFail,
    fixInstructions,
    equipmentTypeId,
    createdAt,
    createdByUserId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskTemplateEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_group_id')) {
      context.handle(
        _templateGroupIdMeta,
        templateGroupId.isAcceptableOrUnknown(
          data['template_group_id']!,
          _templateGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateGroupIdMeta);
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    if (data.containsKey('previous_version_id')) {
      context.handle(
        _previousVersionIdMeta,
        previousVersionId.isAcceptableOrUnknown(
          data['previous_version_id']!,
          _previousVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('segment')) {
      context.handle(
        _segmentMeta,
        segment.isAcceptableOrUnknown(data['segment']!, _segmentMeta),
      );
    } else if (isInserting) {
      context.missing(_segmentMeta);
    }
    if (data.containsKey('applicable_role_tiers')) {
      context.handle(
        _applicableRoleTiersMeta,
        applicableRoleTiers.isAcceptableOrUnknown(
          data['applicable_role_tiers']!,
          _applicableRoleTiersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicableRoleTiersMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('requires_photo')) {
      context.handle(
        _requiresPhotoMeta,
        requiresPhoto.isAcceptableOrUnknown(
          data['requires_photo']!,
          _requiresPhotoMeta,
        ),
      );
    }
    if (data.containsKey('requires_notes')) {
      context.handle(
        _requiresNotesMeta,
        requiresNotes.isAcceptableOrUnknown(
          data['requires_notes']!,
          _requiresNotesMeta,
        ),
      );
    }
    if (data.containsKey('custom_fields_json')) {
      context.handle(
        _customFieldsJsonMeta,
        customFieldsJson.isAcceptableOrUnknown(
          data['custom_fields_json']!,
          _customFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('min_limit')) {
      context.handle(
        _minLimitMeta,
        minLimit.isAcceptableOrUnknown(data['min_limit']!, _minLimitMeta),
      );
    }
    if (data.containsKey('max_limit')) {
      context.handle(
        _maxLimitMeta,
        maxLimit.isAcceptableOrUnknown(data['max_limit']!, _maxLimitMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('legal_limit_category')) {
      context.handle(
        _legalLimitCategoryMeta,
        legalLimitCategory.isAcceptableOrUnknown(
          data['legal_limit_category']!,
          _legalLimitCategoryMeta,
        ),
      );
    }
    if (data.containsKey('is_critical')) {
      context.handle(
        _isCriticalMeta,
        isCritical.isAcceptableOrUnknown(data['is_critical']!, _isCriticalMeta),
      );
    }
    if (data.containsKey('requires_corrective_action_on_fail')) {
      context.handle(
        _requiresCorrectiveActionOnFailMeta,
        requiresCorrectiveActionOnFail.isAcceptableOrUnknown(
          data['requires_corrective_action_on_fail']!,
          _requiresCorrectiveActionOnFailMeta,
        ),
      );
    }
    if (data.containsKey('fix_instructions')) {
      context.handle(
        _fixInstructionsMeta,
        fixInstructions.isAcceptableOrUnknown(
          data['fix_instructions']!,
          _fixInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('equipment_type_id')) {
      context.handle(
        _equipmentTypeIdMeta,
        equipmentTypeId.isAcceptableOrUnknown(
          data['equipment_type_id']!,
          _equipmentTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTemplateEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTemplateEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_group_id'],
      )!,
      versionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_number'],
      )!,
      previousVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_version_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      segment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}segment'],
      )!,
      applicableRoleTiers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applicable_role_tiers'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      requiresPhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_photo'],
      )!,
      requiresNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_notes'],
      )!,
      customFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_fields_json'],
      ),
      minLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_limit'],
      ),
      maxLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_limit'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      legalLimitCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_limit_category'],
      ),
      isCritical: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_critical'],
      )!,
      requiresCorrectiveActionOnFail: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_corrective_action_on_fail'],
      )!,
      fixInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fix_instructions'],
      ),
      equipmentTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_type_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_user_id'],
      ),
    );
  }

  @override
  $TaskTemplatesTable createAlias(String alias) {
    return $TaskTemplatesTable(attachedDatabase, alias);
  }
}

class TaskTemplateEntity extends DataClass
    implements Insertable<TaskTemplateEntity> {
  final int id;
  final int templateGroupId;
  final int versionNumber;
  final int? previousVersionId;
  final String title;
  final String segment;
  final String applicableRoleTiers;
  final String method;
  final bool requiresPhoto;
  final bool requiresNotes;
  final String? customFieldsJson;
  final double? minLimit;
  final double? maxLimit;
  final String? unit;
  final String? legalLimitCategory;
  final bool isCritical;
  final bool requiresCorrectiveActionOnFail;
  final String? fixInstructions;
  final int? equipmentTypeId;
  final DateTime createdAt;
  final int? createdByUserId;
  const TaskTemplateEntity({
    required this.id,
    required this.templateGroupId,
    required this.versionNumber,
    this.previousVersionId,
    required this.title,
    required this.segment,
    required this.applicableRoleTiers,
    required this.method,
    required this.requiresPhoto,
    required this.requiresNotes,
    this.customFieldsJson,
    this.minLimit,
    this.maxLimit,
    this.unit,
    this.legalLimitCategory,
    required this.isCritical,
    required this.requiresCorrectiveActionOnFail,
    this.fixInstructions,
    this.equipmentTypeId,
    required this.createdAt,
    this.createdByUserId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_group_id'] = Variable<int>(templateGroupId);
    map['version_number'] = Variable<int>(versionNumber);
    if (!nullToAbsent || previousVersionId != null) {
      map['previous_version_id'] = Variable<int>(previousVersionId);
    }
    map['title'] = Variable<String>(title);
    map['segment'] = Variable<String>(segment);
    map['applicable_role_tiers'] = Variable<String>(applicableRoleTiers);
    map['method'] = Variable<String>(method);
    map['requires_photo'] = Variable<bool>(requiresPhoto);
    map['requires_notes'] = Variable<bool>(requiresNotes);
    if (!nullToAbsent || customFieldsJson != null) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson);
    }
    if (!nullToAbsent || minLimit != null) {
      map['min_limit'] = Variable<double>(minLimit);
    }
    if (!nullToAbsent || maxLimit != null) {
      map['max_limit'] = Variable<double>(maxLimit);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || legalLimitCategory != null) {
      map['legal_limit_category'] = Variable<String>(legalLimitCategory);
    }
    map['is_critical'] = Variable<bool>(isCritical);
    map['requires_corrective_action_on_fail'] = Variable<bool>(
      requiresCorrectiveActionOnFail,
    );
    if (!nullToAbsent || fixInstructions != null) {
      map['fix_instructions'] = Variable<String>(fixInstructions);
    }
    if (!nullToAbsent || equipmentTypeId != null) {
      map['equipment_type_id'] = Variable<int>(equipmentTypeId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<int>(createdByUserId);
    }
    return map;
  }

  TaskTemplatesCompanion toCompanion(bool nullToAbsent) {
    return TaskTemplatesCompanion(
      id: Value(id),
      templateGroupId: Value(templateGroupId),
      versionNumber: Value(versionNumber),
      previousVersionId: previousVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousVersionId),
      title: Value(title),
      segment: Value(segment),
      applicableRoleTiers: Value(applicableRoleTiers),
      method: Value(method),
      requiresPhoto: Value(requiresPhoto),
      requiresNotes: Value(requiresNotes),
      customFieldsJson: customFieldsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(customFieldsJson),
      minLimit: minLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(minLimit),
      maxLimit: maxLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(maxLimit),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      legalLimitCategory: legalLimitCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(legalLimitCategory),
      isCritical: Value(isCritical),
      requiresCorrectiveActionOnFail: Value(requiresCorrectiveActionOnFail),
      fixInstructions: fixInstructions == null && nullToAbsent
          ? const Value.absent()
          : Value(fixInstructions),
      equipmentTypeId: equipmentTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentTypeId),
      createdAt: Value(createdAt),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
    );
  }

  factory TaskTemplateEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTemplateEntity(
      id: serializer.fromJson<int>(json['id']),
      templateGroupId: serializer.fromJson<int>(json['templateGroupId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      previousVersionId: serializer.fromJson<int?>(json['previousVersionId']),
      title: serializer.fromJson<String>(json['title']),
      segment: serializer.fromJson<String>(json['segment']),
      applicableRoleTiers: serializer.fromJson<String>(
        json['applicableRoleTiers'],
      ),
      method: serializer.fromJson<String>(json['method']),
      requiresPhoto: serializer.fromJson<bool>(json['requiresPhoto']),
      requiresNotes: serializer.fromJson<bool>(json['requiresNotes']),
      customFieldsJson: serializer.fromJson<String?>(json['customFieldsJson']),
      minLimit: serializer.fromJson<double?>(json['minLimit']),
      maxLimit: serializer.fromJson<double?>(json['maxLimit']),
      unit: serializer.fromJson<String?>(json['unit']),
      legalLimitCategory: serializer.fromJson<String?>(
        json['legalLimitCategory'],
      ),
      isCritical: serializer.fromJson<bool>(json['isCritical']),
      requiresCorrectiveActionOnFail: serializer.fromJson<bool>(
        json['requiresCorrectiveActionOnFail'],
      ),
      fixInstructions: serializer.fromJson<String?>(json['fixInstructions']),
      equipmentTypeId: serializer.fromJson<int?>(json['equipmentTypeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdByUserId: serializer.fromJson<int?>(json['createdByUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateGroupId': serializer.toJson<int>(templateGroupId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'previousVersionId': serializer.toJson<int?>(previousVersionId),
      'title': serializer.toJson<String>(title),
      'segment': serializer.toJson<String>(segment),
      'applicableRoleTiers': serializer.toJson<String>(applicableRoleTiers),
      'method': serializer.toJson<String>(method),
      'requiresPhoto': serializer.toJson<bool>(requiresPhoto),
      'requiresNotes': serializer.toJson<bool>(requiresNotes),
      'customFieldsJson': serializer.toJson<String?>(customFieldsJson),
      'minLimit': serializer.toJson<double?>(minLimit),
      'maxLimit': serializer.toJson<double?>(maxLimit),
      'unit': serializer.toJson<String?>(unit),
      'legalLimitCategory': serializer.toJson<String?>(legalLimitCategory),
      'isCritical': serializer.toJson<bool>(isCritical),
      'requiresCorrectiveActionOnFail': serializer.toJson<bool>(
        requiresCorrectiveActionOnFail,
      ),
      'fixInstructions': serializer.toJson<String?>(fixInstructions),
      'equipmentTypeId': serializer.toJson<int?>(equipmentTypeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdByUserId': serializer.toJson<int?>(createdByUserId),
    };
  }

  TaskTemplateEntity copyWith({
    int? id,
    int? templateGroupId,
    int? versionNumber,
    Value<int?> previousVersionId = const Value.absent(),
    String? title,
    String? segment,
    String? applicableRoleTiers,
    String? method,
    bool? requiresPhoto,
    bool? requiresNotes,
    Value<String?> customFieldsJson = const Value.absent(),
    Value<double?> minLimit = const Value.absent(),
    Value<double?> maxLimit = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> legalLimitCategory = const Value.absent(),
    bool? isCritical,
    bool? requiresCorrectiveActionOnFail,
    Value<String?> fixInstructions = const Value.absent(),
    Value<int?> equipmentTypeId = const Value.absent(),
    DateTime? createdAt,
    Value<int?> createdByUserId = const Value.absent(),
  }) => TaskTemplateEntity(
    id: id ?? this.id,
    templateGroupId: templateGroupId ?? this.templateGroupId,
    versionNumber: versionNumber ?? this.versionNumber,
    previousVersionId: previousVersionId.present
        ? previousVersionId.value
        : this.previousVersionId,
    title: title ?? this.title,
    segment: segment ?? this.segment,
    applicableRoleTiers: applicableRoleTiers ?? this.applicableRoleTiers,
    method: method ?? this.method,
    requiresPhoto: requiresPhoto ?? this.requiresPhoto,
    requiresNotes: requiresNotes ?? this.requiresNotes,
    customFieldsJson: customFieldsJson.present
        ? customFieldsJson.value
        : this.customFieldsJson,
    minLimit: minLimit.present ? minLimit.value : this.minLimit,
    maxLimit: maxLimit.present ? maxLimit.value : this.maxLimit,
    unit: unit.present ? unit.value : this.unit,
    legalLimitCategory: legalLimitCategory.present
        ? legalLimitCategory.value
        : this.legalLimitCategory,
    isCritical: isCritical ?? this.isCritical,
    requiresCorrectiveActionOnFail:
        requiresCorrectiveActionOnFail ?? this.requiresCorrectiveActionOnFail,
    fixInstructions: fixInstructions.present
        ? fixInstructions.value
        : this.fixInstructions,
    equipmentTypeId: equipmentTypeId.present
        ? equipmentTypeId.value
        : this.equipmentTypeId,
    createdAt: createdAt ?? this.createdAt,
    createdByUserId: createdByUserId.present
        ? createdByUserId.value
        : this.createdByUserId,
  );
  TaskTemplateEntity copyWithCompanion(TaskTemplatesCompanion data) {
    return TaskTemplateEntity(
      id: data.id.present ? data.id.value : this.id,
      templateGroupId: data.templateGroupId.present
          ? data.templateGroupId.value
          : this.templateGroupId,
      versionNumber: data.versionNumber.present
          ? data.versionNumber.value
          : this.versionNumber,
      previousVersionId: data.previousVersionId.present
          ? data.previousVersionId.value
          : this.previousVersionId,
      title: data.title.present ? data.title.value : this.title,
      segment: data.segment.present ? data.segment.value : this.segment,
      applicableRoleTiers: data.applicableRoleTiers.present
          ? data.applicableRoleTiers.value
          : this.applicableRoleTiers,
      method: data.method.present ? data.method.value : this.method,
      requiresPhoto: data.requiresPhoto.present
          ? data.requiresPhoto.value
          : this.requiresPhoto,
      requiresNotes: data.requiresNotes.present
          ? data.requiresNotes.value
          : this.requiresNotes,
      customFieldsJson: data.customFieldsJson.present
          ? data.customFieldsJson.value
          : this.customFieldsJson,
      minLimit: data.minLimit.present ? data.minLimit.value : this.minLimit,
      maxLimit: data.maxLimit.present ? data.maxLimit.value : this.maxLimit,
      unit: data.unit.present ? data.unit.value : this.unit,
      legalLimitCategory: data.legalLimitCategory.present
          ? data.legalLimitCategory.value
          : this.legalLimitCategory,
      isCritical: data.isCritical.present
          ? data.isCritical.value
          : this.isCritical,
      requiresCorrectiveActionOnFail:
          data.requiresCorrectiveActionOnFail.present
          ? data.requiresCorrectiveActionOnFail.value
          : this.requiresCorrectiveActionOnFail,
      fixInstructions: data.fixInstructions.present
          ? data.fixInstructions.value
          : this.fixInstructions,
      equipmentTypeId: data.equipmentTypeId.present
          ? data.equipmentTypeId.value
          : this.equipmentTypeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplateEntity(')
          ..write('id: $id, ')
          ..write('templateGroupId: $templateGroupId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('title: $title, ')
          ..write('segment: $segment, ')
          ..write('applicableRoleTiers: $applicableRoleTiers, ')
          ..write('method: $method, ')
          ..write('requiresPhoto: $requiresPhoto, ')
          ..write('requiresNotes: $requiresNotes, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('minLimit: $minLimit, ')
          ..write('maxLimit: $maxLimit, ')
          ..write('unit: $unit, ')
          ..write('legalLimitCategory: $legalLimitCategory, ')
          ..write('isCritical: $isCritical, ')
          ..write(
            'requiresCorrectiveActionOnFail: $requiresCorrectiveActionOnFail, ',
          )
          ..write('fixInstructions: $fixInstructions, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    templateGroupId,
    versionNumber,
    previousVersionId,
    title,
    segment,
    applicableRoleTiers,
    method,
    requiresPhoto,
    requiresNotes,
    customFieldsJson,
    minLimit,
    maxLimit,
    unit,
    legalLimitCategory,
    isCritical,
    requiresCorrectiveActionOnFail,
    fixInstructions,
    equipmentTypeId,
    createdAt,
    createdByUserId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTemplateEntity &&
          other.id == this.id &&
          other.templateGroupId == this.templateGroupId &&
          other.versionNumber == this.versionNumber &&
          other.previousVersionId == this.previousVersionId &&
          other.title == this.title &&
          other.segment == this.segment &&
          other.applicableRoleTiers == this.applicableRoleTiers &&
          other.method == this.method &&
          other.requiresPhoto == this.requiresPhoto &&
          other.requiresNotes == this.requiresNotes &&
          other.customFieldsJson == this.customFieldsJson &&
          other.minLimit == this.minLimit &&
          other.maxLimit == this.maxLimit &&
          other.unit == this.unit &&
          other.legalLimitCategory == this.legalLimitCategory &&
          other.isCritical == this.isCritical &&
          other.requiresCorrectiveActionOnFail ==
              this.requiresCorrectiveActionOnFail &&
          other.fixInstructions == this.fixInstructions &&
          other.equipmentTypeId == this.equipmentTypeId &&
          other.createdAt == this.createdAt &&
          other.createdByUserId == this.createdByUserId);
}

class TaskTemplatesCompanion extends UpdateCompanion<TaskTemplateEntity> {
  final Value<int> id;
  final Value<int> templateGroupId;
  final Value<int> versionNumber;
  final Value<int?> previousVersionId;
  final Value<String> title;
  final Value<String> segment;
  final Value<String> applicableRoleTiers;
  final Value<String> method;
  final Value<bool> requiresPhoto;
  final Value<bool> requiresNotes;
  final Value<String?> customFieldsJson;
  final Value<double?> minLimit;
  final Value<double?> maxLimit;
  final Value<String?> unit;
  final Value<String?> legalLimitCategory;
  final Value<bool> isCritical;
  final Value<bool> requiresCorrectiveActionOnFail;
  final Value<String?> fixInstructions;
  final Value<int?> equipmentTypeId;
  final Value<DateTime> createdAt;
  final Value<int?> createdByUserId;
  const TaskTemplatesCompanion({
    this.id = const Value.absent(),
    this.templateGroupId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.previousVersionId = const Value.absent(),
    this.title = const Value.absent(),
    this.segment = const Value.absent(),
    this.applicableRoleTiers = const Value.absent(),
    this.method = const Value.absent(),
    this.requiresPhoto = const Value.absent(),
    this.requiresNotes = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.minLimit = const Value.absent(),
    this.maxLimit = const Value.absent(),
    this.unit = const Value.absent(),
    this.legalLimitCategory = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.requiresCorrectiveActionOnFail = const Value.absent(),
    this.fixInstructions = const Value.absent(),
    this.equipmentTypeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdByUserId = const Value.absent(),
  });
  TaskTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int templateGroupId,
    required int versionNumber,
    this.previousVersionId = const Value.absent(),
    required String title,
    required String segment,
    required String applicableRoleTiers,
    required String method,
    this.requiresPhoto = const Value.absent(),
    this.requiresNotes = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.minLimit = const Value.absent(),
    this.maxLimit = const Value.absent(),
    this.unit = const Value.absent(),
    this.legalLimitCategory = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.requiresCorrectiveActionOnFail = const Value.absent(),
    this.fixInstructions = const Value.absent(),
    this.equipmentTypeId = const Value.absent(),
    required DateTime createdAt,
    this.createdByUserId = const Value.absent(),
  }) : templateGroupId = Value(templateGroupId),
       versionNumber = Value(versionNumber),
       title = Value(title),
       segment = Value(segment),
       applicableRoleTiers = Value(applicableRoleTiers),
       method = Value(method),
       createdAt = Value(createdAt);
  static Insertable<TaskTemplateEntity> custom({
    Expression<int>? id,
    Expression<int>? templateGroupId,
    Expression<int>? versionNumber,
    Expression<int>? previousVersionId,
    Expression<String>? title,
    Expression<String>? segment,
    Expression<String>? applicableRoleTiers,
    Expression<String>? method,
    Expression<bool>? requiresPhoto,
    Expression<bool>? requiresNotes,
    Expression<String>? customFieldsJson,
    Expression<double>? minLimit,
    Expression<double>? maxLimit,
    Expression<String>? unit,
    Expression<String>? legalLimitCategory,
    Expression<bool>? isCritical,
    Expression<bool>? requiresCorrectiveActionOnFail,
    Expression<String>? fixInstructions,
    Expression<int>? equipmentTypeId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdByUserId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateGroupId != null) 'template_group_id': templateGroupId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (previousVersionId != null) 'previous_version_id': previousVersionId,
      if (title != null) 'title': title,
      if (segment != null) 'segment': segment,
      if (applicableRoleTiers != null)
        'applicable_role_tiers': applicableRoleTiers,
      if (method != null) 'method': method,
      if (requiresPhoto != null) 'requires_photo': requiresPhoto,
      if (requiresNotes != null) 'requires_notes': requiresNotes,
      if (customFieldsJson != null) 'custom_fields_json': customFieldsJson,
      if (minLimit != null) 'min_limit': minLimit,
      if (maxLimit != null) 'max_limit': maxLimit,
      if (unit != null) 'unit': unit,
      if (legalLimitCategory != null)
        'legal_limit_category': legalLimitCategory,
      if (isCritical != null) 'is_critical': isCritical,
      if (requiresCorrectiveActionOnFail != null)
        'requires_corrective_action_on_fail': requiresCorrectiveActionOnFail,
      if (fixInstructions != null) 'fix_instructions': fixInstructions,
      if (equipmentTypeId != null) 'equipment_type_id': equipmentTypeId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
    });
  }

  TaskTemplatesCompanion copyWith({
    Value<int>? id,
    Value<int>? templateGroupId,
    Value<int>? versionNumber,
    Value<int?>? previousVersionId,
    Value<String>? title,
    Value<String>? segment,
    Value<String>? applicableRoleTiers,
    Value<String>? method,
    Value<bool>? requiresPhoto,
    Value<bool>? requiresNotes,
    Value<String?>? customFieldsJson,
    Value<double?>? minLimit,
    Value<double?>? maxLimit,
    Value<String?>? unit,
    Value<String?>? legalLimitCategory,
    Value<bool>? isCritical,
    Value<bool>? requiresCorrectiveActionOnFail,
    Value<String?>? fixInstructions,
    Value<int?>? equipmentTypeId,
    Value<DateTime>? createdAt,
    Value<int?>? createdByUserId,
  }) {
    return TaskTemplatesCompanion(
      id: id ?? this.id,
      templateGroupId: templateGroupId ?? this.templateGroupId,
      versionNumber: versionNumber ?? this.versionNumber,
      previousVersionId: previousVersionId ?? this.previousVersionId,
      title: title ?? this.title,
      segment: segment ?? this.segment,
      applicableRoleTiers: applicableRoleTiers ?? this.applicableRoleTiers,
      method: method ?? this.method,
      requiresPhoto: requiresPhoto ?? this.requiresPhoto,
      requiresNotes: requiresNotes ?? this.requiresNotes,
      customFieldsJson: customFieldsJson ?? this.customFieldsJson,
      minLimit: minLimit ?? this.minLimit,
      maxLimit: maxLimit ?? this.maxLimit,
      unit: unit ?? this.unit,
      legalLimitCategory: legalLimitCategory ?? this.legalLimitCategory,
      isCritical: isCritical ?? this.isCritical,
      requiresCorrectiveActionOnFail:
          requiresCorrectiveActionOnFail ?? this.requiresCorrectiveActionOnFail,
      fixInstructions: fixInstructions ?? this.fixInstructions,
      equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateGroupId.present) {
      map['template_group_id'] = Variable<int>(templateGroupId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (previousVersionId.present) {
      map['previous_version_id'] = Variable<int>(previousVersionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (segment.present) {
      map['segment'] = Variable<String>(segment.value);
    }
    if (applicableRoleTiers.present) {
      map['applicable_role_tiers'] = Variable<String>(
        applicableRoleTiers.value,
      );
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (requiresPhoto.present) {
      map['requires_photo'] = Variable<bool>(requiresPhoto.value);
    }
    if (requiresNotes.present) {
      map['requires_notes'] = Variable<bool>(requiresNotes.value);
    }
    if (customFieldsJson.present) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson.value);
    }
    if (minLimit.present) {
      map['min_limit'] = Variable<double>(minLimit.value);
    }
    if (maxLimit.present) {
      map['max_limit'] = Variable<double>(maxLimit.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (legalLimitCategory.present) {
      map['legal_limit_category'] = Variable<String>(legalLimitCategory.value);
    }
    if (isCritical.present) {
      map['is_critical'] = Variable<bool>(isCritical.value);
    }
    if (requiresCorrectiveActionOnFail.present) {
      map['requires_corrective_action_on_fail'] = Variable<bool>(
        requiresCorrectiveActionOnFail.value,
      );
    }
    if (fixInstructions.present) {
      map['fix_instructions'] = Variable<String>(fixInstructions.value);
    }
    if (equipmentTypeId.present) {
      map['equipment_type_id'] = Variable<int>(equipmentTypeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<int>(createdByUserId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('templateGroupId: $templateGroupId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('title: $title, ')
          ..write('segment: $segment, ')
          ..write('applicableRoleTiers: $applicableRoleTiers, ')
          ..write('method: $method, ')
          ..write('requiresPhoto: $requiresPhoto, ')
          ..write('requiresNotes: $requiresNotes, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('minLimit: $minLimit, ')
          ..write('maxLimit: $maxLimit, ')
          ..write('unit: $unit, ')
          ..write('legalLimitCategory: $legalLimitCategory, ')
          ..write('isCritical: $isCritical, ')
          ..write(
            'requiresCorrectiveActionOnFail: $requiresCorrectiveActionOnFail, ',
          )
          ..write('fixInstructions: $fixInstructions, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId')
          ..write(')'))
        .toString();
  }
}

class $AreasTable extends Areas with TableInfo<$AreasTable, AreaEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AreasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'areas';
  @override
  VerificationContext validateIntegrity(
    Insertable<AreaEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AreaEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AreaEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $AreasTable createAlias(String alias) {
    return $AreasTable(attachedDatabase, alias);
  }
}

class AreaEntity extends DataClass implements Insertable<AreaEntity> {
  final int id;
  final String name;
  const AreaEntity({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  AreasCompanion toCompanion(bool nullToAbsent) {
    return AreasCompanion(id: Value(id), name: Value(name));
  }

  factory AreaEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AreaEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  AreaEntity copyWith({int? id, String? name}) =>
      AreaEntity(id: id ?? this.id, name: name ?? this.name);
  AreaEntity copyWithCompanion(AreasCompanion data) {
    return AreaEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AreaEntity(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AreaEntity && other.id == this.id && other.name == this.name);
}

class AreasCompanion extends UpdateCompanion<AreaEntity> {
  final Value<int> id;
  final Value<String> name;
  const AreasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  AreasCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<AreaEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  AreasCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return AreasCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $EquipmentInstancesTable extends EquipmentInstances
    with TableInfo<$EquipmentInstancesTable, EquipmentInstanceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentInstancesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentTypeIdMeta = const VerificationMeta(
    'equipmentTypeId',
  );
  @override
  late final GeneratedColumn<int> equipmentTypeId = GeneratedColumn<int>(
    'equipment_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment_types (id)',
    ),
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<int> areaId = GeneratedColumn<int>(
    'area_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES areas (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, equipmentTypeId, areaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentInstanceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('equipment_type_id')) {
      context.handle(
        _equipmentTypeIdMeta,
        equipmentTypeId.isAcceptableOrUnknown(
          data['equipment_type_id']!,
          _equipmentTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentTypeIdMeta);
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentInstanceEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentInstanceEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      equipmentTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_type_id'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}area_id'],
      ),
    );
  }

  @override
  $EquipmentInstancesTable createAlias(String alias) {
    return $EquipmentInstancesTable(attachedDatabase, alias);
  }
}

class EquipmentInstanceEntity extends DataClass
    implements Insertable<EquipmentInstanceEntity> {
  final int id;
  final String name;
  final int equipmentTypeId;
  final int? areaId;
  const EquipmentInstanceEntity({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
    this.areaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['equipment_type_id'] = Variable<int>(equipmentTypeId);
    if (!nullToAbsent || areaId != null) {
      map['area_id'] = Variable<int>(areaId);
    }
    return map;
  }

  EquipmentInstancesCompanion toCompanion(bool nullToAbsent) {
    return EquipmentInstancesCompanion(
      id: Value(id),
      name: Value(name),
      equipmentTypeId: Value(equipmentTypeId),
      areaId: areaId == null && nullToAbsent
          ? const Value.absent()
          : Value(areaId),
    );
  }

  factory EquipmentInstanceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentInstanceEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      equipmentTypeId: serializer.fromJson<int>(json['equipmentTypeId']),
      areaId: serializer.fromJson<int?>(json['areaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'equipmentTypeId': serializer.toJson<int>(equipmentTypeId),
      'areaId': serializer.toJson<int?>(areaId),
    };
  }

  EquipmentInstanceEntity copyWith({
    int? id,
    String? name,
    int? equipmentTypeId,
    Value<int?> areaId = const Value.absent(),
  }) => EquipmentInstanceEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
    areaId: areaId.present ? areaId.value : this.areaId,
  );
  EquipmentInstanceEntity copyWithCompanion(EquipmentInstancesCompanion data) {
    return EquipmentInstanceEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      equipmentTypeId: data.equipmentTypeId.present
          ? data.equipmentTypeId.value
          : this.equipmentTypeId,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInstanceEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('areaId: $areaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, equipmentTypeId, areaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentInstanceEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.equipmentTypeId == this.equipmentTypeId &&
          other.areaId == this.areaId);
}

class EquipmentInstancesCompanion
    extends UpdateCompanion<EquipmentInstanceEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> equipmentTypeId;
  final Value<int?> areaId;
  const EquipmentInstancesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.equipmentTypeId = const Value.absent(),
    this.areaId = const Value.absent(),
  });
  EquipmentInstancesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int equipmentTypeId,
    this.areaId = const Value.absent(),
  }) : name = Value(name),
       equipmentTypeId = Value(equipmentTypeId);
  static Insertable<EquipmentInstanceEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? equipmentTypeId,
    Expression<int>? areaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (equipmentTypeId != null) 'equipment_type_id': equipmentTypeId,
      if (areaId != null) 'area_id': areaId,
    });
  }

  EquipmentInstancesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? equipmentTypeId,
    Value<int?>? areaId,
  }) {
    return EquipmentInstancesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
      areaId: areaId ?? this.areaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (equipmentTypeId.present) {
      map['equipment_type_id'] = Variable<int>(equipmentTypeId.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<int>(areaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInstancesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('areaId: $areaId')
          ..write(')'))
        .toString();
  }
}

class $TaskSchedulesTable extends TaskSchedules
    with TableInfo<$TaskSchedulesTable, TaskScheduleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskSchedulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _taskTemplateGroupIdMeta =
      const VerificationMeta('taskTemplateGroupId');
  @override
  late final GeneratedColumn<int> taskTemplateGroupId = GeneratedColumn<int>(
    'task_template_group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedUserIdMeta = const VerificationMeta(
    'assignedUserId',
  );
  @override
  late final GeneratedColumn<int> assignedUserId = GeneratedColumn<int>(
    'assigned_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _equipmentInstanceIdMeta =
      const VerificationMeta('equipmentInstanceId');
  @override
  late final GeneratedColumn<int> equipmentInstanceId = GeneratedColumn<int>(
    'equipment_instance_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment_instances (id)',
    ),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customFrequencyDetailMeta =
      const VerificationMeta('customFrequencyDetail');
  @override
  late final GeneratedColumn<String> customFrequencyDetail =
      GeneratedColumn<String>(
        'custom_frequency_detail',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _assignedByUserIdMeta = const VerificationMeta(
    'assignedByUserId',
  );
  @override
  late final GeneratedColumn<int> assignedByUserId = GeneratedColumn<int>(
    'assigned_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskTemplateGroupId,
    assignedUserId,
    equipmentInstanceId,
    frequency,
    customFrequencyDetail,
    assignedByUserId,
    assignedAt,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskScheduleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_template_group_id')) {
      context.handle(
        _taskTemplateGroupIdMeta,
        taskTemplateGroupId.isAcceptableOrUnknown(
          data['task_template_group_id']!,
          _taskTemplateGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taskTemplateGroupIdMeta);
    }
    if (data.containsKey('assigned_user_id')) {
      context.handle(
        _assignedUserIdMeta,
        assignedUserId.isAcceptableOrUnknown(
          data['assigned_user_id']!,
          _assignedUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignedUserIdMeta);
    }
    if (data.containsKey('equipment_instance_id')) {
      context.handle(
        _equipmentInstanceIdMeta,
        equipmentInstanceId.isAcceptableOrUnknown(
          data['equipment_instance_id']!,
          _equipmentInstanceIdMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('custom_frequency_detail')) {
      context.handle(
        _customFrequencyDetailMeta,
        customFrequencyDetail.isAcceptableOrUnknown(
          data['custom_frequency_detail']!,
          _customFrequencyDetailMeta,
        ),
      );
    }
    if (data.containsKey('assigned_by_user_id')) {
      context.handle(
        _assignedByUserIdMeta,
        assignedByUserId.isAcceptableOrUnknown(
          data['assigned_by_user_id']!,
          _assignedByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignedByUserIdMeta);
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskScheduleEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskScheduleEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskTemplateGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_template_group_id'],
      )!,
      assignedUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_user_id'],
      )!,
      equipmentInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_instance_id'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      customFrequencyDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_frequency_detail'],
      ),
      assignedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_by_user_id'],
      )!,
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $TaskSchedulesTable createAlias(String alias) {
    return $TaskSchedulesTable(attachedDatabase, alias);
  }
}

class TaskScheduleEntity extends DataClass
    implements Insertable<TaskScheduleEntity> {
  final int id;
  final int taskTemplateGroupId;
  final int assignedUserId;
  final int? equipmentInstanceId;
  final String frequency;
  final String? customFrequencyDetail;
  final int assignedByUserId;
  final DateTime assignedAt;
  final bool active;
  const TaskScheduleEntity({
    required this.id,
    required this.taskTemplateGroupId,
    required this.assignedUserId,
    this.equipmentInstanceId,
    required this.frequency,
    this.customFrequencyDetail,
    required this.assignedByUserId,
    required this.assignedAt,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_template_group_id'] = Variable<int>(taskTemplateGroupId);
    map['assigned_user_id'] = Variable<int>(assignedUserId);
    if (!nullToAbsent || equipmentInstanceId != null) {
      map['equipment_instance_id'] = Variable<int>(equipmentInstanceId);
    }
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || customFrequencyDetail != null) {
      map['custom_frequency_detail'] = Variable<String>(customFrequencyDetail);
    }
    map['assigned_by_user_id'] = Variable<int>(assignedByUserId);
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    map['active'] = Variable<bool>(active);
    return map;
  }

  TaskSchedulesCompanion toCompanion(bool nullToAbsent) {
    return TaskSchedulesCompanion(
      id: Value(id),
      taskTemplateGroupId: Value(taskTemplateGroupId),
      assignedUserId: Value(assignedUserId),
      equipmentInstanceId: equipmentInstanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentInstanceId),
      frequency: Value(frequency),
      customFrequencyDetail: customFrequencyDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(customFrequencyDetail),
      assignedByUserId: Value(assignedByUserId),
      assignedAt: Value(assignedAt),
      active: Value(active),
    );
  }

  factory TaskScheduleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskScheduleEntity(
      id: serializer.fromJson<int>(json['id']),
      taskTemplateGroupId: serializer.fromJson<int>(
        json['taskTemplateGroupId'],
      ),
      assignedUserId: serializer.fromJson<int>(json['assignedUserId']),
      equipmentInstanceId: serializer.fromJson<int?>(
        json['equipmentInstanceId'],
      ),
      frequency: serializer.fromJson<String>(json['frequency']),
      customFrequencyDetail: serializer.fromJson<String?>(
        json['customFrequencyDetail'],
      ),
      assignedByUserId: serializer.fromJson<int>(json['assignedByUserId']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskTemplateGroupId': serializer.toJson<int>(taskTemplateGroupId),
      'assignedUserId': serializer.toJson<int>(assignedUserId),
      'equipmentInstanceId': serializer.toJson<int?>(equipmentInstanceId),
      'frequency': serializer.toJson<String>(frequency),
      'customFrequencyDetail': serializer.toJson<String?>(
        customFrequencyDetail,
      ),
      'assignedByUserId': serializer.toJson<int>(assignedByUserId),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
      'active': serializer.toJson<bool>(active),
    };
  }

  TaskScheduleEntity copyWith({
    int? id,
    int? taskTemplateGroupId,
    int? assignedUserId,
    Value<int?> equipmentInstanceId = const Value.absent(),
    String? frequency,
    Value<String?> customFrequencyDetail = const Value.absent(),
    int? assignedByUserId,
    DateTime? assignedAt,
    bool? active,
  }) => TaskScheduleEntity(
    id: id ?? this.id,
    taskTemplateGroupId: taskTemplateGroupId ?? this.taskTemplateGroupId,
    assignedUserId: assignedUserId ?? this.assignedUserId,
    equipmentInstanceId: equipmentInstanceId.present
        ? equipmentInstanceId.value
        : this.equipmentInstanceId,
    frequency: frequency ?? this.frequency,
    customFrequencyDetail: customFrequencyDetail.present
        ? customFrequencyDetail.value
        : this.customFrequencyDetail,
    assignedByUserId: assignedByUserId ?? this.assignedByUserId,
    assignedAt: assignedAt ?? this.assignedAt,
    active: active ?? this.active,
  );
  TaskScheduleEntity copyWithCompanion(TaskSchedulesCompanion data) {
    return TaskScheduleEntity(
      id: data.id.present ? data.id.value : this.id,
      taskTemplateGroupId: data.taskTemplateGroupId.present
          ? data.taskTemplateGroupId.value
          : this.taskTemplateGroupId,
      assignedUserId: data.assignedUserId.present
          ? data.assignedUserId.value
          : this.assignedUserId,
      equipmentInstanceId: data.equipmentInstanceId.present
          ? data.equipmentInstanceId.value
          : this.equipmentInstanceId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      customFrequencyDetail: data.customFrequencyDetail.present
          ? data.customFrequencyDetail.value
          : this.customFrequencyDetail,
      assignedByUserId: data.assignedByUserId.present
          ? data.assignedByUserId.value
          : this.assignedByUserId,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskScheduleEntity(')
          ..write('id: $id, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('assignedUserId: $assignedUserId, ')
          ..write('equipmentInstanceId: $equipmentInstanceId, ')
          ..write('frequency: $frequency, ')
          ..write('customFrequencyDetail: $customFrequencyDetail, ')
          ..write('assignedByUserId: $assignedByUserId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskTemplateGroupId,
    assignedUserId,
    equipmentInstanceId,
    frequency,
    customFrequencyDetail,
    assignedByUserId,
    assignedAt,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskScheduleEntity &&
          other.id == this.id &&
          other.taskTemplateGroupId == this.taskTemplateGroupId &&
          other.assignedUserId == this.assignedUserId &&
          other.equipmentInstanceId == this.equipmentInstanceId &&
          other.frequency == this.frequency &&
          other.customFrequencyDetail == this.customFrequencyDetail &&
          other.assignedByUserId == this.assignedByUserId &&
          other.assignedAt == this.assignedAt &&
          other.active == this.active);
}

class TaskSchedulesCompanion extends UpdateCompanion<TaskScheduleEntity> {
  final Value<int> id;
  final Value<int> taskTemplateGroupId;
  final Value<int> assignedUserId;
  final Value<int?> equipmentInstanceId;
  final Value<String> frequency;
  final Value<String?> customFrequencyDetail;
  final Value<int> assignedByUserId;
  final Value<DateTime> assignedAt;
  final Value<bool> active;
  const TaskSchedulesCompanion({
    this.id = const Value.absent(),
    this.taskTemplateGroupId = const Value.absent(),
    this.assignedUserId = const Value.absent(),
    this.equipmentInstanceId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.customFrequencyDetail = const Value.absent(),
    this.assignedByUserId = const Value.absent(),
    this.assignedAt = const Value.absent(),
    this.active = const Value.absent(),
  });
  TaskSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int taskTemplateGroupId,
    required int assignedUserId,
    this.equipmentInstanceId = const Value.absent(),
    required String frequency,
    this.customFrequencyDetail = const Value.absent(),
    required int assignedByUserId,
    required DateTime assignedAt,
    this.active = const Value.absent(),
  }) : taskTemplateGroupId = Value(taskTemplateGroupId),
       assignedUserId = Value(assignedUserId),
       frequency = Value(frequency),
       assignedByUserId = Value(assignedByUserId),
       assignedAt = Value(assignedAt);
  static Insertable<TaskScheduleEntity> custom({
    Expression<int>? id,
    Expression<int>? taskTemplateGroupId,
    Expression<int>? assignedUserId,
    Expression<int>? equipmentInstanceId,
    Expression<String>? frequency,
    Expression<String>? customFrequencyDetail,
    Expression<int>? assignedByUserId,
    Expression<DateTime>? assignedAt,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskTemplateGroupId != null)
        'task_template_group_id': taskTemplateGroupId,
      if (assignedUserId != null) 'assigned_user_id': assignedUserId,
      if (equipmentInstanceId != null)
        'equipment_instance_id': equipmentInstanceId,
      if (frequency != null) 'frequency': frequency,
      if (customFrequencyDetail != null)
        'custom_frequency_detail': customFrequencyDetail,
      if (assignedByUserId != null) 'assigned_by_user_id': assignedByUserId,
      if (assignedAt != null) 'assigned_at': assignedAt,
      if (active != null) 'active': active,
    });
  }

  TaskSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? taskTemplateGroupId,
    Value<int>? assignedUserId,
    Value<int?>? equipmentInstanceId,
    Value<String>? frequency,
    Value<String?>? customFrequencyDetail,
    Value<int>? assignedByUserId,
    Value<DateTime>? assignedAt,
    Value<bool>? active,
  }) {
    return TaskSchedulesCompanion(
      id: id ?? this.id,
      taskTemplateGroupId: taskTemplateGroupId ?? this.taskTemplateGroupId,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      equipmentInstanceId: equipmentInstanceId ?? this.equipmentInstanceId,
      frequency: frequency ?? this.frequency,
      customFrequencyDetail:
          customFrequencyDetail ?? this.customFrequencyDetail,
      assignedByUserId: assignedByUserId ?? this.assignedByUserId,
      assignedAt: assignedAt ?? this.assignedAt,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskTemplateGroupId.present) {
      map['task_template_group_id'] = Variable<int>(taskTemplateGroupId.value);
    }
    if (assignedUserId.present) {
      map['assigned_user_id'] = Variable<int>(assignedUserId.value);
    }
    if (equipmentInstanceId.present) {
      map['equipment_instance_id'] = Variable<int>(equipmentInstanceId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (customFrequencyDetail.present) {
      map['custom_frequency_detail'] = Variable<String>(
        customFrequencyDetail.value,
      );
    }
    if (assignedByUserId.present) {
      map['assigned_by_user_id'] = Variable<int>(assignedByUserId.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('assignedUserId: $assignedUserId, ')
          ..write('equipmentInstanceId: $equipmentInstanceId, ')
          ..write('frequency: $frequency, ')
          ..write('customFrequencyDetail: $customFrequencyDetail, ')
          ..write('assignedByUserId: $assignedByUserId, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('active: $active')
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
  late final $UsersTable users = $UsersTable(this);
  late final $EquipmentTypesTable equipmentTypes = $EquipmentTypesTable(this);
  late final $LegalLimitReferencesTable legalLimitReferences =
      $LegalLimitReferencesTable(this);
  late final $TaskTemplatesTable taskTemplates = $TaskTemplatesTable(this);
  late final $AreasTable areas = $AreasTable(this);
  late final $EquipmentInstancesTable equipmentInstances =
      $EquipmentInstancesTable(this);
  late final $TaskSchedulesTable taskSchedules = $TaskSchedulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskSubmissions,
    users,
    equipmentTypes,
    legalLimitReferences,
    taskTemplates,
    areas,
    equipmentInstances,
    taskSchedules,
  ];
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
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String name,
      required String jobTitle,
      required String roleTier,
      required String pinHash,
      required String pinSalt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> jobTitle,
      Value<String> roleTier,
      Value<String> pinHash,
      Value<String> pinSalt,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, UserEntity> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskTemplatesTable, List<TaskTemplateEntity>>
  _taskTemplatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskTemplates,
    aliasName: 'users__id__task_templates__created_by_user_id',
  );

  $$TaskTemplatesTableProcessedTableManager get taskTemplatesRefs {
    final manager = $$TaskTemplatesTableTableManager(
      $_db,
      $_db.taskTemplates,
    ).filter((f) => f.createdByUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskTemplatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleTier => $composableBuilder(
    column: $table.roleTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskTemplatesRefs(
    Expression<bool> Function($$TaskTemplatesTableFilterComposer f) f,
  ) {
    final $$TaskTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.createdByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleTier => $composableBuilder(
    column: $table.roleTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<String> get roleTier =>
      $composableBuilder(column: $table.roleTier, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  Expression<T> taskTemplatesRefs<T extends Object>(
    Expression<T> Function($$TaskTemplatesTableAnnotationComposer a) f,
  ) {
    final $$TaskTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.createdByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserEntity,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserEntity, $$UsersTableReferences),
          UserEntity,
          PrefetchHooks Function({bool taskTemplatesRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> jobTitle = const Value.absent(),
                Value<String> roleTier = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> pinSalt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                jobTitle: jobTitle,
                roleTier: roleTier,
                pinHash: pinHash,
                pinSalt: pinSalt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String jobTitle,
                required String roleTier,
                required String pinHash,
                required String pinSalt,
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                jobTitle: jobTitle,
                roleTier: roleTier,
                pinHash: pinHash,
                pinSalt: pinSalt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({taskTemplatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskTemplatesRefs) db.taskTemplates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskTemplatesRefs)
                    await $_getPrefetchedData<
                      UserEntity,
                      $UsersTable,
                      TaskTemplateEntity
                    >(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._taskTemplatesRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsersTableReferences(
                        db,
                        table,
                        p0,
                      ).taskTemplatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.createdByUserId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserEntity,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserEntity, $$UsersTableReferences),
      UserEntity,
      PrefetchHooks Function({bool taskTemplatesRefs})
    >;
typedef $$EquipmentTypesTableCreateCompanionBuilder =
    EquipmentTypesCompanion Function({Value<int> id, required String name});
typedef $$EquipmentTypesTableUpdateCompanionBuilder =
    EquipmentTypesCompanion Function({Value<int> id, Value<String> name});

final class $$EquipmentTypesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EquipmentTypesTable,
          EquipmentTypeEntity
        > {
  $$EquipmentTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaskTemplatesTable, List<TaskTemplateEntity>>
  _taskTemplatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskTemplates,
    aliasName: 'equipment_types__id__task_templates__equipment_type_id',
  );

  $$TaskTemplatesTableProcessedTableManager get taskTemplatesRefs {
    final manager = $$TaskTemplatesTableTableManager(
      $_db,
      $_db.taskTemplates,
    ).filter((f) => f.equipmentTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskTemplatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EquipmentInstancesTable,
    List<EquipmentInstanceEntity>
  >
  _equipmentInstancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.equipmentInstances,
        aliasName:
            'equipment_types__id__equipment_instances__equipment_type_id',
      );

  $$EquipmentInstancesTableProcessedTableManager get equipmentInstancesRefs {
    final manager = $$EquipmentInstancesTableTableManager(
      $_db,
      $_db.equipmentInstances,
    ).filter((f) => f.equipmentTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _equipmentInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentTypesTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTypesTable> {
  $$EquipmentTypesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskTemplatesRefs(
    Expression<bool> Function($$TaskTemplatesTableFilterComposer f) f,
  ) {
    final $$TaskTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.equipmentTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> equipmentInstancesRefs(
    Expression<bool> Function($$EquipmentInstancesTableFilterComposer f) f,
  ) {
    final $$EquipmentInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipmentInstances,
      getReferencedColumn: (t) => t.equipmentTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentInstancesTableFilterComposer(
            $db: $db,
            $table: $db.equipmentInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTypesTable> {
  $$EquipmentTypesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTypesTable> {
  $$EquipmentTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> taskTemplatesRefs<T extends Object>(
    Expression<T> Function($$TaskTemplatesTableAnnotationComposer a) f,
  ) {
    final $$TaskTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.equipmentTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> equipmentInstancesRefs<T extends Object>(
    Expression<T> Function($$EquipmentInstancesTableAnnotationComposer a) f,
  ) {
    final $$EquipmentInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.equipmentInstances,
          getReferencedColumn: (t) => t.equipmentTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EquipmentInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.equipmentInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EquipmentTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTypesTable,
          EquipmentTypeEntity,
          $$EquipmentTypesTableFilterComposer,
          $$EquipmentTypesTableOrderingComposer,
          $$EquipmentTypesTableAnnotationComposer,
          $$EquipmentTypesTableCreateCompanionBuilder,
          $$EquipmentTypesTableUpdateCompanionBuilder,
          (EquipmentTypeEntity, $$EquipmentTypesTableReferences),
          EquipmentTypeEntity,
          PrefetchHooks Function({
            bool taskTemplatesRefs,
            bool equipmentInstancesRefs,
          })
        > {
  $$EquipmentTypesTableTableManager(
    _$AppDatabase db,
    $EquipmentTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => EquipmentTypesCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  EquipmentTypesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipmentTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taskTemplatesRefs = false, equipmentInstancesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskTemplatesRefs) db.taskTemplates,
                    if (equipmentInstancesRefs) db.equipmentInstances,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskTemplatesRefs)
                        await $_getPrefetchedData<
                          EquipmentTypeEntity,
                          $EquipmentTypesTable,
                          TaskTemplateEntity
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentTypesTableReferences
                              ._taskTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (equipmentInstancesRefs)
                        await $_getPrefetchedData<
                          EquipmentTypeEntity,
                          $EquipmentTypesTable,
                          EquipmentInstanceEntity
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentTypesTableReferences
                              ._equipmentInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).equipmentInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquipmentTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTypesTable,
      EquipmentTypeEntity,
      $$EquipmentTypesTableFilterComposer,
      $$EquipmentTypesTableOrderingComposer,
      $$EquipmentTypesTableAnnotationComposer,
      $$EquipmentTypesTableCreateCompanionBuilder,
      $$EquipmentTypesTableUpdateCompanionBuilder,
      (EquipmentTypeEntity, $$EquipmentTypesTableReferences),
      EquipmentTypeEntity,
      PrefetchHooks Function({
        bool taskTemplatesRefs,
        bool equipmentInstancesRefs,
      })
    >;
typedef $$LegalLimitReferencesTableCreateCompanionBuilder =
    LegalLimitReferencesCompanion Function({
      Value<int> id,
      required String category,
      Value<double?> legalMin,
      Value<double?> legalMax,
      required String unit,
    });
typedef $$LegalLimitReferencesTableUpdateCompanionBuilder =
    LegalLimitReferencesCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<double?> legalMin,
      Value<double?> legalMax,
      Value<String> unit,
    });

class $$LegalLimitReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $LegalLimitReferencesTable> {
  $$LegalLimitReferencesTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get legalMin => $composableBuilder(
    column: $table.legalMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get legalMax => $composableBuilder(
    column: $table.legalMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalLimitReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalLimitReferencesTable> {
  $$LegalLimitReferencesTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get legalMin => $composableBuilder(
    column: $table.legalMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get legalMax => $composableBuilder(
    column: $table.legalMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalLimitReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalLimitReferencesTable> {
  $$LegalLimitReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get legalMin =>
      $composableBuilder(column: $table.legalMin, builder: (column) => column);

  GeneratedColumn<double> get legalMax =>
      $composableBuilder(column: $table.legalMax, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);
}

class $$LegalLimitReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalLimitReferencesTable,
          LegalLimitReferenceEntity,
          $$LegalLimitReferencesTableFilterComposer,
          $$LegalLimitReferencesTableOrderingComposer,
          $$LegalLimitReferencesTableAnnotationComposer,
          $$LegalLimitReferencesTableCreateCompanionBuilder,
          $$LegalLimitReferencesTableUpdateCompanionBuilder,
          (
            LegalLimitReferenceEntity,
            BaseReferences<
              _$AppDatabase,
              $LegalLimitReferencesTable,
              LegalLimitReferenceEntity
            >,
          ),
          LegalLimitReferenceEntity,
          PrefetchHooks Function()
        > {
  $$LegalLimitReferencesTableTableManager(
    _$AppDatabase db,
    $LegalLimitReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalLimitReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalLimitReferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegalLimitReferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double?> legalMin = const Value.absent(),
                Value<double?> legalMax = const Value.absent(),
                Value<String> unit = const Value.absent(),
              }) => LegalLimitReferencesCompanion(
                id: id,
                category: category,
                legalMin: legalMin,
                legalMax: legalMax,
                unit: unit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                Value<double?> legalMin = const Value.absent(),
                Value<double?> legalMax = const Value.absent(),
                required String unit,
              }) => LegalLimitReferencesCompanion.insert(
                id: id,
                category: category,
                legalMin: legalMin,
                legalMax: legalMax,
                unit: unit,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalLimitReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalLimitReferencesTable,
      LegalLimitReferenceEntity,
      $$LegalLimitReferencesTableFilterComposer,
      $$LegalLimitReferencesTableOrderingComposer,
      $$LegalLimitReferencesTableAnnotationComposer,
      $$LegalLimitReferencesTableCreateCompanionBuilder,
      $$LegalLimitReferencesTableUpdateCompanionBuilder,
      (
        LegalLimitReferenceEntity,
        BaseReferences<
          _$AppDatabase,
          $LegalLimitReferencesTable,
          LegalLimitReferenceEntity
        >,
      ),
      LegalLimitReferenceEntity,
      PrefetchHooks Function()
    >;
typedef $$TaskTemplatesTableCreateCompanionBuilder =
    TaskTemplatesCompanion Function({
      Value<int> id,
      required int templateGroupId,
      required int versionNumber,
      Value<int?> previousVersionId,
      required String title,
      required String segment,
      required String applicableRoleTiers,
      required String method,
      Value<bool> requiresPhoto,
      Value<bool> requiresNotes,
      Value<String?> customFieldsJson,
      Value<double?> minLimit,
      Value<double?> maxLimit,
      Value<String?> unit,
      Value<String?> legalLimitCategory,
      Value<bool> isCritical,
      Value<bool> requiresCorrectiveActionOnFail,
      Value<String?> fixInstructions,
      Value<int?> equipmentTypeId,
      required DateTime createdAt,
      Value<int?> createdByUserId,
    });
typedef $$TaskTemplatesTableUpdateCompanionBuilder =
    TaskTemplatesCompanion Function({
      Value<int> id,
      Value<int> templateGroupId,
      Value<int> versionNumber,
      Value<int?> previousVersionId,
      Value<String> title,
      Value<String> segment,
      Value<String> applicableRoleTiers,
      Value<String> method,
      Value<bool> requiresPhoto,
      Value<bool> requiresNotes,
      Value<String?> customFieldsJson,
      Value<double?> minLimit,
      Value<double?> maxLimit,
      Value<String?> unit,
      Value<String?> legalLimitCategory,
      Value<bool> isCritical,
      Value<bool> requiresCorrectiveActionOnFail,
      Value<String?> fixInstructions,
      Value<int?> equipmentTypeId,
      Value<DateTime> createdAt,
      Value<int?> createdByUserId,
    });

final class $$TaskTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskTemplatesTable, TaskTemplateEntity> {
  $$TaskTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskTemplatesTable _previousVersionIdTable(_$AppDatabase db) => db
      .taskTemplates
      .createAlias('task_templates__previous_version_id__task_templates__id');

  $$TaskTemplatesTableProcessedTableManager? get previousVersionId {
    final $_column = $_itemColumn<int>('previous_version_id');
    if ($_column == null) return null;
    final manager = $$TaskTemplatesTableTableManager(
      $_db,
      $_db.taskTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_previousVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentTypesTable _equipmentTypeIdTable(_$AppDatabase db) => db
      .equipmentTypes
      .createAlias('task_templates__equipment_type_id__equipment_types__id');

  $$EquipmentTypesTableProcessedTableManager? get equipmentTypeId {
    final $_column = $_itemColumn<int>('equipment_type_id');
    if ($_column == null) return null;
    final manager = $$EquipmentTypesTableTableManager(
      $_db,
      $_db.equipmentTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _createdByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('task_templates__created_by_user_id__users__id');

  $$UsersTableProcessedTableManager? get createdByUserId {
    final $_column = $_itemColumn<int>('created_by_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableFilterComposer({
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

  ColumnFilters<int> get templateGroupId => $composableBuilder(
    column: $table.templateGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicableRoleTiers => $composableBuilder(
    column: $table.applicableRoleTiers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresPhoto => $composableBuilder(
    column: $table.requiresPhoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresNotes => $composableBuilder(
    column: $table.requiresNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minLimit => $composableBuilder(
    column: $table.minLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxLimit => $composableBuilder(
    column: $table.maxLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalLimitCategory => $composableBuilder(
    column: $table.legalLimitCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresCorrectiveActionOnFail => $composableBuilder(
    column: $table.requiresCorrectiveActionOnFail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fixInstructions => $composableBuilder(
    column: $table.fixInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskTemplatesTableFilterComposer get previousVersionId {
    final $$TaskTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousVersionId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTypesTableFilterComposer get equipmentTypeId {
    final $$EquipmentTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableFilterComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get createdByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableOrderingComposer({
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

  ColumnOrderings<int> get templateGroupId => $composableBuilder(
    column: $table.templateGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicableRoleTiers => $composableBuilder(
    column: $table.applicableRoleTiers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresPhoto => $composableBuilder(
    column: $table.requiresPhoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresNotes => $composableBuilder(
    column: $table.requiresNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minLimit => $composableBuilder(
    column: $table.minLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxLimit => $composableBuilder(
    column: $table.maxLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalLimitCategory => $composableBuilder(
    column: $table.legalLimitCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresCorrectiveActionOnFail =>
      $composableBuilder(
        column: $table.requiresCorrectiveActionOnFail,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get fixInstructions => $composableBuilder(
    column: $table.fixInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskTemplatesTableOrderingComposer get previousVersionId {
    final $$TaskTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousVersionId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTypesTableOrderingComposer get equipmentTypeId {
    final $$EquipmentTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableOrderingComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get createdByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateGroupId => $composableBuilder(
    column: $table.templateGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumn<String> get applicableRoleTiers => $composableBuilder(
    column: $table.applicableRoleTiers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<bool> get requiresPhoto => $composableBuilder(
    column: $table.requiresPhoto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresNotes => $composableBuilder(
    column: $table.requiresNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minLimit =>
      $composableBuilder(column: $table.minLimit, builder: (column) => column);

  GeneratedColumn<double> get maxLimit =>
      $composableBuilder(column: $table.maxLimit, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get legalLimitCategory => $composableBuilder(
    column: $table.legalLimitCategory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresCorrectiveActionOnFail =>
      $composableBuilder(
        column: $table.requiresCorrectiveActionOnFail,
        builder: (column) => column,
      );

  GeneratedColumn<String> get fixInstructions => $composableBuilder(
    column: $table.fixInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TaskTemplatesTableAnnotationComposer get previousVersionId {
    final $$TaskTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousVersionId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTypesTableAnnotationComposer get equipmentTypeId {
    final $$EquipmentTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get createdByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTemplatesTable,
          TaskTemplateEntity,
          $$TaskTemplatesTableFilterComposer,
          $$TaskTemplatesTableOrderingComposer,
          $$TaskTemplatesTableAnnotationComposer,
          $$TaskTemplatesTableCreateCompanionBuilder,
          $$TaskTemplatesTableUpdateCompanionBuilder,
          (TaskTemplateEntity, $$TaskTemplatesTableReferences),
          TaskTemplateEntity,
          PrefetchHooks Function({
            bool previousVersionId,
            bool equipmentTypeId,
            bool createdByUserId,
          })
        > {
  $$TaskTemplatesTableTableManager(_$AppDatabase db, $TaskTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateGroupId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<int?> previousVersionId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> segment = const Value.absent(),
                Value<String> applicableRoleTiers = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<bool> requiresPhoto = const Value.absent(),
                Value<bool> requiresNotes = const Value.absent(),
                Value<String?> customFieldsJson = const Value.absent(),
                Value<double?> minLimit = const Value.absent(),
                Value<double?> maxLimit = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> legalLimitCategory = const Value.absent(),
                Value<bool> isCritical = const Value.absent(),
                Value<bool> requiresCorrectiveActionOnFail =
                    const Value.absent(),
                Value<String?> fixInstructions = const Value.absent(),
                Value<int?> equipmentTypeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> createdByUserId = const Value.absent(),
              }) => TaskTemplatesCompanion(
                id: id,
                templateGroupId: templateGroupId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                title: title,
                segment: segment,
                applicableRoleTiers: applicableRoleTiers,
                method: method,
                requiresPhoto: requiresPhoto,
                requiresNotes: requiresNotes,
                customFieldsJson: customFieldsJson,
                minLimit: minLimit,
                maxLimit: maxLimit,
                unit: unit,
                legalLimitCategory: legalLimitCategory,
                isCritical: isCritical,
                requiresCorrectiveActionOnFail: requiresCorrectiveActionOnFail,
                fixInstructions: fixInstructions,
                equipmentTypeId: equipmentTypeId,
                createdAt: createdAt,
                createdByUserId: createdByUserId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateGroupId,
                required int versionNumber,
                Value<int?> previousVersionId = const Value.absent(),
                required String title,
                required String segment,
                required String applicableRoleTiers,
                required String method,
                Value<bool> requiresPhoto = const Value.absent(),
                Value<bool> requiresNotes = const Value.absent(),
                Value<String?> customFieldsJson = const Value.absent(),
                Value<double?> minLimit = const Value.absent(),
                Value<double?> maxLimit = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> legalLimitCategory = const Value.absent(),
                Value<bool> isCritical = const Value.absent(),
                Value<bool> requiresCorrectiveActionOnFail =
                    const Value.absent(),
                Value<String?> fixInstructions = const Value.absent(),
                Value<int?> equipmentTypeId = const Value.absent(),
                required DateTime createdAt,
                Value<int?> createdByUserId = const Value.absent(),
              }) => TaskTemplatesCompanion.insert(
                id: id,
                templateGroupId: templateGroupId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                title: title,
                segment: segment,
                applicableRoleTiers: applicableRoleTiers,
                method: method,
                requiresPhoto: requiresPhoto,
                requiresNotes: requiresNotes,
                customFieldsJson: customFieldsJson,
                minLimit: minLimit,
                maxLimit: maxLimit,
                unit: unit,
                legalLimitCategory: legalLimitCategory,
                isCritical: isCritical,
                requiresCorrectiveActionOnFail: requiresCorrectiveActionOnFail,
                fixInstructions: fixInstructions,
                equipmentTypeId: equipmentTypeId,
                createdAt: createdAt,
                createdByUserId: createdByUserId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                previousVersionId = false,
                equipmentTypeId = false,
                createdByUserId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (previousVersionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.previousVersionId,
                                    referencedTable:
                                        $$TaskTemplatesTableReferences
                                            ._previousVersionIdTable(db),
                                    referencedColumn:
                                        $$TaskTemplatesTableReferences
                                            ._previousVersionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (equipmentTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipmentTypeId,
                                    referencedTable:
                                        $$TaskTemplatesTableReferences
                                            ._equipmentTypeIdTable(db),
                                    referencedColumn:
                                        $$TaskTemplatesTableReferences
                                            ._equipmentTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (createdByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdByUserId,
                                    referencedTable:
                                        $$TaskTemplatesTableReferences
                                            ._createdByUserIdTable(db),
                                    referencedColumn:
                                        $$TaskTemplatesTableReferences
                                            ._createdByUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TaskTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTemplatesTable,
      TaskTemplateEntity,
      $$TaskTemplatesTableFilterComposer,
      $$TaskTemplatesTableOrderingComposer,
      $$TaskTemplatesTableAnnotationComposer,
      $$TaskTemplatesTableCreateCompanionBuilder,
      $$TaskTemplatesTableUpdateCompanionBuilder,
      (TaskTemplateEntity, $$TaskTemplatesTableReferences),
      TaskTemplateEntity,
      PrefetchHooks Function({
        bool previousVersionId,
        bool equipmentTypeId,
        bool createdByUserId,
      })
    >;
typedef $$AreasTableCreateCompanionBuilder =
    AreasCompanion Function({Value<int> id, required String name});
typedef $$AreasTableUpdateCompanionBuilder =
    AreasCompanion Function({Value<int> id, Value<String> name});

final class $$AreasTableReferences
    extends BaseReferences<_$AppDatabase, $AreasTable, AreaEntity> {
  $$AreasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $EquipmentInstancesTable,
    List<EquipmentInstanceEntity>
  >
  _equipmentInstancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.equipmentInstances,
        aliasName: 'areas__id__equipment_instances__area_id',
      );

  $$EquipmentInstancesTableProcessedTableManager get equipmentInstancesRefs {
    final manager = $$EquipmentInstancesTableTableManager(
      $_db,
      $_db.equipmentInstances,
    ).filter((f) => f.areaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _equipmentInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AreasTableFilterComposer extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> equipmentInstancesRefs(
    Expression<bool> Function($$EquipmentInstancesTableFilterComposer f) f,
  ) {
    final $$EquipmentInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipmentInstances,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentInstancesTableFilterComposer(
            $db: $db,
            $table: $db.equipmentInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AreasTableOrderingComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AreasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> equipmentInstancesRefs<T extends Object>(
    Expression<T> Function($$EquipmentInstancesTableAnnotationComposer a) f,
  ) {
    final $$EquipmentInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.equipmentInstances,
          getReferencedColumn: (t) => t.areaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EquipmentInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.equipmentInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AreasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AreasTable,
          AreaEntity,
          $$AreasTableFilterComposer,
          $$AreasTableOrderingComposer,
          $$AreasTableAnnotationComposer,
          $$AreasTableCreateCompanionBuilder,
          $$AreasTableUpdateCompanionBuilder,
          (AreaEntity, $$AreasTableReferences),
          AreaEntity,
          PrefetchHooks Function({bool equipmentInstancesRefs})
        > {
  $$AreasTableTableManager(_$AppDatabase db, $AreasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AreasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AreasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AreasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => AreasCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  AreasCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AreasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({equipmentInstancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (equipmentInstancesRefs) db.equipmentInstances,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (equipmentInstancesRefs)
                    await $_getPrefetchedData<
                      AreaEntity,
                      $AreasTable,
                      EquipmentInstanceEntity
                    >(
                      currentTable: table,
                      referencedTable: $$AreasTableReferences
                          ._equipmentInstancesRefsTable(db),
                      managerFromTypedResult: (p0) => $$AreasTableReferences(
                        db,
                        table,
                        p0,
                      ).equipmentInstancesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.areaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AreasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AreasTable,
      AreaEntity,
      $$AreasTableFilterComposer,
      $$AreasTableOrderingComposer,
      $$AreasTableAnnotationComposer,
      $$AreasTableCreateCompanionBuilder,
      $$AreasTableUpdateCompanionBuilder,
      (AreaEntity, $$AreasTableReferences),
      AreaEntity,
      PrefetchHooks Function({bool equipmentInstancesRefs})
    >;
typedef $$EquipmentInstancesTableCreateCompanionBuilder =
    EquipmentInstancesCompanion Function({
      Value<int> id,
      required String name,
      required int equipmentTypeId,
      Value<int?> areaId,
    });
typedef $$EquipmentInstancesTableUpdateCompanionBuilder =
    EquipmentInstancesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> equipmentTypeId,
      Value<int?> areaId,
    });

final class $$EquipmentInstancesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EquipmentInstancesTable,
          EquipmentInstanceEntity
        > {
  $$EquipmentInstancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EquipmentTypesTable _equipmentTypeIdTable(_$AppDatabase db) =>
      db.equipmentTypes.createAlias(
        'equipment_instances__equipment_type_id__equipment_types__id',
      );

  $$EquipmentTypesTableProcessedTableManager get equipmentTypeId {
    final $_column = $_itemColumn<int>('equipment_type_id')!;

    final manager = $$EquipmentTypesTableTableManager(
      $_db,
      $_db.equipmentTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AreasTable _areaIdTable(_$AppDatabase db) =>
      db.areas.createAlias('equipment_instances__area_id__areas__id');

  $$AreasTableProcessedTableManager? get areaId {
    final $_column = $_itemColumn<int>('area_id');
    if ($_column == null) return null;
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_areaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskSchedulesTable, List<TaskScheduleEntity>>
  _taskSchedulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskSchedules,
    aliasName: 'equipment_instances__id__task_schedules__equipment_instance_id',
  );

  $$TaskSchedulesTableProcessedTableManager get taskSchedulesRefs {
    final manager = $$TaskSchedulesTableTableManager($_db, $_db.taskSchedules)
        .filter(
          (f) => f.equipmentInstanceId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_taskSchedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentInstancesTable> {
  $$EquipmentInstancesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$EquipmentTypesTableFilterComposer get equipmentTypeId {
    final $$EquipmentTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableFilterComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableFilterComposer get areaId {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableFilterComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskSchedulesRefs(
    Expression<bool> Function($$TaskSchedulesTableFilterComposer f) f,
  ) {
    final $$TaskSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSchedules,
      getReferencedColumn: (t) => t.equipmentInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.taskSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentInstancesTable> {
  $$EquipmentInstancesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$EquipmentTypesTableOrderingComposer get equipmentTypeId {
    final $$EquipmentTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableOrderingComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableOrderingComposer get areaId {
    final $$AreasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableOrderingComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquipmentInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentInstancesTable> {
  $$EquipmentInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$EquipmentTypesTableAnnotationComposer get equipmentTypeId {
    final $$EquipmentTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentTypeId,
      referencedTable: $db.equipmentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.equipmentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableAnnotationComposer get areaId {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableAnnotationComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskSchedulesRefs<T extends Object>(
    Expression<T> Function($$TaskSchedulesTableAnnotationComposer a) f,
  ) {
    final $$TaskSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSchedules,
      getReferencedColumn: (t) => t.equipmentInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentInstancesTable,
          EquipmentInstanceEntity,
          $$EquipmentInstancesTableFilterComposer,
          $$EquipmentInstancesTableOrderingComposer,
          $$EquipmentInstancesTableAnnotationComposer,
          $$EquipmentInstancesTableCreateCompanionBuilder,
          $$EquipmentInstancesTableUpdateCompanionBuilder,
          (EquipmentInstanceEntity, $$EquipmentInstancesTableReferences),
          EquipmentInstanceEntity,
          PrefetchHooks Function({
            bool equipmentTypeId,
            bool areaId,
            bool taskSchedulesRefs,
          })
        > {
  $$EquipmentInstancesTableTableManager(
    _$AppDatabase db,
    $EquipmentInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentInstancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> equipmentTypeId = const Value.absent(),
                Value<int?> areaId = const Value.absent(),
              }) => EquipmentInstancesCompanion(
                id: id,
                name: name,
                equipmentTypeId: equipmentTypeId,
                areaId: areaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int equipmentTypeId,
                Value<int?> areaId = const Value.absent(),
              }) => EquipmentInstancesCompanion.insert(
                id: id,
                name: name,
                equipmentTypeId: equipmentTypeId,
                areaId: areaId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipmentInstancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                equipmentTypeId = false,
                areaId = false,
                taskSchedulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskSchedulesRefs) db.taskSchedules,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (equipmentTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipmentTypeId,
                                    referencedTable:
                                        $$EquipmentInstancesTableReferences
                                            ._equipmentTypeIdTable(db),
                                    referencedColumn:
                                        $$EquipmentInstancesTableReferences
                                            ._equipmentTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (areaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.areaId,
                                    referencedTable:
                                        $$EquipmentInstancesTableReferences
                                            ._areaIdTable(db),
                                    referencedColumn:
                                        $$EquipmentInstancesTableReferences
                                            ._areaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskSchedulesRefs)
                        await $_getPrefetchedData<
                          EquipmentInstanceEntity,
                          $EquipmentInstancesTable,
                          TaskScheduleEntity
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentInstancesTableReferences
                              ._taskSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentInstancesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentInstanceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquipmentInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentInstancesTable,
      EquipmentInstanceEntity,
      $$EquipmentInstancesTableFilterComposer,
      $$EquipmentInstancesTableOrderingComposer,
      $$EquipmentInstancesTableAnnotationComposer,
      $$EquipmentInstancesTableCreateCompanionBuilder,
      $$EquipmentInstancesTableUpdateCompanionBuilder,
      (EquipmentInstanceEntity, $$EquipmentInstancesTableReferences),
      EquipmentInstanceEntity,
      PrefetchHooks Function({
        bool equipmentTypeId,
        bool areaId,
        bool taskSchedulesRefs,
      })
    >;
typedef $$TaskSchedulesTableCreateCompanionBuilder =
    TaskSchedulesCompanion Function({
      Value<int> id,
      required int taskTemplateGroupId,
      required int assignedUserId,
      Value<int?> equipmentInstanceId,
      required String frequency,
      Value<String?> customFrequencyDetail,
      required int assignedByUserId,
      required DateTime assignedAt,
      Value<bool> active,
    });
typedef $$TaskSchedulesTableUpdateCompanionBuilder =
    TaskSchedulesCompanion Function({
      Value<int> id,
      Value<int> taskTemplateGroupId,
      Value<int> assignedUserId,
      Value<int?> equipmentInstanceId,
      Value<String> frequency,
      Value<String?> customFrequencyDetail,
      Value<int> assignedByUserId,
      Value<DateTime> assignedAt,
      Value<bool> active,
    });

final class $$TaskSchedulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskSchedulesTable, TaskScheduleEntity> {
  $$TaskSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _assignedUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('task_schedules__assigned_user_id__users__id');

  $$UsersTableProcessedTableManager get assignedUserId {
    final $_column = $_itemColumn<int>('assigned_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assignedUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentInstancesTable _equipmentInstanceIdTable(_$AppDatabase db) =>
      db.equipmentInstances.createAlias(
        'task_schedules__equipment_instance_id__equipment_instances__id',
      );

  $$EquipmentInstancesTableProcessedTableManager? get equipmentInstanceId {
    final $_column = $_itemColumn<int>('equipment_instance_id');
    if ($_column == null) return null;
    final manager = $$EquipmentInstancesTableTableManager(
      $_db,
      $_db.equipmentInstances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentInstanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _assignedByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('task_schedules__assigned_by_user_id__users__id');

  $$UsersTableProcessedTableManager get assignedByUserId {
    final $_column = $_itemColumn<int>('assigned_by_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assignedByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskSchedulesTable> {
  $$TaskSchedulesTableFilterComposer({
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

  ColumnFilters<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFrequencyDetail => $composableBuilder(
    column: $table.customFrequencyDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get assignedUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentInstancesTableFilterComposer get equipmentInstanceId {
    final $$EquipmentInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentInstanceId,
      referencedTable: $db.equipmentInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentInstancesTableFilterComposer(
            $db: $db,
            $table: $db.equipmentInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get assignedByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskSchedulesTable> {
  $$TaskSchedulesTableOrderingComposer({
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

  ColumnOrderings<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFrequencyDetail => $composableBuilder(
    column: $table.customFrequencyDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get assignedUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentInstancesTableOrderingComposer get equipmentInstanceId {
    final $$EquipmentInstancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentInstanceId,
      referencedTable: $db.equipmentInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentInstancesTableOrderingComposer(
            $db: $db,
            $table: $db.equipmentInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get assignedByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskSchedulesTable> {
  $$TaskSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get customFrequencyDetail => $composableBuilder(
    column: $table.customFrequencyDetail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$UsersTableAnnotationComposer get assignedUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentInstancesTableAnnotationComposer get equipmentInstanceId {
    final $$EquipmentInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.equipmentInstanceId,
          referencedTable: $db.equipmentInstances,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EquipmentInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.equipmentInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$UsersTableAnnotationComposer get assignedByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskSchedulesTable,
          TaskScheduleEntity,
          $$TaskSchedulesTableFilterComposer,
          $$TaskSchedulesTableOrderingComposer,
          $$TaskSchedulesTableAnnotationComposer,
          $$TaskSchedulesTableCreateCompanionBuilder,
          $$TaskSchedulesTableUpdateCompanionBuilder,
          (TaskScheduleEntity, $$TaskSchedulesTableReferences),
          TaskScheduleEntity,
          PrefetchHooks Function({
            bool assignedUserId,
            bool equipmentInstanceId,
            bool assignedByUserId,
          })
        > {
  $$TaskSchedulesTableTableManager(_$AppDatabase db, $TaskSchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskTemplateGroupId = const Value.absent(),
                Value<int> assignedUserId = const Value.absent(),
                Value<int?> equipmentInstanceId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> customFrequencyDetail = const Value.absent(),
                Value<int> assignedByUserId = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => TaskSchedulesCompanion(
                id: id,
                taskTemplateGroupId: taskTemplateGroupId,
                assignedUserId: assignedUserId,
                equipmentInstanceId: equipmentInstanceId,
                frequency: frequency,
                customFrequencyDetail: customFrequencyDetail,
                assignedByUserId: assignedByUserId,
                assignedAt: assignedAt,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskTemplateGroupId,
                required int assignedUserId,
                Value<int?> equipmentInstanceId = const Value.absent(),
                required String frequency,
                Value<String?> customFrequencyDetail = const Value.absent(),
                required int assignedByUserId,
                required DateTime assignedAt,
                Value<bool> active = const Value.absent(),
              }) => TaskSchedulesCompanion.insert(
                id: id,
                taskTemplateGroupId: taskTemplateGroupId,
                assignedUserId: assignedUserId,
                equipmentInstanceId: equipmentInstanceId,
                frequency: frequency,
                customFrequencyDetail: customFrequencyDetail,
                assignedByUserId: assignedByUserId,
                assignedAt: assignedAt,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                assignedUserId = false,
                equipmentInstanceId = false,
                assignedByUserId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (assignedUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedUserId,
                                    referencedTable:
                                        $$TaskSchedulesTableReferences
                                            ._assignedUserIdTable(db),
                                    referencedColumn:
                                        $$TaskSchedulesTableReferences
                                            ._assignedUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (equipmentInstanceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipmentInstanceId,
                                    referencedTable:
                                        $$TaskSchedulesTableReferences
                                            ._equipmentInstanceIdTable(db),
                                    referencedColumn:
                                        $$TaskSchedulesTableReferences
                                            ._equipmentInstanceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (assignedByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedByUserId,
                                    referencedTable:
                                        $$TaskSchedulesTableReferences
                                            ._assignedByUserIdTable(db),
                                    referencedColumn:
                                        $$TaskSchedulesTableReferences
                                            ._assignedByUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TaskSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskSchedulesTable,
      TaskScheduleEntity,
      $$TaskSchedulesTableFilterComposer,
      $$TaskSchedulesTableOrderingComposer,
      $$TaskSchedulesTableAnnotationComposer,
      $$TaskSchedulesTableCreateCompanionBuilder,
      $$TaskSchedulesTableUpdateCompanionBuilder,
      (TaskScheduleEntity, $$TaskSchedulesTableReferences),
      TaskScheduleEntity,
      PrefetchHooks Function({
        bool assignedUserId,
        bool equipmentInstanceId,
        bool assignedByUserId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskSubmissionsTableTableManager get taskSubmissions =>
      $$TaskSubmissionsTableTableManager(_db, _db.taskSubmissions);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$EquipmentTypesTableTableManager get equipmentTypes =>
      $$EquipmentTypesTableTableManager(_db, _db.equipmentTypes);
  $$LegalLimitReferencesTableTableManager get legalLimitReferences =>
      $$LegalLimitReferencesTableTableManager(_db, _db.legalLimitReferences);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db, _db.taskTemplates);
  $$AreasTableTableManager get areas =>
      $$AreasTableTableManager(_db, _db.areas);
  $$EquipmentInstancesTableTableManager get equipmentInstances =>
      $$EquipmentInstancesTableTableManager(_db, _db.equipmentInstances);
  $$TaskSchedulesTableTableManager get taskSchedules =>
      $$TaskSchedulesTableTableManager(_db, _db.taskSchedules);
}
