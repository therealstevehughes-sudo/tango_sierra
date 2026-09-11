import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/shift_handover_note.dart';

abstract class ShiftHandoverRepository {
  Future<ShiftHandoverNote?> getLatest();
  Future<ShiftHandoverNote?> getLatestForSite(int siteId);
  Future<ShiftHandoverNote> create({
    required int authorUserId,
    required String note,
    required int siteId,
  });
}

class DriftShiftHandoverRepository implements ShiftHandoverRepository {
  DriftShiftHandoverRepository(this._db);

  final AppDatabase _db;

  @override
  Future<ShiftHandoverNote?> getLatest() async {
    final query = _db.select(_db.shiftHandoverNotes)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<ShiftHandoverNote?> getLatestForSite(int siteId) async {
    final query = _db.select(_db.shiftHandoverNotes)
      ..where((note) => note.siteId.equals(siteId))
      ..orderBy([(note) => OrderingTerm.desc(note.createdAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<ShiftHandoverNote> create({
    required int authorUserId,
    required String note,
    required int siteId,
  }) async {
    final id = await _db
        .into(_db.shiftHandoverNotes)
        .insert(
          ShiftHandoverNotesCompanion.insert(
            authorUserId: authorUserId,
            note: note,
            createdAt: DateTime.now(),
            siteId: Value(siteId),
          ),
        );
    final row = await (_db.select(
      _db.shiftHandoverNotes,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toModel(row);
  }

  ShiftHandoverNote _toModel(ShiftHandoverNoteEntity row) => ShiftHandoverNote(
    id: row.id,
    authorUserId: row.authorUserId,
    note: row.note,
    createdAt: row.createdAt,
    siteId: row.siteId!,
  );
}
