// Fails & Problems Register (Part A) — one row per open/resolved
// transition. The append-only audit trail behind TaskSubmission's
// denormalized problemStatus field.
enum ProblemStatus { open, resolved }

class ProblemStatusEvent {
  final int id;
  final int taskSubmissionId;
  final ProblemStatus status;
  final int changedByUserId;
  final DateTime changedAt;
  final String? note;

  const ProblemStatusEvent({
    required this.id,
    required this.taskSubmissionId,
    required this.status,
    required this.changedByUserId,
    required this.changedAt,
    this.note,
  });
}
