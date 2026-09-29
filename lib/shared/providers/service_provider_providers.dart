import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_provider.dart';
import '../repositories/service_provider_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final serviceProviderRepositoryProvider = Provider<ServiceProviderRepository>(
  (ref) => SupabaseServiceProviderRepository(
    ref.watch(backendRestClientProvider),
  ),
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
