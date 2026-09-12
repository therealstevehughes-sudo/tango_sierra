import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/task_schedule.dart';

abstract class TaskScheduleRepository {
  Future<List<TaskSchedule>> getAll();
  Future<List<TaskSchedule>> getForSite(int siteId);
  Future<List<TaskSchedule>> getForStaffMember(int userId);
  Future<TaskSchedule> assign({
    required int taskTemplateGroupId,
    required int assignedUserId,
    int? equipmentInstanceId,
    required ScheduleFrequency frequency,
    String? customFrequencyDetail,
    required int assignedByUserId,
    required int siteId,
    int? windowStartMinutes,
    int? windowEndMinutesExclusive,
  });
  Future<void> deactivate(int scheduleId);
  // Task-reorder (2026-09-12): sets the manager-controlled execution order
  // of one schedule within its venue.
  Future<void> setSortOrder(int scheduleId, int? sortOrder);
}

class DriftTaskScheduleRepository implements TaskScheduleRepository {
  DriftTaskScheduleRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<TaskSchedule>> getAll() async {
    final rows = await _db.select(_db.taskSchedules).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSchedule>> getForSite(int siteId) async {
    final query = _db.select(_db.taskSchedules)
      ..where((schedule) => schedule.siteId.equals(siteId))
      // Task-reorder (2026-09-12): explicit sortOrder first (nulls last —
      // schedules without an order yet fall behind ordered ones), then
      // assignedAt for stable, predictable sequence without a backfill.
      ..orderBy([
        (s) => OrderingTerm.asc(s.sortOrder, nulls: NullsOrder.last),
        (s) => OrderingTerm.asc(s.assignedAt),
      ]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSchedule>> getForStaffMember(int userId) async {
    final query = _db.select(_db.taskSchedules)
      ..where((s) => s.assignedUserId.equals(userId) & s.active.equals(true));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<TaskSchedule> assign({
    required int taskTemplateGroupId,
    required int assignedUserId,
    int? equipmentInstanceId,
    required ScheduleFrequency frequency,
    String? customFrequencyDetail,
    required int assignedByUserId,
    required int siteId,
    int? windowStartMinutes,
    int? windowEndMinutesExclusive,
  }) async {
    final id = await _db
        .into(_db.taskSchedules)
        .insert(
          TaskSchedulesCompanion.insert(
            taskTemplateGroupId: taskTemplateGroupId,
            assignedUserId: assignedUserId,
            equipmentInstanceId: Value(equipmentInstanceId),
            frequency: frequency.name,
            customFrequencyDetail: Value(customFrequencyDetail),
            assignedByUserId: assignedByUserId,
            assignedAt: DateTime.now(),
            siteId: Value(siteId),
            windowStartMinutes: Value(windowStartMinutes),
            windowEndMinutesExclusive: Value(windowEndMinutesExclusive),
          ),
        );
    final row = await (_db.select(
      _db.taskSchedules,
    )..where((s) => s.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> deactivate(int scheduleId) async {
    await (_db.update(_db.taskSchedules)..where((s) => s.id.equals(scheduleId)))
        .write(const TaskSchedulesCompanion(active: Value(false)));
  }

  @override
  Future<void> setSortOrder(int scheduleId, int? sortOrder) async {
    await (_db.update(_db.taskSchedules)..where((s) => s.id.equals(scheduleId)))
        .write(TaskSchedulesCompanion(sortOrder: Value(sortOrder)));
  }

  TaskSchedule _toModel(TaskScheduleEntity row) => TaskSchedule(
    id: row.id,
    taskTemplateGroupId: row.taskTemplateGroupId,
    assignedUserId: row.assignedUserId,
    equipmentInstanceId: row.equipmentInstanceId,
    frequency: ScheduleFrequency.values.byName(row.frequency),
    customFrequencyDetail: row.customFrequencyDetail,
    assignedByUserId: row.assignedByUserId,
    assignedAt: row.assignedAt,
    active: row.active,
    siteId: row.siteId!,
    windowStartMinutes: row.windowStartMinutes,
    windowEndMinutesExclusive: row.windowEndMinutesExclusive,
    sortOrder: row.sortOrder,
  );
}
