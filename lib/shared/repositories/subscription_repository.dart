import '../../core/network/backend_rest_client.dart';
import '../models/billing_pricing.dart';
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
  ///
  /// Billing v2 (2026-10-17): the code can be any of the three one-time
  /// types (50% for life, 50% for a year, free for life). A free-for-life
  /// code needs no Direct Debit, so the result has no redirect URL.
  /// [yearly] bills 11 months' price once a year.
  Future<DirectDebitSetupResult> startDirectDebitSetup({
    String? discountCode,
    bool yearly = false,
  });

  /// The server's current price for the caller's organisation, by branch.
  Future<BillingQuote?> getQuote();
}

class DirectDebitSetupResult {
  const DirectDebitSetupResult({
    required this.redirectUrl,
    required this.discountApplied,
    this.discountError,
    this.freeAccess = false,
  });

  /// Null when no payment is needed ([freeAccess]).
  final String? redirectUrl;
  final bool discountApplied;
  final String? discountError;
  final bool freeAccess;
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
    bool yearly = false,
  }) async {
    final data = await _client.invokeFunction('gocardless-start-mandate', {
      if (discountCode != null && discountCode.trim().isNotEmpty)
        'discount_code': discountCode.trim(),
      'billing_interval': yearly ? 'yearly' : 'monthly',
    });
    if (data['error'] != null) {
      throw DirectDebitSetupException(
        data['error'] is String
            ? data['error'] as String
            : 'Could not start Direct Debit setup',
      );
    }
    final freeAccess = data['free_access'] as bool? ?? false;
    final redirectUrl = data['redirect_url'] as String?;
    if (redirectUrl == null && !freeAccess) {
      throw DirectDebitSetupException('Could not start Direct Debit setup');
    }
    return DirectDebitSetupResult(
      redirectUrl: redirectUrl,
      discountApplied: data['discount_applied'] as bool? ?? false,
      discountError: data['discount_error'] as String?,
      freeAccess: freeAccess,
    );
  }

  @override
  Future<BillingQuote?> getQuote() async {
    final rows = await _client.rpc('my_billing_quote', {});
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    final breakdown = (row['breakdown'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return BillingQuote(
      monthlyPence: (row['monthly_pence'] as num).toInt(),
      headOffice: row['head_office'] as bool? ?? false,
      branches: [
        for (final b in breakdown)
          BranchQuote(
            siteId: (b['site_id'] as num).toInt(),
            name: b['name'] as String,
            band: bandFromName(b['band'] as String?),
            pricePence: (b['price_pence'] as num).toInt(),
          ),
      ],
    );
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
    billingInterval: row['billing_interval'] as String? ?? 'monthly',
    discountPercent: (row['discount_percent'] as num?)?.toInt() ?? 0,
    discountEndsAt: row['discount_ends_at'] == null
        ? null
        : DateTime.parse(row['discount_ends_at'] as String),
    currentPricePence: (row['current_price_pence'] as num?)?.toInt(),
    billingNotice: row['billing_notice'] as String?,
  );
}
