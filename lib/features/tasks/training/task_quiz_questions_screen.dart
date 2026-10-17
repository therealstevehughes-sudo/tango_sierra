import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/friendly_error.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/training_progress_providers.dart';
import '../../../shared/repositories/task_quiz_repository.dart';
import '../task_model.dart';
import 'task_training_guide.dart';
import 'training_progress.dart';

/// A manager's view of a task's quiz (2026-10-17, founder-approved R):
/// which questions are in use, and VenuRite's AI drafts for this venue's
/// own guide or task, which only go live once approved here.
class TaskQuizQuestionsScreen extends ConsumerStatefulWidget {
  const TaskQuizQuestionsScreen({
    super.key,
    required this.task,
    required this.siteId,
    required this.userId,
    required this.guide,
    this.draftOnOpen = false,
  });

  final ResolvedTask task;
  final int siteId;
  final int userId;

  /// The guide as staff see it now — what any new questions are drafted from.
  final TaskTrainingGuide guide;
  final bool draftOnOpen;

  @override
  ConsumerState<TaskQuizQuestionsScreen> createState() =>
      _TaskQuizQuestionsScreenState();
}

class _TaskQuizQuestionsScreenState
    extends ConsumerState<TaskQuizQuestionsScreen> {
  bool _loading = true;
  bool _busy = false;
  Object? _error;
  List<VenueQuizQuestion> _venue = const [];
  QuizAvailability _availability = const QuizAvailability.none();
  final Set<int> _keep = {};

  int get _groupId => widget.task.templateGroupId;
  List<VenueQuizQuestion> get _pending =>
      _venue.where((q) => q.isPending).toList();
  List<VenueQuizQuestion> get _live =>
      _venue.where((q) => !q.isPending).toList();

  @override
  void initState() {
    super.initState();
    _load().then((_) {
      if (widget.draftOnOpen && mounted) _draft();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = ref.read(taskQuizRepositoryProvider);
    try {
      final (venue, availability) = await (
        repo.venueQuestions(siteId: widget.siteId, templateGroupId: _groupId),
        repo.availabilityForSite(widget.siteId),
      ).wait;
      if (!mounted) return;
      setState(() {
        _venue = venue;
        _availability = availability;
        _keep
          ..clear()
          ..addAll(venue.where((q) => q.isPending).map((q) => q.id));
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

  Future<void> _run(Future<void> Function() action, {String? done}) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(quizAvailabilityProvider(widget.siteId));
      ref.invalidate(siteTrainingProvider(widget.siteId));
      await _load();
      if (!mounted || done == null) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _draft() => _run(
    () => ref
        .read(taskQuizRepositoryProvider)
        .draftVenueQuestions(
          siteId: widget.siteId,
          templateGroupId: _groupId,
          taskTitle: widget.task.title,
          guide: widget.guide,
          guideVersion: guideVersion(widget.guide),
        ),
  );

  Future<void> _decide({required bool approve}) {
    final l10n = AppLocalizations.of(context)!;
    if (approve && _keep.length < 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.quizKeepAtLeast3)));
      return Future.value();
    }
    return _run(
      () => ref
          .read(taskQuizRepositoryProvider)
          .decideDrafts(
            siteId: widget.siteId,
            templateGroupId: _groupId,
            approve: approve,
            keepIds: approve ? _keep.toList() : null,
            userId: widget.userId,
          ),
      done: approve ? l10n.quizApproved : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.quizQuestionsButton)),
      body: ResponsiveContent(
        maxWidth: 640,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(friendlyErrorMessage(l10n, _error!)),
                ),
              )
            : _content(l10n),
      ),
    );
  }

  Widget _content(AppLocalizations l10n) {
    final live = _live;
    final pending = _pending;
    final standardCount = _availability.standardByTitle[widget.task.title] ?? 0;
    final String inUse;
    if (live.isNotEmpty) {
      inUse = l10n.quizUsingVenue(live.length);
    } else if (standardCount >= 3) {
      inUse = l10n.quizUsingStandard(standardCount);
    } else {
      inUse = l10n.quizNoQuestions;
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.task.displayTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        AppBanner(kind: BannerKind.info, child: Text(inUse)),
        const SizedBox(height: 16),
        if (_busy) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(l10n.quizDrafting, textAlign: TextAlign.center),
          const SizedBox(height: 16),
        ],
        if (pending.isNotEmpty) ...[
          Text(
            l10n.quizPendingHeading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.quizPendingHelp,
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          for (final q in pending)
            _QuestionCard(
              question: q,
              kept: _keep.contains(q.id),
              onKeptChanged: _busy
                  ? null
                  : (v) => setState(
                      () => v ? _keep.add(q.id) : _keep.remove(q.id),
                    ),
            ),
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.check),
            label: Text(l10n.quizApproveButton),
            onPressed: _busy ? null : () => _decide(approve: true),
          ),
          TextButton(
            onPressed: _busy ? null : () => _decide(approve: false),
            child: Text(l10n.quizRejectButton),
          ),
          const SizedBox(height: 16),
        ],
        OutlinedButton.icon(
          icon: const Icon(Icons.auto_awesome),
          label: Text(l10n.quizDraftButton),
          onPressed: _busy ? null : _draft,
        ),
        if (live.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            l10n.quizLiveHeading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final q in live) _QuestionCard(question: q),
        ],
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    this.kept,
    this.onKeptChanged,
  });

  final VenueQuizQuestion question;
  final bool? kept;
  final ValueChanged<bool>? onKeptChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kept != null)
            Checkbox(
              value: kept,
              onChanged: onKeptChanged == null
                  ? null
                  : (v) => onKeptChanged!(v ?? false),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                for (var i = 0; i < question.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          i == 0 ? Icons.check_circle : Icons.cancel_outlined,
                          size: 16,
                          color: i == 0 ? AppColors.pass : AppColors.mutedLight,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(question.options[i])),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
