import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../shared/models/issue.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/issue_providers.dart';

// PART 2 of the branch-hub build (2026-09-15) — where Process/Outcome
// handling happens. Any staff member can OPEN this (to see the full
// Details -> Process -> Outcome history of something they or a colleague
// raised), but adding a note/resolving/escalating is gated to
// supervisor+ by [canManage] (passed from the register tab, which knows
// the caller's tier) — raising is open to everyone, handling flows up to
// managers, per the governing spec.
enum _IssueAction { addProcessNote, escalate, resolve }

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

  Future<void> _load() async {
    final history = await ref
        .read(issueRepositoryProvider)
        .getHistory(widget.issue.id);
    if (!mounted) return;
    setState(() {
      _history = history;
      _loading = false;
    });
  }

  Future<void> _act(_IssueAction action) async {
    final currentUser = ref.read(currentUserProvider);
    final note = _noteController.text.trim();
    if (currentUser == null || note.isEmpty) return;
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
          );
        case _IssueAction.resolve:
          await repo.resolve(
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

  @override
  Widget build(BuildContext context) {
    final issue = widget.issue;
    return Scaffold(
      appBar: AppBar(title: Text(issueTypeDisplayName(issue.type))),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                issue.subtype ?? issueTypeDisplayName(issue.type),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ..._history.map((e) => _EventTile(event: e)),
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
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final IssueEvent event;

  String get _phaseLabel => switch (event.phase) {
    IssueEventPhase.details => 'Raised',
    IssueEventPhase.process => 'Update',
    IssueEventPhase.outcome => 'Outcome',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _phaseLabel,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
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
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        issueStatusDisplayName(status),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
