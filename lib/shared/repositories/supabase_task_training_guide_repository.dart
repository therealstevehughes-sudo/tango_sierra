import '../../core/network/backend_rest_client.dart';
import '../../features/tasks/training/task_training_guide.dart';
import 'task_training_guide_repository.dart';

class SupabaseTaskTrainingGuideRepository
    implements TaskTrainingGuideRepository {
  SupabaseTaskTrainingGuideRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<VenueTrainingGuide?> getForTask(
    int siteId,
    int templateGroupId,
  ) async {
    final rows = await _client.select(
      'task_training_guides',
      query: 'site_id=eq.$siteId&template_group_id=eq.$templateGroupId',
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return VenueTrainingGuide(
      siteId: row['site_id'] as int,
      templateGroupId: row['template_group_id'] as int,
      guide: TaskTrainingGuide.fromJson(row),
      updatedAt: DateTime.tryParse(row['updated_at'] as String? ?? ''),
    );
  }

  // No upsert on BackendRestClient, so read-then-write. The table's
  // unique (site_id, template_group_id) constraint means a racing second
  // insert fails loudly rather than leaving two competing versions.
  @override
  Future<void> save({
    required int siteId,
    required int templateGroupId,
    required TaskTrainingGuide guide,
    required int updatedByUserId,
  }) async {
    final body = {
      ...guide.toJson(),
      'updated_by_user_id': updatedByUserId,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
    final filter = 'site_id=eq.$siteId&template_group_id=eq.$templateGroupId';
    final existing = await _client.select(
      'task_training_guides',
      query: '$filter&select=id',
    );
    if (existing.isEmpty) {
      await _client.insertOne('task_training_guides', {
        'site_id': siteId,
        'template_group_id': templateGroupId,
        ...body,
      });
    } else {
      await _client.update('task_training_guides', filter: filter, body: body);
    }
  }

  @override
  Future<void> resetToStandard(int siteId, int templateGroupId) =>
      _client.delete(
        'task_training_guides',
        filter: 'site_id=eq.$siteId&template_group_id=eq.$templateGroupId',
      );
}
