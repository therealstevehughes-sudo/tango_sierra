import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/trigger_notification.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../notifications/notification_rules_screen.dart';
import '../onboarding/staff_assignment_screen.dart';
import '../venue_setup/venue_setup_wizard_screen.dart';

class TopScreen extends ConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  builder: (_) => const NotificationRulesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
            tooltip: 'Notification Rules',
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
          ...notifications.map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(notification.message)),
                  if (!notification.acknowledged)
                    TextButton(
                      onPressed: () => onAcknowledge(notification.id),
                      child: const Text('Acknowledge'),
                    )
                  else
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
