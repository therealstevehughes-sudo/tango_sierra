import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/urgency.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
            // Choice chips in a Wrap, not SegmentedButton (2026-09-22,
            // same fix as the Task Problems tab's own filter row) — a
            // fixed 4-way segmented row divides its width evenly
            // regardless of each label's length, so a narrow window
            // could break "Unresolved"/"Escalated" mid-word with nowhere
            // else to wrap. A Wrap sizes each chip to its own label and
            // flows extra chips onto a new row instead.
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _IssueFilterChip(
                  label: l10n.allLabel,
                  selected: _statusFilter == IssueFilter.all,
                  onSelected: () {
                    setState(() => _statusFilter = IssueFilter.all);
                    _load();
                  },
                ),
                _IssueFilterChip(
                  label: l10n.unresolvedLabel,
                  selected: _statusFilter == IssueFilter.open,
                  onSelected: () {
                    setState(() => _statusFilter = IssueFilter.open);
                    _load();
                  },
                ),
                _IssueFilterChip(
                  label: l10n.resolvedLabel,
                  selected: _statusFilter == IssueFilter.resolved,
                  onSelected: () {
                    setState(() => _statusFilter = IssueFilter.resolved);
                    _load();
                  },
                ),
                _IssueFilterChip(
                  label: l10n.escalatedLabel,
                  selected: _statusFilter == IssueFilter.escalated,
                  onSelected: () {
                    setState(() => _statusFilter = IssueFilter.escalated);
                    _load();
                  },
                ),
              ],
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
                  labelText: l10n.dateRangeLabel,
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
                      ? l10n.allDatesLabel
                      : '${formatDate(_dateRange!.start)} - ${formatDate(_dateRange!.end)}',
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
                    decoration: InputDecoration(
                      labelText: l10n.typeLabel,
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.anyTypeLabel),
                      ),
                      ...IssueType.values.map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(issueTypeDisplayName(t, l10n)),
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
                    decoration: InputDecoration(
                      labelText: l10n.employeeLabel,
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.anyoneLabel),
                      ),
                      ...employeeIds.map(
                        (id) => DropdownMenuItem(
                          value: id,
                          child: Text(
                            _staffNames[id] ?? l10n.staffFallback('$id'),
                          ),
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
                ? Center(
                    child: Text(l10n.nothingHereGoodSign),
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
    final l10n = AppLocalizations.of(context)!;
    final urgency = computeUrgency(
      since: issue.raisedAt,
      escalated: issue.status == IssueStatus.escalated,
      manualUrgent: issue.manualUrgent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AppCard(
        accentColor: urgencyStripeColor(urgency),
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
                              ? '${issueTypeDisplayName(issue.type, l10n)} · ${issue.subtype}'
                              : issueTypeDisplayName(issue.type, l10n),
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
                      l10n.escalatedToNameLabel(escalatedToName!),
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
        issueStatusDisplayName(status, AppLocalizations.of(context)!),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// 2026-09-22 — see the matching widget in problems_register_screen.dart
// for the full reasoning; same fix, same shape.
class _IssueFilterChip extends StatelessWidget {
  const _IssueFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
