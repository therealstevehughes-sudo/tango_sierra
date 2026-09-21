// GoCardless billing (2026-09-21) — pure-model coverage for
// effectiveBillingState(), since it's the one place that decides whether
// an overdue account is still fully usable (grace period) or restricted.
import 'package:flutter_application_1/shared/models/subscription.dart';
import 'package:flutter_application_1/shared/services/billing_service.dart';
import 'package:flutter_test/flutter_test.dart';

Subscription _subscription({
  required String status,
  DateTime? lastPaymentFailedAt,
}) {
  return Subscription(
    id: 1,
    organisationId: 1,
    status: status,
    lastPaymentFailedAt: lastPaymentFailedAt,
  );
}

void main() {
  final now = DateTime(2026, 9, 21, 12);

  test('trialing is normal, regardless of anything else', () {
    final subscription = _subscription(status: 'trialing');
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.normal,
    );
  });

  test('active is normal', () {
    final subscription = _subscription(status: 'active');
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.normal,
    );
  });

  test('past_due with no failure timestamp recorded yet is normal', () {
    final subscription = _subscription(status: 'past_due');
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.normal,
    );
  });

  test('past_due, 1 day since failure, is still in the grace period', () {
    final subscription = _subscription(
      status: 'past_due',
      lastPaymentFailedAt: now.subtract(const Duration(days: 1)),
    );
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.pastDueGrace,
    );
  });

  test('past_due, 13 days since failure, is still in the grace period', () {
    final subscription = _subscription(
      status: 'past_due',
      lastPaymentFailedAt: now.subtract(const Duration(days: 13)),
    );
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.pastDueGrace,
    );
  });

  test('past_due, exactly 14 days since failure, is restricted', () {
    final subscription = _subscription(
      status: 'past_due',
      lastPaymentFailedAt: now.subtract(const Duration(days: 14)),
    );
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.restricted,
    );
  });

  test('past_due, well past 14 days, is restricted', () {
    final subscription = _subscription(
      status: 'past_due',
      lastPaymentFailedAt: now.subtract(const Duration(days: 30)),
    );
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.restricted,
    );
  });

  test('cancelled is restricted immediately, no grace period at all', () {
    final subscription = _subscription(status: 'cancelled');
    expect(
      effectiveBillingState(subscription, now: now),
      BillingState.restricted,
    );
  });

  test(
    'cancelled is restricted even with a very recent failure timestamp '
    '(a deliberate mandate cancellation is never treated as a blip)',
    () {
      final subscription = _subscription(
        status: 'cancelled',
        lastPaymentFailedAt: now,
      );
      expect(
        effectiveBillingState(subscription, now: now),
        BillingState.restricted,
      );
    },
  );
}
