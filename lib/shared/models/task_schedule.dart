// Expanded (Sprint 023) to cover the checklist's real frequency vocabulary
// alongside the original four — purely additive, stored as .name in an
// existing TEXT column, so existing rows keep parsing unchanged.
enum ScheduleFrequency {
  daily,
  weekly,
  perShift,
  threeXDaily,
  perBatch,
  perDelivery,
  perUse,
  twoXPerService,
  eventBased,
  asNeeded,
  custom,
}

String frequencyLabel(ScheduleFrequency frequency) {
  switch (frequency) {
    case ScheduleFrequency.daily:
      return 'Daily';
    case ScheduleFrequency.weekly:
      return 'Weekly';
    case ScheduleFrequency.perShift:
      return 'Per Shift';
    case ScheduleFrequency.threeXDaily:
      return '3x Daily';
    case ScheduleFrequency.perBatch:
      return 'Per Batch';
    case ScheduleFrequency.perDelivery:
      return 'Per Delivery';
    case ScheduleFrequency.perUse:
      return 'Per Use';
    case ScheduleFrequency.twoXPerService:
      return '2x Per Service';
    case ScheduleFrequency.eventBased:
      return 'Event-Based';
    case ScheduleFrequency.asNeeded:
      return 'As Needed';
    case ScheduleFrequency.custom:
      return 'Custom';
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
  });
}
