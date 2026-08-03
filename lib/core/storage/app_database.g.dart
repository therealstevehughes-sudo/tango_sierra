// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
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

class $OrganisationsTable extends Organisations
    with TableInfo<$OrganisationsTable, OrganisationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganisationsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organisations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganisationEntity> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganisationEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganisationEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OrganisationsTable createAlias(String alias) {
    return $OrganisationsTable(attachedDatabase, alias);
  }
}

class OrganisationEntity extends DataClass
    implements Insertable<OrganisationEntity> {
  final int id;
  final String name;
  final DateTime createdAt;
  const OrganisationEntity({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrganisationsCompanion toCompanion(bool nullToAbsent) {
    return OrganisationsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory OrganisationEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganisationEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrganisationEntity copyWith({int? id, String? name, DateTime? createdAt}) =>
      OrganisationEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  OrganisationEntity copyWithCompanion(OrganisationsCompanion data) {
    return OrganisationEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganisationEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganisationEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class OrganisationsCompanion extends UpdateCompanion<OrganisationEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const OrganisationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrganisationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<OrganisationEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrganisationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return OrganisationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganisationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SitesTable extends Sites with TableInfo<$SitesTable, SiteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organisations (id)',
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organisationId,
    name,
    address,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiteEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SiteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }
}

class SiteEntity extends DataClass implements Insertable<SiteEntity> {
  final int id;
  final int organisationId;
  final String name;
  final String? address;
  final DateTime createdAt;
  const SiteEntity({
    required this.id,
    required this.organisationId,
    required this.name,
    this.address,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory SiteEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteEntity(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SiteEntity copyWith({
    int? id,
    int? organisationId,
    String? name,
    Value<String?> address = const Value.absent(),
    DateTime? createdAt,
  }) => SiteEntity(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    createdAt: createdAt ?? this.createdAt,
  );
  SiteEntity copyWithCompanion(SitesCompanion data) {
    return SiteEntity(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiteEntity(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, organisationId, name, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteEntity &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.name == this.name &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class SitesCompanion extends UpdateCompanion<SiteEntity> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<String> name;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SitesCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    required String name,
    this.address = const Value.absent(),
    required DateTime createdAt,
  }) : organisationId = Value(organisationId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<SiteEntity> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<String>? name,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SitesCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<String>? name,
    Value<String?>? address,
    Value<DateTime>? createdAt,
  }) {
    return SitesCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, siteId];
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
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
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
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
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
  final int? siteId;
  const AreaEntity({required this.id, required this.name, this.siteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    return map;
  }

  AreasCompanion toCompanion(bool nullToAbsent) {
    return AreasCompanion(
      id: Value(id),
      name: Value(name),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
    );
  }

  factory AreaEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AreaEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      siteId: serializer.fromJson<int?>(json['siteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'siteId': serializer.toJson<int?>(siteId),
    };
  }

  AreaEntity copyWith({
    int? id,
    String? name,
    Value<int?> siteId = const Value.absent(),
  }) => AreaEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    siteId: siteId.present ? siteId.value : this.siteId,
  );
  AreaEntity copyWithCompanion(AreasCompanion data) {
    return AreaEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AreaEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, siteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AreaEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.siteId == this.siteId);
}

class AreasCompanion extends UpdateCompanion<AreaEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> siteId;
  const AreasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.siteId = const Value.absent(),
  });
  AreasCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.siteId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AreaEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? siteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (siteId != null) 'site_id': siteId,
    });
  }

  AreasCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? siteId,
  }) {
    return AreasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      siteId: siteId ?? this.siteId,
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
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('siteId: $siteId')
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
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
    name,
    equipmentTypeId,
    areaId,
    siteId,
    active,
  ];
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
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
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
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
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
  final int? siteId;
  final bool active;
  const EquipmentInstanceEntity({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
    this.areaId,
    this.siteId,
    required this.active,
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
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    map['active'] = Variable<bool>(active);
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
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
      active: Value(active),
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
      siteId: serializer.fromJson<int?>(json['siteId']),
      active: serializer.fromJson<bool>(json['active']),
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
      'siteId': serializer.toJson<int?>(siteId),
      'active': serializer.toJson<bool>(active),
    };
  }

  EquipmentInstanceEntity copyWith({
    int? id,
    String? name,
    int? equipmentTypeId,
    Value<int?> areaId = const Value.absent(),
    Value<int?> siteId = const Value.absent(),
    bool? active,
  }) => EquipmentInstanceEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
    areaId: areaId.present ? areaId.value : this.areaId,
    siteId: siteId.present ? siteId.value : this.siteId,
    active: active ?? this.active,
  );
  EquipmentInstanceEntity copyWithCompanion(EquipmentInstancesCompanion data) {
    return EquipmentInstanceEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      equipmentTypeId: data.equipmentTypeId.present
          ? data.equipmentTypeId.value
          : this.equipmentTypeId,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInstanceEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('areaId: $areaId, ')
          ..write('siteId: $siteId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, equipmentTypeId, areaId, siteId, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentInstanceEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.equipmentTypeId == this.equipmentTypeId &&
          other.areaId == this.areaId &&
          other.siteId == this.siteId &&
          other.active == this.active);
}

class EquipmentInstancesCompanion
    extends UpdateCompanion<EquipmentInstanceEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> equipmentTypeId;
  final Value<int?> areaId;
  final Value<int?> siteId;
  final Value<bool> active;
  const EquipmentInstancesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.equipmentTypeId = const Value.absent(),
    this.areaId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.active = const Value.absent(),
  });
  EquipmentInstancesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int equipmentTypeId,
    this.areaId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.active = const Value.absent(),
  }) : name = Value(name),
       equipmentTypeId = Value(equipmentTypeId);
  static Insertable<EquipmentInstanceEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? equipmentTypeId,
    Expression<int>? areaId,
    Expression<int>? siteId,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (equipmentTypeId != null) 'equipment_type_id': equipmentTypeId,
      if (areaId != null) 'area_id': areaId,
      if (siteId != null) 'site_id': siteId,
      if (active != null) 'active': active,
    });
  }

  EquipmentInstancesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? equipmentTypeId,
    Value<int?>? areaId,
    Value<int?>? siteId,
    Value<bool>? active,
  }) {
    return EquipmentInstancesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
      areaId: areaId ?? this.areaId,
      siteId: siteId ?? this.siteId,
      active: active ?? this.active,
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
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentInstancesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('equipmentTypeId: $equipmentTypeId, ')
          ..write('areaId: $areaId, ')
          ..write('siteId: $siteId, ')
          ..write('active: $active')
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
  static const VerificationMeta _preferredTemperatureUnitMeta =
      const VerificationMeta('preferredTemperatureUnit');
  @override
  late final GeneratedColumn<String> preferredTemperatureUnit =
      GeneratedColumn<String>(
        'preferred_temperature_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('celsius'),
      );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
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
  static const VerificationMeta _deactivatedAtMeta = const VerificationMeta(
    'deactivatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deactivatedAt =
      GeneratedColumn<DateTime>(
        'deactivated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deactivatedByUserIdMeta =
      const VerificationMeta('deactivatedByUserId');
  @override
  late final GeneratedColumn<int> deactivatedByUserId = GeneratedColumn<int>(
    'deactivated_by_user_id',
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
    name,
    jobTitle,
    roleTier,
    pinHash,
    pinSalt,
    preferredTemperatureUnit,
    siteId,
    active,
    deactivatedAt,
    deactivatedByUserId,
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
    if (data.containsKey('preferred_temperature_unit')) {
      context.handle(
        _preferredTemperatureUnitMeta,
        preferredTemperatureUnit.isAcceptableOrUnknown(
          data['preferred_temperature_unit']!,
          _preferredTemperatureUnitMeta,
        ),
      );
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('deactivated_at')) {
      context.handle(
        _deactivatedAtMeta,
        deactivatedAt.isAcceptableOrUnknown(
          data['deactivated_at']!,
          _deactivatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deactivated_by_user_id')) {
      context.handle(
        _deactivatedByUserIdMeta,
        deactivatedByUserId.isAcceptableOrUnknown(
          data['deactivated_by_user_id']!,
          _deactivatedByUserIdMeta,
        ),
      );
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
      preferredTemperatureUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_temperature_unit'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      deactivatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deactivated_at'],
      ),
      deactivatedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deactivated_by_user_id'],
      ),
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
  final String preferredTemperatureUnit;
  final int? siteId;
  final bool active;
  final DateTime? deactivatedAt;
  final int? deactivatedByUserId;
  const UserEntity({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    required this.pinHash,
    required this.pinSalt,
    required this.preferredTemperatureUnit,
    this.siteId,
    required this.active,
    this.deactivatedAt,
    this.deactivatedByUserId,
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
    map['preferred_temperature_unit'] = Variable<String>(
      preferredTemperatureUnit,
    );
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || deactivatedAt != null) {
      map['deactivated_at'] = Variable<DateTime>(deactivatedAt);
    }
    if (!nullToAbsent || deactivatedByUserId != null) {
      map['deactivated_by_user_id'] = Variable<int>(deactivatedByUserId);
    }
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
      preferredTemperatureUnit: Value(preferredTemperatureUnit),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
      active: Value(active),
      deactivatedAt: deactivatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deactivatedAt),
      deactivatedByUserId: deactivatedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(deactivatedByUserId),
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
      preferredTemperatureUnit: serializer.fromJson<String>(
        json['preferredTemperatureUnit'],
      ),
      siteId: serializer.fromJson<int?>(json['siteId']),
      active: serializer.fromJson<bool>(json['active']),
      deactivatedAt: serializer.fromJson<DateTime?>(json['deactivatedAt']),
      deactivatedByUserId: serializer.fromJson<int?>(
        json['deactivatedByUserId'],
      ),
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
      'preferredTemperatureUnit': serializer.toJson<String>(
        preferredTemperatureUnit,
      ),
      'siteId': serializer.toJson<int?>(siteId),
      'active': serializer.toJson<bool>(active),
      'deactivatedAt': serializer.toJson<DateTime?>(deactivatedAt),
      'deactivatedByUserId': serializer.toJson<int?>(deactivatedByUserId),
    };
  }

  UserEntity copyWith({
    int? id,
    String? name,
    String? jobTitle,
    String? roleTier,
    String? pinHash,
    String? pinSalt,
    String? preferredTemperatureUnit,
    Value<int?> siteId = const Value.absent(),
    bool? active,
    Value<DateTime?> deactivatedAt = const Value.absent(),
    Value<int?> deactivatedByUserId = const Value.absent(),
  }) => UserEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    jobTitle: jobTitle ?? this.jobTitle,
    roleTier: roleTier ?? this.roleTier,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt ?? this.pinSalt,
    preferredTemperatureUnit:
        preferredTemperatureUnit ?? this.preferredTemperatureUnit,
    siteId: siteId.present ? siteId.value : this.siteId,
    active: active ?? this.active,
    deactivatedAt: deactivatedAt.present
        ? deactivatedAt.value
        : this.deactivatedAt,
    deactivatedByUserId: deactivatedByUserId.present
        ? deactivatedByUserId.value
        : this.deactivatedByUserId,
  );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      roleTier: data.roleTier.present ? data.roleTier.value : this.roleTier,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      preferredTemperatureUnit: data.preferredTemperatureUnit.present
          ? data.preferredTemperatureUnit.value
          : this.preferredTemperatureUnit,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      active: data.active.present ? data.active.value : this.active,
      deactivatedAt: data.deactivatedAt.present
          ? data.deactivatedAt.value
          : this.deactivatedAt,
      deactivatedByUserId: data.deactivatedByUserId.present
          ? data.deactivatedByUserId.value
          : this.deactivatedByUserId,
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
          ..write('pinSalt: $pinSalt, ')
          ..write('preferredTemperatureUnit: $preferredTemperatureUnit, ')
          ..write('siteId: $siteId, ')
          ..write('active: $active, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('deactivatedByUserId: $deactivatedByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    jobTitle,
    roleTier,
    pinHash,
    pinSalt,
    preferredTemperatureUnit,
    siteId,
    active,
    deactivatedAt,
    deactivatedByUserId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.jobTitle == this.jobTitle &&
          other.roleTier == this.roleTier &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.preferredTemperatureUnit == this.preferredTemperatureUnit &&
          other.siteId == this.siteId &&
          other.active == this.active &&
          other.deactivatedAt == this.deactivatedAt &&
          other.deactivatedByUserId == this.deactivatedByUserId);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> jobTitle;
  final Value<String> roleTier;
  final Value<String> pinHash;
  final Value<String> pinSalt;
  final Value<String> preferredTemperatureUnit;
  final Value<int?> siteId;
  final Value<bool> active;
  final Value<DateTime?> deactivatedAt;
  final Value<int?> deactivatedByUserId;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.roleTier = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.preferredTemperatureUnit = const Value.absent(),
    this.siteId = const Value.absent(),
    this.active = const Value.absent(),
    this.deactivatedAt = const Value.absent(),
    this.deactivatedByUserId = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String jobTitle,
    required String roleTier,
    required String pinHash,
    required String pinSalt,
    this.preferredTemperatureUnit = const Value.absent(),
    this.siteId = const Value.absent(),
    this.active = const Value.absent(),
    this.deactivatedAt = const Value.absent(),
    this.deactivatedByUserId = const Value.absent(),
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
    Expression<String>? preferredTemperatureUnit,
    Expression<int>? siteId,
    Expression<bool>? active,
    Expression<DateTime>? deactivatedAt,
    Expression<int>? deactivatedByUserId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (jobTitle != null) 'job_title': jobTitle,
      if (roleTier != null) 'role_tier': roleTier,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (preferredTemperatureUnit != null)
        'preferred_temperature_unit': preferredTemperatureUnit,
      if (siteId != null) 'site_id': siteId,
      if (active != null) 'active': active,
      if (deactivatedAt != null) 'deactivated_at': deactivatedAt,
      if (deactivatedByUserId != null)
        'deactivated_by_user_id': deactivatedByUserId,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? jobTitle,
    Value<String>? roleTier,
    Value<String>? pinHash,
    Value<String>? pinSalt,
    Value<String>? preferredTemperatureUnit,
    Value<int?>? siteId,
    Value<bool>? active,
    Value<DateTime?>? deactivatedAt,
    Value<int?>? deactivatedByUserId,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      roleTier: roleTier ?? this.roleTier,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      preferredTemperatureUnit:
          preferredTemperatureUnit ?? this.preferredTemperatureUnit,
      siteId: siteId ?? this.siteId,
      active: active ?? this.active,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
      deactivatedByUserId: deactivatedByUserId ?? this.deactivatedByUserId,
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
    if (preferredTemperatureUnit.present) {
      map['preferred_temperature_unit'] = Variable<String>(
        preferredTemperatureUnit.value,
      );
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (deactivatedAt.present) {
      map['deactivated_at'] = Variable<DateTime>(deactivatedAt.value);
    }
    if (deactivatedByUserId.present) {
      map['deactivated_by_user_id'] = Variable<int>(deactivatedByUserId.value);
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
          ..write('pinSalt: $pinSalt, ')
          ..write('preferredTemperatureUnit: $preferredTemperatureUnit, ')
          ..write('siteId: $siteId, ')
          ..write('active: $active, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('deactivatedByUserId: $deactivatedByUserId')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _taskScheduleIdMeta = const VerificationMeta(
    'taskScheduleId',
  );
  @override
  late final GeneratedColumn<int> taskScheduleId = GeneratedColumn<int>(
    'task_schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskTemplateGroupIdMeta =
      const VerificationMeta('taskTemplateGroupId');
  @override
  late final GeneratedColumn<int> taskTemplateGroupId = GeneratedColumn<int>(
    'task_template_group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _customFieldValuesJsonMeta =
      const VerificationMeta('customFieldValuesJson');
  @override
  late final GeneratedColumn<String> customFieldValuesJson =
      GeneratedColumn<String>(
        'custom_field_values_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedByUserIdMeta = const VerificationMeta(
    'completedByUserId',
  );
  @override
  late final GeneratedColumn<int> completedByUserId = GeneratedColumn<int>(
    'completed_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
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
    taskScheduleId,
    taskTemplateGroupId,
    equipmentInstanceId,
    customFieldValuesJson,
    completedByUserId,
    siteId,
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
    if (data.containsKey('task_schedule_id')) {
      context.handle(
        _taskScheduleIdMeta,
        taskScheduleId.isAcceptableOrUnknown(
          data['task_schedule_id']!,
          _taskScheduleIdMeta,
        ),
      );
    }
    if (data.containsKey('task_template_group_id')) {
      context.handle(
        _taskTemplateGroupIdMeta,
        taskTemplateGroupId.isAcceptableOrUnknown(
          data['task_template_group_id']!,
          _taskTemplateGroupIdMeta,
        ),
      );
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
    if (data.containsKey('custom_field_values_json')) {
      context.handle(
        _customFieldValuesJsonMeta,
        customFieldValuesJson.isAcceptableOrUnknown(
          data['custom_field_values_json']!,
          _customFieldValuesJsonMeta,
        ),
      );
    }
    if (data.containsKey('completed_by_user_id')) {
      context.handle(
        _completedByUserIdMeta,
        completedByUserId.isAcceptableOrUnknown(
          data['completed_by_user_id']!,
          _completedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
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
      taskScheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_schedule_id'],
      ),
      taskTemplateGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_template_group_id'],
      ),
      equipmentInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_instance_id'],
      ),
      customFieldValuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_field_values_json'],
      ),
      completedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_by_user_id'],
      ),
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
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
  final int? taskScheduleId;
  final int? taskTemplateGroupId;
  final int? equipmentInstanceId;
  final String? customFieldValuesJson;
  final int? completedByUserId;
  final int? siteId;
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
    this.taskScheduleId,
    this.taskTemplateGroupId,
    this.equipmentInstanceId,
    this.customFieldValuesJson,
    this.completedByUserId,
    this.siteId,
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
    if (!nullToAbsent || taskScheduleId != null) {
      map['task_schedule_id'] = Variable<int>(taskScheduleId);
    }
    if (!nullToAbsent || taskTemplateGroupId != null) {
      map['task_template_group_id'] = Variable<int>(taskTemplateGroupId);
    }
    if (!nullToAbsent || equipmentInstanceId != null) {
      map['equipment_instance_id'] = Variable<int>(equipmentInstanceId);
    }
    if (!nullToAbsent || customFieldValuesJson != null) {
      map['custom_field_values_json'] = Variable<String>(customFieldValuesJson);
    }
    if (!nullToAbsent || completedByUserId != null) {
      map['completed_by_user_id'] = Variable<int>(completedByUserId);
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
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
      taskScheduleId: taskScheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskScheduleId),
      taskTemplateGroupId: taskTemplateGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTemplateGroupId),
      equipmentInstanceId: equipmentInstanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentInstanceId),
      customFieldValuesJson: customFieldValuesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(customFieldValuesJson),
      completedByUserId: completedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedByUserId),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
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
      taskScheduleId: serializer.fromJson<int?>(json['taskScheduleId']),
      taskTemplateGroupId: serializer.fromJson<int?>(
        json['taskTemplateGroupId'],
      ),
      equipmentInstanceId: serializer.fromJson<int?>(
        json['equipmentInstanceId'],
      ),
      customFieldValuesJson: serializer.fromJson<String?>(
        json['customFieldValuesJson'],
      ),
      completedByUserId: serializer.fromJson<int?>(json['completedByUserId']),
      siteId: serializer.fromJson<int?>(json['siteId']),
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
      'taskScheduleId': serializer.toJson<int?>(taskScheduleId),
      'taskTemplateGroupId': serializer.toJson<int?>(taskTemplateGroupId),
      'equipmentInstanceId': serializer.toJson<int?>(equipmentInstanceId),
      'customFieldValuesJson': serializer.toJson<String?>(
        customFieldValuesJson,
      ),
      'completedByUserId': serializer.toJson<int?>(completedByUserId),
      'siteId': serializer.toJson<int?>(siteId),
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
    Value<int?> taskScheduleId = const Value.absent(),
    Value<int?> taskTemplateGroupId = const Value.absent(),
    Value<int?> equipmentInstanceId = const Value.absent(),
    Value<String?> customFieldValuesJson = const Value.absent(),
    Value<int?> completedByUserId = const Value.absent(),
    Value<int?> siteId = const Value.absent(),
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
    taskScheduleId: taskScheduleId.present
        ? taskScheduleId.value
        : this.taskScheduleId,
    taskTemplateGroupId: taskTemplateGroupId.present
        ? taskTemplateGroupId.value
        : this.taskTemplateGroupId,
    equipmentInstanceId: equipmentInstanceId.present
        ? equipmentInstanceId.value
        : this.equipmentInstanceId,
    customFieldValuesJson: customFieldValuesJson.present
        ? customFieldValuesJson.value
        : this.customFieldValuesJson,
    completedByUserId: completedByUserId.present
        ? completedByUserId.value
        : this.completedByUserId,
    siteId: siteId.present ? siteId.value : this.siteId,
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
      taskScheduleId: data.taskScheduleId.present
          ? data.taskScheduleId.value
          : this.taskScheduleId,
      taskTemplateGroupId: data.taskTemplateGroupId.present
          ? data.taskTemplateGroupId.value
          : this.taskTemplateGroupId,
      equipmentInstanceId: data.equipmentInstanceId.present
          ? data.equipmentInstanceId.value
          : this.equipmentInstanceId,
      customFieldValuesJson: data.customFieldValuesJson.present
          ? data.customFieldValuesJson.value
          : this.customFieldValuesJson,
      completedByUserId: data.completedByUserId.present
          ? data.completedByUserId.value
          : this.completedByUserId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
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
          ..write('notes: $notes, ')
          ..write('taskScheduleId: $taskScheduleId, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('equipmentInstanceId: $equipmentInstanceId, ')
          ..write('customFieldValuesJson: $customFieldValuesJson, ')
          ..write('completedByUserId: $completedByUserId, ')
          ..write('siteId: $siteId')
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
    taskScheduleId,
    taskTemplateGroupId,
    equipmentInstanceId,
    customFieldValuesJson,
    completedByUserId,
    siteId,
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
          other.notes == this.notes &&
          other.taskScheduleId == this.taskScheduleId &&
          other.taskTemplateGroupId == this.taskTemplateGroupId &&
          other.equipmentInstanceId == this.equipmentInstanceId &&
          other.customFieldValuesJson == this.customFieldValuesJson &&
          other.completedByUserId == this.completedByUserId &&
          other.siteId == this.siteId);
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
  final Value<int?> taskScheduleId;
  final Value<int?> taskTemplateGroupId;
  final Value<int?> equipmentInstanceId;
  final Value<String?> customFieldValuesJson;
  final Value<int?> completedByUserId;
  final Value<int?> siteId;
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
    this.taskScheduleId = const Value.absent(),
    this.taskTemplateGroupId = const Value.absent(),
    this.equipmentInstanceId = const Value.absent(),
    this.customFieldValuesJson = const Value.absent(),
    this.completedByUserId = const Value.absent(),
    this.siteId = const Value.absent(),
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
    this.taskScheduleId = const Value.absent(),
    this.taskTemplateGroupId = const Value.absent(),
    this.equipmentInstanceId = const Value.absent(),
    this.customFieldValuesJson = const Value.absent(),
    this.completedByUserId = const Value.absent(),
    this.siteId = const Value.absent(),
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
    Expression<int>? taskScheduleId,
    Expression<int>? taskTemplateGroupId,
    Expression<int>? equipmentInstanceId,
    Expression<String>? customFieldValuesJson,
    Expression<int>? completedByUserId,
    Expression<int>? siteId,
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
      if (taskScheduleId != null) 'task_schedule_id': taskScheduleId,
      if (taskTemplateGroupId != null)
        'task_template_group_id': taskTemplateGroupId,
      if (equipmentInstanceId != null)
        'equipment_instance_id': equipmentInstanceId,
      if (customFieldValuesJson != null)
        'custom_field_values_json': customFieldValuesJson,
      if (completedByUserId != null) 'completed_by_user_id': completedByUserId,
      if (siteId != null) 'site_id': siteId,
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
    Value<int?>? taskScheduleId,
    Value<int?>? taskTemplateGroupId,
    Value<int?>? equipmentInstanceId,
    Value<String?>? customFieldValuesJson,
    Value<int?>? completedByUserId,
    Value<int?>? siteId,
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
      taskScheduleId: taskScheduleId ?? this.taskScheduleId,
      taskTemplateGroupId: taskTemplateGroupId ?? this.taskTemplateGroupId,
      equipmentInstanceId: equipmentInstanceId ?? this.equipmentInstanceId,
      customFieldValuesJson:
          customFieldValuesJson ?? this.customFieldValuesJson,
      completedByUserId: completedByUserId ?? this.completedByUserId,
      siteId: siteId ?? this.siteId,
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
    if (taskScheduleId.present) {
      map['task_schedule_id'] = Variable<int>(taskScheduleId.value);
    }
    if (taskTemplateGroupId.present) {
      map['task_template_group_id'] = Variable<int>(taskTemplateGroupId.value);
    }
    if (equipmentInstanceId.present) {
      map['equipment_instance_id'] = Variable<int>(equipmentInstanceId.value);
    }
    if (customFieldValuesJson.present) {
      map['custom_field_values_json'] = Variable<String>(
        customFieldValuesJson.value,
      );
    }
    if (completedByUserId.present) {
      map['completed_by_user_id'] = Variable<int>(completedByUserId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
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
          ..write('notes: $notes, ')
          ..write('taskScheduleId: $taskScheduleId, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('equipmentInstanceId: $equipmentInstanceId, ')
          ..write('customFieldValuesJson: $customFieldValuesJson, ')
          ..write('completedByUserId: $completedByUserId, ')
          ..write('siteId: $siteId')
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
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    priority,
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
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
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
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
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
  final String? priority;
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
    this.priority,
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
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<String>(priority);
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
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
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
      priority: serializer.fromJson<String?>(json['priority']),
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
      'priority': serializer.toJson<String?>(priority),
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
    Value<String?> priority = const Value.absent(),
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
    priority: priority.present ? priority.value : this.priority,
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
      priority: data.priority.present ? data.priority.value : this.priority,
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
          ..write('createdByUserId: $createdByUserId, ')
          ..write('priority: $priority')
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
    priority,
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
          other.createdByUserId == this.createdByUserId &&
          other.priority == this.priority);
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
  final Value<String?> priority;
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
    this.priority = const Value.absent(),
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
    this.priority = const Value.absent(),
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
    Expression<String>? priority,
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
      if (priority != null) 'priority': priority,
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
    Value<String?>? priority,
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
      priority: priority ?? this.priority,
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
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
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
          ..write('createdByUserId: $createdByUserId, ')
          ..write('priority: $priority')
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
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
    siteId,
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
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
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
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
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
  final int? siteId;
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
    this.siteId,
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
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
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
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
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
      siteId: serializer.fromJson<int?>(json['siteId']),
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
      'siteId': serializer.toJson<int?>(siteId),
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
    Value<int?> siteId = const Value.absent(),
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
    siteId: siteId.present ? siteId.value : this.siteId,
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
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
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
          ..write('active: $active, ')
          ..write('siteId: $siteId')
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
    siteId,
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
          other.active == this.active &&
          other.siteId == this.siteId);
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
  final Value<int?> siteId;
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
    this.siteId = const Value.absent(),
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
    this.siteId = const Value.absent(),
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
    Expression<int>? siteId,
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
      if (siteId != null) 'site_id': siteId,
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
    Value<int?>? siteId,
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
      siteId: siteId ?? this.siteId,
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
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
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
          ..write('active: $active, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }
}

class $ShiftHandoverNotesTable extends ShiftHandoverNotes
    with TableInfo<$ShiftHandoverNotesTable, ShiftHandoverNoteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftHandoverNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _authorUserIdMeta = const VerificationMeta(
    'authorUserId',
  );
  @override
  late final GeneratedColumn<int> authorUserId = GeneratedColumn<int>(
    'author_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorUserId,
    note,
    createdAt,
    siteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_handover_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftHandoverNoteEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('author_user_id')) {
      context.handle(
        _authorUserIdMeta,
        authorUserId.isAcceptableOrUnknown(
          data['author_user_id']!,
          _authorUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUserIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftHandoverNoteEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftHandoverNoteEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      authorUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_user_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
    );
  }

  @override
  $ShiftHandoverNotesTable createAlias(String alias) {
    return $ShiftHandoverNotesTable(attachedDatabase, alias);
  }
}

class ShiftHandoverNoteEntity extends DataClass
    implements Insertable<ShiftHandoverNoteEntity> {
  final int id;
  final int authorUserId;
  final String note;
  final DateTime createdAt;
  final int? siteId;
  const ShiftHandoverNoteEntity({
    required this.id,
    required this.authorUserId,
    required this.note,
    required this.createdAt,
    this.siteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['author_user_id'] = Variable<int>(authorUserId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    return map;
  }

  ShiftHandoverNotesCompanion toCompanion(bool nullToAbsent) {
    return ShiftHandoverNotesCompanion(
      id: Value(id),
      authorUserId: Value(authorUserId),
      note: Value(note),
      createdAt: Value(createdAt),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
    );
  }

  factory ShiftHandoverNoteEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftHandoverNoteEntity(
      id: serializer.fromJson<int>(json['id']),
      authorUserId: serializer.fromJson<int>(json['authorUserId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      siteId: serializer.fromJson<int?>(json['siteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'authorUserId': serializer.toJson<int>(authorUserId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'siteId': serializer.toJson<int?>(siteId),
    };
  }

  ShiftHandoverNoteEntity copyWith({
    int? id,
    int? authorUserId,
    String? note,
    DateTime? createdAt,
    Value<int?> siteId = const Value.absent(),
  }) => ShiftHandoverNoteEntity(
    id: id ?? this.id,
    authorUserId: authorUserId ?? this.authorUserId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    siteId: siteId.present ? siteId.value : this.siteId,
  );
  ShiftHandoverNoteEntity copyWithCompanion(ShiftHandoverNotesCompanion data) {
    return ShiftHandoverNoteEntity(
      id: data.id.present ? data.id.value : this.id,
      authorUserId: data.authorUserId.present
          ? data.authorUserId.value
          : this.authorUserId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftHandoverNoteEntity(')
          ..write('id: $id, ')
          ..write('authorUserId: $authorUserId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, authorUserId, note, createdAt, siteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftHandoverNoteEntity &&
          other.id == this.id &&
          other.authorUserId == this.authorUserId &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.siteId == this.siteId);
}

class ShiftHandoverNotesCompanion
    extends UpdateCompanion<ShiftHandoverNoteEntity> {
  final Value<int> id;
  final Value<int> authorUserId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<int?> siteId;
  const ShiftHandoverNotesCompanion({
    this.id = const Value.absent(),
    this.authorUserId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.siteId = const Value.absent(),
  });
  ShiftHandoverNotesCompanion.insert({
    this.id = const Value.absent(),
    required int authorUserId,
    required String note,
    required DateTime createdAt,
    this.siteId = const Value.absent(),
  }) : authorUserId = Value(authorUserId),
       note = Value(note),
       createdAt = Value(createdAt);
  static Insertable<ShiftHandoverNoteEntity> custom({
    Expression<int>? id,
    Expression<int>? authorUserId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? siteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorUserId != null) 'author_user_id': authorUserId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (siteId != null) 'site_id': siteId,
    });
  }

  ShiftHandoverNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? authorUserId,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<int?>? siteId,
  }) {
    return ShiftHandoverNotesCompanion(
      id: id ?? this.id,
      authorUserId: authorUserId ?? this.authorUserId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      siteId: siteId ?? this.siteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (authorUserId.present) {
      map['author_user_id'] = Variable<int>(authorUserId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftHandoverNotesCompanion(')
          ..write('id: $id, ')
          ..write('authorUserId: $authorUserId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }
}

class $SessionSummariesTable extends SessionSummaries
    with TableInfo<$SessionSummariesTable, SessionSummaryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionSummariesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _staffUserIdMeta = const VerificationMeta(
    'staffUserId',
  );
  @override
  late final GeneratedColumn<int> staffUserId = GeneratedColumn<int>(
    'staff_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _staffNameMeta = const VerificationMeta(
    'staffName',
  );
  @override
  late final GeneratedColumn<String> staffName = GeneratedColumn<String>(
    'staff_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentToManagerIdMeta = const VerificationMeta(
    'sentToManagerId',
  );
  @override
  late final GeneratedColumn<int> sentToManagerId = GeneratedColumn<int>(
    'sent_to_manager_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _passCountMeta = const VerificationMeta(
    'passCount',
  );
  @override
  late final GeneratedColumn<int> passCount = GeneratedColumn<int>(
    'pass_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failCountMeta = const VerificationMeta(
    'failCount',
  );
  @override
  late final GeneratedColumn<int> failCount = GeneratedColumn<int>(
    'fail_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedTaskTitlesJsonMeta =
      const VerificationMeta('failedTaskTitlesJson');
  @override
  late final GeneratedColumn<String> failedTaskTitlesJson =
      GeneratedColumn<String>(
        'failed_task_titles_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acknowledgedMeta = const VerificationMeta(
    'acknowledged',
  );
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
    'acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acknowledged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _acknowledgedAtMeta = const VerificationMeta(
    'acknowledgedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>(
        'acknowledged_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    staffUserId,
    staffName,
    sentToManagerId,
    passCount,
    failCount,
    failedTaskTitlesJson,
    note,
    sentAt,
    acknowledged,
    acknowledgedAt,
    siteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionSummaryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_user_id')) {
      context.handle(
        _staffUserIdMeta,
        staffUserId.isAcceptableOrUnknown(
          data['staff_user_id']!,
          _staffUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_staffUserIdMeta);
    }
    if (data.containsKey('staff_name')) {
      context.handle(
        _staffNameMeta,
        staffName.isAcceptableOrUnknown(data['staff_name']!, _staffNameMeta),
      );
    } else if (isInserting) {
      context.missing(_staffNameMeta);
    }
    if (data.containsKey('sent_to_manager_id')) {
      context.handle(
        _sentToManagerIdMeta,
        sentToManagerId.isAcceptableOrUnknown(
          data['sent_to_manager_id']!,
          _sentToManagerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sentToManagerIdMeta);
    }
    if (data.containsKey('pass_count')) {
      context.handle(
        _passCountMeta,
        passCount.isAcceptableOrUnknown(data['pass_count']!, _passCountMeta),
      );
    } else if (isInserting) {
      context.missing(_passCountMeta);
    }
    if (data.containsKey('fail_count')) {
      context.handle(
        _failCountMeta,
        failCount.isAcceptableOrUnknown(data['fail_count']!, _failCountMeta),
      );
    } else if (isInserting) {
      context.missing(_failCountMeta);
    }
    if (data.containsKey('failed_task_titles_json')) {
      context.handle(
        _failedTaskTitlesJsonMeta,
        failedTaskTitlesJson.isAcceptableOrUnknown(
          data['failed_task_titles_json']!,
          _failedTaskTitlesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_failedTaskTitlesJsonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
        _acknowledgedMeta,
        acknowledged.isAcceptableOrUnknown(
          data['acknowledged']!,
          _acknowledgedMeta,
        ),
      );
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
        _acknowledgedAtMeta,
        acknowledgedAt.isAcceptableOrUnknown(
          data['acknowledged_at']!,
          _acknowledgedAtMeta,
        ),
      );
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionSummaryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionSummaryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      staffUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_user_id'],
      )!,
      staffName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_name'],
      )!,
      sentToManagerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sent_to_manager_id'],
      )!,
      passCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pass_count'],
      )!,
      failCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fail_count'],
      )!,
      failedTaskTitlesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failed_task_titles_json'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      acknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acknowledged'],
      )!,
      acknowledgedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acknowledged_at'],
      ),
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
    );
  }

  @override
  $SessionSummariesTable createAlias(String alias) {
    return $SessionSummariesTable(attachedDatabase, alias);
  }
}

class SessionSummaryEntity extends DataClass
    implements Insertable<SessionSummaryEntity> {
  final int id;
  final int staffUserId;
  final String staffName;
  final int sentToManagerId;
  final int passCount;
  final int failCount;
  final String failedTaskTitlesJson;
  final String? note;
  final DateTime sentAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;
  final int? siteId;
  const SessionSummaryEntity({
    required this.id,
    required this.staffUserId,
    required this.staffName,
    required this.sentToManagerId,
    required this.passCount,
    required this.failCount,
    required this.failedTaskTitlesJson,
    this.note,
    required this.sentAt,
    required this.acknowledged,
    this.acknowledgedAt,
    this.siteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_user_id'] = Variable<int>(staffUserId);
    map['staff_name'] = Variable<String>(staffName);
    map['sent_to_manager_id'] = Variable<int>(sentToManagerId);
    map['pass_count'] = Variable<int>(passCount);
    map['fail_count'] = Variable<int>(failCount);
    map['failed_task_titles_json'] = Variable<String>(failedTaskTitlesJson);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['acknowledged'] = Variable<bool>(acknowledged);
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    return map;
  }

  SessionSummariesCompanion toCompanion(bool nullToAbsent) {
    return SessionSummariesCompanion(
      id: Value(id),
      staffUserId: Value(staffUserId),
      staffName: Value(staffName),
      sentToManagerId: Value(sentToManagerId),
      passCount: Value(passCount),
      failCount: Value(failCount),
      failedTaskTitlesJson: Value(failedTaskTitlesJson),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      sentAt: Value(sentAt),
      acknowledged: Value(acknowledged),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
    );
  }

  factory SessionSummaryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionSummaryEntity(
      id: serializer.fromJson<int>(json['id']),
      staffUserId: serializer.fromJson<int>(json['staffUserId']),
      staffName: serializer.fromJson<String>(json['staffName']),
      sentToManagerId: serializer.fromJson<int>(json['sentToManagerId']),
      passCount: serializer.fromJson<int>(json['passCount']),
      failCount: serializer.fromJson<int>(json['failCount']),
      failedTaskTitlesJson: serializer.fromJson<String>(
        json['failedTaskTitlesJson'],
      ),
      note: serializer.fromJson<String?>(json['note']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
      siteId: serializer.fromJson<int?>(json['siteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffUserId': serializer.toJson<int>(staffUserId),
      'staffName': serializer.toJson<String>(staffName),
      'sentToManagerId': serializer.toJson<int>(sentToManagerId),
      'passCount': serializer.toJson<int>(passCount),
      'failCount': serializer.toJson<int>(failCount),
      'failedTaskTitlesJson': serializer.toJson<String>(failedTaskTitlesJson),
      'note': serializer.toJson<String?>(note),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'acknowledged': serializer.toJson<bool>(acknowledged),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
      'siteId': serializer.toJson<int?>(siteId),
    };
  }

  SessionSummaryEntity copyWith({
    int? id,
    int? staffUserId,
    String? staffName,
    int? sentToManagerId,
    int? passCount,
    int? failCount,
    String? failedTaskTitlesJson,
    Value<String?> note = const Value.absent(),
    DateTime? sentAt,
    bool? acknowledged,
    Value<DateTime?> acknowledgedAt = const Value.absent(),
    Value<int?> siteId = const Value.absent(),
  }) => SessionSummaryEntity(
    id: id ?? this.id,
    staffUserId: staffUserId ?? this.staffUserId,
    staffName: staffName ?? this.staffName,
    sentToManagerId: sentToManagerId ?? this.sentToManagerId,
    passCount: passCount ?? this.passCount,
    failCount: failCount ?? this.failCount,
    failedTaskTitlesJson: failedTaskTitlesJson ?? this.failedTaskTitlesJson,
    note: note.present ? note.value : this.note,
    sentAt: sentAt ?? this.sentAt,
    acknowledged: acknowledged ?? this.acknowledged,
    acknowledgedAt: acknowledgedAt.present
        ? acknowledgedAt.value
        : this.acknowledgedAt,
    siteId: siteId.present ? siteId.value : this.siteId,
  );
  SessionSummaryEntity copyWithCompanion(SessionSummariesCompanion data) {
    return SessionSummaryEntity(
      id: data.id.present ? data.id.value : this.id,
      staffUserId: data.staffUserId.present
          ? data.staffUserId.value
          : this.staffUserId,
      staffName: data.staffName.present ? data.staffName.value : this.staffName,
      sentToManagerId: data.sentToManagerId.present
          ? data.sentToManagerId.value
          : this.sentToManagerId,
      passCount: data.passCount.present ? data.passCount.value : this.passCount,
      failCount: data.failCount.present ? data.failCount.value : this.failCount,
      failedTaskTitlesJson: data.failedTaskTitlesJson.present
          ? data.failedTaskTitlesJson.value
          : this.failedTaskTitlesJson,
      note: data.note.present ? data.note.value : this.note,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionSummaryEntity(')
          ..write('id: $id, ')
          ..write('staffUserId: $staffUserId, ')
          ..write('staffName: $staffName, ')
          ..write('sentToManagerId: $sentToManagerId, ')
          ..write('passCount: $passCount, ')
          ..write('failCount: $failCount, ')
          ..write('failedTaskTitlesJson: $failedTaskTitlesJson, ')
          ..write('note: $note, ')
          ..write('sentAt: $sentAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    staffUserId,
    staffName,
    sentToManagerId,
    passCount,
    failCount,
    failedTaskTitlesJson,
    note,
    sentAt,
    acknowledged,
    acknowledgedAt,
    siteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionSummaryEntity &&
          other.id == this.id &&
          other.staffUserId == this.staffUserId &&
          other.staffName == this.staffName &&
          other.sentToManagerId == this.sentToManagerId &&
          other.passCount == this.passCount &&
          other.failCount == this.failCount &&
          other.failedTaskTitlesJson == this.failedTaskTitlesJson &&
          other.note == this.note &&
          other.sentAt == this.sentAt &&
          other.acknowledged == this.acknowledged &&
          other.acknowledgedAt == this.acknowledgedAt &&
          other.siteId == this.siteId);
}

class SessionSummariesCompanion extends UpdateCompanion<SessionSummaryEntity> {
  final Value<int> id;
  final Value<int> staffUserId;
  final Value<String> staffName;
  final Value<int> sentToManagerId;
  final Value<int> passCount;
  final Value<int> failCount;
  final Value<String> failedTaskTitlesJson;
  final Value<String?> note;
  final Value<DateTime> sentAt;
  final Value<bool> acknowledged;
  final Value<DateTime?> acknowledgedAt;
  final Value<int?> siteId;
  const SessionSummariesCompanion({
    this.id = const Value.absent(),
    this.staffUserId = const Value.absent(),
    this.staffName = const Value.absent(),
    this.sentToManagerId = const Value.absent(),
    this.passCount = const Value.absent(),
    this.failCount = const Value.absent(),
    this.failedTaskTitlesJson = const Value.absent(),
    this.note = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.siteId = const Value.absent(),
  });
  SessionSummariesCompanion.insert({
    this.id = const Value.absent(),
    required int staffUserId,
    required String staffName,
    required int sentToManagerId,
    required int passCount,
    required int failCount,
    required String failedTaskTitlesJson,
    this.note = const Value.absent(),
    required DateTime sentAt,
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.siteId = const Value.absent(),
  }) : staffUserId = Value(staffUserId),
       staffName = Value(staffName),
       sentToManagerId = Value(sentToManagerId),
       passCount = Value(passCount),
       failCount = Value(failCount),
       failedTaskTitlesJson = Value(failedTaskTitlesJson),
       sentAt = Value(sentAt);
  static Insertable<SessionSummaryEntity> custom({
    Expression<int>? id,
    Expression<int>? staffUserId,
    Expression<String>? staffName,
    Expression<int>? sentToManagerId,
    Expression<int>? passCount,
    Expression<int>? failCount,
    Expression<String>? failedTaskTitlesJson,
    Expression<String>? note,
    Expression<DateTime>? sentAt,
    Expression<bool>? acknowledged,
    Expression<DateTime>? acknowledgedAt,
    Expression<int>? siteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffUserId != null) 'staff_user_id': staffUserId,
      if (staffName != null) 'staff_name': staffName,
      if (sentToManagerId != null) 'sent_to_manager_id': sentToManagerId,
      if (passCount != null) 'pass_count': passCount,
      if (failCount != null) 'fail_count': failCount,
      if (failedTaskTitlesJson != null)
        'failed_task_titles_json': failedTaskTitlesJson,
      if (note != null) 'note': note,
      if (sentAt != null) 'sent_at': sentAt,
      if (acknowledged != null) 'acknowledged': acknowledged,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
      if (siteId != null) 'site_id': siteId,
    });
  }

  SessionSummariesCompanion copyWith({
    Value<int>? id,
    Value<int>? staffUserId,
    Value<String>? staffName,
    Value<int>? sentToManagerId,
    Value<int>? passCount,
    Value<int>? failCount,
    Value<String>? failedTaskTitlesJson,
    Value<String?>? note,
    Value<DateTime>? sentAt,
    Value<bool>? acknowledged,
    Value<DateTime?>? acknowledgedAt,
    Value<int?>? siteId,
  }) {
    return SessionSummariesCompanion(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      staffName: staffName ?? this.staffName,
      sentToManagerId: sentToManagerId ?? this.sentToManagerId,
      passCount: passCount ?? this.passCount,
      failCount: failCount ?? this.failCount,
      failedTaskTitlesJson: failedTaskTitlesJson ?? this.failedTaskTitlesJson,
      note: note ?? this.note,
      sentAt: sentAt ?? this.sentAt,
      acknowledged: acknowledged ?? this.acknowledged,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      siteId: siteId ?? this.siteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffUserId.present) {
      map['staff_user_id'] = Variable<int>(staffUserId.value);
    }
    if (staffName.present) {
      map['staff_name'] = Variable<String>(staffName.value);
    }
    if (sentToManagerId.present) {
      map['sent_to_manager_id'] = Variable<int>(sentToManagerId.value);
    }
    if (passCount.present) {
      map['pass_count'] = Variable<int>(passCount.value);
    }
    if (failCount.present) {
      map['fail_count'] = Variable<int>(failCount.value);
    }
    if (failedTaskTitlesJson.present) {
      map['failed_task_titles_json'] = Variable<String>(
        failedTaskTitlesJson.value,
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionSummariesCompanion(')
          ..write('id: $id, ')
          ..write('staffUserId: $staffUserId, ')
          ..write('staffName: $staffName, ')
          ..write('sentToManagerId: $sentToManagerId, ')
          ..write('passCount: $passCount, ')
          ..write('failCount: $failCount, ')
          ..write('failedTaskTitlesJson: $failedTaskTitlesJson, ')
          ..write('note: $note, ')
          ..write('sentAt: $sentAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }
}

class $NotificationRulesTable extends NotificationRules
    with TableInfo<$NotificationRulesTable, NotificationRuleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationRulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ruleGroupIdMeta = const VerificationMeta(
    'ruleGroupId',
  );
  @override
  late final GeneratedColumn<int> ruleGroupId = GeneratedColumn<int>(
    'rule_group_id',
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
      'REFERENCES notification_rules (id)',
    ),
  );
  static const VerificationMeta _taskTemplateGroupIdMeta =
      const VerificationMeta('taskTemplateGroupId');
  @override
  late final GeneratedColumn<int> taskTemplateGroupId = GeneratedColumn<int>(
    'task_template_group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRoleTierMeta = const VerificationMeta(
    'targetRoleTier',
  );
  @override
  late final GeneratedColumn<String> targetRoleTier = GeneratedColumn<String>(
    'target_role_tier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetUserIdMeta = const VerificationMeta(
    'targetUserId',
  );
  @override
  late final GeneratedColumn<int> targetUserId = GeneratedColumn<int>(
    'target_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _channelPushMeta = const VerificationMeta(
    'channelPush',
  );
  @override
  late final GeneratedColumn<bool> channelPush = GeneratedColumn<bool>(
    'channel_push',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("channel_push" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _channelEmailMeta = const VerificationMeta(
    'channelEmail',
  );
  @override
  late final GeneratedColumn<bool> channelEmail = GeneratedColumn<bool>(
    'channel_email',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("channel_email" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _setByUserIdMeta = const VerificationMeta(
    'setByUserId',
  );
  @override
  late final GeneratedColumn<int> setByUserId = GeneratedColumn<int>(
    'set_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _setByTierMeta = const VerificationMeta(
    'setByTier',
  );
  @override
  late final GeneratedColumn<String> setByTier = GeneratedColumn<String>(
    'set_by_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleGroupId,
    versionNumber,
    previousVersionId,
    taskTemplateGroupId,
    targetRoleTier,
    targetUserId,
    channelPush,
    channelEmail,
    setByUserId,
    setByTier,
    active,
    createdAt,
    siteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRuleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rule_group_id')) {
      context.handle(
        _ruleGroupIdMeta,
        ruleGroupId.isAcceptableOrUnknown(
          data['rule_group_id']!,
          _ruleGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ruleGroupIdMeta);
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
    if (data.containsKey('task_template_group_id')) {
      context.handle(
        _taskTemplateGroupIdMeta,
        taskTemplateGroupId.isAcceptableOrUnknown(
          data['task_template_group_id']!,
          _taskTemplateGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('target_role_tier')) {
      context.handle(
        _targetRoleTierMeta,
        targetRoleTier.isAcceptableOrUnknown(
          data['target_role_tier']!,
          _targetRoleTierMeta,
        ),
      );
    }
    if (data.containsKey('target_user_id')) {
      context.handle(
        _targetUserIdMeta,
        targetUserId.isAcceptableOrUnknown(
          data['target_user_id']!,
          _targetUserIdMeta,
        ),
      );
    }
    if (data.containsKey('channel_push')) {
      context.handle(
        _channelPushMeta,
        channelPush.isAcceptableOrUnknown(
          data['channel_push']!,
          _channelPushMeta,
        ),
      );
    }
    if (data.containsKey('channel_email')) {
      context.handle(
        _channelEmailMeta,
        channelEmail.isAcceptableOrUnknown(
          data['channel_email']!,
          _channelEmailMeta,
        ),
      );
    }
    if (data.containsKey('set_by_user_id')) {
      context.handle(
        _setByUserIdMeta,
        setByUserId.isAcceptableOrUnknown(
          data['set_by_user_id']!,
          _setByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_setByUserIdMeta);
    }
    if (data.containsKey('set_by_tier')) {
      context.handle(
        _setByTierMeta,
        setByTier.isAcceptableOrUnknown(data['set_by_tier']!, _setByTierMeta),
      );
    } else if (isInserting) {
      context.missing(_setByTierMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRuleEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRuleEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ruleGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rule_group_id'],
      )!,
      versionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_number'],
      )!,
      previousVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_version_id'],
      ),
      taskTemplateGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_template_group_id'],
      ),
      targetRoleTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_role_tier'],
      ),
      targetUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_user_id'],
      ),
      channelPush: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}channel_push'],
      )!,
      channelEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}channel_email'],
      )!,
      setByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_by_user_id'],
      )!,
      setByTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_by_tier'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
    );
  }

  @override
  $NotificationRulesTable createAlias(String alias) {
    return $NotificationRulesTable(attachedDatabase, alias);
  }
}

class NotificationRuleEntity extends DataClass
    implements Insertable<NotificationRuleEntity> {
  final int id;
  final int ruleGroupId;
  final int versionNumber;
  final int? previousVersionId;
  final int? taskTemplateGroupId;
  final String? targetRoleTier;
  final int? targetUserId;
  final bool channelPush;
  final bool channelEmail;
  final int setByUserId;
  final String setByTier;
  final bool active;
  final DateTime createdAt;
  final int? siteId;
  const NotificationRuleEntity({
    required this.id,
    required this.ruleGroupId,
    required this.versionNumber,
    this.previousVersionId,
    this.taskTemplateGroupId,
    this.targetRoleTier,
    this.targetUserId,
    required this.channelPush,
    required this.channelEmail,
    required this.setByUserId,
    required this.setByTier,
    required this.active,
    required this.createdAt,
    this.siteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rule_group_id'] = Variable<int>(ruleGroupId);
    map['version_number'] = Variable<int>(versionNumber);
    if (!nullToAbsent || previousVersionId != null) {
      map['previous_version_id'] = Variable<int>(previousVersionId);
    }
    if (!nullToAbsent || taskTemplateGroupId != null) {
      map['task_template_group_id'] = Variable<int>(taskTemplateGroupId);
    }
    if (!nullToAbsent || targetRoleTier != null) {
      map['target_role_tier'] = Variable<String>(targetRoleTier);
    }
    if (!nullToAbsent || targetUserId != null) {
      map['target_user_id'] = Variable<int>(targetUserId);
    }
    map['channel_push'] = Variable<bool>(channelPush);
    map['channel_email'] = Variable<bool>(channelEmail);
    map['set_by_user_id'] = Variable<int>(setByUserId);
    map['set_by_tier'] = Variable<String>(setByTier);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    return map;
  }

  NotificationRulesCompanion toCompanion(bool nullToAbsent) {
    return NotificationRulesCompanion(
      id: Value(id),
      ruleGroupId: Value(ruleGroupId),
      versionNumber: Value(versionNumber),
      previousVersionId: previousVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousVersionId),
      taskTemplateGroupId: taskTemplateGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTemplateGroupId),
      targetRoleTier: targetRoleTier == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRoleTier),
      targetUserId: targetUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetUserId),
      channelPush: Value(channelPush),
      channelEmail: Value(channelEmail),
      setByUserId: Value(setByUserId),
      setByTier: Value(setByTier),
      active: Value(active),
      createdAt: Value(createdAt),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
    );
  }

  factory NotificationRuleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRuleEntity(
      id: serializer.fromJson<int>(json['id']),
      ruleGroupId: serializer.fromJson<int>(json['ruleGroupId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      previousVersionId: serializer.fromJson<int?>(json['previousVersionId']),
      taskTemplateGroupId: serializer.fromJson<int?>(
        json['taskTemplateGroupId'],
      ),
      targetRoleTier: serializer.fromJson<String?>(json['targetRoleTier']),
      targetUserId: serializer.fromJson<int?>(json['targetUserId']),
      channelPush: serializer.fromJson<bool>(json['channelPush']),
      channelEmail: serializer.fromJson<bool>(json['channelEmail']),
      setByUserId: serializer.fromJson<int>(json['setByUserId']),
      setByTier: serializer.fromJson<String>(json['setByTier']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      siteId: serializer.fromJson<int?>(json['siteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ruleGroupId': serializer.toJson<int>(ruleGroupId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'previousVersionId': serializer.toJson<int?>(previousVersionId),
      'taskTemplateGroupId': serializer.toJson<int?>(taskTemplateGroupId),
      'targetRoleTier': serializer.toJson<String?>(targetRoleTier),
      'targetUserId': serializer.toJson<int?>(targetUserId),
      'channelPush': serializer.toJson<bool>(channelPush),
      'channelEmail': serializer.toJson<bool>(channelEmail),
      'setByUserId': serializer.toJson<int>(setByUserId),
      'setByTier': serializer.toJson<String>(setByTier),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'siteId': serializer.toJson<int?>(siteId),
    };
  }

  NotificationRuleEntity copyWith({
    int? id,
    int? ruleGroupId,
    int? versionNumber,
    Value<int?> previousVersionId = const Value.absent(),
    Value<int?> taskTemplateGroupId = const Value.absent(),
    Value<String?> targetRoleTier = const Value.absent(),
    Value<int?> targetUserId = const Value.absent(),
    bool? channelPush,
    bool? channelEmail,
    int? setByUserId,
    String? setByTier,
    bool? active,
    DateTime? createdAt,
    Value<int?> siteId = const Value.absent(),
  }) => NotificationRuleEntity(
    id: id ?? this.id,
    ruleGroupId: ruleGroupId ?? this.ruleGroupId,
    versionNumber: versionNumber ?? this.versionNumber,
    previousVersionId: previousVersionId.present
        ? previousVersionId.value
        : this.previousVersionId,
    taskTemplateGroupId: taskTemplateGroupId.present
        ? taskTemplateGroupId.value
        : this.taskTemplateGroupId,
    targetRoleTier: targetRoleTier.present
        ? targetRoleTier.value
        : this.targetRoleTier,
    targetUserId: targetUserId.present ? targetUserId.value : this.targetUserId,
    channelPush: channelPush ?? this.channelPush,
    channelEmail: channelEmail ?? this.channelEmail,
    setByUserId: setByUserId ?? this.setByUserId,
    setByTier: setByTier ?? this.setByTier,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    siteId: siteId.present ? siteId.value : this.siteId,
  );
  NotificationRuleEntity copyWithCompanion(NotificationRulesCompanion data) {
    return NotificationRuleEntity(
      id: data.id.present ? data.id.value : this.id,
      ruleGroupId: data.ruleGroupId.present
          ? data.ruleGroupId.value
          : this.ruleGroupId,
      versionNumber: data.versionNumber.present
          ? data.versionNumber.value
          : this.versionNumber,
      previousVersionId: data.previousVersionId.present
          ? data.previousVersionId.value
          : this.previousVersionId,
      taskTemplateGroupId: data.taskTemplateGroupId.present
          ? data.taskTemplateGroupId.value
          : this.taskTemplateGroupId,
      targetRoleTier: data.targetRoleTier.present
          ? data.targetRoleTier.value
          : this.targetRoleTier,
      targetUserId: data.targetUserId.present
          ? data.targetUserId.value
          : this.targetUserId,
      channelPush: data.channelPush.present
          ? data.channelPush.value
          : this.channelPush,
      channelEmail: data.channelEmail.present
          ? data.channelEmail.value
          : this.channelEmail,
      setByUserId: data.setByUserId.present
          ? data.setByUserId.value
          : this.setByUserId,
      setByTier: data.setByTier.present ? data.setByTier.value : this.setByTier,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRuleEntity(')
          ..write('id: $id, ')
          ..write('ruleGroupId: $ruleGroupId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('targetRoleTier: $targetRoleTier, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('channelPush: $channelPush, ')
          ..write('channelEmail: $channelEmail, ')
          ..write('setByUserId: $setByUserId, ')
          ..write('setByTier: $setByTier, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleGroupId,
    versionNumber,
    previousVersionId,
    taskTemplateGroupId,
    targetRoleTier,
    targetUserId,
    channelPush,
    channelEmail,
    setByUserId,
    setByTier,
    active,
    createdAt,
    siteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRuleEntity &&
          other.id == this.id &&
          other.ruleGroupId == this.ruleGroupId &&
          other.versionNumber == this.versionNumber &&
          other.previousVersionId == this.previousVersionId &&
          other.taskTemplateGroupId == this.taskTemplateGroupId &&
          other.targetRoleTier == this.targetRoleTier &&
          other.targetUserId == this.targetUserId &&
          other.channelPush == this.channelPush &&
          other.channelEmail == this.channelEmail &&
          other.setByUserId == this.setByUserId &&
          other.setByTier == this.setByTier &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.siteId == this.siteId);
}

class NotificationRulesCompanion
    extends UpdateCompanion<NotificationRuleEntity> {
  final Value<int> id;
  final Value<int> ruleGroupId;
  final Value<int> versionNumber;
  final Value<int?> previousVersionId;
  final Value<int?> taskTemplateGroupId;
  final Value<String?> targetRoleTier;
  final Value<int?> targetUserId;
  final Value<bool> channelPush;
  final Value<bool> channelEmail;
  final Value<int> setByUserId;
  final Value<String> setByTier;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<int?> siteId;
  const NotificationRulesCompanion({
    this.id = const Value.absent(),
    this.ruleGroupId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.previousVersionId = const Value.absent(),
    this.taskTemplateGroupId = const Value.absent(),
    this.targetRoleTier = const Value.absent(),
    this.targetUserId = const Value.absent(),
    this.channelPush = const Value.absent(),
    this.channelEmail = const Value.absent(),
    this.setByUserId = const Value.absent(),
    this.setByTier = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.siteId = const Value.absent(),
  });
  NotificationRulesCompanion.insert({
    this.id = const Value.absent(),
    required int ruleGroupId,
    required int versionNumber,
    this.previousVersionId = const Value.absent(),
    this.taskTemplateGroupId = const Value.absent(),
    this.targetRoleTier = const Value.absent(),
    this.targetUserId = const Value.absent(),
    this.channelPush = const Value.absent(),
    this.channelEmail = const Value.absent(),
    required int setByUserId,
    required String setByTier,
    this.active = const Value.absent(),
    required DateTime createdAt,
    this.siteId = const Value.absent(),
  }) : ruleGroupId = Value(ruleGroupId),
       versionNumber = Value(versionNumber),
       setByUserId = Value(setByUserId),
       setByTier = Value(setByTier),
       createdAt = Value(createdAt);
  static Insertable<NotificationRuleEntity> custom({
    Expression<int>? id,
    Expression<int>? ruleGroupId,
    Expression<int>? versionNumber,
    Expression<int>? previousVersionId,
    Expression<int>? taskTemplateGroupId,
    Expression<String>? targetRoleTier,
    Expression<int>? targetUserId,
    Expression<bool>? channelPush,
    Expression<bool>? channelEmail,
    Expression<int>? setByUserId,
    Expression<String>? setByTier,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<int>? siteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleGroupId != null) 'rule_group_id': ruleGroupId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (previousVersionId != null) 'previous_version_id': previousVersionId,
      if (taskTemplateGroupId != null)
        'task_template_group_id': taskTemplateGroupId,
      if (targetRoleTier != null) 'target_role_tier': targetRoleTier,
      if (targetUserId != null) 'target_user_id': targetUserId,
      if (channelPush != null) 'channel_push': channelPush,
      if (channelEmail != null) 'channel_email': channelEmail,
      if (setByUserId != null) 'set_by_user_id': setByUserId,
      if (setByTier != null) 'set_by_tier': setByTier,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (siteId != null) 'site_id': siteId,
    });
  }

  NotificationRulesCompanion copyWith({
    Value<int>? id,
    Value<int>? ruleGroupId,
    Value<int>? versionNumber,
    Value<int?>? previousVersionId,
    Value<int?>? taskTemplateGroupId,
    Value<String?>? targetRoleTier,
    Value<int?>? targetUserId,
    Value<bool>? channelPush,
    Value<bool>? channelEmail,
    Value<int>? setByUserId,
    Value<String>? setByTier,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<int?>? siteId,
  }) {
    return NotificationRulesCompanion(
      id: id ?? this.id,
      ruleGroupId: ruleGroupId ?? this.ruleGroupId,
      versionNumber: versionNumber ?? this.versionNumber,
      previousVersionId: previousVersionId ?? this.previousVersionId,
      taskTemplateGroupId: taskTemplateGroupId ?? this.taskTemplateGroupId,
      targetRoleTier: targetRoleTier ?? this.targetRoleTier,
      targetUserId: targetUserId ?? this.targetUserId,
      channelPush: channelPush ?? this.channelPush,
      channelEmail: channelEmail ?? this.channelEmail,
      setByUserId: setByUserId ?? this.setByUserId,
      setByTier: setByTier ?? this.setByTier,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      siteId: siteId ?? this.siteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ruleGroupId.present) {
      map['rule_group_id'] = Variable<int>(ruleGroupId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (previousVersionId.present) {
      map['previous_version_id'] = Variable<int>(previousVersionId.value);
    }
    if (taskTemplateGroupId.present) {
      map['task_template_group_id'] = Variable<int>(taskTemplateGroupId.value);
    }
    if (targetRoleTier.present) {
      map['target_role_tier'] = Variable<String>(targetRoleTier.value);
    }
    if (targetUserId.present) {
      map['target_user_id'] = Variable<int>(targetUserId.value);
    }
    if (channelPush.present) {
      map['channel_push'] = Variable<bool>(channelPush.value);
    }
    if (channelEmail.present) {
      map['channel_email'] = Variable<bool>(channelEmail.value);
    }
    if (setByUserId.present) {
      map['set_by_user_id'] = Variable<int>(setByUserId.value);
    }
    if (setByTier.present) {
      map['set_by_tier'] = Variable<String>(setByTier.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRulesCompanion(')
          ..write('id: $id, ')
          ..write('ruleGroupId: $ruleGroupId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('taskTemplateGroupId: $taskTemplateGroupId, ')
          ..write('targetRoleTier: $targetRoleTier, ')
          ..write('targetUserId: $targetUserId, ')
          ..write('channelPush: $channelPush, ')
          ..write('channelEmail: $channelEmail, ')
          ..write('setByUserId: $setByUserId, ')
          ..write('setByTier: $setByTier, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('siteId: $siteId')
          ..write(')'))
        .toString();
  }
}

class $TriggerNotificationsTable extends TriggerNotifications
    with TableInfo<$TriggerNotificationsTable, TriggerNotificationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriggerNotificationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _notificationRuleIdMeta =
      const VerificationMeta('notificationRuleId');
  @override
  late final GeneratedColumn<int> notificationRuleId = GeneratedColumn<int>(
    'notification_rule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notification_rules (id)',
    ),
  );
  static const VerificationMeta _taskSubmissionIdMeta = const VerificationMeta(
    'taskSubmissionId',
  );
  @override
  late final GeneratedColumn<int> taskSubmissionId = GeneratedColumn<int>(
    'task_submission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_submissions (id)',
    ),
  );
  static const VerificationMeta _recipientUserIdMeta = const VerificationMeta(
    'recipientUserId',
  );
  @override
  late final GeneratedColumn<int> recipientUserId = GeneratedColumn<int>(
    'recipient_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
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
  static const VerificationMeta _acknowledgedMeta = const VerificationMeta(
    'acknowledged',
  );
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
    'acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acknowledged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _acknowledgedAtMeta = const VerificationMeta(
    'acknowledgedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>(
        'acknowledged_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _originTargetRoleTierMeta =
      const VerificationMeta('originTargetRoleTier');
  @override
  late final GeneratedColumn<String> originTargetRoleTier =
      GeneratedColumn<String>(
        'origin_target_role_tier',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _escalatedAtMeta = const VerificationMeta(
    'escalatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> escalatedAt = GeneratedColumn<DateTime>(
    'escalated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notificationRuleId,
    taskSubmissionId,
    recipientUserId,
    message,
    siteId,
    createdAt,
    acknowledged,
    acknowledgedAt,
    originTargetRoleTier,
    escalatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trigger_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriggerNotificationEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notification_rule_id')) {
      context.handle(
        _notificationRuleIdMeta,
        notificationRuleId.isAcceptableOrUnknown(
          data['notification_rule_id']!,
          _notificationRuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationRuleIdMeta);
    }
    if (data.containsKey('task_submission_id')) {
      context.handle(
        _taskSubmissionIdMeta,
        taskSubmissionId.isAcceptableOrUnknown(
          data['task_submission_id']!,
          _taskSubmissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taskSubmissionIdMeta);
    }
    if (data.containsKey('recipient_user_id')) {
      context.handle(
        _recipientUserIdMeta,
        recipientUserId.isAcceptableOrUnknown(
          data['recipient_user_id']!,
          _recipientUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientUserIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
        _acknowledgedMeta,
        acknowledged.isAcceptableOrUnknown(
          data['acknowledged']!,
          _acknowledgedMeta,
        ),
      );
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
        _acknowledgedAtMeta,
        acknowledgedAt.isAcceptableOrUnknown(
          data['acknowledged_at']!,
          _acknowledgedAtMeta,
        ),
      );
    }
    if (data.containsKey('origin_target_role_tier')) {
      context.handle(
        _originTargetRoleTierMeta,
        originTargetRoleTier.isAcceptableOrUnknown(
          data['origin_target_role_tier']!,
          _originTargetRoleTierMeta,
        ),
      );
    }
    if (data.containsKey('escalated_at')) {
      context.handle(
        _escalatedAtMeta,
        escalatedAt.isAcceptableOrUnknown(
          data['escalated_at']!,
          _escalatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriggerNotificationEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriggerNotificationEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notificationRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_rule_id'],
      )!,
      taskSubmissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_submission_id'],
      )!,
      recipientUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipient_user_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      acknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acknowledged'],
      )!,
      acknowledgedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acknowledged_at'],
      ),
      originTargetRoleTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_target_role_tier'],
      ),
      escalatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}escalated_at'],
      ),
    );
  }

  @override
  $TriggerNotificationsTable createAlias(String alias) {
    return $TriggerNotificationsTable(attachedDatabase, alias);
  }
}

class TriggerNotificationEntity extends DataClass
    implements Insertable<TriggerNotificationEntity> {
  final int id;
  final int notificationRuleId;
  final int taskSubmissionId;
  final int recipientUserId;
  final String message;
  final int siteId;
  final DateTime createdAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;
  final String? originTargetRoleTier;
  final DateTime? escalatedAt;
  const TriggerNotificationEntity({
    required this.id,
    required this.notificationRuleId,
    required this.taskSubmissionId,
    required this.recipientUserId,
    required this.message,
    required this.siteId,
    required this.createdAt,
    required this.acknowledged,
    this.acknowledgedAt,
    this.originTargetRoleTier,
    this.escalatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['notification_rule_id'] = Variable<int>(notificationRuleId);
    map['task_submission_id'] = Variable<int>(taskSubmissionId);
    map['recipient_user_id'] = Variable<int>(recipientUserId);
    map['message'] = Variable<String>(message);
    map['site_id'] = Variable<int>(siteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['acknowledged'] = Variable<bool>(acknowledged);
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    if (!nullToAbsent || originTargetRoleTier != null) {
      map['origin_target_role_tier'] = Variable<String>(originTargetRoleTier);
    }
    if (!nullToAbsent || escalatedAt != null) {
      map['escalated_at'] = Variable<DateTime>(escalatedAt);
    }
    return map;
  }

  TriggerNotificationsCompanion toCompanion(bool nullToAbsent) {
    return TriggerNotificationsCompanion(
      id: Value(id),
      notificationRuleId: Value(notificationRuleId),
      taskSubmissionId: Value(taskSubmissionId),
      recipientUserId: Value(recipientUserId),
      message: Value(message),
      siteId: Value(siteId),
      createdAt: Value(createdAt),
      acknowledged: Value(acknowledged),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
      originTargetRoleTier: originTargetRoleTier == null && nullToAbsent
          ? const Value.absent()
          : Value(originTargetRoleTier),
      escalatedAt: escalatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(escalatedAt),
    );
  }

  factory TriggerNotificationEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriggerNotificationEntity(
      id: serializer.fromJson<int>(json['id']),
      notificationRuleId: serializer.fromJson<int>(json['notificationRuleId']),
      taskSubmissionId: serializer.fromJson<int>(json['taskSubmissionId']),
      recipientUserId: serializer.fromJson<int>(json['recipientUserId']),
      message: serializer.fromJson<String>(json['message']),
      siteId: serializer.fromJson<int>(json['siteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
      originTargetRoleTier: serializer.fromJson<String?>(
        json['originTargetRoleTier'],
      ),
      escalatedAt: serializer.fromJson<DateTime?>(json['escalatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notificationRuleId': serializer.toJson<int>(notificationRuleId),
      'taskSubmissionId': serializer.toJson<int>(taskSubmissionId),
      'recipientUserId': serializer.toJson<int>(recipientUserId),
      'message': serializer.toJson<String>(message),
      'siteId': serializer.toJson<int>(siteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'acknowledged': serializer.toJson<bool>(acknowledged),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
      'originTargetRoleTier': serializer.toJson<String?>(originTargetRoleTier),
      'escalatedAt': serializer.toJson<DateTime?>(escalatedAt),
    };
  }

  TriggerNotificationEntity copyWith({
    int? id,
    int? notificationRuleId,
    int? taskSubmissionId,
    int? recipientUserId,
    String? message,
    int? siteId,
    DateTime? createdAt,
    bool? acknowledged,
    Value<DateTime?> acknowledgedAt = const Value.absent(),
    Value<String?> originTargetRoleTier = const Value.absent(),
    Value<DateTime?> escalatedAt = const Value.absent(),
  }) => TriggerNotificationEntity(
    id: id ?? this.id,
    notificationRuleId: notificationRuleId ?? this.notificationRuleId,
    taskSubmissionId: taskSubmissionId ?? this.taskSubmissionId,
    recipientUserId: recipientUserId ?? this.recipientUserId,
    message: message ?? this.message,
    siteId: siteId ?? this.siteId,
    createdAt: createdAt ?? this.createdAt,
    acknowledged: acknowledged ?? this.acknowledged,
    acknowledgedAt: acknowledgedAt.present
        ? acknowledgedAt.value
        : this.acknowledgedAt,
    originTargetRoleTier: originTargetRoleTier.present
        ? originTargetRoleTier.value
        : this.originTargetRoleTier,
    escalatedAt: escalatedAt.present ? escalatedAt.value : this.escalatedAt,
  );
  TriggerNotificationEntity copyWithCompanion(
    TriggerNotificationsCompanion data,
  ) {
    return TriggerNotificationEntity(
      id: data.id.present ? data.id.value : this.id,
      notificationRuleId: data.notificationRuleId.present
          ? data.notificationRuleId.value
          : this.notificationRuleId,
      taskSubmissionId: data.taskSubmissionId.present
          ? data.taskSubmissionId.value
          : this.taskSubmissionId,
      recipientUserId: data.recipientUserId.present
          ? data.recipientUserId.value
          : this.recipientUserId,
      message: data.message.present ? data.message.value : this.message,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
      originTargetRoleTier: data.originTargetRoleTier.present
          ? data.originTargetRoleTier.value
          : this.originTargetRoleTier,
      escalatedAt: data.escalatedAt.present
          ? data.escalatedAt.value
          : this.escalatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriggerNotificationEntity(')
          ..write('id: $id, ')
          ..write('notificationRuleId: $notificationRuleId, ')
          ..write('taskSubmissionId: $taskSubmissionId, ')
          ..write('recipientUserId: $recipientUserId, ')
          ..write('message: $message, ')
          ..write('siteId: $siteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('originTargetRoleTier: $originTargetRoleTier, ')
          ..write('escalatedAt: $escalatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notificationRuleId,
    taskSubmissionId,
    recipientUserId,
    message,
    siteId,
    createdAt,
    acknowledged,
    acknowledgedAt,
    originTargetRoleTier,
    escalatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriggerNotificationEntity &&
          other.id == this.id &&
          other.notificationRuleId == this.notificationRuleId &&
          other.taskSubmissionId == this.taskSubmissionId &&
          other.recipientUserId == this.recipientUserId &&
          other.message == this.message &&
          other.siteId == this.siteId &&
          other.createdAt == this.createdAt &&
          other.acknowledged == this.acknowledged &&
          other.acknowledgedAt == this.acknowledgedAt &&
          other.originTargetRoleTier == this.originTargetRoleTier &&
          other.escalatedAt == this.escalatedAt);
}

class TriggerNotificationsCompanion
    extends UpdateCompanion<TriggerNotificationEntity> {
  final Value<int> id;
  final Value<int> notificationRuleId;
  final Value<int> taskSubmissionId;
  final Value<int> recipientUserId;
  final Value<String> message;
  final Value<int> siteId;
  final Value<DateTime> createdAt;
  final Value<bool> acknowledged;
  final Value<DateTime?> acknowledgedAt;
  final Value<String?> originTargetRoleTier;
  final Value<DateTime?> escalatedAt;
  const TriggerNotificationsCompanion({
    this.id = const Value.absent(),
    this.notificationRuleId = const Value.absent(),
    this.taskSubmissionId = const Value.absent(),
    this.recipientUserId = const Value.absent(),
    this.message = const Value.absent(),
    this.siteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.originTargetRoleTier = const Value.absent(),
    this.escalatedAt = const Value.absent(),
  });
  TriggerNotificationsCompanion.insert({
    this.id = const Value.absent(),
    required int notificationRuleId,
    required int taskSubmissionId,
    required int recipientUserId,
    required String message,
    required int siteId,
    required DateTime createdAt,
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.originTargetRoleTier = const Value.absent(),
    this.escalatedAt = const Value.absent(),
  }) : notificationRuleId = Value(notificationRuleId),
       taskSubmissionId = Value(taskSubmissionId),
       recipientUserId = Value(recipientUserId),
       message = Value(message),
       siteId = Value(siteId),
       createdAt = Value(createdAt);
  static Insertable<TriggerNotificationEntity> custom({
    Expression<int>? id,
    Expression<int>? notificationRuleId,
    Expression<int>? taskSubmissionId,
    Expression<int>? recipientUserId,
    Expression<String>? message,
    Expression<int>? siteId,
    Expression<DateTime>? createdAt,
    Expression<bool>? acknowledged,
    Expression<DateTime>? acknowledgedAt,
    Expression<String>? originTargetRoleTier,
    Expression<DateTime>? escalatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationRuleId != null)
        'notification_rule_id': notificationRuleId,
      if (taskSubmissionId != null) 'task_submission_id': taskSubmissionId,
      if (recipientUserId != null) 'recipient_user_id': recipientUserId,
      if (message != null) 'message': message,
      if (siteId != null) 'site_id': siteId,
      if (createdAt != null) 'created_at': createdAt,
      if (acknowledged != null) 'acknowledged': acknowledged,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
      if (originTargetRoleTier != null)
        'origin_target_role_tier': originTargetRoleTier,
      if (escalatedAt != null) 'escalated_at': escalatedAt,
    });
  }

  TriggerNotificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? notificationRuleId,
    Value<int>? taskSubmissionId,
    Value<int>? recipientUserId,
    Value<String>? message,
    Value<int>? siteId,
    Value<DateTime>? createdAt,
    Value<bool>? acknowledged,
    Value<DateTime?>? acknowledgedAt,
    Value<String?>? originTargetRoleTier,
    Value<DateTime?>? escalatedAt,
  }) {
    return TriggerNotificationsCompanion(
      id: id ?? this.id,
      notificationRuleId: notificationRuleId ?? this.notificationRuleId,
      taskSubmissionId: taskSubmissionId ?? this.taskSubmissionId,
      recipientUserId: recipientUserId ?? this.recipientUserId,
      message: message ?? this.message,
      siteId: siteId ?? this.siteId,
      createdAt: createdAt ?? this.createdAt,
      acknowledged: acknowledged ?? this.acknowledged,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      originTargetRoleTier: originTargetRoleTier ?? this.originTargetRoleTier,
      escalatedAt: escalatedAt ?? this.escalatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notificationRuleId.present) {
      map['notification_rule_id'] = Variable<int>(notificationRuleId.value);
    }
    if (taskSubmissionId.present) {
      map['task_submission_id'] = Variable<int>(taskSubmissionId.value);
    }
    if (recipientUserId.present) {
      map['recipient_user_id'] = Variable<int>(recipientUserId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    if (originTargetRoleTier.present) {
      map['origin_target_role_tier'] = Variable<String>(
        originTargetRoleTier.value,
      );
    }
    if (escalatedAt.present) {
      map['escalated_at'] = Variable<DateTime>(escalatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriggerNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('notificationRuleId: $notificationRuleId, ')
          ..write('taskSubmissionId: $taskSubmissionId, ')
          ..write('recipientUserId: $recipientUserId, ')
          ..write('message: $message, ')
          ..write('siteId: $siteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('originTargetRoleTier: $originTargetRoleTier, ')
          ..write('escalatedAt: $escalatedAt')
          ..write(')'))
        .toString();
  }
}

class $ThirdPartyContactsTable extends ThirdPartyContacts
    with TableInfo<$ThirdPartyContactsTable, ThirdPartyContactEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThirdPartyContactsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specialtyMeta = const VerificationMeta(
    'specialty',
  );
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
    'specialty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
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
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id)',
    ),
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<int> createdByUserId = GeneratedColumn<int>(
    'created_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
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
    name,
    company,
    specialty,
    phone,
    email,
    notes,
    siteId,
    createdByUserId,
    createdAt,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'third_party_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThirdPartyContactEntity> instance, {
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
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('specialty')) {
      context.handle(
        _specialtyMeta,
        specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByUserIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  ThirdPartyContactEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThirdPartyContactEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      specialty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialty'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      ),
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $ThirdPartyContactsTable createAlias(String alias) {
    return $ThirdPartyContactsTable(attachedDatabase, alias);
  }
}

class ThirdPartyContactEntity extends DataClass
    implements Insertable<ThirdPartyContactEntity> {
  final int id;
  final String name;
  final String? company;
  final String? specialty;
  final String? phone;
  final String? email;
  final String? notes;
  final int? siteId;
  final int createdByUserId;
  final DateTime createdAt;
  final bool active;
  const ThirdPartyContactEntity({
    required this.id,
    required this.name,
    this.company,
    this.specialty,
    this.phone,
    this.email,
    this.notes,
    this.siteId,
    required this.createdByUserId,
    required this.createdAt,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    map['created_by_user_id'] = Variable<int>(createdByUserId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['active'] = Variable<bool>(active);
    return map;
  }

  ThirdPartyContactsCompanion toCompanion(bool nullToAbsent) {
    return ThirdPartyContactsCompanion(
      id: Value(id),
      name: Value(name),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      siteId: siteId == null && nullToAbsent
          ? const Value.absent()
          : Value(siteId),
      createdByUserId: Value(createdByUserId),
      createdAt: Value(createdAt),
      active: Value(active),
    );
  }

  factory ThirdPartyContactEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThirdPartyContactEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      company: serializer.fromJson<String?>(json['company']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
      siteId: serializer.fromJson<int?>(json['siteId']),
      createdByUserId: serializer.fromJson<int>(json['createdByUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'company': serializer.toJson<String?>(company),
      'specialty': serializer.toJson<String?>(specialty),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
      'siteId': serializer.toJson<int?>(siteId),
      'createdByUserId': serializer.toJson<int>(createdByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'active': serializer.toJson<bool>(active),
    };
  }

  ThirdPartyContactEntity copyWith({
    int? id,
    String? name,
    Value<String?> company = const Value.absent(),
    Value<String?> specialty = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> siteId = const Value.absent(),
    int? createdByUserId,
    DateTime? createdAt,
    bool? active,
  }) => ThirdPartyContactEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    company: company.present ? company.value : this.company,
    specialty: specialty.present ? specialty.value : this.specialty,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    notes: notes.present ? notes.value : this.notes,
    siteId: siteId.present ? siteId.value : this.siteId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    createdAt: createdAt ?? this.createdAt,
    active: active ?? this.active,
  );
  ThirdPartyContactEntity copyWithCompanion(ThirdPartyContactsCompanion data) {
    return ThirdPartyContactEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      company: data.company.present ? data.company.value : this.company,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThirdPartyContactEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('company: $company, ')
          ..write('specialty: $specialty, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('siteId: $siteId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    company,
    specialty,
    phone,
    email,
    notes,
    siteId,
    createdByUserId,
    createdAt,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThirdPartyContactEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.company == this.company &&
          other.specialty == this.specialty &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.siteId == this.siteId &&
          other.createdByUserId == this.createdByUserId &&
          other.createdAt == this.createdAt &&
          other.active == this.active);
}

class ThirdPartyContactsCompanion
    extends UpdateCompanion<ThirdPartyContactEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> company;
  final Value<String?> specialty;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<int?> siteId;
  final Value<int> createdByUserId;
  final Value<DateTime> createdAt;
  final Value<bool> active;
  const ThirdPartyContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.company = const Value.absent(),
    this.specialty = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.siteId = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.active = const Value.absent(),
  });
  ThirdPartyContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.company = const Value.absent(),
    this.specialty = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.siteId = const Value.absent(),
    required int createdByUserId,
    required DateTime createdAt,
    this.active = const Value.absent(),
  }) : name = Value(name),
       createdByUserId = Value(createdByUserId),
       createdAt = Value(createdAt);
  static Insertable<ThirdPartyContactEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? company,
    Expression<String>? specialty,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<int>? siteId,
    Expression<int>? createdByUserId,
    Expression<DateTime>? createdAt,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (company != null) 'company': company,
      if (specialty != null) 'specialty': specialty,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (siteId != null) 'site_id': siteId,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (createdAt != null) 'created_at': createdAt,
      if (active != null) 'active': active,
    });
  }

  ThirdPartyContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? company,
    Value<String?>? specialty,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? notes,
    Value<int?>? siteId,
    Value<int>? createdByUserId,
    Value<DateTime>? createdAt,
    Value<bool>? active,
  }) {
    return ThirdPartyContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      siteId: siteId ?? this.siteId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
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
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<int>(createdByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThirdPartyContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('company: $company, ')
          ..write('specialty: $specialty, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('siteId: $siteId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EquipmentTypesTable equipmentTypes = $EquipmentTypesTable(this);
  late final $OrganisationsTable organisations = $OrganisationsTable(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $AreasTable areas = $AreasTable(this);
  late final $EquipmentInstancesTable equipmentInstances =
      $EquipmentInstancesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TaskSubmissionsTable taskSubmissions = $TaskSubmissionsTable(
    this,
  );
  late final $LegalLimitReferencesTable legalLimitReferences =
      $LegalLimitReferencesTable(this);
  late final $TaskTemplatesTable taskTemplates = $TaskTemplatesTable(this);
  late final $TaskSchedulesTable taskSchedules = $TaskSchedulesTable(this);
  late final $ShiftHandoverNotesTable shiftHandoverNotes =
      $ShiftHandoverNotesTable(this);
  late final $SessionSummariesTable sessionSummaries = $SessionSummariesTable(
    this,
  );
  late final $NotificationRulesTable notificationRules =
      $NotificationRulesTable(this);
  late final $TriggerNotificationsTable triggerNotifications =
      $TriggerNotificationsTable(this);
  late final $ThirdPartyContactsTable thirdPartyContacts =
      $ThirdPartyContactsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    equipmentTypes,
    organisations,
    sites,
    areas,
    equipmentInstances,
    users,
    taskSubmissions,
    legalLimitReferences,
    taskTemplates,
    taskSchedules,
    shiftHandoverNotes,
    sessionSummaries,
    notificationRules,
    triggerNotifications,
    thirdPartyContacts,
  ];
}

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
            bool equipmentInstancesRefs,
            bool taskTemplatesRefs,
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
              ({equipmentInstancesRefs = false, taskTemplatesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (equipmentInstancesRefs) db.equipmentInstances,
                    if (taskTemplatesRefs) db.taskTemplates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
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
        bool equipmentInstancesRefs,
        bool taskTemplatesRefs,
      })
    >;
typedef $$OrganisationsTableCreateCompanionBuilder =
    OrganisationsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
    });
typedef $$OrganisationsTableUpdateCompanionBuilder =
    OrganisationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$OrganisationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OrganisationsTable, OrganisationEntity> {
  $$OrganisationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SitesTable, List<SiteEntity>> _sitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sites,
    aliasName: 'organisations__id__sites__organisation_id',
  );

  $$SitesTableProcessedTableManager get sitesRefs {
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.organisationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganisationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganisationsTable> {
  $$OrganisationsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sitesRefs(
    Expression<bool> Function($$SitesTableFilterComposer f) f,
  ) {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.organisationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganisationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganisationsTable> {
  $$OrganisationsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganisationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganisationsTable> {
  $$OrganisationsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> sitesRefs<T extends Object>(
    Expression<T> Function($$SitesTableAnnotationComposer a) f,
  ) {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.organisationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganisationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganisationsTable,
          OrganisationEntity,
          $$OrganisationsTableFilterComposer,
          $$OrganisationsTableOrderingComposer,
          $$OrganisationsTableAnnotationComposer,
          $$OrganisationsTableCreateCompanionBuilder,
          $$OrganisationsTableUpdateCompanionBuilder,
          (OrganisationEntity, $$OrganisationsTableReferences),
          OrganisationEntity,
          PrefetchHooks Function({bool sitesRefs})
        > {
  $$OrganisationsTableTableManager(_$AppDatabase db, $OrganisationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganisationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganisationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganisationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OrganisationsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
              }) => OrganisationsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrganisationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sitesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sitesRefs) db.sites],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sitesRefs)
                    await $_getPrefetchedData<
                      OrganisationEntity,
                      $OrganisationsTable,
                      SiteEntity
                    >(
                      currentTable: table,
                      referencedTable: $$OrganisationsTableReferences
                          ._sitesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrganisationsTableReferences(
                            db,
                            table,
                            p0,
                          ).sitesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.organisationId == item.id,
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

typedef $$OrganisationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganisationsTable,
      OrganisationEntity,
      $$OrganisationsTableFilterComposer,
      $$OrganisationsTableOrderingComposer,
      $$OrganisationsTableAnnotationComposer,
      $$OrganisationsTableCreateCompanionBuilder,
      $$OrganisationsTableUpdateCompanionBuilder,
      (OrganisationEntity, $$OrganisationsTableReferences),
      OrganisationEntity,
      PrefetchHooks Function({bool sitesRefs})
    >;
typedef $$SitesTableCreateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      required int organisationId,
      required String name,
      Value<String?> address,
      required DateTime createdAt,
    });
typedef $$SitesTableUpdateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<String> name,
      Value<String?> address,
      Value<DateTime> createdAt,
    });

final class $$SitesTableReferences
    extends BaseReferences<_$AppDatabase, $SitesTable, SiteEntity> {
  $$SitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganisationsTable _organisationIdTable(_$AppDatabase db) =>
      db.organisations.createAlias('sites__organisation_id__organisations__id');

  $$OrganisationsTableProcessedTableManager get organisationId {
    final $_column = $_itemColumn<int>('organisation_id')!;

    final manager = $$OrganisationsTableTableManager(
      $_db,
      $_db.organisations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organisationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AreasTable, List<AreaEntity>> _areasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.areas,
    aliasName: 'sites__id__areas__site_id',
  );

  $$AreasTableProcessedTableManager get areasRefs {
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_areasRefsTable($_db));
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
        aliasName: 'sites__id__equipment_instances__site_id',
      );

  $$EquipmentInstancesTableProcessedTableManager get equipmentInstancesRefs {
    final manager = $$EquipmentInstancesTableTableManager(
      $_db,
      $_db.equipmentInstances,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _equipmentInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsersTable, List<UserEntity>> _usersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.users,
    aliasName: 'sites__id__users__site_id',
  );

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskSubmissionsTable, List<TaskSubmissionEntity>>
  _taskSubmissionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskSubmissions,
    aliasName: 'sites__id__task_submissions__site_id',
  );

  $$TaskSubmissionsTableProcessedTableManager get taskSubmissionsRefs {
    final manager = $$TaskSubmissionsTableTableManager(
      $_db,
      $_db.taskSubmissions,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskSubmissionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskSchedulesTable, List<TaskScheduleEntity>>
  _taskSchedulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskSchedules,
    aliasName: 'sites__id__task_schedules__site_id',
  );

  $$TaskSchedulesTableProcessedTableManager get taskSchedulesRefs {
    final manager = $$TaskSchedulesTableTableManager(
      $_db,
      $_db.taskSchedules,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskSchedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftHandoverNotesTable,
    List<ShiftHandoverNoteEntity>
  >
  _shiftHandoverNotesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftHandoverNotes,
        aliasName: 'sites__id__shift_handover_notes__site_id',
      );

  $$ShiftHandoverNotesTableProcessedTableManager get shiftHandoverNotesRefs {
    final manager = $$ShiftHandoverNotesTableTableManager(
      $_db,
      $_db.shiftHandoverNotes,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftHandoverNotesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionSummariesTable, List<SessionSummaryEntity>>
  _sessionSummariesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionSummaries,
    aliasName: 'sites__id__session_summaries__site_id',
  );

  $$SessionSummariesTableProcessedTableManager get sessionSummariesRefs {
    final manager = $$SessionSummariesTableTableManager(
      $_db,
      $_db.sessionSummaries,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionSummariesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $NotificationRulesTable,
    List<NotificationRuleEntity>
  >
  _notificationRulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.notificationRules,
        aliasName: 'sites__id__notification_rules__site_id',
      );

  $$NotificationRulesTableProcessedTableManager get notificationRulesRefs {
    final manager = $$NotificationRulesTableTableManager(
      $_db,
      $_db.notificationRules,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _notificationRulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TriggerNotificationsTable,
    List<TriggerNotificationEntity>
  >
  _triggerNotificationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.triggerNotifications,
        aliasName: 'sites__id__trigger_notifications__site_id',
      );

  $$TriggerNotificationsTableProcessedTableManager
  get triggerNotificationsRefs {
    final manager = $$TriggerNotificationsTableTableManager(
      $_db,
      $_db.triggerNotifications,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _triggerNotificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ThirdPartyContactsTable,
    List<ThirdPartyContactEntity>
  >
  _thirdPartyContactsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.thirdPartyContacts,
        aliasName: 'sites__id__third_party_contacts__site_id',
      );

  $$ThirdPartyContactsTableProcessedTableManager get thirdPartyContactsRefs {
    final manager = $$ThirdPartyContactsTableTableManager(
      $_db,
      $_db.thirdPartyContacts,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _thirdPartyContactsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
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

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganisationsTableFilterComposer get organisationId {
    final $$OrganisationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organisationId,
      referencedTable: $db.organisations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganisationsTableFilterComposer(
            $db: $db,
            $table: $db.organisations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> areasRefs(
    Expression<bool> Function($$AreasTableFilterComposer f) f,
  ) {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.siteId,
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
    return f(composer);
  }

  Expression<bool> equipmentInstancesRefs(
    Expression<bool> Function($$EquipmentInstancesTableFilterComposer f) f,
  ) {
    final $$EquipmentInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipmentInstances,
      getReferencedColumn: (t) => t.siteId,
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

  Expression<bool> usersRefs(
    Expression<bool> Function($$UsersTableFilterComposer f) f,
  ) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.siteId,
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
    return f(composer);
  }

  Expression<bool> taskSubmissionsRefs(
    Expression<bool> Function($$TaskSubmissionsTableFilterComposer f) f,
  ) {
    final $$TaskSubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskSchedulesRefs(
    Expression<bool> Function($$TaskSchedulesTableFilterComposer f) f,
  ) {
    final $$TaskSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSchedules,
      getReferencedColumn: (t) => t.siteId,
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

  Expression<bool> shiftHandoverNotesRefs(
    Expression<bool> Function($$ShiftHandoverNotesTableFilterComposer f) f,
  ) {
    final $$ShiftHandoverNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftHandoverNotes,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftHandoverNotesTableFilterComposer(
            $db: $db,
            $table: $db.shiftHandoverNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionSummariesRefs(
    Expression<bool> Function($$SessionSummariesTableFilterComposer f) f,
  ) {
    final $$SessionSummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSummaries,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSummariesTableFilterComposer(
            $db: $db,
            $table: $db.sessionSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notificationRulesRefs(
    Expression<bool> Function($$NotificationRulesTableFilterComposer f) f,
  ) {
    final $$NotificationRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notificationRules,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationRulesTableFilterComposer(
            $db: $db,
            $table: $db.notificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> triggerNotificationsRefs(
    Expression<bool> Function($$TriggerNotificationsTableFilterComposer f) f,
  ) {
    final $$TriggerNotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerNotifications,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerNotificationsTableFilterComposer(
            $db: $db,
            $table: $db.triggerNotifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> thirdPartyContactsRefs(
    Expression<bool> Function($$ThirdPartyContactsTableFilterComposer f) f,
  ) {
    final $$ThirdPartyContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.thirdPartyContacts,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThirdPartyContactsTableFilterComposer(
            $db: $db,
            $table: $db.thirdPartyContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
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

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganisationsTableOrderingComposer get organisationId {
    final $$OrganisationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organisationId,
      referencedTable: $db.organisations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganisationsTableOrderingComposer(
            $db: $db,
            $table: $db.organisations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
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

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrganisationsTableAnnotationComposer get organisationId {
    final $$OrganisationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organisationId,
      referencedTable: $db.organisations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganisationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organisations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> areasRefs<T extends Object>(
    Expression<T> Function($$AreasTableAnnotationComposer a) f,
  ) {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.siteId,
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
          getReferencedColumn: (t) => t.siteId,
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

  Expression<T> usersRefs<T extends Object>(
    Expression<T> Function($$UsersTableAnnotationComposer a) f,
  ) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.siteId,
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
    return f(composer);
  }

  Expression<T> taskSubmissionsRefs<T extends Object>(
    Expression<T> Function($$TaskSubmissionsTableAnnotationComposer a) f,
  ) {
    final $$TaskSubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskSchedulesRefs<T extends Object>(
    Expression<T> Function($$TaskSchedulesTableAnnotationComposer a) f,
  ) {
    final $$TaskSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSchedules,
      getReferencedColumn: (t) => t.siteId,
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

  Expression<T> shiftHandoverNotesRefs<T extends Object>(
    Expression<T> Function($$ShiftHandoverNotesTableAnnotationComposer a) f,
  ) {
    final $$ShiftHandoverNotesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftHandoverNotes,
          getReferencedColumn: (t) => t.siteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftHandoverNotesTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftHandoverNotes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sessionSummariesRefs<T extends Object>(
    Expression<T> Function($$SessionSummariesTableAnnotationComposer a) f,
  ) {
    final $$SessionSummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSummaries,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notificationRulesRefs<T extends Object>(
    Expression<T> Function($$NotificationRulesTableAnnotationComposer a) f,
  ) {
    final $$NotificationRulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notificationRules,
          getReferencedColumn: (t) => t.siteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationRulesTableAnnotationComposer(
                $db: $db,
                $table: $db.notificationRules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> triggerNotificationsRefs<T extends Object>(
    Expression<T> Function($$TriggerNotificationsTableAnnotationComposer a) f,
  ) {
    final $$TriggerNotificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.triggerNotifications,
          getReferencedColumn: (t) => t.siteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TriggerNotificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.triggerNotifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> thirdPartyContactsRefs<T extends Object>(
    Expression<T> Function($$ThirdPartyContactsTableAnnotationComposer a) f,
  ) {
    final $$ThirdPartyContactsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.thirdPartyContacts,
          getReferencedColumn: (t) => t.siteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ThirdPartyContactsTableAnnotationComposer(
                $db: $db,
                $table: $db.thirdPartyContacts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SitesTable,
          SiteEntity,
          $$SitesTableFilterComposer,
          $$SitesTableOrderingComposer,
          $$SitesTableAnnotationComposer,
          $$SitesTableCreateCompanionBuilder,
          $$SitesTableUpdateCompanionBuilder,
          (SiteEntity, $$SitesTableReferences),
          SiteEntity,
          PrefetchHooks Function({
            bool organisationId,
            bool areasRefs,
            bool equipmentInstancesRefs,
            bool usersRefs,
            bool taskSubmissionsRefs,
            bool taskSchedulesRefs,
            bool shiftHandoverNotesRefs,
            bool sessionSummariesRefs,
            bool notificationRulesRefs,
            bool triggerNotificationsRefs,
            bool thirdPartyContactsRefs,
          })
        > {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SitesCompanion(
                id: id,
                organisationId: organisationId,
                name: name,
                address: address,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                required String name,
                Value<String?> address = const Value.absent(),
                required DateTime createdAt,
              }) => SitesCompanion.insert(
                id: id,
                organisationId: organisationId,
                name: name,
                address: address,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SitesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organisationId = false,
                areasRefs = false,
                equipmentInstancesRefs = false,
                usersRefs = false,
                taskSubmissionsRefs = false,
                taskSchedulesRefs = false,
                shiftHandoverNotesRefs = false,
                sessionSummariesRefs = false,
                notificationRulesRefs = false,
                triggerNotificationsRefs = false,
                thirdPartyContactsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (areasRefs) db.areas,
                    if (equipmentInstancesRefs) db.equipmentInstances,
                    if (usersRefs) db.users,
                    if (taskSubmissionsRefs) db.taskSubmissions,
                    if (taskSchedulesRefs) db.taskSchedules,
                    if (shiftHandoverNotesRefs) db.shiftHandoverNotes,
                    if (sessionSummariesRefs) db.sessionSummaries,
                    if (notificationRulesRefs) db.notificationRules,
                    if (triggerNotificationsRefs) db.triggerNotifications,
                    if (thirdPartyContactsRefs) db.thirdPartyContacts,
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
                        if (organisationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.organisationId,
                                    referencedTable: $$SitesTableReferences
                                        ._organisationIdTable(db),
                                    referencedColumn: $$SitesTableReferences
                                        ._organisationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (areasRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          AreaEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._areasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(db, table, p0).areasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (equipmentInstancesRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          EquipmentInstanceEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._equipmentInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).equipmentInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (usersRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          UserEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._usersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(db, table, p0).usersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskSubmissionsRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          TaskSubmissionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._taskSubmissionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskSubmissionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskSchedulesRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          TaskScheduleEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._taskSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftHandoverNotesRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          ShiftHandoverNoteEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._shiftHandoverNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftHandoverNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionSummariesRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          SessionSummaryEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._sessionSummariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionSummariesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notificationRulesRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          NotificationRuleEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._notificationRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).notificationRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (triggerNotificationsRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          TriggerNotificationEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._triggerNotificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).triggerNotificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (thirdPartyContactsRefs)
                        await $_getPrefetchedData<
                          SiteEntity,
                          $SitesTable,
                          ThirdPartyContactEntity
                        >(
                          currentTable: table,
                          referencedTable: $$SitesTableReferences
                              ._thirdPartyContactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitesTableReferences(
                                db,
                                table,
                                p0,
                              ).thirdPartyContactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.siteId == item.id,
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

typedef $$SitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SitesTable,
      SiteEntity,
      $$SitesTableFilterComposer,
      $$SitesTableOrderingComposer,
      $$SitesTableAnnotationComposer,
      $$SitesTableCreateCompanionBuilder,
      $$SitesTableUpdateCompanionBuilder,
      (SiteEntity, $$SitesTableReferences),
      SiteEntity,
      PrefetchHooks Function({
        bool organisationId,
        bool areasRefs,
        bool equipmentInstancesRefs,
        bool usersRefs,
        bool taskSubmissionsRefs,
        bool taskSchedulesRefs,
        bool shiftHandoverNotesRefs,
        bool sessionSummariesRefs,
        bool notificationRulesRefs,
        bool triggerNotificationsRefs,
        bool thirdPartyContactsRefs,
      })
    >;
typedef $$AreasTableCreateCompanionBuilder =
    AreasCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> siteId,
    });
typedef $$AreasTableUpdateCompanionBuilder =
    AreasCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> siteId,
    });

final class $$AreasTableReferences
    extends BaseReferences<_$AppDatabase, $AreasTable, AreaEntity> {
  $$AreasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('areas__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
          PrefetchHooks Function({bool siteId, bool equipmentInstancesRefs})
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
                Value<int?> siteId = const Value.absent(),
              }) => AreasCompanion(id: id, name: name, siteId: siteId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> siteId = const Value.absent(),
              }) => AreasCompanion.insert(id: id, name: name, siteId: siteId),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AreasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({siteId = false, equipmentInstancesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (equipmentInstancesRefs) db.equipmentInstances,
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
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable: $$AreasTableReferences
                                        ._siteIdTable(db),
                                    referencedColumn: $$AreasTableReferences
                                        ._siteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
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
                          managerFromTypedResult: (p0) =>
                              $$AreasTableReferences(
                                db,
                                table,
                                p0,
                              ).equipmentInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.areaId == item.id,
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
      PrefetchHooks Function({bool siteId, bool equipmentInstancesRefs})
    >;
typedef $$EquipmentInstancesTableCreateCompanionBuilder =
    EquipmentInstancesCompanion Function({
      Value<int> id,
      required String name,
      required int equipmentTypeId,
      Value<int?> areaId,
      Value<int?> siteId,
      Value<bool> active,
    });
typedef $$EquipmentInstancesTableUpdateCompanionBuilder =
    EquipmentInstancesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> equipmentTypeId,
      Value<int?> areaId,
      Value<int?> siteId,
      Value<bool> active,
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

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('equipment_instances__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskSubmissionsTable, List<TaskSubmissionEntity>>
  _taskSubmissionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskSubmissions,
    aliasName:
        'equipment_instances__id__task_submissions__equipment_instance_id',
  );

  $$TaskSubmissionsTableProcessedTableManager get taskSubmissionsRefs {
    final manager =
        $$TaskSubmissionsTableTableManager($_db, $_db.taskSubmissions).filter(
          (f) => f.equipmentInstanceId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _taskSubmissionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskSubmissionsRefs(
    Expression<bool> Function($$TaskSubmissionsTableFilterComposer f) f,
  ) {
    final $$TaskSubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.equipmentInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
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

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskSubmissionsRefs<T extends Object>(
    Expression<T> Function($$TaskSubmissionsTableAnnotationComposer a) f,
  ) {
    final $$TaskSubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.equipmentInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
            bool siteId,
            bool taskSubmissionsRefs,
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
                Value<int?> siteId = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => EquipmentInstancesCompanion(
                id: id,
                name: name,
                equipmentTypeId: equipmentTypeId,
                areaId: areaId,
                siteId: siteId,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int equipmentTypeId,
                Value<int?> areaId = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => EquipmentInstancesCompanion.insert(
                id: id,
                name: name,
                equipmentTypeId: equipmentTypeId,
                areaId: areaId,
                siteId: siteId,
                active: active,
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
                siteId = false,
                taskSubmissionsRefs = false,
                taskSchedulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskSubmissionsRefs) db.taskSubmissions,
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
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$EquipmentInstancesTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$EquipmentInstancesTableReferences
                                            ._siteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskSubmissionsRefs)
                        await $_getPrefetchedData<
                          EquipmentInstanceEntity,
                          $EquipmentInstancesTable,
                          TaskSubmissionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentInstancesTableReferences
                              ._taskSubmissionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentInstancesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskSubmissionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentInstanceId == item.id,
                              ),
                          typedResults: items,
                        ),
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
        bool siteId,
        bool taskSubmissionsRefs,
        bool taskSchedulesRefs,
      })
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String name,
      required String jobTitle,
      required String roleTier,
      required String pinHash,
      required String pinSalt,
      Value<String> preferredTemperatureUnit,
      Value<int?> siteId,
      Value<bool> active,
      Value<DateTime?> deactivatedAt,
      Value<int?> deactivatedByUserId,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> jobTitle,
      Value<String> roleTier,
      Value<String> pinHash,
      Value<String> pinSalt,
      Value<String> preferredTemperatureUnit,
      Value<int?> siteId,
      Value<bool> active,
      Value<DateTime?> deactivatedAt,
      Value<int?> deactivatedByUserId,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, UserEntity> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('users__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _deactivatedByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('users__deactivated_by_user_id__users__id');

  $$UsersTableProcessedTableManager? get deactivatedByUserId {
    final $_column = $_itemColumn<int>('deactivated_by_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deactivatedByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskSubmissionsTable, List<TaskSubmissionEntity>>
  _taskSubmissionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskSubmissions,
    aliasName: 'users__id__task_submissions__completed_by_user_id',
  );

  $$TaskSubmissionsTableProcessedTableManager get taskSubmissionsRefs {
    final manager = $$TaskSubmissionsTableTableManager(
      $_db,
      $_db.taskSubmissions,
    ).filter((f) => f.completedByUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskSubmissionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

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

  static MultiTypedResultKey<
    $ShiftHandoverNotesTable,
    List<ShiftHandoverNoteEntity>
  >
  _shiftHandoverNotesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftHandoverNotes,
        aliasName: 'users__id__shift_handover_notes__author_user_id',
      );

  $$ShiftHandoverNotesTableProcessedTableManager get shiftHandoverNotesRefs {
    final manager = $$ShiftHandoverNotesTableTableManager(
      $_db,
      $_db.shiftHandoverNotes,
    ).filter((f) => f.authorUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftHandoverNotesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TriggerNotificationsTable,
    List<TriggerNotificationEntity>
  >
  _triggerNotificationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.triggerNotifications,
        aliasName: 'users__id__trigger_notifications__recipient_user_id',
      );

  $$TriggerNotificationsTableProcessedTableManager
  get triggerNotificationsRefs {
    final manager = $$TriggerNotificationsTableTableManager(
      $_db,
      $_db.triggerNotifications,
    ).filter((f) => f.recipientUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _triggerNotificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ThirdPartyContactsTable,
    List<ThirdPartyContactEntity>
  >
  _thirdPartyContactsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.thirdPartyContacts,
        aliasName: 'users__id__third_party_contacts__created_by_user_id',
      );

  $$ThirdPartyContactsTableProcessedTableManager get thirdPartyContactsRefs {
    final manager = $$ThirdPartyContactsTableTableManager(
      $_db,
      $_db.thirdPartyContacts,
    ).filter((f) => f.createdByUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _thirdPartyContactsRefsTable($_db),
    );
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

  ColumnFilters<String> get preferredTemperatureUnit => $composableBuilder(
    column: $table.preferredTemperatureUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get deactivatedByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deactivatedByUserId,
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

  Expression<bool> taskSubmissionsRefs(
    Expression<bool> Function($$TaskSubmissionsTableFilterComposer f) f,
  ) {
    final $$TaskSubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.completedByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

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

  Expression<bool> shiftHandoverNotesRefs(
    Expression<bool> Function($$ShiftHandoverNotesTableFilterComposer f) f,
  ) {
    final $$ShiftHandoverNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftHandoverNotes,
      getReferencedColumn: (t) => t.authorUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftHandoverNotesTableFilterComposer(
            $db: $db,
            $table: $db.shiftHandoverNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> triggerNotificationsRefs(
    Expression<bool> Function($$TriggerNotificationsTableFilterComposer f) f,
  ) {
    final $$TriggerNotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerNotifications,
      getReferencedColumn: (t) => t.recipientUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerNotificationsTableFilterComposer(
            $db: $db,
            $table: $db.triggerNotifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> thirdPartyContactsRefs(
    Expression<bool> Function($$ThirdPartyContactsTableFilterComposer f) f,
  ) {
    final $$ThirdPartyContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.thirdPartyContacts,
      getReferencedColumn: (t) => t.createdByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThirdPartyContactsTableFilterComposer(
            $db: $db,
            $table: $db.thirdPartyContacts,
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

  ColumnOrderings<String> get preferredTemperatureUnit => $composableBuilder(
    column: $table.preferredTemperatureUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get deactivatedByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deactivatedByUserId,
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

  GeneratedColumn<String> get preferredTemperatureUnit => $composableBuilder(
    column: $table.preferredTemperatureUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => column,
  );

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get deactivatedByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deactivatedByUserId,
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

  Expression<T> taskSubmissionsRefs<T extends Object>(
    Expression<T> Function($$TaskSubmissionsTableAnnotationComposer a) f,
  ) {
    final $$TaskSubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.completedByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

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

  Expression<T> shiftHandoverNotesRefs<T extends Object>(
    Expression<T> Function($$ShiftHandoverNotesTableAnnotationComposer a) f,
  ) {
    final $$ShiftHandoverNotesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftHandoverNotes,
          getReferencedColumn: (t) => t.authorUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftHandoverNotesTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftHandoverNotes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> triggerNotificationsRefs<T extends Object>(
    Expression<T> Function($$TriggerNotificationsTableAnnotationComposer a) f,
  ) {
    final $$TriggerNotificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.triggerNotifications,
          getReferencedColumn: (t) => t.recipientUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TriggerNotificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.triggerNotifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> thirdPartyContactsRefs<T extends Object>(
    Expression<T> Function($$ThirdPartyContactsTableAnnotationComposer a) f,
  ) {
    final $$ThirdPartyContactsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.thirdPartyContacts,
          getReferencedColumn: (t) => t.createdByUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ThirdPartyContactsTableAnnotationComposer(
                $db: $db,
                $table: $db.thirdPartyContacts,
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
          PrefetchHooks Function({
            bool siteId,
            bool deactivatedByUserId,
            bool taskSubmissionsRefs,
            bool taskTemplatesRefs,
            bool shiftHandoverNotesRefs,
            bool triggerNotificationsRefs,
            bool thirdPartyContactsRefs,
          })
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
                Value<String> preferredTemperatureUnit = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> deactivatedAt = const Value.absent(),
                Value<int?> deactivatedByUserId = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                jobTitle: jobTitle,
                roleTier: roleTier,
                pinHash: pinHash,
                pinSalt: pinSalt,
                preferredTemperatureUnit: preferredTemperatureUnit,
                siteId: siteId,
                active: active,
                deactivatedAt: deactivatedAt,
                deactivatedByUserId: deactivatedByUserId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String jobTitle,
                required String roleTier,
                required String pinHash,
                required String pinSalt,
                Value<String> preferredTemperatureUnit = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> deactivatedAt = const Value.absent(),
                Value<int?> deactivatedByUserId = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                jobTitle: jobTitle,
                roleTier: roleTier,
                pinHash: pinHash,
                pinSalt: pinSalt,
                preferredTemperatureUnit: preferredTemperatureUnit,
                siteId: siteId,
                active: active,
                deactivatedAt: deactivatedAt,
                deactivatedByUserId: deactivatedByUserId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                siteId = false,
                deactivatedByUserId = false,
                taskSubmissionsRefs = false,
                taskTemplatesRefs = false,
                shiftHandoverNotesRefs = false,
                triggerNotificationsRefs = false,
                thirdPartyContactsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskSubmissionsRefs) db.taskSubmissions,
                    if (taskTemplatesRefs) db.taskTemplates,
                    if (shiftHandoverNotesRefs) db.shiftHandoverNotes,
                    if (triggerNotificationsRefs) db.triggerNotifications,
                    if (thirdPartyContactsRefs) db.thirdPartyContacts,
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
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable: $$UsersTableReferences
                                        ._siteIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._siteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (deactivatedByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.deactivatedByUserId,
                                    referencedTable: $$UsersTableReferences
                                        ._deactivatedByUserIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._deactivatedByUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskSubmissionsRefs)
                        await $_getPrefetchedData<
                          UserEntity,
                          $UsersTable,
                          TaskSubmissionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._taskSubmissionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).taskSubmissionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.completedByUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskTemplatesRefs)
                        await $_getPrefetchedData<
                          UserEntity,
                          $UsersTable,
                          TaskTemplateEntity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._taskTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).taskTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.createdByUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftHandoverNotesRefs)
                        await $_getPrefetchedData<
                          UserEntity,
                          $UsersTable,
                          ShiftHandoverNoteEntity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._shiftHandoverNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftHandoverNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.authorUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (triggerNotificationsRefs)
                        await $_getPrefetchedData<
                          UserEntity,
                          $UsersTable,
                          TriggerNotificationEntity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._triggerNotificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).triggerNotificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipientUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (thirdPartyContactsRefs)
                        await $_getPrefetchedData<
                          UserEntity,
                          $UsersTable,
                          ThirdPartyContactEntity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._thirdPartyContactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).thirdPartyContactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({
        bool siteId,
        bool deactivatedByUserId,
        bool taskSubmissionsRefs,
        bool taskTemplatesRefs,
        bool shiftHandoverNotesRefs,
        bool triggerNotificationsRefs,
        bool thirdPartyContactsRefs,
      })
    >;
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
      Value<int?> taskScheduleId,
      Value<int?> taskTemplateGroupId,
      Value<int?> equipmentInstanceId,
      Value<String?> customFieldValuesJson,
      Value<int?> completedByUserId,
      Value<int?> siteId,
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
      Value<int?> taskScheduleId,
      Value<int?> taskTemplateGroupId,
      Value<int?> equipmentInstanceId,
      Value<String?> customFieldValuesJson,
      Value<int?> completedByUserId,
      Value<int?> siteId,
    });

final class $$TaskSubmissionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskSubmissionsTable,
          TaskSubmissionEntity
        > {
  $$TaskSubmissionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EquipmentInstancesTable _equipmentInstanceIdTable(_$AppDatabase db) =>
      db.equipmentInstances.createAlias(
        'task_submissions__equipment_instance_id__equipment_instances__id',
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

  static $UsersTable _completedByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('task_submissions__completed_by_user_id__users__id');

  $$UsersTableProcessedTableManager? get completedByUserId {
    final $_column = $_itemColumn<int>('completed_by_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_completedByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('task_submissions__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TriggerNotificationsTable,
    List<TriggerNotificationEntity>
  >
  _triggerNotificationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.triggerNotifications,
        aliasName:
            'task_submissions__id__trigger_notifications__task_submission_id',
      );

  $$TriggerNotificationsTableProcessedTableManager
  get triggerNotificationsRefs {
    final manager = $$TriggerNotificationsTableTableManager(
      $_db,
      $_db.triggerNotifications,
    ).filter((f) => f.taskSubmissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _triggerNotificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFieldValuesJson => $composableBuilder(
    column: $table.customFieldValuesJson,
    builder: (column) => ColumnFilters(column),
  );

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

  $$UsersTableFilterComposer get completedByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.completedByUserId,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> triggerNotificationsRefs(
    Expression<bool> Function($$TriggerNotificationsTableFilterComposer f) f,
  ) {
    final $$TriggerNotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerNotifications,
      getReferencedColumn: (t) => t.taskSubmissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerNotificationsTableFilterComposer(
            $db: $db,
            $table: $db.triggerNotifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFieldValuesJson => $composableBuilder(
    column: $table.customFieldValuesJson,
    builder: (column) => ColumnOrderings(column),
  );

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

  $$UsersTableOrderingComposer get completedByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.completedByUserId,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<int> get taskScheduleId => $composableBuilder(
    column: $table.taskScheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFieldValuesJson => $composableBuilder(
    column: $table.customFieldValuesJson,
    builder: (column) => column,
  );

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

  $$UsersTableAnnotationComposer get completedByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.completedByUserId,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> triggerNotificationsRefs<T extends Object>(
    Expression<T> Function($$TriggerNotificationsTableAnnotationComposer a) f,
  ) {
    final $$TriggerNotificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.triggerNotifications,
          getReferencedColumn: (t) => t.taskSubmissionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TriggerNotificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.triggerNotifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (TaskSubmissionEntity, $$TaskSubmissionsTableReferences),
          TaskSubmissionEntity,
          PrefetchHooks Function({
            bool equipmentInstanceId,
            bool completedByUserId,
            bool siteId,
            bool triggerNotificationsRefs,
          })
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
                Value<int?> taskScheduleId = const Value.absent(),
                Value<int?> taskTemplateGroupId = const Value.absent(),
                Value<int?> equipmentInstanceId = const Value.absent(),
                Value<String?> customFieldValuesJson = const Value.absent(),
                Value<int?> completedByUserId = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
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
                taskScheduleId: taskScheduleId,
                taskTemplateGroupId: taskTemplateGroupId,
                equipmentInstanceId: equipmentInstanceId,
                customFieldValuesJson: customFieldValuesJson,
                completedByUserId: completedByUserId,
                siteId: siteId,
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
                Value<int?> taskScheduleId = const Value.absent(),
                Value<int?> taskTemplateGroupId = const Value.absent(),
                Value<int?> equipmentInstanceId = const Value.absent(),
                Value<String?> customFieldValuesJson = const Value.absent(),
                Value<int?> completedByUserId = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
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
                taskScheduleId: taskScheduleId,
                taskTemplateGroupId: taskTemplateGroupId,
                equipmentInstanceId: equipmentInstanceId,
                customFieldValuesJson: customFieldValuesJson,
                completedByUserId: completedByUserId,
                siteId: siteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskSubmissionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                equipmentInstanceId = false,
                completedByUserId = false,
                siteId = false,
                triggerNotificationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (triggerNotificationsRefs) db.triggerNotifications,
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
                        if (equipmentInstanceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipmentInstanceId,
                                    referencedTable:
                                        $$TaskSubmissionsTableReferences
                                            ._equipmentInstanceIdTable(db),
                                    referencedColumn:
                                        $$TaskSubmissionsTableReferences
                                            ._equipmentInstanceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (completedByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.completedByUserId,
                                    referencedTable:
                                        $$TaskSubmissionsTableReferences
                                            ._completedByUserIdTable(db),
                                    referencedColumn:
                                        $$TaskSubmissionsTableReferences
                                            ._completedByUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$TaskSubmissionsTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$TaskSubmissionsTableReferences
                                            ._siteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (triggerNotificationsRefs)
                        await $_getPrefetchedData<
                          TaskSubmissionEntity,
                          $TaskSubmissionsTable,
                          TriggerNotificationEntity
                        >(
                          currentTable: table,
                          referencedTable: $$TaskSubmissionsTableReferences
                              ._triggerNotificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskSubmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).triggerNotificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskSubmissionId == item.id,
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
      (TaskSubmissionEntity, $$TaskSubmissionsTableReferences),
      TaskSubmissionEntity,
      PrefetchHooks Function({
        bool equipmentInstanceId,
        bool completedByUserId,
        bool siteId,
        bool triggerNotificationsRefs,
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
      Value<String?> priority,
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
      Value<String?> priority,
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

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
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

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
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

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

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
                Value<String?> priority = const Value.absent(),
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
                priority: priority,
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
                Value<String?> priority = const Value.absent(),
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
                priority: priority,
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
      Value<int?> siteId,
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
      Value<int?> siteId,
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

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('task_schedules__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
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
            bool siteId,
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
                Value<int?> siteId = const Value.absent(),
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
                siteId: siteId,
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
                Value<int?> siteId = const Value.absent(),
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
                siteId: siteId,
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
                siteId = false,
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
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$TaskSchedulesTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$TaskSchedulesTableReferences
                                            ._siteIdTable(db)
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
        bool siteId,
      })
    >;
typedef $$ShiftHandoverNotesTableCreateCompanionBuilder =
    ShiftHandoverNotesCompanion Function({
      Value<int> id,
      required int authorUserId,
      required String note,
      required DateTime createdAt,
      Value<int?> siteId,
    });
typedef $$ShiftHandoverNotesTableUpdateCompanionBuilder =
    ShiftHandoverNotesCompanion Function({
      Value<int> id,
      Value<int> authorUserId,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<int?> siteId,
    });

final class $$ShiftHandoverNotesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftHandoverNotesTable,
          ShiftHandoverNoteEntity
        > {
  $$ShiftHandoverNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _authorUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('shift_handover_notes__author_user_id__users__id');

  $$UsersTableProcessedTableManager get authorUserId {
    final $_column = $_itemColumn<int>('author_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_authorUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('shift_handover_notes__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftHandoverNotesTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftHandoverNotesTable> {
  $$ShiftHandoverNotesTableFilterComposer({
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get authorUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorUserId,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftHandoverNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftHandoverNotesTable> {
  $$ShiftHandoverNotesTableOrderingComposer({
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get authorUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorUserId,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftHandoverNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftHandoverNotesTable> {
  $$ShiftHandoverNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get authorUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorUserId,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftHandoverNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftHandoverNotesTable,
          ShiftHandoverNoteEntity,
          $$ShiftHandoverNotesTableFilterComposer,
          $$ShiftHandoverNotesTableOrderingComposer,
          $$ShiftHandoverNotesTableAnnotationComposer,
          $$ShiftHandoverNotesTableCreateCompanionBuilder,
          $$ShiftHandoverNotesTableUpdateCompanionBuilder,
          (ShiftHandoverNoteEntity, $$ShiftHandoverNotesTableReferences),
          ShiftHandoverNoteEntity,
          PrefetchHooks Function({bool authorUserId, bool siteId})
        > {
  $$ShiftHandoverNotesTableTableManager(
    _$AppDatabase db,
    $ShiftHandoverNotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftHandoverNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftHandoverNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftHandoverNotesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> authorUserId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
              }) => ShiftHandoverNotesCompanion(
                id: id,
                authorUserId: authorUserId,
                note: note,
                createdAt: createdAt,
                siteId: siteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int authorUserId,
                required String note,
                required DateTime createdAt,
                Value<int?> siteId = const Value.absent(),
              }) => ShiftHandoverNotesCompanion.insert(
                id: id,
                authorUserId: authorUserId,
                note: note,
                createdAt: createdAt,
                siteId: siteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftHandoverNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({authorUserId = false, siteId = false}) {
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
                    if (authorUserId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.authorUserId,
                                referencedTable:
                                    $$ShiftHandoverNotesTableReferences
                                        ._authorUserIdTable(db),
                                referencedColumn:
                                    $$ShiftHandoverNotesTableReferences
                                        ._authorUserIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (siteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.siteId,
                                referencedTable:
                                    $$ShiftHandoverNotesTableReferences
                                        ._siteIdTable(db),
                                referencedColumn:
                                    $$ShiftHandoverNotesTableReferences
                                        ._siteIdTable(db)
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

typedef $$ShiftHandoverNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftHandoverNotesTable,
      ShiftHandoverNoteEntity,
      $$ShiftHandoverNotesTableFilterComposer,
      $$ShiftHandoverNotesTableOrderingComposer,
      $$ShiftHandoverNotesTableAnnotationComposer,
      $$ShiftHandoverNotesTableCreateCompanionBuilder,
      $$ShiftHandoverNotesTableUpdateCompanionBuilder,
      (ShiftHandoverNoteEntity, $$ShiftHandoverNotesTableReferences),
      ShiftHandoverNoteEntity,
      PrefetchHooks Function({bool authorUserId, bool siteId})
    >;
typedef $$SessionSummariesTableCreateCompanionBuilder =
    SessionSummariesCompanion Function({
      Value<int> id,
      required int staffUserId,
      required String staffName,
      required int sentToManagerId,
      required int passCount,
      required int failCount,
      required String failedTaskTitlesJson,
      Value<String?> note,
      required DateTime sentAt,
      Value<bool> acknowledged,
      Value<DateTime?> acknowledgedAt,
      Value<int?> siteId,
    });
typedef $$SessionSummariesTableUpdateCompanionBuilder =
    SessionSummariesCompanion Function({
      Value<int> id,
      Value<int> staffUserId,
      Value<String> staffName,
      Value<int> sentToManagerId,
      Value<int> passCount,
      Value<int> failCount,
      Value<String> failedTaskTitlesJson,
      Value<String?> note,
      Value<DateTime> sentAt,
      Value<bool> acknowledged,
      Value<DateTime?> acknowledgedAt,
      Value<int?> siteId,
    });

final class $$SessionSummariesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SessionSummariesTable,
          SessionSummaryEntity
        > {
  $$SessionSummariesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _staffUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('session_summaries__staff_user_id__users__id');

  $$UsersTableProcessedTableManager get staffUserId {
    final $_column = $_itemColumn<int>('staff_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _sentToManagerIdTable(_$AppDatabase db) =>
      db.users.createAlias('session_summaries__sent_to_manager_id__users__id');

  $$UsersTableProcessedTableManager get sentToManagerId {
    final $_column = $_itemColumn<int>('sent_to_manager_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sentToManagerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('session_summaries__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableFilterComposer({
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

  ColumnFilters<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passCount => $composableBuilder(
    column: $table.passCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failCount => $composableBuilder(
    column: $table.failCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failedTaskTitlesJson => $composableBuilder(
    column: $table.failedTaskTitlesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get staffUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffUserId,
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

  $$UsersTableFilterComposer get sentToManagerId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentToManagerId,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableOrderingComposer({
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

  ColumnOrderings<String> get staffName => $composableBuilder(
    column: $table.staffName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passCount => $composableBuilder(
    column: $table.passCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failCount => $composableBuilder(
    column: $table.failCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failedTaskTitlesJson => $composableBuilder(
    column: $table.failedTaskTitlesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get staffUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffUserId,
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

  $$UsersTableOrderingComposer get sentToManagerId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentToManagerId,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get staffName =>
      $composableBuilder(column: $table.staffName, builder: (column) => column);

  GeneratedColumn<int> get passCount =>
      $composableBuilder(column: $table.passCount, builder: (column) => column);

  GeneratedColumn<int> get failCount =>
      $composableBuilder(column: $table.failCount, builder: (column) => column);

  GeneratedColumn<String> get failedTaskTitlesJson => $composableBuilder(
    column: $table.failedTaskTitlesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get staffUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffUserId,
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

  $$UsersTableAnnotationComposer get sentToManagerId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentToManagerId,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionSummariesTable,
          SessionSummaryEntity,
          $$SessionSummariesTableFilterComposer,
          $$SessionSummariesTableOrderingComposer,
          $$SessionSummariesTableAnnotationComposer,
          $$SessionSummariesTableCreateCompanionBuilder,
          $$SessionSummariesTableUpdateCompanionBuilder,
          (SessionSummaryEntity, $$SessionSummariesTableReferences),
          SessionSummaryEntity,
          PrefetchHooks Function({
            bool staffUserId,
            bool sentToManagerId,
            bool siteId,
          })
        > {
  $$SessionSummariesTableTableManager(
    _$AppDatabase db,
    $SessionSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> staffUserId = const Value.absent(),
                Value<String> staffName = const Value.absent(),
                Value<int> sentToManagerId = const Value.absent(),
                Value<int> passCount = const Value.absent(),
                Value<int> failCount = const Value.absent(),
                Value<String> failedTaskTitlesJson = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<bool> acknowledged = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
              }) => SessionSummariesCompanion(
                id: id,
                staffUserId: staffUserId,
                staffName: staffName,
                sentToManagerId: sentToManagerId,
                passCount: passCount,
                failCount: failCount,
                failedTaskTitlesJson: failedTaskTitlesJson,
                note: note,
                sentAt: sentAt,
                acknowledged: acknowledged,
                acknowledgedAt: acknowledgedAt,
                siteId: siteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int staffUserId,
                required String staffName,
                required int sentToManagerId,
                required int passCount,
                required int failCount,
                required String failedTaskTitlesJson,
                Value<String?> note = const Value.absent(),
                required DateTime sentAt,
                Value<bool> acknowledged = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
              }) => SessionSummariesCompanion.insert(
                id: id,
                staffUserId: staffUserId,
                staffName: staffName,
                sentToManagerId: sentToManagerId,
                passCount: passCount,
                failCount: failCount,
                failedTaskTitlesJson: failedTaskTitlesJson,
                note: note,
                sentAt: sentAt,
                acknowledged: acknowledged,
                acknowledgedAt: acknowledgedAt,
                siteId: siteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionSummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({staffUserId = false, sentToManagerId = false, siteId = false}) {
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
                        if (staffUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.staffUserId,
                                    referencedTable:
                                        $$SessionSummariesTableReferences
                                            ._staffUserIdTable(db),
                                    referencedColumn:
                                        $$SessionSummariesTableReferences
                                            ._staffUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sentToManagerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sentToManagerId,
                                    referencedTable:
                                        $$SessionSummariesTableReferences
                                            ._sentToManagerIdTable(db),
                                    referencedColumn:
                                        $$SessionSummariesTableReferences
                                            ._sentToManagerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$SessionSummariesTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$SessionSummariesTableReferences
                                            ._siteIdTable(db)
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

typedef $$SessionSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionSummariesTable,
      SessionSummaryEntity,
      $$SessionSummariesTableFilterComposer,
      $$SessionSummariesTableOrderingComposer,
      $$SessionSummariesTableAnnotationComposer,
      $$SessionSummariesTableCreateCompanionBuilder,
      $$SessionSummariesTableUpdateCompanionBuilder,
      (SessionSummaryEntity, $$SessionSummariesTableReferences),
      SessionSummaryEntity,
      PrefetchHooks Function({
        bool staffUserId,
        bool sentToManagerId,
        bool siteId,
      })
    >;
typedef $$NotificationRulesTableCreateCompanionBuilder =
    NotificationRulesCompanion Function({
      Value<int> id,
      required int ruleGroupId,
      required int versionNumber,
      Value<int?> previousVersionId,
      Value<int?> taskTemplateGroupId,
      Value<String?> targetRoleTier,
      Value<int?> targetUserId,
      Value<bool> channelPush,
      Value<bool> channelEmail,
      required int setByUserId,
      required String setByTier,
      Value<bool> active,
      required DateTime createdAt,
      Value<int?> siteId,
    });
typedef $$NotificationRulesTableUpdateCompanionBuilder =
    NotificationRulesCompanion Function({
      Value<int> id,
      Value<int> ruleGroupId,
      Value<int> versionNumber,
      Value<int?> previousVersionId,
      Value<int?> taskTemplateGroupId,
      Value<String?> targetRoleTier,
      Value<int?> targetUserId,
      Value<bool> channelPush,
      Value<bool> channelEmail,
      Value<int> setByUserId,
      Value<String> setByTier,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<int?> siteId,
    });

final class $$NotificationRulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NotificationRulesTable,
          NotificationRuleEntity
        > {
  $$NotificationRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NotificationRulesTable _previousVersionIdTable(_$AppDatabase db) =>
      db.notificationRules.createAlias(
        'notification_rules__previous_version_id__notification_rules__id',
      );

  $$NotificationRulesTableProcessedTableManager? get previousVersionId {
    final $_column = $_itemColumn<int>('previous_version_id');
    if ($_column == null) return null;
    final manager = $$NotificationRulesTableTableManager(
      $_db,
      $_db.notificationRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_previousVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _targetUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('notification_rules__target_user_id__users__id');

  $$UsersTableProcessedTableManager? get targetUserId {
    final $_column = $_itemColumn<int>('target_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _setByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias('notification_rules__set_by_user_id__users__id');

  $$UsersTableProcessedTableManager get setByUserId {
    final $_column = $_itemColumn<int>('set_by_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_setByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('notification_rules__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TriggerNotificationsTable,
    List<TriggerNotificationEntity>
  >
  _triggerNotificationsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.triggerNotifications,
    aliasName:
        'notification_rules__id__trigger_notifications__notification_rule_id',
  );

  $$TriggerNotificationsTableProcessedTableManager
  get triggerNotificationsRefs {
    final manager =
        $$TriggerNotificationsTableTableManager(
          $_db,
          $_db.triggerNotifications,
        ).filter(
          (f) => f.notificationRuleId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _triggerNotificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotificationRulesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableFilterComposer({
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

  ColumnFilters<int> get ruleGroupId => $composableBuilder(
    column: $table.ruleGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetRoleTier => $composableBuilder(
    column: $table.targetRoleTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get channelPush => $composableBuilder(
    column: $table.channelPush,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get channelEmail => $composableBuilder(
    column: $table.channelEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setByTier => $composableBuilder(
    column: $table.setByTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotificationRulesTableFilterComposer get previousVersionId {
    final $$NotificationRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousVersionId,
      referencedTable: $db.notificationRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationRulesTableFilterComposer(
            $db: $db,
            $table: $db.notificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get targetUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetUserId,
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

  $$UsersTableFilterComposer get setByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setByUserId,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> triggerNotificationsRefs(
    Expression<bool> Function($$TriggerNotificationsTableFilterComposer f) f,
  ) {
    final $$TriggerNotificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerNotifications,
      getReferencedColumn: (t) => t.notificationRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerNotificationsTableFilterComposer(
            $db: $db,
            $table: $db.triggerNotifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotificationRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableOrderingComposer({
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

  ColumnOrderings<int> get ruleGroupId => $composableBuilder(
    column: $table.ruleGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetRoleTier => $composableBuilder(
    column: $table.targetRoleTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get channelPush => $composableBuilder(
    column: $table.channelPush,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get channelEmail => $composableBuilder(
    column: $table.channelEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setByTier => $composableBuilder(
    column: $table.setByTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotificationRulesTableOrderingComposer get previousVersionId {
    final $$NotificationRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousVersionId,
      referencedTable: $db.notificationRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationRulesTableOrderingComposer(
            $db: $db,
            $table: $db.notificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get targetUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetUserId,
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

  $$UsersTableOrderingComposer get setByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setByUserId,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotificationRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ruleGroupId => $composableBuilder(
    column: $table.ruleGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskTemplateGroupId => $composableBuilder(
    column: $table.taskTemplateGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetRoleTier => $composableBuilder(
    column: $table.targetRoleTier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get channelPush => $composableBuilder(
    column: $table.channelPush,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get channelEmail => $composableBuilder(
    column: $table.channelEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setByTier =>
      $composableBuilder(column: $table.setByTier, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NotificationRulesTableAnnotationComposer get previousVersionId {
    final $$NotificationRulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.previousVersionId,
          referencedTable: $db.notificationRules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationRulesTableAnnotationComposer(
                $db: $db,
                $table: $db.notificationRules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$UsersTableAnnotationComposer get targetUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetUserId,
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

  $$UsersTableAnnotationComposer get setByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setByUserId,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> triggerNotificationsRefs<T extends Object>(
    Expression<T> Function($$TriggerNotificationsTableAnnotationComposer a) f,
  ) {
    final $$TriggerNotificationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.triggerNotifications,
          getReferencedColumn: (t) => t.notificationRuleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TriggerNotificationsTableAnnotationComposer(
                $db: $db,
                $table: $db.triggerNotifications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$NotificationRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationRulesTable,
          NotificationRuleEntity,
          $$NotificationRulesTableFilterComposer,
          $$NotificationRulesTableOrderingComposer,
          $$NotificationRulesTableAnnotationComposer,
          $$NotificationRulesTableCreateCompanionBuilder,
          $$NotificationRulesTableUpdateCompanionBuilder,
          (NotificationRuleEntity, $$NotificationRulesTableReferences),
          NotificationRuleEntity,
          PrefetchHooks Function({
            bool previousVersionId,
            bool targetUserId,
            bool setByUserId,
            bool siteId,
            bool triggerNotificationsRefs,
          })
        > {
  $$NotificationRulesTableTableManager(
    _$AppDatabase db,
    $NotificationRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationRulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ruleGroupId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<int?> previousVersionId = const Value.absent(),
                Value<int?> taskTemplateGroupId = const Value.absent(),
                Value<String?> targetRoleTier = const Value.absent(),
                Value<int?> targetUserId = const Value.absent(),
                Value<bool> channelPush = const Value.absent(),
                Value<bool> channelEmail = const Value.absent(),
                Value<int> setByUserId = const Value.absent(),
                Value<String> setByTier = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
              }) => NotificationRulesCompanion(
                id: id,
                ruleGroupId: ruleGroupId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                taskTemplateGroupId: taskTemplateGroupId,
                targetRoleTier: targetRoleTier,
                targetUserId: targetUserId,
                channelPush: channelPush,
                channelEmail: channelEmail,
                setByUserId: setByUserId,
                setByTier: setByTier,
                active: active,
                createdAt: createdAt,
                siteId: siteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ruleGroupId,
                required int versionNumber,
                Value<int?> previousVersionId = const Value.absent(),
                Value<int?> taskTemplateGroupId = const Value.absent(),
                Value<String?> targetRoleTier = const Value.absent(),
                Value<int?> targetUserId = const Value.absent(),
                Value<bool> channelPush = const Value.absent(),
                Value<bool> channelEmail = const Value.absent(),
                required int setByUserId,
                required String setByTier,
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                Value<int?> siteId = const Value.absent(),
              }) => NotificationRulesCompanion.insert(
                id: id,
                ruleGroupId: ruleGroupId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                taskTemplateGroupId: taskTemplateGroupId,
                targetRoleTier: targetRoleTier,
                targetUserId: targetUserId,
                channelPush: channelPush,
                channelEmail: channelEmail,
                setByUserId: setByUserId,
                setByTier: setByTier,
                active: active,
                createdAt: createdAt,
                siteId: siteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotificationRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                previousVersionId = false,
                targetUserId = false,
                setByUserId = false,
                siteId = false,
                triggerNotificationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (triggerNotificationsRefs) db.triggerNotifications,
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
                        if (previousVersionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.previousVersionId,
                                    referencedTable:
                                        $$NotificationRulesTableReferences
                                            ._previousVersionIdTable(db),
                                    referencedColumn:
                                        $$NotificationRulesTableReferences
                                            ._previousVersionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (targetUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.targetUserId,
                                    referencedTable:
                                        $$NotificationRulesTableReferences
                                            ._targetUserIdTable(db),
                                    referencedColumn:
                                        $$NotificationRulesTableReferences
                                            ._targetUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (setByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.setByUserId,
                                    referencedTable:
                                        $$NotificationRulesTableReferences
                                            ._setByUserIdTable(db),
                                    referencedColumn:
                                        $$NotificationRulesTableReferences
                                            ._setByUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$NotificationRulesTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$NotificationRulesTableReferences
                                            ._siteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (triggerNotificationsRefs)
                        await $_getPrefetchedData<
                          NotificationRuleEntity,
                          $NotificationRulesTable,
                          TriggerNotificationEntity
                        >(
                          currentTable: table,
                          referencedTable: $$NotificationRulesTableReferences
                              ._triggerNotificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotificationRulesTableReferences(
                                db,
                                table,
                                p0,
                              ).triggerNotificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.notificationRuleId == item.id,
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

typedef $$NotificationRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationRulesTable,
      NotificationRuleEntity,
      $$NotificationRulesTableFilterComposer,
      $$NotificationRulesTableOrderingComposer,
      $$NotificationRulesTableAnnotationComposer,
      $$NotificationRulesTableCreateCompanionBuilder,
      $$NotificationRulesTableUpdateCompanionBuilder,
      (NotificationRuleEntity, $$NotificationRulesTableReferences),
      NotificationRuleEntity,
      PrefetchHooks Function({
        bool previousVersionId,
        bool targetUserId,
        bool setByUserId,
        bool siteId,
        bool triggerNotificationsRefs,
      })
    >;
typedef $$TriggerNotificationsTableCreateCompanionBuilder =
    TriggerNotificationsCompanion Function({
      Value<int> id,
      required int notificationRuleId,
      required int taskSubmissionId,
      required int recipientUserId,
      required String message,
      required int siteId,
      required DateTime createdAt,
      Value<bool> acknowledged,
      Value<DateTime?> acknowledgedAt,
      Value<String?> originTargetRoleTier,
      Value<DateTime?> escalatedAt,
    });
typedef $$TriggerNotificationsTableUpdateCompanionBuilder =
    TriggerNotificationsCompanion Function({
      Value<int> id,
      Value<int> notificationRuleId,
      Value<int> taskSubmissionId,
      Value<int> recipientUserId,
      Value<String> message,
      Value<int> siteId,
      Value<DateTime> createdAt,
      Value<bool> acknowledged,
      Value<DateTime?> acknowledgedAt,
      Value<String?> originTargetRoleTier,
      Value<DateTime?> escalatedAt,
    });

final class $$TriggerNotificationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TriggerNotificationsTable,
          TriggerNotificationEntity
        > {
  $$TriggerNotificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NotificationRulesTable _notificationRuleIdTable(_$AppDatabase db) =>
      db.notificationRules.createAlias(
        'trigger_notifications__notification_rule_id__notification_rules__id',
      );

  $$NotificationRulesTableProcessedTableManager get notificationRuleId {
    final $_column = $_itemColumn<int>('notification_rule_id')!;

    final manager = $$NotificationRulesTableTableManager(
      $_db,
      $_db.notificationRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_notificationRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskSubmissionsTable _taskSubmissionIdTable(_$AppDatabase db) =>
      db.taskSubmissions.createAlias(
        'trigger_notifications__task_submission_id__task_submissions__id',
      );

  $$TaskSubmissionsTableProcessedTableManager get taskSubmissionId {
    final $_column = $_itemColumn<int>('task_submission_id')!;

    final manager = $$TaskSubmissionsTableTableManager(
      $_db,
      $_db.taskSubmissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskSubmissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _recipientUserIdTable(_$AppDatabase db) => db.users
      .createAlias('trigger_notifications__recipient_user_id__users__id');

  $$UsersTableProcessedTableManager get recipientUserId {
    final $_column = $_itemColumn<int>('recipient_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipientUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('trigger_notifications__site_id__sites__id');

  $$SitesTableProcessedTableManager get siteId {
    final $_column = $_itemColumn<int>('site_id')!;

    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TriggerNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $TriggerNotificationsTable> {
  $$TriggerNotificationsTableFilterComposer({
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

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originTargetRoleTier => $composableBuilder(
    column: $table.originTargetRoleTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotificationRulesTableFilterComposer get notificationRuleId {
    final $$NotificationRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notificationRuleId,
      referencedTable: $db.notificationRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationRulesTableFilterComposer(
            $db: $db,
            $table: $db.notificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskSubmissionsTableFilterComposer get taskSubmissionId {
    final $$TaskSubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskSubmissionId,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get recipientUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientUserId,
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

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TriggerNotificationsTable> {
  $$TriggerNotificationsTableOrderingComposer({
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

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originTargetRoleTier => $composableBuilder(
    column: $table.originTargetRoleTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotificationRulesTableOrderingComposer get notificationRuleId {
    final $$NotificationRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notificationRuleId,
      referencedTable: $db.notificationRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotificationRulesTableOrderingComposer(
            $db: $db,
            $table: $db.notificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskSubmissionsTableOrderingComposer get taskSubmissionId {
    final $$TaskSubmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskSubmissionId,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get recipientUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientUserId,
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

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriggerNotificationsTable> {
  $$TriggerNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originTargetRoleTier => $composableBuilder(
    column: $table.originTargetRoleTier,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => column,
  );

  $$NotificationRulesTableAnnotationComposer get notificationRuleId {
    final $$NotificationRulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.notificationRuleId,
          referencedTable: $db.notificationRules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotificationRulesTableAnnotationComposer(
                $db: $db,
                $table: $db.notificationRules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TaskSubmissionsTableAnnotationComposer get taskSubmissionId {
    final $$TaskSubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskSubmissionId,
      referencedTable: $db.taskSubmissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskSubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskSubmissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get recipientUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientUserId,
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

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriggerNotificationsTable,
          TriggerNotificationEntity,
          $$TriggerNotificationsTableFilterComposer,
          $$TriggerNotificationsTableOrderingComposer,
          $$TriggerNotificationsTableAnnotationComposer,
          $$TriggerNotificationsTableCreateCompanionBuilder,
          $$TriggerNotificationsTableUpdateCompanionBuilder,
          (TriggerNotificationEntity, $$TriggerNotificationsTableReferences),
          TriggerNotificationEntity,
          PrefetchHooks Function({
            bool notificationRuleId,
            bool taskSubmissionId,
            bool recipientUserId,
            bool siteId,
          })
        > {
  $$TriggerNotificationsTableTableManager(
    _$AppDatabase db,
    $TriggerNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriggerNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriggerNotificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TriggerNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> notificationRuleId = const Value.absent(),
                Value<int> taskSubmissionId = const Value.absent(),
                Value<int> recipientUserId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int> siteId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> acknowledged = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<String?> originTargetRoleTier = const Value.absent(),
                Value<DateTime?> escalatedAt = const Value.absent(),
              }) => TriggerNotificationsCompanion(
                id: id,
                notificationRuleId: notificationRuleId,
                taskSubmissionId: taskSubmissionId,
                recipientUserId: recipientUserId,
                message: message,
                siteId: siteId,
                createdAt: createdAt,
                acknowledged: acknowledged,
                acknowledgedAt: acknowledgedAt,
                originTargetRoleTier: originTargetRoleTier,
                escalatedAt: escalatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int notificationRuleId,
                required int taskSubmissionId,
                required int recipientUserId,
                required String message,
                required int siteId,
                required DateTime createdAt,
                Value<bool> acknowledged = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<String?> originTargetRoleTier = const Value.absent(),
                Value<DateTime?> escalatedAt = const Value.absent(),
              }) => TriggerNotificationsCompanion.insert(
                id: id,
                notificationRuleId: notificationRuleId,
                taskSubmissionId: taskSubmissionId,
                recipientUserId: recipientUserId,
                message: message,
                siteId: siteId,
                createdAt: createdAt,
                acknowledged: acknowledged,
                acknowledgedAt: acknowledgedAt,
                originTargetRoleTier: originTargetRoleTier,
                escalatedAt: escalatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TriggerNotificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                notificationRuleId = false,
                taskSubmissionId = false,
                recipientUserId = false,
                siteId = false,
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
                        if (notificationRuleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.notificationRuleId,
                                    referencedTable:
                                        $$TriggerNotificationsTableReferences
                                            ._notificationRuleIdTable(db),
                                    referencedColumn:
                                        $$TriggerNotificationsTableReferences
                                            ._notificationRuleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (taskSubmissionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taskSubmissionId,
                                    referencedTable:
                                        $$TriggerNotificationsTableReferences
                                            ._taskSubmissionIdTable(db),
                                    referencedColumn:
                                        $$TriggerNotificationsTableReferences
                                            ._taskSubmissionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (recipientUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recipientUserId,
                                    referencedTable:
                                        $$TriggerNotificationsTableReferences
                                            ._recipientUserIdTable(db),
                                    referencedColumn:
                                        $$TriggerNotificationsTableReferences
                                            ._recipientUserIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (siteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.siteId,
                                    referencedTable:
                                        $$TriggerNotificationsTableReferences
                                            ._siteIdTable(db),
                                    referencedColumn:
                                        $$TriggerNotificationsTableReferences
                                            ._siteIdTable(db)
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

typedef $$TriggerNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriggerNotificationsTable,
      TriggerNotificationEntity,
      $$TriggerNotificationsTableFilterComposer,
      $$TriggerNotificationsTableOrderingComposer,
      $$TriggerNotificationsTableAnnotationComposer,
      $$TriggerNotificationsTableCreateCompanionBuilder,
      $$TriggerNotificationsTableUpdateCompanionBuilder,
      (TriggerNotificationEntity, $$TriggerNotificationsTableReferences),
      TriggerNotificationEntity,
      PrefetchHooks Function({
        bool notificationRuleId,
        bool taskSubmissionId,
        bool recipientUserId,
        bool siteId,
      })
    >;
typedef $$ThirdPartyContactsTableCreateCompanionBuilder =
    ThirdPartyContactsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> company,
      Value<String?> specialty,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
      Value<int?> siteId,
      required int createdByUserId,
      required DateTime createdAt,
      Value<bool> active,
    });
typedef $$ThirdPartyContactsTableUpdateCompanionBuilder =
    ThirdPartyContactsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> company,
      Value<String?> specialty,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
      Value<int?> siteId,
      Value<int> createdByUserId,
      Value<DateTime> createdAt,
      Value<bool> active,
    });

final class $$ThirdPartyContactsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ThirdPartyContactsTable,
          ThirdPartyContactEntity
        > {
  $$ThirdPartyContactsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('third_party_contacts__site_id__sites__id');

  $$SitesTableProcessedTableManager? get siteId {
    final $_column = $_itemColumn<int>('site_id');
    if ($_column == null) return null;
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _createdByUserIdTable(_$AppDatabase db) => db.users
      .createAlias('third_party_contacts__created_by_user_id__users__id');

  $$UsersTableProcessedTableManager get createdByUserId {
    final $_column = $_itemColumn<int>('created_by_user_id')!;

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

class $$ThirdPartyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ThirdPartyContactsTable> {
  $$ThirdPartyContactsTableFilterComposer({
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

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
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

class $$ThirdPartyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThirdPartyContactsTable> {
  $$ThirdPartyContactsTableOrderingComposer({
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

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
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

class $$ThirdPartyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThirdPartyContactsTable> {
  $$ThirdPartyContactsTableAnnotationComposer({
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

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
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

class $$ThirdPartyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThirdPartyContactsTable,
          ThirdPartyContactEntity,
          $$ThirdPartyContactsTableFilterComposer,
          $$ThirdPartyContactsTableOrderingComposer,
          $$ThirdPartyContactsTableAnnotationComposer,
          $$ThirdPartyContactsTableCreateCompanionBuilder,
          $$ThirdPartyContactsTableUpdateCompanionBuilder,
          (ThirdPartyContactEntity, $$ThirdPartyContactsTableReferences),
          ThirdPartyContactEntity,
          PrefetchHooks Function({bool siteId, bool createdByUserId})
        > {
  $$ThirdPartyContactsTableTableManager(
    _$AppDatabase db,
    $ThirdPartyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThirdPartyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThirdPartyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThirdPartyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                Value<int> createdByUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => ThirdPartyContactsCompanion(
                id: id,
                name: name,
                company: company,
                specialty: specialty,
                phone: phone,
                email: email,
                notes: notes,
                siteId: siteId,
                createdByUserId: createdByUserId,
                createdAt: createdAt,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> company = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> siteId = const Value.absent(),
                required int createdByUserId,
                required DateTime createdAt,
                Value<bool> active = const Value.absent(),
              }) => ThirdPartyContactsCompanion.insert(
                id: id,
                name: name,
                company: company,
                specialty: specialty,
                phone: phone,
                email: email,
                notes: notes,
                siteId: siteId,
                createdByUserId: createdByUserId,
                createdAt: createdAt,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ThirdPartyContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siteId = false, createdByUserId = false}) {
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
                    if (siteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.siteId,
                                referencedTable:
                                    $$ThirdPartyContactsTableReferences
                                        ._siteIdTable(db),
                                referencedColumn:
                                    $$ThirdPartyContactsTableReferences
                                        ._siteIdTable(db)
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
                                    $$ThirdPartyContactsTableReferences
                                        ._createdByUserIdTable(db),
                                referencedColumn:
                                    $$ThirdPartyContactsTableReferences
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

typedef $$ThirdPartyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThirdPartyContactsTable,
      ThirdPartyContactEntity,
      $$ThirdPartyContactsTableFilterComposer,
      $$ThirdPartyContactsTableOrderingComposer,
      $$ThirdPartyContactsTableAnnotationComposer,
      $$ThirdPartyContactsTableCreateCompanionBuilder,
      $$ThirdPartyContactsTableUpdateCompanionBuilder,
      (ThirdPartyContactEntity, $$ThirdPartyContactsTableReferences),
      ThirdPartyContactEntity,
      PrefetchHooks Function({bool siteId, bool createdByUserId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EquipmentTypesTableTableManager get equipmentTypes =>
      $$EquipmentTypesTableTableManager(_db, _db.equipmentTypes);
  $$OrganisationsTableTableManager get organisations =>
      $$OrganisationsTableTableManager(_db, _db.organisations);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$AreasTableTableManager get areas =>
      $$AreasTableTableManager(_db, _db.areas);
  $$EquipmentInstancesTableTableManager get equipmentInstances =>
      $$EquipmentInstancesTableTableManager(_db, _db.equipmentInstances);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TaskSubmissionsTableTableManager get taskSubmissions =>
      $$TaskSubmissionsTableTableManager(_db, _db.taskSubmissions);
  $$LegalLimitReferencesTableTableManager get legalLimitReferences =>
      $$LegalLimitReferencesTableTableManager(_db, _db.legalLimitReferences);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db, _db.taskTemplates);
  $$TaskSchedulesTableTableManager get taskSchedules =>
      $$TaskSchedulesTableTableManager(_db, _db.taskSchedules);
  $$ShiftHandoverNotesTableTableManager get shiftHandoverNotes =>
      $$ShiftHandoverNotesTableTableManager(_db, _db.shiftHandoverNotes);
  $$SessionSummariesTableTableManager get sessionSummaries =>
      $$SessionSummariesTableTableManager(_db, _db.sessionSummaries);
  $$NotificationRulesTableTableManager get notificationRules =>
      $$NotificationRulesTableTableManager(_db, _db.notificationRules);
  $$TriggerNotificationsTableTableManager get triggerNotifications =>
      $$TriggerNotificationsTableTableManager(_db, _db.triggerNotifications);
  $$ThirdPartyContactsTableTableManager get thirdPartyContacts =>
      $$ThirdPartyContactsTableTableManager(_db, _db.thirdPartyContacts);
}
