import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// Worker recognition (Sprint 031, dashboard + worker recognition). A neutral,
// non-graded counterpart to StatusBadge — always the same teal informational
// tone regardless of the value shown. Reserved specifically for figures that
// must never carry judgment (a worker's completion %/on-time % score): never
// use pass/caution/critical colouring here, or a "92% completed" reading as
// green and a "45% completed" reading as red/amber would silently reintroduce
// the graded, pass-rate-flavoured feel the scoring rule exists to avoid.
// FAILs/overdue counts are a different kind of figure (legitimate compliance
// alerts, not a person's score) and should keep using StatusBadge instead.
class MetricChip extends StatelessWidget {
  const MetricChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tealTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.tealInk),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.tealInk,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
