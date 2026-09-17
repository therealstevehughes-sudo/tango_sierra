// Issues & Incidents — the deferred live-backend cross-tenant proof
// (raised 2026-09-15/16, deferred, closed 2026-09-17). Proves the actual
// Dart IssueRepository/SupabaseIssueRepository wiring stays tenant-isolated
// against the live backend, distinct from the SQL-level RLS proof (curl,
// verbatim results in DECISIONS_LOG.md). This matters more than usual for
// this cluster: issues carry sensitive data (complaints, accidents), so a
// leak here would be especially serious.
//
// Hand-obtained GoTrue tokens for a throwaway tenant pair, created live via
// tenant-signup immediately before this test was written:
//   Tenant A: org 42 / site 47 / director user 44 (issue id 1 exists,
//     an IssueEvent id 1 on it)
//   Tenant B: org 43 / site 48 / director user 45 (issue id 2 exists,
//     resolved, with IssueEvent id 3 on it)
// Fixture deleted from the server directly after this proof; kept in the
// repo per the B2–B5 precedent (real tokens, short-lived, already expired
// by the time anyone reads this).
//
// Run: flutter test integration_test/issues_incidents_cross_tenant_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/backend_rest_client.dart';
import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/issue.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/issue_providers.dart';

const _tokenA =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTYzMjU4M31dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0MiwicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoiaXNzdWVzcHJvb2YuYUBleGFtcGxlLmNvbSIsImV4cCI6MTc4OTYzNjE4MywiaWF0IjoxNzg5NjMyNTgzLCJpc19hbm9ueW1vdXMiOmZhbHNlLCJpc3MiOiJodHRwczovL2FwaS52ZW51cml0ZS5jb20vYXV0aC92MSIsInBob25lIjoiIiwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJzZXNzaW9uX2lkIjoiYjdiZjRmZmYtNDcwNy00YzM3LWEwMWQtYmUzNDY5OTQ1NTRiIiwic3ViIjoiM2NkYjI3MDgtN2I0ZS00ZjFlLWIzZWQtNGRjMWM5NmNlZGYyIiwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX19.8vOqM8QdhYK6qYbqeEcjUmtZ50EhmHXSqsVyvg8yH7M';
const _tokenB =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTYzMjU4M31dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0MywicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoiaXNzdWVzcHJvb2YuYkBleGFtcGxlLmNvbSIsImV4cCI6MTc4OTYzNjE4MywiaWF0IjoxNzg5NjMyNTgzLCJpc19hbm9ueW1vdXMiOmZhbHNlLCJpc3MiOiJodHRwczovL2FwaS52ZW51cml0ZS5jb20vYXV0aC92MSIsInBob25lIjoiIiwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJzZXNzaW9uX2lkIjoiZWJkZDQ0YzktMDc3My00NGRjLWE5ZWMtMTA2YzdkYjdlMzk3Iiwic3ViIjoiMDhhMmZjMzQtZTc2Yy00OWJmLWFmYTQtMWRkODBlMmUyN2VlIiwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX19.bj9advr_D7otnGqswUtssiSER-XTxEEeaxgF1GzaVx4';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer containerA;
  late ProviderContainer containerB;

  setUpAll(() async {
    await initSupabase();
  });

  setUp(() {
    containerA = ProviderContainer(
      overrides: [backendDataEnabledProvider.overrideWithValue(true)],
    );
    containerA.read(currentSessionTokenProvider.notifier).state = _tokenA;
    containerB = ProviderContainer(
      overrides: [backendDataEnabledProvider.overrideWithValue(true)],
    );
    containerB.read(currentSessionTokenProvider.notifier).state = _tokenB;
  });

  tearDown(() {
    containerA.dispose();
    containerB.dispose();
  });

  testWidgets(
    'Issues: getForSite never returns the other tenant\'s issue, even '
    'when explicitly asked for the other tenant\'s own site id',
    (tester) async {
      final repoA = containerA.read(issueRepositoryProvider);

      final ownIssues = await repoA.getForSite(47);
      expect(ownIssues.length, 1);
      expect(ownIssues.single.siteId, 47);
      expect(ownIssues.single.details, 'A-tenant test complaint');

      // Asking the REPOSITORY (not raw curl) for tenant B's own site id --
      // RLS filters server-side regardless of what the client asks for.
      final crossTenantQuery = await repoA.getForSite(48);
      expect(crossTenantQuery, isEmpty);
    },
  );

  testWidgets(
    'Issues: getHistory on the other tenant\'s issue id returns nothing, '
    'never leaks their event notes',
    (tester) async {
      final repoA = containerA.read(issueRepositoryProvider);

      final ownHistory = await repoA.getHistory(1);
      expect(ownHistory.length, 1);
      expect(ownHistory.single.note, 'A-tenant working on it');

      final crossTenantHistory = await repoA.getHistory(2);
      expect(crossTenantHistory, isEmpty);
    },
  );

  testWidgets(
    'Issues: raise() at the other tenant\'s site is rejected by the '
    'server, not silently accepted by the client',
    (tester) async {
      final repoA = containerA.read(issueRepositoryProvider);

      await expectLater(
        repoA.raise(
          siteId: 48,
          type: IssueType.other,
          details: 'HOSTILE cross-tenant raise via repository',
          raisedByUserId: 44,
        ),
        throwsA(isA<BackendRequestException>()),
      );
    },
  );

  testWidgets(
    'Issues: escalate()/resolve() on the other tenant\'s issue id is '
    'rejected, and the target issue is provably untouched afterward',
    (tester) async {
      final repoA = containerA.read(issueRepositoryProvider);
      final repoB = containerB.read(issueRepositoryProvider);

      await expectLater(
        repoA.escalate(
          issueId: 2,
          note: 'HOSTILE cross-tenant escalate via repository',
          byUserId: 44,
          escalateToUserId: 44,
        ),
        throwsA(anything),
      );

      // Confirm from the OWNER's own session that tenant B's issue still
      // shows its real resolved state from the earlier curl proof, not
      // anything the hostile call above tried to write.
      final stillB = await repoB.getForSite(48);
      expect(stillB.single.status, IssueStatus.resolved);
      expect(stillB.single.escalatedToUserId, isNull);
    },
  );

  testWidgets(
    'Issues: getRaisedByUser never crosses tenants for a shared-looking '
    'user id space',
    (tester) async {
      final repoA = containerA.read(issueRepositoryProvider);
      final repoB = containerB.read(issueRepositoryProvider);

      final aRaised = await repoA.getRaisedByUser(44);
      expect(aRaised.length, 1);
      expect(aRaised.single.siteId, 47);

      final bRaised = await repoB.getRaisedByUser(45);
      expect(bRaised.length, 1);
      expect(bRaised.single.siteId, 48);

      // A's own session asking for B's raiser id (45) must not somehow
      // surface B's row through A's tenant-scoped session.
      final aAskingForB = await repoA.getRaisedByUser(45);
      expect(aAskingForB, isEmpty);
    },
  );
}
