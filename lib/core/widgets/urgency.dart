import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// Urgency colour-coding (2026-09-17), per the user's request: green/amber/
// red grading on how long something has sat unresolved, separate from the
// existing status colours (StatusBadge/_StatusPill/_ProblemStatusChip
// already own red/green/grey for the fail/resolved/escalated OUTCOME).
// This grades staleness, not outcome, so it's shown alongside those, never
// instead of them.
//
// Deliberately additive-only: a manual "mark as urgent" flag or an
// escalated status can only push a row UP to urgent, never down — matches
// the app's standing anti-gaming rule (nobody can talk a real problem back
// down the scale).
enum UrgencyLevel { none, low, medium, high }

// One universal threshold set across Problems Register + Issues &
// Incidents to start (confirmed with the user) — per-type thresholds
// (e.g. a food-safety hazard needing a tighter window) are a later
// refinement if real usage shows it's needed, not built speculatively now.
UrgencyLevel computeUrgency({
  required DateTime since,
  bool escalated = false,
  bool manualUrgent = false,
  bool immediateUrgent = false,
}) {
  if (escalated || manualUrgent || immediateUrgent) return UrgencyLevel.high;
  final age = DateTime.now().difference(since);
  if (age > const Duration(hours: 72)) return UrgencyLevel.high;
  if (age > const Duration(hours: 24)) return UrgencyLevel.medium;
  return UrgencyLevel.low;
}

(Color, Color, String?) urgencyColors(UrgencyLevel level) {
  switch (level) {
    case UrgencyLevel.high:
      return (AppColors.critical, AppColors.criticalBg, 'URGENT');
    case UrgencyLevel.medium:
      return (AppColors.caution, AppColors.cautionBg, null);
    case UrgencyLevel.low:
      return (AppColors.pass, AppColors.passBg, null);
    case UrgencyLevel.none:
      return (AppColors.ink, AppColors.line, null);
  }
}

/// A small coloured stripe (for the tile's edge) plus, only when urgent, an
/// "URGENT" chip — kept separate from the outcome-status pill/badge that
/// already sits on these tiles.
class UrgencyChip extends StatelessWidget {
  const UrgencyChip({super.key, required this.level});

  final UrgencyLevel level;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, label) = urgencyColors(level);
    if (label == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// A thin coloured left edge on a tile, indicating urgency at a glance
/// without needing to read any text.
class UrgencyStripe extends StatelessWidget {
  const UrgencyStripe({super.key, required this.level, required this.child});

  final UrgencyLevel level;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (fg, _, _) = urgencyColors(level);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: fg, width: 4)),
      ),
      child: child,
    );
  }
}
