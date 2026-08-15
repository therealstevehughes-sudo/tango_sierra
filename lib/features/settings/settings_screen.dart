import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

// Settings shell (Sprint 031, Build Order item 5, Sub-sprint C). Two
// sections: Personal (any user, self-serve) and Venue (venueManager tier
// and above — matches the "Settings layer" decision and every other
// venue-configuration screen's access level). Deliberately does NOT
// duplicate ManagementDrawer's operational tools (Assign Tasks, Staff
// Management, Department/Supplier Management, etc.) — those already have
// one home, reached via Oversight's drawer, per the explicit "one path to
// each tool" instruction from the tier-home-screen build. This screen is
// for preferences/config, not a second way to reach existing screens.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final canSeeVenueSettings =
        currentUser != null &&
        roleTierRank(currentUser.roleTier) >= roleTierRank(RoleTier.venueManager);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const ManagementDrawer(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Personal'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentUser != null)
                  _TemperatureUnitSetting(currentUser: currentUser),
                const Divider(height: 24),
                const _ComingSoonTile(label: 'Dark Mode'),
                const _ComingSoonTile(label: 'Language'),
              ],
            ),
          ),
          if (canSeeVenueSettings) ...[
            const SizedBox(height: 24),
            const SectionHeader(title: 'Venue'),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ComingSoonTile(label: 'Branding'),
                  _ComingSoonTile(label: 'Login Layout'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TemperatureUnitSetting extends ConsumerWidget {
  const _TemperatureUnitSetting({required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Expanded(child: Text('Temperature unit')),
        DropdownButton<TemperatureUnit>(
          value: currentUser.preferredTemperatureUnit,
          items: const [
            DropdownMenuItem(
              value: TemperatureUnit.celsius,
              child: Text('Celsius (°C)'),
            ),
            DropdownMenuItem(
              value: TemperatureUnit.fahrenheit,
              child: Text('Fahrenheit (°F)'),
            ),
          ],
          onChanged: (unit) async {
            if (unit == null || unit == currentUser.preferredTemperatureUnit) {
              return;
            }
            final repo = ref.read(userRepositoryProvider);
            await repo.setPreferredTemperatureUnit(
              userId: currentUser.id,
              unit: unit,
            );
            ref.read(currentUserProvider.notifier).state = currentUser
                .copyWith(preferredTemperatureUnit: unit);
          },
        ),
      ],
    );
  }
}

class _ComingSoonTile extends StatelessWidget {
  const _ComingSoonTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor),
            ),
          ),
          Text(
            'Coming soon',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
