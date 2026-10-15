import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/friendly_error.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/user.dart';
import '../../../shared/providers/auth_providers.dart';
import '../../../shared/providers/task_training_guide_providers.dart';
import '../../../shared/providers/training_progress_providers.dart';
import '../task_model.dart';
import 'standard_guide_for.dart';
import 'task_training_guide.dart';
import 'task_training_guide_edit_screen.dart';
import 'training_progress.dart';

/// "How to do this correctly" — opened from the task carousel. Shows the
/// venue's own version of the guide when a manager has customised it,
/// otherwise the standard one. If the venue version can't be loaded (no
/// connection), the standard guide still shows — a worker mid-task should
/// never hit a dead end here.
class TaskTrainingGuideScreen extends ConsumerWidget {
  const TaskTrainingGuideScreen({super.key, required this.task});

  final ResolvedTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final siteId = user?.siteId;
    final canEdit =
        user != null &&
        siteId != null &&
        roleTierRank(user.roleTier) >= roleTierRank(RoleTier.venueManager);

    final key = siteId == null
        ? null
        : (siteId: siteId, templateGroupId: task.templateGroupId);
    final venueAsync = key == null
        ? const AsyncValue<VenueTrainingGuide?>.data(null)
        : ref.watch(venueTrainingGuideProvider(key));

    final venueGuide = venueAsync.value;
    final guide = venueGuide?.guide ?? standardGuideFor(task);

    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.trainingGuideTitle)),
      body: ResponsiveContent(
        maxWidth: 560,
        child: venueAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    task.displayTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  _SourcePill(
                    label: venueGuide != null
                        ? l10n.trainingGuideVenueVersion
                        : l10n.trainingGuideStandardVersion,
                    custom: venueGuide != null,
                  ),
                  if (venueAsync.hasError) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.trainingGuideVenueLoadFailed,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  AppCard(
                    elevated: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.trainingGuideStepsHeading,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        for (var i = 0; i < guide.steps.length; i++)
                          _StepRow(number: i + 1, text: guide.steps[i]),
                      ],
                    ),
                  ),
                  if (guide.whyItMatters != null) ...[
                    const SizedBox(height: 16),
                    AppBanner(
                      kind: BannerKind.info,
                      child: _LabelledText(
                        label: l10n.trainingGuideWhyHeading,
                        text: guide.whyItMatters!,
                      ),
                    ),
                  ],
                  if (guide.ifItFails != null) ...[
                    const SizedBox(height: 12),
                    AppBanner(
                      kind: BannerKind.caution,
                      child: _LabelledText(
                        label: l10n.trainingGuideIfFailsHeading,
                        text: guide.ifItFails!,
                      ),
                    ),
                  ],
                  // Training section (2026-10-15): the worker's own
                  // "read and understood" record for exactly this version
                  // of the guide. Hidden if the venue version failed to
                  // load — acknowledging the standard text when the venue
                  // has its own would record the wrong thing.
                  if (user != null && siteId != null && !venueAsync.hasError)
                    _AcknowledgeSection(
                      userId: user.id,
                      siteId: siteId,
                      templateGroupId: task.templateGroupId,
                      version: guideVersion(guide),
                    ),
                  if (canEdit) ...[
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.trainingGuideEditButton),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TaskTrainingGuideEditScreen(
                            task: task,
                            siteId: siteId,
                            userId: user.id,
                            initial: guide,
                          ),
                        ),
                      ),
                    ),
                    if (venueGuide != null)
                      TextButton(
                        onPressed: () => _resetToStandard(context, ref, key!),
                        child: Text(l10n.trainingGuideResetButton),
                      ),
                  ],
                ],
              ),
      ),
    );
  }

  Future<void> _resetToStandard(
    BuildContext context,
    WidgetRef ref,
    ({int siteId, int templateGroupId}) key,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.trainingGuideResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.trainingGuideResetButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(taskTrainingGuideRepositoryProvider)
          .resetToStandard(key.siteId, key.templateGroupId);
      ref.invalidate(venueTrainingGuideProvider(key));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(l10n, e))),
      );
    }
  }
}

class _AcknowledgeSection extends ConsumerStatefulWidget {
  const _AcknowledgeSection({
    required this.userId,
    required this.siteId,
    required this.templateGroupId,
    required this.version,
  });

  final int userId;
  final int siteId;
  final int templateGroupId;
  final String version;

  @override
  ConsumerState<_AcknowledgeSection> createState() =>
      _AcknowledgeSectionState();
}

class _AcknowledgeSectionState extends ConsumerState<_AcknowledgeSection> {
  bool _saving = false;

  Future<void> _acknowledge() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await ref
          .read(trainingProgressRepositoryProvider)
          .acknowledge(
            userId: widget.userId,
            siteId: widget.siteId,
            templateGroupId: widget.templateGroupId,
            guideVersion: widget.version,
          );
      ref.invalidate(myAcknowledgementsProvider(widget.userId));
      ref.invalidate(siteTrainingProvider(widget.siteId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final acks = ref.watch(myAcknowledgementsProvider(widget.userId));
    // Can't tell (offline / not deployed) — say nothing rather than offer
    // a button that may fail or claim a status we don't know.
    if (!acks.hasValue) return const SizedBox.shrink();
    final current = acks.value!
        .where(
          (a) =>
              a.templateGroupId == widget.templateGroupId &&
              a.guideVersion == widget.version,
        )
        .firstOrNull;
    final readOlder = acks.value!.any(
      (a) => a.templateGroupId == widget.templateGroupId,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: current != null
          ? Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.pass),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.trainingReadOn(formatDate(current.acknowledgedAt)),
                    style: const TextStyle(color: AppColors.pass),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (readOlder)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.trainingGuideChangedNotice,
                      style: const TextStyle(color: AppColors.caution),
                    ),
                  ),
                FilledButton.icon(
                  icon: const Icon(Icons.task_alt),
                  label: Text(l10n.trainingAcknowledgeButton),
                  onPressed: _saving ? null : _acknowledge,
                ),
              ],
            ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.teal,
            child: Text(
              '$number',
              style: const TextStyle(
                color: AppColors.onTeal,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelledText extends StatelessWidget {
  const _LabelledText({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(text),
      ],
    );
  }
}

/// Says whose version this is — the standard guide, or one the venue
/// changed — so a worker trained elsewhere knows why it differs.
class _SourcePill extends StatelessWidget {
  const _SourcePill({required this.label, required this.custom});

  final String label;
  final bool custom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: custom ? AppColors.standbyBg : AppColors.tealTint,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: custom ? AppColors.standby : AppColors.tealInk,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
