// Multi-site isolation proof (Sprint 2 follow-up) — proves that the
// site-scoped repository reads DO NOT mix venues, at the local Drift layer.
//
// Context: "multi-site is only partially usable" was logged as a known gap
// (DECISIONS_LOG — Area/EquipmentInstance/TaskSchedule/User reads were
// unfiltered by site). Sprint 1 added getForSite() across those paths;
// this test pins the behaviour so a regression (a read accidentally
// reverting to getAll()) fails loudly.
//
// Scope: runs entirely in-memory (AppDatabase.forTesting), no device file,
// no live backend. It proves the *local* app-layer isolation; the backend
// path is additionally protected by RLS (proven separately in the
// phase_b* integration tests against the live backend).
//
// Run: flutter test test/multi_site_isolation_test.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/storage/app_database.dart';
import 'package:flutter_application_1/shared/models/task_schedule.dart';
import 'package:flutter_application_1/shared/models/user.dart';
import 'package:flutter_application_1/shared/repositories/area_repository.dart';
import 'package:flutter_application_1/shared/repositories/equipment_repository.dart';
import 'package:flutter_application_1/shared/repositories/task_schedule_repository.dart';
import 'package:flutter_application_1/shared/repositories/user_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> seedOrganisation() => db
      .into(db.organisations)
      .insert(
        OrganisationsCompanion.insert(
          name: 'Test Org',
          createdAt: DateTime.now(),
        ),
      );

  Future<int> seedSite(int organisationId, String name) => db
      .into(db.sites)
      .insert(
        SitesCompanion.insert(
          organisationId: organisationId,
          name: name,
          createdAt: DateTime.now(),
        ),
      );

  Future<int> seedUser({
    required String name,
    required int siteId,
    required RoleTier roleTier,
  }) => db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          name: name,
          jobTitle: 'Kitchen Assistant',
          roleTier: roleTier.name,
          pinHash: 'hash',
          pinSalt: 'salt',
          siteId: Value(siteId),
        ),
      );

  Future<int> seedArea({required String name, required int siteId}) => db
      .into(db.areas)
      .insert(AreasCompanion.insert(name: name, siteId: Value(siteId)));

  Future<int> seedEquipment({required String name, required int siteId}) async {
    final typeId = await db
        .into(db.equipmentTypes)
        .insert(EquipmentTypesCompanion.insert(name: 'Fridge'));
    return db
        .into(db.equipmentInstances)
        .insert(
          EquipmentInstancesCompanion.insert(
            name: name,
            equipmentTypeId: typeId,
            siteId: Value(siteId),
          ),
        );
  }

  Future<int> seedSchedule({
    required int templateGroupId,
    required int assignedUserId,
    required int siteId,
    required int assignedByUserId,
    int? equipmentInstanceId,
    required ScheduleFrequency frequency,
  }) => db
      .into(db.taskSchedules)
      .insert(
        TaskSchedulesCompanion.insert(
          taskTemplateGroupId: templateGroupId,
          assignedUserId: assignedUserId,
          equipmentInstanceId: Value(equipmentInstanceId),
          frequency: frequency.name,
          assignedByUserId: assignedByUserId,
          assignedAt: DateTime.now(),
          siteId: Value(siteId),
        ),
      );

  test('Users: getForSite returns only that site\'s staff', () async {
    final org = await seedOrganisation();
    final siteA = await seedSite(org, 'Venue A');
    final siteB = await seedSite(org, 'Venue B');
    await seedUser(
      name: 'Alice',
      siteId: siteA,
      roleTier: RoleTier.venueManager,
    );
    await seedUser(name: 'Bob', siteId: siteB, roleTier: RoleTier.base);

    final repo = DriftUserRepository(db);
    final a = await repo.getForSite(siteA);
    final b = await repo.getForSite(siteB);

    expect(a.map((u) => u.name), ['Alice']);
    expect(b.map((u) => u.name), ['Bob']);
  });

  test('Areas: getForSite returns only that site\'s areas', () async {
    final org = await seedOrganisation();
    final siteA = await seedSite(org, 'Venue A');
    final siteB = await seedSite(org, 'Venue B');
    await seedArea(name: 'Walk-in', siteId: siteA);
    await seedArea(name: 'Prep', siteId: siteB);

    final repo = DriftAreaRepository(db);
    final a = await repo.getForSite(siteA);
    final b = await repo.getForSite(siteB);

    expect(a.map((x) => x.name), ['Walk-in']);
    expect(b.map((x) => x.name), ['Prep']);
  });

  test('Equipment: getForSite returns only that site\'s instances', () async {
    final org = await seedOrganisation();
    final siteA = await seedSite(org, 'Venue A');
    final siteB = await seedSite(org, 'Venue B');
    await seedEquipment(name: 'Fridge A1', siteId: siteA);
    await seedEquipment(name: 'Fridge B1', siteId: siteB);

    final repo = DriftEquipmentRepository(db);
    final a = await repo.getForSite(siteA);
    final b = await repo.getForSite(siteB);

    expect(a.map((e) => e.name), ['Fridge A1']);
    expect(b.map((e) => e.name), ['Fridge B1']);
  });

  test(
    'TaskSchedules: getForSite returns only that site\'s schedules',
    () async {
      final org = await seedOrganisation();
      final siteA = await seedSite(org, 'Venue A');
      final siteB = await seedSite(org, 'Venue B');
      final manager = await seedUser(
        name: 'Mgr',
        siteId: siteA,
        roleTier: RoleTier.venueManager,
      );
      final alice = await seedUser(
        name: 'Alice',
        siteId: siteA,
        roleTier: RoleTier.base,
      );
      final bob = await seedUser(
        name: 'Bob',
        siteId: siteB,
        roleTier: RoleTier.base,
      );
      // A template group per venue's task (groupId is a soft reference).
      await seedSchedule(
        templateGroupId: 1,
        assignedUserId: alice,
        assignedByUserId: manager,
        siteId: siteA,
        frequency: ScheduleFrequency.daily,
      );
      await seedSchedule(
        templateGroupId: 2,
        assignedUserId: bob,
        assignedByUserId: manager,
        siteId: siteB,
        frequency: ScheduleFrequency.daily,
      );

      final repo = DriftTaskScheduleRepository(db);
      final a = await repo.getForSite(siteA);
      final b = await repo.getForSite(siteB);

      // One schedule per site: each sees exactly its own.
      expect(a.length, 1);
      expect(b.length, 1);
      expect(a.single.taskTemplateGroupId, 1);
      expect(b.single.taskTemplateGroupId, 2);
    },
  );
}
