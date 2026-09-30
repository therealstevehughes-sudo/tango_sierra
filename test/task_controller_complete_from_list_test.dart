// Complete-from-the-list (2026-09-25) — regression coverage for the three
// real correctness bugs this feature could otherwise introduce, since a
// task can now be submitted out of the carousel's own strict order (see
// TaskController.completedTaskKeys/isCompleted's own doc comment):
//
// 1. nextTask() must skip past a task already completed out of order,
//    or the carousel would eventually reach it again and offer it for a
//    second, duplicate submission.
// 2. logRemainingAsNotCompleted() must skip it too, or leaving mid-shift
//    would log a bogus NOT_COMPLETED on top of its real PASS/FAIL.
// 3. hasRemainingTasks must reflect actual completion, not just
//    currentIndex position, or a worker who finished everything via the
//    list would still see a false "leave before finishing?" warning.
//
// Runs entirely in-memory (AppDatabase.forTesting) against real Drift
// repositories, same pattern as multi_site_isolation_test.dart — this is
// exactly the kind of subtle, safety-critical logic that deserves real
// coverage, not just manual verification.
//
// Run: flutter test test/task_controller_complete_from_list_test.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:venurite/core/storage/app_database.dart';
import 'package:venurite/features/tasks/task_controller.dart';
import 'package:venurite/shared/models/task_schedule.dart';
import 'package:venurite/shared/repositories/equipment_repository.dart';
import 'package:venurite/shared/repositories/notification_rule_repository.dart';
import 'package:venurite/shared/repositories/problem_register_repository.dart';
import 'package:venurite/shared/repositories/task_schedule_repository.dart';
import 'package:venurite/shared/repositories/task_submission_repository.dart';
import 'package:venurite/shared/repositories/task_template_repository.dart';
import 'package:venurite/shared/repositories/trigger_notification_repository.dart';
import 'package:venurite/shared/repositories/user_repository.dart';

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

  Future<int> seedUser({required String name, required int siteId}) => db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          name: name,
          jobTitle: 'Kitchen Assistant',
          roleTier: 'base',
          pinHash: 'hash',
          pinSalt: 'salt',
          siteId: Value(siteId),
        ),
      );

  Future<int> seedTemplate(String title) async {
    final id = await db
        .into(db.taskTemplates)
        .insert(
          TaskTemplatesCompanion.insert(
            templateGroupId: 0,
            versionNumber: 1,
            title: title,
            segment: 'food_safety',
            applicableRoleTiers: 'base',
            method: 'tick',
            createdAt: DateTime.now(),
          ),
        );
    await (db.update(db.taskTemplates)..where((t) => t.id.equals(id))).write(
      TaskTemplatesCompanion(templateGroupId: Value(id)),
    );
    return id;
  }

  Future<int> seedSchedule({
    required int templateGroupId,
    required int userId,
    required int siteId,
  }) => db
      .into(db.taskSchedules)
      .insert(
        TaskSchedulesCompanion.insert(
          taskTemplateGroupId: templateGroupId,
          assignedUserId: userId,
          frequency: ScheduleFrequency.asNeeded.name,
          assignedByUserId: userId,
          assignedAt: DateTime.now(),
          siteId: Value(siteId),
        ),
      );

  Future<TaskController> buildController({
    required int siteId,
    required int userId,
  }) async {
    final userRepo = DriftUserRepository(db);
    final user = (await userRepo.getForSite(
      siteId,
    )).firstWhere((u) => u.id == userId);
    return TaskController(
      DriftTaskSubmissionRepository(db),
      DriftTaskScheduleRepository(db),
      DriftTaskTemplateRepository(db),
      DriftEquipmentRepository(db),
      user,
      DriftNotificationRuleRepository(db),
      DriftTriggerNotificationRepository(db),
      userRepo,
      DriftProblemRegisterRepository(db),
    );
  }

  test(
    'nextTask() skips a task already completed out of order via the list',
    () async {
      final org = await seedOrganisation();
      final site = await seedSite(org, 'Venue A');
      final userId = await seedUser(name: 'Worker', siteId: site);
      final t0 = await seedTemplate('Fridge temperature');
      final t1 = await seedTemplate('Freezer temperature');
      final t2 = await seedTemplate('Cellar temperature');
      for (final t in [t0, t1, t2]) {
        await seedSchedule(templateGroupId: t, userId: userId, siteId: site);
      }

      final controller = await buildController(siteId: site, userId: userId);
      await controller.loadTasks();
      expect(controller.tasks.length, 3);
      expect(controller.currentIndex, 0);

      // Worker jumps ahead via the All Tasks list and completes the LAST
      // task first, out of carousel order.
      await controller.logTaskSubmission(
        task: controller.tasks[2],
        status: 'PASS',
        photoAttached: false,
      );
      expect(controller.isCompleted(controller.tasks[2]), isTrue);
      // The list-triggered detour never touches currentIndex itself (that
      // restoration is task_overview_screen.dart's own job) — still 0.
      expect(controller.currentIndex, 0);

      // Now the carousel proceeds normally: submit task 0, advance.
      await controller.logTaskSubmission(
        task: controller.tasks[0],
        status: 'PASS',
        photoAttached: false,
      );
      final hasSecond = controller.nextTask();
      expect(hasSecond, isTrue);
      expect(controller.currentIndex, 1);

      // Submit task 1, advance again — this is where the bug would show:
      // without the fix, nextTask() would land back on the ALREADY-DONE
      // task 2 and offer it again.
      await controller.logTaskSubmission(
        task: controller.tasks[1],
        status: 'PASS',
        photoAttached: false,
      );
      final hasThird = controller.nextTask();
      expect(
        hasThird,
        isFalse,
        reason:
            'task 2 was already completed via the list - nextTask() must '
            'skip past it, not offer it a second time',
      );
      expect(controller.hasRemainingTasks, isFalse);
    },
  );

  test('logRemainingAsNotCompleted() does not duplicate a task already '
      'completed via the list', () async {
    final org = await seedOrganisation();
    final site = await seedSite(org, 'Venue A');
    final userId = await seedUser(name: 'Worker', siteId: site);
    final t0 = await seedTemplate('Fridge temperature');
    final t1 = await seedTemplate('Freezer temperature');
    final t2 = await seedTemplate('Cellar temperature');
    for (final t in [t0, t1, t2]) {
      await seedSchedule(templateGroupId: t, userId: userId, siteId: site);
    }

    final controller = await buildController(siteId: site, userId: userId);
    await controller.loadTasks();

    // Complete the last task out of order via the list; currentIndex
    // stays at 0 (nothing else has been touched via the carousel yet).
    await controller.logTaskSubmission(
      task: controller.tasks[2],
      status: 'PASS',
      photoAttached: false,
    );

    // Worker leaves mid-shift with tasks 0 and 1 genuinely abandoned.
    await controller.logRemainingAsNotCompleted();

    final submissionRepo = DriftTaskSubmissionRepository(db);
    final all = await submissionRepo.getAll();
    final byTitle = {for (final s in all) s.taskTitle: s.status};

    expect(byTitle['Fridge temperature'], 'NOT_COMPLETED');
    expect(byTitle['Freezer temperature'], 'NOT_COMPLETED');
    expect(
      byTitle['Cellar temperature'],
      'PASS',
      reason:
          'already completed via the list - must keep its real PASS, '
          'never get overwritten/duplicated with a bogus NOT_COMPLETED',
    );
    expect(
      all.length,
      3,
      reason: 'exactly one submission per task, no duplicates',
    );
  });

  test('hasRemainingTasks is false once every remaining task is done via the '
      'list, even though currentIndex never advanced', () async {
    final org = await seedOrganisation();
    final site = await seedSite(org, 'Venue A');
    final userId = await seedUser(name: 'Worker', siteId: site);
    final t0 = await seedTemplate('Fridge temperature');
    final t1 = await seedTemplate('Freezer temperature');
    for (final t in [t0, t1]) {
      await seedSchedule(templateGroupId: t, userId: userId, siteId: site);
    }

    final controller = await buildController(siteId: site, userId: userId);
    await controller.loadTasks();
    expect(controller.hasRemainingTasks, isTrue);

    // Both tasks completed entirely via list detours - currentIndex
    // never moves off 0.
    await controller.logTaskSubmission(
      task: controller.tasks[0],
      status: 'PASS',
      photoAttached: false,
    );
    await controller.logTaskSubmission(
      task: controller.tasks[1],
      status: 'PASS',
      photoAttached: false,
    );
    expect(controller.currentIndex, 0);
    expect(
      controller.hasRemainingTasks,
      isFalse,
      reason:
          'both tasks are actually done - a "leave before finishing?" '
          'warning here would be a false alarm',
    );
  });
}
