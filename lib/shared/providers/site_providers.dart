import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/site.dart';
import '../repositories/organisation_repository.dart';
import '../repositories/site_repository.dart';
import 'auth_providers.dart' show currentUserProvider;
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

// Branding inheritance (Part E) — the logged-in user's own site, for
// showing "which branch is this" on the home screen. Deliberately
// different from currentSiteProvider above (which always resolves to the
// first-created site regardless of who's logged in) — a regional/
// executive user's own siteId still points at wherever their own account
// is homed, and that's the specific name this screen needs.
final currentUserSiteProvider = FutureProvider<Site?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final repository = ref.watch(siteRepositoryProvider);
  return repository.getById(user.siteId);
});
