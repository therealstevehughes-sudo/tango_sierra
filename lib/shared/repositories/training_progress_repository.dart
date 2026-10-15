import '../../features/tasks/training/training_progress.dart';

abstract class TrainingProgressRepository {
  Future<List<TrainingAcknowledgement>> getAcknowledgementsForSite(int siteId);

  Future<List<TrainingAcknowledgement>> getAcknowledgementsForUser(int userId);

  /// Records that [userId] read and understood [guideVersion] of a task's
  /// guide. Re-acknowledging the same version is a harmless no-op.
  Future<void> acknowledge({
    required int userId,
    required int siteId,
    required int templateGroupId,
    required String guideVersion,
  });

  Future<List<CompetenceSignoff>> getSignoffsForSite(int siteId);

  Future<void> signOff({
    required int userId,
    required int siteId,
    required int templateGroupId,
    required int signedOffByUserId,
  });

  Future<void> withdrawSignoff({
    required int userId,
    required int templateGroupId,
  });
}
