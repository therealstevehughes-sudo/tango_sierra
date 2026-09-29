import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_provider.dart';
import '../repositories/drift_service_provider_repository.dart';
import '../repositories/service_provider_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

// Dual-mode (2026-09-29) — same shape as every other repository in this
// app: Drift locally (private contacts only, no cross-org sharing — see
// DriftServiceProviderRepository's own doc comment), Supabase once a real
// backend account is signed in (full directory: blur/unlock/rate across
// organisations).
final serviceProviderRepositoryProvider = Provider<ServiceProviderRepository>(
  (ref) {
    if (ref.watch(backendDataEnabledProvider)) {
      return SupabaseServiceProviderRepository(
        ref.watch(backendRestClientProvider),
      );
    }
    return DriftServiceProviderRepository(ref.watch(appDatabaseProvider));
  },
);

final myServiceProvidersProvider = FutureProvider<List<ServiceProvider>>(
  (ref) => ref.watch(serviceProviderRepositoryProvider).getMyProviders(),
);

final sharedProviderDirectoryProvider =
    FutureProvider<List<SharedProviderListing>>(
      (ref) =>
          ref.watch(serviceProviderRepositoryProvider).getSharedDirectory(),
    );

final providerReviewsProvider = FutureProvider.family<List<ProviderReview>, int>(
  (ref, providerId) =>
      ref.watch(serviceProviderRepositoryProvider).getReviews(providerId),
);

final unlocksThisMonthProvider = FutureProvider<int>(
  (ref) => ref.watch(serviceProviderRepositoryProvider).getUnlocksThisMonth(),
);
