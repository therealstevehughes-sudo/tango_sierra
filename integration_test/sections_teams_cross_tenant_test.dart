// Sections/Teams backend cluster (2026-09-20) — live-backend cross-tenant
// proof, to the same standard as every other backend cluster (curl proof,
// verbatim results in DECISIONS_LOG.md, PLUS this real
// TeamRepository/SupervisionRepository exercise). Closes the "not yet
// done" item logged in BACKEND_INFRA.md's Sections/Teams entry.
//
// Hand-obtained GoTrue tokens for a throwaway tenant pair, created live via
// tenant-signup immediately before this test was written:
//   Tenant A: org 46 / site 51 / director user 48
//     Department "Kitchen A" id=5, Team "Night Team A" id=1
//     supervised_departments id=1 (user 48 -> dept 5)
//     supervised_teams id=1 (user 48 -> team 1)
//   Tenant B: org 47 / site 52 / director user 49
//     Department "Kitchen B" id=6, Team "Night Team B" id=2
//     supervised_departments id=2 (user 49 -> dept 6)
//     supervised_teams id=2 (user 49 -> team 2)
// Fixture deleted from the server directly after this proof; kept in the
// repo per the Suppliers/B2-B5/Issues & Incidents precedent (real tokens,
// short-lived, already expired by the time anyone reads this).
//
// Run: flutter test integration_test/sections_teams_cross_tenant_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/backend_rest_client.dart';
import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/supervision_providers.dart';
import 'package:flutter_application_1/shared/providers/team_providers.dart';

const _tokenA =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTkwMzc5NH1dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0NiwicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoidGVhbXMtaXQtYS0xNzg5OTAzNzgzQHZlbnVyaXRlLmludmFsaWQiLCJleHAiOjE3ODk5MDczOTQsImlhdCI6MTc4OTkwMzc5NCwiaXNfYW5vbnltb3VzIjpmYWxzZSwiaXNzIjoiaHR0cHM6Ly9hcGkudmVudXJpdGUuY29tL2F1dGgvdjEiLCJwaG9uZSI6IiIsInJvbGUiOiJhdXRoZW50aWNhdGVkIiwic2Vzc2lvbl9pZCI6IjZiZTc2NjgyLTY5MmItNDY1NC1hNTQ3LTA5MTg0NGMzYzJmOCIsInN1YiI6ImQxY2E5NjRiLWJjMmYtNDA2Ni1iN2E5LWNkMDgyN2Y1YjIwNyIsInVzZXJfbWV0YWRhdGEiOnsiZW1haWxfdmVyaWZpZWQiOnRydWV9fQ.9Cl1HtkMI78K-ejYWDYGFGlFn_OCQ3C1YxBwMk4ELfo';
const _tokenB =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTkwMzc5NH1dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0NywicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoidGVhbXMtaXQtYi0xNzg5OTAzNzgzQHZlbnVyaXRlLmludmFsaWQiLCJleHAiOjE3ODk5MDczOTQsImlhdCI6MTc4OTkwMzc5NCwiaXNfYW5vbnltb3VzIjpmYWxzZSwiaXNzIjoiaHR0cHM6Ly9hcGkudmVudXJpdGUuY29tL2F1dGgvdjEiLCJwaG9uZSI6IiIsInJvbGUiOiJhdXRoZW50aWNhdGVkIiwic2Vzc2lvbl9pZCI6IjY4ZGRhN2FiLTY4Y2MtNDdhYi04MjRiLTc1ZTU1MWFiODRmNiIsInN1YiI6IjdmOGFjN2IwLWIzMGEtNGEzNS1hYWFlLTBkNzI0ZmVkNTMxNyIsInVzZXJfbWV0YWRhdGEiOnsiZW1haWxfdmVyaWZpZWQiOnRydWV9fQ.cHVP7IFvJuYmIj84x1Tndor7VCgE2ugH6B7J4VGUyLE';

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
    'Teams: getForDepartment never returns the other tenant\'s team, even '
    'when explicitly asked for the other tenant\'s own department id',
    (tester) async {
      final repoA = containerA.read(teamRepositoryProvider);

      final own = await repoA.getForDepartment(5);
      expect(own.length, 1);
      expect(own.single.name, 'Night Team A');

      final crossTenant = await repoA.getForDepartment(6);
      expect(crossTenant, isEmpty);
    },
  );

  testWidgets(
    'Teams: create() under the other tenant\'s department is rejected by '
    'the server, not silently accepted by the client',
    (tester) async {
      final repoA = containerA.read(teamRepositoryProvider);

      await expectLater(
        repoA.create(name: 'HOSTILE cross-tenant team', departmentId: 6),
        throwsA(isA<BackendRequestException>()),
      );
    },
  );

  testWidgets(
    'Teams: rename()/setActive() on the other tenant\'s team id silently '
    'affect nothing, and the target team is provably untouched afterward',
    (tester) async {
      final repoA = containerA.read(teamRepositoryProvider);
      final repoB = containerB.read(teamRepositoryProvider);

      await repoA.rename(2, 'HACKED');
      await repoA.setActive(2, false);

      final stillB = await repoB.getForDepartment(6);
      expect(stillB.single.name, 'Night Team B');
      expect(stillB.single.active, isTrue);
    },
  );

  testWidgets(
    'SupervisionRepository: getSupervisedDepartmentIds/getSupervisedTeamIds '
    'never return the other tenant\'s scoping rows, even when asked for '
    'the other tenant\'s own user id',
    (tester) async {
      final repoA = containerA.read(supervisionRepositoryProvider);

      final ownDepts = await repoA.getSupervisedDepartmentIds(48);
      expect(ownDepts, [5]);
      final ownTeams = await repoA.getSupervisedTeamIds(48);
      expect(ownTeams, [1]);

      // Asking the REPOSITORY (not raw curl) for tenant B's own user id --
      // RLS filters server-side via the join to departments/teams
      // regardless of what the client asks for.
      final crossDepts = await repoA.getSupervisedDepartmentIds(49);
      expect(crossDepts, isEmpty);
      final crossTeams = await repoA.getSupervisedTeamIds(49);
      expect(crossTeams, isEmpty);
    },
  );

  testWidgets(
    'SupervisionRepository: setSupervisedDepartments()/setSupervisedTeams() '
    'cannot plant a hostile cross-tenant scoping row, and — a real bug '
    'found and fixed by this very test run — no longer destroys the '
    'caller\'s own existing rows when the cross-tenant half is rejected',
    (tester) async {
      final repoA = containerA.read(supervisionRepositoryProvider);
      final repoB = containerB.read(supervisionRepositoryProvider);

      // A tries to ADD B's department/team ids to its own user id's
      // supervision -- rejected by WITH CHECK since department/team 6/2
      // don't resolve under A's can_access_site().
      //
      // Real bug found here, now fixed: the original implementation
      // deleted every one of A's existing rows FIRST, then re-inserted
      // the new set one at a time -- so a rejected insert partway through
      // left A's real, legitimate supervision assignment already wiped,
      // with nothing restored (no client-side transaction over
      // PostgREST). Reordered to insert-before-delete: a rejection now
      // leaves A's existing rows completely untouched, confirmed below.
      await expectLater(
        repoA.setSupervisedDepartments(userId: 48, departmentIds: [5, 6]),
        throwsA(isA<BackendRequestException>()),
      );
      await expectLater(
        repoA.setSupervisedTeams(userId: 48, teamIds: [1, 2]),
        throwsA(isA<BackendRequestException>()),
      );

      // B's own scoping rows are untouched by A's attempts above.
      final stillBDepts = await repoB.getSupervisedDepartmentIds(49);
      expect(stillBDepts, [6]);
      final stillBTeams = await repoB.getSupervisedTeamIds(49);
      expect(stillBTeams, [2]);

      // A's own rows are still exactly what they were before the failed
      // call -- not wiped by it.
      final ownDepts = await repoA.getSupervisedDepartmentIds(48);
      expect(ownDepts, [5]);
      final ownTeams = await repoA.getSupervisedTeamIds(48);
      expect(ownTeams, [1]);
    },
  );
}
