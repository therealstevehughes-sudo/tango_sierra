import 'user.dart';

class TriggerNotification {
  final int id;
  final int? notificationRuleId;
  final int taskSubmissionId;
  final int recipientUserId;
  final String message;
  final int siteId;
  final DateTime createdAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;
  // The firing rule's target-role-tier at creation time (Sprint 022) — null
  // means the rule targeted a specific person instead of a tier. Nothing
  // to do with acknowledgment; used only to decide escalation eligibility.
  final RoleTier? originTargetRoleTier;
  final DateTime? escalatedAt;

  const TriggerNotification({
    required this.id,
    required this.notificationRuleId,
    required this.taskSubmissionId,
    required this.recipientUserId,
    required this.message,
    required this.siteId,
    required this.createdAt,
    required this.acknowledged,
    this.acknowledgedAt,
    this.originTargetRoleTier,
    this.escalatedAt,
  });
}
