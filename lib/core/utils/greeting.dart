/// Login-screen warmth pass (2026-09-17) — a small human touch, computed
/// client-side from the device clock. Deliberately not persisted or
/// timezone-aware beyond the device's own local time; this is decorative
/// copy, not a compliance-relevant timestamp.
String timeAwareGreeting([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
