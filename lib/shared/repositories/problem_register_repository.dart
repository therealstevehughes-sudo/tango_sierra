import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/problem_status_event.dart';
import '../models/task_submission.dart';

// Fails & Problems Register (Part A) — deliberately never date-bounded.
// Every fail/reported/abandoned task stays visible until someone explicitly
// resolves it, no matter how old — the whole point of this register is that
// nothing here can silently age out of sight the way a plain log view might.
enum ProblemFilter { all, fail, reported, notCompleted }

abstract class ProblemRegisterRepository {
  Stream<List<TaskSubmission>> watchForSite(
    int siteId, {
    ProblemFilter filter = ProblemFilter.all,
  });
  Future<List<ProblemStatusEvent>> getHistory(int taskSubmissionId);
  Future<void> resolve({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  });
  Future<void> reopen({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  });
  // Called once, automatically, right after a submission is saved — never
  // a silent edit, but also never something a UI action triggers directly
  // (see TaskController). Idempotent-in-intent: only ever called once per
  // submission, immediately after it's created.
  Future<void> initialize({
    required int taskSubmissionId,
    required ProblemStatus status,
    required int byUserId,
  });
}

class DriftProblemRegisterRepository implements ProblemRegisterRepository {
  DriftProblemRegisterRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TaskSubmission>> watchForSite(
    int siteId, {
    ProblemFilter filter = ProblemFilter.all,
  }) {
    final query = _db.select(_db.taskSubmissions)
      ..where((t) => t.siteId.equals(siteId))
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);

    switch (filter) {
      case ProblemFilter.all:
        query.where((t) => t.status.isIn(const ['FAIL', 'NOT_COMPLETED']));
      case ProblemFilter.fail:
        query.where((t) => t.status.equals('FAIL'));
      case ProblemFilter.reported:
        query.where(
          (t) =>
              t.status.equals('FAIL') &
              t.correctiveActionOutcome.equals('reported'),
        );
      case ProblemFilter.notCompleted:
        query.where((t) => t.status.equals('NOT_COMPLETED'));
    }

    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Future<List<ProblemStatusEvent>> getHistory(int taskSubmissionId) async {
    final query = _db.select(_db.problemStatusEvents)
      ..where((e) => e.taskSubmissionId.equals(taskSubmissionId))
      ..orderBy([(e) => OrderingTerm.asc(e.changedAt)]);
    final rows = await query.get();
    return rows.map(_toEventModel).toList();
  }

  @override
  Future<void> resolve({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: ProblemStatus.resolved,
    byUserId: byUserId,
    note: note,
  );

  @override
  Future<void> reopen({
    required int taskSubmissionId,
    required int byUserId,
    String? note,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: ProblemStatus.open,
    byUserId: byUserId,
    note: note,
  );

  @override
  Future<void> initialize({
    required int taskSubmissionId,
    required ProblemStatus status,
    required int byUserId,
  }) => _recordStatusChange(
    taskSubmissionId: taskSubmissionId,
    status: status,
    byUserId: byUserId,
    note: null,
  );

  Future<void> _recordStatusChange({
    required int taskSubmissionId,
    required ProblemStatus status,
    required int byUserId,
    String? note,
  }) async {
    final statusString = status.name;
    await _db.transaction(() async {
      await _db
          .into(_db.problemStatusEvents)
          .insert(
            ProblemStatusEventsCompanion.insert(
              taskSubmissionId: taskSubmissionId,
              status: statusString,
              changedByUserId: byUserId,
              changedAt: DateTime.now(),
              note: Value(note),
            ),
          );
      await (_db.update(
        _db.taskSubmissions,
      )..where((t) => t.id.equals(taskSubmissionId))).write(
        TaskSubmissionsCompanion(problemStatus: Value(statusString)),
      );
    });
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
      correctiveActionOutcome: row.correctiveActionOutcome,
      correctiveActionNote: row.correctiveActionNote,
      supplierId: row.supplierId,
      problemStatus: row.problemStatus,
      equipmentInstanceName: row.equipmentInstanceName,
    );
  }

  ProblemStatusEvent _toEventModel(ProblemStatusEventEntity row) {
    return ProblemStatusEvent(
      id: row.id,
      taskSubmissionId: row.taskSubmissionId,
      status: ProblemStatus.values.byName(row.status),
      changedByUserId: row.changedByUserId,
      changedAt: row.changedAt,
      note: row.note,
    );
  }
}
