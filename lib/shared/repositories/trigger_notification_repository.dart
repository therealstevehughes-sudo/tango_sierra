import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/trigger_notification.dart';
import '../models/user.dart';

abstract class TriggerNotificationRepository {
  Future<TriggerNotification> create({
    required int? notificationRuleId,
    required int taskSubmissionId,
    required int recipientUserId,
    required String message,
    required int siteId,
    required RoleTier? originTargetRoleTier,
    String? equipmentInstanceName,
  });
  Stream<List<TriggerNotification>> watchForUser(int userId);
  Future<List<TriggerNotification>> getAllUnacknowledged();
  Future<void> acknowledge(int id);
  Future<void> markEscalated(int id);
}

class DriftTriggerNotificationRepository
    implements TriggerNotificationRepository {
  DriftTriggerNotificationRepository(this._db);

  final AppDatabase _db;

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
    final id = await _db
        .into(_db.triggerNotifications)
        .insert(
          TriggerNotificationsCompanion.insert(
            notificationRuleId: Value(notificationRuleId),
            taskSubmissionId: taskSubmissionId,
            recipientUserId: recipientUserId,
            message: message,
            siteId: siteId,
            createdAt: DateTime.now(),
            originTargetRoleTier: Value(originTargetRoleTier?.name),
            equipmentInstanceName: Value(equipmentInstanceName),
          ),
        );
    final row = await (_db.select(
      _db.triggerNotifications,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Stream<List<TriggerNotification>> watchForUser(int userId) {
    final query = _db.select(_db.triggerNotifications)
      ..where((t) => t.recipientUserId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Future<List<TriggerNotification>> getAllUnacknowledged() async {
    final query = _db.select(_db.triggerNotifications)
      ..where((t) => t.acknowledged.equals(false));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> acknowledge(int id) async {
    await (_db.update(
      _db.triggerNotifications,
    )..where((t) => t.id.equals(id))).write(
      TriggerNotificationsCompanion(
        acknowledged: const Value(true),
        acknowledgedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markEscalated(int id) async {
    await (_db.update(
      _db.triggerNotifications,
    )..where((t) => t.id.equals(id))).write(
      TriggerNotificationsCompanion(escalatedAt: Value(DateTime.now())),
    );
  }

  TriggerNotification _toModel(TriggerNotificationEntity row) {
    return TriggerNotification(
      id: row.id,
      notificationRuleId: row.notificationRuleId,
      taskSubmissionId: row.taskSubmissionId,
      recipientUserId: row.recipientUserId,
      message: row.message,
      siteId: row.siteId,
      createdAt: row.createdAt,
      acknowledged: row.acknowledged,
      acknowledgedAt: row.acknowledgedAt,
      originTargetRoleTier: row.originTargetRoleTier == null
          ? null
          : RoleTier.values.byName(row.originTargetRoleTier!),
      escalatedAt: row.escalatedAt,
      equipmentInstanceName: row.equipmentInstanceName,
    );
  }
}
