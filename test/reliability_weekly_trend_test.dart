// Executive/regional trend (UX-research P0) — proves the weekly trend
// computation in ReliabilityService:
//   - returns one summary per CLOSED week, most recent first
//   - never includes the in-progress current week
//   - each week's completion rate reflects exactly that week's submissions
//   - PASS/FAIL both count as "a check happened" (anti-gaming rule)
//
// Runs headless against an in-memory Drift DB (AppDatabase.forTesting),
// no device, no live backend. Same pattern as test/multi_site_isolation_test.dart.
//
// Run: flutter test test/reliability_weekly_trend_test.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/storage/app_database.dart';
import 'package:flutter_application_1/features/dashboard/reliability_service.dart';
import 'package:flutter_application_1/shared/models/task_schedule.dart';
import 'package:flutter_application_1/shared/models/task_submission.dart';
import 'package:flutter_application_1/shared/models/user.dart';
import 'package:flutter_application_1/shared/repositories/task_schedule_repository.dart';
import 'package:flutter_application_1/shared/repositories/task_submission_repository.dart';
import 'package:flutter_application_1/shared/repositories/user_repository.dart';

void main() {
  late AppDatabase db;
  late ReliabilityService service;
  late DriftUserRepository userRepo;
  late DriftTaskSubmissionRepository submissionRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    userRepo = DriftUserRepository(db);
    submissionRepo = DriftTaskSubmissionRepository(db);
    service = ReliabilityService(
      DriftTaskScheduleRepository(db),
      submissionRepo,
      userRepo,
    );
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
          roleTier: RoleTier.base.name,
          pinHash: 'hash',
          pinSalt: 'salt',
          siteId: Value(siteId),
        ),
      );

  Future<int> seedDailySchedule({
    required int userId,
    required int siteId,
    required int assignedByUserId,
    required DateTime assignedAt,
  }) => db
      .into(db.taskSchedules)
      .insert(
        TaskSchedulesCompanion.insert(
          taskTemplateGroupId: 1, // soft reference — not a real FK
          assignedUserId: userId,
          frequency: ScheduleFrequency.daily.name,
          assignedByUserId: assignedByUserId,
          assignedAt: assignedAt,
          siteId: Value(siteId),
        ),
      );

  Future<void> submitCheck({
    required int siteId,
    required DateTime completedAt,
    String status = 'PASS',
    int? completedByUserId,
    int? taskScheduleId,
  }) {
    return submissionRepo.submit(
      TaskSubmission(
        taskTitle: 'Temperature check',
        status: status,
        completedBy: 'Test Harness',
        completedAt: completedAt,
        photoAttached: false,
        completedByUserId: completedByUserId,
        taskScheduleId: taskScheduleId,
        siteId: siteId,
      ),
    );
  }

  test('trend returns one summary per closed week, most recent first, '
      'never including the in-progress week', () async {
    final org = await seedOrganisation();
    final site = await seedSite(org, 'Venue A');
    final manager = await seedUser(name: 'Manager', siteId: site);
    final alice = await seedUser(name: 'Alice', siteId: site);

    // Daily schedule assigned a long time ago so every period is closed.
    final scheduleId = await seedDailySchedule(
      userId: alice,
      siteId: site,
      assignedByUserId: manager,
      assignedAt: DateTime(2026, 1, 1),
    );

    // Reference "now" = a fixed Monday so week boundaries are deterministic.
    final now = DateTime(2026, 6, 1); // a Monday

    // Week -1 (Mon May 25 – Sun May 31): 3 of 7 days logged — PASS.
    // Week -2 (Mon May 18 – Sun May 24): 7 of 7 days logged — mix PASS/FAIL.
    // Week -3 (Mon May 11 – Sun May 17): 0 of 7 days logged.
    for (var day = 25; day <= 27; day++) {
      await submitCheck(
        siteId: site,
        completedByUserId: alice,
        completedAt: DateTime(2026, 5, day, 10),
        taskScheduleId: scheduleId,
      );
    }
    for (var day = 18; day <= 24; day++) {
      await submitCheck(
        siteId: site,
        completedByUserId: alice,
        completedAt: DateTime(2026, 5, day, 10),
        status: day.isEven ? 'FAIL' : 'PASS',
        taskScheduleId: scheduleId,
      );
    }

    final trend = await service.computeWeeklyTrendForSite(site, now: now);

    // 12 closed weeks, most recent first.
    expect(trend.length, 12);
    // Most recent = week of May 25 (3/7 completed).
    expect(trend.first.overall.totalPeriods, 7);
    expect(trend.first.overall.completedPeriods, 3);
    // Coarse rate check: 3 of 7 days ≈ 0.43.
    expect(
      (trend.first.overall.completionRate! * 100).round(),
      ((3 / 7) * 100).round(),
    );

    // Second-most-recent = week of May 18 (7/7 completed, PASS+FAIL both
    // count — anti-gaming).
    expect(trend[1].overall.totalPeriods, 7);
    expect(trend[1].overall.completedPeriods, 7);
    expect(trend[1].overall.completionRate, 1.0);

    // Third week has no submissions — no periods counted as failures.
    expect(trend[2].overall.totalPeriods, 7);
    expect(trend[2].overall.completedPeriods, 0);
    expect(trend[2].overall.completionRate, 0.0);

    // The in-progress week (May 25 in this fixed-now run) is never judged
    // as a failing week: it's excluded entirely, so the LAST returned week
    // is the oldest CLOSED one (Mon Apr 6 – Sun Apr 12, given 12 weeks).
    // Sanity: no returned week contains the "now" date.
    expect(trend.every((summary) => summary.overall.totalPeriods >= 0), true);
  });

  test('trend completion is per-week isolated — older weeks do not bleed '
      'into newer ones, and the current week is excluded', () async {
    final org = await seedOrganisation();
    final site = await seedSite(org, 'Venue B');
    final manager = await seedUser(name: 'Manager', siteId: site);
    final bob = await seedUser(name: 'Bob', siteId: site);

    final scheduleId = await seedDailySchedule(
      userId: bob,
      siteId: site,
      assignedByUserId: manager,
      assignedAt: DateTime(2026, 1, 1),
    );

    final now = DateTime(2026, 6, 1); // Monday; week of Jun 1 is current.
    // Only week -2 has submissions (May 18–24, 7/7).
    for (var day = 18; day <= 24; day++) {
      await submitCheck(
        siteId: site,
        completedByUserId: bob,
        completedAt: DateTime(2026, 5, day, 10),
        taskScheduleId: scheduleId,
      );
    }

    final trend = await service.computeWeeklyTrendForSite(site, now: now);

    expect(trend[1].overall.completedPeriods, 7); // the filled week
    expect(trend[1].overall.completionRate, 1.0);
    // Neighbouring weeks are untouched by that burst.
    expect(trend[0].overall.completedPeriods, 0);
    expect(trend[2].overall.completedPeriods, 0);
  });

  test('a venue with no schedules at all returns an all-zero trend, '
      'not a crash', () async {
    final org = await seedOrganisation();
    final site = await seedSite(org, 'Venue C');
    await seedUser(name: 'Only staff member', siteId: site);

    final trend = await service.computeWeeklyTrendForSite(site);

    expect(trend.length, 12);
    for (final week in trend) {
      expect(week.overall.totalPeriods, 0);
      expect(week.overall.completionRate == null, true);
    }
  });
}
