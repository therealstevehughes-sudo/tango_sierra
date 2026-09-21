// GoCardless billing (2026-09-21) -- mirrors public.subscriptions exactly.
// Backend-only concept: a local-only install has no subscription row at
// all (see SubscriptionRepository's own doc comment) -- this model and
// its repository are never touched unless backendDataEnabledProvider is on.
class Subscription {
  final int id;
  final int organisationId;
  // 'trialing' | 'active' | 'past_due' | 'cancelled' -- the raw fact
  // GoCardless/tenant-signup recorded. Never read directly to decide
  // whether someone can use the app right now -- see
  // billing_service.dart's effectiveBillingState(), which is the one
  // place that turns this plus lastPaymentFailedAt into an actual
  // access decision (computed at read time, same pattern
  // DueStatusService already uses for overdue tasks -- no cron needed).
  final String status;
  final String? planName;
  final DateTime? trialEndsAt;
  final DateTime? currentPeriodEnd;
  final String? paymentProvider;
  final String? providerCustomerId;
  final String? providerSubscriptionId;
  final String? gocardlessMandateId;
  final String? mandateStatus;
  final DateTime? lastPaymentFailedAt;
  final DateTime? restrictedAt;

  const Subscription({
    required this.id,
    required this.organisationId,
    required this.status,
    this.planName,
    this.trialEndsAt,
    this.currentPeriodEnd,
    this.paymentProvider,
    this.providerCustomerId,
    this.providerSubscriptionId,
    this.gocardlessMandateId,
    this.mandateStatus,
    this.lastPaymentFailedAt,
    this.restrictedAt,
  });
}

// Friendly labels for wherever a plan is shown to a user -- the stored
// key (`planName`) never changes, only what's rendered.
String planDisplayName(String? planName) {
  switch (planName) {
    case 'friends':
      return 'Friends';
    case 'standard':
      return 'Standard';
    case 'premier':
      return 'Premier';
    default:
      return planName ?? 'No plan selected';
  }
}

// Kept in sync with the price the gocardless-confirm-mandate Edge
// Function actually charges (BACKEND_INFRA.md) -- shown to the user
// before they authorize anything, never guessed at or left blank. null
// means "no price set yet" (currently true only for 'premier').
int? planMonthlyPricePence(String? planName) {
  switch (planName) {
    case 'friends':
      return 1900;
    case 'standard':
      return 3900;
    default:
      return null;
  }
}
