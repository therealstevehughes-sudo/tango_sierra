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

/// The colour for AppCard's `accentColor` left-edge stripe — null for
/// [UrgencyLevel.none] so a resolved/non-urgent card gets no stripe at all,
/// rather than a dark neutral-coloured one nobody needs to see.
///
/// Previously its own `UrgencyStripe` wrapper widget, drawn as a plain
/// rectangular border OUTSIDE AppCard — removed 2026-09-18 because it sat
/// behind AppCard's own opaque rounded background and only ever showed as
/// a short, broken sliver in the rounded-corner gap, not a continuous
/// edge. AppCard now draws this stripe itself, clipped to its own
/// borderRadius, so it reads as part of the card's frame.
Color? urgencyStripeColor(UrgencyLevel level) {
  if (level == UrgencyLevel.none) return null;
  final (fg, _, _) = urgencyColors(level);
  return fg;
}
