import '../../core/network/backend_polling_stream.dart';
import '../../core/network/backend_rest_client.dart';
import '../models/task_submission.dart';
import 'task_submission_repository.dart';

// Phase B5 — backend-hosted TaskSubmissions: the audit backbone, the
// highest-volume and most compliance-critical table. Append-only in
// practice (submit only ever inserts). RLS reuses can_access_site(site_id)
// — the whole row is scoped by site_id regardless of which fields are
// denormalised inside it (completed_by, equipment_instance_name,
// problem_status), so those work tenant-scoped for free. Proven via curl,
// including that a cross-tenant read returns nothing (no denormalised
// field leak) and a cross-tenant write is rejected, before this class was
// written.
//
// The watch* streams poll (see backend_polling_stream.dart) — the manager
// log's live-refresh is PULL on the backend path until the Realtime
// follow-on. The DISTINCT-lookup methods fetch the RLS-scoped rows and
// dedupe in Dart, since PostgREST has no bare SELECT DISTINCT.
class SupabaseTaskSubmissionRepository implements TaskSubmissionRepository {
  SupabaseTaskSubmissionRepository(this._client);

  final BackendRestClient _client;

  static String _iso(DateTime dt) => dt.toUtc().toIso8601String();

  static DateTime _startOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  @override
  Future<int> submit(TaskSubmission submission) async {
    final row = await _client.insertOne('task_submissions', {
      'task_title': submission.taskTitle,
      'status': submission.status,
      'completed_by': submission.completedBy,
      'completed_at': _iso(submission.completedAt),
      'numeric_value': submission.numericValue,
      'photo_attached': submission.photoAttached,
      'photo_path': submission.photoPath,
      'notes': submission.notes,
      'task_schedule_id': submission.taskScheduleId,
      'task_template_group_id': submission.taskTemplateGroupId,
      'equipment_instance_id': submission.equipmentInstanceId,
      'custom_field_values_json': submission.customFieldValuesJson,
      'completed_by_user_id': submission.completedByUserId,
      'site_id': submission.siteId,
      'corrective_action_outcome': submission.correctiveActionOutcome,
      'corrective_action_note': submission.correctiveActionNote,
      'supplier_id': submission.supplierId,
      'problem_status': submission.problemStatus,
      'equipment_instance_name': submission.equipmentInstanceName,
    });
    return row['id'] as int;
  }

  Future<List<TaskSubmission>> _query(String query) async {
    final rows = await _client.select('task_submissions', query: query);
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSubmission>> getAll() =>
      _query('order=completed_at.desc');

  @override
  Future<List<TaskSubmission>> getByStaff(String staffId) =>
      _query('completed_by=eq.$staffId&order=completed_at.desc');

  @override
  Future<List<TaskSubmission>> getByDateRange(DateTime start, DateTime end) =>
      _query(
        'completed_at=gte.${_iso(start)}&completed_at=lte.${_iso(end)}'
        '&order=completed_at.desc',
      );

  @override
  Future<List<TaskSubmission>> getForSiteAndDateRange({
    required int siteId,
    required DateTime start,
    required DateTime end,
  }) => _query(
    'site_id=eq.$siteId&completed_at=gte.${_iso(start)}'
    '&completed_at=lte.${_iso(end)}&order=completed_at.asc',
  );

  @override
  Future<List<TaskSubmission>> getForUserSince(int userId, DateTime since) =>
      _query(
        'completed_by_user_id=eq.$userId&completed_at=gte.${_iso(since)}'
        '&order=completed_at.desc',
      );

  @override
  Stream<List<TaskSubmission>> watchAll() =>
      _poll(() => getAll());

  @override
  Stream<List<TaskSubmission>> watchDefaultView() {
    final startOfToday = _startOfDay(DateTime.now());
    final endOfToday = startOfToday.add(const Duration(days: 1));
    return _poll(
      () => _query(
        'or=(and(completed_at.gte.${_iso(startOfToday)},'
        'completed_at.lt.${_iso(endOfToday)}),status.eq.FAIL)'
        '&order=completed_at.desc',
      ),
    );
  }

  @override
  Stream<List<TaskSubmission>> watchFiltered({
    String? name,
    DateTime? date,
    String? task,
  }) {
    final filters = <String>['order=completed_at.desc'];
    if (name != null) filters.add('completed_by=eq.$name');
    if (task != null) filters.add('task_title=eq.$task');
    if (date != null) {
      final start = _startOfDay(date);
      final end = start.add(const Duration(days: 1));
      filters.add('completed_at=gte.${_iso(start)}');
      filters.add('completed_at=lt.${_iso(end)}');
    }
    return _poll(() => _query(filters.join('&')));
  }

  Stream<List<TaskSubmission>> _poll(
    Future<List<TaskSubmission>> Function() fetch,
  ) {
    return backendPollingStream<List<TaskSubmission>>(
      fetch: fetch,
      identity: (list) => listIdentity([
        for (final s in list) '${s.id}:${s.problemStatus}',
      ]),
    );
  }

  @override
  Future<List<String>> getDistinctNames({DateTime? date, String? task}) async {
    final rows = await _scopedRows(date: date, task: task);
    final names = {for (final r in rows) r['completed_by'] as String}.toList()
      ..sort();
    return names;
  }

  @override
  Future<List<String>> getDistinctTasks({String? name, DateTime? date}) async {
    final rows = await _scopedRows(date: date, name: name);
    final tasks = {for (final r in rows) r['task_title'] as String}.toList()
      ..sort();
    return tasks;
  }

  @override
  Future<List<DateTime>> getDistinctDates({String? name, String? task}) async {
    final rows = await _scopedRows(name: name, task: task);
    final days = {
      for (final r in rows)
        _startOfDay(DateTime.parse(r['completed_at'] as String)),
    }.toList()..sort((a, b) => b.compareTo(a));
    return days;
  }

  Future<List<Map<String, dynamic>>> _scopedRows({
    DateTime? date,
    String? name,
    String? task,
  }) {
    final filters = <String>['select=completed_by,task_title,completed_at'];
    if (name != null) filters.add('completed_by=eq.$name');
    if (task != null) filters.add('task_title=eq.$task');
    if (date != null) {
      final start = _startOfDay(date);
      final end = start.add(const Duration(days: 1));
      filters.add('completed_at=gte.${_iso(start)}');
      filters.add('completed_at=lt.${_iso(end)}');
    }
    return _client.select('task_submissions', query: filters.join('&'));
  }

  @override
  Future<int> countForScheduleInRange({
    required int taskScheduleId,
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await _client.select(
      'task_submissions',
      query:
          'select=id&task_schedule_id=eq.$taskScheduleId'
          '&completed_at=gte.${_iso(start)}&completed_at=lt.${_iso(end)}'
          '&status=in.(PASS,FAIL)',
    );
    return rows.length;
  }

  // Exposed so SupabaseProblemRegisterRepository (which also returns
  // TaskSubmission rows from the same table) shares one mapping and can't
  // drift out of sync with it.
  TaskSubmission rowToModel(Map<String, dynamic> row) => _toModel(row);

  TaskSubmission _toModel(Map<String, dynamic> row) => TaskSubmission(
    id: row['id'] as int,
    taskTitle: row['task_title'] as String,
    status: row['status'] as String,
    completedBy: row['completed_by'] as String,
    completedAt: DateTime.parse(row['completed_at'] as String),
    numericValue: row['numeric_value'] as String?,
    photoAttached: row['photo_attached'] as bool,
    photoPath: row['photo_path'] as String?,
    notes: row['notes'] as String?,
    taskScheduleId: row['task_schedule_id'] as int?,
    taskTemplateGroupId: row['task_template_group_id'] as int?,
    equipmentInstanceId: row['equipment_instance_id'] as int?,
    customFieldValuesJson: row['custom_field_values_json'] as String?,
    completedByUserId: row['completed_by_user_id'] as int?,
    siteId: row['site_id'] as int,
    correctiveActionOutcome: row['corrective_action_outcome'] as String?,
    correctiveActionNote: row['corrective_action_note'] as String?,
    supplierId: row['supplier_id'] as int?,
    problemStatus: row['problem_status'] as String?,
    equipmentInstanceName: row['equipment_instance_name'] as String?,
  );
}
