import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/task_submission.dart';

abstract class TaskSubmissionRepository {
  Future<void> submit(TaskSubmission submission);
  Future<List<TaskSubmission>> getAll();
  Future<List<TaskSubmission>> getByStaff(String staffId);
  Future<List<TaskSubmission>> getByDateRange(DateTime start, DateTime end);
  Future<List<TaskSubmission>> getForUserSince(int userId, DateTime since);
  Stream<List<TaskSubmission>> watchAll();
}

class DriftTaskSubmissionRepository implements TaskSubmissionRepository {
  DriftTaskSubmissionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> submit(TaskSubmission submission) {
    return _db
        .into(_db.taskSubmissions)
        .insert(
          TaskSubmissionsCompanion.insert(
            taskTitle: submission.taskTitle,
            status: submission.status,
            completedBy: submission.completedBy,
            completedAt: submission.completedAt,
            numericValue: Value(submission.numericValue),
            photoAttached: Value(submission.photoAttached),
            photoPath: Value(submission.photoPath),
            notes: Value(submission.notes),
            taskScheduleId: Value(submission.taskScheduleId),
            taskTemplateGroupId: Value(submission.taskTemplateGroupId),
            equipmentInstanceId: Value(submission.equipmentInstanceId),
            customFieldValuesJson: Value(submission.customFieldValuesJson),
            completedByUserId: Value(submission.completedByUserId),
            siteId: Value(submission.siteId),
          ),
        );
  }

  @override
  Future<List<TaskSubmission>> getAll() async {
    final query = _db.select(_db.taskSubmissions)
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSubmission>> getByStaff(String staffId) async {
    final query = _db.select(_db.taskSubmissions)
      ..where((t) => t.completedBy.equals(staffId))
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSubmission>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = _db.select(_db.taskSubmissions)
      ..where((t) => t.completedAt.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TaskSubmission>> getForUserSince(
    int userId,
    DateTime since,
  ) async {
    final query = _db.select(_db.taskSubmissions)
      ..where(
        (t) =>
            t.completedByUserId.equals(userId) &
            t.completedAt.isBiggerOrEqualValue(since),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Stream<List<TaskSubmission>> watchAll() {
    final query = _db.select(_db.taskSubmissions)
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  TaskSubmission _toModel(TaskSubmissionEntity row) {
    return TaskSubmission(
      id: row.id,
      taskTitle: row.taskTitle,
      status: row.status,
      completedBy: row.completedBy,
      completedAt: row.completedAt,
      numericValue: row.numericValue,
      photoAttached: row.photoAttached,
      photoPath: row.photoPath,
      notes: row.notes,
      taskScheduleId: row.taskScheduleId,
      taskTemplateGroupId: row.taskTemplateGroupId,
      equipmentInstanceId: row.equipmentInstanceId,
      customFieldValuesJson: row.customFieldValuesJson,
      completedByUserId: row.completedByUserId,
      siteId: row.siteId!,
    );
  }
}
