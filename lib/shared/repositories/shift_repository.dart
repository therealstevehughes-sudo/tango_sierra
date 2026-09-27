import '../../core/network/backend_rest_client.dart';
import '../models/shift.dart';

// Roster add-on (2026-09-27) — backend-only, no Drift/local-only mirror,
// unlike ShiftLog. Claiming a shift is a genuine race condition (two staff
// tapping "Claim" on the same open shift at once) that only a single
// source of truth with an atomic write can resolve safely — a local-first
// design would need real conflict resolution/sync logic this feature
// doesn't need if it just always talks to the real backend. Gated behind
// backendDataEnabledProvider at the provider layer, same as Billing.
abstract class ShiftRepository {
  Future<List<Shift>> getForSite(int siteId);

  Future<Shift> postShift({
    required int siteId,
    int? departmentId,
    String? roleRequired,
    String? category,
    required DateTime startsAt,
    required DateTime endsAt,
    String? notes,
    required int createdByUserId,
  });

  /// Atomic claim — returns the updated [Shift] on success, or null if the
  /// shift was already claimed/not open by the time this call landed (the
  /// race was lost, not an error).
  Future<Shift?> claimShift({required int shiftId, required int userId});

  Future<void> managerAssign({
    required int shiftId,
    required int userId,
    required int assignedByUserId,
  });

  Future<void> managerRemove({required int shiftId, String? reason});

  Future<void> cancelClaim({required int shiftId, String? reason});
}

class SupabaseShiftRepository implements ShiftRepository {
  SupabaseShiftRepository(this._client);

  final BackendRestClient _client;

  Shift _toModel(Map<String, dynamic> row) => Shift(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    departmentId: row['department_id'] as int?,
    roleRequired: row['role_required'] as String?,
    category: row['category'] as String?,
    startsAt: DateTime.parse(row['starts_at'] as String),
    endsAt: DateTime.parse(row['ends_at'] as String),
    notes: row['notes'] as String?,
    status: shiftStatusFromString(row['status'] as String),
    claimedByUserId: row['claimed_by_user_id'] as int?,
    assignedByUserId: row['assigned_by_user_id'] as int?,
    createdByUserId: row['created_by_user_id'] as int,
    createdAt: DateTime.parse(row['created_at'] as String),
    cancelledAt: row['cancelled_at'] == null
        ? null
        : DateTime.parse(row['cancelled_at'] as String),
    cancelledByUserId: row['cancelled_by_user_id'] as int?,
    cancellationReason: row['cancellation_reason'] as String?,
  );

  @override
  Future<List<Shift>> getForSite(int siteId) async {
    final rows = await _client.select(
      'shifts',
      query: 'site_id=eq.$siteId&order=starts_at.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Shift> postShift({
    required int siteId,
    int? departmentId,
    String? roleRequired,
    String? category,
    required DateTime startsAt,
    required DateTime endsAt,
    String? notes,
    required int createdByUserId,
  }) async {
    final row = await _client.insertOne('shifts', {
      'site_id': siteId,
      'department_id': departmentId,
      'role_required': roleRequired,
      'category': category,
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'notes': notes,
      'created_by_user_id': createdByUserId,
    });
    return _toModel(row);
  }

  @override
  Future<Shift?> claimShift({required int shiftId, required int userId}) async {
    final rows = await _client.rpc('claim_shift', {
      'p_shift_id': shiftId,
      'p_user_id': userId,
    });
    if (rows.isEmpty) return null;
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<void> managerAssign({
    required int shiftId,
    required int userId,
    required int assignedByUserId,
  }) async {
    await _client.update(
      'shifts',
      filter: 'id=eq.$shiftId',
      body: {
        'status': 'assigned',
        'claimed_by_user_id': userId,
        'assigned_by_user_id': assignedByUserId,
      },
    );
    await _client.insertOne('shift_claims', {
      'shift_id': shiftId,
      'user_id': userId,
      'event_type': 'manager_assigned',
      'actor_user_id': assignedByUserId,
    });
  }

  @override
  Future<void> managerRemove({required int shiftId, String? reason}) async {
    await _client.update(
      'shifts',
      filter: 'id=eq.$shiftId',
      body: {
        'status': 'open',
        'claimed_by_user_id': null,
        'assigned_by_user_id': null,
      },
    );
  }

  @override
  Future<void> cancelClaim({required int shiftId, String? reason}) async {
    await _client.update(
      'shifts',
      filter: 'id=eq.$shiftId',
      body: {
        'status': 'open',
        'claimed_by_user_id': null,
        'cancelled_at': DateTime.now().toIso8601String(),
        'cancellation_reason': reason,
      },
    );
  }
}
