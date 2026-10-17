import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/friendly_error.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/task_training_guide_providers.dart';
import '../task_model.dart';
import 'task_training_guide.dart';
import 'task_quiz_questions_screen.dart';

/// Venue manager edits this site's version of a task's guide — different
/// venues have different kit and house rules (direct founder request,
/// 2026-10-15). Starts from whatever is currently showing (standard or the
/// venue's existing version), so a small tweak never means retyping.
class TaskTrainingGuideEditScreen extends ConsumerStatefulWidget {
  const TaskTrainingGuideEditScreen({
    super.key,
    required this.task,
    required this.siteId,
    required this.userId,
    required this.initial,
  });

  final ResolvedTask task;
  final int siteId;
  final int userId;
  final TaskTrainingGuide initial;

  @override
  ConsumerState<TaskTrainingGuideEditScreen> createState() =>
      _TaskTrainingGuideEditScreenState();
}

class _TaskTrainingGuideEditScreenState
    extends ConsumerState<TaskTrainingGuideEditScreen> {
  late final List<TextEditingController> _steps;
  late final TextEditingController _why;
  late final TextEditingController _ifFails;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _steps = widget.initial.steps
        .map((s) => TextEditingController(text: s))
        .toList();
    if (_steps.isEmpty) _steps.add(TextEditingController());
    _why = TextEditingController(text: widget.initial.whyItMatters ?? '');
    _ifFails = TextEditingController(text: widget.initial.ifItFails ?? '');
  }

  @override
  void dispose() {
    for (final c in _steps) {
      c.dispose();
    }
    _why.dispose();
    _ifFails.dispose();
    super.dispose();
  }

  void _move(int from, int to) {
    setState(() {
      final c = _steps.removeAt(from);
      _steps.insert(to, c);
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final steps = _steps
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (steps.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.trainingGuideNeedsStep)));
      return;
    }
    setState(() => _saving = true);
    final guide = TaskTrainingGuide(
      steps: steps,
      whyItMatters: _why.text.trim().isEmpty ? null : _why.text.trim(),
      ifItFails: _ifFails.text.trim().isEmpty ? null : _ifFails.text.trim(),
    );
    try {
      await ref
          .read(taskTrainingGuideRepositoryProvider)
          .save(
            siteId: widget.siteId,
            templateGroupId: widget.task.templateGroupId,
            guide: guide,
            updatedByUserId: widget.userId,
          );
      ref.invalidate(
        venueTrainingGuideProvider((
          siteId: widget.siteId,
          templateGroupId: widget.task.templateGroupId,
        )),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.trainingGuideSaved)));
      // R (2026-10-17): a changed guide needs matching quiz questions.
      // VenuRite's AI drafts them; a manager approves before staff see them.
      final draft = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l10n.quizRedraftPrompt),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.quizLaterButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.quizDraftNowButton),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (draft == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => TaskQuizQuestionsScreen(
              task: widget.task,
              siteId: widget.siteId,
              userId: widget.userId,
              guide: guide,
              draftOnOpen: true,
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.trainingGuideEditButton)),
      body: ResponsiveContent(
        maxWidth: 560,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.task.displayTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.trainingGuideStepsHeading,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _steps[i],
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: l10n.trainingGuideStepLabel(i + 1),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: l10n.trainingGuideMoveUp,
                          icon: const Icon(Icons.arrow_upward, size: 20),
                          onPressed: i == 0 ? null : () => _move(i, i - 1),
                        ),
                        IconButton(
                          tooltip: l10n.trainingGuideMoveDown,
                          icon: const Icon(Icons.arrow_downward, size: 20),
                          onPressed: i == _steps.length - 1
                              ? null
                              : () => _move(i, i + 1),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: l10n.trainingGuideRemoveStep,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _steps.length == 1
                          ? null
                          : () => setState(() => _steps.removeAt(i).dispose()),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.trainingGuideAddStep),
                onPressed: () =>
                    setState(() => _steps.add(TextEditingController())),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _why,
              maxLines: null,
              decoration: InputDecoration(
                labelText: l10n.trainingGuideWhyHeading,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ifFails,
              maxLines: null,
              decoration: InputDecoration(
                labelText: l10n.trainingGuideIfFailsHeading,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.saveButton),
            ),
          ],
        ),
      ),
    );
  }
}
