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

// Audit trail row (R4, 2026-09-27) — one event per claim/cancel/manager
// action, read back for ShiftReliabilityService's own-standing computation.
// Never exposed as a per-person list to peers/managers — see
// ShiftReliabilityService's doc comment for the anti-gaming rule this
// mirrors from ReliabilitySummary.
enum ShiftClaimEventType { claimed, cancelled, managerAssigned, managerRemoved }

ShiftClaimEventType shiftClaimEventTypeFromString(String value) {
  switch (value) {
    case 'claimed':
      return ShiftClaimEventType.claimed;
    case 'cancelled':
      return ShiftClaimEventType.cancelled;
    case 'manager_assigned':
      return ShiftClaimEventType.managerAssigned;
    case 'manager_removed':
      return ShiftClaimEventType.managerRemoved;
    default:
      throw ArgumentError('Unknown shift claim event type: $value');
  }
}

class ShiftClaimEvent {
  const ShiftClaimEvent({
    required this.id,
    required this.shiftId,
    required this.userId,
    required this.eventType,
    required this.actorUserId,
    required this.createdAt,
    this.shiftStartsAt,
  });

  final int id;
  final int shiftId;
  final int userId;
  final ShiftClaimEventType eventType;
  final int actorUserId;
  final DateTime createdAt;
  // Embedded from the related shift (via PostgREST's foreign-table select)
  // so lateness can be judged without a second round trip — null only if
  // the embed wasn't requested or the shift has since been deleted.
  final DateTime? shiftStartsAt;
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
  // Priority claim window (Phase R4, staged — the `priority_until` column
  // doesn't exist on the server yet, so this always parses null until that
  // migration is applied; see BACKEND_INFRA.md's R4 entry). Once live: only
  // staff above the reliability floor can claim before this timestamp: after
  // it, the shift opens to everyone. Null means no priority window at all
  // (either not yet migrated, or the shift was posted before this existed).
  final DateTime? priorityUntil;
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
    this.priorityUntil,
    this.claimedByUserId,
    this.assignedByUserId,
    required this.createdByUserId,
    required this.createdAt,
    this.cancelledAt,
    this.cancelledByUserId,
    this.cancellationReason,
  });
}
