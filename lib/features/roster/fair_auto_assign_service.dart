import '../../shared/models/certification_requirement.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/training_record.dart';
import '../../shared/models/user.dart';

// Fair auto-assign (Rota calendar, Sprint 8, 2026-10-02) — direct founder
// request: manager ticks staff + shifts, hits one button, the app assigns
// fairly instead of each shift being assigned one at a time by hand.
//
// Hard constraints (a shift is simply never offered to a candidate that
// fails one of these — no override, no "assign anyway"):
//   - certification eligibility (same missingCertificationsForRole check
//     claim/managerAssign already enforce elsewhere)
//   - role match, when the shift has one (role_required is set by
//     ShiftRequirement-generated shifts; a shift with no role_required
//     accepts any job role)
//   - no day-off conflict (an approved or pending off-day request for
//     that date excludes the candidate — pending is treated as a
//     conflict too, since offering it a shift while a request sits
//     undecided would undermine the request)
//   - no double-booking, against both the candidate's existing real
//     shifts AND every assignment already proposed earlier in this same
//     run (so two shifts on the same tick don't get the same person
//     twice if their times overlap)
//
// Fairness beyond the hard constraints is explainable, not a black box:
// hardest-to-fill shifts (fewest eligible candidates) are assigned
// first, and among eligible candidates for a given shift, whoever has
// the fewest hours assigned SO FAR IN THIS RUN wins — a plain, auditable
// rule a manager could explain to staff, not a scored/ranked algorithm.
// Deliberately resets every run: this is round-robin over one batch of
// shifts, not a lifetime fairness ledger (that already exists separately
// as ShiftFairnessScreen's pattern review).
//
// Never writes anything itself — always returns a preview for the caller
// to show and let the manager confirm/edit before any managerAssign call
// happens, same "never auto-publish unreviewed" principle as the
// allergen tags and AI-drafted SOP documents.

class FairAssignProposal {
  const FairAssignProposal({required this.shift, this.user, this.reason});

  final Shift shift;
  final User? user;
  // Explanation shown in the preview — either why this candidate was
  // picked ("fewest hours assigned so far: 6h") or why nobody was
  // ("no eligible candidate among the selected staff").
  final String? reason;

  bool get isFilled => user != null;
}

List<FairAssignProposal> computeFairAutoAssignProposals({
  required List<Shift> candidateShifts,
  required List<User> candidateStaff,
  required List<Shift> allExistingShiftsForSite,
  required List<OffDayRequest> offDayRequestsForSite,
  required Map<int, List<TrainingRecord>> trainingRecordsByUserId,
  required List<SiteRoleCertificationRequirement> siteCertAdditions,
}) {
  bool overlaps(Shift a, Shift b) =>
      a.startsAt.isBefore(b.endsAt) && b.startsAt.isBefore(a.endsAt);

  bool hasDayOffConflict(User user, Shift shift) {
    final day = shift.startsAt;
    return offDayRequestsForSite.any(
      (r) =>
          r.userId == user.id &&
          r.status != OffDayRequestStatus.denied &&
          r.requestedDate.year == day.year &&
          r.requestedDate.month == day.month &&
          r.requestedDate.day == day.day,
    );
  }

  // Running state across the whole batch, updated as shifts get assigned.
  final hoursAssignedThisRun = <int, double>{
    for (final u in candidateStaff) u.id: 0,
  };
  final shiftsAssignedThisRun = <int, List<Shift>>{
    for (final u in candidateStaff) u.id: [],
  };

  bool isDoubleBooked(User user, Shift shift) {
    final existingReal = allExistingShiftsForSite.where(
      (s) =>
          (s.claimedByUserId == user.id) &&
          s.status != ShiftStatus.cancelled &&
          s.id != shift.id,
    );
    if (existingReal.any((s) => overlaps(s, shift))) return true;
    final existingProposed = shiftsAssignedThisRun[user.id] ?? const [];
    return existingProposed.any((s) => overlaps(s, shift));
  }

  bool isEligible(User user, Shift shift) {
    if (shift.roleRequired != null &&
        user.jobRole?.name != shift.roleRequired) {
      return false;
    }
    if (hasDayOffConflict(user, shift)) return false;
    if (isDoubleBooked(user, shift)) return false;
    final missing = missingCertificationsForRole(
      role: user.jobRole,
      records: trainingRecordsByUserId[user.id] ?? const [],
      siteAdditions: siteCertAdditions,
    );
    return missing.isEmpty;
  }

  // Hardest-to-fill first: fewest eligible candidates (at the time of
  // sorting — eligibility for other shifts can only shrink as the run
  // goes on, so earliest-counted is also the most accurate order).
  final shiftsByDifficulty = [...candidateShifts]..sort((a, b) {
    final countA = candidateStaff.where((u) => isEligible(u, a)).length;
    final countB = candidateStaff.where((u) => isEligible(u, b)).length;
    return countA.compareTo(countB);
  });

  final proposals = <FairAssignProposal>[];
  for (final shift in shiftsByDifficulty) {
    final eligible = candidateStaff.where((u) => isEligible(u, shift)).toList();
    if (eligible.isEmpty) {
      proposals.add(
        FairAssignProposal(
          shift: shift,
          reason: 'No eligible candidate among the selected staff.',
        ),
      );
      continue;
    }
    eligible.sort(
      (a, b) => (hoursAssignedThisRun[a.id] ?? 0).compareTo(
        hoursAssignedThisRun[b.id] ?? 0,
      ),
    );
    final chosen = eligible.first;
    final hoursBefore = hoursAssignedThisRun[chosen.id] ?? 0;
    final duration = shift.endsAt.difference(shift.startsAt);
    hoursAssignedThisRun[chosen.id] =
        hoursBefore + duration.inMinutes / 60.0;
    shiftsAssignedThisRun[chosen.id] = [
      ...(shiftsAssignedThisRun[chosen.id] ?? const []),
      shift,
    ];
    proposals.add(
      FairAssignProposal(
        shift: shift,
        user: chosen,
        reason:
            'Fewest hours assigned so far this run '
            '(${hoursBefore.toStringAsFixed(1)}h).',
      ),
    );
  }

  // Restore chronological order for display — difficulty order was only
  // needed to decide who gets picked, not how the preview reads.
  proposals.sort((a, b) => a.shift.startsAt.compareTo(b.shift.startsAt));
  return proposals;
}
