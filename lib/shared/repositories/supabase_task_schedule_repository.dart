import '../../core/network/backend_rest_client.dart';
import '../models/task_schedule.dart';
import 'task_schedule_repository.dart';

// Phase B4 — backend-hosted TaskSchedules. RLS reuses can_access_site
// (site_id), same shape as every site-scoped table since B2. Proven via
// curl before this class was written.
//
// equipment_instance_id has no FK on the backend table yet — a genuine,
// documented compromise (equipment_instances isn't backend-hosted until a
// later cluster), not a relaxation of tenant isolation itself: the
// isolation boundary here is site_id, not equipment_instance_id.
class SupabaseTaskScheduleRepository implements TaskScheduleRepository {
  SupabaseTaskScheduleRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<TaskSchedule>> getAll() async {
    final rows = await _client.select('task_schedules');
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSchedule>> getForStaffMember(int userId) async {
    final rows = await _client.select(
      'task_schedules',
      query: 'assigned_user_id=eq.$userId&active=eq.true',
    );
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
    final row = await _client.insertOne('task_schedules', {
      'task_template_group_id': taskTemplateGroupId,
      'assigned_user_id': assignedUserId,
      'equipment_instance_id': equipmentInstanceId,
      'frequency': frequency.name,
      'custom_frequency_detail': customFrequencyDetail,
      'assigned_by_user_id': assignedByUserId,
      'assigned_at': DateTime.now().toIso8601String(),
      'site_id': siteId,
      'window_start_minutes': windowStartMinutes,
      'window_end_minutes_exclusive': windowEndMinutesExclusive,
    });
    return _toModel(row);
  }

  @override
  Future<void> deactivate(int scheduleId) async {
    await _client.update(
      'task_schedules',
      filter: 'id=eq.$scheduleId',
      body: {'active': false},
    );
  }

  TaskSchedule _toModel(Map<String, dynamic> row) => TaskSchedule(
    id: row['id'] as int,
    taskTemplateGroupId: row['task_template_group_id'] as int,
    assignedUserId: row['assigned_user_id'] as int,
    equipmentInstanceId: row['equipment_instance_id'] as int?,
    frequency: ScheduleFrequency.values.byName(row['frequency'] as String),
    customFrequencyDetail: row['custom_frequency_detail'] as String?,
    assignedByUserId: row['assigned_by_user_id'] as int,
    assignedAt: DateTime.parse(row['assigned_at'] as String),
    active: row['active'] as bool,
    siteId: row['site_id'] as int,
    windowStartMinutes: row['window_start_minutes'] as int?,
    windowEndMinutesExclusive: row['window_end_minutes_exclusive'] as int?,
  );
}
