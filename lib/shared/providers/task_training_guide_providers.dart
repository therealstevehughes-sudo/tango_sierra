import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/training/task_training_guide.dart';
import '../repositories/supabase_task_training_guide_repository.dart';
import '../repositories/task_training_guide_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final taskTrainingGuideRepositoryProvider =
    Provider<TaskTrainingGuideRepository>(
      (ref) => SupabaseTaskTrainingGuideRepository(
        ref.watch(backendRestClientProvider),
      ),
    );

/// The venue's own guide for a task, or null when the standard one applies.
final venueTrainingGuideProvider = FutureProvider.autoDispose
    .family<VenueTrainingGuide?, ({int siteId, int templateGroupId})>(
      (ref, key) => ref
          .watch(taskTrainingGuideRepositoryProvider)
          .getForTask(key.siteId, key.templateGroupId),
    );
