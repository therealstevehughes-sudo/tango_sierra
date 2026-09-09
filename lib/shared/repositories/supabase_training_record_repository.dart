import '../../core/network/backend_rest_client.dart';
import '../models/training_item.dart';
import '../models/training_record.dart';
import 'training_record_repository.dart';

// Phase B3 — backend-hosted TrainingRecords. RLS reuses can_access_site
// (site_id), same shape as every B2 site-scoped table. Proven via curl
// before this class was written.
class SupabaseTrainingRecordRepository implements TrainingRecordRepository {
  SupabaseTrainingRecordRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<int> add(TrainingRecord record) async {
    final row = await _client.insertOne('training_records', {
      'user_id': record.userId,
      'site_id': record.siteId,
      'item_type': record.itemType.name,
      'custom_item_title': record.customItemTitle,
      'completed_at': record.completedAt.toIso8601String(),
      'expires_at': record.expiresAt?.toIso8601String(),
      'signed_off_by_user_id': record.signedOffByUserId,
      'certificate_reference': record.certificateReference,
      'created_at': record.createdAt.toIso8601String(),
    });
    return row['id'] as int;
  }

  @override
  Future<List<TrainingRecord>> getForUser(int userId) async {
    final rows = await _client.select(
      'training_records',
      query: 'user_id=eq.$userId&order=completed_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TrainingRecord>> getForSite(int siteId) async {
    final rows = await _client.select(
      'training_records',
      query: 'site_id=eq.$siteId&order=completed_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  TrainingRecord _toModel(Map<String, dynamic> row) => TrainingRecord(
    id: row['id'] as int,
    userId: row['user_id'] as int,
    siteId: row['site_id'] as int,
    itemType: TrainingItemType.values.byName(row['item_type'] as String),
    customItemTitle: row['custom_item_title'] as String?,
    completedAt: DateTime.parse(row['completed_at'] as String),
    expiresAt: row['expires_at'] == null
        ? null
        : DateTime.parse(row['expires_at'] as String),
    signedOffByUserId: row['signed_off_by_user_id'] as int,
    certificateReference: row['certificate_reference'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
