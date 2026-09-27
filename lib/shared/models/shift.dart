// Roster add-on (2026-09-27) — a manager-posted, staff-claimable shift.
// Backend-only, no local Drift mirror (see ShiftRepository's own doc
// comment) — claiming is a race condition that only a single source of
// truth with an atomic write can resolve safely, unlike ShiftLog's
// clock-in/out habit tracker, which is fine local-only.
enum ShiftStatus { open, claimed, assigned, cancelled, completed, noShow }

ShiftStatus shiftStatusFromString(String value) {
  switch (value) {
    case 'open':
      return ShiftStatus.open;
    case 'claimed':
      return ShiftStatus.claimed;
    case 'assigned':
      return ShiftStatus.assigned;
    case 'cancelled':
      return ShiftStatus.cancelled;
    case 'completed':
      return ShiftStatus.completed;
    case 'no_show':
      return ShiftStatus.noShow;
    default:
      throw ArgumentError('Unknown shift status: $value');
  }
}

String shiftStatusToString(ShiftStatus status) {
  switch (status) {
    case ShiftStatus.open:
      return 'open';
    case ShiftStatus.claimed:
      return 'claimed';
    case ShiftStatus.assigned:
      return 'assigned';
    case ShiftStatus.cancelled:
      return 'cancelled';
    case ShiftStatus.completed:
      return 'completed';
    case ShiftStatus.noShow:
      return 'no_show';
  }
}

class Shift {
  final int id;
  final int siteId;
  final int? departmentId;
  final String? roleRequired;
  // Manager-defined free-text label (e.g. "opening"/"closing") — drives
  // the per-category weekly claim cap once that's built (Phase R4,
  // deferred); purely descriptive until then.
  final String? category;
  final DateTime startsAt;
  final DateTime endsAt;
  final String? notes;
  final ShiftStatus status;
  final int? claimedByUserId;
  final int? assignedByUserId;
  final int createdByUserId;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final int? cancelledByUserId;
  final String? cancellationReason;

  const Shift({
    required this.id,
    required this.siteId,
    this.departmentId,
    this.roleRequired,
    this.category,
    required this.startsAt,
    required this.endsAt,
    this.notes,
    required this.status,
    this.claimedByUserId,
    this.assignedByUserId,
    required this.createdByUserId,
    required this.createdAt,
    this.cancelledAt,
    this.cancelledByUserId,
    this.cancellationReason,
  });
}
