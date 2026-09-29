// Trusted Service Provider directory, phase 1 (2026-09-29) — backend-only,
// no local Drift mirror, same reasoning as Roster/off-day requests: this
// is inherently a cross-tenant feature (a venue browsing OTHER
// organisations' shared contacts), which has no meaningful offline/
// local-only form. See tools/service_provider_directory_migration.sql for
// the full schema/RLS/RPC design and DECISIONS_LOG.md for the agreed
// product design (blurred name+contact until unlocked, self-policing
// reviews, pay-per-lead + seeker-side micro-fee monetization).

/// A provider your own organisation has added to its own contacts — full
/// detail always visible to you, whether or not you've chosen to share it.
class ServiceProvider {
  const ServiceProvider({
    required this.id,
    required this.organisationId,
    this.createdByUserId,
    required this.name,
    this.phone,
    this.email,
    required this.category,
    this.notes,
    required this.shared,
    required this.createdAt,
  });

  final int id;
  final int organisationId;
  final int? createdByUserId;
  final String name;
  final String? phone;
  final String? email;
  final String category;
  final String? notes;
  final bool shared;
  final DateTime createdAt;
}

/// A row from the shared directory (`list_shared_service_providers` RPC) —
/// [name]/[phone]/[email] are null unless [isOwn] or [isUnlocked]. Never
/// constructed from a plain table read; only ever from that RPC's masked
/// output.
class SharedProviderListing {
  const SharedProviderListing({
    required this.id,
    required this.category,
    this.name,
    this.phone,
    this.email,
    this.avgPrice,
    this.avgPunctuality,
    this.avgQuality,
    this.avgAvailability,
    required this.reviewCount,
    required this.isOwn,
    required this.isUnlocked,
  });

  final int id;
  final String category;
  final String? name;
  final String? phone;
  final String? email;
  final double? avgPrice;
  final double? avgPunctuality;
  final double? avgQuality;
  final double? avgAvailability;
  final int reviewCount;
  final bool isOwn;
  final bool isUnlocked;

  bool get isRevealed => isOwn || isUnlocked;
}

/// One rating+review submission for a provider. No reviewer identity is
/// carried here — reviews surface anonymously in the shared directory,
/// matching the "reviews are external, not vetted by VenuRite" framing.
class ProviderReview {
  const ProviderReview({
    required this.priceRating,
    required this.punctualityRating,
    required this.qualityRating,
    required this.availabilityRating,
    this.reviewText,
    required this.createdAt,
  });

  final int priceRating;
  final int punctualityRating;
  final int qualityRating;
  final int availabilityRating;
  final String? reviewText;
  final DateTime createdAt;
}
