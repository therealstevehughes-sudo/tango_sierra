import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/task_template_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskTemplateRepositoryProvider = Provider<TaskTemplateRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskTemplateRepository(db);
});
