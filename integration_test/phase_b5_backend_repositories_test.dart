// Phase B5 — proves the actual Dart repository/provider wiring for the
// Live/transactional cluster against the live backend: the audit backbone
// (TaskSubmissions) round-trips correctly and stays tenant-isolated, the
// denormalised fields don't leak across the boundary, and EquipmentInstances
// (the B2 deferral, now backend-hosted) is scoped too. Distinct from the
// SQL-level RLS proof (curl, verbatim results in BACKEND_INFRA.md).
//
// Hand-crafted short-lived token for a throwaway tenant pair (Org I /
// Site I1 with one seeded user, Org J / Site J1 with a seeded FAIL
// submission carrying denormalised fields). Fixture deleted from the
// server directly after; kept in the repo per the B2–B4 precedent.
//
// Run: flutter test integration_test/phase_b5_backend_repositories_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/task_submission.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/task_submission_providers.dart';
import 'package:flutter_application_1/shared/providers/venue_setup_providers.dart';

// Throwaway fixture — Org I (17) / Site I1 (25) / user id 8, Org J (18) /
// Site J1 (26) / task_submission id 5 (FAIL, denormalised fields set).
const _branchIToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImF1ZCI6ImF1dGhlbnRpY2F0ZWQiLCJzdWIiOiJiNWRhcnQtaSIsImFwcF9tZXRhZGF0YSI6eyJyb2xlX3RpZXIiOiJiYXNlIiwic2l0ZV9pZCI6MjUsImxvY2FsX3VzZXJfaWQiOjk4MDEsIm9yZ2FuaXNhdGlvbl9pZCI6MTcsInJlZ2lvbl9pZCI6bnVsbH0sImlhdCI6MTc4OTAxNjUyNCwiZXhwIjoxNzg5MTAyOTI0fQ.AE-wCjI76KUu15UW5A6qpj98--duYlFNKqtQd9CUPX8';

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
    container.read(currentSessionTokenProvider.notifier).state = _branchIToken;
  });

  tearDown(() => container.dispose());

  testWidgets(
    'TaskSubmissions: append a submission, read it back, and never see '
    'the other tenant\'s — including its denormalised fields',
    (tester) async {
      final repo = container.read(taskSubmissionRepositoryProvider);

      // Start clean for this tenant.
      final before = await repo.getAll();
      expect(before, isEmpty);

      // Append an audit record (append-only write path).
      final newId = await repo.submit(
        TaskSubmission(
          taskTitle: 'I-tenant check',
          status: 'PASS',
          completedBy: 'B5-DARTTEST-USER-I',
          completedAt: DateTime.utc(2026, 1, 1),
          photoAttached: false,
          completedByUserId: 8,
          siteId: 25,
          equipmentInstanceName: 'I-FRIDGE (denorm)',
        ),
      );
      expect(newId, greaterThan(0));

      // Read back: exactly our own row, denormalised field intact.
      final after = await repo.getAll();
      expect(after.length, 1);
      expect(after.single.siteId, 25);
      expect(after.single.equipmentInstanceName, 'I-FRIDGE (denorm)');

      // The other tenant's FAIL (id 5) must be invisible — no leak of its
      // denormalised completed_by / equipment_instance_name either.
      final crossTenant = await repo.getByDateRange(
        DateTime.utc(2000),
        DateTime.utc(2100),
      );
      expect(crossTenant.every((s) => s.siteId == 25), true);
      expect(
        crossTenant.any((s) => s.completedBy.contains('USER-J')),
        false,
      );
      expect(
        crossTenant.any(
          (s) => (s.equipmentInstanceName ?? '').contains('J-FRIDGE'),
        ),
        false,
      );
    },
  );

  testWidgets(
    'EquipmentInstances (B2 deferral, now backend-hosted): create at own '
    'site works, cross-tenant write is rejected',
    (tester) async {
      final repo = container.read(equipmentRepositoryProvider);

      final created = await repo.create(
        name: 'B5-DARTTEST-FRIDGE-I',
        equipmentTypeId: 4,
        siteId: 25,
      );
      expect(created.siteId, 25);

      final mine = await repo.getAll();
      expect(mine.every((e) => e.siteId == 25), true);

      await expectLater(
        repo.create(
          name: 'HOSTILE-J-FRIDGE',
          equipmentTypeId: 4,
          siteId: 26,
        ),
        throwsA(anything),
      );
    },
  );
}
