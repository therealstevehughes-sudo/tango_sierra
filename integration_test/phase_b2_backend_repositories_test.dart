// Phase B2 — proves the actual Dart repository/provider wiring added this
// phase (BackendRestClient, the Supabase*Repository classes, the
// backendDataEnabledProvider switch) genuinely talks to the real live
// backend correctly — distinct from Phase B1/B2's SQL-level RLS proof
// (curl, verbatim results in BACKEND_INFRA.md), which already proved the
// server-side policies themselves. This test proves the new CODE built on
// top of that is wired correctly, real network, no mocks.
//
// Uses a hand-crafted, short-lived HS256 token for a throwaway tenant
// (Org C / Site C1, plus Org D / Site D1 for the cross-tenant check) —
// the app can never mint its own tokens (no JWT_SECRET access, correctly
// so), so this fixture token was signed server-side and is only valid
// for a limited window. All throwaway rows are deleted from the server
// directly after this test is run; kept in the repo per the Phase 2
// precedent for real-backend integration tests (needs internet).
//
// Run: flutter test integration_test/phase_b2_backend_repositories_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/backend_rest_client.dart';
import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/department_providers.dart';
import 'package:flutter_application_1/shared/providers/site_providers.dart';

// Throwaway fixture — Org C (id 5) / Site C1 (id 10), Org D (id 6) /
// Site D1 (id 11), created directly on the server for this test only.
const _branchC1Token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImF1ZCI6ImF1dGhlbnRpY2F0ZWQiLCJzdWIiOiJiMi1kYXJ0dGVzdC1icmFuY2gtYzEiLCJhcHBfbWV0YWRhdGEiOnsicm9sZV90aWVyIjoiYmFzZSIsInNpdGVfaWQiOjEwLCJsb2NhbF91c2VyX2lkIjo5MjAxLCJvcmdhbmlzYXRpb25faWQiOjUsInJlZ2lvbl9pZCI6bnVsbH0sImlhdCI6MTc4ODg3MTk0NSwiZXhwIjoxNzg4OTU4MzQ1fQ.4wh6T5T7z3DVwbWbOUBoVEzM_wnbH3yisGNVhAREins';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUpAll(() async {
    await initSupabase();
  });

  setUp(() {
    container = ProviderContainer(
      overrides: [backendDataEnabledProvider.overrideWithValue(true)],
    );
    container.read(currentSessionTokenProvider.notifier).state =
        _branchC1Token;
  });

  tearDown(() => container.dispose());

  testWidgets('SupabaseOrganisationRepository sees only its own tenant', (
    tester,
  ) async {
    final repo = container.read(organisationRepositoryProvider);
    final orgs = await repo.getAll();
    expect(orgs.length, 1);
    expect(orgs.single.name, 'B2-DARTTEST-ORG-C');
  });

  testWidgets('SupabaseSiteRepository sees only its own site', (
    tester,
  ) async {
    final repo = container.read(siteRepositoryProvider);
    final sites = await repo.getAll();
    expect(sites.length, 1);
    expect(sites.single.name, 'B2-DARTTEST-SITE-C1');
  });

  testWidgets(
    'SupabaseSiteRepository.create() into a different tenant is rejected',
    (tester) async {
      final repo = container.read(siteRepositoryProvider);
      await expectLater(
        repo.create(name: 'HOSTILE SITE', organisationId: 6),
        throwsA(
          isA<BackendRequestException>().having(
            (e) => e.isRlsRejection,
            'isRlsRejection',
            true,
          ),
        ),
      );
    },
  );

  testWidgets('SupabaseDepartmentRepository sees only its own site\'s rows', (
    tester,
  ) async {
    final repo = container.read(departmentRepositoryProvider);
    final ownSite = await repo.getForSite(10);
    expect(ownSite.length, 1);
    expect(ownSite.single.name, 'B2-DARTTEST-DEPT');

    final otherTenantsSite = await repo.getForSite(11);
    expect(otherTenantsSite, isEmpty);
  });
}
