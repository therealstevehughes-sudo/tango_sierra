import '../../core/network/backend_rest_client.dart';
import '../models/shift_period.dart';
import 'shift_period_repository.dart';

class SupabaseShiftPeriodRepository implements ShiftPeriodRepository {
  SupabaseShiftPeriodRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<ShiftPeriod>> getForSite(int siteId) async {
    final rows = await _client.select(
      'shift_periods',
      query: 'site_id=eq.$siteId&order=sort_order.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> replaceAll(int siteId, List<ShiftPeriod> periods) async {
    await _client.delete('shift_periods', filter: 'site_id=eq.$siteId');
    for (var i = 0; i < periods.length; i++) {
      final period = periods[i];
      await _client.insertOne('shift_periods', {
        'site_id': siteId,
        'name': period.name,
        'start_minutes': period.startMinutes,
        'end_minutes': period.endMinutes,
        'sort_order': i,
      });
    }
  }

  ShiftPeriod _toModel(Map<String, dynamic> row) => ShiftPeriod(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    name: row['name'] as String,
    startMinutes: row['start_minutes'] as int,
    endMinutes: row['end_minutes'] as int,
    sortOrder: row['sort_order'] as int,
  );
}
