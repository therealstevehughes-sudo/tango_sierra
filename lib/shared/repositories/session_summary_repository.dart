import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/session_summary.dart';

abstract class SessionSummaryRepository {
  Future<SessionSummary> create({
    required int staffUserId,
    required String staffName,
    required int sentToManagerId,
    required int passCount,
    required int failCount,
    required List<String> failedTaskTitles,
    String? note,
    required int siteId,
  });
  Stream<List<SessionSummary>> watchForManager(int managerId);
  Future<void> acknowledge(int id);
}

class DriftSessionSummaryRepository implements SessionSummaryRepository {
  DriftSessionSummaryRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SessionSummary> create({
    required int staffUserId,
    required String staffName,
    required int sentToManagerId,
    required int passCount,
    required int failCount,
    required List<String> failedTaskTitles,
    String? note,
    required int siteId,
  }) async {
    final id = await _db
        .into(_db.sessionSummaries)
        .insert(
          SessionSummariesCompanion.insert(
            staffUserId: staffUserId,
            staffName: staffName,
            sentToManagerId: sentToManagerId,
            passCount: passCount,
            failCount: failCount,
            failedTaskTitlesJson: jsonEncode(failedTaskTitles),
            note: Value(note),
            sentAt: DateTime.now(),
            siteId: Value(siteId),
          ),
        );
    final row = await (_db.select(
      _db.sessionSummaries,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Stream<List<SessionSummary>> watchForManager(int managerId) {
    final query = _db.select(_db.sessionSummaries)
      ..where((t) => t.sentToManagerId.equals(managerId))
      ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Future<void> acknowledge(int id) async {
    await (_db.update(_db.sessionSummaries)..where((t) => t.id.equals(id)))
        .write(
          SessionSummariesCompanion(
            acknowledged: const Value(true),
            acknowledgedAt: Value(DateTime.now()),
          ),
        );
  }

  SessionSummary _toModel(SessionSummaryEntity row) {
    final decoded = jsonDecode(row.failedTaskTitlesJson);
    final titles = decoded is List
        ? List<String>.from(decoded)
        : <String>[];

    return SessionSummary(
      id: row.id,
      staffUserId: row.staffUserId,
      staffName: row.staffName,
      sentToManagerId: row.sentToManagerId,
      passCount: row.passCount,
      failCount: row.failCount,
      failedTaskTitles: titles,
      note: row.note,
      sentAt: row.sentAt,
      acknowledged: row.acknowledged,
      acknowledgedAt: row.acknowledgedAt,
      siteId: row.siteId!,
    );
  }
}
