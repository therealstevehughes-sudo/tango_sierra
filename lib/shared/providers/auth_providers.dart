import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftUserRepository(db);
});

final staffDirectoryProvider = FutureProvider<List<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAll();
});

final currentUserProvider = StateProvider<User?>((ref) => null);
