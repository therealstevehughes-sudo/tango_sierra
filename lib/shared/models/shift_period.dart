// Rota calendar, Sprint 1 (2026-10-01) — leadership-configured shift
// periods (e.g. Morning/Afternoon/Night), 2 or 3 per site, each with a
// time-of-day boundary. A shift's period is always DERIVED live from
// this config + its own startsAt — never stored on the shift itself, so
// a config change (e.g. splitting "Day" into "Morning"/"Afternoon")
// reclassifies every existing shift automatically rather than needing a
// backfill. Founder's own framing: "the calendar/rota feature adjusts
// accordingly" to however many periods leadership picks.
class ShiftPeriod {
  final int? id;
  final int siteId;
  final String name;
  // Minutes since midnight (0-1439), not a DateTime — these are pure
  // time-of-day boundaries, reused against every date a shift falls on.
  final int startMinutes;
  final int endMinutes;
  final int sortOrder;

  const ShiftPeriod({
    required this.id,
    required this.siteId,
    required this.name,
    required this.startMinutes,
    required this.endMinutes,
    required this.sortOrder,
  });

  /// Whether a shift starting at [timeOfDayMinutes] (minutes since
  /// midnight) falls in this period. Handles an overnight period (e.g.
  /// Night 22:00-06:00, where endMinutes < startMinutes) by treating it
  /// as wrapping past midnight.
  bool containsStartMinutes(int timeOfDayMinutes) {
    if (startMinutes <= endMinutes) {
      return timeOfDayMinutes >= startMinutes && timeOfDayMinutes < endMinutes;
    }
    // Overnight wrap: e.g. 22:00-06:00 matches 22:00-23:59 OR 00:00-05:59.
    return timeOfDayMinutes >= startMinutes || timeOfDayMinutes < endMinutes;
  }
}

/// Finds which of [periods] a shift starting at [shiftStart] falls into,
/// by time-of-day only (the date doesn't matter, only hour/minute).
/// Returns null if [periods] is empty (not configured yet) or no period's
/// window matches (shouldn't happen if periods cover the full 24h, but
/// not assumed/enforced here — an unconfigured gap just means
/// "uncategorised", not a crash).
ShiftPeriod? shiftPeriodFor(List<ShiftPeriod> periods, DateTime shiftStart) {
  final minutes = shiftStart.hour * 60 + shiftStart.minute;
  for (final period in periods) {
    if (period.containsStartMinutes(minutes)) return period;
  }
  return null;
}
