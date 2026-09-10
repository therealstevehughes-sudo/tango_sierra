import 'dart:convert';

import '../../core/network/backend_polling_stream.dart';
import '../../core/network/backend_rest_client.dart';
import '../models/session_summary.dart';
import 'session_summary_repository.dart';

// Phase B5 — backend-hosted SessionSummaries (the manager's end-of-shift
// inbox). RLS reuses can_access_site(site_id). watchForManager is a poll
// (see backend_polling_stream.dart) pending the Realtime follow-on.
class SupabaseSessionSummaryRepository implements SessionSummaryRepository {
  SupabaseSessionSummaryRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<SessionSummary> create({
    required int staffUserId,
    required String staffName,
    required int sentToManagerId,
    required int passCount,
    required int failCount,
    required List<String> failedTaskTitles,
    String? note,
    required int siteId,
  }) async {
    final row = await _client.insertOne('session_summaries', {
      'staff_user_id': staffUserId,
      'staff_name': staffName,
      'sent_to_manager_id': sentToManagerId,
      'pass_count': passCount,
      'fail_count': failCount,
      'failed_task_titles_json': jsonEncode(failedTaskTitles),
      'note': note,
      'sent_at': DateTime.now().toIso8601String(),
      'site_id': siteId,
    });
    return _toModel(row);
  }

  @override
  Stream<List<SessionSummary>> watchForManager(int managerId) {
    return backendPollingStream<List<SessionSummary>>(
      fetch: () => _forManager(managerId),
      identity: (list) => listIdentity([
        for (final s in list) '${s.id}:${s.acknowledged}',
      ]),
    );
  }

  Future<List<SessionSummary>> _forManager(int managerId) async {
    final rows = await _client.select(
      'session_summaries',
      query: 'sent_to_manager_id=eq.$managerId&order=sent_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> acknowledge(int id) async {
    await _client.update(
      'session_summaries',
      filter: 'id=eq.$id',
      body: {
        'acknowledged': true,
        'acknowledged_at': DateTime.now().toIso8601String(),
      },
    );
  }

  SessionSummary _toModel(Map<String, dynamic> row) => SessionSummary(
    id: row['id'] as int,
    staffUserId: row['staff_user_id'] as int,
    staffName: row['staff_name'] as String,
    sentToManagerId: row['sent_to_manager_id'] as int,
    passCount: row['pass_count'] as int,
    failCount: row['fail_count'] as int,
    failedTaskTitles: (jsonDecode(row['failed_task_titles_json'] as String)
            as List)
        .cast<String>(),
    note: row['note'] as String?,
    sentAt: DateTime.parse(row['sent_at'] as String),
    acknowledged: row['acknowledged'] as bool,
    acknowledgedAt: row['acknowledged_at'] == null
        ? null
        : DateTime.parse(row['acknowledged_at'] as String),
    siteId: row['site_id'] as int,
  );
}
