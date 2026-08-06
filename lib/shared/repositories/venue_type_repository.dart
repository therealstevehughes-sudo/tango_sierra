import '../../core/storage/app_database.dart';
import '../models/venue_type.dart';

abstract class VenueTypeRepository {
  Future<List<VenueType>> getAll();
  Future<VenueType> create(String name);
}

class DriftVenueTypeRepository implements VenueTypeRepository {
  DriftVenueTypeRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<VenueType>> getAll() async {
    final rows = await _db.select(_db.venueTypes).get();
    return rows.map((row) => VenueType(id: row.id, name: row.name)).toList();
  }

  @override
  Future<VenueType> create(String name) async {
    final id = await _db
        .into(_db.venueTypes)
        .insert(VenueTypesCompanion.insert(name: name));
    return VenueType(id: id, name: name);
  }
}
