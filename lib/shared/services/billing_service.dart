import '../models/subscription.dart';

// GoCardless billing (2026-09-21) -- the one place that turns a
// Subscription's raw stored facts into an actual access decision.
// Deliberately computed at read time from `status`/`lastPaymentFailedAt`,
// not a separately-stored "current state" flag kept in sync by a cron job
// -- mirrors DueStatusService's own "compute overdue on read" approach,
// which this app already relies on elsewhere. Agreed grace-period model:
//   trialing / active           -> normal, full access
//   past_due, < 14 days         -> pastDueGrace: full access + a banner
//   past_due, >= 14 days        -> restricted: read-only
//   cancelled (mandate pulled)  -> restricted immediately, no grace —
//                                  a deliberate stop, not a billing blip
enum BillingState { normal, pastDueGrace, restricted }

const _gracePeriod = Duration(days: 14);

BillingState effectiveBillingState(Subscription subscription, {DateTime? now}) {
  // Free-access override (2026-09-25) — see Subscription.freeAccessGranted's
  // own doc comment. Checked first, before any real billing fact.
  if (subscription.freeAccessGranted) return BillingState.normal;

  final at = now ?? DateTime.now();
  if (subscription.status == 'cancelled') return BillingState.restricted;
  if (subscription.status != 'past_due') return BillingState.normal;

  final failedAt = subscription.lastPaymentFailedAt;
  if (failedAt == null) return BillingState.normal;
  return at.difference(failedAt) >= _gracePeriod
      ? BillingState.restricted
      : BillingState.pastDueGrace;
}
