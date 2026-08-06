import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/venue_type_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final venueTypeRepositoryProvider = Provider<VenueTypeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftVenueTypeRepository(db);
});
