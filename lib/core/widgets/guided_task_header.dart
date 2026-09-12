import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../features/tasks/task_model.dart';

// Guided Cards (Sprint 2 visual follow-up, 2026-09-12): the worker's
// task-presentation upgrade — a "guided" header that tells a staff member
// WHERE they are in the day and WHICH work area they're in, without adding
// any task logic or changing what they must enter. Three deliberate
// elements, all strictly informational:
//
//  1. A progress line ("Task 2 of 6") — the single strongest anti-skip
//     signal this app can add: a worker who knows they have 4 checks left
//     is measurably less likely to wander off after the 2nd. It reads from
//     the controller's own index, so it can never disagree with the
//     carousel's actual position.
//  2. A section pill (segment — "Kitchen", "Dry store", etc.) — orients
//     the worker to the work area the check belongs to. Blank segments are
//     hidden (custom tasks), never shown as an empty pill.
//  3. The equipment-instance line + task title, exactly as the previous
//     header rendered them — kept unchanged so the compliance-critical
//     "which physical unit" text is untouched.
//
// This header replaces _TaskTitleHeader in task_screen.dart. It deliberately
// does NOT add colour-as-decoration, new tokens, or a graded look: teal
// stays the only accent, and the section pill reuses the neutral
// `tealTint`/`tealInk` informational tone (same language as MetricChip),
// never pass/caution/critical.
class GuidedTaskHeader extends StatelessWidget {
  const GuidedTaskHeader({
    super.key,
    required this.task,
    required this.position,
    required this.total,
  });

  final ResolvedTask task;
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    final instanceName = task.equipmentInstanceName;
    final segment = task.segment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress line — "Task 2 of 6". Only shown when there's more than
        // one task, so a lone "Task 1 of 1" never reads as noise.
        if (total > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Task $position of $total',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        // Section pill — the work area this check belongs to. Hidden when
        // the segment is blank (custom tasks carry no segment).
        if (segment.isNotEmpty) ...[
          const SizedBox(height: 2),
          _SegmentPill(label: segment),
          const SizedBox(height: 8),
        ],
        if (instanceName != null) ...[
          Text(
            instanceName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.teal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

/// The small teal pill that labels a task's work area. Reuses the neutral
/// informational tone (tealTint/tealInk) — never a status colour — so a
/// section reads as orientation, not as pass/fail judgment.
class _SegmentPill extends StatelessWidget {
  const _SegmentPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tealTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.place_outlined, size: 14, color: AppColors.tealInk),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.tealInk,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
