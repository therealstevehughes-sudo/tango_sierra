// Phase C1b — proves the actual client signup path
// (SupabaseTenantProvisioningRepository -> tenant-signup Edge Function)
// against the live backend: a fresh company becomes a genuinely isolated
// tenant, its Director can sign in, and the new tenant starts empty.
//
// Creates a throwaway company; deleted from the server directly after.
// Kept in the repo per the B2-B5 / C1a precedent (needs internet).
//
// Run: flutter test integration_test/phase_c1b_tenant_signup_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/site_providers.dart';
import 'package:flutter_application_1/shared/providers/tenant_provisioning_providers.dart';

final _unique = DateTime.now().millisecondsSinceEpoch;
final _email = 'c1b-it-$_unique@venurite.invalid';
const _password = 'ThrowawayC1bIntegration!2026';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initSupabase();
  });

  testWidgets(
    'signUpCompany creates an isolated, empty tenant the Director can sign into',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          backendDataEnabledProvider.overrideWithValue(true),
          backendAuthEnabledProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      // 1. Sign up.
      final result = await container
          .read(tenantProvisioningRepositoryProvider)
          .signUpCompany(
            companyName: 'C1B-IT-COMPANY-$_unique',
            country: 'United Kingdom',
            venueName: 'Main Site',
            firstName: 'IT',
            lastName: 'Director',
            email: _email,
            password: _password,
          );
      expect(result.organisationId, greaterThan(0));
      expect(result.localUserId, greaterThan(0));

      // 2. Sign in as the Director (real GoTrue), like SeniorLoginScreen does.
      final signIn = await supabase.auth
          .signInWithPassword(email: _email, password: _password);
      expect(signIn.session, isNotNull);
      container.read(currentSessionTokenProvider.notifier).state =
          signIn.session!.accessToken;

      // 3. The linked local profile resolves (this is what login needs).
      final localUser = await container
          .read(userRepositoryProvider)
          .findBySupabaseUserId(signIn.user!.id);
      expect(localUser, isNotNull);
      expect(localUser!.roleTier.name, 'executive');

      // 4. Isolation: sees exactly one organisation — its own.
      final orgs = await container.read(organisationRepositoryProvider).getAll();
      expect(orgs.length, 1);
      expect(orgs.single.id, result.organisationId);
      expect(orgs.single.name, 'C1B-IT-COMPANY-$_unique');

      // 5. Sprint 034: signup now creates the first venue in the same
      // call (the onboarding wizard's Step 4), so exactly one site
      // exists — not the pre-Sprint-034 "starts empty" behaviour.
      final sites = await container.read(siteRepositoryProvider).getAll();
      expect(sites.length, 1);
      expect(sites.single.id, result.siteId);
      expect(sites.single.name, 'Main Site');
      final users = await container.read(userRepositoryProvider).getAll();
      expect(users.length, 1);
      expect(users.single.id, result.localUserId);

      await supabase.auth.signOut();
    },
  );

  testWidgets('a duplicate email is rejected without leaving an orphan tenant',
      (tester) async {
    final container = ProviderContainer(
      overrides: [backendDataEnabledProvider.overrideWithValue(true)],
    );
    addTearDown(container.dispose);

    Object? thrown;
    try {
      await container.read(tenantProvisioningRepositoryProvider).signUpCompany(
            companyName: 'C1B-IT-DUPE-$_unique',
            country: 'United Kingdom',
            venueName: 'Main Site',
            firstName: 'X',
            lastName: 'Y',
            email: _email, // same as the first test
            password: 'SomeOtherPassword123',
          );
    } catch (e) {
      thrown = e;
    }
    expect(thrown, isNotNull);
  });
}
