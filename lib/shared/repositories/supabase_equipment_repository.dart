import '../../core/network/backend_rest_client.dart';
import '../models/equipment.dart';
import '../models/equipment_type.dart';
import 'equipment_repository.dart';

// Phase B2 — only EquipmentTypes move to the backend this cluster (the
// Foundation-cluster item explicitly approved). EquipmentInstances and the
// equipment-type/venue-type tagging join are operational/site data
// reserved for a later cluster — this class delegates every one of those
// methods to a wrapped Drift instance so the rest of EquipmentRepository's
// interface keeps working exactly as it does today while only the type
// catalog itself becomes backend-hosted. RLS on equipment_types uses the
// same shared-baseline-plus-tenant-private-addition shape as VenueTypes,
// proven via curl before this class was written.
class SupabaseEquipmentRepository implements EquipmentRepository {
  SupabaseEquipmentRepository(
    this._client,
    this._organisationId,
    this._localInstanceDelegate,
  );

  final BackendRestClient _client;
  final int Function() _organisationId;
  final EquipmentRepository _localInstanceDelegate;

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
  Future<List<Equipment>> getAll() => _localInstanceDelegate.getAll();

  @override
  Future<Equipment> create({
    required String name,
    required int equipmentTypeId,
    int? areaId,
    required int siteId,
  }) => _localInstanceDelegate.create(
    name: name,
    equipmentTypeId: equipmentTypeId,
    areaId: areaId,
    siteId: siteId,
  );

  @override
  Future<void> rename(int id, String newName) =>
      _localInstanceDelegate.rename(id, newName);

  @override
  Future<void> setActive(int id, bool active) =>
      _localInstanceDelegate.setActive(id, active);

  @override
  Future<List<int>> getVenueTypeIds(int equipmentTypeId) =>
      _localInstanceDelegate.getVenueTypeIds(equipmentTypeId);

  @override
  Future<void> setVenueTypeIds(int equipmentTypeId, List<int> venueTypeIds) =>
      _localInstanceDelegate.setVenueTypeIds(equipmentTypeId, venueTypeIds);
}
