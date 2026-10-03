import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/metric_chip.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_background.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/user_title.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../dashboard/reliability_service.dart';
import '../dashboard/top_screen.dart';
import '../issues/report_issue_screen.dart';
import '../manager/manager_screen.dart';
import '../tasks/overdue_summary_service.dart';
import '../tasks/task_screen.dart';
import '../../core/widgets/app_screen_header.dart';

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
//
// Phase C2 (2026-09-14) — branded-per-branch home screen: a site-having
// tier (supervisor/venueManager) now sees a real "Today at {branch}"
// status card between the branding header and the action buttons, not
// just a bare nav hub. Regional/executive have no single branch (their
// oversight is already the org/region-wide TopScreen aggregate), so their
// home is deliberately unchanged. Every figure here reuses the exact
// services ManagerScreen/DashboardScreen already use — completion/on-time
// via ReliabilityService (MetricChip, neutral, never graded, per the
// worker-recognition anti-gaming rule), fails/overdue via StatusBadge
// (legitimate compliance alerts, a different kind of figure). "Active
// staff" is a roster count, not a literal shift-clock-in feature — this
// app has no such concept, so the honest reading of "who's on shift" is
// "who's an active member of this branch," not something invented here.
class TierHomeScreen extends ConsumerStatefulWidget {
  const TierHomeScreen({super.key});

  static Widget oversightScreenFor(RoleTier tier) {
    return (tier == RoleTier.regional || tier == RoleTier.executive)
        ? const TopScreen()
        : const ManagerScreen();
  }

  @override
  ConsumerState<TierHomeScreen> createState() => _TierHomeScreenState();
}

class _BranchStatus {
  const _BranchStatus({
    required this.reliability,
    required this.failCountToday,
    required this.overdueCount,
    required this.activeStaffCount,
  });

  final ReliabilitySummary reliability;
  final int failCountToday;
  final int overdueCount;
  final int activeStaffCount;
}

class _TierHomeScreenState extends ConsumerState<TierHomeScreen> {
  _BranchStatus? _status;
  int? _loadedForSiteId;

  Future<void> _loadStatus(int siteId) async {
    final reliabilityService = ref.read(reliabilityServiceProvider);
    final overdueService = ref.read(overdueSummaryServiceProvider);
    final submissionRepo = ref.read(taskSubmissionRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    final results = await Future.wait([
      reliabilityService.computeForSite(siteId),
      overdueService.getSummaryForSite(siteId),
      submissionRepo.getForSiteAndDateRange(
        siteId: siteId,
        start: startOfToday,
        end: now,
      ),
      userRepo.getForSite(siteId),
    ]);

    if (!mounted) return;
    final site = results[0] as SiteReliabilitySummary;
    final overdue = results[1] as List<OverdueSummaryEntry>;
    final submissions = results[2] as List;
    final staff = results[3] as List;

    setState(() {
      _status = _BranchStatus(
        reliability: site.overall,
        failCountToday: submissions.where((s) => s.status == 'FAIL').length,
        overdueCount: overdue.length,
        activeStaffCount: staff.where((u) => u.active).length,
      );
      _loadedForSiteId = siteId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final branding = ref
        .watch(brandingConfigProvider)
        .maybeWhen(data: (config) => config, orElse: () => null);
    final site = ref
        .watch(currentUserSiteProvider)
        .maybeWhen(data: (site) => site, orElse: () => null);

    // Only site-having tiers get a branch status card — regional/executive
    // have no single branch to show one for (see class doc).
    final showBranchStatus =
        currentUser != null &&
        site != null &&
        (currentUser.roleTier == RoleTier.supervisor ||
            currentUser.roleTier == RoleTier.venueManager);
    if (showBranchStatus && _loadedForSiteId != site.id) {
      // Fire-and-forget: `_loadStatus` calls `setState` itself once done.
      // Not awaited here — `build` must stay synchronous.
      _loadStatus(site.id);
    }

    return Scaffold(
      appBar: AppScreenHeader(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : Text(l10n.homeLabel),
        // Header decluttering (2026-10-03) — AI icon is now a global
        // floating button (see AssistantFab); Log out folds into
        // AppScreenHeader's own "⋮" overflow menu.
        onLogout: () => ref.read(currentUserProvider.notifier).state = null,
      ),
      // Navigation-consistency pass (Sprint 031): the same drawer every
      // non-base screen now has — Home/My Tasks/Oversight/Settings/tools/
      // Log out, always reachable, never a dead end. TierHomeScreen keeps
      // its own AppBar Log out button too (unchanged, low-risk to leave).
      drawer: ManagementDrawer(title: l10n.homeLabel),
      // Visual pass follow-up (2026-09-24, direct user feedback) — the
      // comment that used to be here claimed this card "shrink-wraps to
      // its own content width," but that's not actually how
      // CrossAxisAlignment.stretch behaves inside a Column given loose
      // (unconstrained) width from Center: the buttons stretched edge to
      // edge on a wide desktop window, same bug WorkerHubScreen had. Now
      // capped the same way every other form-shaped screen in this app
      // already is, via ResponsiveContent — Alignment.center (not the
      // default topCenter) keeps this screen's own vertical centering.
      // Guided Cards (2026-09-14): the VenuRite mark now anchors to the
      // true top-left corner of the screen, not the branding card's own
      // inset corner — a Stack over the whole body so it sits independent
      // of the centered card's padding/width.
      body: Stack(
        children: [
          SectionBackground(jobRole: currentUser?.jobRole),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ResponsiveContent(
                  maxWidth: 420,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        elevated: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Branding inheritance (Part E) + app logo (2026-09-13):
                            // the shared BrandHeader renders the VenuRite lockup, the
                            // client company logo (set once, Organisation-wide, by a
                            // Director) and this specific branch's own name — same
                            // live-reactive mechanism as the accent-colour re-theme,
                            // no restart needed either.
                            BrandHeader(
                              branding: branding,
                              siteName: site?.name,
                              showAppMark: false,
                            ),
                            if (showBranchStatus) ...[
                              const SizedBox(height: 16),
                              _BranchStatusCard(status: _status, l10n: l10n),
                            ],
                            const SizedBox(height: 16),
                            // Visual pass follow-up (2026-09-22) — same treatment
                            // as WorkerHubScreen's own headline: Fraunces for
                            // warmth, no hero photo (this screen is reached
                            // multiple times a shift; a repeated image would
                            // read as clutter, not polish).
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
                            // Oversight leads for venueManager+ (2026-09-29,
                            // direct founder request, "as long as you feel
                            // it makes the most sense intuitively"): a GM
                            // or above is rarely the person doing the daily
                            // fridge-temp check themselves — Oversight is
                            // what they open first almost every time. A
                            // supervisor is much more often hands-on, so
                            // My Tasks stays first for that tier — same
                            // reasoning as this file's own "small team"
                            // case, just applied per-tier rather than
                            // reordered for everyone.
                            if (currentUser != null &&
                                roleTierRank(currentUser.roleTier) >=
                                    roleTierRank(RoleTier.venueManager)) ...[
                              PrimaryActionButton(
                                label: l10n.oversightLabel,
                                icon: Icons.visibility,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TierHomeScreen.oversightScreenFor(
                                          currentUser.roleTier,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              PrimaryActionButton(
                                label: l10n.myTasksTitle,
                                icon: Icons.checklist,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TaskScreen(),
                                  ),
                                ),
                              ),
                            ] else ...[
                              PrimaryActionButton(
                                label: l10n.myTasksTitle,
                                icon: Icons.checklist,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TaskScreen(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              PrimaryActionButton(
                                label: l10n.oversightLabel,
                                icon: Icons.visibility,
                                onPressed: currentUser == null
                                    ? null
                                    : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TierHomeScreen.oversightScreenFor(
                                                currentUser.roleTier,
                                              ),
                                        ),
                                      ),
                              ),
                            ],
                            // Branch-hub build (2026-09-15) — supervisor+ already
                            // has a home hub, so the second "ad-hoc entry" option
                            // is added here rather than a duplicate screen (base
                            // tier gets its own fork via WorkerHubScreen). Needs a
                            // single site to raise against, so it only shows for
                            // site-having tiers, same condition as the branch
                            // status card above.
                            if (showBranchStatus) ...[
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportIssueScreen(
                                      siteId: site.id,
                                      raisedByUserId: currentUser.id,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.report_problem_outlined),
                                label: Text(l10n.logSomethingHappened),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  minimumSize: const Size.fromHeight(48),
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 16, left: 16, child: VenuRiteMark()),
        ],
      ),
    );
  }
}

/// "Today at {branch}" — a compact glance at this branch's live status,
/// shown only to supervisor/venueManager. Shows a loading placeholder
/// (never a spinner that jumps the layout) while `_TierHomeScreenState`
/// fetches the figures.
class _BranchStatusCard extends StatelessWidget {
  const _BranchStatusCard({required this.status, required this.l10n});

  final _BranchStatus? status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final status = this.status;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
      ),
      child: status == null
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (status.reliability.completionRate != null)
                  MetricChip(
                    icon: Icons.check_circle_outline,
                    label: l10n.percentCompletedTodayChip(
                      (status.reliability.completionRate! * 100).round(),
                    ),
                  ),
                if (status.reliability.onTimeRate != null)
                  MetricChip(
                    icon: Icons.schedule,
                    label: l10n.onTimePercentChip(
                      (status.reliability.onTimeRate! * 100).round(),
                    ),
                  ),
                if (status.failCountToday > 0)
                  StatusBadge(
                    kind: StatusKind.critical,
                    label: l10n.failCountTodayBadge(status.failCountToday),
                  ),
                if (status.overdueCount > 0)
                  StatusBadge(
                    kind: StatusKind.overdue,
                    label: l10n.overdueCountLabel(status.overdueCount),
                  ),
                MetricChip(
                  icon: Icons.groups_outlined,
                  label: l10n.activeStaffCountLabel(status.activeStaffCount),
                ),
              ],
            ),
    );
  }
}
