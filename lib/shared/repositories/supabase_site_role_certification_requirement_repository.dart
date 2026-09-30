import '../../core/network/backend_rest_client.dart';
import '../models/certification_requirement.dart';
import '../models/job_role.dart';
import '../models/training_item.dart';
import 'site_role_certification_requirement_repository.dart';

// RLS reuses can_access_site(site_id), same shape as every other
// site-scoped table — writes additionally require leadership per the
// site_role_certification_requirements policy (see
// tools/phase2_cert_requirements_migration.sql), so a base/supervisor
// session's insert/delete attempt is rejected server-side even if the UI
// never offers it to them.
class SupabaseSiteRoleCertificationRequirementRepository
    implements SiteRoleCertificationRequirementRepository {
  SupabaseSiteRoleCertificationRequirementRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<SiteRoleCertificationRequirement>> getForSite(
    int siteId,
  ) async {
    final rows = await _client.select(
      'site_role_certification_requirements',
      query: 'site_id=eq.$siteId&order=created_at.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<SiteRoleCertificationRequirement> add(
    SiteRoleCertificationRequirement requirement,
  ) async {
    final row = await _client.insertOne('site_role_certification_requirements', {
      'site_id': requirement.siteId,
      'job_role': requirement.jobRole.name,
      'item_type': requirement.itemType.name,
      'added_by_user_id': requirement.addedByUserId,
    });
    return _toModel(row);
  }

  @override
  Future<void> remove(int id) async {
    await _client.delete(
      'site_role_certification_requirements',
      filter: 'id=eq.$id',
    );
  }

  SiteRoleCertificationRequirement _toModel(Map<String, dynamic> row) =>
      SiteRoleCertificationRequirement(
        id: row['id'] as int,
        siteId: row['site_id'] as int,
        jobRole: JobRole.values.byName(row['job_role'] as String),
        itemType: TrainingItemType.values.byName(row['item_type'] as String),
        addedByUserId: row['added_by_user_id'] as int,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
}
