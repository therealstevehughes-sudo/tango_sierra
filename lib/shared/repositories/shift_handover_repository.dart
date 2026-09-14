import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/shift_handover_note.dart';

abstract class ShiftHandoverRepository {
  Future<ShiftHandoverNote?> getLatest();
  // Built 2026-09-14: only ever returns an UNresolved note — once a note
  // is resolved it's done, for every shift, forever (fixes the original
  // bug where the same note showed on every task-screen open with no way
  // to clear it).
  Future<ShiftHandoverNote?> getLatestForSite(int siteId);
  Future<ShiftHandoverNote> create({
    required int authorUserId,
    required String note,
    required int siteId,
  });
  // True once [userId] has acknowledged [noteId] — lets the caller skip
  // re-showing a still-active note to someone who's already seen it,
  // while it keeps surfacing to anyone who hasn't (the actual next shift).
  Future<bool> hasAcknowledged({required int noteId, required int userId});
  // [repeatForNextShift] false resolves the note for everyone (the issue
  // is done). true just records this reader's acknowledgement and leaves
  // the note active for whoever opens the task screen next.
  Future<void> acknowledge({
    required int noteId,
    required int userId,
    required bool repeatForNextShift,
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
      ..where(
        (note) => note.siteId.equals(siteId) & note.resolved.equals(false),
      )
      ..orderBy([(note) => OrderingTerm.desc(note.createdAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<bool> hasAcknowledged({
    required int noteId,
    required int userId,
  }) async {
    final query = _db.select(_db.shiftHandoverAcknowledgements)
      ..where((a) => a.noteId.equals(noteId) & a.userId.equals(userId));
    final row = await query.getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> acknowledge({
    required int noteId,
    required int userId,
    required bool repeatForNextShift,
  }) async {
    if (!repeatForNextShift) {
      await (_db.update(
        _db.shiftHandoverNotes,
      )..where((n) => n.id.equals(noteId))).write(
        const ShiftHandoverNotesCompanion(resolved: Value(true)),
      );
      return;
    }
    await _db
        .into(_db.shiftHandoverAcknowledgements)
        .insert(
          ShiftHandoverAcknowledgementsCompanion.insert(
            noteId: noteId,
            userId: userId,
            acknowledgedAt: DateTime.now(),
          ),
        );
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
