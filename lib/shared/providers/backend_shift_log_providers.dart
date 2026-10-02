import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/backend_shift_log_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final backendShiftLogRepositoryProvider = Provider<BackendShiftLogRepository>(
  (ref) =>
      SupabaseBackendShiftLogRepository(ref.watch(backendRestClientProvider)),
);
