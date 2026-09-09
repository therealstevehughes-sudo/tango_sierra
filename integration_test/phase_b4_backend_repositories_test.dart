// Phase B4 — proves the actual Dart repository/provider wiring added this
// phase against the live backend, with special attention to the one thing
// Steve asked to see proven at THIS layer, not just SQL: the fork-on-write
// rule in SupabaseTaskTemplateRepository. Distinct from the SQL-level RLS
// proof (curl, verbatim results in BACKEND_INFRA.md), which already
// proved the policies themselves — this proves the app-layer code that
// decides whether to fork actually does so correctly.
//
// Uses hand-crafted, short-lived HS256 tokens for a throwaway tenant pair
// (Org G / Site G1, Org H / Site H1) plus one pre-seeded shared (null-org)
// task template — the app can never mint its own tokens. Fixture deleted
// from the server directly after this test is run; kept in the repo per
// the B2/B3 precedent for real-backend integration tests (needs internet).
//
// Run: flutter test integration_test/phase_b4_backend_repositories_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/task_template.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/task_schedule_providers.dart';
import 'package:flutter_application_1/shared/providers/task_template_providers.dart';

// Throwaway fixture — Org G (id 13) / Site G1 (id 21), Org H (id 14) /
// Site H1 (id 22), one shared task template (id 5, template_group_id 5,
// organisation_id null) created directly on the server for this test only.
const _branchGToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImF1ZCI6ImF1dGhlbnRpY2F0ZWQiLCJzdWIiOiJiNGRhcnQtYnJhbmNoX2ciLCJhcHBfbWV0YWRhdGEiOnsicm9sZV90aWVyIjoiYmFzZSIsInNpdGVfaWQiOjIxLCJsb2NhbF91c2VyX2lkIjo5NjAxLCJvcmdhbmlzYXRpb25faWQiOjEzLCJyZWdpb25faWQiOm51bGx9LCJpYXQiOjE3ODg5MzMwNTMsImV4cCI6MTc4OTAxOTQ1M30.-K_K8OkpJFaQUXKOV17HxiyRT_UFpTX9oMbOfyabkmY';
const _branchHToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImF1ZCI6ImF1dGhlbnRpY2F0ZWQiLCJzdWIiOiJiNGRhcnQtYnJhbmNoX2giLCJhcHBfbWV0YWRhdGEiOnsicm9sZV90aWVyIjoiYmFzZSIsInNpdGVfaWQiOjIyLCJsb2NhbF91c2VyX2lkIjo5NjAyLCJvcmdhbmlzYXRpb25faWQiOjE0LCJyZWdpb25faWQiOm51bGx9LCJpYXQiOjE3ODg5MzMwNTMsImV4cCI6MTc4OTAxOTQ1M30.9neGgHQUU9Ck24U2L47m7HAKnJPOGhdEMfoN5hAbSrY';
const _sharedTaskGroupId = 5;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initSupabase();
  });

  ProviderContainer containerFor(String token) {
    final c = ProviderContainer(
      overrides: [backendDataEnabledProvider.overrideWithValue(true)],
    );
    c.read(currentSessionTokenProvider.notifier).state = token;
    return c;
  }

  testWidgets(
    'FORK-ON-WRITE: editing a shared task from Org G forks to a private '
    'copy, leaving Org H\'s view of the shared original untouched',
    (tester) async {
      final gContainer = containerFor(_branchGToken);
      final hContainer = containerFor(_branchHToken);
      addTearDown(gContainer.dispose);
      addTearDown(hContainer.dispose);

      final gRepo = gContainer.read(taskTemplateRepositoryProvider);
      final hRepo = hContainer.read(taskTemplateRepositoryProvider);

      // Sanity: both tenants can currently see the shared task.
      final gBefore = await gRepo.getVersionHistory(_sharedTaskGroupId);
      final hBefore = await hRepo.getVersionHistory(_sharedTaskGroupId);
      expect(gBefore.length, 1);
      expect(hBefore.length, 1);

      // Org G "edits" the shared task — this must FORK, not extend.
      final result = await gRepo.saveNewVersion(
        templateGroupId: _sharedTaskGroupId,
        title: 'B4-DARTTEST-FORKED (Org G private edit)',
        segment: 'kitchen',
        applicableRoleTiers: const [],
        method: 'visual_check',
        requiresPhoto: false,
        requiresNotes: false,
        priority: TaskPriority.standard,
        requiresCorrectiveActionOnFail: false,
        // A real users.id is required (real FK) -- id 1 is the permanent
        // "RESERVED" placeholder row documented in BACKEND_INFRA.md's B3
        // section, safe to reference here (it's inert, not real data).
        createdByUserId: 1,
      );

      // The fork must NOT reuse the shared group id.
      expect(result.template.templateGroupId, isNot(_sharedTaskGroupId));

      // The shared chain itself must be completely unaffected.
      final gAfterShared = await gRepo.getVersionHistory(_sharedTaskGroupId);
      final hAfterShared = await hRepo.getVersionHistory(_sharedTaskGroupId);
      expect(gAfterShared.length, 1);
      expect(hAfterShared.length, 1);
      expect(hAfterShared.single.title, 'B4-DARTTEST-SHARED-TASK');

      // Org H must never see Org G's new private fork.
      final hAll = await hRepo.getAllCurrentVersions();
      expect(
        hAll.any((t) => t.templateGroupId == result.template.templateGroupId),
        false,
      );

      // Org G must see both the original shared task and its own fork.
      final gAll = await gRepo.getAllCurrentVersions();
      expect(gAll.any((t) => t.title == 'B4-DARTTEST-SHARED-TASK'), true);
      expect(
        gAll.any(
          (t) => t.title == 'B4-DARTTEST-FORKED (Org G private edit)',
        ),
        true,
      );
    },
  );

  testWidgets('SupabaseTaskScheduleRepository sees only its own tenant', (
    tester,
  ) async {
    final container = containerFor(_branchGToken);
    addTearDown(container.dispose);
    final repo = container.read(taskScheduleRepositoryProvider);
    final schedules = await repo.getAll();
    expect(schedules.every((s) => s.siteId == 21), true);
  });
}
