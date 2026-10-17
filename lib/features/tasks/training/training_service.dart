import '../../../shared/models/user.dart';
import '../../../shared/repositories/task_quiz_repository.dart';
import '../../../shared/repositories/task_schedule_repository.dart';
import '../../../shared/repositories/task_template_repository.dart';
import '../../../shared/repositories/task_training_guide_repository.dart';
import '../../../shared/repositories/training_progress_repository.dart';
import '../../../shared/repositories/user_repository.dart';
import 'standard_guide_for.dart';
import 'training_progress.dart';

/// Builds every person's training list at a site from what they're
/// actually assigned (active task schedules) — one load for the whole
/// site, since both My Training and Team Training need the same inputs
/// and a venue is small enough that per-person queries would only add
/// round trips.
class TrainingService {
  TrainingService({
    required TaskScheduleRepository schedules,
    required TaskTemplateRepository templates,
    required TaskTrainingGuideRepository guides,
    required TrainingProgressRepository progress,
    required TaskQuizRepository quizzes,
    required UserRepository users,
  }) : _schedules = schedules,
       _templates = templates,
       _guides = guides,
       _progress = progress,
       _quizzes = quizzes,
       _users = users;

  final TaskScheduleRepository _schedules;
  final TaskTemplateRepository _templates;
  final TaskTrainingGuideRepository _guides;
  final TrainingProgressRepository _progress;
  final TaskQuizRepository _quizzes;
  final UserRepository _users;

  /// Quiz data is an add-on to the training list: if it can't load
  /// (offline, or a server without the quiz tables), the list still shows,
  /// just without quizzes, rather than failing altogether.
  Future<T> _orElse<T>(Future<T> f, T fallback) async {
    try {
      return await f;
    } catch (_) {
      return fallback;
    }
  }

  /// userId -> that person's training items, sorted most-urgent first.
  Future<Map<int, List<TrainingItem>>> forSite(
    int siteId, {
    DateTime? now,
  }) async {
    final (schedules, templateList, guideList, acks, signoffs) = await (
      _schedules.getForSite(siteId),
      _templates.getAllCurrentVersions(),
      _guides.getForSite(siteId),
      _progress.getAcknowledgementsForSite(siteId),
      _progress.getSignoffsForSite(siteId),
    ).wait;
    final (availability, passes, months, people) = await (
      _orElse(
        _quizzes.availabilityForSite(siteId),
        const QuizAvailability.none(),
      ),
      _orElse(_quizzes.passesForSite(siteId), const <QuizPass>[]),
      _orElse(_quizzes.refreshMonths(siteId), const RefreshMonths()),
      _orElse(_users.getForSite(siteId), const <User>[]),
    ).wait;
    final tierById = {for (final u in people) u.id: u.roleTier};
    final at = now ?? DateTime.now();
    final templates = {for (final t in templateList) t.templateGroupId: t};
    final venueGuides = {for (final g in guideList) g.templateGroupId: g};

    // Distinct tasks per person — one equipment-specific schedule per
    // fridge is still one fridge-temperature guide to learn.
    final tasksByUser = <int, Set<int>>{};
    for (final s in schedules) {
      if (!s.active) continue;
      tasksByUser
          .putIfAbsent(s.assignedUserId, () => <int>{})
          .add(s.taskTemplateGroupId);
    }

    final out = <int, List<TrainingItem>>{};
    tasksByUser.forEach((userId, groupIds) {
      final items = <TrainingItem>[];
      for (final groupId in groupIds) {
        final template = templates[groupId];
        if (template == null) continue;
        final task = trainingTaskFromTemplate(template);
        final venueGuide = venueGuides[groupId];
        final guide = venueGuide?.guide ?? standardGuideFor(task);
        final userAcks = acks
            .where((a) => a.userId == userId && a.templateGroupId == groupId)
            .toList();
        final signoff = signoffs
            .where((s) => s.userId == userId && s.templateGroupId == groupId)
            .firstOrNull;
        final version = guideVersion(guide);
        final tier = tierById[userId];
        final isManager =
            tier != null &&
            roleTierRank(tier) >= roleTierRank(RoleTier.venueManager);
        final hasQuiz = availability.hasQuiz(groupId, task.title);
        final userPasses = passes
            .where((p) => p.userId == userId && p.templateGroupId == groupId)
            .toList();
        final status = trainingStatusFor(
          isCritical: task.isCritical,
          currentVersion: version,
          acknowledgements: userAcks,
          signoff: signoff,
          quizPasses: userPasses,
          quizAvailable: hasQuiz,
          isManager: isManager,
          refreshMonths: months.forTask(isCritical: task.isCritical),
          now: at,
        );
        final currentPasses = userPasses
            .where((p) => p.guideVersion == version)
            .map((p) => p.passedAt)
            .toList();
        final currentAck = userAcks
            .where((a) => a.guideVersion == version)
            .firstOrNull;
        items.add(
          TrainingItem(
            task: task,
            guide: guide,
            isVenueGuide: venueGuide != null,
            status: status,
            acknowledgedAt: currentAck?.acknowledgedAt,
            signoff: signoff,
            quizRequired: hasQuiz && (task.isCritical || !isManager),
            quizPassedAt: currentPasses.isEmpty
                ? null
                : currentPasses.reduce((a, b) => a.isAfter(b) ? a : b),
          ),
        );
      }
      items.sort(compareTrainingItems);
      out[userId] = items;
    });
    return out;
  }
}

/// Things to do first (read, quiz, refresher), then awaiting sign-off,
/// then done; critical before non-critical within each; then alphabetical.
int compareTrainingItems(TrainingItem a, TrainingItem b) {
  int rank(TrainingItem i) => switch (i.status) {
    TrainingStatus.notRead ||
    TrainingStatus.updated ||
    TrainingStatus.quizDue ||
    TrainingStatus.refresherDue => 0,
    TrainingStatus.awaitingSignoff => 1,
    TrainingStatus.read || TrainingStatus.competent => 2,
  };
  final byStatus = rank(a).compareTo(rank(b));
  if (byStatus != 0) return byStatus;
  if (a.task.isCritical != b.task.isCritical) {
    return a.task.isCritical ? -1 : 1;
  }
  return a.task.title.compareTo(b.task.title);
}
