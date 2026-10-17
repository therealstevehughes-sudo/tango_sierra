import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/friendly_error.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/load_error_view.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/user.dart';
import '../../../shared/providers/auth_providers.dart';
import '../../../shared/providers/site_providers.dart';
import '../../../shared/providers/training_progress_providers.dart';
import '../../../shared/repositories/task_quiz_repository.dart';
import 'task_training_guide_screen.dart';
import 'training_progress.dart';

// Training section (2026-10-15, founder-approved). My Training is every
// staff member's own list; Team Training is the supervisor+ view of who's
// trained on what, where venueManager+ also gives the "watched them do
// it" competence sign-off on critical tasks.

/// The site whose training a screen should show: the site a manager has
/// set active, else the person's own.
int? _trainingSiteId(WidgetRef ref) =>
    ref.watch(activeSiteProvider)?.id ?? ref.watch(currentUserProvider)?.siteId;

class MyTrainingScreen extends ConsumerWidget {
  const MyTrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final siteId = user?.siteId;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.myTrainingTitle)),
      body: user == null || siteId == null
          ? Center(child: Text(l10n.trainingEmpty))
          : ref
                .watch(siteTrainingProvider(siteId))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => LoadErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(siteTrainingProvider(siteId)),
                  ),
                  data: (bySite) => _TrainingList(
                    items: bySite[user.id] ?? const [],
                    emptyText: l10n.trainingEmpty,
                    onTap: (item) => _openGuide(context, item),
                  ),
                ),
    );
  }
}

class TeamTrainingScreen extends ConsumerWidget {
  const TeamTrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final siteId = _trainingSiteId(ref);
    if (siteId == null) {
      return Scaffold(
        appBar: AppScreenHeader(title: Text(l10n.teamTrainingTitle)),
        body: Center(child: Text(l10n.trainingTeamEmpty)),
      );
    }
    final training = ref.watch(siteTrainingProvider(siteId));
    final staff = ref.watch(_siteStaffProvider(siteId));
    final viewer = ref.watch(currentUserProvider);
    final isManager =
        viewer != null &&
        roleTierRank(viewer.roleTier) >= roleTierRank(RoleTier.venueManager);
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.teamTrainingTitle),
        actions: [
          if (isManager)
            IconButton(
              tooltip: l10n.trainingRefresherSettingsTitle,
              icon: const Icon(Icons.update),
              onPressed: () => _editRefreshers(context, ref, siteId),
            ),
        ],
      ),
      body: switch ((training, staff)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
          LoadErrorView(
            error: error,
            onRetry: () {
              ref.invalidate(siteTrainingProvider(siteId));
              ref.invalidate(_siteStaffProvider(siteId));
            },
          ),
        (AsyncData(value: final bySite), AsyncData(value: final people)) =>
          _TeamList(siteId: siteId, bySite: bySite, people: people),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// P (2026-10-17): the venue chooses its refresher periods.
Future<void> _editRefreshers(
  BuildContext context,
  WidgetRef ref,
  int siteId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repo = ref.read(taskQuizRepositoryProvider);
  RefreshMonths current;
  try {
    current = await repo.refreshMonths(siteId);
  } catch (_) {
    current = const RefreshMonths();
  }
  if (!context.mounted) return;
  var critical = current.critical;
  var other = current.other;
  const choices = [1, 2, 3, 6, 9, 12, 18, 24];
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        DropdownButtonFormField<int> picker(
          String label,
          int value,
          ValueChanged<int> onChanged,
        ) => DropdownButtonFormField<int>(
          initialValue: choices.contains(value) ? value : null,
          decoration: InputDecoration(labelText: label),
          items: [
            for (final m in choices)
              DropdownMenuItem(value: m, child: Text(l10n.monthsCount(m))),
          ],
          onChanged: (v) {
            if (v != null) setState(() => onChanged(v));
          },
        );
        return AlertDialog(
          title: Text(l10n.trainingRefresherSettingsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.trainingRefresherSettingsHelp),
              const SizedBox(height: 12),
              picker(
                l10n.trainingRefresherCriticalLabel,
                critical,
                (v) => critical = v,
              ),
              const SizedBox(height: 8),
              picker(l10n.trainingRefresherOtherLabel, other, (v) => other = v),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    ),
  );
  if (saved != true) return;
  try {
    await repo.setRefreshMonths(
      siteId,
      RefreshMonths(critical: critical, other: other),
    );
    ref.invalidate(siteTrainingProvider(siteId));
    ref.invalidate(refreshMonthsProvider(siteId));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.trainingRefresherSaved)));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
  }
}

final _siteStaffProvider = FutureProvider.autoDispose.family<List<User>, int>(
  (ref, siteId) => ref.watch(userRepositoryProvider).getForSite(siteId),
);

class _TeamList extends StatelessWidget {
  const _TeamList({
    required this.siteId,
    required this.bySite,
    required this.people,
  });

  final int siteId;
  final Map<int, List<TrainingItem>> bySite;
  final List<User> people;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final withTraining =
        people.where((p) => p.active && bySite.containsKey(p.id)).toList()
          ..sort((a, b) {
            // Most to do first, so the gaps are at the top.
            int open(User u) => bySite[u.id]!.where((i) => !i.isComplete).length;
            final byOpen = open(b).compareTo(open(a));
            return byOpen != 0 ? byOpen : a.name.compareTo(b.name);
          });
    if (withTraining.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.trainingTeamEmpty, textAlign: TextAlign.center),
        ),
      );
    }
    return ResponsiveContent(
      maxWidth: 640,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: withTraining.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final person = withTraining[index];
          final items = bySite[person.id]!;
          final done = items.where((i) => i.isComplete).length;
          final toRead = items.where((i) => i.needsReading).length;
          final quizzes = items
              .where(
                (i) =>
                    i.status == TrainingStatus.quizDue ||
                    i.status == TrainingStatus.refresherDue,
              )
              .length;
          final awaiting = items
              .where((i) => i.status == TrainingStatus.awaitingSignoff)
              .length;
          return AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(person.name),
              subtitle: Text(
                [
                  l10n.trainingProgressSummary(done, items.length),
                  if (toRead > 0) l10n.trainingToReadCount(toRead),
                  if (quizzes > 0) l10n.trainingQuizToDoCount(quizzes),
                  if (awaiting > 0) l10n.trainingAwaitingCount(awaiting),
                ].join(' · '),
              ),
              trailing: isFullyTrained(items)
                  ? const _FullyTrainedBadge()
                  : _ProgressRing(done: done, total: items.length),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      StaffTrainingScreen(siteId: siteId, person: person),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One staff member's training, as seen by a supervisor or manager.
class StaffTrainingScreen extends ConsumerWidget {
  const StaffTrainingScreen({
    super.key,
    required this.siteId,
    required this.person,
  });

  final int siteId;
  final User person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final viewer = ref.watch(currentUserProvider);
    final canSignOff =
        viewer != null &&
        viewer.id != person.id &&
        roleTierRank(viewer.roleTier) >= roleTierRank(RoleTier.venueManager);
    return Scaffold(
      appBar: AppScreenHeader(title: Text(person.name)),
      body: ref
          .watch(siteTrainingProvider(siteId))
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadErrorView(
              error: e,
              onRetry: () => ref.invalidate(siteTrainingProvider(siteId)),
            ),
            data: (bySite) => _TrainingList(
              items: bySite[person.id] ?? const [],
              emptyText: l10n.trainingEmpty,
              onTap: (item) => _openGuide(context, item),
              actionFor: !canSignOff
                  ? null
                  : (item) => _signOffAction(context, ref, item, viewer),
            ),
          ),
    );
  }

  Widget? _signOffAction(
    BuildContext context,
    WidgetRef ref,
    TrainingItem item,
    User viewer,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (!item.task.isCritical) return null;
    if (item.signoff != null) {
      return TextButton(
        onPressed: () => _run(
          context,
          ref,
          () => ref
              .read(trainingProgressRepositoryProvider)
              .withdrawSignoff(
                userId: person.id,
                templateGroupId: item.task.templateGroupId,
              ),
        ),
        child: Text(l10n.trainingWithdrawSignoff),
      );
    }
    return FilledButton.tonal(
      onPressed: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.trainingSignOffButton),
            content: Text(
              l10n.trainingSignOffConfirm(person.name, item.task.title),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.trainingSignOffButton),
              ),
            ],
          ),
        );
        if (ok != true || !context.mounted) return;
        await _run(
          context,
          ref,
          () => ref
              .read(trainingProgressRepositoryProvider)
              .signOff(
                userId: person.id,
                siteId: siteId,
                templateGroupId: item.task.templateGroupId,
                signedOffByUserId: viewer.id,
              ),
        );
      },
      child: Text(l10n.trainingSignOffButton),
    );
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await action();
      ref.invalidate(siteTrainingProvider(siteId));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    }
  }
}

void _openGuide(BuildContext context, TrainingItem item) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TaskTrainingGuideScreen(task: item.task),
      ),
    );

class _TrainingList extends StatelessWidget {
  const _TrainingList({
    required this.items,
    required this.emptyText,
    required this.onTap,
    this.actionFor,
  });

  final List<TrainingItem> items;
  final String emptyText;
  final void Function(TrainingItem) onTap;
  final Widget? Function(TrainingItem)? actionFor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyText, textAlign: TextAlign.center),
        ),
      );
    }
    final done = items.where((i) => i.isComplete).length;
    return ResponsiveContent(
      maxWidth: 640,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _ProgressRing(done: done, total: items.length),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.trainingProgressSummary(done, items.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (isFullyTrained(items)) const _FullyTrainedBadge(),
            ],
          ),
          const SizedBox(height: 16),
          for (final item in items) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.task.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _StatusChip(item: item),
                          if (item.task.isCritical)
                            _Chip(
                              label: l10n.trainingCriticalLabel,
                              fg: AppColors.critical,
                              bg: AppColors.criticalBg,
                            ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onTap(item),
                  ),
                  if (actionFor?.call(item) case final action?)
                    Align(alignment: Alignment.centerRight, child: action),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.item});

  final TrainingItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (item.status) {
      TrainingStatus.notRead => _Chip(
        label: l10n.trainingStatusNotRead,
        fg: AppColors.caution,
        bg: AppColors.cautionBg,
      ),
      TrainingStatus.updated => _Chip(
        label: l10n.trainingStatusUpdated,
        fg: AppColors.caution,
        bg: AppColors.cautionBg,
      ),
      TrainingStatus.quizDue => _Chip(
        label: l10n.trainingStatusQuizDue,
        fg: AppColors.caution,
        bg: AppColors.cautionBg,
      ),
      TrainingStatus.refresherDue => _Chip(
        label: l10n.trainingStatusRefresherDue,
        fg: AppColors.caution,
        bg: AppColors.cautionBg,
      ),
      TrainingStatus.read => _Chip(
        label: item.quizPassedAt != null
            ? l10n.trainingStatusTrained
            : l10n.trainingStatusRead,
        fg: AppColors.pass,
        bg: AppColors.passBg,
      ),
      TrainingStatus.awaitingSignoff => _Chip(
        label: l10n.trainingStatusAwaitingSignoff,
        fg: AppColors.info,
        bg: AppColors.infoBg,
      ),
      TrainingStatus.competent => _Chip(
        label: l10n.trainingSignedOffOn(formatDate(item.signoff!.signedOffAt)),
        fg: AppColors.pass,
        bg: AppColors.passBg,
      ),
    };
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.fg, required this.bg});

  final String label;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );
}

class _FullyTrainedBadge extends StatelessWidget {
  const _FullyTrainedBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified, color: AppColors.pass, size: 22),
        const SizedBox(width: 4),
        Text(
          l10n.trainingFullyTrained,
          style: const TextStyle(
            color: AppColors.pass,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36,
    height: 36,
    child: CircularProgressIndicator(
      value: total == 0 ? 0 : done / total,
      strokeWidth: 4,
      backgroundColor: AppColors.line,
      color: done == total ? AppColors.pass : AppColors.teal,
    ),
  );
}
