import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/task_segment.dart';
import 'task_controller.dart';
import 'task_model.dart';
import 'task_screen.dart';
import '../../core/widgets/app_screen_header.dart';

// Hybrid task view (roadmap v1.1, built 2026-09-15; complete-from-the-list
// added 2026-09-25, direct user request). Shares the exact same
// TaskController instance as whichever TaskScreen pushed this ("the
// grouped-by-heading overview half" of the carousel session, not a
// separate session) — grouped by section so a worker isn't flying blind
// about what's ahead.
//
// Any unlocked, not-yet-done task can now be completed directly from here,
// out of the carousel's own strict order — confirmed with the user as the
// right model: the carousel stays strictly sequential and unchanged, but
// this list lets a worker knock out whatever's actually in front of them.
// See TaskController.completedTaskKeys/isCompleted's own doc comment for
// how "done" is tracked independent of currentIndex once that's possible,
// and TaskScreen's `returnToListAfterSubmit`/`existingController` for how
// a single out-of-order completion reuses the carousel's own tested
// input/camera/corrective-action UI without disturbing its position.
class TaskOverviewScreen extends StatefulWidget {
  const TaskOverviewScreen({super.key, required this.controller});

  final TaskController controller;

  @override
  State<TaskOverviewScreen> createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  TaskController get controller => widget.controller;

  // Complete-from-the-list: temporarily repoints the shared controller's
  // currentIndex at the tapped task so TaskScreen's own unchanged
  // getCurrentTask()/submitTask() logic just works, then restores it
  // afterward regardless of outcome — the carousel underneath must never
  // see its own position move because of a detour taken from here.
  Future<void> _completeTask(int index) async {
    final originalIndex = controller.currentIndex;
    controller.currentIndex = index;
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskScreen(
            existingController: controller,
            returnToListAfterSubmit: true,
          ),
        ),
      );
    } finally {
      controller.currentIndex = originalIndex;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = controller.tasks;
    final grouped = <String, List<int>>{};
    for (var i = 0; i < tasks.length; i++) {
      grouped.putIfAbsent(tasks[i].segment, () => []).add(i);
    }

    return Scaffold(
      appBar: AppScreenHeader(
        title: const Text('All Tasks'),
        actions: const [AssistantIconButton()],
      ),
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final entry in grouped.entries) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key.isEmpty ? 'Other' : segmentDisplayName(entry.key),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final index in entry.value)
                _TaskRow(
                  task: tasks[index],
                  status: _statusFor(index),
                  onTap: _canComplete(index)
                      ? () => _completeTask(index)
                      : null,
                ),
            ],
          ],
        ),
      ),
    );
  }

  bool _canComplete(int index) {
    final task = controller.tasks[index];
    return !controller.isCompleted(task) && !task.isLocked;
  }

  _RowStatus _statusFor(int index) {
    final task = controller.tasks[index];
    if (controller.isCompleted(task)) return _RowStatus.done;
    if (task.isLocked) return _RowStatus.locked;
    if (index == controller.currentIndex) return _RowStatus.current;
    return _RowStatus.pending;
  }
}

enum _RowStatus { done, current, locked, pending }

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.status, this.onTap});

  final ResolvedTask task;
  final _RowStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (status) {
      _RowStatus.done => (Icons.check_circle, AppColors.pass),
      _RowStatus.current => (Icons.arrow_circle_right, AppColors.teal),
      _RowStatus.locked => (Icons.lock_outline, AppColors.mutedLight),
      _RowStatus.pending => (
        Icons.radio_button_unchecked,
        AppColors.mutedLight,
      ),
    };
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.displayTitle,
                  style: status == _RowStatus.pending
                      ? Theme.of(context).textTheme.bodyMedium
                      : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.mutedLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
