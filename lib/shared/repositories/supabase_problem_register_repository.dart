import '../../core/network/backend_polling_stream.dart';
import '../../core/network/backend_rest_client.dart';
import '../models/problem_status_event.dart';
import '../models/task_submission.dart';
import 'problem_register_repository.dart';
import 'supabase_task_submission_repository.dart';

// Phase B5 — backend-hosted Fails & Problems Register. problem_status_events
// gained a backend-only denormalised site_id (populated from the parent
// submission at write time), so RLS reuses can_access_site(site_id) the
// same as every other table. Proven via curl before this class was
// written, including that a status-change event carrying another tenant's
// site_id is rejected.
class SupabaseProblemRegisterRepository implements ProblemRegisterRepository {
  SupabaseProblemRegisterRepository(this._client)
    : _submissions = SupabaseTaskSubmissionRepository(_client);

  final BackendRestClient _client;
  final SupabaseTaskSubmissionRepository _submissions;

  @override
  Stream<List<TaskSubmission>> watchForSite(
    int siteId, {
    ProblemFilter filter = ProblemFilter.all,
  }) {
    String statusFilter() {
      switch (filter) {
        case ProblemFilter.all:
          return 'status=in.(FAIL,NOT_COMPLETED)';
        case ProblemFilter.fail:
          return 'status=eq.FAIL';
        case ProblemFilter.reported:
          return 'status=eq.FAIL&corrective_action_outcome=eq.reported';
        case ProblemFilter.notCompleted:
          return 'status=eq.NOT_COMPLETED';
      }
    }

    return backendPollingStream<List<TaskSubmission>>(
      fetch: () async {
        final rows = await _client.select(
          'task_submissions',
          query:
              'site_id=eq.$siteId&${statusFilter()}&order=completed_at.desc',
        );
        return rows.map(_toSubmissionModel).toList();
      },
      identity: (list) => listIdentity([
        for (final s in list) '${s.id}:${s.problemStatus}',
      ]),
    );
  }

  @override
  Future<List<ProblemStatusEvent>> getHistory(int taskSubmissionId) async {
    final rows = await _client.select(
      'problem_status_events',
      query:
          'task_submission_id=eq.$taskSubmissionId&order=changed_at.asc',
    );
    return rows.map(_toEventModel).toList();
  }

  @override
  Future<void> resolve({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: ProblemStatus.resolved,
    byUserId: byUserId,
    note: note,
  );

  @override
  Future<void> reopen({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: ProblemStatus.open,
    byUserId: byUserId,
    note: note,
  );

  @override
  Future<void> initialize({
    required int taskSubmissionId,
    required ProblemStatus status,
    required int byUserId,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: status,
    byUserId: byUserId,
    note: null,
  );

  Future<void> _recordStatusChange({
    required int taskSubmissionId,
    required ProblemStatus status,
    required int byUserId,
    String? note,
  }) async {
    // Resolve the parent submission's site first -- it's the denormalised
    // scope for the new event row, and RLS means this returns nothing if
    // the caller can't legitimately act on this submission at all.
    final parentRows = await _client.select(
      'task_submissions',
      query: 'id=eq.$taskSubmissionId&select=site_id',
    );
    if (parentRows.isEmpty) {
      throw StateError(
        'Task submission $taskSubmissionId is not visible to this session '
        '— cannot record a problem status change against it.',
      );
    }
    final siteId = parentRows.first['site_id'] as int;
    final statusString = status.name;

    // Two writes, not a transaction (PostgREST has no multi-statement
    // transaction without an RPC). The event row is the source of truth;
    // problem_status on the submission is a read-optimisation mirror. If
    // the mirror write failed, getHistory would still be correct.
    await _client.insertOne('problem_status_events', {
      'task_submission_id': taskSubmissionId,
      'status': statusString,
      'changed_by_user_id': byUserId,
      'changed_at': DateTime.now().toUtc().toIso8601String(),
      'note': note,
      'site_id': siteId,
    });
    await _client.update(
      'task_submissions',
      filter: 'id=eq.$taskSubmissionId',
      body: {'problem_status': statusString},
    );
  }

  ProblemStatusEvent _toEventModel(Map<String, dynamic> row) =>
      ProblemStatusEvent(
        id: row['id'] as int,
        taskSubmissionId: row['task_submission_id'] as int,
        status: ProblemStatus.values.byName(row['status'] as String),
        changedByUserId: row['changed_by_user_id'] as int,
        changedAt: DateTime.parse(row['changed_at'] as String),
        note: row['note'] as String?,
      );

  // Reuses the submission repo's own row->model mapping so the two stay in
  // lockstep.
  TaskSubmission _toSubmissionModel(Map<String, dynamic> row) {
    // A tiny shim: SupabaseTaskSubmissionRepository._toModel is private, so
    // round-trip through its public submit-shaped fields isn't available.
    // Duplicating the mapping here would drift; instead delegate via a
    // dedicated helper on that class.
    return _submissions.rowToModel(row);
  }
}
