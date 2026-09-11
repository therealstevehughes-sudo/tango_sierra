// Phase C1c — proves the actual Dart repository/screen-layer code
// (RegionRepository.create, TenantProvisioningRepository.inviteSenior,
// SiteRepository.create with regionId) against the live backend,
// including the exact case that was broken and fixed this cluster: a
// legitimate authenticated INSERT with RETURNING on regions/sites.
//
// Signs up a real throwaway company via signUpCompany (the actual C1b
// path), then as that Director: creates a region, invites a regional
// manager, creates a branch (site) in-region and one org-wide (no
// region), and confirms the regional's session sees ONLY the in-region
// branch and ONLY its own region. Deleted from the server afterward.
//
// Run: flutter test integration_test/phase_c1c_region_branch_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/site_providers.dart';
import 'package:flutter_application_1/shared/providers/tenant_provisioning_providers.dart';

final _unique = DateTime.now().millisecondsSinceEpoch;
final _directorEmail = 'c1c-it-director-$_unique@venurite.invalid';
final _regionalEmail = 'c1c-it-regional-$_unique@venurite.invalid';
const _directorPassword = 'ThrowawayC1cDirector!2026';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initSupabase();
  });

  testWidgets(
    'Director creates a region, invites a regional manager, creates '
    'branches -- the regional sees only its own region and branch',
    (tester) async {
      final director = ProviderContainer(
        overrides: [
          backendDataEnabledProvider.overrideWithValue(true),
          backendAuthEnabledProvider.overrideWithValue(true),
        ],
      );
      addTearDown(director.dispose);

      // 1. Real signup path (C1b), as the Director.
      final signup = await director
          .read(tenantProvisioningRepositoryProvider)
          .signUpCompany(
            companyName: 'C1C-IT-COMPANY-$_unique',
            directorName: 'IT Director',
            email: _directorEmail,
            password: _directorPassword,
          );
      final signIn = await supabase.auth
          .signInWithPassword(email: _directorEmail, password: _directorPassword);
      director.read(currentSessionTokenProvider.notifier).state =
          signIn.session!.accessToken;

      // 2. THE FIX UNDER TEST: a real authenticated region create (was
      // broken -- INSERT ... RETURNING failed the self-referential USING
      // check for the executive branch of can_access_region()).
      final region = await director
          .read(regionRepositoryProvider)
          .create(name: 'C1C-IT-REGION', organisationId: signup.organisationId);
      expect(region.id, greaterThan(0));

      // 3. Invite a regional manager for that region.
      final invite = await director
          .read(tenantProvisioningRepositoryProvider)
          .inviteSenior(
            email: _regionalEmail,
            name: 'IT Regional',
            roleTier: 'regional',
            organisationId: signup.organisationId,
            regionId: region.id,
          );
      expect(invite.localUserId, greaterThan(0));

      // 4. Two branches: one IN the region, one org-wide (no region) --
      // also exercises the fix for a legitimate executive site create.
      final inRegionSite = await director.read(siteRepositoryProvider).create(
            name: 'C1C-IT-SITE-IN-REGION',
            organisationId: signup.organisationId,
            regionId: region.id,
          );
      await director.read(siteRepositoryProvider).create(
            name: 'C1C-IT-SITE-NO-REGION',
            organisationId: signup.organisationId,
          );

      await supabase.auth.signOut();

      // 5. Sign in as the new regional manager and prove isolation at
      // THIS layer too, not just curl.
      final regional = ProviderContainer(
        overrides: [
          backendDataEnabledProvider.overrideWithValue(true),
          backendAuthEnabledProvider.overrideWithValue(true),
        ],
      );
      addTearDown(regional.dispose);
      final regionalSignIn = await supabase.auth.signInWithPassword(
        email: _regionalEmail,
        password: invite.temporaryPassword,
      );
      regional.read(currentSessionTokenProvider.notifier).state =
          regionalSignIn.session!.accessToken;

      final regionalUser = await regional
          .read(userRepositoryProvider)
          .findBySupabaseUserId(regionalSignIn.user!.id);
      expect(regionalUser, isNotNull);
      expect(regionalUser!.roleTier.name, 'regional');
      expect(regionalUser.regionId, region.id);

      final regionalSites = await regional.read(siteRepositoryProvider).getAll();
      expect(regionalSites.length, 1);
      expect(regionalSites.single.id, inRegionSite.id);

      final regionalRegions =
          await regional.read(regionRepositoryProvider).getForOrganisation(
                signup.organisationId,
              );
      expect(regionalRegions.length, 1);
      expect(regionalRegions.single.id, region.id);

      await supabase.auth.signOut();
    },
  );
}
