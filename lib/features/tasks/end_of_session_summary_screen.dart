import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import 'task_model.dart';

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

  final TextEditingController summaryNoteController = TextEditingController();
  final TextEditingController handoverNoteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadManagers();
  }

  @override
  void dispose() {
    summaryNoteController.dispose();
    handoverNoteController.dispose();
    super.dispose();
  }

  Future<void> _loadManagers() async {
    final userRepo = ref.read(userRepositoryProvider);
    final all = await userRepo.getAll();
    final managerList = all
        .where((u) => u.roleTier != RoleTier.base)
        .toList();

    if (!mounted) return;
    setState(() {
      managers = managerList;
      loadingManagers = false;
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
      siteId: currentUser.siteId,
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
        siteId: currentUser.siteId,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.stats.passCount + widget.stats.failCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Session Summary')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        'Tasks completed: $total',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusBadge(
                            kind: StatusKind.pass,
                            label: 'Pass: ${widget.stats.passCount}',
                          ),
                          StatusBadge(
                            kind: StatusKind.critical,
                            label: 'Fail: ${widget.stats.failCount}',
                          ),
                        ],
                      ),
                      if (widget.stats.failedTaskTitles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const SectionHeader(title: 'Triggers / Failed tasks'),
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
                const SizedBox(height: 24),
                const SectionHeader(title: 'Send this summary to a manager (optional)'),
                const SizedBox(height: 8),
                if (loadingManagers)
                  const Center(child: CircularProgressIndicator())
                else if (managers.isEmpty)
                  const Text('No managers set up yet.')
                else ...[
                  DropdownButtonFormField<int>(
                    initialValue: selectedManagerId,
                    decoration: const InputDecoration(labelText: 'Manager'),
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
                        : (value) => setState(() => selectedManagerId = value),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: summaryNoteController,
                    enabled: !sent,
                    decoration: const InputDecoration(
                      labelText: 'Note (optional)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: (sent || selectedManagerId == null)
                        ? null
                        : _sendToManager,
                    child: Text(sent ? 'Sent' : 'Send'),
                  ),
                ],
                const SizedBox(height: 24),
                const SectionHeader(title: 'Leave a note for the next shift (optional)'),
                const SizedBox(height: 8),
                TextField(
                  controller: handoverNoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Handover note'),
                ),
                const SizedBox(height: 24),
                PrimaryActionButton(label: 'Done', onPressed: _finish),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
