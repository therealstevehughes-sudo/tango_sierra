import '../../core/network/backend_rest_client.dart';

// Stopping faked checks (2026-10-17, founder-approved plan items 1-8). The
// flags are raised by the database itself (tools/integrity_flags_migration.sql);
// this only reads them for managers, and records a manager's own check.

enum IntegrityKind {
  tooFast('too_fast'),
  burst('burst'),
  reusedPhoto('reused_photo'),
  sameReading('same_reading'),
  roundNumbers('round_numbers'),
  offSite('off_site'),
  checkMismatch('check_mismatch');

  const IntegrityKind(this.wire);
  final String wire;

  static IntegrityKind? fromWire(String? s) =>
      IntegrityKind.values.where((k) => k.wire == s).firstOrNull;
}

class IntegrityFlag {
  const IntegrityFlag({
    required this.id,
    required this.userId,
    required this.kind,
    required this.detail,
    required this.createdAt,
    required this.reviewed,
  });

  final int id;
  final int? userId;
  final IntegrityKind kind;
  final String detail;
  final DateTime createdAt;
  final bool reviewed;
}

/// A recent submission a manager could go and check in person.
class SpotCheckCandidate {
  const SpotCheckCandidate({
    required this.submissionId,
    required this.userId,
    required this.title,
    required this.completedBy,
    required this.completedAt,
    required this.status,
    this.value,
  });

  final int submissionId;
  final int? userId;
  final String title;
  final String completedBy;
  final DateTime completedAt;
  final String status;
  final String? value;
}

class IntegrityOverview {
  const IntegrityOverview({
    required this.flags,
    required this.secondsByUser,
    required this.matchedByUser,
    required this.mismatchedByUser,
    required this.today,
  });

  final List<IntegrityFlag> flags;

  /// Time on checks over the last 7 days (each check capped at 15 minutes,
  /// so a screen left open doesn't count as work).
  final Map<int, int> secondsByUser;
  final Map<int, int> matchedByUser;
  final Map<int, int> mismatchedByUser;
  final List<SpotCheckCandidate> today;
}

class IntegrityRepository {
  IntegrityRepository(this._client);

  final BackendRestClient _client;

  static String _iso(DateTime d) => d.toUtc().toIso8601String();

  Future<IntegrityOverview> overview(int siteId) async {
    final now = DateTime.now();
    final since30 = now.subtract(const Duration(days: 30));
    final since7 = now.subtract(const Duration(days: 7));
    final startOfDay = DateTime(now.year, now.month, now.day);
    final (flagRows, timeRows, checkRows, todayRows) = await (
      _client.select(
        'integrity_flags',
        query: 'site_id=eq.$siteId&created_at=gte.${_iso(since30)}'
            '&order=created_at.desc',
      ),
      _client.select(
        'task_submissions',
        query: 'site_id=eq.$siteId&completed_at=gte.${_iso(since7)}'
            '&duration_seconds=not.is.null'
            '&select=completed_by_user_id,duration_seconds',
      ),
      _client.select(
        'manager_spot_verifications',
        query: 'site_id=eq.$siteId&created_at=gte.${_iso(since30)}'
            '&select=result,task_submissions(completed_by_user_id)',
      ),
      _client.select(
        'task_submissions',
        query: 'site_id=eq.$siteId&completed_at=gte.${_iso(startOfDay)}'
            '&status=neq.NOT_COMPLETED&order=completed_at.desc&limit=200'
            '&select=id,completed_by_user_id,task_title,equipment_instance_name,'
            'completed_by,completed_at,status,numeric_value',
      ),
    ).wait;

    final flags = <IntegrityFlag>[
      for (final r in flagRows)
        if (IntegrityKind.fromWire(r['kind'] as String?) case final kind?)
          IntegrityFlag(
            id: r['id'] as int,
            userId: r['user_id'] as int?,
            kind: kind,
            detail: r['detail'] as String? ?? '',
            createdAt: DateTime.parse(r['created_at'] as String).toLocal(),
            reviewed: r['reviewed_at'] != null,
          ),
    ];
    final seconds = <int, int>{};
    for (final r in timeRows) {
      final uid = r['completed_by_user_id'] as int?;
      final s = r['duration_seconds'] as int?;
      if (uid == null || s == null) continue;
      seconds[uid] = (seconds[uid] ?? 0) + (s > 900 ? 900 : s);
    }
    final matched = <int, int>{};
    final mismatched = <int, int>{};
    for (final r in checkRows) {
      final uid = (r['task_submissions'] as Map?)?['completed_by_user_id'] as int?;
      if (uid == null) continue;
      final map = r['result'] == 'matches' ? matched : mismatched;
      map[uid] = (map[uid] ?? 0) + 1;
    }
    final today = [
      for (final r in todayRows)
        SpotCheckCandidate(
          submissionId: r['id'] as int,
          userId: r['completed_by_user_id'] as int?,
          title: r['equipment_instance_name'] == null
              ? r['task_title'] as String
              : '${r['task_title']} - ${r['equipment_instance_name']}',
          completedBy: r['completed_by'] as String? ?? '',
          completedAt: DateTime.parse(r['completed_at'] as String).toLocal(),
          status: r['status'] as String? ?? '',
          value: r['numeric_value'] as String?,
        ),
    ];
    return IntegrityOverview(
      flags: flags,
      secondsByUser: seconds,
      matchedByUser: matched,
      mismatchedByUser: mismatched,
      today: today,
    );
  }

  Future<void> markReviewed(int flagId, int reviewerId) => _client.update(
    'integrity_flags',
    filter: 'id=eq.$flagId',
    body: {
      'reviewed_at': DateTime.now().toUtc().toIso8601String(),
      'reviewed_by_user_id': reviewerId,
    },
  );

  Future<void> recordSpotCheck({
    required int submissionId,
    required bool matches,
    String? note,
    required int managerId,
  }) => _client.rpcVoid('record_spot_verification', {
    'p_submission_id': submissionId,
    'p_result': matches ? 'matches' : 'mismatch',
    'p_note': note,
    'p_user_id': managerId,
  });
}
