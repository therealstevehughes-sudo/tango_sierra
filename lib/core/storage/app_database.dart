import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../utils/pin_hasher.dart';

part 'app_database.g.dart';

@DataClassName('TaskSubmissionEntity')
class TaskSubmissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskTitle => text()();
  TextColumn get status => text()();
  TextColumn get completedBy => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get numericValue => text().nullable()();
  BoolColumn get photoAttached =>
      boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('UserEntity')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get jobTitle => text()();
  TextColumn get roleTier => text()();
  TextColumn get pinHash => text()();
  TextColumn get pinSalt => text()();
}

@DataClassName('EquipmentTypeEntity')
class EquipmentTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('LegalLimitReferenceEntity')
class LegalLimitReferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  RealColumn get legalMin => real().nullable()();
  RealColumn get legalMax => real().nullable()();
  TextColumn get unit => text()();
}

@DataClassName('TaskTemplateEntity')
class TaskTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateGroupId => integer()();
  IntColumn get versionNumber => integer()();
  IntColumn get previousVersionId =>
      integer().nullable().references(TaskTemplates, #id)();
  TextColumn get title => text()();
  TextColumn get segment => text()();
  TextColumn get applicableRoleTiers => text()();
  TextColumn get method => text()();
  BoolColumn get requiresPhoto =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get requiresNotes =>
      boolean().withDefault(const Constant(false))();
  TextColumn get customFieldsJson => text().nullable()();
  RealColumn get minLimit => real().nullable()();
  RealColumn get maxLimit => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get legalLimitCategory => text().nullable()();
  BoolColumn get isCritical => boolean().withDefault(const Constant(false))();
  BoolColumn get requiresCorrectiveActionOnFail =>
      boolean().withDefault(const Constant(false))();
  TextColumn get fixInstructions => text().nullable()();
  IntColumn get equipmentTypeId =>
      integer().nullable().references(EquipmentTypes, #id)();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get createdByUserId =>
      integer().nullable().references(Users, #id)();
}

@DataClassName('AreaEntity')
class Areas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('EquipmentInstanceEntity')
class EquipmentInstances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get equipmentTypeId =>
      integer().references(EquipmentTypes, #id)();
  IntColumn get areaId => integer().nullable().references(Areas, #id)();
}

@DriftDatabase(
  tables: [
    TaskSubmissions,
    Users,
    EquipmentTypes,
    LegalLimitReferences,
    TaskTemplates,
    Areas,
    EquipmentInstances,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(users);
      }
      if (from < 3) {
        // Two-tier (staff/manager) -> three-tier (top/mid/base) role rename.
        await (update(
          users,
        )..where((u) => u.roleTier.equals('staff'))).write(
          const UsersCompanion(roleTier: Value('base')),
        );
        await (update(
          users,
        )..where((u) => u.roleTier.equals('manager'))).write(
          const UsersCompanion(roleTier: Value('mid')),
        );
      }
      if (from < 4) {
        await m.createTable(equipmentTypes);
        await m.createTable(legalLimitReferences);
        await m.createTable(taskTemplates);
      }
      if (from < 5) {
        await m.createTable(areas);
        await m.createTable(equipmentInstances);
      }
    },
    beforeOpen: (details) async {
      final existingUsers = await select(users).get();
      if (existingUsers.isEmpty) {
        await _seedUsers();
      }

      final existingEquipmentTypes = await select(equipmentTypes).get();
      if (existingEquipmentTypes.isEmpty) {
        await _seedTaskLibraryReferenceData();
      }
    },
  );

  Future<void> _seedUsers() async {
    await _insertSeedUser(
      name: 'Steve Hughes',
      jobTitle: 'Kitchen Porter',
      roleTier: 'base',
      pin: '1111',
    );
    await _insertSeedUser(
      name: 'Aisha Khan',
      jobTitle: 'Line Chef',
      roleTier: 'base',
      pin: '2222',
    );
    await _insertSeedUser(
      name: 'Marta Nowak',
      jobTitle: 'Prep Chef',
      roleTier: 'base',
      pin: '3333',
    );
    await _insertSeedUser(
      name: 'Lewis Grant',
      jobTitle: 'Sous Chef',
      roleTier: 'base',
      pin: '4444',
    );
    await _insertSeedUser(
      name: 'Elena Petrov',
      jobTitle: 'Commis Chef',
      roleTier: 'base',
      pin: '5555',
    );
    await _insertSeedUser(
      name: 'Samir Ali',
      jobTitle: 'Grill Chef',
      roleTier: 'base',
      pin: '6666',
    );
    await _insertSeedUser(
      name: 'Jordan Blake',
      jobTitle: 'Head Chef / Kitchen Manager',
      roleTier: 'mid',
      pin: '9999',
    );
    await _insertSeedUser(
      name: 'Alex Rivera',
      jobTitle: 'Director / MD',
      roleTier: 'top',
      pin: '7777',
    );
  }

  Future<void> _insertSeedUser({
    required String name,
    required String jobTitle,
    required String roleTier,
    required String pin,
  }) {
    final salt = generateSalt();
    return into(users).insert(
      UsersCompanion.insert(
        name: name,
        jobTitle: jobTitle,
        roleTier: roleTier,
        pinHash: hashPin(pin, salt),
        pinSalt: salt,
      ),
    );
  }

  Future<void> _seedTaskLibraryReferenceData() async {
    final fridgeTypeId = await into(equipmentTypes).insert(
      EquipmentTypesCompanion.insert(name: 'Fridge'),
    );
    await into(equipmentTypes).insert(
      EquipmentTypesCompanion.insert(name: 'Freezer'),
    );
    await into(equipmentTypes).insert(
      EquipmentTypesCompanion.insert(name: 'Hot-hold unit'),
    );

    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'fridge_temp',
        legalMax: const Value(8.0),
        unit: 'celsius',
      ),
    );
    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'freezer_temp',
        legalMax: const Value(-18.0),
        unit: 'celsius',
      ),
    );
    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'hot_hold_temp',
        legalMin: const Value(63.0),
        unit: 'celsius',
      ),
    );

    final templateId = await into(taskTemplates).insert(
      TaskTemplatesCompanion.insert(
        templateGroupId: 0,
        versionNumber: 1,
        title: 'Check Fridge Temperature',
        segment: 'food_safety',
        applicableRoleTiers: 'base',
        method: 'numeric_photo',
        requiresPhoto: const Value(true),
        minLimit: const Value(2.0),
        maxLimit: const Value(8.0),
        unit: const Value('celsius'),
        legalLimitCategory: const Value('fridge_temp'),
        isCritical: const Value(true),
        requiresCorrectiveActionOnFail: const Value(true),
        fixInstructions: const Value(
          'Move stock to a working fridge and contact management immediately.',
        ),
        equipmentTypeId: Value(fridgeTypeId),
        createdAt: DateTime.now(),
      ),
    );
    await (update(
      taskTemplates,
    )..where((t) => t.id.equals(templateId))).write(
      TaskTemplatesCompanion(templateGroupId: Value(templateId)),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kitchen_control_db');
  }
}
