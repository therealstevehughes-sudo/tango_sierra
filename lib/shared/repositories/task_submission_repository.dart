import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/task_submission.dart';

abstract class TaskSubmissionRepository {
  Future<int> submit(TaskSubmission submission);
  Future<List<TaskSubmission>> getAll();
  Future<List<TaskSubmission>> getByStaff(String staffId);
  Future<List<TaskSubmission>> getByDateRange(DateTime start, DateTime end);
  Future<List<TaskSubmission>> getForUserSince(int userId, DateTime since);
  Stream<List<TaskSubmission>> watchAll();

  // Manager log filtering (Sprint 031) — the log becomes an unusable wall
  // at real scale (30 staff x 150 tasks x days), so ManagerScreen no longer
  // defaults to watchAll(). Default view: today's entries, plus every
  // FAIL regardless of date, since FAILs must never silently age out of a
  // compliance view (PASS is the volume that's safe to bound to today).
  Stream<List<TaskSubmission>> watchDefaultView();

  // Cascading filter option lookups, each optionally scoped by whichever
  // other dimension(s) are already selected — one generic method per
  // dimension serves all three "Filter by" modes (Name/Date/Task), rather
  // than nine mode-specific methods.
  Future<List<String>> getDistinctNames({DateTime? date, String? task});
  Future<List<DateTime>> getDistinctDates({String? name, String? task});
  Future<List<String>> getDistinctTasks({String? name, DateTime? date});

  // The actual filtered result once one or more dimensions are chosen.
  Stream<List<TaskSubmission>> watchFiltered({
    String? name,
    DateTime? date,
    String? task,
  });

  // Due/overdue tracking (Sprint 031, Build Order item 5) — how many
  // PASS/FAIL submissions a schedule has within [start, end). NOT_COMPLETED
  // (Sub-sprint B) deliberately doesn't count: an abandoned task must not
  // satisfy its period, or it would wrongly stop showing as due/overdue
  // when the worker returns.
  Future<int> countForScheduleInRange({
    required int taskScheduleId,
    required DateTime start,
    required DateTime end,
  });

  // EHO/audit export (Sprint 031) — properly site-scoped using the real
  // siteId column, same approach Sub-sprint D established for the overdue
  // summary, not the older unscoped-reads gap logged elsewhere in the app.
  Future<List<TaskSubmission>> getForSiteAndDateRange({
    required int siteId,
    required DateTime start,
    required DateTime end,
  });
}

class DriftTaskSubmissionRepository implements TaskSubmissionRepository {
  DriftTaskSubmissionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<int> submit(TaskSubmission submission) {
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
            correctiveActionOutcome: Value(submission.correctiveActionOutcome),
            correctiveActionNote: Value(submission.correctiveActionNote),
            supplierId: Value(submission.supplierId),
            problemStatus: Value(submission.problemStatus),
            equipmentInstanceName: Value(submission.equipmentInstanceName),
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
  Future<List<TaskSubmission>> getForSiteAndDateRange({
    required int siteId,
    required DateTime start,
    required DateTime end,
  }) async {
    final query = _db.select(_db.taskSubmissions)
      ..where(
        (t) =>
            t.siteId.equals(siteId) & t.completedAt.isBetweenValues(start, end),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.completedAt)]);
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

  @override
  Stream<List<TaskSubmission>> watchDefaultView() {
    final startOfToday = _startOfDay(DateTime.now());
    final endOfToday = startOfToday.add(const Duration(days: 1));
    final query = _db.select(_db.taskSubmissions)
      ..where(
        (t) =>
            (t.completedAt.isBiggerOrEqualValue(startOfToday) &
                t.completedAt.isSmallerThanValue(endOfToday)) |
            t.status.equals('FAIL'),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Stream<List<TaskSubmission>> watchFiltered({
    String? name,
    DateTime? date,
    String? task,
  }) {
    final query = _db.select(_db.taskSubmissions)
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    if (name != null) {
      query.where((t) => t.completedBy.equals(name));
    }
    if (date != null) {
      final start = _startOfDay(date);
      final end = start.add(const Duration(days: 1));
      query.where(
        (t) =>
            t.completedAt.isBiggerOrEqualValue(start) &
            t.completedAt.isSmallerThanValue(end),
      );
    }
    if (task != null) {
      query.where((t) => t.taskTitle.equals(task));
    }
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Future<List<String>> getDistinctNames({DateTime? date, String? task}) async {
    final query = _db.selectOnly(_db.taskSubmissions, distinct: true)
      ..addColumns([_db.taskSubmissions.completedBy]);
    _applyDateAndTaskScope(query, date: date, task: task);
    final rows = await query.get();
    final names = rows
        .map((row) => row.read(_db.taskSubmissions.completedBy)!)
        .toList();
    names.sort();
    return names;
  }

  @override
  Future<List<String>> getDistinctTasks({String? name, DateTime? date}) async {
    final query = _db.selectOnly(_db.taskSubmissions, distinct: true)
      ..addColumns([_db.taskSubmissions.taskTitle]);
    if (name != null) {
      query.where(_db.taskSubmissions.completedBy.equals(name));
    }
    if (date != null) {
      final start = _startOfDay(date);
      final end = start.add(const Duration(days: 1));
      query.where(
        _db.taskSubmissions.completedAt.isBiggerOrEqualValue(start) &
            _db.taskSubmissions.completedAt.isSmallerThanValue(end),
      );
    }
    final rows = await query.get();
    final tasks = rows
        .map((row) => row.read(_db.taskSubmissions.taskTitle)!)
        .toList();
    tasks.sort();
    return tasks;
  }

  @override
  Future<List<DateTime>> getDistinctDates({String? name, String? task}) async {
    // Unlike name/task, a calendar day isn't a stored column value — two
    // submissions on the same day still have different completedAt
    // timestamps, so SQL-level DISTINCT can't dedupe them. Fetches just
    // the completedAt column (not full rows) for whatever scope is given,
    // then truncates and dedupes to calendar days in Dart. When neither
    // name nor task narrows it (the root of "Filter by Date"), this scans
    // one column across the whole table — still far lighter than the
    // full-row watchAll() this replaces, and the distinct-day result set
    // itself stays small (bounded by real calendar time, not submission
    // volume).
    final query = _db.selectOnly(_db.taskSubmissions)
      ..addColumns([_db.taskSubmissions.completedAt]);
    if (name != null) {
      query.where(_db.taskSubmissions.completedBy.equals(name));
    }
    if (task != null) {
      query.where(_db.taskSubmissions.taskTitle.equals(task));
    }
    final rows = await query.get();
    final days = rows
        .map((row) => _startOfDay(row.read(_db.taskSubmissions.completedAt)!))
        .toSet()
        .toList();
    days.sort((a, b) => b.compareTo(a));
    return days;
  }

  void _applyDateAndTaskScope(
    JoinedSelectStatement query, {
    DateTime? date,
    String? task,
  }) {
    if (date != null) {
      final start = _startOfDay(date);
      final end = start.add(const Duration(days: 1));
      query.where(
        _db.taskSubmissions.completedAt.isBiggerOrEqualValue(start) &
            _db.taskSubmissions.completedAt.isSmallerThanValue(end),
      );
    }
    if (task != null) {
      query.where(_db.taskSubmissions.taskTitle.equals(task));
    }
  }

  DateTime _startOfDay(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  @override
  Future<int> countForScheduleInRange({
    required int taskScheduleId,
    required DateTime start,
    required DateTime end,
  }) async {
    final query = _db.selectOnly(_db.taskSubmissions)
      ..addColumns([_db.taskSubmissions.id.count()])
      ..where(
        _db.taskSubmissions.taskScheduleId.equals(taskScheduleId) &
            _db.taskSubmissions.completedAt.isBiggerOrEqualValue(start) &
            _db.taskSubmissions.completedAt.isSmallerThanValue(end) &
            _db.taskSubmissions.status.isIn(const ['PASS', 'FAIL']),
      );
    final row = await query.getSingle();
    return row.read(_db.taskSubmissions.id.count()) ?? 0;
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
}
