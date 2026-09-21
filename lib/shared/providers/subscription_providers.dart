import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subscription.dart';
import '../repositories/subscription_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;
import 'site_providers.dart' show currentOrganisationIdProvider;

final subscriptionRepositoryProvider = Provider<SupabaseSubscriptionRepository>(
  (ref) => SupabaseSubscriptionRepository(ref.watch(backendRestClientProvider)),
);

/// Watches the signed-in organisation's own subscription row. Null while
/// there's no organisation on the session yet, or the row genuinely
/// doesn't exist (shouldn't happen for a real backend-hosted org --
/// tenant-signup always creates one).
final currentSubscriptionProvider = FutureProvider<Subscription?>((ref) async {
  final organisationId = await ref.watch(currentOrganisationIdProvider.future);
  if (organisationId == null) return null;
  return ref.watch(subscriptionRepositoryProvider).getForOrganisation(organisationId);
});
