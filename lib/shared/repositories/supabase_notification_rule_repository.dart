import '../../core/network/backend_rest_client.dart';
import '../models/notification_rule.dart';
import '../models/user.dart';
import 'notification_rule_repository.dart';

// Phase B4 — backend-hosted NotificationRules. organisation_id is a NEW
// column that doesn't exist in the local model at all — resolved from the
// creating session's own org here, not exposed on the interface (matches
// how VenueType/EquipmentType's create() resolves it in B2). RLS: a
// site-specific rule (site_id set) uses can_access_site; an org-wide rule
// (site_id null) uses can_access_organisation against this column — proven
// via curl, including that an org-wide rule can never be created claiming
// a different tenant's organisation_id, before this class was written.
class SupabaseNotificationRuleRepository implements NotificationRuleRepository {
  SupabaseNotificationRuleRepository(this._client, this._organisationId);

  final BackendRestClient _client;
  final int Function() _organisationId;

  @override
  Future<List<NotificationRule>> getAllCurrentVersions() async {
    final rows = await _client.select('notification_rules');
    final currentIds = _currentVersionIds(rows);
    return rows
        .where((row) => currentIds.contains(row['id'] as int))
        .map(_toModel)
        .toList();
  }

  @override
  Future<List<NotificationRule>> getVersionHistory(int ruleGroupId) async {
    final rows = await _client.select(
      'notification_rules',
      query: 'rule_group_id=eq.$ruleGroupId&order=version_number.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<NotificationRule> saveNewVersion({
    int? ruleGroupId,
    int? taskTemplateGroupId,
    RoleTier? targetRoleTier,
    int? targetUserId,
    required bool channelPush,
    required bool channelEmail,
    required int setByUserId,
    required RoleTier setByTier,
    required bool active,
    int? siteId,
  }) async {
    if (targetRoleTier == null && targetUserId == null) {
      throw ArgumentError(
        'A notification rule must target either a role tier or a specific user',
      );
    }

    int? previousVersionId;
    var nextVersionNumber = 1;

    if (ruleGroupId != null) {
      final history = await getVersionHistory(ruleGroupId);
      if (history.isNotEmpty) {
        final current = history.last;
        previousVersionId = current.id;
        nextVersionNumber = current.versionNumber + 1;
      }
    }

    final row = await _client.insertOne('notification_rules', {
      'rule_group_id': ruleGroupId ?? 0,
      'version_number': nextVersionNumber,
      'previous_version_id': previousVersionId,
      'task_template_group_id': taskTemplateGroupId,
      'target_role_tier': targetRoleTier?.name,
      'target_user_id': targetUserId,
      'channel_push': channelPush,
      'channel_email': channelEmail,
      'set_by_user_id': setByUserId,
      'set_by_tier': setByTier.name,
      'active': active,
      'site_id': siteId,
      'organisation_id': _organisationId(),
    });

    var insertedId = row['id'] as int;
    if (ruleGroupId == null) {
      await _client.update(
        'notification_rules',
        filter: 'id=eq.$insertedId',
        body: {'rule_group_id': insertedId},
      );
    }

    final savedRows = await _client.select(
      'notification_rules',
      query: 'id=eq.$insertedId',
    );
    return _toModel(savedRows.first);
  }

  List<int> _currentVersionIds(List<Map<String, dynamic>> rows) {
    final referencedAsPrevious = rows
        .map((r) => r['previous_version_id'] as int?)
        .whereType<int>()
        .toSet();
    return rows
        .where((r) => !referencedAsPrevious.contains(r['id'] as int))
        .map((r) => r['id'] as int)
        .toList();
  }

  NotificationRule _toModel(Map<String, dynamic> row) => NotificationRule(
    id: row['id'] as int,
    ruleGroupId: row['rule_group_id'] as int,
    versionNumber: row['version_number'] as int,
    previousVersionId: row['previous_version_id'] as int?,
    taskTemplateGroupId: row['task_template_group_id'] as int?,
    targetRoleTier: row['target_role_tier'] == null
        ? null
        : RoleTier.values.byName(row['target_role_tier'] as String),
    targetUserId: row['target_user_id'] as int?,
    channelPush: row['channel_push'] as bool,
    channelEmail: row['channel_email'] as bool,
    setByUserId: row['set_by_user_id'] as int,
    setByTier: RoleTier.values.byName(row['set_by_tier'] as String),
    active: row['active'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
    siteId: row['site_id'] as int?,
  );
}
