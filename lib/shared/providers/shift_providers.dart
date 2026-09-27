import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shift.dart';
import '../repositories/shift_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => SupabaseShiftRepository(ref.watch(backendRestClientProvider)),
);

/// Watches a site's shifts, newest-starting-first-loaded. Callers reload
/// by invalidating this provider after a mutation (post/claim/cancel),
/// same pattern as every other screen-local list in this app.
final shiftsForSiteProvider = FutureProvider.family<List<Shift>, int>(
  (ref, siteId) => ref.watch(shiftRepositoryProvider).getForSite(siteId),
);
