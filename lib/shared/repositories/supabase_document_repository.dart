import '../../core/network/backend_rest_client.dart';
import '../models/document.dart';
import 'document_repository.dart';

// Document Centre (roadmap v1.1, built 2026-09-15) — backend-hosted. RLS
// reuses can_access_site(site_id), same shape as every other site-scoped
// table.
class SupabaseDocumentRepository implements DocumentRepository {
  SupabaseDocumentRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Document>> getForSite(int siteId) async {
    final rows = await _client.select(
      'documents',
      query: 'site_id=eq.$siteId&order=uploaded_at.desc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Document> create({
    required int siteId,
    required String title,
    required DocumentCategory category,
    required String filePath,
    DateTime? expiryDate,
    required int uploadedByUserId,
  }) async {
    final row = await _client.insertOne('documents', {
      'site_id': siteId,
      'title': title,
      'category': category.name,
      'file_path': filePath,
      'expiry_date': expiryDate?.toUtc().toIso8601String(),
      'uploaded_by_user_id': uploadedByUserId,
      'uploaded_at': DateTime.now().toUtc().toIso8601String(),
    });
    return _toModel(row);
  }

  @override
  Future<void> updateDetails(
    int id, {
    required String title,
    required DocumentCategory category,
    DateTime? expiryDate,
  }) async {
    await _client.update(
      'documents',
      filter: 'id=eq.$id',
      body: {
        'title': title,
        'category': category.name,
        'expiry_date': expiryDate?.toUtc().toIso8601String(),
      },
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await _client.update(
      'documents',
      filter: 'id=eq.$id',
      body: {'active': active},
    );
  }

  Document _toModel(Map<String, dynamic> row) => Document(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    title: row['title'] as String,
    category: DocumentCategory.values.byName(row['category'] as String),
    filePath: row['file_path'] as String,
    expiryDate: row['expiry_date'] == null
        ? null
        : DateTime.parse(row['expiry_date'] as String),
    uploadedByUserId: row['uploaded_by_user_id'] as int,
    uploadedAt: DateTime.parse(row['uploaded_at'] as String),
    active: row['active'] as bool,
  );
}
