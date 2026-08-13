import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum StatusKind { pass, caution, critical, overdue }

/// Never colour alone (DESIGN_SYSTEM_LOCK's Accessibility Rule and Colour
/// Logic — "use colour for state, not decoration"): every status pairs a
/// colour, an icon, and a short word, so a colourblind reader gets the same
/// information a sighted one does.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.kind, required this.label});

  final StatusKind kind;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData icon) = switch (kind) {
      StatusKind.pass => (
        AppColors.pass,
        AppColors.passBg,
        Icons.check_circle_outline,
      ),
      StatusKind.caution => (
        AppColors.caution,
        AppColors.cautionBg,
        Icons.error_outline,
      ),
      StatusKind.critical => (
        AppColors.critical,
        AppColors.criticalBg,
        Icons.cancel_outlined,
      ),
      // Due/overdue tracking (Sprint 031, Sub-sprint A): a distinct icon
      // (not error_outline, already caution's) keeps "overdue" from
      // reading as the same thing as a caution alert, while reusing the
      // caution colour tokens rather than adding a new one to the
      // deliberately minimal pass/caution/critical palette.
      StatusKind.overdue => (
        AppColors.caution,
        AppColors.cautionBg,
        Icons.schedule,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
