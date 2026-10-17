import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/friendly_error.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/training_progress_providers.dart';
import '../../../shared/repositories/task_quiz_repository.dart';
import '../task_model.dart';

/// How a quiz visit ended, for the guide screen underneath.
enum QuizOutcome { passed, failed, rereadNeeded }

/// Training quiz (2026-10-17, founder-approved): three questions on the
/// task's guide, all on one page. All three right = the green tick. The
/// server picks and shuffles the questions and marks the answers; a retry
/// needs the guide read again first.
class TaskQuizScreen extends ConsumerStatefulWidget {
  const TaskQuizScreen({
    super.key,
    required this.task,
    required this.siteId,
    required this.userId,
    required this.guideVersion,
  });

  final ResolvedTask task;
  final int siteId;
  final int userId;
  final String guideVersion;

  @override
  ConsumerState<TaskQuizScreen> createState() => _TaskQuizScreenState();
}

class _TaskQuizScreenState extends ConsumerState<TaskQuizScreen> {
  bool _loading = true;
  bool _submitting = false;
  bool _rereadNeeded = false;
  Object? _error;
  QuizAttempt? _attempt;
  final Map<int, int> _answers = {};
  QuizResult? _result;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final attempt = await ref
          .read(taskQuizRepositoryProvider)
          .start(
            siteId: widget.siteId,
            templateGroupId: widget.task.templateGroupId,
            taskTitle: widget.task.title,
            guideVersion: widget.guideVersion,
            userId: widget.userId,
          );
      if (!mounted) return;
      setState(() {
        _attempt = attempt;
        _loading = false;
      });
    } on QuizRereadRequired {
      if (!mounted) return;
      setState(() {
        _rereadNeeded = true;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    final attempt = _attempt!;
    setState(() => _submitting = true);
    try {
      final result = await ref
          .read(taskQuizRepositoryProvider)
          .submit(
            attemptId: attempt.attemptId,
            answers: [for (final q in attempt.questions) _answers[q.number]!],
          );
      ref.invalidate(siteTrainingProvider(widget.siteId));
      if (!mounted) return;
      setState(() => _result = result);
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_outcome);
      },
      child: Scaffold(
        appBar: AppScreenHeader(title: Text(l10n.quizTitle)),
        body: ResponsiveContent(maxWidth: 560, child: _body(l10n)),
      ),
    );
  }

  QuizOutcome? get _outcome => _rereadNeeded
      ? QuizOutcome.rereadNeeded
      : switch (_result) {
          null => null,
          final r when r.passed => QuizOutcome.passed,
          _ => QuizOutcome.failed,
        };

  Widget _body(AppLocalizations l10n) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_rereadNeeded) {
      return _Message(
        icon: Icons.menu_book_outlined,
        color: AppColors.caution,
        title: l10n.quizRereadFirst,
        buttonLabel: l10n.quizBackToGuide,
        onPressed: () => Navigator.of(context).pop(QuizOutcome.rereadNeeded),
      );
    }
    if (_error != null) {
      return _Message(
        icon: Icons.error_outline,
        color: AppColors.critical,
        title: friendlyErrorMessage(l10n, _error!),
        buttonLabel: l10n.retryLabel,
        onPressed: _start,
      );
    }
    final attempt = _attempt;
    if (attempt == null) {
      return _Message(
        icon: Icons.quiz_outlined,
        color: AppColors.muted,
        title: l10n.quizNoneYet,
        buttonLabel: l10n.quizBackToGuide,
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    final result = _result;
    if (result != null) {
      return result.passed
          ? _Message(
              icon: Icons.check_circle,
              color: AppColors.pass,
              title: l10n.quizPassedTitle,
              body: widget.task.isCritical
                  ? l10n.quizPassedAwaitingSignoff
                  : l10n.quizPassedBody,
              buttonLabel: l10n.quizBackToGuide,
              onPressed: () => Navigator.of(context).pop(QuizOutcome.passed),
            )
          : _Message(
              icon: Icons.replay,
              color: AppColors.caution,
              title: l10n.quizFailedTitle(result.correct, result.total),
              body: l10n.quizFailedBody,
              buttonLabel: l10n.quizBackToGuide,
              onPressed: () => Navigator.of(context).pop(QuizOutcome.failed),
            );
    }

    final total = attempt.questions.length;
    final allAnswered = attempt.questions.every(
      (q) => _answers.containsKey(q.number),
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.task.displayTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(l10n.quizIntro, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 16),
        for (final q in attempt.questions) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quizQuestionLabel(q.number, total),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(q.text, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                RadioGroup<int>(
                  groupValue: _answers[q.number],
                  onChanged: (v) {
                    if (v != null) setState(() => _answers[q.number] = v);
                  },
                  // Own Material so the tap ripple shows inside the card.
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        for (var i = 0; i < q.options.length; i++)
                          RadioListTile<int>(
                            value: i,
                            contentPadding: EdgeInsets.zero,
                            title: Text(q.options[i]),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        FilledButton(
          onPressed: allAnswered && !_submitting ? _submit : null,
          child: Text(l10n.quizSubmitButton),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.color,
    required this.title,
    required this.buttonLabel,
    required this.onPressed,
    this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? body;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(body!, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 24),
          FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
        ],
      ),
    ),
  );
}
