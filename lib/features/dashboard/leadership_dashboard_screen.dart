import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';

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
import '../../shared/services/supervisor_scope_service.dart';
import '../../l10n/app_localizations.dart';
import 'leadership_dashboard_service.dart';
import '../../core/widgets/app_screen_header.dart';

enum _Period { month, week, day }

// Cross-venue rollup (2026-09-18) — a sentinel Branch-dropdown value
// meaning "All branches" (aggregate every permitted site), distinct from
// any real site id (autoincrement ids never start at 0 in this schema).
// Only ever offered when `_sites.length > 1` — Supervisor/Venue Manager
// always have exactly one permitted site, so this never applies to them.
const _allBranchesSentinel = 0;

// Leadership dashboard overview (2026-09-15) — from the user's own
// `Visual idea.pdf` mockup. Branch/Section filters plus Month/Week/Day
// drive two aggregate colour bars (Task overview, Incidents). Employee
// filter DEFAULTS to a plain, ungraded lookup list of what a named person
// raised/completed, per the governing anti-gaming rule (see
// leadership_dashboard_service.dart's own doc comment) — a lookup, not a
// score. Per-employee graded bars (2026-09-24): an organisation can opt
// into showing the same colour bar for a selected individual instead
// (Organisation.employeeGradedBarsEnabled, off by default) — reframed by
// the user as "work oversight for risk assessment," not grading. Off is
// still the default for every install; this is a deliberate, confirmed
// exception a Director switches on, not a reversal of the rule itself.
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

  // Sections/Teams scoping (2026-09-18) — a Supervisor's dashboard is
  // locked to their own supervised section(s)/team(s), never their free
  // choice like Venue Manager+ gets. Null for every other tier (no
  // scoping applied). Empty-but-non-null means "a Supervisor with nothing
  // assigned yet" — a real state, shown as its own message, not an
  // all-zero dashboard that looks like a bug.
  Set<int>? _allowedUserIds;
  List<String> _scopeLabels = [];
  // Per-employee graded dashboard bars (2026-09-24) — off by default;
  // see OrganisationRepository.setEmployeeGradedBarsEnabled's own doc
  // comment. Loaded once in initState alongside sites.
  bool _gradedBarsEnabled = false;

  bool get _isSupervisor =>
      ref.read(currentUserProvider)?.roleTier == RoleTier.supervisor;

  @override
  void initState() {
    super.initState();
    _loadGradedBarsSetting();
    _loadSites();
  }

  int? _organisationId;

  Future<void> _loadGradedBarsSetting() async {
    final org = await ref.read(organisationRepositoryProvider).getDefault();
    if (!mounted) return;
    setState(() {
      _organisationId = org.id;
      _gradedBarsEnabled = org.employeeGradedBarsEnabled;
    });
  }

  Future<void> _toggleGradedBars() async {
    final orgId = _organisationId;
    if (orgId == null) return;
    final next = !_gradedBarsEnabled;
    setState(() => _gradedBarsEnabled = next);
    await ref
        .read(organisationRepositoryProvider)
        .setEmployeeGradedBarsEnabled(orgId, next);
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
      // Cross-venue rollup (2026-09-18) — a genuinely multi-site tier
      // (Regional/Executive) defaults to the aggregate "All branches"
      // view, matching the user's own framing ("Regional = their region's
      // branches, Executive = everything") rather than an arbitrary first
      // branch. Single-site tiers (Supervisor/Venue Manager) are
      // unaffected — they only ever have one site to begin with.
      _selectedSiteId = sites.isEmpty
          ? null
          : (sites.length > 1 ? _allBranchesSentinel : sites.first.id);
    });
    if (_selectedSiteId != null) await _loadForSite();
  }

  Future<void> _loadForSite() async {
    final siteId = _selectedSiteId;
    if (siteId == null) return;
    setState(() => _loading = true);

    if (siteId == _allBranchesSentinel) {
      // Area/Employee/section-scope don't generalise across multiple
      // sites without much more work than this pass is scoped for — see
      // _buildFilters(), which hides those controls in this mode.
      setState(() {
        _areas = [];
        _staff = [];
        _selectedAreaId = null;
        _selectedEmployeeId = null;
        _allowedUserIds = null;
        _scopeLabels = [];
      });
      await _loadBreakdowns();
      return;
    }

    final areas = await ref.read(areaRepositoryProvider).getForSite(siteId);
    final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
    final activeStaff = staff.where((u) => u.active).toList();

    final currentUser = ref.read(currentUserProvider);
    final scope = await computeSupervisorScope(
      ref,
      currentUser: currentUser,
      siteId: siteId,
    );
    final allowedUserIds = scope?.allowedUserIds;
    final scopeLabels = scope?.scopeLabels ?? <String>[];

    if (!mounted) return;
    setState(() {
      _areas = areas;
      _staff = activeStaff;
      _selectedAreaId = null;
      _selectedEmployeeId = null;
      _allowedUserIds = allowedUserIds;
      _scopeLabels = scopeLabels;
    });
    await _loadBreakdowns();
  }

  Future<void> _loadBreakdowns() async {
    final siteId = _selectedSiteId;
    if (siteId == null) return;
    setState(() => _loading = true);
    final range = _range;
    final service = ref.read(leadershipDashboardServiceProvider);

    if (siteId == _allBranchesSentinel) {
      // Cross-venue rollup (2026-09-18) — one computation per permitted
      // site, then a plain concatenation merge (see
      // TaskOverviewBreakdown.merge/IncidentsBreakdown.merge). Each site's
      // own numbers are exactly what its own single-site dashboard would
      // show; nothing here recomputes or reinterprets them.
      final overviews = <TaskOverviewBreakdown>[];
      final incidentsList = <IncidentsBreakdown>[];
      for (final site in _sites) {
        overviews.add(
          await service.computeTaskOverview(
            siteId: site.id,
            start: range.start,
            end: range.end,
          ),
        );
        incidentsList.add(
          await service.computeIncidents(
            siteId: site.id,
            start: range.start,
            end: range.end,
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _taskOverview = TaskOverviewBreakdown.merge(overviews);
        _incidents = IncidentsBreakdown.merge(incidentsList);
        _loading = false;
      });
      return;
    }

    if (_selectedEmployeeId != null) {
      // Per-employee graded bars (2026-09-24, opt-in): when the org has
      // switched this on, reuse the exact same bar the branch/section
      // view renders, fed by computeTaskOverview/computeIncidents'
      // pre-existing employeeId filter. Off (default): the plain,
      // ungraded lookup list — see the class doc comment.
      if (_gradedBarsEnabled) {
        final taskOverview = await service.computeTaskOverview(
          siteId: siteId,
          start: range.start,
          end: range.end,
          areaId: _selectedAreaId,
          employeeId: _selectedEmployeeId,
          allowedUserIds: _allowedUserIds,
        );
        final incidents = await service.computeIncidents(
          siteId: siteId,
          start: range.start,
          end: range.end,
          employeeId: _selectedEmployeeId,
          allowedUserIds: _allowedUserIds,
        );
        if (!mounted) return;
        setState(() {
          _taskOverview = taskOverview;
          _incidents = incidents;
          _loading = false;
        });
        return;
      }

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
      allowedUserIds: _allowedUserIds,
    );
    final incidents = await service.computeIncidents(
      siteId: siteId,
      start: range.start,
      end: range.end,
      allowedUserIds: _allowedUserIds,
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
    final l10n = AppLocalizations.of(context)!;
    final supervisorHasNoScope =
        _isSupervisor && !_loading && (_allowedUserIds?.isEmpty ?? false);
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.dashboardOverviewTitle),
        actions: [
          // Moved here from a Settings toggle (2026-09-29, direct founder
          // request) — the setting and the thing it controls used to live
          // on two different screens. Still executive-only (unchanged
          // gate: a company-wide dashboard behaviour, not a per-venue
          // one) — a supervisor/venueManager viewing this screen simply
          // doesn't see the icon at all, same as before when the Settings
          // toggle was invisible to them.
          if (ref.watch(currentUserProvider)?.roleTier == RoleTier.executive)
            IconButton(
              icon: Icon(
                _gradedBarsEnabled ? Icons.leaderboard : Icons.leaderboard_outlined,
              ),
              tooltip: _gradedBarsEnabled
                  ? l10n.gradedBarsOnTooltip
                  : l10n.gradedBarsOffTooltip,
              onPressed: _toggleGradedBars,
            ),
          const AssistantIconButton(),
        ],
      ),
      drawer: ManagementDrawer(title: l10n.dashboardOverviewTitle),
      body: _sites.isEmpty
          ? Center(child: Text(l10n.noBranchesToShow))
          : ResponsiveContent(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters(l10n),
                    const SizedBox(height: 16),
                    if (_loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (supervisorHasNoScope)
                      AppCard(child: Text(l10n.supervisorNoScopeMessage))
                    else if (_selectedEmployeeId != null && !_gradedBarsEnabled)
                      _buildEmployeeLookup(l10n)
                    else ...[
                      if (_selectedEmployeeId != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.individualViewNotice,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.muted),
                          ),
                        ),
                      _buildTaskOverviewCard(l10n),
                      const SizedBox(height: 16),
                      _buildIncidentsCard(l10n),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_sites.length > 1) ...[
            Text(l10n.branchLabel),
            const SizedBox(height: 4),
            DropdownButtonFormField<int>(
              initialValue: _selectedSiteId,
              items: [
                // Cross-venue rollup (2026-09-18) — combines every
                // permitted site's own numbers via plain concatenation
                // (TaskOverviewBreakdown.merge/IncidentsBreakdown.merge).
                DropdownMenuItem(
                  value: _allBranchesSentinel,
                  child: Text(l10n.allBranchesLabel),
                ),
                ..._sites.map(
                  (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                ),
              ],
              onChanged: (v) {
                setState(() => _selectedSiteId = v);
                _loadForSite();
              },
            ),
            const SizedBox(height: 12),
          ],
          // Sections/Teams scoping (2026-09-18) — a Supervisor gets a
          // locked read-out of their own supervised section(s)/team(s)
          // instead of the free Area/Employee dropdowns Venue Manager+
          // gets: their whole point is to see only their own scope, not
          // to be handed the same free-roam filters as branch leadership.
          if (_isSupervisor) ...[
            Text(l10n.yourSectionLabel),
            const SizedBox(height: 4),
            Text(
              _scopeLabels.isEmpty
                  ? l10n.noneAssignedLabel
                  : _scopeLabels.join(', '),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
          ] else if (_selectedSiteId != _allBranchesSentinel) ...[
            // "Area" — a physical/equipment location grouping, a
            // deliberately different concept from the Department-based
            // "section" a Supervisor is scoped by above (renamed from
            // "Section" 2026-09-18 to stop the two ideas colliding under
            // one word).
            Text(l10n.areaLabel),
            const SizedBox(height: 4),
            DropdownButtonFormField<int?>(
              initialValue: _selectedAreaId,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.allAreasLabel)),
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
            Text(l10n.employeeLabel),
            const SizedBox(height: 4),
            DropdownButtonFormField<int?>(
              initialValue: _selectedEmployeeId,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.allEmployeesLabel),
                ),
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
          ],
          SegmentedButton<_Period>(
            segments: [
              ButtonSegment(value: _Period.month, label: Text(l10n.monthLabel)),
              ButtonSegment(value: _Period.week, label: Text(l10n.weekLabel)),
              ButtonSegment(value: _Period.day, label: Text(l10n.dayLabel)),
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

  Widget _buildTaskOverviewCard(AppLocalizations l10n) {
    final overview = _taskOverview;
    if (overview == null || overview.total == 0) {
      return AppCard(child: Text(l10n.noTaskActivityPeriod));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.taskOverviewTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _ProportionBar(
            segments: [
              _BarSegment(
                overview.onTimeNoIssuesRate,
                AppColors.pass,
                '${overview.onTimeNoIssues.length}',
                () => _showSubmissionBreakdown(
                  l10n.doneOnTimeNoIssues,
                  overview.onTimeNoIssues,
                ),
              ),
              _BarSegment(
                overview.onTimeIssuesLoggedRate,
                const Color(0xFFE8C547),
                '${overview.onTimeIssuesLogged.length}',
                () => _showSubmissionBreakdown(
                  l10n.doneOnTimeIssuesLogged,
                  overview.onTimeIssuesLogged,
                ),
              ),
              _BarSegment(
                overview.offWindowNoIssuesRate,
                const Color(0xFFE8873D),
                '${overview.offWindowNoIssues.length}',
                () => _showSubmissionBreakdown(
                  l10n.doneEarlyLateNoIssues,
                  overview.offWindowNoIssues,
                ),
              ),
              _BarSegment(
                overview.offWindowIssuesLoggedRate,
                const Color(0xFF8E5FD9),
                '${overview.offWindowIssuesLogged.length}',
                () => _showSubmissionBreakdown(
                  l10n.doneEarlyLateIssuesLogged,
                  overview.offWindowIssuesLogged,
                ),
              ),
              _BarSegment(
                overview.notDoneRate,
                AppColors.critical,
                '${overview.notDone.length}',
                () => _showSubmissionBreakdown(l10n.notDoneLabel, overview.notDone),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _legendRow([
            (
              AppColors.pass,
              l10n.doneOnTimeNoIssues,
              () => _showSubmissionBreakdown(
                l10n.doneOnTimeNoIssues,
                overview.onTimeNoIssues,
              ),
            ),
            (
              const Color(0xFFE8C547),
              l10n.doneOnTimeIssuesLogged,
              () => _showSubmissionBreakdown(
                l10n.doneOnTimeIssuesLogged,
                overview.onTimeIssuesLogged,
              ),
            ),
            (
              const Color(0xFFE8873D),
              l10n.doneEarlyLateNoIssues,
              () => _showSubmissionBreakdown(
                l10n.doneEarlyLateNoIssues,
                overview.offWindowNoIssues,
              ),
            ),
            (
              const Color(0xFF8E5FD9),
              l10n.doneEarlyLateIssuesLogged,
              () => _showSubmissionBreakdown(
                l10n.doneEarlyLateIssuesLogged,
                overview.offWindowIssuesLogged,
              ),
            ),
            (
              AppColors.critical,
              l10n.notDoneLabel,
              () => _showSubmissionBreakdown(l10n.notDoneLabel, overview.notDone),
            ),
          ]),
          _TapForDetailsHint(text: l10n.tapForDetailsHint),
        ],
      ),
    );
  }

  Widget _buildIncidentsCard(AppLocalizations l10n) {
    final incidents = _incidents;
    if (incidents == null || incidents.total == 0) {
      return AppCard(child: Text(l10n.noIncidentsPeriod));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.incidentsTitle, style: Theme.of(context).textTheme.titleMedium),
              // "Urgent" badge (2026-09-20) — additive, not part of the
              // bar below (see IncidentsBreakdown.urgent's own doc
              // comment for why it can't be a mutually-exclusive
              // segment). Only shown when non-zero, same "never a
              // permanent zero-value fixture" convention as every other
              // conditional badge in this app.
              if (incidents.urgent.isNotEmpty) ...[
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () =>
                      _showIssueBreakdown(l10n.urgentLabel, incidents.urgent),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.criticalBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.urgentCountLabel(incidents.urgent.length),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.critical,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _ProportionBar(
            segments: [
              _BarSegment(
                incidents.resolvedRate,
                AppColors.pass,
                '${incidents.resolved.length}',
                () => _showIssueBreakdown(l10n.resolvedLabel, incidents.resolved),
              ),
              _BarSegment(
                incidents.unresolvedRate,
                const Color(0xFFE8C547),
                '${incidents.unresolved.length}',
                () => _showIssueBreakdown(l10n.unresolvedLabel, incidents.unresolved),
              ),
              _BarSegment(
                incidents.escalatedRate,
                const Color(0xFFE8873D),
                '${incidents.escalated.length}',
                () => _showIssueBreakdown(l10n.escalatedLabel, incidents.escalated),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _legendRow([
            (
              AppColors.pass,
              l10n.resolvedLabel,
              () => _showIssueBreakdown(l10n.resolvedLabel, incidents.resolved),
            ),
            (
              const Color(0xFFE8C547),
              l10n.unresolvedLabel,
              () => _showIssueBreakdown(l10n.unresolvedLabel, incidents.unresolved),
            ),
            (
              const Color(0xFFE8873D),
              l10n.escalatedLabel,
              () => _showIssueBreakdown(l10n.escalatedLabel, incidents.escalated),
            ),
          ]),
          _TapForDetailsHint(text: l10n.tapForDetailsHint),
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
              subtitle: '${i.details} - ${formatDateTime(i.raisedAt)}',
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeLookup(AppLocalizations l10n) {
    final employee = _staff
        .where((u) => u.id == _selectedEmployeeId)
        .firstOrNull;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee?.name ?? l10n.employeeFallbackLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.plainLookupNotice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.tasksCompletedCountParens(_employeeSubmissions.length),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final s in _employeeSubmissions.take(20))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${s.taskTitle} - ${formatDateTime(s.completedAt)}'),
            ),
          const SizedBox(height: 12),
          Text(
            l10n.issuesRaisedCountParens(_employeeIssues.length),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final i in _employeeIssues.take(20))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${issueTypeDisplayName(i.type)} - ${issueStatusDisplayName(i.status)} '
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

// Discoverability fix (2026-09-24, direct user feedback) — the bars and
// legend were already tappable (see _showSubmissionBreakdown/
// _showIssueBreakdown's own doc comment: this was literally in the
// original mockup's own "Click on colour band for detailed breakdown"
// text), but that hint text itself never actually made it onto the
// screen — only the underlying tap behaviour was built. This closes
// that gap.
class _TapForDetailsHint extends StatelessWidget {
  const _TapForDetailsHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.touch_app_outlined,
            size: 14,
            color: AppColors.muted,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
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
