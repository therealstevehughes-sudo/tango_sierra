import '../../core/network/backend_rest_client.dart';
import '../models/shift_handover_note.dart';
import 'shift_handover_repository.dart';

// Phase B5 — backend-hosted ShiftHandoverNotes. RLS reuses
// can_access_site(site_id), the same shape proven since B2. Proven via
// curl before this class was written.
class SupabaseShiftHandoverRepository implements ShiftHandoverRepository {
  SupabaseShiftHandoverRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<ShiftHandoverNote?> getLatest() async {
    final rows = await _client.select(
      'shift_handover_notes',
      query: 'order=created_at.desc&limit=1',
    );
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<ShiftHandoverNote?> getLatestForSite(int siteId) async {
    final rows = await _client.select(
      'shift_handover_notes',
      query:
          'site_id=eq.$siteId&resolved=eq.false&order=created_at.desc&limit=1',
    );
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<bool> hasAcknowledged({
    required int noteId,
    required int userId,
  }) async {
    final rows = await _client.select(
      'shift_handover_acknowledgements',
      query: 'note_id=eq.$noteId&user_id=eq.$userId',
    );
    return rows.isNotEmpty;
  }

  @override
  Future<void> acknowledge({
    required int noteId,
    required int userId,
    required bool repeatForNextShift,
  }) async {
    if (!repeatForNextShift) {
      await _client.update(
        'shift_handover_notes',
        filter: 'id=eq.$noteId',
        body: {'resolved': true},
      );
      return;
    }
    await _client.insertOne('shift_handover_acknowledgements', {
      'note_id': noteId,
      'user_id': userId,
      'acknowledged_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<ShiftHandoverNote> create({
    required int authorUserId,
    required String note,
    required int siteId,
  }) async {
    final row = await _client.insertOne('shift_handover_notes', {
      'author_user_id': authorUserId,
      'note': note,
      'created_at': DateTime.now().toIso8601String(),
      'site_id': siteId,
    });
    return _toModel(row);
  }

  ShiftHandoverNote _toModel(Map<String, dynamic> row) => ShiftHandoverNote(
    id: row['id'] as int,
    authorUserId: row['author_user_id'] as int,
    note: row['note'] as String,
    createdAt: DateTime.parse(row['created_at'] as String),
    siteId: row['site_id'] as int,
  );
}
