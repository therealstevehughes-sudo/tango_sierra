import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/urgency.dart';
import '../../shared/models/issue.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart' show userRepositoryProvider;
import '../../shared/providers/issue_providers.dart';
import '../../shared/repositories/issue_repository.dart';
import 'issue_detail_screen.dart';

// PART 2 of the branch-hub build (2026-09-15) — second tab of the Fails &
// Problems Register. Filterable by date/type/status/employee here; branch
// per the user's spec is covered by this register already being
// site-scoped (branch = site, same single-site-per-user limitation the
// Task Problems tab next to it already documents). No "shift" concept
// exists anywhere in this app yet — a real gap, not silently invented
// here.
//
// Any staff member can see this register (raising and viewing are both
// open); adding a Process/Outcome note or resolving/escalating is gated
// to supervisor+ inside IssueDetailScreen via [canManage].
class IssuesRegisterTab extends ConsumerStatefulWidget {
  const IssuesRegisterTab({super.key, required this.currentUser});

  final User currentUser;

  @override
  ConsumerState<IssuesRegisterTab> createState() => _IssuesRegisterTabState();
}

class _IssuesRegisterTabState extends ConsumerState<IssuesRegisterTab> {
  IssueFilter _statusFilter = IssueFilter.all;
  IssueType? _typeFilter;
  int? _employeeFilter;
  DateTimeRange? _dateRange;
  List<Issue> _issues = [];
  Map<int, String> _staffNames = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final siteId = widget.currentUser.siteId!;
    final results = await Future.wait([
      ref
          .read(issueRepositoryProvider)
          .getForSite(siteId, filter: _statusFilter),
      ref.read(userRepositoryProvider).getForSite(siteId),
    ]);
    if (!mounted) return;
    final issues = results[0] as List<Issue>;
    final staff = results[1] as List<User>;
    setState(() {
      _issues = issues;
      _staffNames = {for (final u in staff) u.id: u.name};
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canManage =
        roleTierRank(widget.currentUser.roleTier) >=
        roleTierRank(RoleTier.supervisor);

    final range = _dateRange;
    final visible = _issues.where((i) {
      if (_typeFilter != null && i.type != _typeFilter) return false;
      if (_employeeFilter != null && i.raisedByUserId != _employeeFilter) {
        return false;
      }
      if (range != null) {
        final raisedDate = DateTime(
          i.raisedAt.year,
          i.raisedAt.month,
          i.raisedAt.day,
        );
        if (raisedDate.isBefore(range.start) || raisedDate.isAfter(range.end)) {
          return false;
        }
      }
      return true;
    }).toList();

    final employeeIds = _issues.map((i) => i.raisedByUserId).toSet().toList();

    return ResponsiveContent(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SegmentedButton<IssueFilter>(
              segments: const [
                ButtonSegment(value: IssueFilter.all, label: Text('All')),
                ButtonSegment(
                  value: IssueFilter.open,
                  label: Text('Unresolved'),
                ),
                ButtonSegment(
                  value: IssueFilter.resolved,
                  label: Text('Resolved'),
                ),
                ButtonSegment(
                  value: IssueFilter.escalated,
                  label: Text('Escalated'),
                ),
              ],
              selected: {_statusFilter},
              onSelectionChanged: (selection) {
                setState(() => _statusFilter = selection.first);
                _load();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 2),
                  lastDate: now,
                  initialDateRange: _dateRange,
                );
                if (picked != null) setState(() => _dateRange = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date range',
                  isDense: true,
                  suffixIcon: _dateRange == null
                      ? const Icon(Icons.date_range)
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _dateRange = null),
                        ),
                ),
                child: Text(
                  _dateRange == null
                      ? 'All dates'
                      : '${formatDate(_dateRange!.start)} — ${formatDate(_dateRange!.end)}',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<IssueType?>(
                    initialValue: _typeFilter,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Any type'),
                      ),
                      ...IssueType.values.map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(issueTypeDisplayName(t)),
                        ),
                      ),
                    ],
                    onChanged: (t) => setState(() => _typeFilter = t),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: _employeeFilter,
                    decoration: const InputDecoration(
                      labelText: 'Employee',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Anyone'),
                      ),
                      ...employeeIds.map(
                        (id) => DropdownMenuItem(
                          value: id,
                          child: Text(_staffNames[id] ?? 'Staff #$id'),
                        ),
                      ),
                    ],
                    onChanged: (id) => setState(() => _employeeFilter = id),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : visible.isEmpty
                ? const Center(
                    child: Text('Nothing here — that\'s a good sign.'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final issue = visible[index];
                      return _IssueTile(
                        issue: issue,
                        escalatedToName: issue.escalatedToUserId == null
                            ? null
                            : _staffNames[issue.escalatedToUserId],
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IssueDetailScreen(
                                issue: issue,
                                canManage: canManage,
                              ),
                            ),
                          );
                          _load();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _IssueTile extends StatelessWidget {
  const _IssueTile({
    required this.issue,
    required this.onTap,
    this.escalatedToName,
  });

  final Issue issue;
  final VoidCallback onTap;
  final String? escalatedToName;

  @override
  Widget build(BuildContext context) {
    final urgency = computeUrgency(
      since: issue.raisedAt,
      escalated: issue.status == IssueStatus.escalated,
      manualUrgent: issue.manualUrgent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: UrgencyStripe(
        level: urgency,
        child: AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            issue.subtype != null
                                ? '${issueTypeDisplayName(issue.type)} · ${issue.subtype}'
                                : issueTypeDisplayName(issue.type),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (urgency == UrgencyLevel.high) ...[
                          const SizedBox(width: 6),
                          UrgencyChip(level: urgency),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      issue.details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateTime(issue.raisedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (escalatedToName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Escalated to $escalatedToName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(status: issue.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final IssueStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg) = switch (status) {
      IssueStatus.resolved => (AppColors.pass, AppColors.passBg),
      IssueStatus.escalated => (AppColors.critical, AppColors.criticalBg),
      IssueStatus.open => (AppColors.ink, AppColors.line),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        issueStatusDisplayName(status),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
