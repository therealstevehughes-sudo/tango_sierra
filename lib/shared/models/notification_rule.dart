import 'user.dart';

class NotificationRule {
  final int id;
  final int ruleGroupId;
  final int versionNumber;
  final int? previousVersionId;
  final int? taskTemplateGroupId;
  final RoleTier? targetRoleTier;
  final int? targetUserId;
  final bool channelPush;
  final bool channelEmail;
  final int setByUserId;
  final RoleTier setByTier;
  final bool active;
  final DateTime createdAt;

  const NotificationRule({
    required this.id,
    required this.ruleGroupId,
    required this.versionNumber,
    this.previousVersionId,
    this.taskTemplateGroupId,
    this.targetRoleTier,
    this.targetUserId,
    required this.channelPush,
    required this.channelEmail,
    required this.setByUserId,
    required this.setByTier,
    required this.active,
    required this.createdAt,
  });
}
