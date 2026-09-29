import '../../core/network/backend_rest_client.dart';
import '../models/service_provider.dart';

// Trusted Service Provider directory, phase 1 (2026-09-29) — see the
// model file's doc comment for the full design. Backend-only, deployed:
// tools/service_provider_directory_migration.sql, live-proven cross-org
// (two real throwaway tenants, both cleaned up afterward).
abstract class ServiceProviderRepository {
  /// Your own organisation's added providers, full detail regardless of
  /// [ServiceProvider.shared] — RLS scopes this to your own org, so this
  /// never needs an explicit organisation filter client-side.
  Future<List<ServiceProvider>> getMyProviders();

  Future<ServiceProvider> addProvider({
    required int organisationId,
    required String name,
    String? phone,
    String? email,
    required String category,
    String? notes,
    required bool shared,
  });

  /// The opt-in "I'm happy to review and share" toggle — flips visibility
  /// in the shared directory without touching anything else about the
  /// listing.
  Future<void> setShared(int providerId, bool shared);

  /// The masked, cross-organisation directory — see
  /// `list_shared_service_providers()`'s own doc comment for exactly how
  /// name/phone/email get blurred until unlocked.
  Future<List<SharedProviderListing>> getSharedDirectory();

  /// Records that your organisation has unlocked a provider's contact
  /// details. Idempotent — calling this again for an already-unlocked
  /// provider is a harmless no-op, never a duplicate charge record.
  Future<void> unlockProvider(int providerId);

  Future<List<ProviderReview>> getReviews(int providerId);

  Future<void> submitReview({
    required int providerId,
    required int priceRating,
    required int punctualityRating,
    required int qualityRating,
    required int availabilityRating,
    String? reviewText,
    int? siteId,
  });

  /// How many contacts your organisation has unlocked so far this billing
  /// month — the running total shown on the directory screen itself
  /// (agreed placement: on the screen it's about, never buried in
  /// Settings/Account).
  Future<int> getUnlocksThisMonth();
}

class SupabaseServiceProviderRepository implements ServiceProviderRepository {
  SupabaseServiceProviderRepository(this._client);

  final BackendRestClient _client;

  ServiceProvider _toModel(Map<String, dynamic> row) => ServiceProvider(
    id: row['id'] as int,
    organisationId: row['organisation_id'] as int,
    createdByUserId: row['created_by_user_id'] as int?,
    name: row['name'] as String,
    phone: row['phone'] as String?,
    email: row['email'] as String?,
    category: row['category'] as String,
    notes: row['notes'] as String?,
    shared: row['shared'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
  );

  SharedProviderListing _toListing(Map<String, dynamic> row) =>
      SharedProviderListing(
        id: row['id'] as int,
        category: row['category'] as String,
        name: row['name'] as String?,
        phone: row['phone'] as String?,
        email: row['email'] as String?,
        avgPrice: (row['avg_price'] as num?)?.toDouble(),
        avgPunctuality: (row['avg_punctuality'] as num?)?.toDouble(),
        avgQuality: (row['avg_quality'] as num?)?.toDouble(),
        avgAvailability: (row['avg_availability'] as num?)?.toDouble(),
        reviewCount: (row['review_count'] as num).toInt(),
        isOwn: row['is_own'] as bool,
        isUnlocked: row['is_unlocked'] as bool,
      );

  ProviderReview _toReview(Map<String, dynamic> row) => ProviderReview(
    priceRating: row['price_rating'] as int,
    punctualityRating: row['punctuality_rating'] as int,
    qualityRating: row['quality_rating'] as int,
    availabilityRating: row['availability_rating'] as int,
    reviewText: row['review_text'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
  );

  @override
  Future<List<ServiceProvider>> getMyProviders() async {
    final rows = await _client.select(
      'service_providers',
      query: 'order=created_at.desc',
    );
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
    final row = await _client.insertOne('service_providers', {
      'organisation_id': organisationId,
      'name': name,
      'phone': phone,
      'email': email,
      'category': category,
      'notes': notes,
      'shared': shared,
    });
    return _toModel(row);
  }

  @override
  Future<void> setShared(int providerId, bool shared) async {
    await _client.update(
      'service_providers',
      filter: 'id=eq.$providerId',
      body: {'shared': shared},
    );
  }

  @override
  Future<List<SharedProviderListing>> getSharedDirectory() async {
    final rows = await _client.rpc('list_shared_service_providers', {});
    return rows.map((r) => _toListing(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> unlockProvider(int providerId) async {
    await _client.rpc('unlock_service_provider', {'p_provider_id': providerId});
  }

  @override
  Future<List<ProviderReview>> getReviews(int providerId) async {
    final rows = await _client.rpc('list_provider_reviews', {
      'p_provider_id': providerId,
    });
    return rows.map((r) => _toReview(r as Map<String, dynamic>)).toList();
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
    await _client.insertOne('service_provider_ratings', {
      'service_provider_id': providerId,
      'price_rating': priceRating,
      'punctuality_rating': punctualityRating,
      'quality_rating': qualityRating,
      'availability_rating': availabilityRating,
      'review_text': reviewText,
      'site_id': siteId,
    });
  }

  @override
  Future<int> getUnlocksThisMonth() async {
    final rows = await _client.rpc('count_unlocks_this_month', {});
    if (rows.isEmpty) return 0;
    return ((rows.first as Map<String, dynamic>)['unlock_count'] as num)
        .toInt();
  }
}
