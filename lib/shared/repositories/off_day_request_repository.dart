import '../../core/network/backend_rest_client.dart';
import '../models/off_day_request.dart';

// Off-day requests (R5, 2026-09-27) — see the model file's doc comment:
// backend-only, staged pending the off_day_requests table migration
// (BACKEND_INFRA.md's R5 entry).
abstract class OffDayRequestRepository {
  Future<List<OffDayRequest>> getForSite(int siteId);

  Future<List<OffDayRequest>> getForUser(int userId);

  Future<OffDayRequest> request({
    required int siteId,
    required int userId,
    required DateTime requestedDate,
    String? reason,
  });

  Future<void> decide({
    required int requestId,
    required OffDayRequestStatus status,
    required int decidedByUserId,
  });
}

class SupabaseOffDayRequestRepository implements OffDayRequestRepository {
  SupabaseOffDayRequestRepository(this._client);

  final BackendRestClient _client;

  OffDayRequest _toModel(Map<String, dynamic> row) => OffDayRequest(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    userId: row['user_id'] as int,
    requestedDate: DateTime.parse(row['requested_date'] as String),
    reason: row['reason'] as String?,
    status: offDayRequestStatusFromString(row['status'] as String),
    decidedByUserId: row['decided_by_user_id'] as int?,
    decidedAt: row['decided_at'] == null
        ? null
        : DateTime.parse(row['decided_at'] as String),
    createdAt: DateTime.parse(row['created_at'] as String),
  );

  @override
  Future<List<OffDayRequest>> getForSite(int siteId) async {
    final rows = await _client.select(
      'off_day_requests',
      query: 'site_id=eq.$siteId&order=requested_date.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<OffDayRequest>> getForUser(int userId) async {
    final rows = await _client.select(
      'off_day_requests',
      query: 'user_id=eq.$userId&order=requested_date.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<OffDayRequest> request({
    required int siteId,
    required int userId,
    required DateTime requestedDate,
    String? reason,
  }) async {
    final row = await _client.insertOne('off_day_requests', {
      'site_id': siteId,
      'user_id': userId,
      'requested_date': requestedDate.toIso8601String().split('T').first,
      'reason': reason,
    });
    return _toModel(row);
  }

  @override
  Future<void> decide({
    required int requestId,
    required OffDayRequestStatus status,
    required int decidedByUserId,
  }) async {
    await _client.update(
      'off_day_requests',
      filter: 'id=eq.$requestId',
      body: {
        'status': offDayRequestStatusToString(status),
        'decided_by_user_id': decidedByUserId,
        'decided_at': DateTime.now().toIso8601String(),
      },
    );
  }
}
