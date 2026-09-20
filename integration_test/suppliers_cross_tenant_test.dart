// Suppliers backend migration (2026-09-20) — live-backend cross-tenant
// proof, to the same standard as every other backend cluster (curl proof,
// verbatim results in DECISIONS_LOG.md, PLUS this real Dart
// SupplierRepository/SupabaseSupplierRepository exercise).
//
// Hand-obtained GoTrue tokens for a throwaway tenant pair, created live via
// tenant-signup immediately before this test was written:
//   Tenant A: org 44 / site 49 / director user 46 (supplier id 1 exists:
//     "Supplier A1")
//   Tenant B: org 45 / site 50 / director user 47 (supplier id 2 exists:
//     "Supplier B1")
// Fixture deleted from the server directly after this proof; kept in the
// repo per the B2–B5 / Issues & Incidents precedent (real tokens,
// short-lived, already expired by the time anyone reads this).
//
// Run: flutter test integration_test/suppliers_cross_tenant_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/backend_rest_client.dart';
import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/supplier.dart';
import 'package:flutter_application_1/shared/models/supplier_category.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/supplier_providers.dart';

const _tokenA =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTkwMDMyNX1dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0NCwicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoic3VwcGxpZXJzcHJvb2YuYUBleGFtcGxlLmNvbSIsImV4cCI6MTc4OTkwMzkyNSwiaWF0IjoxNzg5OTAwMzI1LCJpc19hbm9ueW1vdXMiOmZhbHNlLCJpc3MiOiJodHRwczovL2FwaS52ZW51cml0ZS5jb20vYXV0aC92MSIsInBob25lIjoiIiwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJzZXNzaW9uX2lkIjoiNGE0NzI0MTgtODNhOS00Zjk1LWFjYmItMGJlYWQwNmFjZTE3Iiwic3ViIjoiODk2OTg5MmYtNTRiNS00YzYxLWJlZGEtZWQ1MjU5ZTIyOWMzIiwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX19.wOJPEyT5aUKMVLvHvm-iwfjsXPfMhOk6r1p7R0ebPbM';
const _tokenB =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTkwMDMzOH1dLCJhcHBfbWV0YWRhdGEiOnsib3JnYW5pc2F0aW9uX2lkIjo0NSwicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdLCJyb2xlX3RpZXIiOiJleGVjdXRpdmUifSwiYXVkIjoiYXV0aGVudGljYXRlZCIsImVtYWlsIjoic3VwcGxpZXJzcHJvb2YuYkBleGFtcGxlLmNvbSIsImV4cCI6MTc4OTkwMzkzOCwiaWF0IjoxNzg5OTAwMzM4LCJpc19hbm9ueW1vdXMiOmZhbHNlLCJpc3MiOiJodHRwczovL2FwaS52ZW51cml0ZS5jb20vYXV0aC92MSIsInBob25lIjoiIiwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJzZXNzaW9uX2lkIjoiMzRiZWZjMDItOWFmYy00MjNhLTk1MDAtNzM2NWY3NmM3ZmI0Iiwic3ViIjoiNjY5OWFjYWYtOTQyNC00MzRkLWEwOGYtZmUzNDI3MDMwZDEwIiwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX19.knEfA_ss45kL30l0Fiji4ekrNhpu1_mMy_bktOPkSHA';

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
    'Suppliers: getForSite never returns the other tenant\'s supplier, '
    'even when explicitly asked for the other tenant\'s own site id',
    (tester) async {
      final repoA = containerA.read(supplierRepositoryProvider);

      final ownSuppliers = await repoA.getForSite(49);
      expect(ownSuppliers.length, 1);
      expect(ownSuppliers.single.siteId, 49);
      expect(ownSuppliers.single.name, 'Supplier A1');

      // Asking the REPOSITORY (not raw curl) for tenant B's own site id --
      // RLS filters server-side regardless of what the client asks for.
      final crossTenantQuery = await repoA.getForSite(50);
      expect(crossTenantQuery, isEmpty);
    },
  );

  testWidgets(
    'Suppliers: create() at the other tenant\'s site is rejected by the '
    'server, not silently accepted by the client',
    (tester) async {
      final repoA = containerA.read(supplierRepositoryProvider);

      await expectLater(
        repoA.create(
          name: 'HOSTILE cross-tenant supplier via repository',
          category: SupplierCategory.other,
          approvalStatus: SupplierApprovalStatus.approved,
          siteId: 50,
        ),
        throwsA(isA<BackendRequestException>()),
      );
    },
  );

  testWidgets(
    'Suppliers: updateDetails()/setApprovalStatus()/setActive() on the '
    'other tenant\'s supplier id silently affect nothing, and the target '
    'supplier is provably untouched afterward',
    (tester) async {
      final repoA = containerA.read(supplierRepositoryProvider);
      final repoB = containerB.read(supplierRepositoryProvider);

      // None of these throw -- PostgREST's RLS-filtered UPDATE just
      // matches 0 rows, same shape as every other cross-tenant write
      // proof this project has already run (issues, departments, etc.).
      await repoA.updateDetails(
        2,
        name: 'HACKED',
        category: SupplierCategory.other,
      );
      await repoA.setApprovalStatus(2, SupplierApprovalStatus.suspended);
      await repoA.setActive(2, false);

      // Confirm from the OWNER's own session that tenant B's supplier
      // still shows its real original state, not anything the hostile
      // calls above tried to write.
      final stillB = await repoB.getForSite(50);
      expect(stillB.single.name, 'Supplier B1');
      expect(stillB.single.approvalStatus, SupplierApprovalStatus.approved);
      expect(stillB.single.active, isTrue);
    },
  );
}
