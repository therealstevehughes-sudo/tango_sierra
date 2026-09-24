import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_background.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../auth/end_shift.dart';
import '../help/help_screen.dart';
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
          // Help (2026-09-24) — base tier has no drawer at all (see class
          // doc), so this is the one small addition to the existing
          // actions row rather than a new nav surface.
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            ),
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
          ),
          // "End shift" (2026-09-24, direct user request) — replaces a
          // plain logout with a "here's what's still not done" check,
          // plus records the clock-out on today's ShiftLog.
          TextButton.icon(
            onPressed: currentUser == null
                ? null
                : () => endShift(context, ref, currentUser),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('End shift'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SectionBackground(jobRole: currentUser?.jobRole),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                // Visual pass follow-up (2026-09-24, direct user
                // feedback) — the card (and, since its Column stretches
                // its children, every button in it) had no width cap, so
                // on a wide desktop window the buttons ran edge to edge.
                // Capped the same way every other form-shaped screen in
                // this app already is.
                child: ResponsiveContent(
                  maxWidth: 420,
                  alignment: Alignment.center,
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
                        // Visual pass follow-up (2026-09-22) — same restraint the
                        // onboarding pass used on dense screens: a Fraunces
                        // headline for warmth, no hero photo, since this screen
                        // is reached fresh every shift and a repeated image
                        // would read as clutter, not polish, on a screen this
                        // frequently used.
                        Text(
                          'What would you like to do?',
                          style: const TextStyle(
                            fontFamily: 'Fraunces',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.ink,
                          ),
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
                            MaterialPageRoute(
                              builder: (_) => const TaskScreen(),
                            ),
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
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: currentUser == null
                              ? null
                              : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MyRaisedIssuesScreen(
                                      userId: currentUser.id,
                                    ),
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
          ),
        ],
      ),
    );
  }
}
