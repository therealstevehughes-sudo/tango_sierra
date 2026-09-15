import '../../core/network/backend_rest_client.dart';
import '../models/issue.dart';
import 'issue_repository.dart';

// Issues & Incidents (built 2026-09-15) — backend-hosted. issue_events has
// no site_id of its own; its tenant_isolation policy is scoped via a join
// to the parent issue's site_id (see the schema in BACKEND_INFRA.md), so
// unlike problem_status_events this needs no denormalised site_id column
// or lookup before insert.
class SupabaseIssueRepository implements IssueRepository {
  SupabaseIssueRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Issue>> getForSite(
    int siteId, {
    IssueFilter filter = IssueFilter.all,
  }) async {
    final statusFilter = switch (filter) {
      IssueFilter.all => '',
      IssueFilter.open => '&status=eq.open',
      IssueFilter.resolved => '&status=eq.resolved',
      IssueFilter.escalated => '&status=eq.escalated',
    };
    final rows = await _client.select(
      'issues',
      query: 'site_id=eq.$siteId$statusFilter&order=raised_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Issue>> getRaisedByUser(int userId) async {
    final rows = await _client.select(
      'issues',
      query: 'raised_by_user_id=eq.$userId&order=raised_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<IssueEvent>> getHistory(int issueId) async {
    final rows = await _client.select(
      'issue_events',
      query: 'issue_id=eq.$issueId&order=changed_at.asc',
    );
    return rows.map(_toEventModel).toList();
  }

  @override
  Future<Issue> raise({
    required int siteId,
    required IssueType type,
    String? subtype,
    required String details,
    required int raisedByUserId,
    int? supplierId,
    DeliveryProblemType? deliveryProblemType,
    int? receivedByUserId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final issueRow = await _client.insertOne('issues', {
      'site_id': siteId,
      'type': type.name,
      'subtype': subtype,
      'details': details,
      'raised_by_user_id': raisedByUserId,
      'raised_at': now,
      'status': 'open',
      'supplier_id': supplierId,
      'delivery_problem_type': deliveryProblemType?.name,
      'received_by_user_id': receivedByUserId,
    });
    final issueId = issueRow['id'] as int;
    // Two writes, not a transaction (PostgREST has no multi-statement
    // transaction without an RPC) — same tradeoff as
    // SupabaseProblemRegisterRepository. The issue row above is already
    // the source of truth for status; this event is the audit trail.
    await _client.insertOne('issue_events', {
      'issue_id': issueId,
      'phase': IssueEventPhase.details.name,
      'note': details,
      'changed_by_user_id': raisedByUserId,
      'changed_at': now,
      'resulting_status': 'open',
    });
    return _toModel(issueRow);
  }

  @override
  Future<void> addProcessNote({
    required int issueId,
    required String note,
    required int byUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.process,
    note: note,
    byUserId: byUserId,
    resultingStatus: null,
  );

  @override
  Future<void> resolve({
    required int issueId,
    required String note,
    required int byUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.outcome,
    note: note,
    byUserId: byUserId,
    resultingStatus: IssueStatus.resolved,
  );

  @override
  Future<void> escalate({
    required int issueId,
    required String note,
    required int byUserId,
    required int escalateToUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.process,
    note: note,
    byUserId: byUserId,
    resultingStatus: IssueStatus.escalated,
    targetUserId: escalateToUserId,
  );

  Future<void> _recordEvent({
    required int issueId,
    required IssueEventPhase phase,
    required String note,
    required int byUserId,
    required IssueStatus? resultingStatus,
    int? targetUserId,
  }) async {
    String newStatus;
    if (resultingStatus != null) {
      newStatus = resultingStatus.name;
    } else {
      final parentRows = await _client.select(
        'issues',
        query: 'id=eq.$issueId&select=status',
      );
      if (parentRows.isEmpty) {
        throw StateError(
          'Issue $issueId is not visible to this session — cannot record '
          'an event against it.',
        );
      }
      newStatus = parentRows.first['status'] as String;
    }
    await _client.insertOne('issue_events', {
      'issue_id': issueId,
      'phase': phase.name,
      'note': note,
      'changed_by_user_id': byUserId,
      'changed_at': DateTime.now().toUtc().toIso8601String(),
      'resulting_status': newStatus,
      'target_user_id': targetUserId,
    });
    if (resultingStatus != null) {
      await _client.update(
        'issues',
        filter: 'id=eq.$issueId',
        body: {
          'status': newStatus,
          'escalated_to_user_id': resultingStatus == IssueStatus.escalated
              ? targetUserId
              : null,
        },
      );
    }
  }

  Issue _toModel(Map<String, dynamic> row) => Issue(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    type: IssueType.values.byName(row['type'] as String),
    subtype: row['subtype'] as String?,
    details: row['details'] as String,
    raisedByUserId: row['raised_by_user_id'] as int,
    raisedAt: DateTime.parse(row['raised_at'] as String),
    status: IssueStatus.values.byName(row['status'] as String),
    supplierId: row['supplier_id'] as int?,
    deliveryProblemType: row['delivery_problem_type'] == null
        ? null
        : DeliveryProblemType.values.byName(
            row['delivery_problem_type'] as String,
          ),
    receivedByUserId: row['received_by_user_id'] as int?,
    escalatedToUserId: row['escalated_to_user_id'] as int?,
  );

  IssueEvent _toEventModel(Map<String, dynamic> row) => IssueEvent(
    id: row['id'] as int,
    issueId: row['issue_id'] as int,
    phase: IssueEventPhase.values.byName(row['phase'] as String),
    note: row['note'] as String,
    changedByUserId: row['changed_by_user_id'] as int,
    changedAt: DateTime.parse(row['changed_at'] as String),
    resultingStatus: IssueStatus.values.byName(
      row['resulting_status'] as String,
    ),
    targetUserId: row['target_user_id'] as int?,
  );
}
