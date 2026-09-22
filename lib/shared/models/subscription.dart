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
  // Discount applied (Sprint 043 pivot, 2026-09-22) — a valid "Friends"
  // code entered at Direct Debit setup drops the per-branch rate from
  // £39 to £19 (see gocardless-start-mandate's own doc comment). No
  // longer tied to sign-up at all -- the name is kept for the column,
  // but it no longer means "founding member".
  final bool foundingOffer;
  // Per-branch pricing (Sprint 043 pivot) -- how many branch-equivalent
  // units this organisation is actually billed for, already including
  // the automatic head-office unit at 4+ branches (see tenant-signup's
  // own doc comment for that threshold). Drives price display here
  // instead of planName, which is now always 'standard'.
  final int billedSiteCount;

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
    this.foundingOffer = false,
    this.billedSiteCount = 1,
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

// Per-branch pricing (Sprint 043 pivot, 2026-09-22) -- kept in sync with
// gocardless-confirm-mandate, the Edge Function that actually charges
// (BACKEND_INFRA.md): £39/branch/month standard, £19/branch/month once a
// valid discount code has been applied (subscriptions.founding_offer).
// [billedSiteCount] already includes the automatic head-office unit.
int totalMonthlyPricePence(int billedSiteCount, {bool foundingOffer = false}) {
  final perBranch = foundingOffer ? 1900 : 3900;
  return billedSiteCount * perBranch;
}
