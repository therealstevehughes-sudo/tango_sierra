import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/auth_providers.dart';
import '../venue_setup/venue_setup_wizard_screen.dart';

class TopScreen extends ConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ref.read(currentUserProvider.notifier).state = null;
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Dashboards, exports, and branding controls are coming in a later sprint.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
