import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/metric_chip.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../tasks/overdue_summary_service.dart';
import 'reliability_service.dart';

// Dashboard + worker recognition, Sub-sprint B (Sprint 031). Venue-scoped —
// shared by supervisor and venueManager, per the confirmed decision that
// supervisor sees the same venue-wide view rather than an undermodeled
// "team/shift" scope. Sub-sprint C (regional/executive) reuses `DashboardBody`
// directly inside TopScreen rather than duplicating it — same venue-scoped
// view, cross-venue comparison stays deferred until multi-site is actually
// usable (see the "Multi-site is only partially usable" entry in
// DECISIONS_LOG.md).
//
// Display extends the anti-gaming principle from the scoring math itself
// (see reliability_service.dart's own doc comment) into how this screen
// presents it, confirmed with the user before building: the team list below
// is alphabetical (never ordered by score — a roster, not a leaderboard),
// uses one flat neutral chip style regardless of the number (MetricChip,
// never a graded pass/caution/critical colour), and never shows a
// per-person FAIL count — FAILs only ever appear once, aggregated, in the
// summary card above the team list. A manager needing per-person FAIL
// detail still has the existing Submission Log filter for that. Since
// TopScreen embeds this exact same widget, these rules automatically carry
// over to the regional/executive view too, not just this screen.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const ManagementDrawer(title: 'Dashboard'),
      body: const SafeArea(child: DashboardBody()),
    );
  }
}

class DashboardBody extends ConsumerStatefulWidget {
  const DashboardBody({super.key});

  @override
  ConsumerState<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<DashboardBody> {
  bool _loading = true;
  SiteReliabilitySummary? _reliability;
  int _failCount = 0;
  int _overdueCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      setState(() => _loading = false);
      return;
    }
    final siteId = currentUser.siteId!; // operational screen, current user always has a site here

    final reliabilityService = ref.read(reliabilityServiceProvider);
    final overdueService = ref.read(overdueSummaryServiceProvider);
    final submissionRepo = ref.read(taskSubmissionRepositoryProvider);

    final now = DateTime.now();
    final rangeStart = now.subtract(const Duration(days: 30));

    final reliability = await reliabilityService.computeForSite(siteId);
    final overdue = await overdueService.getSummaryForSite(siteId);
    final submissions = await submissionRepo.getForSiteAndDateRange(
      siteId: siteId,
      start: rangeStart,
      end: now,
    );

    if (!mounted) return;
    setState(() {
      _reliability = reliability;
      _overdueCount = overdue.length;
      _failCount = submissions.where((s) => s.status == 'FAIL').length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reliability == null) {
      return const Center(child: Text('No venue found.'));
    }

    final overall = _reliability!.overall;
    // Alphabetical, never by score — a roster, not a leaderboard.
    final staff = [..._reliability!.staff]
      ..sort(
        (a, b) =>
            a.userName.toLowerCase().compareTo(b.userName.toLowerCase()),
      );

    // Responsive foundation: wrapped here (not at each call site) since
    // this widget is embedded directly in both DashboardScreen and
    // TopScreen — one fix covers both.
    return ResponsiveContent(
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last 30 days',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (overall.completionRate != null)
                      MetricChip(
                        icon: Icons.check_circle_outline,
                        label:
                            '${(overall.completionRate! * 100).round()}% completed',
                      ),
                    if (overall.onTimeRate != null)
                      MetricChip(
                        icon: Icons.schedule,
                        label:
                            '${(overall.onTimeRate! * 100).round()}% on time',
                      ),
                    StatusBadge(
                      kind: StatusKind.critical,
                      label:
                          '$_failCount FAIL${_failCount == 1 ? '' : 's'} (30 days)',
                    ),
                    StatusBadge(
                      kind: StatusKind.overdue,
                      label: '$_overdueCount overdue',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Team'),
          const SizedBox(height: 8),
          if (staff.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No staff at this venue yet.'),
            )
          else
            ...staff.map(
              (member) => Card(
                child: ListTile(
                  title: Text(member.userName),
                  subtitle: member.reliability.totalPeriods == 0
                      ? Text(
                          'Not enough data yet',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              MetricChip(
                                icon: Icons.check_circle_outline,
                                label:
                                    '${(member.reliability.completionRate! * 100).round()}% completed',
                              ),
                              MetricChip(
                                icon: Icons.schedule,
                                label:
                                    '${(member.reliability.onTimeRate! * 100).round()}% on time',
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
