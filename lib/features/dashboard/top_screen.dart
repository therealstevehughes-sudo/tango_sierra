import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/models/trigger_notification.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backup_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../export/eho_export_dialog.dart';
import '../notifications/escalation_service.dart';
import 'dashboard_screen.dart';

Future<void> _showBackupDialog(BuildContext context, WidgetRef ref) async {
  final nameController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Back Up Now'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This creates a complete copy of the local database in your '
            'Documents folder. Moving it to a USB drive or cloud-synced '
            'folder afterward is a separate manual step.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Backup name (optional)',
              hintText: 'e.g. Pre-inspection backup',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Back Up Now'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  final repo = ref.read(backupRepositoryProvider);
  final path = await repo.createBackup(
    customName: nameController.text.trim().isEmpty
        ? null
        : nameController.text.trim(),
  );

  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Backup Created'),
      content: Text('Saved to:\n$path'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class TopScreen extends ConsumerStatefulWidget {
  const TopScreen({super.key});

  @override
  ConsumerState<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends ConsumerState<TopScreen> {
  Timer? _escalationTimer;

  @override
  void initState() {
    super.initState();
    _runEscalationCheck();
    _escalationTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _runEscalationCheck(),
    );
  }

  @override
  void dispose() {
    _escalationTimer?.cancel();
    super.dispose();
  }

  // Runs on load and every tick thereafter — the only realistic mechanism
  // for a purely local app with no background service. If nobody has this
  // screen open, nothing escalates; the setState afterward also keeps the
  // banner's overdue styling fresh even on ticks that escalate nothing.
  Future<void> _runEscalationCheck() async {
    await ref.read(escalationServiceProvider).checkAndEscalate();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final triggerNotificationRepo = ref.watch(
      triggerNotificationRepositoryProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text('Top-Tier View'),
      ),
      // Sub-sprint 2 (visual/UX pass): see manager_screen.dart's identical
      // change for the rationale — replaces the previous 9-icon,
      // tooltip-only AppBar action row.
      drawer: ManagementDrawer(
        title: 'Top-Tier View',
        onBackUp: () => _showBackupDialog(context, ref),
        onEhoExport: () => showEhoExportDialog(context, ref),
      ),
      body: Column(
        children: [
          if (currentUser != null)
            StreamBuilder<List<TriggerNotification>>(
              stream: triggerNotificationRepo.watchForUser(currentUser.id),
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];
                if (notifications.isEmpty) return const SizedBox.shrink();
                // Responsive foundation: capped to the same width as
                // DashboardBody below it, so the two don't visually
                // mismatch on a wide screen. Safe to wrap here (unlike the
                // Expanded content below) since this banner has no flex
                // layout of its own to disrupt.
                return ResponsiveContent(
                  child: _TriggerNotificationsBanner(
                    notifications: notifications,
                    onAcknowledge: triggerNotificationRepo.acknowledge,
                  ),
                );
              },
            ),
          // Dashboard + worker recognition, Sub-sprint C: reuses the exact
          // same DashboardBody Sub-sprint B built for supervisor/venueManager
          // — same venue-scoped view (currentUser.siteId), same anti-gaming
          // display rules (alphabetical roster, neutral chips, no per-person
          // FAIL counts). Cross-venue comparison stays deferred until
          // multi-site is actually usable — see DECISIONS_LOG.md.
          const Expanded(child: DashboardBody(aggregatePermittedSites: true)),
        ],
      ),
    );
  }
}

// Busy-oversight declutter (Sprint 031): matches manager_screen.dart's
// identical change — Card+ExpansionTile, initiallyExpanded: true (alerts
// start open, since they're urgent, but stay tap-to-collapse once read
// rather than permanently occupying space). Same duplicated-per-screen
// pattern as everywhere else between ManagerScreen/TopScreen.
class _TriggerNotificationsBanner extends StatelessWidget {
  const _TriggerNotificationsBanner({
    required this.notifications,
    required this.onAcknowledge,
  });

  final List<TriggerNotification> notifications;
  final void Function(int id) onAcknowledge;

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instance-name prominence (2026-09-06): same fix
                        // as manager_screen.dart's identical banner.
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
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.critical,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (notification.escalatedAt != null)
                          Text(
                            'Escalated to top tier',
                            style: TextStyle(
                              fontSize: 12,
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
              ),
            );
          }),
        ],
      ),
    );
  }
}
