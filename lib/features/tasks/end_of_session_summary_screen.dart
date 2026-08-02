import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        .where((u) => u.roleTier == RoleTier.mid || u.roleTier == RoleTier.top)
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
                Text(
                  'Tasks completed: $total',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pass: ${widget.stats.passCount}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fail: ${widget.stats.failCount}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.stats.failedTaskTitles.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Triggers / Failed tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...widget.stats.failedTaskTitles.map(
                    (title) => Text('• $title'),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Send this summary to a manager (optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Leave a note for the next shift (optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: handoverNoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Handover note'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _finish, child: const Text('Done')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
