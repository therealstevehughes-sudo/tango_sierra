class SessionSummary {
  final int id;
  final int staffUserId;
  final String staffName;
  final int sentToManagerId;
  final int passCount;
  final int failCount;
  final List<String> failedTaskTitles;
  final String? note;
  final DateTime sentAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;
  final int siteId;

  const SessionSummary({
    required this.id,
    required this.staffUserId,
    required this.staffName,
    required this.sentToManagerId,
    required this.passCount,
    required this.failCount,
    required this.failedTaskTitles,
    this.note,
    required this.sentAt,
    required this.acknowledged,
    this.acknowledgedAt,
    required this.siteId,
  });
}
