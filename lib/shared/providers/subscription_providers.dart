import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subscription.dart';
import '../repositories/subscription_repository.dart';
import '../services/billing_service.dart';
import 'auth_providers.dart'
    show backendDataEnabledProvider, currentUserProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'site_providers.dart' show currentOrganisationIdProvider;

final subscriptionRepositoryProvider = Provider<SupabaseSubscriptionRepository>(
  (ref) => SupabaseSubscriptionRepository(ref.watch(backendRestClientProvider)),
);

/// Watches the signed-in organisation's own subscription row. Null while
/// there's no organisation on the session yet, or the row genuinely
/// doesn't exist (shouldn't happen for a real backend-hosted org --
/// tenant-signup always creates one).
/// Billing access (2026-10-17): whether the signed-in person may see the
/// Billing screen ([allowed]) and set up/change payment ([canManage],
/// Directors only). Asked of the server (my_billing_access) — never
/// inferred from data cached on the device. False/false in local mode.
final billingAccessProvider =
    FutureProvider<({bool allowed, bool canManage})>((ref) async {
      ref.watch(currentUserProvider);
      if (!ref.watch(backendDataEnabledProvider)) {
        return (allowed: false, canManage: false);
      }
      try {
        final rows = await ref
            .watch(backendRestClientProvider)
            .rpc('my_billing_access', {});
        if (rows.isEmpty) return (allowed: false, canManage: false);
        final row = rows.first as Map<String, dynamic>;
        return (
          allowed: row['allowed'] as bool? ?? false,
          canManage: row['can_manage'] as bool? ?? false,
        );
      } catch (_) {
        return (allowed: false, canManage: false);
      }
    });

final currentSubscriptionProvider = FutureProvider<Subscription?>((ref) async {
  final organisationId = await ref.watch(currentOrganisationIdProvider.future);
  if (organisationId == null) return null;
  return ref.watch(subscriptionRepositoryProvider).getForOrganisation(organisationId);
});

// Billing enforcement (2026-09-24) — the pressure-test audit's own
// disclosed gap: effectiveBillingState() correctly computes "restricted"
// but nothing actually blocked task submission for one. This is the one
// canonical answer to "should this org's writes be blocked right now" —
// every write chokepoint reads this instead of recomputing billing
// state itself. Local/demo installs (no billing concept at all -- see
// SubscriptionRepository's own doc comment) are never restricted.
// Deliberately fails OPEN (false) on any lookup error -- a transient
// network hiccup checking billing must never be the thing that stops
// kitchen staff recording a fridge temperature; real enforcement already
// happened server-side (the mandate was actually cancelled/past due),
// this is just reflecting that back, not the enforcement mechanism
// itself.
final isBillingRestrictedProvider = FutureProvider<bool>((ref) async {
  if (!ref.watch(backendDataEnabledProvider)) return false;
  try {
    final subscription = await ref.watch(currentSubscriptionProvider.future);
    if (subscription == null) return false;
    return effectiveBillingState(subscription) == BillingState.restricted;
  } catch (_) {
    return false;
  }
});
