import 'task_schedule.dart';

// A named "standard task set" (Sprint 026) — a curated grouping of task
// templates tied to an equipment type and/or a segment, applied to create
// TaskSchedules in bulk. Not versioned, org-wide. See app_database.dart.
class TaskPreset {
  final int id;
  final String name;
  final int? equipmentTypeId;
  final String? segment;
  final bool active;
  final int? createdByUserId;
  final DateTime createdAt;
  final List<TaskPresetItem> items;

  const TaskPreset({
    required this.id,
    required this.name,
    this.equipmentTypeId,
    this.segment,
    required this.active,
    this.createdByUserId,
    required this.createdAt,
    this.items = const [],
  });
}

class TaskPresetItem {
  final int id;
  final int presetId;
  final int taskTemplateGroupId;
  final ScheduleFrequency defaultFrequency;
  final String? defaultCustomFrequencyDetail;

  const TaskPresetItem({
    required this.id,
    required this.presetId,
    required this.taskTemplateGroupId,
    required this.defaultFrequency,
    this.defaultCustomFrequencyDetail,
  });
}
