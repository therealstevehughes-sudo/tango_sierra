import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shift_requirement.dart';
import '../repositories/shift_requirement_repository.dart';
import '../repositories/supabase_shift_requirement_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final shiftRequirementRepositoryProvider =
    Provider<ShiftRequirementRepository>(
      (ref) => SupabaseShiftRequirementRepository(
        ref.watch(backendRestClientProvider),
      ),
    );

final shiftRequirementsForSiteProvider =
    FutureProvider.family<List<ShiftRequirement>, int>(
      (ref, siteId) =>
          ref.watch(shiftRequirementRepositoryProvider).getForSite(siteId),
    );
