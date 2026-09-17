import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../issues/my_raised_issues_screen.dart';
import '../issues/report_issue_screen.dart';
import 'ad_hoc_task_screen.dart';
import 'task_screen.dart';

// PART 3 of the branch-hub build (2026-09-15) — a pre-carousel choice
// screen for base tier, added ahead of TaskScreen (never replacing it —
// "My scheduled tasks" leads to the exact same, unchanged carousel base
// tier always had). Supervisor+ already has a home hub (TierHomeScreen)
// and gets the same second option added there instead of a duplicate
// screen — see tier_home_screen.dart.
//
// Deliberately no drawer, no logout button beyond what TaskScreen itself
// offers — this stays a single fork in the road, not a new nav surface,
// per the Staff Task Screen Rule's minimalism that governs base tier
// throughout the app.
class WorkerHubScreen extends ConsumerWidget {
  const WorkerHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final branding = ref
        .watch(brandingConfigProvider)
        .maybeWhen(data: (config) => config, orElse: () => null);
    final site = ref
        .watch(currentUserSiteProvider)
        .maybeWhen(data: (site) => site, orElse: () => null);

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              elevated: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BrandHeader(
                    branding: branding,
                    siteName: site?.name,
                    showAppMark: true,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What would you like to do?',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PrimaryActionButton(
                    label: 'My scheduled tasks',
                    icon: Icons.checklist,
                    // Logout bug fix (2026-09-17): this was pushReplacement,
                    // which destroys WorkerHubScreen's route entirely rather
                    // than stacking on top of it. WorkerHubScreen IS
                    // MaterialApp.home for base tier (see app.dart) — the
                    // one route whose builder reactively re-reads
                    // currentUserProvider on every rebuild. Replacing it
                    // meant TaskScreen's logout (`popUntil(isFirst)` then
                    // nulling currentUserProvider) had nothing reactive left
                    // to pop back down to: the route AT position 0 was now a
                    // plain, static `(_) => const TaskScreen()` closure that
                    // never re-evaluates against currentUser, so the screen
                    // never navigated to LoginScreen even though the user
                    // was, internally, already logged out — a real "worker
                    // trapped" bug. Plain push (matching TierHomeScreen's
                    // own push to TaskScreen for every non-base tier, which
                    // never had this bug) keeps WorkerHubScreen alive
                    // underneath, so popUntil(isFirst) correctly reveals it
                    // again for the reactive swap to work.
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Ad-hoc task path (2026-09-17) — a third fork, distinct
                  // from "Log something that just happened": that option is
                  // for PROBLEMS (something wrong), this one is for a TASK
                  // that needs doing but was never scheduled (an unplanned
                  // delivery to check, an off-schedule temperature reading).
                  // Conflating the two would misfile a routine ad-hoc check
                  // as if it were a problem being reported.
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdHocTaskScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.add_task),
                    label: const Text('Do an ad-hoc task'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: site == null || currentUser == null
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportIssueScreen(
                                siteId: site.id,
                                raisedByUserId: currentUser.id,
                              ),
                            ),
                          ),
                    icon: const Icon(Icons.report_problem_outlined),
                    label: const Text('Log something that just happened'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: currentUser == null
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MyRaisedIssuesScreen(userId: currentUser.id),
                            ),
                          ),
                    child: const Text('Things I\'ve reported'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
