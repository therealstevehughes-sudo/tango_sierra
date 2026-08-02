import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/third_party_contact_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final thirdPartyContactRepositoryProvider =
    Provider<ThirdPartyContactRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return DriftThirdPartyContactRepository(db);
    });
