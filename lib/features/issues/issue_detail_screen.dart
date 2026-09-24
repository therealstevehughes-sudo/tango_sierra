import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/issue.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../suppliers/supplier_detail_screen.dart';

// PART 2 of the branch-hub build (2026-09-15) — where Process/Outcome
// handling happens. Any staff member can OPEN this (to see the full
// Details -> Process -> Outcome history of something they or a colleague
// raised), but adding a note/resolving/escalating is gated to
// supervisor+ by [canManage] (passed from the register tab, which knows
// the caller's tier) — raising is open to everyone, handling flows up to
// managers, per the governing spec.
//
// Redesign (2026-09-24, direct user feedback on this exact screen): the
// old layout centered everything vertically, so on a tall window the
// content read as "floating in space" with no anchor; History was a
// column of loose text blocks with no visual structure at all. Now
// top-anchored (ResponsiveContent's own alignment, not Center) and
// History is a real timeline — a coloured dot per event, connected by a
// line, so it reads as one continuous record instead of separate floating
// paragraphs. Also adds real per-event actions ("Remind", "Reopen") the
// user asked for directly — not decorative buttons, both wired to real
// repository methods (see IssueRepository's own doc comments).
enum _IssueAction { addProcessNote, escalate, resolve, reopen }

class IssueDetailScreen extends ConsumerStatefulWidget {
  const IssueDetailScreen({
    super.key,
    required this.issue,
    required this.canManage,
  });

  final Issue issue;
  final bool canManage;

  @override
  ConsumerState<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends ConsumerState<IssueDetailScreen> {
  final _noteController = TextEditingController();
  List<IssueEvent> _history = [];
  List<User> _staff = [];
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _staffName(int userId) {
    final match = _staff.where((u) => u.id == userId);
    return match.isEmpty ? 'Staff #$userId' : match.first.name;
  }

  Future<void> _load() async {
    final results = await Future.wait([
      ref.read(issueRepositoryProvider).getHistory(widget.issue.id),
      ref.read(userRepositoryProvider).getForSite(widget.issue.siteId),
    ]);
    if (!mounted) return;
    setState(() {
      _history = results[0] as List<IssueEvent>;
      _staff = (results[1] as List<User>).where((u) => u.active).toList();
      _loading = false;
    });
  }

  // Suppliers has no getById (local-Drift-only, no backend cluster yet —
  // see BACKEND_INFRA.md), so resolving the id on this issue means loading
  // the site's supplier list, same lookup pattern used elsewhere in this
  // app for un-indexed local tables.
  Future<void> _openSupplierScorecard() async {
    final supplierId = widget.issue.supplierId;
    if (supplierId == null) return;
    final suppliers = await ref
        .read(supplierRepositoryProvider)
        .getForSite(widget.issue.siteId);
    final supplier = suppliers.where((s) => s.id == supplierId).firstOrNull;
    if (!mounted || supplier == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SupplierDetailScreen(supplier: supplier),
      ),
    );
  }

  // Chain of command (2026-09-15) — escalation target is a free choice,
  // not automatically the raiser's own line manager, since the issue may
  // be about that manager (confirmed with the user). The raiser's
  // reportsToUserId is only used to PRE-SELECT a sensible default in the
  // picker below, never to force the choice.
  Future<int?> _pickEscalationTarget(int? defaultUserId) async {
    var selected =
        defaultUserId != null && _staff.any((u) => u.id == defaultUserId)
        ? defaultUserId
        : null;
    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Escalate to'),
          content: DropdownButtonFormField<int>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Send to'),
            items: _staff
                .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
                .toList(),
            onChanged: (v) => setDialogState(() => selected = v),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () => Navigator.pop(context, selected),
              child: const Text('Escalate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _act(_IssueAction action) async {
    final currentUser = ref.read(currentUserProvider);
    final note = _noteController.text.trim();
    if (currentUser == null || note.isEmpty) return;

    int? escalateToUserId;
    if (action == _IssueAction.escalate) {
      final raiser = _staff.where((u) => u.id == widget.issue.raisedByUserId);
      final defaultTarget = raiser.isEmpty
          ? null
          : raiser.first.reportsToUserId;
      escalateToUserId = await _pickEscalationTarget(defaultTarget);
      if (escalateToUserId == null) return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ref.read(issueRepositoryProvider);
      switch (action) {
        case _IssueAction.addProcessNote:
          await repo.addProcessNote(
            issueId: widget.issue.id,
            note: note,
            byUserId: currentUser.id,
          );
        case _IssueAction.escalate:
          await repo.escalate(
            issueId: widget.issue.id,
            note: note,
            byUserId: currentUser.id,
            escalateToUserId: escalateToUserId!,
          );
        case _IssueAction.resolve:
          await repo.resolve(
            issueId: widget.issue.id,
            note: note,
            byUserId: currentUser.id,
          );
        case _IssueAction.reopen:
          await repo.reopen(
            issueId: widget.issue.id,
            note: note,
            byUserId: currentUser.id,
          );
      }
      _noteController.clear();
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved.')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // "Appeal" (2026-09-24, direct user request) — a resolved issue isn't
  // a dead end: this asks for the reason (required, same as every other
  // action here) then reopens it as a real event, not a silent status
  // flip. Reuses the same note controller/submit path as every other
  // action for consistency, rather than a separate one-off dialog.
  Future<void> _promptReopen() async {
    _noteController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reopen this issue'),
        content: TextField(
          controller: _noteController,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Why should this be reopened?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reopen'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _act(_IssueAction.reopen);
  }

  // "Remind" (2026-09-24) — a nudge, not a new process step; see
  // IssueRepository.remind's own doc comment for why this doesn't touch
  // history at all. Backend-only (no push infra on a local install),
  // gated in the UI below rather than surfacing an error after tapping.
  Future<void> _remind(int targetUserId) async {
    try {
      await ref
          .read(issueRepositoryProvider)
          .remind(issueId: widget.issue.id, targetUserId: targetUserId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminded ${_staffName(targetUserId)}.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send the reminder.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final issue = widget.issue;
    final backendAvailable = ref.watch(backendDataEnabledProvider);
    return Scaffold(
      appBar: AppBar(title: Text(issueTypeDisplayName(issue.type))),
      // Visual pass follow-up (2026-09-24) — was Center(...), which
      // vertically centered everything on a tall window, reading as
      // "floating in space" with no anchor. ResponsiveContent's own
      // topCenter default keeps the width cap without the floaty
      // centering.
      body: SingleChildScrollView(
        child: ResponsiveContent(
          maxWidth: 640,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  elevated: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              issue.subtype ??
                                  issueTypeDisplayName(issue.type),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          _StatusChip(status: issue.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Raised ${formatDateTime(issue.raisedAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(issue.details),
                      if (issue.status == IssueStatus.escalated &&
                          issue.escalatedToUserId != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Escalated to: ${_staffName(issue.escalatedToUserId!)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (issue.type == IssueType.supplyProblem &&
                          issue.supplierId != null) ...[
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _openSupplierScorecard,
                          icon: const Icon(Icons.storefront, size: 18),
                          label: const Text('View supplier scorecard'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('History', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  for (var i = 0; i < _history.length; i++)
                    _EventTile(
                      event: _history[i],
                      isLast: i == _history.length - 1,
                      targetName: _history[i].targetUserId == null
                          ? null
                          : _staffName(_history[i].targetUserId!),
                      // "Remind" only makes sense on the escalation that's
                      // STILL the live one — a superseded historical
                      // escalation (issue has since moved on) has no one
                      // waiting on it any more.
                      canRemind:
                          widget.canManage &&
                          backendAvailable &&
                          _history[i].targetUserId != null &&
                          issue.status == IssueStatus.escalated &&
                          _history[i].targetUserId == issue.escalatedToUserId,
                      onRemind: _history[i].targetUserId == null
                          ? null
                          : () => _remind(_history[i].targetUserId!),
                      // "Reopen" only on the event that actually resolved
                      // it, and only while it's still resolved.
                      canReopen:
                          widget.canManage &&
                          _history[i].resultingStatus == IssueStatus.resolved &&
                          issue.status == IssueStatus.resolved &&
                          i == _history.length - 1,
                      onReopen: _promptReopen,
                    ),
                if (widget.canManage &&
                    issue.status != IssueStatus.resolved) ...[
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Add an update',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            labelText: 'Note',
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: _submitting
                                  ? null
                                  : () => _act(_IssueAction.addProcessNote),
                              child: const Text('Add process note'),
                            ),
                            if (issue.status != IssueStatus.escalated)
                              OutlinedButton(
                                onPressed: _submitting
                                    ? null
                                    : () => _act(_IssueAction.escalate),
                                child: const Text('Escalate'),
                              ),
                            ElevatedButton(
                              onPressed: _submitting
                                  ? null
                                  : () => _act(_IssueAction.resolve),
                              child: const Text('Resolve'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Redesign (2026-09-24) — a real timeline row instead of a loose column
// of text: a coloured dot (by what actually happened) connected by a
// line to the next entry, so History reads as one continuous record
// rather than separate floating paragraphs. Per-event actions
// (Remind/Reopen) sit inline, only shown when they're genuinely
// applicable to THAT event (see the two `can...` flags' call site for
// the exact conditions) — never decorative buttons that don't do
// anything.
class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.isLast,
    this.targetName,
    this.canRemind = false,
    this.onRemind,
    this.canReopen = false,
    this.onReopen,
  });

  final IssueEvent event;
  final bool isLast;
  final String? targetName;
  final bool canRemind;
  final VoidCallback? onRemind;
  final bool canReopen;
  final VoidCallback? onReopen;

  String get _phaseLabel => switch (event.phase) {
    IssueEventPhase.details => 'Raised',
    IssueEventPhase.process => 'Update',
    IssueEventPhase.outcome => 'Outcome',
  };

  Color get _dotColor => switch (event.resultingStatus) {
    IssueStatus.resolved => AppColors.pass,
    IssueStatus.escalated => AppColors.critical,
    IssueStatus.open when event.phase != IssueEventPhase.details =>
      AppColors.caution,
    IssueStatus.open => AppColors.teal,
  };

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.card, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: AppColors.line,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _phaseLabel,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatDateTime(event.changedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(event.note),
                  if (targetName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Sent to $targetName',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (canRemind || canReopen) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (canRemind)
                          TextButton.icon(
                            onPressed: onRemind,
                            icon: const Icon(
                              Icons.notifications_active_outlined,
                              size: 16,
                            ),
                            label: const Text('Remind'),
                          ),
                        if (canReopen)
                          TextButton.icon(
                            onPressed: onReopen,
                            icon: const Icon(Icons.replay, size: 16),
                            label: const Text('Reopen'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Same neutral-badge pattern as ProblemsRegisterScreen's own status chip —
// deliberately not colour-graded per individual (see the governing rule);
// this reflects the issue's own state, which is fine to colour, same as
// the existing Fails & Problems Register's open/resolved chip.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

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
