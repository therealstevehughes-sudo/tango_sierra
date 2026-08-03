import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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

// Resolves the first-created site — the only site that existed until
// Sprint 025, and still the correct default for every install with just
// one site.
final currentSiteProvider = FutureProvider<Site>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return repository.getDefault();
});

// Which site a top/mid-tier user is actively managing (Sprint 025's
// minimal site-context fix). Null until explicitly set via Venue Details'
// "Set as Active" action — venue_setup_wizard_screen.dart's create call
// sites fall back to currentSiteProvider's default when this is null, so
// single-site installs behave exactly as before. This does NOT filter any
// read (getAll()-style queries remain unfiltered by site) — see Sprint
// 025's DECISIONS_LOG entry for the disclosed limitation.
final activeSiteProvider = StateProvider<Site?>((ref) => null);
