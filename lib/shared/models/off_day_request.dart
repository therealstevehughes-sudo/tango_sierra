// Off-day requests (R5, 2026-09-27) — backend-only, no local Drift mirror,
// same reasoning as Shift itself: a request and its approval are two
// parties needing to see the same live state, not a local habit-tracking
// log. Staged: the off_day_requests table doesn't exist on the server yet
// (see BACKEND_INFRA.md's R5 entry) — this model/repository compile and are
// ready, but calls will fail until that migration is applied.
enum OffDayRequestStatus { pending, approved, denied }

OffDayRequestStatus offDayRequestStatusFromString(String value) {
  switch (value) {
    case 'pending':
      return OffDayRequestStatus.pending;
    case 'approved':
      return OffDayRequestStatus.approved;
    case 'denied':
      return OffDayRequestStatus.denied;
    default:
      throw ArgumentError('Unknown off-day request status: $value');
  }
}

String offDayRequestStatusToString(OffDayRequestStatus status) {
  switch (status) {
    case OffDayRequestStatus.pending:
      return 'pending';
    case OffDayRequestStatus.approved:
      return 'approved';
    case OffDayRequestStatus.denied:
      return 'denied';
  }
}

class OffDayRequest {
  const OffDayRequest({
    required this.id,
    required this.siteId,
    required this.userId,
    required this.requestedDate,
    this.reason,
    required this.status,
    this.decidedByUserId,
    this.decidedAt,
    required this.createdAt,
  });

  final int id;
  final int siteId;
  final int userId;
  final DateTime requestedDate;
  final String? reason;
  final OffDayRequestStatus status;
  final int? decidedByUserId;
  final DateTime? decidedAt;
  final DateTime createdAt;
}
