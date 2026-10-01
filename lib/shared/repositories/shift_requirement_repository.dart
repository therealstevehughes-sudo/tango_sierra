import '../models/shift_requirement.dart';

abstract class ShiftRequirementRepository {
  Future<List<ShiftRequirement>> getForSite(int siteId);

  Future<ShiftRequirement> create(ShiftRequirement requirement);

  Future<void> delete(int id);

  /// Turns every requirement into real open Shift rows for the week
  /// starting [weekStart] (a Monday) — [requiredCount] regular shifts plus
  /// [standbyCount] standby-flagged ones, per requirement, on whichever
  /// date in that week matches its dayOfWeek. Idempotency is NOT
  /// attempted here (calling this twice for the same week creates
  /// duplicate shifts) — the UI's own "Generate" button is a deliberate,
  /// one-off action a manager takes once per week, same trust model as
  /// every other manual action in this app; a safety re-check is a
  /// reasonable follow-up, not built in this pass.
  Future<int> generateShiftsForWeek({
    required int siteId,
    required DateTime weekStart,
    required int createdByUserId,
  });
}
