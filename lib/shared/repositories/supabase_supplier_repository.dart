import '../../core/network/backend_rest_client.dart';
import '../models/supplier.dart';
import '../models/supplier_category.dart';
import 'supplier_repository.dart';

// Suppliers backend migration (2026-09-20) — closes the long-standing
// local-Drift-only gap (flagged repeatedly: Sprint 038's Supplier
// Scorecard, Report Issue's supplier picker, delivery traceability all
// already depend on Supplier data). Same pattern as
// SupabaseDepartmentRepository — RLS reuses can_access_site(site_id)
// directly, no join needed (Suppliers has its own site_id column).
class SupabaseSupplierRepository implements SupplierRepository {
  SupabaseSupplierRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Supplier>> getForSite(int siteId) async {
    final rows = await _client.select(
      'suppliers',
      query: 'site_id=eq.$siteId&order=name.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Supplier> create({
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
    required SupplierApprovalStatus approvalStatus,
    String? approvalNote,
    required int siteId,
  }) async {
    final row = await _client.insertOne('suppliers', {
      'name': name,
      'contact': contact,
      'category': category.name,
      'custom_category_title': customCategoryTitle,
      'approval_status': approvalStatus.name,
      'approval_note': approvalNote,
      'site_id': siteId,
    });
    return _toModel(row);
  }

  @override
  Future<void> updateDetails(
    int id, {
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
  }) async {
    await _client.update(
      'suppliers',
      filter: 'id=eq.$id',
      body: {
        'name': name,
        'contact': contact,
        'category': category.name,
        'custom_category_title': customCategoryTitle,
      },
    );
  }

  @override
  Future<void> setApprovalStatus(
    int id,
    SupplierApprovalStatus status, {
    String? approvalNote,
  }) async {
    await _client.update(
      'suppliers',
      filter: 'id=eq.$id',
      body: {'approval_status': status.name, 'approval_note': approvalNote},
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await _client.update(
      'suppliers',
      filter: 'id=eq.$id',
      body: {'active': active},
    );
  }

  Supplier _toModel(Map<String, dynamic> row) => Supplier(
    id: row['id'] as int,
    name: row['name'] as String,
    contact: row['contact'] as String?,
    category: SupplierCategory.values.byName(row['category'] as String),
    customCategoryTitle: row['custom_category_title'] as String?,
    approvalStatus: SupplierApprovalStatus.values.byName(
      row['approval_status'] as String,
    ),
    approvalNote: row['approval_note'] as String?,
    siteId: row['site_id'] as int,
    active: row['active'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
