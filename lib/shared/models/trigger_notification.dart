class TriggerNotification {
  final int id;
  final int notificationRuleId;
  final int taskSubmissionId;
  final int recipientUserId;
  final String message;
  final int siteId;
  final DateTime createdAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;

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
  });
}
