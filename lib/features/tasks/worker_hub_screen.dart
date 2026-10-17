import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/localization/language_picker.dart';
import '../../core/widgets/home_tile.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_background.dart';
import '../../core/widgets/user_title.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../auth/end_shift.dart';
import '../issues/my_raised_issues_screen.dart';
import '../issues/report_issue_screen.dart';
import '../roster/roster_billing_service.dart' show rosterAddonEnabledProvider;
import '../roster/rota_claim_screen.dart';
import 'ad_hoc_task_screen.dart';
import 'task_screen.dart';
import 'training/training_screens.dart';
import '../../shared/providers/training_progress_providers.dart';
import '../../core/widgets/app_screen_header.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final branding = ref
        .watch(brandingConfigProvider)
        .maybeWhen(data: (config) => config, orElse: () => null);
    final site = ref
        .watch(currentUserSiteProvider)
        .maybeWhen(data: (site) => site, orElse: () => null);
    // Roster teaser UX (2026-09-27, direct founder request): base tier has
    // no path to purchase the add-on, so a locked button they can't act on
    // is just confusing dead weight — hide both Roster buttons entirely
    // until a manager has actually enabled it, rather than showing a lock
    // they can't unlock (contrast with the drawer's locked-teaser tiles,
    // which ARE useful for venueManager+ who CAN act on them).
    final rosterAddonEnabled = ref
        .watch(rosterAddonEnabledProvider)
        .maybeWhen(data: (enabled) => enabled, orElse: () => false);

    final siteId = currentUser?.siteId;
    final toRead = currentUser == null || siteId == null
        ? 0
        : (ref.watch(siteTrainingProvider(siteId)).value?[currentUser.id] ??
                  const [])
              .where((i) => i.needsAction)
              .length;

    return Scaffold(
      appBar: AppScreenHeader(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : Text(l10n.home),
        // Header decluttering (2026-10-03, direct founder feedback: AI +
        // language + Log out + End shift all sitting in a row read as
        // "far too crowded"). The AI icon is now a global floating button
        // (see AssistantFab); language, Log out and End shift fold into
        // one "⋮" overflow menu instead of four separate widgets here.
        onLogout: currentUser == null
            ? null
            : () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                ref.read(currentUserProvider.notifier).state = null;
              },
        extraMenuItems: currentUser == null
            ? null
            : [
                PopupMenuItem<VoidCallback>(
                  value: () => showLanguagePicker(context, ref),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, size: 18),
                      const SizedBox(width: 12),
                      Text(l10n.languageSettingTitle),
                    ],
                  ),
                ),
                // "End shift" (2026-09-24, direct user request) — a
                // "here's what's still not done" check, plus records the
                // clock-out on today's ShiftLog. Reached only when the
                // person actually means to finish their shift, not just
                // step away — distinct from plain Log out above.
                PopupMenuItem<VoidCallback>(
                  value: () => endShift(context, ref, currentUser),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_available, size: 18),
                      const SizedBox(width: 12),
                      Text(l10n.endShift),
                    ],
                  ),
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
                          l10n.workerHubPrompt,
                          style: const TextStyle(
                            fontFamily: 'Fraunces',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Home tiles (2026-10-17 menu redesign) — one tap
                        // to each job, no side menu for staff.
                        HomeTileGrid(
                          wide: [
                            HomeTile(
                              icon: Icons.checklist,
                              label: l10n.myTasksTitle,
                              primary: true,
                              tall: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TaskScreen(),
                                ),
                              ),
                            ),
                          ],
                          children: [
                            HomeTile(
                              icon: Icons.report_problem_outlined,
                              label: l10n.menuReportProblem,
                              onTap: site == null || currentUser == null
                                  ? () {}
                                  : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ReportIssueScreen(
                                          siteId: site.id,
                                          raisedByUserId: currentUser.id,
                                        ),
                                      ),
                                    ),
                            ),
                            HomeTile(
                              icon: Icons.school_outlined,
                              label: l10n.myTrainingTitle,
                              badge: toRead > 0
                                  ? l10n.trainingToDoCount(toRead)
                                  : null,
                              badgeAlert: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyTrainingScreen(),
                                ),
                              ),
                            ),
                            if (rosterAddonEnabled && currentUser != null)
                              HomeTile(
                                icon: Icons.calendar_month_outlined,
                                label: l10n.menuMyShifts,
                                subtitle: l10n.menuMyShiftsSubtitle,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RotaClaimScreen(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // Less frequent actions stay one tap away, but
                        // don't compete with the tiles.
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdHocTaskScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.add_task),
                          label: Text(l10n.doAdHocTask),
                        ),
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
                          child: Text(l10n.thingsIReported),
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
