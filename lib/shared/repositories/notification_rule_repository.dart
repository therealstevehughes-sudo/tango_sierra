import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/notification_rule.dart';
import '../models/user.dart';

abstract class NotificationRuleRepository {
  Future<List<NotificationRule>> getAllCurrentVersions();
  Future<List<NotificationRule>> getVersionHistory(int ruleGroupId);
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
  });
}

class DriftNotificationRuleRepository implements NotificationRuleRepository {
  DriftNotificationRuleRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<NotificationRule>> getAllCurrentVersions() async {
    final rows = await _db.select(_db.notificationRules).get();
    final currentVersionIds = _currentVersionIds(rows);
    return rows
        .where((row) => currentVersionIds.contains(row.id))
        .map(_toModel)
        .toList();
  }

  @override
  Future<List<NotificationRule>> getVersionHistory(int ruleGroupId) async {
    final query = _db.select(_db.notificationRules)
      ..where((r) => r.ruleGroupId.equals(ruleGroupId))
      ..orderBy([(r) => OrderingTerm.asc(r.versionNumber)]);
    final rows = await query.get();
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

    final insertedId = await _db
        .into(_db.notificationRules)
        .insert(
          NotificationRulesCompanion.insert(
            ruleGroupId: ruleGroupId ?? 0,
            versionNumber: nextVersionNumber,
            previousVersionId: Value(previousVersionId),
            taskTemplateGroupId: Value(taskTemplateGroupId),
            targetRoleTier: Value(targetRoleTier?.name),
            targetUserId: Value(targetUserId),
            channelPush: Value(channelPush),
            channelEmail: Value(channelEmail),
            setByUserId: setByUserId,
            setByTier: setByTier.name,
            active: Value(active),
            createdAt: DateTime.now(),
            siteId: Value(siteId),
          ),
        );

    if (ruleGroupId == null) {
      await (_db.update(
        _db.notificationRules,
      )..where((r) => r.id.equals(insertedId))).write(
        NotificationRulesCompanion(ruleGroupId: Value(insertedId)),
      );
    }

    final savedRow = await (_db.select(
      _db.notificationRules,
    )..where((r) => r.id.equals(insertedId))).getSingle();

    return _toModel(savedRow);
  }

  List<int> _currentVersionIds(List<NotificationRuleEntity> rows) {
    final referencedAsPrevious = rows
        .map((r) => r.previousVersionId)
        .whereType<int>()
        .toSet();
    return rows
        .where((r) => !referencedAsPrevious.contains(r.id))
        .map((r) => r.id)
        .toList();
  }

  NotificationRule _toModel(NotificationRuleEntity row) {
    return NotificationRule(
      id: row.id,
      ruleGroupId: row.ruleGroupId,
      versionNumber: row.versionNumber,
      previousVersionId: row.previousVersionId,
      taskTemplateGroupId: row.taskTemplateGroupId,
      targetRoleTier: row.targetRoleTier == null
          ? null
          : RoleTier.values.byName(row.targetRoleTier!),
      targetUserId: row.targetUserId,
      channelPush: row.channelPush,
      channelEmail: row.channelEmail,
      setByUserId: row.setByUserId,
      setByTier: RoleTier.values.byName(row.setByTier),
      active: row.active,
      createdAt: row.createdAt,
      siteId: row.siteId,
    );
  }
}
