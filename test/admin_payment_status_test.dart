import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/admin/repositories/admin_repository.dart';

AdminOrgSummary _org({
  String? subscriptionStatus,
  DateTime? lastPaymentFailedAt,
  bool freeAccessGranted = false,
}) => AdminOrgSummary(
  id: 1,
  name: 'Test Co',
  billingEmail: null,
  ownerName: null,
  branchCount: 1,
  staffCount: 1,
  billedSiteCount: 1,
  rosterAddonEnabled: false,
  subscriptionStatus: subscriptionStatus,
  trialEndsAt: null,
  currentPeriodEnd: null,
  restrictedAt: null,
  freeAccessGranted: freeAccessGranted,
  lastPaymentFailedAt: lastPaymentFailedAt,
  serviceProviderUnlockCount: 0,
  createdAt: DateTime(2026, 1, 1),
  archivedAt: null,
);

void main() {
  group('computeAdminPaymentStatus', () {
    test('active with no failure is paid', () {
      expect(
        computeAdminPaymentStatus(_org(subscriptionStatus: 'active')),
        AdminPaymentStatus.paid,
      );
    });

    test('trialing is its own status, not paid', () {
      expect(
        computeAdminPaymentStatus(_org(subscriptionStatus: 'trialing')),
        AdminPaymentStatus.trialing,
      );
    });

    test('cancelled is always missed', () {
      expect(
        computeAdminPaymentStatus(_org(subscriptionStatus: 'cancelled')),
        AdminPaymentStatus.missed,
      );
    });

    test('past_due within the 14-day grace period is late', () {
      final now = DateTime(2026, 10, 2);
      final org = _org(
        subscriptionStatus: 'past_due',
        lastPaymentFailedAt: DateTime(2026, 10, 1),
      );
      expect(computeAdminPaymentStatus(org, now: now), AdminPaymentStatus.late);
    });

    test('past_due at exactly 14 days is missed, not late', () {
      final failedAt = DateTime(2026, 9, 18);
      final now = failedAt.add(const Duration(days: 14));
      final org = _org(
        subscriptionStatus: 'past_due',
        lastPaymentFailedAt: failedAt,
      );
      expect(computeAdminPaymentStatus(org, now: now), AdminPaymentStatus.missed);
    });

    test('past_due one day before the 14-day boundary is still late', () {
      final failedAt = DateTime(2026, 9, 18);
      final now = failedAt.add(const Duration(days: 13));
      final org = _org(
        subscriptionStatus: 'past_due',
        lastPaymentFailedAt: failedAt,
      );
      expect(computeAdminPaymentStatus(org, now: now), AdminPaymentStatus.late);
    });

    test('unknown subscription status falls back to unknown', () {
      expect(computeAdminPaymentStatus(_org()), AdminPaymentStatus.unknown);
    });
  });
}
