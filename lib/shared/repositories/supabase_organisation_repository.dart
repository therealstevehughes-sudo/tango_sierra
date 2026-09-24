import '../../core/network/backend_rest_client.dart';
import '../models/organisation.dart';
import 'organisation_repository.dart';

// Phase B2 — backend-hosted Organisations, gated behind
// backendDataEnabledProvider. RLS (see BACKEND_INFRA.md's B2 section)
// scopes every one of these calls to the caller's own organisation_id —
// getAll() and getDefault() can never see another tenant's row, proven
// directly via curl before this class was written.
class SupabaseOrganisationRepository implements OrganisationRepository {
  SupabaseOrganisationRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Organisation>> getAll() async {
    final rows = await _client.select('organisations');
    return rows.map(_toModel).toList();
  }

  @override
  Future<Organisation> getDefault() async {
    final rows = await _client.select(
      'organisations',
      query: 'order=id.asc&limit=1',
    );
    if (rows.isEmpty) {
      throw StateError(
        'No organisation visible to this session - check the session has '
        'a valid organisation_id claim.',
      );
    }
    return _toModel(rows.first);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update(
      'organisations',
      filter: 'id=eq.$id',
      body: {'name': newName},
    );
  }

  // Per-employee graded dashboard bars (2026-09-24) — backend schema gap,
  // same disclosed pattern as this file's siblings this session:
  // employee_graded_bars_enabled doesn't exist on the live
  // `organisations` table yet, so a read defaults to false (never
  // silently enables the anti-gaming-rule exception) and a write attempt
  // fails loudly rather than pretending to succeed.
  @override
  Future<void> setEmployeeGradedBarsEnabled(int id, bool enabled) {
    throw UnimplementedError(
      'employeeGradedBarsEnabled is not yet on the backend schema - needs '
      'a migration adding organisations.employee_graded_bars_enabled '
      'before this can be set for a backend-hosted organisation.',
    );
  }

  Organisation _toModel(Map<String, dynamic> row) => Organisation(
    id: row['id'] as int,
    name: row['name'] as String,
    createdAt: DateTime.parse(row['created_at'] as String),
    employeeGradedBarsEnabled:
        row['employee_graded_bars_enabled'] as bool? ?? false,
  );
}
