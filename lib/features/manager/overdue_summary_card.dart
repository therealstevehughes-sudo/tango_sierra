import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../tasks/overdue_summary_service.dart';

// Manager-facing overdue tracking (Sprint 031, Sub-sprint D). Collapsed by
// default (Card+ExpansionTile, matching ManagerLogFilter's established
// pattern) — a bare "N overdue" count isn't actionable on its own, a
// manager needs to see whose and what, but the same lesson from the
// manager log applies: don't let that detail permanently occupy screen
// space. Grouped by staff, capped, rather than one line per task.
class OverdueSummaryCard extends StatelessWidget {
  const OverdueSummaryCard({super.key, required this.entries});

  final List<OverdueSummaryEntry> entries;

  static const _maxStaffShown = 5;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final byStaff = <String, List<OverdueSummaryEntry>>{};
    for (final entry in entries) {
      byStaff.putIfAbsent(entry.staffName, () => []).add(entry);
    }
    final staffNames = byStaff.keys.toList();
    final shown = staffNames.take(_maxStaffShown).toList();
    final remaining = staffNames.length - shown.length;

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.schedule, color: AppColors.caution),
        title: Text(
          '${entries.length} task${entries.length == 1 ? '' : 's'} overdue',
        ),
        subtitle: Text(
          'Across ${staffNames.length} staff member'
          '${staffNames.length == 1 ? '' : 's'}',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final staffName in shown)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staffName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  for (final entry in byStaff[staffName]!)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(color: AppColors.critical),
                          children: [
                            // Instance-name prominence (2026-09-06): found
                            // while fixing the other four surfaces — this
                            // card previously had no instance disambiguation
                            // at all, so two overdue fridges were identical.
                            if (entry.equipmentInstanceName != null)
                              TextSpan(
                                text: '${entry.equipmentInstanceName} — ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            TextSpan(
                              text: entry.overdueSince == null
                                  ? entry.taskTitle
                                  : '${entry.taskTitle} — overdue since '
                                        '${formatDate(entry.overdueSince!)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (remaining > 0)
            Text(
              '+$remaining more staff member${remaining == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
