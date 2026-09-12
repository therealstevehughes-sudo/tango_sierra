import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../shared/models/trigger_notification.dart';
import '../../features/notifications/escalation_service.dart';

/// Manager/director alert banner (extracted 2026-09-12 from
/// `manager_screen.dart` + `top_screen.dart`'s duplicated
/// `_TriggerNotificationsBanner`).
///
/// Busy-oversight declutter (Sprint 031): Card+ExpansionTile,
/// initiallyExpanded: true — alerts are urgent, so this starts open, but
/// stays tap-to-collapse once read so it doesn't permanently occupy space.
///
/// Two screens use it with deliberately different row behavior:
/// - The manager screen passes `onRowTap` so a row opens the failed task's
///   detail dialog (alert → task drill-down, 2026-09-12).
/// - The top-tier screen passes none, so rows stay non-tappable.
/// The chrome (count, unacknowledged, overdue styling) is identical.
class TriggerNotificationsBanner extends StatelessWidget {
  const TriggerNotificationsBanner({
    super.key,
    required this.notifications,
    required this.onAcknowledge,
    this.onRowTap,
  });

  final List<TriggerNotification> notifications;
  final void Function(int id) onAcknowledge;

  /// Optional row-tap handler — passed only where the alert→task
  /// drill-down exists (manager screen). When null, rows are plain.
  final void Function(TriggerNotification notification)? onRowTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final unacknowledged = notifications.where((n) => !n.acknowledged).length;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.notifications, color: AppColors.critical),
        title: Text(
          '${notifications.length} alert${notifications.length == 1 ? '' : 's'}',
        ),
        subtitle: unacknowledged > 0
            ? Text(
                '$unacknowledged unacknowledged',
                style: const TextStyle(
                  color: AppColors.critical,
                  fontWeight: FontWeight.w700,
                ),
              )
            : const Text('All acknowledged'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ...notifications.map((notification) {
            final isOverdue =
                !notification.acknowledged &&
                now.difference(notification.createdAt) >= escalationThreshold;
            final row = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instance-name prominence (2026-09-06): shared by
                      // both screens' banners — an alert without the
                      // physical unit is ambiguous (two failing fridges).
                      if (notification.equipmentInstanceName != null)
                        Text(
                          notification.equipmentInstanceName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                      Text(
                        notification.message,
                        style: isOverdue
                            ? const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.critical,
                              )
                            : null,
                      ),
                      if (isOverdue)
                        Text(
                          'OVERDUE — unacknowledged for '
                          '${now.difference(notification.createdAt).inMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.critical,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      if (notification.escalatedAt != null)
                        Text(
                          'Escalated to top tier',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppColors.muted,
                              ),
                        ),
                    ],
                  ),
                ),
                if (!notification.acknowledged)
                  TextButton(
                    onPressed: () => onAcknowledge(notification.id),
                    child: const Text('Acknowledge'),
                  )
                else
                  const Icon(Icons.check, color: AppColors.pass),
              ],
            );
            final rowTap = onRowTap;
            // Improvement (2026-09-12): the manager screen's row is
            // tappable to open the specific failed task — "There's an
            // alert" becomes "which task, which equipment, who, is it
            // handled" in one tap (control, not just visibility). Top-tier
            // keeps the plain row.
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: rowTap == null
                  ? row
                  : InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => rowTap(notification),
                      child: row,
                    ),
            );
          }),
        ],
      ),
    );
  }
}
