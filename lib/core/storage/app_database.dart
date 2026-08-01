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
  // Traceability back to what this submission actually fulfilled, added when
  // the carousel was wired to real schedules/templates instead of a
  // hardcoded queue (Sprint 010). Nullable: older rows predate this link.
  IntColumn get taskScheduleId => integer().nullable()();
  IntColumn get taskTemplateGroupId => integer().nullable()();
  IntColumn get equipmentInstanceId =>
      integer().nullable().references(EquipmentInstances, #id)();
  TextColumn get customFieldValuesJson => text().nullable()();
  // Added for reliable session-boundary queries (Sprint 013) — completedBy
  // is only a formatted display string, not a real reference.
  IntColumn get completedByUserId =>
      integer().nullable().references(Users, #id)();
}

@DataClassName('UserEntity')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get jobTitle => text()();
  TextColumn get roleTier => text()();
  TextColumn get pinHash => text()();
  TextColumn get pinSalt => text()();
  TextColumn get preferredTemperatureUnit =>
      text().withDefault(const Constant('celsius'))();
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

@DataClassName('TaskScheduleEntity')
class TaskSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Not a real FK: templateGroupId has no unique constraint on TaskTemplates
  // (it's a denormalized grouping key shared across version rows), so this
  // is a soft reference resolved at the application layer, not the DB layer.
  IntColumn get taskTemplateGroupId => integer()();
  IntColumn get assignedUserId => integer().references(Users, #id)();
  IntColumn get equipmentInstanceId =>
      integer().nullable().references(EquipmentInstances, #id)();
  TextColumn get frequency => text()();
  TextColumn get customFrequencyDetail => text().nullable()();
  IntColumn get assignedByUserId => integer().references(Users, #id)();
  DateTimeColumn get assignedAt => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

@DataClassName('ShiftHandoverNoteEntity')
class ShiftHandoverNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get authorUserId => integer().references(Users, #id)();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('SessionSummaryEntity')
class SessionSummaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffUserId => integer().references(Users, #id)();
  // Denormalized, matching TaskSubmissions.completedBy's existing pattern —
  // avoids a join just to render a name in the manager's inbox.
  TextColumn get staffName => text()();
  IntColumn get sentToManagerId => integer().references(Users, #id)();
  IntColumn get passCount => integer()();
  IntColumn get failCount => integer()();
  TextColumn get failedTaskTitlesJson => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  BoolColumn get acknowledged =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
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
    TaskSchedules,
    ShiftHandoverNotes,
    SessionSummaries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

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
      if (from < 6) {
        await m.createTable(taskSchedules);
      }
      if (from < 7) {
        await m.addColumn(taskSubmissions, taskSubmissions.taskScheduleId);
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.taskTemplateGroupId,
        );
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.equipmentInstanceId,
        );
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.customFieldValuesJson,
        );
        await m.addColumn(users, users.preferredTemperatureUnit);
      }
      if (from < 8) {
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.completedByUserId,
        );
        await m.createTable(shiftHandoverNotes);
        await m.createTable(sessionSummaries);
      }
    },
    beforeOpen: (details) async {
      final existingUsers = await select(users).get();
      if (existingUsers.isEmpty) {
        await _seedUsers();
      }

      // Always ensured (not gated on "table empty"), so an existing install
      // that only has the original 3 equipment types picks up the rest too.
      await _ensureExpandedEquipmentTypes();

      final existingLegalLimits = await select(legalLimitReferences).get();
      if (existingLegalLimits.isEmpty) {
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

  // Derived from the real venue checklist ("Full check list.docx") plus the
  // original 3 test rows — realistic commercial-kitchen equipment coverage,
  // not an exhaustive catalogue. Managers can still add anything missing via
  // the wizard's "Something else..." option.
  static const _expandedEquipmentTypeNames = [
    'Fridge',
    'Freezer',
    'Hot-hold unit',
    'Blast Chiller',
    'Walk-in Fridge',
    'Walk-in Freezer',
    'Fryer',
    'Oven',
    'Grill',
    'Salamander',
    'Hob',
    'Rotisserie',
    'Kebab Machine',
    'Bain-marie',
    'Steamer',
    'Dishwasher',
    'Ice Machine',
    'Prep Station',
  ];

  Future<void> _ensureExpandedEquipmentTypes() async {
    final existingNames = (await select(
      equipmentTypes,
    ).get()).map((row) => row.name).toSet();

    for (final name in _expandedEquipmentTypeNames) {
      if (!existingNames.contains(name)) {
        await into(
          equipmentTypes,
        ).insert(EquipmentTypesCompanion.insert(name: name));
      }
    }
  }

  Future<void> _seedTaskLibraryReferenceData() async {
    final fridgeType = await (select(
      equipmentTypes,
    )..where((t) => t.name.equals('Fridge'))).getSingle();

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
        equipmentTypeId: Value(fridgeType.id),
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
