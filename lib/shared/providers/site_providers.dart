import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/site.dart';
import '../repositories/organisation_repository.dart';
import '../repositories/region_repository.dart';
import '../repositories/site_repository.dart';
import '../repositories/supabase_organisation_repository.dart';
import '../repositories/supabase_region_repository.dart';
import '../repositories/supabase_site_repository.dart';
import 'auth_providers.dart'
    show
        backendDataEnabledProvider,
        currentBackendOrganisationIdProvider,
        currentUserProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final organisationRepositoryProvider = Provider<OrganisationRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseOrganisationRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftOrganisationRepository(db);
});

// Sprint 034 fix (2026-09-14): `currentBackendOrganisationIdProvider` only
// resolves when there's a real backend JWT (Leadership Access via GoTrue,
// or a server-verified PIN session) — it decodes organisation_id straight
// out of the token. A LOCAL PIN-based executive/regional session
// (backendAuthEnabled false — every local/demo install, including the PIN
// fallback restored for Leadership Access) has no token at all, so every
// screen that read organisation id ONLY from that provider (Regions,
// Branches, the setup checklist, notification rules, task templates, venue
// types) broke the instant local senior sign-in became possible again —
// "No organisation on this session," even though a real local Organisation
// obviously exists. This provider is the one place that adds the missing
// fallback: the backend org id when a token exists, otherwise the local
// install's one Organisation (the same single-tenant-locally assumption
// `brandingConfigProvider` already makes via `getDefault()`), or null if
// running in real backend mode with no session yet (nothing to fall back
// to there — that's a genuine "not signed in").
final currentOrganisationIdProvider = FutureProvider<int?>((ref) async {
  final backendOrgId = ref.watch(currentBackendOrganisationIdProvider);
  if (backendOrgId != null) return backendOrgId;
  if (ref.watch(backendDataEnabledProvider)) return null;
  final org = await ref.watch(organisationRepositoryProvider).getDefault();
  return org.id;
});

final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseSiteRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftSiteRepository(db);
});

final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseRegionRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftRegionRepository(db);
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
  // siteId is null for a freshly signed-up executive (Phase C1b) who
  // hasn't created a branch yet — TierHomeScreen already handles a null
  // site here (shows no branch name rather than crashing).
  if (user?.siteId == null) return null;
  final repository = ref.watch(siteRepositoryProvider);
  return repository.getById(user!.siteId!);
});
