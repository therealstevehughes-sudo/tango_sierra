import '../models/shift_period.dart';

abstract class ShiftPeriodRepository {
  Future<List<ShiftPeriod>> getForSite(int siteId);

  /// Replaces the ENTIRE period config for [siteId] with [periods] in one
  /// go — leadership picks "2 or 3 periods" as a whole shape, not
  /// individual add/remove operations, so a full replace is the natural
  /// operation here (same "replace-all" pattern ShiftRepository's own
  /// setIngredients-equivalent uses elsewhere for a similarly
  /// whole-config edit).
  Future<void> replaceAll(int siteId, List<ShiftPeriod> periods);
}
