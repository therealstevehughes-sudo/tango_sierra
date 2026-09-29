import '../../l10n/app_localizations.dart';

// Expanded (Sprint 023) to cover the checklist's real frequency vocabulary
// alongside the original four, then again (Sprint 030) for gaps found while
// loading HORECA_TASK_LIBRARY.md — purely additive both times, stored as
// .name in an existing TEXT column, so existing rows keep parsing unchanged.
enum ScheduleFrequency {
  daily,
  weekly,
  perShift,
  threeXDaily,
  twoXDaily,
  perBatch,
  perDelivery,
  perUse,
  perService,
  twoXPerService,
  eventBased,
  asNeeded,
  monthly,
  custom,
}

String frequencyLabel(ScheduleFrequency frequency, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (frequency) {
      case ScheduleFrequency.daily:
        return 'Daily';
      case ScheduleFrequency.weekly:
        return 'Weekly';
      case ScheduleFrequency.perShift:
        return 'Per Shift';
      case ScheduleFrequency.threeXDaily:
        return '3x Daily';
      case ScheduleFrequency.twoXDaily:
        return '2x Daily';
      case ScheduleFrequency.perBatch:
        return 'Per Batch';
      case ScheduleFrequency.perDelivery:
        return 'Per Delivery';
      case ScheduleFrequency.perUse:
        return 'Per Use';
      case ScheduleFrequency.perService:
        return 'Per Service';
      case ScheduleFrequency.twoXPerService:
        return '2x Per Service';
      case ScheduleFrequency.eventBased:
        return 'Event-Based';
      case ScheduleFrequency.asNeeded:
        return 'As Needed';
      case ScheduleFrequency.monthly:
        return 'Monthly';
      case ScheduleFrequency.custom:
        return 'Custom';
    }
  }
  switch (frequency) {
    case ScheduleFrequency.daily:
      return l10n.freqDaily;
    case ScheduleFrequency.weekly:
      return l10n.freqWeekly;
    case ScheduleFrequency.perShift:
      return l10n.freqPerShift;
    case ScheduleFrequency.threeXDaily:
      return l10n.freqThreeXDaily;
    case ScheduleFrequency.twoXDaily:
      return l10n.freqTwoXDaily;
    case ScheduleFrequency.perBatch:
      return l10n.freqPerBatch;
    case ScheduleFrequency.perDelivery:
      return l10n.freqPerDelivery;
    case ScheduleFrequency.perUse:
      return l10n.freqPerUse;
    case ScheduleFrequency.perService:
      return l10n.freqPerService;
    case ScheduleFrequency.twoXPerService:
      return l10n.freqTwoXPerService;
    case ScheduleFrequency.eventBased:
      return l10n.freqEventBased;
    case ScheduleFrequency.asNeeded:
      return l10n.freqAsNeeded;
    case ScheduleFrequency.monthly:
      return l10n.freqMonthly;
    case ScheduleFrequency.custom:
      return l10n.freqCustom;
  }
}

// Due/overdue tracking (Sprint 031, Build Order item 5). Only these five
// frequencies describe a pure calendar-time recurrence that's computable
// without a shift/service-period system — perShift/perService/etc. are
// shift- or event-relative concepts this app doesn't model yet (logged,
// deferred decision), so they stay "always available, no due/overdue
// badge" rather than being silently mis-computed.
bool isClockBasedFrequency(ScheduleFrequency frequency) {
  switch (frequency) {
    case ScheduleFrequency.daily:
    case ScheduleFrequency.twoXDaily:
    case ScheduleFrequency.threeXDaily:
    case ScheduleFrequency.weekly:
    case ScheduleFrequency.monthly:
      return true;
    default:
      return false;
  }
}

// How many PASS/FAIL submissions satisfy one period — 2x/3x-daily need
// more than one before the day counts as done.
int requiredSubmissionsPerPeriod(ScheduleFrequency frequency) {
  switch (frequency) {
    case ScheduleFrequency.twoXDaily:
      return 2;
    case ScheduleFrequency.threeXDaily:
      return 3;
    default:
      return 1;
  }
}

// Start of the period containing [reference], device-local. Weekly starts
// Monday (UK/ISO convention). Only meaningful for clock-based frequencies
// — callers must check isClockBasedFrequency first.
DateTime periodStart(ScheduleFrequency frequency, DateTime reference) {
  final startOfDay = DateTime(reference.year, reference.month, reference.day);
  switch (frequency) {
    case ScheduleFrequency.daily:
    case ScheduleFrequency.twoXDaily:
    case ScheduleFrequency.threeXDaily:
      return startOfDay;
    case ScheduleFrequency.weekly:
      final daysSinceMonday = startOfDay.weekday - DateTime.monday;
      return startOfDay.subtract(Duration(days: daysSinceMonday));
    case ScheduleFrequency.monthly:
      return DateTime(reference.year, reference.month, 1);
    default:
      throw ArgumentError(
        'periodStart is only defined for clock-based frequencies',
      );
  }
}

// Exclusive end of the period that starts at [start] — i.e. the start of
// the next period of the same frequency.
DateTime periodEnd(ScheduleFrequency frequency, DateTime start) {
  switch (frequency) {
    case ScheduleFrequency.daily:
    case ScheduleFrequency.twoXDaily:
    case ScheduleFrequency.threeXDaily:
      return start.add(const Duration(days: 1));
    case ScheduleFrequency.weekly:
      return start.add(const Duration(days: 7));
    case ScheduleFrequency.monthly:
      return DateTime(start.year, start.month + 1, 1);
    default:
      throw ArgumentError(
        'periodEnd is only defined for clock-based frequencies',
      );
  }
}

class TaskSchedule {
  final int id;
  final int taskTemplateGroupId;
  final int assignedUserId;
  final int? equipmentInstanceId;
  final ScheduleFrequency frequency;
  final String? customFrequencyDetail;
  final int assignedByUserId;
  final DateTime assignedAt;
  final bool active;
  final int siteId;
  // Time-windowed tasks (Sprint 031, Sub-sprint C) — both null or both
  // set. Minutes since midnight, end exclusive.
  final int? windowStartMinutes;
  final int? windowEndMinutesExclusive;
  // Shift-relative window start (2026-09-24, direct user request) — when
  // true, windowStartMinutes is ignored and the effective start is
  // whatever time the assigned person's ShiftLog says they clocked in
  // today (resolved at read time by TaskController.loadTasks, not stored
  // here — a schedule is set up once, but the actual clock-in time is
  // different every day). Falls back to "always open" if that person has
  // no shift log today (e.g. a tier that doesn't use the shift-welcome
  // flow) rather than blocking them. windowEndMinutesExclusive is
  // unaffected either way — still a plain time of day, if set at all.
  final bool windowStartsAtShiftStart;
  // Task-reorder (2026-09-12): the manager-controlled execution order for
  // this venue's schedules. Nullable; null = no explicit order yet (falls
  // back to natural/creation order), so existing installs and newly-
  // assigned-but-not-yet-ordered tasks keep working unchanged.
  final int? sortOrder;

  const TaskSchedule({
    required this.id,
    required this.taskTemplateGroupId,
    required this.assignedUserId,
    this.equipmentInstanceId,
    required this.frequency,
    this.customFrequencyDetail,
    required this.assignedByUserId,
    required this.assignedAt,
    required this.active,
    required this.siteId,
    this.windowStartMinutes,
    this.windowEndMinutesExclusive,
    this.windowStartsAtShiftStart = false,
    this.sortOrder,
  });
}
