import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/trigger_notifications_banner.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/models/session_summary.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/trigger_notification.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../notifications/escalation_service.dart';
import '../tasks/overdue_summary_service.dart';
import 'manager_log_filter.dart';
import 'overdue_summary_card.dart';

class ManagerScreen extends ConsumerStatefulWidget {
  const ManagerScreen({super.key});

  @override
  ConsumerState<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends ConsumerState<ManagerScreen> {
  Timer? _escalationTimer;
  LogFilterSelection _filter = const LogFilterSelection();
  List<OverdueSummaryEntry> _overdueEntries = [];

  @override
  void initState() {
    super.initState();
    _runPeriodicChecks();
    _escalationTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _runPeriodicChecks(),
    );
  }

  @override
  void dispose() {
    _escalationTimer?.cancel();
    super.dispose();
  }

  // Runs on load and every tick thereafter — the only realistic mechanism
  // for a purely local app with no background service. If nobody has this
  // screen open, nothing escalates and the overdue summary goes stale;
  // there's nothing to "miss" for the overdue half specifically though —
  // unlike a notification, it's a live fact, correct the instant any
  // manager next opens this screen, not a fired-or-not event. Renamed
  // from _runEscalationCheck (Sprint 031, Sub-sprint D) once it started
  // doing more than escalation.
  Future<void> _runPeriodicChecks() async {
    await ref.read(escalationServiceProvider).checkAndEscalate();

    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      final overdue = await ref
          .read(overdueSummaryServiceProvider)
          .getSummaryForSite(currentUser.siteId!);
      if (mounted) setState(() => _overdueEntries = overdue);
    } else if (mounted) {
      setState(() {});
    }
  }

  // Manager log filtering (Sprint 031): grouping follows whichever
  // dimension leads the active "Filter by" lens — Name/null groups by
  // staff (the pre-existing, unchanged default), Date groups by calendar
  // day, Task groups by task title. This is a distinct decision from which
  // dimensions are actually selected as filter values (ManagerLogFilter's
  // own concern) — grouping only cares about the chosen lens.
  Map<String, List<TaskSubmission>> _groupEntries(
    List<TaskSubmission> items,
    LogFilterAxis? axis,
  ) {
    String keyOf(TaskSubmission entry) {
      switch (axis) {
        case LogFilterAxis.date:
          return formatDate(entry.completedAt);
        case LogFilterAxis.task:
          return entry.taskTitle;
        case LogFilterAxis.name:
        case null:
          return entry.completedBy;
      }
    }

    final Map<String, List<TaskSubmission>> grouped = {};
    for (final entry in items) {
      grouped.putIfAbsent(keyOf(entry), () => []).add(entry);
    }
    return grouped;
  }

  // Visual/UX pass, Sub-sprint 5: was a hand-built ✓/✗ + "Pass"/"Fail"
  // string — the same "ad hoc instead of shared widget" pattern the
  // base-tier audit found. A full StatusBadge pill per line would be too
  // heavy for this screen's "control room" density (many lines, dense
  // list) — deliberately lighter: a small coloured icon, and colour on the
  // text only for FAIL, so failures are what actually draws the eye.
  //
  // Manager log filtering (Sprint 031): the line's own text adapts to
  // whatever the group header (see _groupEntries) DOESN'T already show —
  // grouped by staff, the header already says who, so the line shows
  // task+date; grouped by date, the header already says when, so the line
  // shows who+task; grouped by task, the line shows who+date.
  Widget _buildLogLine(TaskSubmission entry, LogFilterAxis? groupBy) {
    // Exit behaviour (Sprint 031, Sub-sprint B): NOT_COMPLETED is its own
    // state, not a FAIL wearing a different name — confirmed with the
    // user this needed a genuinely distinguishable treatment (icon AND
    // word, not colour alone, per the Accessibility Rule), not just
    // falling into the old binary isPass/critical branch. Neutral muted
    // colour, since an abandoned mid-shift task isn't itself a compliance
    // failure — it's expected, allowed behaviour, just never silent.
    final isPass = entry.status == 'PASS';
    final isNotCompleted = entry.status == 'NOT_COMPLETED';
    final Color color;
    final IconData icon;
    if (isNotCompleted) {
      color = AppColors.muted;
      icon = Icons.remove_circle_outline;
    } else if (isPass) {
      color = AppColors.pass;
      icon = Icons.check_circle_outline;
    } else {
      color = AppColors.critical;
      icon = Icons.cancel_outlined;
    }

    // Instance-name prominence (2026-09-06): the instance name (if any)
    // renders bold within the line, wherever the task title itself would
    // appear — never just folded into the plain string, so "which fridge"
    // reads at a glance even in a dense scrolling log.
    const boldInstance = TextStyle(fontWeight: FontWeight.w700);
    List<InlineSpan> titleSpans() {
      final instanceName = entry.equipmentInstanceName;
      if (instanceName == null) return [TextSpan(text: entry.taskTitle)];
      return [
        TextSpan(text: instanceName, style: boldInstance),
        TextSpan(text: ' — ${entry.taskTitle}'),
      ];
    }

    final List<InlineSpan> spans;
    switch (groupBy) {
      case LogFilterAxis.date:
        spans = [TextSpan(text: '${entry.completedBy} — '), ...titleSpans()];
        break;
      case LogFilterAxis.task:
        spans = [
          TextSpan(
            text: '${entry.completedBy} (${formatDateTime(entry.completedAt)})',
          ),
        ];
        break;
      case LogFilterAxis.name:
      case null:
        spans = [
          ...titleSpans(),
          TextSpan(text: ' (${formatDateTime(entry.completedAt)})'),
        ];
        break;
    }
    final statusSuffix = isNotCompleted
        ? ' — NOT COMPLETED (session ended)'
        : '';
    spans.add(
      TextSpan(text: '$statusSuffix${entry.photoAttached ? ' 📷' : ''}'),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.3,
                  color: isPass ? null : color,
                  fontWeight: isPass ? null : FontWeight.w600,
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskSubmissionRepo = ref.watch(taskSubmissionRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);
    final sessionSummaryRepo = ref.watch(sessionSummaryRepositoryProvider);
    final triggerNotificationRepo = ref.watch(
      triggerNotificationRepositoryProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text('Manager View'),
      ),
      // Sub-sprint 2 (visual/UX pass): replaces the previous 9-icon,
      // tooltip-only AppBar action row — tooltips never surface on touch
      // devices, so a user unfamiliar with the glyphs had no way to tell
      // what a button did before pressing it. A drawer with a visible icon
      // + label per row fixes that without crowding the app bar.
      drawer: const ManagementDrawer(title: 'Manager View'),
      // Layout fix (Sprint 031): the banners and the filter used to sit
      // outside the scrollable area (only the log itself was Expanded),
      // so their combined height was a fixed tax on the viewport — with
      // the cascade filter and a few notifications/summaries, the actual
      // log (the point of this screen) could get squeezed to almost
      // nothing. Now everything is one scrollable ListView: banners and
      // the (collapsed-by-default) filter are just its first items, so
      // they scroll away instead of permanently reserving space. The
      // banners themselves are unchanged — still fully visible, not
      // collapsible, since a manager must not miss a critical/caution
      // alert by default; they just no longer block the log.
      body: StreamBuilder<List<TaskSubmission>>(
        // Manager log filtering (Sprint 031): the log becomes an unusable
        // wall at real scale (30 staff x 150 tasks x days), so this no
        // longer defaults to the unbounded watchAll(). No filter active:
        // today's entries, plus every FAIL regardless of date (FAILs must
        // never silently age out of a compliance view — see
        // DECISIONS_LOG.md). A filter active: the matching subset, via
        // the same repository.
        stream: _filter.isActive
            ? taskSubmissionRepo.watchFiltered(
                name: _filter.name,
                date: _filter.date,
                task: _filter.task,
              )
            : taskSubmissionRepo.watchDefaultView(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!;
          final groupedEntries = _groupEntries(entries, _filter.axis);
          final groupKeys = groupedEntries.keys.toList();

          return ResponsiveContent(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (currentUser != null)
                  StreamBuilder<List<TriggerNotification>>(
                    stream: triggerNotificationRepo.watchForUser(
                      currentUser.id,
                    ),
                    builder: (context, snapshot) {
                      final notifications = snapshot.data ?? [];
                      if (notifications.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TriggerNotificationsBanner(
                          notifications: notifications,
                          onAcknowledge: triggerNotificationRepo.acknowledge,
                          // Alert → task drill-down (2026-09-12): the
                          // already-loaded submissions let an alert row
                          // resolve its failed task in-place for a detail
                          // dialog — no extra fetch, no navigation.
                          onRowTap: (notification) => _showAlertDetail(
                            context,
                            notification,
                            entries,
                            triggerNotificationRepo.acknowledge,
                          ),
                        ),
                      );
                    },
                  ),
                if (currentUser != null)
                  StreamBuilder<List<SessionSummary>>(
                    stream: sessionSummaryRepo.watchForManager(currentUser.id),
                    builder: (context, snapshot) {
                      final summaries = snapshot.data ?? [];
                      if (summaries.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SessionSummariesBanner(
                          summaries: summaries,
                          onAcknowledge: sessionSummaryRepo.acknowledge,
                        ),
                      );
                    },
                  ),
                if (_overdueEntries.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OverdueSummaryCard(entries: _overdueEntries),
                  ),
                _SubmissionLogSection(
                  entries: entries,
                  groupedEntries: groupedEntries,
                  groupKeys: groupKeys,
                  axis: _filter.axis,
                  buildLogLine: _buildLogLine,
                  onFilterChanged: (selection) =>
                      setState(() => _filter = selection),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Busy-oversight declutter (Sprint 031): wraps the existing ManagerLogFilter
// (unchanged, still owns its own collapse state for just the filter
// controls) plus the resulting grouped log cards in one new outer
// Card+ExpansionTile, collapsed by default — previously the log cards
// rendered unconditionally below the filter with nothing to tidy them
// away. The collapsed header flags FAIL presence distinctly (not a bare
// count): "12 entries" alone can't distinguish 12 uneventful passes from
// 12 entries including 2 fails without expanding, which would be exactly
// the kind of silent-by-omission gap the "fails never hidden" principle
// exists to prevent — the count itself is never hidden, just the detail.
class _SubmissionLogSection extends StatelessWidget {
  const _SubmissionLogSection({
    required this.entries,
    required this.groupedEntries,
    required this.groupKeys,
    required this.axis,
    required this.buildLogLine,
    required this.onFilterChanged,
  });

  final List<TaskSubmission> entries;
  final Map<String, List<TaskSubmission>> groupedEntries;
  final List<String> groupKeys;
  final LogFilterAxis? axis;
  final Widget Function(TaskSubmission entry, LogFilterAxis? axis) buildLogLine;
  final ValueChanged<LogFilterSelection> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final failCount = entries.where((e) => e.status == 'FAIL').length;

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.list_alt),
        title: Text(
          '${entries.length} entr${entries.length == 1 ? 'y' : 'ies'}',
        ),
        subtitle: failCount > 0
            ? Text(
                '$failCount FAIL${failCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: AppColors.critical,
                  fontWeight: FontWeight.w700,
                ),
              )
            : const Text('No fails'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ManagerLogFilter(onChanged: onFilterChanged),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Center(child: Text('No completed tasks logged yet')),
            )
          else
            for (final groupKey in groupKeys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupKey,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...groupedEntries[groupKey]!.map(
                        (entry) => buildLogLine(entry, axis),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// Busy-oversight declutter (Sprint 031): Card+ExpansionTile, matching
// OverdueSummaryCard/ManagerLogFilter's established pattern — collapsed by
// default. The collapsed header flags the *unacknowledged* count
// specifically, not just a bare total: an unacknowledged summary is the
// thing that actually needs action, so it must stay distinguishable from
// an already-handled one without expanding (same reasoning the Submission
// Log's collapsed header above applies to FAILs).
class _SessionSummariesBanner extends StatelessWidget {
  const _SessionSummariesBanner({
    required this.summaries,
    required this.onAcknowledge,
  });

  final List<SessionSummary> summaries;
  final void Function(int id) onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final unacknowledged = summaries.where((s) => !s.acknowledged).length;

    return Card(
      child: ExpansionTile(
        leading: const Icon(
          Icons.assignment_turned_in,
          color: AppColors.caution,
        ),
        title: Text(
          '${summaries.length} session '
          'summar${summaries.length == 1 ? 'y' : 'ies'}',
        ),
        subtitle: unacknowledged > 0
            ? Text(
                '$unacknowledged unacknowledged',
                style: const TextStyle(
                  color: AppColors.caution,
                  fontWeight: FontWeight.w700,
                ),
              )
            : const Text('All acknowledged'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ...summaries.map(
            (summary) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${summary.staffName} — ${summary.passCount} pass / '
                      '${summary.failCount} fail'
                      '${summary.note != null ? '\n"${summary.note}"' : ''}',
                    ),
                  ),
                  if (!summary.acknowledged)
                    TextButton(
                      onPressed: () => onAcknowledge(summary.id),
                      child: const Text('Acknowledge'),
                    )
                  else
                    const Icon(Icons.check, color: AppColors.pass),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Busy-oversight declutter (Sprint 031): Card+ExpansionTile like the other
// three sections, but initiallyExpanded: true — alerts are urgent, a
// manager must see them immediately, so this one starts open rather than
// collapsed. Still tap-to-collapse once read, same as everywhere else,
// so it doesn't permanently occupy space after being handled — nothing is
// hidden by default, which is what the "never miss a critical alert"
// principle actually requires; it never required being un-collapsible.
// Alert → task drill-down (2026-09-12): opens the failed submission an
// alert points at. Falls back to a lightweight detail when the submission
// isn't in the currently-watched set (e.g. an old FAIL that's filtered out
// of the default view).
void _showAlertDetail(
  BuildContext context,
  TriggerNotification notification,
  List<TaskSubmission> submissions,
  void Function(int id) onAcknowledge,
) {
  TaskSubmission? submissionFor(TriggerNotification n) {
    for (final submission in submissions) {
      if (submission.id == n.taskSubmissionId) {
        return submission;
      }
    }
    return null;
  }

  final submission = submissionFor(notification);
  final correctiveLabel = switch (submission?.correctiveActionOutcome) {
    'fixed' => 'Worker fixed it',
    'reported' => 'Reported to manager',
    _ => 'No corrective action recorded',
  };

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(submission?.taskTitle ?? 'Task alert'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (submission?.equipmentInstanceName != null)
            Text(
              submission!.equipmentInstanceName!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.teal,
              ),
            ),
          const SizedBox(height: 8),
          Text(notification.message),
          const SizedBox(height: 12),
          if (submission != null) ...[
            _DetailRow(
              label: 'Logged by',
              value:
                  '${submission.completedBy} (${formatDateTime(submission.completedAt)})',
            ),
            const SizedBox(height: 4),
            _DetailRow(label: 'Result', value: submission.status),
            const SizedBox(height: 4),
            _DetailRow(label: 'Corrective action', value: correctiveLabel),
            if (submission.correctiveActionNote != null) ...[
              const SizedBox(height: 4),
              _DetailRow(
                label: 'Note',
                value: submission.correctiveActionNote!,
              ),
            ],
          ] else
            _DetailRow(label: 'Corrective action', value: correctiveLabel),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
        if (!notification.acknowledged)
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onAcknowledge(notification.id);
            },
            child: const Text('Acknowledge'),
          ),
      ],
    ),
  );
}

// Alert → task drill-down (2026-09-12): a small labelled value row used by
// the alert detail dialog — label in muted text, value strong. Keeps the
// dialog scannable without prose.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
