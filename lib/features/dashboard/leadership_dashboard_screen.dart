import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/breakdown_sheet.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/area.dart';
import '../../shared/models/issue.dart';
import '../../shared/models/site.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import 'leadership_dashboard_service.dart';

enum _Period { month, week, day }

// Leadership dashboard overview (2026-09-15) — from the user's own
// `Visual idea.pdf` mockup. Branch/Section filters plus Month/Week/Day
// drive two aggregate colour bars (Task overview, Incidents). Employee
// filter is DELIBERATELY different from the other two: per the governing
// anti-gaming rule (see leadership_dashboard_service.dart's own doc
// comment), picking a named person never produces a colour-graded bar —
// it switches to a plain, ungraded list of what they raised/completed,
// a lookup, not a score.
class LeadershipDashboardScreen extends ConsumerStatefulWidget {
  const LeadershipDashboardScreen({super.key});

  @override
  ConsumerState<LeadershipDashboardScreen> createState() =>
      _LeadershipDashboardScreenState();
}

class _LeadershipDashboardScreenState
    extends ConsumerState<LeadershipDashboardScreen> {
  bool _loading = true;
  List<Site> _sites = [];
  int? _selectedSiteId;
  List<Area> _areas = [];
  int? _selectedAreaId;
  List<User> _staff = [];
  int? _selectedEmployeeId;
  _Period _period = _Period.week;

  TaskOverviewBreakdown? _taskOverview;
  IncidentsBreakdown? _incidents;
  List<TaskSubmission> _employeeSubmissions = [];
  List<Issue> _employeeIssues = [];

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  DateTimeRange get _range {
    final now = DateTime.now();
    final start = switch (_period) {
      _Period.month => now.subtract(const Duration(days: 30)),
      _Period.week => now.subtract(const Duration(days: 7)),
      _Period.day => now.subtract(const Duration(days: 1)),
    };
    return DateTimeRange(start: start, end: now);
  }

  // Same "permitted sites" resolution DashboardBody already uses: a
  // single-site tier sees only their own site, Regional sees their
  // region's sites, Executive/Director sees the whole organisation —
  // reused rather than reinvented so this screen's Branch dropdown
  // matches the RLS boundary the backend actually enforces.
  Future<void> _loadSites() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    final siteRepo = ref.read(siteRepositoryProvider);

    List<Site> sites;
    if (currentUser.regionId != null) {
      sites = await siteRepo.getForRegion(currentUser.regionId!);
    } else if (currentUser.roleTier == RoleTier.executive) {
      final orgId =
          ref.read(currentBackendOrganisationIdProvider) ??
          (await ref.read(organisationRepositoryProvider).getDefault()).id;
      sites = await siteRepo.getForOrganisation(orgId);
    } else {
      sites = currentUser.siteId == null
          ? const <Site>[]
          : [
              await siteRepo.getById(currentUser.siteId!),
            ].whereType<Site>().toList();
    }

    if (!mounted) return;
    setState(() {
      _sites = sites;
      _selectedSiteId = sites.isEmpty ? null : sites.first.id;
    });
    if (_selectedSiteId != null) await _loadForSite();
  }

  Future<void> _loadForSite() async {
    final siteId = _selectedSiteId;
    if (siteId == null) return;
    setState(() => _loading = true);

    final areas = await ref.read(areaRepositoryProvider).getForSite(siteId);
    final staff = await ref.read(userRepositoryProvider).getForSite(siteId);

    if (!mounted) return;
    setState(() {
      _areas = areas;
      _staff = staff.where((u) => u.active).toList();
      _selectedAreaId = null;
      _selectedEmployeeId = null;
    });
    await _loadBreakdowns();
  }

  Future<void> _loadBreakdowns() async {
    final siteId = _selectedSiteId;
    if (siteId == null) return;
    setState(() => _loading = true);
    final range = _range;
    final service = ref.read(leadershipDashboardServiceProvider);

    if (_selectedEmployeeId != null) {
      // Employee lookup path — a plain list, never a colour bar. See the
      // class doc comment.
      final submissions = await ref
          .read(taskSubmissionRepositoryProvider)
          .getForSiteAndDateRange(
            siteId: siteId,
            start: range.start,
            end: range.end,
          );
      final issues = await ref.read(issueRepositoryProvider).getForSite(siteId);
      if (!mounted) return;
      setState(() {
        _employeeSubmissions = submissions
            .where((s) => s.completedByUserId == _selectedEmployeeId)
            .toList();
        _employeeIssues = issues
            .where(
              (i) =>
                  i.raisedByUserId == _selectedEmployeeId &&
                  !i.raisedAt.isBefore(range.start) &&
                  i.raisedAt.isBefore(range.end),
            )
            .toList();
        _loading = false;
      });
      return;
    }

    final taskOverview = await service.computeTaskOverview(
      siteId: siteId,
      start: range.start,
      end: range.end,
      areaId: _selectedAreaId,
    );
    final incidents = await service.computeIncidents(
      siteId: siteId,
      start: range.start,
      end: range.end,
    );
    if (!mounted) return;
    setState(() {
      _taskOverview = taskOverview;
      _incidents = incidents;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Overview')),
      drawer: const ManagementDrawer(title: 'Dashboard Overview'),
      body: _sites.isEmpty
          ? const Center(child: Text('No branches to show yet.'))
          : ResponsiveContent(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters(),
                    const SizedBox(height: 16),
                    if (_loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_selectedEmployeeId != null)
                      _buildEmployeeLookup()
                    else ...[
                      _buildTaskOverviewCard(),
                      const SizedBox(height: 16),
                      _buildIncidentsCard(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFilters() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_sites.length > 1) ...[
            const Text('Branch'),
            const SizedBox(height: 4),
            DropdownButtonFormField<int>(
              initialValue: _selectedSiteId,
              items: _sites
                  .map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => _selectedSiteId = v);
                _loadForSite();
              },
            ),
            const SizedBox(height: 12),
          ],
          const Text('Section'),
          const SizedBox(height: 4),
          DropdownButtonFormField<int?>(
            initialValue: _selectedAreaId,
            items: [
              const DropdownMenuItem(value: null, child: Text('All sections')),
              ..._areas.map(
                (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
              ),
            ],
            onChanged: (v) {
              setState(() => _selectedAreaId = v);
              _loadBreakdowns();
            },
          ),
          const SizedBox(height: 12),
          const Text('Employee'),
          const SizedBox(height: 4),
          DropdownButtonFormField<int?>(
            initialValue: _selectedEmployeeId,
            items: [
              const DropdownMenuItem(value: null, child: Text('All employees')),
              ..._staff.map(
                (u) => DropdownMenuItem(value: u.id, child: Text(u.name)),
              ),
            ],
            onChanged: (v) {
              setState(() => _selectedEmployeeId = v);
              _loadBreakdowns();
            },
          ),
          const SizedBox(height: 12),
          SegmentedButton<_Period>(
            segments: const [
              ButtonSegment(value: _Period.month, label: Text('Month')),
              ButtonSegment(value: _Period.week, label: Text('Week')),
              ButtonSegment(value: _Period.day, label: Text('Day')),
            ],
            selected: {_period},
            onSelectionChanged: (selection) {
              setState(() => _period = selection.first);
              _loadBreakdowns();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskOverviewCard() {
    final overview = _taskOverview;
    if (overview == null || overview.total == 0) {
      return const AppCard(child: Text('No task activity in this period.'));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task overview', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ProportionBar(
            segments: [
              _BarSegment(
                overview.onTimeNoIssuesRate,
                AppColors.pass,
                '${overview.onTimeNoIssues.length}',
                () => _showSubmissionBreakdown(
                  'Done on time (no issues)',
                  overview.onTimeNoIssues,
                ),
              ),
              _BarSegment(
                overview.onTimeIssuesLoggedRate,
                const Color(0xFFE8C547),
                '${overview.onTimeIssuesLogged.length}',
                () => _showSubmissionBreakdown(
                  'Done on time (issues logged)',
                  overview.onTimeIssuesLogged,
                ),
              ),
              _BarSegment(
                overview.offWindowNoIssuesRate,
                const Color(0xFFE8873D),
                '${overview.offWindowNoIssues.length}',
                () => _showSubmissionBreakdown(
                  'Done early/late (no issues)',
                  overview.offWindowNoIssues,
                ),
              ),
              _BarSegment(
                overview.offWindowIssuesLoggedRate,
                const Color(0xFF8E5FD9),
                '${overview.offWindowIssuesLogged.length}',
                () => _showSubmissionBreakdown(
                  'Done early/late (issues logged)',
                  overview.offWindowIssuesLogged,
                ),
              ),
              _BarSegment(
                overview.notDoneRate,
                AppColors.critical,
                '${overview.notDone.length}',
                () => _showSubmissionBreakdown('Not done', overview.notDone),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _legendRow([
            (
              AppColors.pass,
              'Done on time (no issues)',
              () => _showSubmissionBreakdown(
                'Done on time (no issues)',
                overview.onTimeNoIssues,
              ),
            ),
            (
              const Color(0xFFE8C547),
              'Done on time (issues logged)',
              () => _showSubmissionBreakdown(
                'Done on time (issues logged)',
                overview.onTimeIssuesLogged,
              ),
            ),
            (
              const Color(0xFFE8873D),
              'Done early/late (no issues)',
              () => _showSubmissionBreakdown(
                'Done early/late (no issues)',
                overview.offWindowNoIssues,
              ),
            ),
            (
              const Color(0xFF8E5FD9),
              'Done early/late (issues logged)',
              () => _showSubmissionBreakdown(
                'Done early/late (issues logged)',
                overview.offWindowIssuesLogged,
              ),
            ),
            (
              AppColors.critical,
              'Not done',
              () => _showSubmissionBreakdown('Not done', overview.notDone),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildIncidentsCard() {
    final incidents = _incidents;
    if (incidents == null || incidents.total == 0) {
      return const AppCard(child: Text('No incidents raised in this period.'));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Incidents', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ProportionBar(
            segments: [
              _BarSegment(
                incidents.resolvedRate,
                AppColors.pass,
                '${incidents.resolved.length}',
                () => _showIssueBreakdown('Resolved', incidents.resolved),
              ),
              _BarSegment(
                incidents.unresolvedRate,
                const Color(0xFFE8C547),
                '${incidents.unresolved.length}',
                () => _showIssueBreakdown('Unresolved', incidents.unresolved),
              ),
              _BarSegment(
                incidents.escalatedRate,
                const Color(0xFFE8873D),
                '${incidents.escalated.length}',
                () => _showIssueBreakdown('Escalated', incidents.escalated),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _legendRow([
            (
              AppColors.pass,
              'Resolved',
              () => _showIssueBreakdown('Resolved', incidents.resolved),
            ),
            (
              const Color(0xFFE8C547),
              'Unresolved',
              () => _showIssueBreakdown('Unresolved', incidents.unresolved),
            ),
            (
              const Color(0xFFE8873D),
              'Escalated',
              () => _showIssueBreakdown('Escalated', incidents.escalated),
            ),
          ]),
        ],
      ),
    );
  }

  // Click-to-drill-down (2026-09-17) — from the original mockup's own
  // "Click on colour band for detailed breakdown" text under both bars.
  // A plain bottom sheet listing the actual rows behind whichever
  // category was tapped (bar segment or legend entry, either way in) —
  // no new queries, these are the same lists the bars were already built
  // from.
  void _showSubmissionBreakdown(String title, List<TaskSubmission> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BreakdownSheet(
        title: title,
        count: items.length,
        rows: [
          for (final s in items)
            BreakdownRow(
              title: s.displayTitle,
              subtitle: formatDateTime(s.completedAt),
            ),
        ],
      ),
    );
  }

  void _showIssueBreakdown(String title, List<Issue> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BreakdownSheet(
        title: title,
        count: items.length,
        rows: [
          for (final i in items)
            BreakdownRow(
              title: issueTypeDisplayName(i.type),
              subtitle: '${i.details} — ${formatDateTime(i.raisedAt)}',
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeLookup() {
    final employee = _staff
        .where((u) => u.id == _selectedEmployeeId)
        .firstOrNull;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee?.name ?? 'Employee',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'A plain lookup, not a score — completion colour and issue tags '
            'here are never graded per person.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Tasks completed (${_employeeSubmissions.length})',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final s in _employeeSubmissions.take(20))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${s.taskTitle} — ${formatDateTime(s.completedAt)}'),
            ),
          const SizedBox(height: 12),
          Text(
            'Issues raised (${_employeeIssues.length})',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final i in _employeeIssues.take(20))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${issueTypeDisplayName(i.type)} — ${issueStatusDisplayName(i.status)} '
                '(${formatDateTime(i.raisedAt)})',
              ),
            ),
        ],
      ),
    );
  }

  // Click-to-drill-down (2026-09-17): each legend entry is now the same
  // tap target as its matching bar segment — two ways into the same
  // breakdown, per the original mockup's own "Click on colour band" text
  // (a legend swatch reads as part of the same affordance).
  Widget _legendRow(List<(Color, String, VoidCallback)> entries) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: entries
          .map(
            (e) => InkWell(
              onTap: e.$3,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: e.$1,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(e.$2, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BarSegment {
  const _BarSegment(this.rate, this.color, this.label, this.onTap);
  final double rate;
  final Color color;
  final String label;
  final VoidCallback onTap;
}

class _ProportionBar extends StatelessWidget {
  const _ProportionBar({required this.segments});

  final List<_BarSegment> segments;

  @override
  Widget build(BuildContext context) {
    final visible = segments.where((s) => s.rate > 0).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 36,
        child: Row(
          children: visible
              .map(
                (s) => Expanded(
                  flex: (s.rate * 1000).round().clamp(1, 1000),
                  child: InkWell(
                    onTap: s.onTap,
                    child: Container(
                      color: s.color,
                      alignment: Alignment.center,
                      child: Text(
                        '${(s.rate * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// BreakdownSheet/BreakdownRow (the drill-down list itself) now live in
// core/widgets/breakdown_sheet.dart, shared with Sprint 038's Supplier
// Scorecard.
