import '../../core/network/backend_rest_client.dart';
import '../models/bug_report.dart';

abstract class BugReportRepository {
  Future<BugReport> submit({
    required int organisationId,
    int? siteId,
    int? reportedByUserId,
    required String title,
    required String description,
    String? platform,
  });
}

class SupabaseBugReportRepository implements BugReportRepository {
  SupabaseBugReportRepository(this._client);

  final BackendRestClient _client;

  BugReport _toModel(Map<String, dynamic> row) => BugReport(
    id: row['id'] as int,
    organisationId: row['organisation_id'] as int,
    siteId: row['site_id'] as int?,
    reportedByUserId: row['reported_by_user_id'] as int?,
    title: row['title'] as String,
    description: row['description'] as String,
    platform: row['platform'] as String?,
    status: row['status'] as String,
    createdAt: DateTime.parse(row['created_at'] as String),
    resolvedAt: row['resolved_at'] == null
        ? null
        : DateTime.parse(row['resolved_at'] as String),
  );

  @override
  Future<BugReport> submit({
    required int organisationId,
    int? siteId,
    int? reportedByUserId,
    required String title,
    required String description,
    String? platform,
  }) async {
    final row = await _client.insertOne('bug_reports', {
      'organisation_id': organisationId,
      'site_id': siteId,
      'reported_by_user_id': reportedByUserId,
      'title': title,
      'description': description,
      'platform': platform,
    });
    return _toModel(row);
  }
}
