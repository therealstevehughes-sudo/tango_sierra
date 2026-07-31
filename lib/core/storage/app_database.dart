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

@DriftDatabase(tables: [TaskSubmissions, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
    },
    beforeOpen: (details) async {
      final existingUsers = await select(users).get();
      if (existingUsers.isEmpty) {
        await _seedUsers();
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

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kitchen_control_db');
  }
}
