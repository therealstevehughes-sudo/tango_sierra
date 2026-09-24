import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/shift_log.dart';

// Shift log (2026-09-24) — local-only, like SessionSummaryRepository's own
// doc comment pattern for site-scoped operational logs that don't need
// backend sync for this first pass. See ShiftLog's own doc comment for
// why this is deliberately a habit-tracking signal, not a payroll record.
abstract class ShiftLogRepository {
  Future<ShiftLog> clockIn({required int userId, int? siteId});
  Future<void> clockOut(int shiftLogId);
  // The most recent shift log for this user that has no clockOutAt yet —
  // used to find "the shift currently in progress" without the caller
  // needing to track the id itself across screens.
  Future<ShiftLog?> getOpenShift(int userId);
  Future<List<ShiftLog>> getRecentForSite(int siteId, {int limit = 50});
}

class DriftShiftLogRepository implements ShiftLogRepository {
  DriftShiftLogRepository(this._db);

  final AppDatabase _db;

  @override
  Future<ShiftLog> clockIn({required int userId, int? siteId}) async {
    final id = await _db
        .into(_db.shiftLogs)
        .insert(
          ShiftLogsCompanion.insert(
            userId: userId,
            siteId: Value(siteId),
            clockInAt: DateTime.now(),
          ),
        );
    final row = await (_db.select(
      _db.shiftLogs,
    )..where((s) => s.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> clockOut(int shiftLogId) {
    return (_db.update(_db.shiftLogs)..where((s) => s.id.equals(shiftLogId)))
        .write(ShiftLogsCompanion(clockOutAt: Value(DateTime.now())));
  }

  @override
  Future<ShiftLog?> getOpenShift(int userId) async {
    final query = _db.select(_db.shiftLogs)
      ..where((s) => s.userId.equals(userId) & s.clockOutAt.isNull())
      ..orderBy([(s) => OrderingTerm.desc(s.clockInAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<List<ShiftLog>> getRecentForSite(int siteId, {int limit = 50}) async {
    final query = _db.select(_db.shiftLogs)
      ..where((s) => s.siteId.equals(siteId))
      ..orderBy([(s) => OrderingTerm.desc(s.clockInAt)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  ShiftLog _toModel(ShiftLogEntity row) => ShiftLog(
    id: row.id,
    userId: row.userId,
    siteId: row.siteId,
    clockInAt: row.clockInAt,
    clockOutAt: row.clockOutAt,
  );
}
