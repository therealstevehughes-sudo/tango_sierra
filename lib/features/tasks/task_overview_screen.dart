import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import 'task_controller.dart';
import 'task_model.dart';

// Hybrid task view (roadmap v1.1, built 2026-09-15) — the carousel stays
// exactly as it is (one task at a time, strictly in order; the Staff Task
// Screen Rule's minimalism and the sequential completion model are both
// unchanged). This is the "grouped-by-heading overview" half: a read-only
// look at everything in the session grouped by section, so a worker isn't
// flying blind about what's ahead. Deliberately does NOT let a worker jump
// to or reorder tasks from here — completion still only ever happens
// through the carousel, in the order it was assigned.
class TaskOverviewScreen extends StatelessWidget {
  const TaskOverviewScreen({super.key, required this.controller});

  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    final tasks = controller.tasks;
    final grouped = <String, List<int>>{};
    for (var i = 0; i < tasks.length; i++) {
      grouped.putIfAbsent(tasks[i].segment, () => []).add(i);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final entry in grouped.entries) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key.isEmpty ? 'Other' : entry.key,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final index in entry.value)
                _TaskRow(
                  task: tasks[index],
                  status: index < controller.currentIndex
                      ? _RowStatus.done
                      : index == controller.currentIndex
                      ? _RowStatus.current
                      : _RowStatus.pending,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _RowStatus { done, current, pending }

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.status});

  final ResolvedTask task;
  final _RowStatus status;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (status) {
      _RowStatus.done => (Icons.check_circle, AppColors.pass),
      _RowStatus.current => (Icons.arrow_circle_right, AppColors.teal),
      _RowStatus.pending => (
        Icons.radio_button_unchecked,
        AppColors.mutedLight,
      ),
    };
    return AppCard(
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
        ],
      ),
    );
  }
}
