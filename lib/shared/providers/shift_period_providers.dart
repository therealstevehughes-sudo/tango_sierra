import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shift_period.dart';
import '../repositories/shift_period_repository.dart';
import '../repositories/supabase_shift_period_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final shiftPeriodRepositoryProvider = Provider<ShiftPeriodRepository>(
  (ref) => SupabaseShiftPeriodRepository(ref.watch(backendRestClientProvider)),
);

final shiftPeriodsForSiteProvider =
    FutureProvider.family<List<ShiftPeriod>, int>(
      (ref, siteId) =>
          ref.watch(shiftPeriodRepositoryProvider).getForSite(siteId),
    );
