import '../../core/network/backend_rest_client.dart';
import '../../features/tasks/training/training_progress.dart';
import 'training_progress_repository.dart';

class SupabaseTrainingProgressRepository implements TrainingProgressRepository {
  SupabaseTrainingProgressRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<TrainingAcknowledgement>> getAcknowledgementsForSite(
    int siteId,
  ) async {
    final rows = await _client.select(
      'training_acknowledgements',
      query: 'site_id=eq.$siteId',
    );
    return rows.map(_ackFromRow).toList();
  }

  @override
  Future<List<TrainingAcknowledgement>> getAcknowledgementsForUser(
    int userId,
  ) async {
    final rows = await _client.select(
      'training_acknowledgements',
      query: 'user_id=eq.$userId',
    );
    return rows.map(_ackFromRow).toList();
  }

  @override
  Future<void> acknowledge({
    required int userId,
    required int siteId,
    required int templateGroupId,
    required String guideVersion,
  }) async {
    // Upserts (2026-10-17): reading the same guide again moves the time
    // forward, which is what unlocks a quiz retry or a refresher.
    await _client.rpc('acknowledge_training_guide', {
      'p_site_id': siteId,
      'p_template_group_id': templateGroupId,
      'p_guide_version': guideVersion,
      'p_user_id': userId,
    });
  }

  @override
  Future<List<CompetenceSignoff>> getSignoffsForSite(int siteId) async {
    final rows = await _client.select(
      'training_competence_signoffs',
      query: 'site_id=eq.$siteId',
    );
    return rows
        .map(
          (row) => CompetenceSignoff(
            userId: row['user_id'] as int,
            siteId: row['site_id'] as int,
            templateGroupId: row['template_group_id'] as int,
            signedOffByUserId: row['signed_off_by_user_id'] as int,
            signedOffAt: DateTime.parse(row['signed_off_at'] as String),
          ),
        )
        .toList();
  }

  @override
  Future<void> signOff({
    required int userId,
    required int siteId,
    required int templateGroupId,
    required int signedOffByUserId,
  }) async {
    await _client.insertOne('training_competence_signoffs', {
      'user_id': userId,
      'site_id': siteId,
      'template_group_id': templateGroupId,
      'signed_off_by_user_id': signedOffByUserId,
    });
  }

  @override
  Future<void> withdrawSignoff({
    required int userId,
    required int templateGroupId,
  }) => _client.delete(
    'training_competence_signoffs',
    filter: 'user_id=eq.$userId&template_group_id=eq.$templateGroupId',
  );

  TrainingAcknowledgement _ackFromRow(Map<String, dynamic> row) =>
      TrainingAcknowledgement(
        userId: row['user_id'] as int,
        siteId: row['site_id'] as int,
        templateGroupId: row['template_group_id'] as int,
        guideVersion: row['guide_version'] as String,
        acknowledgedAt: DateTime.parse(row['acknowledged_at'] as String),
      );
}
