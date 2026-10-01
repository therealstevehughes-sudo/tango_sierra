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

      for (var i = 0; i < req.requiredCount; i++) {
        await _client.insertOne('shifts', {
          'site_id': siteId,
          'department_id': req.departmentId,
          'role_required': req.jobRole?.name,
          'starts_at': startsAt.toIso8601String(),
          'ends_at': endsAt.toIso8601String(),
          'created_by_user_id': createdByUserId,
          'is_standby': false,
        });
        created++;
      }
      for (var i = 0; i < req.standbyCount; i++) {
        await _client.insertOne('shifts', {
          'site_id': siteId,
          'department_id': req.departmentId,
          'role_required': req.jobRole?.name,
          'starts_at': startsAt.toIso8601String(),
          'ends_at': endsAt.toIso8601String(),
          'created_by_user_id': createdByUserId,
          'is_standby': true,
        });
        created++;
      }
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
  );
}
