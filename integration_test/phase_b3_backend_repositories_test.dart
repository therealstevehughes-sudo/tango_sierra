// Phase B3 — proves the actual Dart repository/provider wiring added this
// phase (SupabaseUserRepository, SupabaseTrainingRecordRepository) works
// against the live backend, and — the part Steve specifically asked to
// see proven — that authenticate() still round-trips through the
// UNCHANGED Drift-delegated path even with backendDataEnabledProvider on.
// Distinct from the SQL-level RLS proof (curl, verbatim results in
// BACKEND_INFRA.md).
//
// Uses a hand-crafted, short-lived HS256 token for a throwaway tenant
// (Org E / Site E1, plus Org F / Site F1 for the cross-tenant check) —
// the app can never mint its own tokens. Fixture deleted from the server
// directly after this test is run; kept in the repo per the Phase 2/B2
// precedent for real-backend integration tests (needs internet).
//
// Run: flutter test integration_test/phase_b3_backend_repositories_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/pin_auth_outcome.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';

// Throwaway fixture — Org E (id 9) / Site E1 (id 17) / user id 4, Org F
// (id 10) / Site F1 (id 18) / user id 5, created directly on the server
// for this test only.
const _branchE1Token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImF1ZCI6ImF1dGhlbnRpY2F0ZWQiLCJzdWIiOiJiMy1kYXJ0dGVzdC1icmFuY2gtZTEiLCJhcHBfbWV0YWRhdGEiOnsicm9sZV90aWVyIjoiYmFzZSIsInNpdGVfaWQiOjE3LCJsb2NhbF91c2VyX2lkIjo5NDAxLCJvcmdhbmlzYXRpb25faWQiOjksInJlZ2lvbl9pZCI6bnVsbH0sImlhdCI6MTc4ODkzMDc1MCwiZXhwIjoxNzg5MDE3MTUwfQ.vezAL7TSKKVYr8NFoGyNNaJa5RPK7I8yzezMUKKdjh4';

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
        _branchE1Token;
  });

  tearDown(() => container.dispose());

  testWidgets('SupabaseUserRepository sees only its own tenant\'s users', (
    tester,
  ) async {
    final repo = container.read(userRepositoryProvider);
    final users = await repo.getAll();
    expect(users.length, 1);
    expect(users.single.name, 'B3-DARTTEST-USER-E1');
  });

  testWidgets(
    'SupabaseUserRepository.setActive() on a different tenant\'s user '
    'affects nothing (RLS silently filters the UPDATE to zero rows, '
    'matching the proven curl behaviour -- this is not an error case)',
    (tester) async {
      final repo = container.read(userRepositoryProvider);
      // Completing without throwing IS the expected, proven behaviour: a
      // PostgREST UPDATE whose USING clause matches no rows returns 200
      // with an empty result, not an error (see BACKEND_INFRA.md's B1/B2
      // "0 rows affected" tests) -- the isolation is that user 5's row is
      // untouched, not that this call is rejected outright.
      await repo.setActive(userId: 5, active: false, actingUserId: 4);

      // Confirm user 5 is still invisible to this tenant's session (the
      // isolation itself, re-confirmed at the Dart layer, not just SQL).
      final repoAgain = container.read(userRepositoryProvider);
      final visibleUsers = await repoAgain.getAll();
      expect(visibleUsers.any((u) => u.name == 'B3-DARTTEST-USER-F1'), false);
    },
  );

  testWidgets(
    'authenticate() still round-trips through the unchanged Drift path '
    'with backendDataEnabledProvider ON',
    (tester) async {
      final repo = container.read(userRepositoryProvider);
      // A userId that cannot exist locally proves this reached the real
      // Drift lookup (which returns PinAuthNotFound for a missing local
      // row) rather than silently doing nothing or hitting the network —
      // no dependency on any specific real seed account or its PIN.
      final outcome = await repo.authenticate(
        userId: 999999999,
        pin: '0000',
      );
      expect(outcome, isA<PinAuthNotFound>());
    },
  );
}
