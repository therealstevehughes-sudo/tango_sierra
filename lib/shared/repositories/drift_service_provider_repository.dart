import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/service_provider.dart';
import 'service_provider_repository.dart';

/// Local mode's Service Provider repository (2026-09-29) — see
/// ThirdPartyContacts' own doc comment in app_database.dart for why this
/// table (previously "Maintenance Contacts", a real, avoidable
/// duplication the founder caught) now backs "My Providers" locally too.
///
/// Cross-organisation concepts have no meaning on a single-device local
/// install — there's no other organisation to share with — so
/// [getSharedDirectory]/[unlockProvider]/[getUnlocksThisMonth] are
/// deliberately inert here (empty list / no-op / always 0) rather than
/// throwing, matching this app's established "local mode does less, not
/// nothing" shape for every other dual-mode repository. The screen itself
/// hides the share toggle and the Find a Provider tab entirely in local
/// mode, so these paths are a safety net, not the primary UI.
class DriftServiceProviderRepository implements ServiceProviderRepository {
  DriftServiceProviderRepository(this._db);

  final AppDatabase _db;

  ServiceProvider _toModel(ThirdPartyContactEntity row) => ServiceProvider(
    id: row.id,
    // organisationId has no local meaning — 0 is a harmless placeholder,
    // never read by any local-mode call site.
    organisationId: 0,
    createdByUserId: row.createdByUserId,
    name: row.name,
    phone: row.phone,
    email: row.email,
    category: row.specialty ?? 'General',
    notes: row.notes,
    shared: false,
    createdAt: row.createdAt,
  );

  ProviderReview _toReview(LocalProviderRating row) => ProviderReview(
    priceRating: row.priceRating,
    punctualityRating: row.punctualityRating,
    qualityRating: row.qualityRating,
    availabilityRating: row.availabilityRating,
    reviewText: row.reviewText,
    createdAt: row.createdAt,
  );

  @override
  Future<List<ServiceProvider>> getMyProviders() async {
    final rows =
        await (_db.select(_db.thirdPartyContacts)
              ..where((c) => c.active.equals(true))
              ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
            .get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<ServiceProvider> addProvider({
    required int organisationId,
    required String name,
    String? phone,
    String? email,
    required String category,
    String? notes,
    required bool shared,
  }) async {
    // organisationId/shared are ignored locally — see class doc comment.
    final id = await _db
        .into(_db.thirdPartyContacts)
        .insert(
          ThirdPartyContactsCompanion.insert(
            name: name,
            specialty: Value(category),
            phone: Value(phone),
            email: Value(email),
            notes: Value(notes),
            createdByUserId: 0,
            createdAt: DateTime.now(),
          ),
        );
    return ServiceProvider(
      id: id,
      organisationId: organisationId,
      name: name,
      phone: phone,
      email: email,
      category: category,
      notes: notes,
      shared: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> setShared(int providerId, bool shared) async {
    // No-op locally — sharing has no meaning without another organisation
    // to share with. The screen hides this control in local mode.
  }

  @override
  Future<List<SharedProviderListing>> getSharedDirectory() async => const [];

  @override
  Future<bool> unlockProvider(int providerId) async => false;

  @override
  Future<List<ProviderReview>> getReviews(int providerId) async {
    final rows = await (_db.select(
      _db.localProviderRatings,
    )..where((r) => r.contactId.equals(providerId))).get();
    return rows.map(_toReview).toList();
  }

  @override
  Future<void> submitReview({
    required int providerId,
    required int priceRating,
    required int punctualityRating,
    required int qualityRating,
    required int availabilityRating,
    String? reviewText,
    int? siteId,
  }) async {
    await _db
        .into(_db.localProviderRatings)
        .insert(
          LocalProviderRatingsCompanion.insert(
            contactId: providerId,
            priceRating: priceRating,
            punctualityRating: punctualityRating,
            qualityRating: qualityRating,
            availabilityRating: availabilityRating,
            reviewText: Value(reviewText),
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<int> getUnlocksThisMonth() async => 0;
}
