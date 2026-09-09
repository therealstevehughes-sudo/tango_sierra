import '../../core/network/backend_rest_client.dart';
import '../models/venue_type.dart';
import 'venue_type_repository.dart';

// Phase B2 — backend-hosted VenueTypes. RLS shows the shared baseline
// (organisation_id null, shipped with every install) plus the caller's own
// tenant's private additions — never another tenant's — and blocks any
// attempt to write a null-org ("global") row. Proven via curl before this
// class was written.
class SupabaseVenueTypeRepository implements VenueTypeRepository {
  SupabaseVenueTypeRepository(this._client, this._organisationId);

  final BackendRestClient _client;

  // The creating session's own organisation_id — a create() can only ever
  // tag its own tenant, never null/global (RLS enforces this too; this is
  // just so the app doesn't rely on the server rejecting an omitted value).
  final int Function() _organisationId;

  @override
  Future<List<VenueType>> getAll() async {
    final rows = await _client.select('venue_types');
    return rows.map(_toModel).toList();
  }

  @override
  Future<VenueType> create(String name) async {
    final row = await _client.insertOne('venue_types', {
      'name': name,
      'organisation_id': _organisationId(),
    });
    return _toModel(row);
  }

  VenueType _toModel(Map<String, dynamic> row) =>
      VenueType(id: row['id'] as int, name: row['name'] as String);
}
