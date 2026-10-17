import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/training/training_progress.dart';
import '../../features/tasks/training/training_service.dart';
import '../repositories/supabase_training_progress_repository.dart';
import '../repositories/task_quiz_repository.dart';
import '../repositories/training_progress_repository.dart';
import 'auth_providers.dart' show userRepositoryProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_schedule_providers.dart';
import 'task_template_providers.dart';
import 'task_training_guide_providers.dart';

final trainingProgressRepositoryProvider = Provider<TrainingProgressRepository>(
  (ref) => SupabaseTrainingProgressRepository(
    ref.watch(backendRestClientProvider),
  ),
);

final taskQuizRepositoryProvider = Provider<TaskQuizRepository>(
  (ref) => SupabaseTaskQuizRepository(ref.watch(backendRestClientProvider)),
);

final trainingServiceProvider = Provider<TrainingService>(
  (ref) => TrainingService(
    schedules: ref.watch(taskScheduleRepositoryProvider),
    templates: ref.watch(taskTemplateRepositoryProvider),
    guides: ref.watch(taskTrainingGuideRepositoryProvider),
    progress: ref.watch(trainingProgressRepositoryProvider),
    quizzes: ref.watch(taskQuizRepositoryProvider),
    users: ref.watch(userRepositoryProvider),
  ),
);

/// Which tasks at a site have a quiz (and pending AI drafts).
final quizAvailabilityProvider = FutureProvider.autoDispose
    .family<QuizAvailability, int>(
      (ref, siteId) =>
          ref.watch(taskQuizRepositoryProvider).availabilityForSite(siteId),
    );

/// The venue's refresher periods (P: 3 months critical, 6 other).
final refreshMonthsProvider = FutureProvider.autoDispose
    .family<RefreshMonths, int>(
      (ref, siteId) =>
          ref.watch(taskQuizRepositoryProvider).refreshMonths(siteId),
    );

/// userId -> training list, for everyone at [siteId].
final siteTrainingProvider = FutureProvider.autoDispose
    .family<Map<int, List<TrainingItem>>, int>(
      (ref, siteId) => ref.watch(trainingServiceProvider).forSite(siteId),
    );

/// The current worker's own acknowledgements — used by the task carousel
/// to nudge (never block) someone who hasn't read a task's guide yet.
final myAcknowledgementsProvider = FutureProvider.autoDispose
    .family<List<TrainingAcknowledgement>, int>(
      (ref, userId) => ref
          .watch(trainingProgressRepositoryProvider)
          .getAcknowledgementsForUser(userId),
    );
