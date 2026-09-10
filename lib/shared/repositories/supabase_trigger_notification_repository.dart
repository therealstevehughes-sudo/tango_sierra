import '../../core/network/backend_polling_stream.dart';
import '../../core/network/backend_rest_client.dart';
import '../models/trigger_notification.dart';
import '../models/user.dart';
import 'trigger_notification_repository.dart';

// Phase B5 — backend-hosted TriggerNotifications (the escalation alerts a
// FAIL fires). RLS reuses can_access_site(site_id). watchForUser is a poll
// (see backend_polling_stream.dart) pending the Realtime follow-on — this
// is the alert-banner stream, so it's the one that most wants a real push
// feed eventually.
class SupabaseTriggerNotificationRepository
    implements TriggerNotificationRepository {
  SupabaseTriggerNotificationRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<TriggerNotification> create({
    required int? notificationRuleId,
    required int taskSubmissionId,
    required int recipientUserId,
    required String message,
    required int siteId,
    required RoleTier? originTargetRoleTier,
    String? equipmentInstanceName,
  }) async {
    final row = await _client.insertOne('trigger_notifications', {
      'notification_rule_id': notificationRuleId,
      'task_submission_id': taskSubmissionId,
      'recipient_user_id': recipientUserId,
      'message': message,
      'site_id': siteId,
      'created_at': DateTime.now().toIso8601String(),
      'origin_target_role_tier': originTargetRoleTier?.name,
      'equipment_instance_name': equipmentInstanceName,
    });
    return _toModel(row);
  }

  @override
  Stream<List<TriggerNotification>> watchForUser(int userId) {
    return backendPollingStream<List<TriggerNotification>>(
      fetch: () => _forUser(userId),
      identity: (list) => listIdentity([
        for (final n in list) '${n.id}:${n.acknowledged}:${n.escalatedAt}',
      ]),
    );
  }

  Future<List<TriggerNotification>> _forUser(int userId) async {
    final rows = await _client.select(
      'trigger_notifications',
      query: 'recipient_user_id=eq.$userId&order=created_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TriggerNotification>> getAllUnacknowledged() async {
    final rows = await _client.select(
      'trigger_notifications',
      query: 'acknowledged=eq.false&order=created_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> acknowledge(int id) async {
    await _client.update(
      'trigger_notifications',
      filter: 'id=eq.$id',
      body: {
        'acknowledged': true,
        'acknowledged_at': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> markEscalated(int id) async {
    await _client.update(
      'trigger_notifications',
      filter: 'id=eq.$id',
      body: {'escalated_at': DateTime.now().toIso8601String()},
    );
  }

  TriggerNotification _toModel(Map<String, dynamic> row) => TriggerNotification(
    id: row['id'] as int,
    notificationRuleId: row['notification_rule_id'] as int?,
    taskSubmissionId: row['task_submission_id'] as int,
    recipientUserId: row['recipient_user_id'] as int,
    message: row['message'] as String,
    siteId: row['site_id'] as int,
    createdAt: DateTime.parse(row['created_at'] as String),
    acknowledged: row['acknowledged'] as bool,
    acknowledgedAt: row['acknowledged_at'] == null
        ? null
        : DateTime.parse(row['acknowledged_at'] as String),
    originTargetRoleTier: row['origin_target_role_tier'] == null
        ? null
        : RoleTier.values.byName(row['origin_target_role_tier'] as String),
    escalatedAt: row['escalated_at'] == null
        ? null
        : DateTime.parse(row['escalated_at'] as String),
    equipmentInstanceName: row['equipment_instance_name'] as String?,
  );
}
