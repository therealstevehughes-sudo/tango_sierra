import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/auth_providers.dart';
import '../../../shared/providers/task_training_guide_providers.dart';
import '../../../shared/providers/training_progress_providers.dart';
import '../task_model.dart';
import 'standard_guide_for.dart';
import 'task_training_guide_screen.dart';
import 'training_progress.dart';

/// The carousel's "How to do this correctly" button. When the worker
/// hasn't read the current version of this task's guide it gets louder —
/// a tonal button plus a one-line nudge — but never blocks the task:
/// stopping someone mid-shift means the check doesn't get done at all,
/// which is worse than the gap (founder-approved, 2026-10-15). While the
/// read status is unknown (loading, offline) it stays the plain button.
class TrainingGuideButton extends ConsumerWidget {
  const TrainingGuideButton({super.key, required this.task});

  final ResolvedTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final siteId = user?.siteId;

    var notRead = false;
    if (user != null && siteId != null) {
      final venue = ref.watch(
        venueTrainingGuideProvider((
          siteId: siteId,
          templateGroupId: task.templateGroupId,
        )),
      );
      final acks = ref.watch(myAcknowledgementsProvider(user.id));
      if (venue.hasValue && acks.hasValue) {
        final version = guideVersion(
          venue.value?.guide ?? standardGuideFor(task),
        );
        notRead = !acks.value!.any(
          (a) =>
              a.templateGroupId == task.templateGroupId &&
              a.guideVersion == version,
        );
      }
    }

    void open() => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TaskTrainingGuideScreen(task: task),
      ),
    );

    if (!notRead) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(Icons.school_outlined),
          label: Text(l10n.trainingGuideButton),
          onPressed: open,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonalIcon(
          icon: const Icon(Icons.school_outlined),
          label: Text(l10n.trainingGuideButton),
          onPressed: open,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.trainingNotReadNudge,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.caution),
        ),
      ],
    );
  }
}
