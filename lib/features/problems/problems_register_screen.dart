import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/repositories/problem_register_repository.dart';

// Fails & Problems Register (Part A) — a first-class screen at every
// leadership tier (drawer-gated at supervisor, same floor as Dashboard).
// Deliberately never date-bounded (see ProblemFilter's own doc comment):
// the whole point is that nothing here can silently age out of sight.
//
// Scoped to the logged-in user's own site for now — regional/executive
// only have one siteId today, same as everyone else, since there's no
// Region/cross-venue data model yet (see Part C1). This screen will widen
// its scope once that lands; it isn't a limitation specific to this
// screen, it's the whole app's current single-site-per-user reality.
class ProblemsRegisterScreen extends ConsumerStatefulWidget {
  const ProblemsRegisterScreen({super.key});

  @override
  ConsumerState<ProblemsRegisterScreen> createState() =>
      _ProblemsRegisterScreenState();
}

class _ProblemsRegisterScreenState
    extends ConsumerState<ProblemsRegisterScreen> {
  ProblemFilter _filter = ProblemFilter.all;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final repository = ref.watch(problemRegisterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fails & Problems Register')),
      drawer: const ManagementDrawer(title: 'Fails & Problems Register'),
      body: currentUser == null
          ? const SizedBox.shrink()
          : ResponsiveContent(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: SegmentedButton<ProblemFilter>(
                    segments: const [
                      ButtonSegment(
                        value: ProblemFilter.all,
                        label: Text('All'),
                      ),
                      ButtonSegment(
                        value: ProblemFilter.fail,
                        label: Text('Fail'),
                      ),
                      ButtonSegment(
                        value: ProblemFilter.reported,
                        label: Text('Reported'),
                      ),
                      ButtonSegment(
                        value: ProblemFilter.notCompleted,
                        label: Text('Not Completed'),
                      ),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (selection) =>
                        setState(() => _filter = selection.first),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<TaskSubmission>>(
                    stream: repository.watchForSite(
                      currentUser.siteId!,
                      filter: _filter,
                    ),
                    builder: (context, snapshot) {
                      final entries = snapshot.data ?? [];
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (entries.isEmpty) {
                        return const Center(
                          child: Text('Nothing here — that\'s a good sign.'),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => _ProblemTile(
                          submission: entries[index],
                          currentUserId: currentUser.id,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _ProblemTile extends ConsumerWidget {
  const _ProblemTile({required this.submission, required this.currentUserId});

  final TaskSubmission submission;
  final int currentUserId;

  String get _correctiveLabel => switch (submission.correctiveActionOutcome) {
    'fixed' => 'I fixed it',
    'reported' => 'Reported to manager',
    _ => submission.status == 'NOT_COMPLETED' ? 'Abandoned' : 'No action taken',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isResolved = submission.problemStatus == 'resolved';
    final repository = ref.read(problemRegisterRepositoryProvider);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (submission.status == 'NOT_COMPLETED')
            const StatusBadge(kind: StatusKind.overdue, label: 'Not Completed')
          else
            const StatusBadge(kind: StatusKind.critical, label: 'Fail'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instance-name prominence (2026-09-06): leads on its own
                // bold line — this register exists precisely to make a
                // problem unmissable, so "which fridge" can't be the part
                // that's easy to skim past.
                if (submission.equipmentInstanceName != null)
                  Text(
                    submission.equipmentInstanceName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.teal,
                    ),
                  ),
                Text(
                  submission.taskTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${submission.completedBy} · '
                  '${formatDateTime(submission.completedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _correctiveLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (submission.correctiveActionNote != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    submission.correctiveActionNote!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ProblemStatusChip(resolved: isResolved),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  if (submission.id == null) return;
                  if (isResolved) {
                    await repository.reopen(
                      taskSubmissionId: submission.id!,
                      byUserId: currentUserId,
                    );
                  } else {
                    await repository.resolve(
                      taskSubmissionId: submission.id!,
                      byUserId: currentUserId,
                    );
                  }
                },
                child: Text(isResolved ? 'Reopen' : 'Mark Resolved'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Deliberately its own small widget, not StatusBadge/MetricChip — this is
// a genuinely different graded state (open/resolved) from either of those
// two, and reusing one would blur what it means (StatusBadge's colours are
// already spoken for by the fail/not-completed badge next to this one).
class _ProblemStatusChip extends StatelessWidget {
  const _ProblemStatusChip({required this.resolved});

  final bool resolved;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData icon, String label) = resolved
        ? (AppColors.pass, AppColors.passBg, Icons.check_circle_outline, 'Resolved')
        : (AppColors.ink, AppColors.line, Icons.radio_button_unchecked, 'Open');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
