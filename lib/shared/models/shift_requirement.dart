import 'job_role.dart';

// Rota calendar, Sprint 3 (2026-10-01) — the "master rota" a manager
// builds once per recurring pattern (e.g. "every Friday evening, Bar
// needs 3 staff + 1 standby"), rather than posting individual shifts one
// at a time. generateShiftsForWeek() (see ShiftRequirementRepository)
// turns a requirement into real Shift rows for a given week - everything
// downstream (claiming, assigning, cert checks) is then the existing
// Shift machinery unchanged.
//
// departmentId and jobRole are both nullable and independent - a
// requirement can target a specific department, a specific role
// (regardless of department), both, or neither (any staff, any
// department) - founder's own framing ("by department or by role").
class ShiftRequirement {
  final int? id;
  final int siteId;
  final int? departmentId;
  final JobRole? jobRole;
  final int periodId;
  // ISO weekday: 1 = Monday .. 7 = Sunday, matching DateTime.weekday
  // directly so generateShiftsForWeek needs no translation.
  final int dayOfWeek;
  final int requiredCount;
  final int standbyCount;

  const ShiftRequirement({
    required this.id,
    required this.siteId,
    this.departmentId,
    this.jobRole,
    required this.periodId,
    required this.dayOfWeek,
    required this.requiredCount,
    required this.standbyCount,
  });
}
