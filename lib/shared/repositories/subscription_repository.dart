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
  Future<String> startDirectDebitSetup();
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
  Future<String> startDirectDebitSetup() async {
    final data = await _client.invokeFunction('gocardless-start-mandate', {});
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
    return redirectUrl;
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
  );
}
