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
    bool isStandby = false,
  });

  /// Atomic claim — returns the updated [Shift] on success, or null if the
  /// shift was already claimed/not open by the time this call landed (the
  /// race was lost, not an error).
  Future<Shift?> claimShift({required int shiftId, required int userId});

  /// Returns the updated [Shift] on success, or null if the assignment was
  /// rejected server-side — role gate (venueManager+) or certification
  /// eligibility failed. See manager_assign_shift's own SQL doc comment
  /// (tools/phase2_manager_assign_shift_rpc_migration.sql) for why this is
  /// a real RPC now, not a plain table update.
  Future<Shift?> managerAssign({
    required int shiftId,
    required int userId,
    required int assignedByUserId,
  });

  Future<void> managerRemove({
    required int shiftId,
    required int removedUserId,
    required int removedByUserId,
    String? reason,
  });

  Future<void> cancelClaim({
    required int shiftId,
    required int userId,
    String? reason,
  });

  /// Full claim/cancel/manager-action history for one user, most recent
  /// first — the raw data ShiftReliabilityService computes a descriptive
  /// (never numeric-to-peers) standing from.
  Future<List<ShiftClaimEvent>> getClaimHistoryForUser(
    int userId, {
    DateTime? since,
  });
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
    priorityUntil: row['priority_until'] == null
        ? null
        : DateTime.parse(row['priority_until'] as String),
    claimedByUserId: row['claimed_by_user_id'] as int?,
    assignedByUserId: row['assigned_by_user_id'] as int?,
    createdByUserId: row['created_by_user_id'] as int,
    createdAt: DateTime.parse(row['created_at'] as String),
    cancelledAt: row['cancelled_at'] == null
        ? null
        : DateTime.parse(row['cancelled_at'] as String),
    cancelledByUserId: row['cancelled_by_user_id'] as int?,
    cancellationReason: row['cancellation_reason'] as String?,
    isStandby: row['is_standby'] as bool? ?? false,
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
    bool isStandby = false,
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
      'is_standby': isStandby,
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
    // Audit trail (R4, 2026-09-27) — written client-side after the atomic
    // claim succeeds, same pattern managerAssign already uses below. Not
    // perfectly atomic with the claim itself (a crash between the two would
    // lose this one row), but matches this app's established "not a hot
    // path, simple read/write" convention and RLS already permits it (the
    // same policy that lets managerAssign write here).
    await _client.insertOne('shift_claims', {
      'shift_id': shiftId,
      'user_id': userId,
      'event_type': 'claimed',
      'actor_user_id': userId,
    });
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<Shift?> managerAssign({
    required int shiftId,
    required int userId,
    required int assignedByUserId,
  }) async {
    final rows = await _client.rpc('manager_assign_shift', {
      'p_shift_id': shiftId,
      'p_user_id': userId,
      'p_assigned_by_user_id': assignedByUserId,
    });
    if (rows.isEmpty) return null;
    // Audit trail, same not-perfectly-atomic-but-established convention
    // as claimShift's own comment on this exact pattern.
    await _client.insertOne('shift_claims', {
      'shift_id': shiftId,
      'user_id': userId,
      'event_type': 'manager_assigned',
      'actor_user_id': assignedByUserId,
    });
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<void> managerRemove({
    required int shiftId,
    required int removedUserId,
    required int removedByUserId,
    String? reason,
  }) async {
    await _client.update(
      'shifts',
      filter: 'id=eq.$shiftId',
      body: {
        'status': 'open',
        'claimed_by_user_id': null,
        'assigned_by_user_id': null,
      },
    );
    await _client.insertOne('shift_claims', {
      'shift_id': shiftId,
      'user_id': removedUserId,
      'event_type': 'manager_removed',
      'actor_user_id': removedByUserId,
    });
  }

  @override
  Future<void> cancelClaim({
    required int shiftId,
    required int userId,
    String? reason,
  }) async {
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
    await _client.insertOne('shift_claims', {
      'shift_id': shiftId,
      'user_id': userId,
      'event_type': 'cancelled',
      'actor_user_id': userId,
    });
  }

  @override
  Future<List<ShiftClaimEvent>> getClaimHistoryForUser(
    int userId, {
    DateTime? since,
  }) async {
    final sinceClause = since == null
        ? ''
        : '&created_at=gte.${since.toIso8601String()}';
    final rows = await _client.select(
      'shift_claims',
      query:
          'user_id=eq.$userId$sinceClause'
          '&select=id,shift_id,user_id,event_type,actor_user_id,created_at,shifts(starts_at)'
          '&order=created_at.desc',
    );
    return rows.map((row) {
      final embeddedShift = row['shifts'] as Map<String, dynamic>?;
      return ShiftClaimEvent(
        id: row['id'] as int,
        shiftId: row['shift_id'] as int,
        userId: row['user_id'] as int,
        eventType: shiftClaimEventTypeFromString(row['event_type'] as String),
        actorUserId: row['actor_user_id'] as int,
        createdAt: DateTime.parse(row['created_at'] as String),
        shiftStartsAt: embeddedShift?['starts_at'] == null
            ? null
            : DateTime.parse(embeddedShift!['starts_at'] as String),
      );
    }).toList();
  }
}
