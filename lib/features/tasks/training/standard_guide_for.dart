import '../../../shared/models/task_template.dart';
import '../task_model.dart';
import 'task_training_guide.dart';
import 'task_training_guide_data.dart';

/// The standard guide for [task]: the hand-written one for its title when
/// there is one (every HORECA library task), otherwise a guide built from
/// the task's own setup — so a manager's custom task still gets a usable
/// "How to do this correctly" screen, never an empty one.
TaskTrainingGuide standardGuideFor(ResolvedTask task) =>
    standardTrainingGuides[task.title] ?? _buildFromTask(task);

/// The template-level view of a task, for screens that list training by
/// task rather than open one scheduled instance (My Training, Team
/// Training). Carries only what a guide and its screen need.
ResolvedTask trainingTaskFromTemplate(TaskTemplate template) => ResolvedTask(
  templateGroupId: template.templateGroupId,
  title: template.title,
  segment: template.segment,
  method: template.method,
  requiresPhoto: template.requiresPhoto,
  requiresNotes: template.requiresNotes,
  minLimit: template.minLimit,
  maxLimit: template.maxLimit,
  unit: template.unit,
  isCritical: template.isCritical,
  requiresCorrectiveActionOnFail: template.requiresCorrectiveActionOnFail,
  fixInstructions: template.fixInstructions,
  guidanceText: template.guidanceText,
  assignedByUserId: template.createdByUserId ?? 0,
);

TaskTrainingGuide _buildFromTask(ResolvedTask task) {
  final steps = <String>[];

  final guidance = task.guidanceText?.trim() ?? '';
  if (guidance.isNotEmpty) {
    steps.addAll(
      guidance
          .split(RegExp(r'(?<=[.!?])\s+'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty),
    );
  }

  if (task.hasNumericRange || task.method.contains('data')) {
    final unit = task.unit ?? '';
    if (task.minLimit != null && task.maxLimit != null) {
      steps.add(
        'Take the reading and enter it. It must be between '
        '${_num(task.minLimit!)}$unit and ${_num(task.maxLimit!)}$unit.',
      );
    } else if (task.minLimit != null) {
      steps.add(
        'Take the reading and enter it. It must be ${_num(task.minLimit!)}$unit or above.',
      );
    } else if (task.maxLimit != null) {
      steps.add(
        'Take the reading and enter it. It must be ${_num(task.maxLimit!)}$unit or below.',
      );
    } else {
      steps.add('Take the reading and enter it.');
    }
  }
  if (task.hasChoice) {
    steps.add('Pick the option that matches what you actually see.');
  }
  if (task.requiresPhoto || task.method.contains('photo')) {
    steps.add('Take a clear photo as proof.');
  }
  if (task.requiresNotes || task.method.contains('note')) {
    steps.add('Add a short note describing what you found.');
  }
  if (steps.isEmpty) {
    steps.add('Check it properly yourself. Only confirm what you have seen.');
  }
  steps.add('Mark PASS only if everything is right. Otherwise mark FAIL.');

  final fix = task.fixInstructions?.trim() ?? '';
  return TaskTrainingGuide(
    steps: steps,
    whyItMatters: task.isCritical
        ? 'This is a critical check. A failure must be put right before you carry on.'
        : null,
    ifItFails: fix.isNotEmpty
        ? fix
        : 'Tell your manager and record what you did to put it right.',
  );
}

String _num(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
