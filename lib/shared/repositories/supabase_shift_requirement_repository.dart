import '../../core/network/backend_rest_client.dart';
import '../models/job_role.dart';
import '../models/shift_requirement.dart';
import 'shift_requirement_repository.dart';

class SupabaseShiftRequirementRepository implements ShiftRequirementRepository {
  SupabaseShiftRequirementRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<ShiftRequirement>> getForSite(int siteId) async {
    final rows = await _client.select(
      'shift_requirements',
      query: 'site_id=eq.$siteId&order=day_of_week.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<ShiftRequirement> create(ShiftRequirement requirement) async {
    final row = await _client.insertOne('shift_requirements', {
      'site_id': requirement.siteId,
      'department_id': requirement.departmentId,
      'job_role': requirement.jobRole?.name,
      'period_id': requirement.periodId,
      'day_of_week': requirement.dayOfWeek,
      'required_count': requirement.requiredCount,
      'standby_count': requirement.standbyCount,
      'min_tier': requirement.minTier,
    });
    return _toModel(row);
  }

  @override
  Future<void> delete(int id) async {
    await _client.delete('shift_requirements', filter: 'id=eq.$id');
  }

  @override
  Future<int> generateShiftsForWeek({
    required int siteId,
    required DateTime weekStart,
    required int createdByUserId,
  }) async {
    final requirements = await getForSite(siteId);
    if (requirements.isEmpty) return 0;

    final periodRows = await _client.select(
      'shift_periods',
      query: 'site_id=eq.$siteId',
    );
    final periodById = {
      for (final row in periodRows)
        row['id'] as int: (
          startMinutes: row['start_minutes'] as int,
          endMinutes: row['end_minutes'] as int,
        ),
    };

    // Idempotency guard (2026-10-02) — without this, clicking "Generate"
    // twice for the same week (a double-tap, or regenerating after adding
    // one more requirement) silently doubled every shift already created,
    // since this used to be a plain unconditional insert loop. Count what
    // already exists per (department, role, start time, standby/not) slot
    // in the target week and only top up the shortfall, so a repeat call
    // is a safe no-op and a partial-then-extended call fills in exactly
    // the gap.
    final weekEnd = weekStart.add(const Duration(days: 7));
    final existingShifts = await _client.select(
      'shifts',
      query:
          'site_id=eq.$siteId'
          '&starts_at=gte.${weekStart.toIso8601String()}'
          '&starts_at=lt.${weekEnd.toIso8601String()}'
          '&status=neq.cancelled'
          '&select=department_id,role_required,starts_at,is_standby,min_tier',
    );
    // Instants compared in UTC: the server returns starts_at in UTC while
    // the requirement's start is built in local time.
    String slotKey(
      dynamic departmentId,
      dynamic roleRequired,
      DateTime startsAt,
      bool isStandby,
      dynamic minTier,
    ) =>
        '$departmentId|$roleRequired|${startsAt.toUtc().toIso8601String()}|'
        '$isStandby|$minTier';
    final existingCountBySlot = <String, int>{};
    for (final row in existingShifts) {
      final key = slotKey(
        row['department_id'],
        row['role_required'],
        DateTime.parse(row['starts_at'] as String),
        row['is_standby'] as bool? ?? false,
        row['min_tier'],
      );
      existingCountBySlot[key] = (existingCountBySlot[key] ?? 0) + 1;
    }

    var created = 0;
    for (final req in requirements) {
      final period = periodById[req.periodId];
      if (period == null) continue; // period deleted since the requirement was made

      // weekStart is always a Monday (weekday 1), so dayOfWeek 1..7 maps
      // directly onto weekStart+0..weekStart+6.
      final targetDate = weekStart.add(Duration(days: req.dayOfWeek - 1));

      final startsAt = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        period.startMinutes ~/ 60,
        period.startMinutes % 60,
      );
      var endsAt = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        period.endMinutes ~/ 60,
        period.endMinutes % 60,
      );
      if (!endsAt.isAfter(startsAt)) {
        endsAt = endsAt.add(const Duration(days: 1)); // overnight period
      }

      // Only top up the shortfall (2026-10-17): the counts above were
      // gathered but never used, so a second "Generate" still doubled
      // every shift. Each slot's existing count is consumed as it's used,
      // so two requirements sharing a slot still add up correctly.
      Future<void> topUp(int wanted, bool isStandby) async {
        final key = slotKey(
          req.departmentId,
          req.jobRole?.name,
          startsAt,
          isStandby,
          req.minTier,
        );
        final have = existingCountBySlot[key] ?? 0;
        existingCountBySlot[key] = have > wanted ? have - wanted : 0;
        for (var i = have; i < wanted; i++) {
          await _client.insertOne('shifts', {
            'site_id': siteId,
            'department_id': req.departmentId,
            'role_required': req.jobRole?.name,
            'starts_at': startsAt.toIso8601String(),
            'ends_at': endsAt.toIso8601String(),
            'created_by_user_id': createdByUserId,
            'is_standby': isStandby,
            'min_tier': req.minTier,
          });
          created++;
        }
      }

      await topUp(req.requiredCount, false);
      await topUp(req.standbyCount, true);
    }
    return created;
  }

  ShiftRequirement _toModel(Map<String, dynamic> row) => ShiftRequirement(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    departmentId: row['department_id'] as int?,
    jobRole: row['job_role'] == null
        ? null
        : JobRole.values.byName(row['job_role'] as String),
    periodId: row['period_id'] as int,
    dayOfWeek: row['day_of_week'] as int,
    requiredCount: row['required_count'] as int,
    standbyCount: row['standby_count'] as int,
    minTier: row['min_tier'] as String?,
  );
}
