import '../../core/network/backend_rest_client.dart';
import '../models/subscription.dart';

// GoCardless billing (2026-09-21) -- backend-only, same reasoning as
// Subscription's own doc comment: a local-only install has no billing
// concept, so there is no Drift-backed implementation of this interface
// at all (unlike every other repository in this app, which has a local
// and a backend side) -- callers must check backendDataEnabledProvider
// themselves before touching this, the same way billing UI already only
// ever renders for a backend-hosted, executive-tier session.
abstract class SubscriptionRepository {
  Future<Subscription?> getForOrganisation(int organisationId);

  /// Starts the GoCardless Direct Debit setup flow for the caller's own
  /// organisation (must be a signed-in executive). Returns a URL to open
  /// in the system browser -- GoCardless's own hosted authorization page.
  /// Throws [DirectDebitSetupException] with a plain-English reason on
  /// failure (already has a mandate, no plan chosen, etc).
  ///
  /// [discountCode] (2026-09-22) -- optional "Friends" discount code,
  /// checked server-side; a valid one drops this organisation's rate to
  /// £19/branch/month instead of £39. Never required at sign-up anymore
  /// -- this is the one place it's entered.
  Future<DirectDebitSetupResult> startDirectDebitSetup({String? discountCode});

  /// Free-access code (2026-09-25) — see Subscription.freeAccessGranted's
  /// own doc comment. Returns true if [code] matched and access was
  /// granted; false for a wrong code (never throws for a wrong guess —
  /// this is a plain redemption box, not a security-sensitive login).
  Future<bool> redeemFreeAccessCode(int organisationId, String code);
}

class DirectDebitSetupResult {
  const DirectDebitSetupResult({
    required this.redirectUrl,
    required this.discountApplied,
    this.discountError,
  });

  final String redirectUrl;
  final bool discountApplied;
  final String? discountError;
}

class DirectDebitSetupException implements Exception {
  DirectDebitSetupException(this.message);
  final String message;
  @override
  String toString() => message;
}

class SupabaseSubscriptionRepository implements SubscriptionRepository {
  SupabaseSubscriptionRepository(this._client);

  final BackendRestClient _client;

  // Free-access code (2026-09-25, direct user request) — deliberately a
  // plain client-side string match, not a server-validated secret: this
  // is a testing convenience for two named people, not a real discount
  // mechanism protecting revenue (that's the server-validated "Friends"
  // discount code in startDirectDebitSetup above). Anyone who found this
  // string in the compiled app could grant themselves free access, which
  // is an acceptable risk for what this exists to do — flagged here so
  // it's never mistaken for something that needs stronger protection.
  static const _freeAccessCode = 'welovegreekosgyros';

  @override
  Future<Subscription?> getForOrganisation(int organisationId) async {
    final rows = await _client.select(
      'subscriptions',
      query: 'organisation_id=eq.$organisationId',
    );
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<DirectDebitSetupResult> startDirectDebitSetup({
    String? discountCode,
  }) async {
    final data = await _client.invokeFunction('gocardless-start-mandate', {
      if (discountCode != null && discountCode.trim().isNotEmpty)
        'discount_code': discountCode.trim(),
    });
    if (data['error'] != null) {
      throw DirectDebitSetupException(
        data['error'] is String
            ? data['error'] as String
            : 'Could not start Direct Debit setup',
      );
    }
    final redirectUrl = data['redirect_url'] as String?;
    if (redirectUrl == null) {
      throw DirectDebitSetupException('Could not start Direct Debit setup');
    }
    return DirectDebitSetupResult(
      redirectUrl: redirectUrl,
      discountApplied: data['discount_applied'] as bool? ?? false,
      discountError: data['discount_error'] as String?,
    );
  }

  @override
  Future<bool> redeemFreeAccessCode(int organisationId, String code) async {
    if (code.trim().toLowerCase() != _freeAccessCode) return false;
    await _client.update(
      'subscriptions',
      filter: 'organisation_id=eq.$organisationId',
      body: {'free_access_granted': true},
    );
    return true;
  }

  Subscription _toModel(Map<String, dynamic> row) => Subscription(
    id: (row['id'] as num).toInt(),
    organisationId: row['organisation_id'] as int,
    status: row['status'] as String,
    planName: row['plan_name'] as String?,
    trialEndsAt: row['trial_ends_at'] == null
        ? null
        : DateTime.parse(row['trial_ends_at'] as String),
    currentPeriodEnd: row['current_period_end'] == null
        ? null
        : DateTime.parse(row['current_period_end'] as String),
    paymentProvider: row['payment_provider'] as String?,
    providerCustomerId: row['provider_customer_id'] as String?,
    providerSubscriptionId: row['provider_subscription_id'] as String?,
    gocardlessMandateId: row['gocardless_mandate_id'] as String?,
    mandateStatus: row['mandate_status'] as String?,
    lastPaymentFailedAt: row['last_payment_failed_at'] == null
        ? null
        : DateTime.parse(row['last_payment_failed_at'] as String),
    restrictedAt: row['restricted_at'] == null
        ? null
        : DateTime.parse(row['restricted_at'] as String),
    foundingOffer: row['founding_offer'] as bool? ?? false,
    billedSiteCount: (row['billed_site_count'] as num?)?.toInt() ?? 1,
    freeAccessGranted: row['free_access_granted'] as bool? ?? false,
  );
}
