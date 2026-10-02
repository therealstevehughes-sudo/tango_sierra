import '../../core/network/backend_rest_client.dart';
import '../models/backend_shift_log.dart';

const shiftVerificationPhotosBucket = 'shift-verification-photos';

// Shift verification photos (2026-10-02) — see BackendShiftLog's own doc
// comment. Backend-only, no local Drift mirror: the whole point is a
// supervisor on a DIFFERENT device seeing a pending clock-in/out, which a
// local-only table can never support.
abstract class BackendShiftLogRepository {
  /// Uploads [photoBytes] (already compressed/downscaled by the caller)
  /// to the private Storage bucket, then calls the shift_clock_in RPC.
  /// [photoBytes] null means the staff member declined — the row is
  /// created with no photo, immediately pending supervisor verification.
  Future<BackendShiftLog?> clockIn({
    required int siteId,
    required int userId,
    List<int>? photoBytes,
  });

  Future<BackendShiftLog?> clockOut({
    required int shiftLogId,
    required int siteId,
    required int userId,
    List<int>? photoBytes,
  });

  /// The most recent open (no clockOutAt) shift for this user at this
  /// site — mirrors the local ShiftLogRepository.getOpenShift shape.
  Future<BackendShiftLog?> getOpenShift({
    required int userId,
    required int siteId,
  });

  Future<List<BackendShiftLog>> getRecentForSite(
    int siteId, {
    int limit = 50,
  });

  /// Supervisor+ confirming a declined clock-in/out actually happened.
  /// [which] is 'in' or 'out'.
  Future<BackendShiftLog?> verify({
    required int shiftLogId,
    required String which,
  });

  /// Lazy retention purge (2026-10-02) — call whenever a supervisor+
  /// views the shift log for a site; deletes the Storage object for any
  /// photo older than [retentionDays], then clears the row's path. Safe
  /// to call repeatedly — rows with no expired photo are left untouched.
  Future<void> purgeExpiredPhotos({
    required List<BackendShiftLog> logs,
    required int retentionDays,
  });
}

class SupabaseBackendShiftLogRepository implements BackendShiftLogRepository {
  SupabaseBackendShiftLogRepository(this._client);

  final BackendRestClient _client;

  BackendShiftLog _toModel(Map<String, dynamic> row) => BackendShiftLog(
    id: row['id'] as int,
    userId: row['user_id'] as int,
    siteId: row['site_id'] as int,
    clockInAt: DateTime.parse(row['clock_in_at'] as String),
    clockInPhotoPath: row['clock_in_photo_path'] as String?,
    clockInPhotoPurged: row['clock_in_photo_purged'] as bool? ?? false,
    clockInVerifiedByUserId: row['clock_in_verified_by_user_id'] as int?,
    clockInVerifiedAt: row['clock_in_verified_at'] == null
        ? null
        : DateTime.parse(row['clock_in_verified_at'] as String),
    clockOutAt: row['clock_out_at'] == null
        ? null
        : DateTime.parse(row['clock_out_at'] as String),
    clockOutPhotoPath: row['clock_out_photo_path'] as String?,
    clockOutPhotoPurged: row['clock_out_photo_purged'] as bool? ?? false,
    clockOutVerifiedByUserId: row['clock_out_verified_by_user_id'] as int?,
    clockOutVerifiedAt: row['clock_out_verified_at'] == null
        ? null
        : DateTime.parse(row['clock_out_verified_at'] as String),
  );

  String _photoPath(int siteId, int userId, String which) =>
      '$siteId/$userId/${DateTime.now().millisecondsSinceEpoch}_$which.jpg';

  @override
  Future<BackendShiftLog?> clockIn({
    required int siteId,
    required int userId,
    List<int>? photoBytes,
  }) async {
    String? photoPath;
    if (photoBytes != null) {
      photoPath = _photoPath(siteId, userId, 'in');
      await _client.uploadToStorage(
        shiftVerificationPhotosBucket,
        photoPath,
        photoBytes,
        contentType: 'image/jpeg',
      );
    }
    final rows = await _client.rpc('shift_clock_in', {
      'p_site_id': siteId,
      'p_photo_path': photoPath,
    });
    if (rows.isEmpty) return null;
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<BackendShiftLog?> clockOut({
    required int shiftLogId,
    required int siteId,
    required int userId,
    List<int>? photoBytes,
  }) async {
    String? photoPath;
    if (photoBytes != null) {
      photoPath = _photoPath(siteId, userId, 'out');
      await _client.uploadToStorage(
        shiftVerificationPhotosBucket,
        photoPath,
        photoBytes,
        contentType: 'image/jpeg',
      );
    }
    final rows = await _client.rpc('shift_clock_out', {
      'p_shift_log_id': shiftLogId,
      'p_photo_path': photoPath,
    });
    if (rows.isEmpty) return null;
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<BackendShiftLog?> getOpenShift({
    required int userId,
    required int siteId,
  }) async {
    final rows = await _client.select(
      'shift_logs',
      query:
          'user_id=eq.$userId&site_id=eq.$siteId&clock_out_at=is.null'
          '&order=clock_in_at.desc&limit=1',
    );
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<List<BackendShiftLog>> getRecentForSite(
    int siteId, {
    int limit = 50,
  }) async {
    final rows = await _client.select(
      'shift_logs',
      query: 'site_id=eq.$siteId&order=clock_in_at.desc&limit=$limit',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<BackendShiftLog?> verify({
    required int shiftLogId,
    required String which,
  }) async {
    final rows = await _client.rpc('shift_verify_clock_event', {
      'p_shift_log_id': shiftLogId,
      'p_which': which,
    });
    if (rows.isEmpty) return null;
    return _toModel(rows.first as Map<String, dynamic>);
  }

  @override
  Future<void> purgeExpiredPhotos({
    required List<BackendShiftLog> logs,
    required int retentionDays,
  }) async {
    for (final log in logs) {
      if (log.clockInPhotoPath != null &&
          isShiftPhotoExpired(
            capturedAt: log.clockInAt,
            retentionDays: retentionDays,
          )) {
        await _purgeOne(log.siteId, log.id, log.clockInPhotoPath!, 'in');
      }
      final clockOutAt = log.clockOutAt;
      if (log.clockOutPhotoPath != null &&
          clockOutAt != null &&
          isShiftPhotoExpired(
            capturedAt: clockOutAt,
            retentionDays: retentionDays,
          )) {
        await _purgeOne(log.siteId, log.id, log.clockOutPhotoPath!, 'out');
      }
    }
  }

  Future<void> _purgeOne(
    int siteId,
    int shiftLogId,
    String photoPath,
    String which,
  ) async {
    try {
      await _client.deleteFromStorage(
        shiftVerificationPhotosBucket,
        photoPath,
      );
    } catch (_) {
      // Already gone, or a transient failure — either way, still clear
      // the DB path below so this row isn't retried forever; a storage
      // object that failed to delete is a disk-space cost, not a privacy
      // leak (RLS still gates who can read it).
    }
    await _client.rpcVoid('shift_clear_expired_photo', {
      'p_shift_log_id': shiftLogId,
      'p_which': which,
    });
  }
}
