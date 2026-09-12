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
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/models/site.dart';
import '../tasks/overdue_summary_service.dart';
import 'reliability_service.dart';

// Dashboard + worker recognition, Sub-sprint B (Sprint 031). Venue-scoped —
// shared by supervisor and venueManager, per the confirmed decision that
// supervisor sees the same venue-wide view rather than an undermodeled
// "team/shift" scope. Sub-sprint C (regional/executive) reuses `DashboardBody`
// directly inside TopScreen rather than duplicating it. Leadership receives
// a clearly venue-labelled aggregate with each venue expandable to its own
// team metrics.
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
  const DashboardBody({super.key, this.aggregatePermittedSites = false});

  final bool aggregatePermittedSites;

  @override
  ConsumerState<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<DashboardBody> {
  bool _loading = true;
  SiteReliabilitySummary? _reliability;
  int _failCount = 0;
  int _overdueCount = 0;
  List<_SiteDashboardSummary> _siteSummaries = [];
  Map<int, String> _siteNameByUserId = {};
  // Regional/executive aggregation: when the permitted venue set spans more
  // than one Region (a multi-region/multi-country Director), the venue cards
  // are grouped under their Region's name. The common single-region case
  // stays a flat list — no header noise. Map: siteId -> region name.
  Map<int, String> _regionNameBySiteId = {};

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
    final reliabilityService = ref.read(reliabilityServiceProvider);
    final overdueService = ref.read(overdueSummaryServiceProvider);
    final submissionRepo = ref.read(taskSubmissionRepositoryProvider);
    final siteRepo = ref.read(siteRepositoryProvider);
    final orgRepo = ref.read(organisationRepositoryProvider);
    final regionRepo = ref.read(regionRepositoryProvider);

    // Leadership aggregation (Sprint 2): the venue set for regional/
    // executive is NOT `getAll()` — that is deliberately unfiltered (a
    // cross-tenant leak once the backend flag flips and a second tenant
    // exists). Instead we scope by the exact RLS boundary the backend
    // enforces: a Regional sees their own region's sites; an Executive/
    // Director sees every site in their organisation. Site-less
    // supervisors/venue managers (Phase C1b edge case) keep the empty
    // set, unchanged.
    int? organisationId;
    List<Site> sites;
    if (!widget.aggregatePermittedSites) {
      sites = currentUser.siteId == null
          ? const <Site>[]
          : [
              await siteRepo.getById(currentUser.siteId!),
            ].whereType<Site>().toList();
    } else if (currentUser.regionId != null) {
      // Regional: their own region is their permitted set. The organisation
      // id used for the region-grouping lookup comes from the site rows
      // themselves (same org), so resolve it from them.
      sites = await siteRepo.getForRegion(currentUser.regionId!);
      organisationId = sites.isNotEmpty ? sites.first.organisationId : null;
    } else {
      // Executive/Director: the whole organisation. The org id comes from
      // the session's own claim on the backend path; on a Drift-only
      // install there is exactly one org, so getDefault() resolves it the
      // same way every other single-tenant read does.
      organisationId =
          ref.read(currentBackendOrganisationIdProvider) ??
          (await orgRepo.getDefault()).id;
      sites = await siteRepo.getForOrganisation(organisationId);
    }

    // Region-grouping data for the leadership view: the region name for
    // each site in the permitted set. Only built when aggregating — a
    // single-venue dashboard never needs it.
    final regionNameBySiteId = <int, String>{};
    if (widget.aggregatePermittedSites && organisationId != null) {
      final regions = await regionRepo.getForOrganisation(organisationId);
      final regionNameById = {
        for (final region in regions) region.id: region.name,
      };
      for (final site in sites) {
        final regionId = site.regionId;
        if (regionId != null) {
          regionNameBySiteId[site.id] =
              regionNameById[regionId] ?? 'Region #$regionId';
        }
      }
    }

    final now = DateTime.now();
    final rangeStart = now.subtract(const Duration(days: 30));

    final summaries = <_SiteDashboardSummary>[];
    for (final site in sites) {
      final reliability = await reliabilityService.computeForSite(site.id);
      final overdue = await overdueService.getSummaryForSite(site.id);
      final submissions = await submissionRepo.getForSiteAndDateRange(
        siteId: site.id,
        start: rangeStart,
        end: now,
      );
      summaries.add(
        _SiteDashboardSummary(
          site: site,
          reliability: reliability,
          failCount: submissions.where((s) => s.status == 'FAIL').length,
          overdueCount: overdue.length,
        ),
      );
    }

    final combined = _combineSummaries(summaries);
    final siteNameByUserId = <int, String>{};
    for (final summary in summaries) {
      for (final member in summary.reliability.staff) {
        siteNameByUserId[member.userId] = summary.site.name;
      }
    }

    if (!mounted) return;
    setState(() {
      _reliability = combined.reliability;
      _overdueCount = combined.overdueCount;
      _failCount = combined.failCount;
      _siteSummaries = summaries;
      _siteNameByUserId = siteNameByUserId;
      _regionNameBySiteId = regionNameBySiteId;
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
        (a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()),
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
                    widget.aggregatePermittedSites
                        ? 'All permitted venues · last 30 days'
                        : 'Last 30 days',
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
            if (widget.aggregatePermittedSites) ...[
              const SectionHeader(title: 'Venues'),
              const SizedBox(height: 8),
              ..._buildVenueSection(),
              const SizedBox(height: 16),
            ],
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
                    title: Text(
                      widget.aggregatePermittedSites
                          ? '${member.userName} · ${_siteNameByUserId[member.userId] ?? 'Venue'}'
                          : member.userName,
                    ),
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
                                // Improvement (2026-09-12): leadership-only,
                                // strictly NEUTRAL "needs a look" cue. Never
                                // graded (uses the caution tone, not pass/
                                // critical), never reorders the alphabetical
                                // roster, never carries a per-person FAIL
                                // count (the anti-gaming rule). Its only job
                                // is to make a Director's scan show "this
                                // person isn't logging" without turning the
                                // roster into a report card.
                                if (widget.aggregatePermittedSites &&
                                    _lowLoggingFlag(member) != null)
                                  _LowLoggingChip(
                                    label: _lowLoggingFlag(member)!,
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

  Widget _buildSiteSummary(_SiteDashboardSummary summary) {
    final overall = summary.reliability.overall;
    final staff = [...summary.reliability.staff]
      ..sort(
        (a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()),
      );
    return Card(
      child: ExpansionTile(
        title: Text(summary.site.name),
        subtitle: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (overall.completionRate != null)
              MetricChip(
                icon: Icons.check_circle_outline,
                label: '${(overall.completionRate! * 100).round()}% completed',
              ),
            StatusBadge(
              kind: StatusKind.critical,
              label:
                  '${summary.failCount} FAIL${summary.failCount == 1 ? '' : 's'}',
            ),
            StatusBadge(
              kind: StatusKind.overdue,
              label: '${summary.overdueCount} overdue',
            ),
          ],
        ),
        children: [
          if (staff.isEmpty)
            const ListTile(title: Text('No staff at this venue yet.'))
          else
            ...staff.map(
              (member) => ListTile(
                dense: true,
                title: Text(member.userName),
                subtitle: member.reliability.totalPeriods == 0
                    ? const Text('Not enough data yet')
                    : Wrap(
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
                          // Same leadership-only neutral cue as the Team
                          // list above — this venue's own staff drill-down.
                          if (widget.aggregatePermittedSites &&
                              _lowLoggingFlag(member) != null)
                            _LowLoggingChip(label: _lowLoggingFlag(member)!),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }

  // Leadership aggregation (Sprint 2): region-grouped venue cards. When the
  // permitted set spans more than one Region (a multi-region/multi-country
  // Director), the cards are grouped under each Region's name — the natural
  // hierarchy for a large operator. A single region (or a mix where some
  // sites attach directly to the org, regionId == null) stays flat.
  List<Widget> _buildVenueSection() {
    if (_siteSummaries.isEmpty) {
      return const [Text('No venues yet.')];
    }

    // Only group when there are at least two DISTINCT region-labelled
    // groups — otherwise the flat list reads better.
    final regionNames = {
      for (final summary in _siteSummaries)
        _regionNameBySiteId[summary.site.id],
    }.whereType<String>().toSet();
    final groupable = regionNames.length > 1;

    if (!groupable) {
      return _siteSummaries.map(_buildSiteSummary).toList();
    }

    final widgets = <Widget>[];
    final remaining = [..._siteSummaries];
    // Preserve insertion order of first-seen region names for a stable,
    // non-alphabetical hierarchy (a Director's configured region order).
    final orderedRegions = <String>[];
    for (final summary in _siteSummaries) {
      final name = _regionNameBySiteId[summary.site.id];
      if (name != null && !orderedRegions.contains(name)) {
        orderedRegions.add(name);
      }
    }

    for (final regionName in orderedRegions) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: SectionHeader(title: regionName),
        ),
      );
      final grouped = remaining
          .where((s) => _regionNameBySiteId[s.site.id] == regionName)
          .toList();
      for (final summary in grouped) {
        widgets.add(_buildSiteSummary(summary));
        remaining.remove(summary);
      }
    }

    // Sites that attach directly to the org (no region) always come last,
    // under their own header — never silently dropped from a director's
    // view.
    if (remaining.isNotEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 4),
          child: SectionHeader(title: 'Other venues'),
        ),
      );
      widgets.addAll(remaining.map(_buildSiteSummary));
    }

    return widgets;
  }

  // Improvement (2026-09-12): the ONE leadership "needs a look" signal —
  // deliberately tiny and deliberately neutral. A staff member is flagged
  // only when (a) there's real data to judge (totalPeriods > 0) and (b)
  // they've logged fewer than half of their scheduled checks. That's the
  // "this person isn't logging" signal a Director scans for — without a
  // pass/fail score, without a FAIL count, without reordering the roster,
  // and never graded green/red. Returns null for everyone else.
  String? _lowLoggingFlag(StaffReliabilitySummary member) {
    final total = member.reliability.totalPeriods;
    if (total == 0) return null;
    final completed = member.reliability.completedPeriods;
    if (completed >= total ~/ 2) return null;
    return '$completed of $total checks logged';
  }
}

// Improvement (2026-09-12): a strictly neutral "needs a look" cue. Uses the
// caution (amber) tone — informational, never pass-green or critical-red —
// and pairs an icon with a factual label. It is NOT a grade: it says "this
// person is logging less than expected," nothing more. The roster stays
// alphabetical and unrankable; this chip never reorders and never carries a
// FAIL count (the existing anti-gaming structural rule).
class _LowLoggingChip extends StatelessWidget {
  const _LowLoggingChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cautionBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.visibility_off_outlined,
            size: 16,
            color: AppColors.caution,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.caution,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteDashboardSummary {
  const _SiteDashboardSummary({
    required this.site,
    required this.reliability,
    required this.failCount,
    required this.overdueCount,
  });

  final Site site;
  final SiteReliabilitySummary reliability;
  final int failCount;
  final int overdueCount;
}

_SiteDashboardSummary _combineSummaries(List<_SiteDashboardSummary> summaries) {
  var totalPeriods = 0;
  var completedPeriods = 0;
  var onTimePeriods = 0;
  var failCount = 0;
  var overdueCount = 0;
  final staff = <StaffReliabilitySummary>[];

  for (final summary in summaries) {
    final reliability = summary.reliability.overall;
    totalPeriods += reliability.totalPeriods;
    completedPeriods += reliability.completedPeriods;
    onTimePeriods += reliability.onTimePeriods;
    failCount += summary.failCount;
    overdueCount += summary.overdueCount;
    staff.addAll(summary.reliability.staff);
  }

  return _SiteDashboardSummary(
    site: summaries.isEmpty
        ? Site(
            id: 0,
            organisationId: 0,
            name: '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          )
        : summaries.first.site,
    reliability: SiteReliabilitySummary(
      overall: ReliabilitySummary(
        totalPeriods: totalPeriods,
        completedPeriods: completedPeriods,
        onTimePeriods: onTimePeriods,
      ),
      staff: staff,
    ),
    failCount: failCount,
    overdueCount: overdueCount,
  );
}
