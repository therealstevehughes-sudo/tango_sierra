// Shift log (2026-09-24, direct user request) — a lightweight habit-
// tracking record of when someone logged in/out for a shift. Deliberately
// NOT a payroll or Working Time Regulations record — no claim is made
// about accuracy for pay/legal purposes, it's a "did people show up on
// time" signal for management, framed the same way the user themselves
// asked for it ("a good habit builder", not "a regulation burdened
// item"). A null [clockOutAt] means the shift is still open, or the app
// was closed without an explicit "End shift" tap — an accepted gap given
// what this is for.
class ShiftLog {
  final int id;
  final int userId;
  final int? siteId;
  final DateTime clockInAt;
  final DateTime? clockOutAt;

  const ShiftLog({
    required this.id,
    required this.userId,
    this.siteId,
    required this.clockInAt,
    this.clockOutAt,
  });

  Duration? get duration => clockOutAt?.difference(clockInAt);
}
