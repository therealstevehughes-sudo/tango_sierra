import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/off_day_request.dart';
import '../repositories/off_day_request_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final offDayRequestRepositoryProvider = Provider<OffDayRequestRepository>(
  (ref) =>
      SupabaseOffDayRequestRepository(ref.watch(backendRestClientProvider)),
);

final offDayRequestsForSiteProvider =
    FutureProvider.family<List<OffDayRequest>, int>(
      (ref, siteId) =>
          ref.watch(offDayRequestRepositoryProvider).getForSite(siteId),
    );

final offDayRequestsForUserProvider =
    FutureProvider.family<List<OffDayRequest>, int>(
      (ref, userId) =>
          ref.watch(offDayRequestRepositoryProvider).getForUser(userId),
    );
