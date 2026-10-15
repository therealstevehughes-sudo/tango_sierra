import '../../features/tasks/training/task_training_guide.dart';

abstract class TaskTrainingGuideRepository {
  /// The venue's own guide for [templateGroupId] at [siteId], or null when
  /// the venue hasn't customised it (the standard guide applies).
  Future<VenueTrainingGuide?> getForTask(int siteId, int templateGroupId);

  /// Every guide this venue has customised — for the training lists, which
  /// need the guide each person should have read for many tasks at once.
  Future<List<VenueTrainingGuide>> getForSite(int siteId);

  /// Saves (creates or replaces) the venue's own version of the guide.
  Future<void> save({
    required int siteId,
    required int templateGroupId,
    required TaskTrainingGuide guide,
    required int updatedByUserId,
  });

  /// Removes the venue's version so the standard guide applies again.
  Future<void> resetToStandard(int siteId, int templateGroupId);
}
