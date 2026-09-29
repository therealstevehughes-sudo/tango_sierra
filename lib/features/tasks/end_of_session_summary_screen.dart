import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/metric_chip.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/voice_note_field.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../dashboard/reliability_service.dart';
import '../../l10n/app_localizations.dart';
import 'task_model.dart';
import '../../core/widgets/app_screen_header.dart';

class EndOfSessionSummaryScreen extends ConsumerStatefulWidget {
  const EndOfSessionSummaryScreen({super.key, required this.stats});

  final SessionStats stats;

  @override
  ConsumerState<EndOfSessionSummaryScreen> createState() =>
      _EndOfSessionSummaryScreenState();
}

class _EndOfSessionSummaryScreenState
    extends ConsumerState<EndOfSessionSummaryScreen> {
  bool loadingManagers = true;
  List<User> managers = [];
  int? selectedManagerId;
  bool sent = false;

  bool loadingReliability = true;
  ReliabilitySummary? reliability;

  final TextEditingController summaryNoteController = TextEditingController();
  final TextEditingController handoverNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadManagers();
    _loadReliability();
  }

  @override
  void dispose() {
    summaryNoteController.dispose();
    handoverNoteController.dispose();
    super.dispose();
  }

  Future<void> _loadManagers() async {
    final userRepo = ref.read(userRepositoryProvider);
    final currentUser = ref.read(currentUserProvider);
    final all = currentUser?.siteId == null
        ? const <User>[]
        : await userRepo.getForSite(currentUser!.siteId!);
    final managerList = all.where((u) => u.roleTier != RoleTier.base).toList();

    if (!mounted) return;
    setState(() {
      managers = managerList;
      loadingManagers = false;
    });
  }

  Future<void> _loadReliability() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      setState(() => loadingReliability = false);
      return;
    }
    final service = ref.read(reliabilityServiceProvider);
    final summary = await service.computeForUser(currentUser.id);

    if (!mounted) return;
    setState(() {
      reliability = summary;
      loadingReliability = false;
    });
  }

  Future<void> _sendToManager() async {
    if (selectedManagerId == null) return;
    final currentUser = ref.read(currentUserProvider)!;
    final repo = ref.read(sessionSummaryRepositoryProvider);

    await repo.create(
      staffUserId: currentUser.id,
      staffName: '${currentUser.name} (${currentUser.jobTitle})',
      sentToManagerId: selectedManagerId!,
      passCount: widget.stats.passCount,
      failCount: widget.stats.failCount,
      failedTaskTitles: widget.stats.failedTaskTitles,
      note: summaryNoteController.text.trim().isEmpty
          ? null
          : summaryNoteController.text.trim(),
      siteId: currentUser.siteId!,
    );

    if (!mounted) return;
    setState(() => sent = true);
  }

  Future<void> _finish() async {
    final note = handoverNoteController.text.trim();
    if (note.isNotEmpty) {
      final currentUser = ref.read(currentUserProvider)!;
      final repo = ref.read(shiftHandoverRepositoryProvider);
      await repo.create(
        authorUserId: currentUser.id,
        note: note,
        siteId: currentUser.siteId!,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.stats.passCount + widget.stats.failCount;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.sessionSummaryTitle),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 560,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visual/UX pass, Sub-sprint 3: the glanceable pass/fail
                  // summary — the one thing this screen must communicate at a
                  // glance — grouped in an AppCard; colour is never the only
                  // signal (StatusBadge pairs it with an icon and a word).
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tasksCompletedCount(total),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        // Improvement (2026-09-12): the pass/fail summary is
                        // now glanceable — a large icon + number pair in the
                        // status colour, with the smallest possible word
                        // label. A tired worker at the end of a shift reads
                        // "big green check, big number" without parsing
                        // prose. Colour is still never the only signal
                        // (icon + word always present).
                        Row(
                          children: [
                            Expanded(
                              child: _BigCount(
                                icon: Icons.check_circle,
                                color: AppColors.pass,
                                count: widget.stats.passCount,
                                label: l10n.passedLabel,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _BigCount(
                                icon: Icons.cancel,
                                color: AppColors.critical,
                                count: widget.stats.failCount,
                                label: l10n.failedLabel,
                              ),
                            ),
                          ],
                        ),
                        if (widget.stats.failedTaskTitles.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          SectionHeader(title: l10n.triggersFailedTasks),
                          ...widget.stats.failedTaskTitles.map(
                            (title) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.cancel_outlined,
                                    size: 16,
                                    color: AppColors.critical,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(title)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!loadingReliability &&
                      reliability != null &&
                      reliability!.totalPeriods > 0) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.yourReliability),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.reliabilityExplanation,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              MetricChip(
                                icon: Icons.check_circle_outline,
                                label: l10n.completedPercentChip(
                                  (reliability!.completionRate! * 100).round(),
                                ),
                              ),
                              MetricChip(
                                icon: Icons.schedule,
                                label: l10n.onTimePercentChip(
                                  (reliability!.onTimeRate! * 100).round(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SectionHeader(title: l10n.sendSummaryToManager),
                  const SizedBox(height: 8),
                  if (loadingManagers)
                    const Center(child: CircularProgressIndicator())
                  else if (managers.isEmpty)
                    Text(l10n.noManagersSetUp)
                  else ...[
                    DropdownButtonFormField<int>(
                      initialValue: selectedManagerId,
                      decoration: InputDecoration(
                        labelText: l10n.managerLabel,
                      ),
                      items: managers
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.id,
                              child: Text('${m.name} (${m.jobTitle})'),
                            ),
                          )
                          .toList(),
                      onChanged: sent
                          ? null
                          : (value) =>
                                setState(() => selectedManagerId = value),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: summaryNoteController,
                      enabled: !sent,
                      decoration: InputDecoration(
                        labelText: l10n.noteOptionalLabel,
                        suffixIcon: sent
                            ? null
                            : VoiceNoteMicButton(
                                controller: summaryNoteController,
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: (sent || selectedManagerId == null)
                          ? null
                          : _sendToManager,
                      child: Text(sent ? l10n.sentLabel : l10n.sendLabel),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SectionHeader(title: l10n.leaveNoteForNextShift),
                  const SizedBox(height: 8),
                  TextField(
                    controller: handoverNoteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.handoverNoteLabel,
                      suffixIcon: VoiceNoteMicButton(
                        controller: handoverNoteController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryActionButton(label: l10n.doneLabel, onPressed: _finish),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Improvement (2026-09-12): a large, glanceable count for the session
// summary — icon + big number + a minimal word. Colour is never the only
// signal (DESIGN_SYSTEM_LOCK's Accessibility Rule); the number carries the
// meaning, the word disambiguates, the colour reinforces. This is the
// at-a-glance "how did my shift go" display.
class _BigCount extends StatelessWidget {
  const _BigCount({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
