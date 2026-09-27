import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/shift.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/repositories/shift_repository.dart';

// Roster reliability (R4, 2026-09-27) — mirrors reliability_service.dart's
// own governance rule exactly: this must never become a ranked, per-person
// score list a manager or peer can browse. A person can see only their OWN
// standing, framed descriptively (never a number) — see
// ShiftReliabilityStanding. The claim_shift RPC will (once the priority-
// window migration is applied server-side, staged pending SSH access — see
// BACKEND_INFRA.md's R4 entry) use a numeric score internally to decide
// priority-window eligibility, but that number is never surfaced to the app.
//
// Score inputs: a kept claim counts positively; a cancellation counts
// against it, weighted by how late it was (the existing <24h warning copy
// in claim_board_screen.dart becomes real here — a same-day cancellation
// costs more than an early one). A manager removing someone's claim
// (manager_removed) is NOT held against the person removed — that's a
// manager decision, not a reliability failure by the staff member.
enum ShiftReliabilityStanding {
  buildingTrackRecord, // fewer than [minEventsForStanding] events yet
  reliable,
  needsImprovement,
}

class ShiftReliabilitySummary {
  const ShiftReliabilitySummary({
    required this.kept,
    required this.cancelledEarly,
    required this.cancelledLate,
  });

  final int kept;
  final int cancelledEarly;
  final int cancelledLate;

  int get totalDecisions => kept + cancelledEarly + cancelledLate;

  // Weighted: a late cancellation counts double against a kept claim, an
  // early one counts single — never exposed as a raw number, only through
  // [standing] below.
  double get _weightedScore {
    if (totalDecisions == 0) return 1;
    final penalised = cancelledEarly + (cancelledLate * 2);
    return kept / (kept + penalised);
  }

  static const minEventsForStanding = 3;

  ShiftReliabilityStanding get standing {
    if (totalDecisions < minEventsForStanding) {
      return ShiftReliabilityStanding.buildingTrackRecord;
    }
    return _weightedScore >= 0.7
        ? ShiftReliabilityStanding.reliable
        : ShiftReliabilityStanding.needsImprovement;
  }
}

const _lateCancellationWindow = Duration(hours: 24);

class ShiftReliabilityService {
  ShiftReliabilityService(this._shiftRepository);

  final ShiftRepository _shiftRepository;

  Future<ShiftReliabilitySummary> computeForUser(
    int userId, {
    Duration lookback = const Duration(days: 90),
  }) async {
    final since = DateTime.now().subtract(lookback);
    final events = await _shiftRepository.getClaimHistoryForUser(
      userId,
      since: since,
    );

    // Group by shift first — one claim episode can produce multiple events
    // (a "claimed" row, then later a "cancelled" row for the same shift),
    // and only the LATEST event per shift decides its final outcome. Events
    // arrive most-recent-first (see getClaimHistoryForUser's ordering), so
    // the first event seen per shiftId is already the latest one.
    final latestEventPerShift = <int, ShiftClaimEvent>{};
    for (final event in events) {
      latestEventPerShift.putIfAbsent(event.shiftId, () => event);
    }

    var kept = 0;
    var cancelledEarly = 0;
    var cancelledLate = 0;

    for (final event in latestEventPerShift.values) {
      switch (event.eventType) {
        case ShiftClaimEventType.claimed:
        case ShiftClaimEventType.managerAssigned:
          kept++;
        case ShiftClaimEventType.cancelled:
          final shiftStartsAt = event.shiftStartsAt;
          final isLate =
              shiftStartsAt != null &&
              shiftStartsAt.difference(event.createdAt) <
                  _lateCancellationWindow;
          if (isLate) {
            cancelledLate++;
          } else {
            cancelledEarly++;
          }
        case ShiftClaimEventType.managerRemoved:
          // Deliberately excluded — see file doc comment.
          break;
      }
    }

    return ShiftReliabilitySummary(
      kept: kept,
      cancelledEarly: cancelledEarly,
      cancelledLate: cancelledLate,
    );
  }
}

final shiftReliabilityServiceProvider = Provider<ShiftReliabilityService>(
  (ref) => ShiftReliabilityService(ref.watch(shiftRepositoryProvider)),
);
