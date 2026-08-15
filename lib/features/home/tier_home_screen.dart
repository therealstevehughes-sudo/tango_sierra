import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../dashboard/top_screen.dart';
import '../manager/manager_screen.dart';
import '../tasks/task_screen.dart';

// Tier home screen (Sprint 031, Build Order item 5, Sub-sprint A) — closes
// the "My Tasks navigation fix" gap for good: every non-base tier previously
// landed directly on their oversight screen (ManagerScreen/TopScreen) with
// no path back to TaskScreen at all, making any task tiered to
// supervisor/venueManager/regional/executive (31 of them in the real
// library) assignable but architecturally uncompletable. base tier is
// deliberately unchanged — a Kitchen Porter has one job and lands straight
// on TaskScreen, no home menu, per the Staff Task Screen Rule's minimalism.
//
// Navigation-consistency pass (Sprint 031): the standalone "Settings"
// button from Sub-sprint C is gone — Settings is now a `ManagementDrawer`
// item, reachable the same way from every non-base screen, not a
// TierHomeScreen-only button. My Tasks / Oversight stay as the two big
// buttons here — the primary "what do you want to do" choice when already
// home — while the drawer covers always-available navigation from anywhere.
class TierHomeScreen extends ConsumerWidget {
  const TierHomeScreen({super.key});

  static Widget oversightScreenFor(RoleTier tier) {
    return (tier == RoleTier.regional || tier == RoleTier.executive)
        ? const TopScreen()
        : const ManagerScreen();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text('Home'),
        actions: [
          TextButton.icon(
            onPressed: () =>
                ref.read(currentUserProvider.notifier).state = null,
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Log out'),
          ),
        ],
      ),
      // Navigation-consistency pass (Sprint 031): the same drawer every
      // non-base screen now has — Home/My Tasks/Oversight/Settings/tools/
      // Log out, always reachable, never a dead end. TierHomeScreen keeps
      // its own AppBar Log out button too (unchanged, low-risk to leave).
      drawer: const ManagementDrawer(title: 'Home'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'What would you like to do?',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PrimaryActionButton(
                  label: 'My Tasks',
                  icon: Icons.checklist,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TaskScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryActionButton(
                  label: 'Oversight',
                  icon: Icons.visibility,
                  onPressed: currentUser == null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                oversightScreenFor(currentUser.roleTier),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
