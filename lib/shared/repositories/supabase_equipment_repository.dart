import '../../core/network/backend_rest_client.dart';
import '../models/duplicate_equipment_name_exception.dart';
import '../models/equipment.dart';
import '../models/equipment_type.dart';
import 'equipment_repository.dart';

// Phase B2 brought EquipmentTypes; Phase B5 brings EquipmentInstances —
// so every method here except the equipment-type/venue-type tagging join
// (getVenueTypeIds/setVenueTypeIds — a join table not yet backend-hosted,
// still "schema-ready, no filtering UI" locally too) now goes to the
// backend. Instance RLS reuses can_access_site(site_id), proven via curl
// before this was upgraded. The same-site duplicate-name check (an
// app-layer rule, no DB constraint even locally) is replicated against
// the RLS-scoped instance list.
class SupabaseEquipmentRepository implements EquipmentRepository {
  SupabaseEquipmentRepository(
    this._client,
    this._organisationId,
    this._tagsDelegate,
  );

  final BackendRestClient _client;
  final int Function() _organisationId;

  // Only the two venue-type-tagging methods still route here.
  final EquipmentRepository _tagsDelegate;

  @override
  Future<List<EquipmentType>> getEquipmentTypes() async {
    final rows = await _client.select('equipment_types');
    return rows
        .map(
          (row) =>
              EquipmentType(id: row['id'] as int, name: row['name'] as String),
        )
        .toList();
  }

  @override
  Future<EquipmentType> createEquipmentType(String name) async {
    final row = await _client.insertOne('equipment_types', {
      'name': name,
      'organisation_id': _organisationId(),
    });
    return EquipmentType(id: row['id'] as int, name: row['name'] as String);
  }

  @override
  Future<List<Equipment>> getAll() async {
    final rows = await _client.select('equipment_instances');
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Equipment>> getForSite(int siteId) async {
    final rows = await _client.select(
      'equipment_instances',
      query: 'site_id=eq.$siteId',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Equipment> create({
    required String name,
    required int equipmentTypeId,
    int? areaId,
    required int siteId,
  }) async {
    final trimmed = name.trim();
    await _checkNotDuplicate(siteId: siteId, name: trimmed);
    final row = await _client.insertOne('equipment_instances', {
      'name': trimmed,
      'equipment_type_id': equipmentTypeId,
      'area_id': areaId,
      'site_id': siteId,
    });
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    final trimmed = newName.trim();
    final existing = await _client.select(
      'equipment_instances',
      query: 'id=eq.$id&select=site_id',
    );
    if (existing.isNotEmpty && existing.first['site_id'] != null) {
      await _checkNotDuplicate(
        siteId: existing.first['site_id'] as int,
        name: trimmed,
        excludingId: id,
      );
    }
    await _client.update(
      'equipment_instances',
      filter: 'id=eq.$id',
      body: {'name': trimmed},
    );
  }

  Future<void> _checkNotDuplicate({
    required int siteId,
    required String name,
    int? excludingId,
  }) async {
    final atSite = await _client.select(
      'equipment_instances',
      query: 'site_id=eq.$siteId&select=id,name',
    );
    final normalized = name.toLowerCase();
    final collision = atSite.any(
      (row) =>
          row['id'] != excludingId &&
          (row['name'] as String).trim().toLowerCase() == normalized,
    );
    if (collision) throw DuplicateEquipmentNameException(name);
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await _client.update(
      'equipment_instances',
      filter: 'id=eq.$id',
      body: {'active': active},
    );
    // NOTE: the local path also deactivates any TaskSchedules pointing at
    // this instance. On the backend that cascade belongs in the same
    // layer once the "retire equipment" flow itself is retrofitted — for
    // now this mirrors only the instance's own active flag. Logged in
    // BACKEND_INFRA.md's B5 section.
  }

  @override
  Future<List<int>> getVenueTypeIds(int equipmentTypeId) =>
      _tagsDelegate.getVenueTypeIds(equipmentTypeId);

  @override
  Future<void> setVenueTypeIds(int equipmentTypeId, List<int> venueTypeIds) =>
      _tagsDelegate.setVenueTypeIds(equipmentTypeId, venueTypeIds);

  Equipment _toModel(Map<String, dynamic> row) => Equipment(
    id: row['id'] as int,
    name: row['name'] as String,
    equipmentTypeId: row['equipment_type_id'] as int,
    areaId: row['area_id'] as int?,
    siteId: row['site_id'] as int,
    active: row['active'] as bool,
  );
}
