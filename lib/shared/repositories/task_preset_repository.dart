import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/task_preset.dart';
import '../models/task_schedule.dart';

abstract class TaskPresetRepository {
  Future<List<TaskPreset>> getAll();
  Future<TaskPreset> create({
    required String name,
    int? equipmentTypeId,
    String? segment,
    int? createdByUserId,
  });
  Future<void> rename(int id, String newName);
  Future<void> setActive(int id, bool active);
  Future<TaskPresetItem> addItem({
    required int presetId,
    required int taskTemplateGroupId,
    required ScheduleFrequency defaultFrequency,
    String? defaultCustomFrequencyDetail,
  });
  Future<void> removeItem(int itemId);

  /// Applies a preset to one staff member: creates a TaskSchedule for each
  /// of the preset's items that the staff member doesn't already have an
  /// active schedule for (matched on templateGroupId + equipmentInstance).
  /// Returns the number of schedules actually created. Takes a single staff
  /// member so applying to several is a natural loop over this method, not
  /// a rework (Sprint 026 forward-looking note).
  Future<int> applyPresetToStaff({
    required int presetId,
    required int staffUserId,
    int? equipmentInstanceId,
    required int assignedByUserId,
    required int siteId,
  });
}

class DriftTaskPresetRepository implements TaskPresetRepository {
  DriftTaskPresetRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<TaskPreset>> getAll() async {
    final presetRows = await _db.select(_db.taskPresets).get();
    final itemRows = await _db.select(_db.taskPresetItems).get();

    final itemsByPreset = <int, List<TaskPresetItem>>{};
    for (final row in itemRows) {
      itemsByPreset.putIfAbsent(row.presetId, () => []).add(_toItemModel(row));
    }

    return presetRows
        .map((row) => _toModel(row, itemsByPreset[row.id] ?? const []))
        .toList();
  }

  @override
  Future<TaskPreset> create({
    required String name,
    int? equipmentTypeId,
    String? segment,
    int? createdByUserId,
  }) async {
    if (equipmentTypeId == null && (segment == null || segment.isEmpty)) {
      throw ArgumentError(
        'A task preset must be tied to an equipment type or a segment',
      );
    }

    final createdAt = DateTime.now();
    final id = await _db
        .into(_db.taskPresets)
        .insert(
          TaskPresetsCompanion.insert(
            name: name,
            equipmentTypeId: Value(equipmentTypeId),
            segment: Value(segment),
            createdByUserId: Value(createdByUserId),
            createdAt: createdAt,
          ),
        );
    return TaskPreset(
      id: id,
      name: name,
      equipmentTypeId: equipmentTypeId,
      segment: segment,
      active: true,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.taskPresets)..where((p) => p.id.equals(id))).write(
      TaskPresetsCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await (_db.update(_db.taskPresets)..where((p) => p.id.equals(id))).write(
      TaskPresetsCompanion(active: Value(active)),
    );
  }

  @override
  Future<TaskPresetItem> addItem({
    required int presetId,
    required int taskTemplateGroupId,
    required ScheduleFrequency defaultFrequency,
    String? defaultCustomFrequencyDetail,
  }) async {
    final id = await _db
        .into(_db.taskPresetItems)
        .insert(
          TaskPresetItemsCompanion.insert(
            presetId: presetId,
            taskTemplateGroupId: taskTemplateGroupId,
            defaultFrequency: defaultFrequency.name,
            defaultCustomFrequencyDetail: Value(defaultCustomFrequencyDetail),
          ),
        );
    return TaskPresetItem(
      id: id,
      presetId: presetId,
      taskTemplateGroupId: taskTemplateGroupId,
      defaultFrequency: defaultFrequency,
      defaultCustomFrequencyDetail: defaultCustomFrequencyDetail,
    );
  }

  @override
  Future<void> removeItem(int itemId) async {
    await (_db.delete(
      _db.taskPresetItems,
    )..where((i) => i.id.equals(itemId))).go();
  }

  @override
  Future<int> applyPresetToStaff({
    required int presetId,
    required int staffUserId,
    int? equipmentInstanceId,
    required int assignedByUserId,
    required int siteId,
  }) async {
    final itemRows = await (_db.select(
      _db.taskPresetItems,
    )..where((i) => i.presetId.equals(presetId))).get();

    // The staff member's existing active schedules, to skip anything already
    // assigned (so applying the same preset twice is safe).
    final existing = await (_db.select(_db.taskSchedules)..where(
          (s) => s.assignedUserId.equals(staffUserId) & s.active.equals(true),
        ))
        .get();

    var createdCount = 0;
    for (final item in itemRows) {
      final alreadyAssigned = existing.any(
        (s) =>
            s.taskTemplateGroupId == item.taskTemplateGroupId &&
            s.equipmentInstanceId == equipmentInstanceId,
      );
      if (alreadyAssigned) continue;

      await _db
          .into(_db.taskSchedules)
          .insert(
            TaskSchedulesCompanion.insert(
              taskTemplateGroupId: item.taskTemplateGroupId,
              assignedUserId: staffUserId,
              equipmentInstanceId: Value(equipmentInstanceId),
              frequency: item.defaultFrequency,
              customFrequencyDetail: Value(item.defaultCustomFrequencyDetail),
              assignedByUserId: assignedByUserId,
              assignedAt: DateTime.now(),
              siteId: Value(siteId),
            ),
          );
      createdCount++;
    }
    return createdCount;
  }

  TaskPreset _toModel(TaskPresetEntity row, List<TaskPresetItem> items) {
    return TaskPreset(
      id: row.id,
      name: row.name,
      equipmentTypeId: row.equipmentTypeId,
      segment: row.segment,
      active: row.active,
      createdByUserId: row.createdByUserId,
      createdAt: row.createdAt,
      items: items,
    );
  }

  TaskPresetItem _toItemModel(TaskPresetItemEntity row) {
    return TaskPresetItem(
      id: row.id,
      presetId: row.presetId,
      taskTemplateGroupId: row.taskTemplateGroupId,
      defaultFrequency: ScheduleFrequency.values.byName(row.defaultFrequency),
      defaultCustomFrequencyDetail: row.defaultCustomFrequencyDetail,
    );
  }
}
