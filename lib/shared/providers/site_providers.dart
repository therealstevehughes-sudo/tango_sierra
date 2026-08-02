import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/site.dart';
import '../repositories/organisation_repository.dart';
import '../repositories/site_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final organisationRepositoryProvider = Provider<OrganisationRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftOrganisationRepository(db);
});

final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSiteRepository(db);
});

// No site-switcher UI exists yet (deferred per the multi-site foundation
// plan) — this simply resolves the one auto-seeded default site.
final currentSiteProvider = FutureProvider<Site>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return repository.getDefault();
});
