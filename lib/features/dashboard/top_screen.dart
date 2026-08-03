import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/trigger_notification.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backup_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../notifications/escalation_service.dart';
import '../notifications/notification_rules_screen.dart';
import '../onboarding/staff_assignment_screen.dart';
import '../settings/staff_management_screen.dart';
import '../settings/third_party_contacts_screen.dart';
import '../settings/venue_details_screen.dart';
import '../venue_setup/venue_setup_wizard_screen.dart';

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
        title: const Text('Top-Tier View'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VenueSetupWizardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.store),
            tooltip: 'Venue Setup',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VenueDetailsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.location_city),
            tooltip: 'Venue Details',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffAssignmentScreen(),
                ),
              );
            },
            icon: const Icon(Icons.assignment_ind),
            tooltip: 'Assign Tasks',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.badge),
            tooltip: 'Staff Management',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationRulesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
            tooltip: 'Notification Rules',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThirdPartyContactsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.contact_phone),
            tooltip: 'Maintenance Contacts',
          ),
          IconButton(
            onPressed: () => _showBackupDialog(context, ref),
            icon: const Icon(Icons.backup),
            tooltip: 'Back Up Now',
          ),
          IconButton(
            onPressed: () {
              ref.read(currentUserProvider.notifier).state = null;
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Column(
        children: [
          if (currentUser != null)
            StreamBuilder<List<TriggerNotification>>(
              stream: triggerNotificationRepo.watchForUser(currentUser.id),
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];
                if (notifications.isEmpty) return const SizedBox.shrink();
                return _TriggerNotificationsBanner(
                  notifications: notifications,
                  onAcknowledge: triggerNotificationRepo.acknowledge,
                );
              },
            ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Dashboards, exports, and branding controls are coming in a later sprint.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      width: double.infinity,
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
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
                        Text(
                          notification.message,
                          style: isOverdue
                              ? const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                )
                              : null,
                        ),
                        if (isOverdue)
                          Text(
                            'OVERDUE — unacknowledged for '
                            '${now.difference(notification.createdAt).inMinutes} min',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (notification.escalatedAt != null)
                          const Text(
                            'Escalated to top tier',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
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
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
