// Phase C1d — proves the full cascade down to real staff PIN login,
// through the actual Dart repository code, live: signup -> region ->
// invite a regional -> regional creates a branch -> regional provisions a
// branch manager (venueManager) -> that branch manager's REAL PIN login
// via userRepositoryProvider.authenticate() (the backend-native path
// added this cluster) -> the branch manager provisions a base staff
// member -> that person's real PIN login too -> the branch manager's
// session sees only its own site's staff.
//
// This is also the specific thing asked to be shown: a real backend-only
// account (no local Drift row at all) can actually log in.
//
// Run: flutter test integration_test/phase_c1d_staff_provisioning_test.dart -d windows
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/shared/models/pin_auth_outcome.dart';
import 'package:flutter_application_1/shared/providers/auth_providers.dart';
import 'package:flutter_application_1/shared/providers/site_providers.dart';
import 'package:flutter_application_1/shared/providers/tenant_provisioning_providers.dart';

final _unique = DateTime.now().millisecondsSinceEpoch;
final _directorEmail = 'c1d-it-director-$_unique@venurite.invalid';
final _regionalEmail = 'c1d-it-regional-$_unique@venurite.invalid';
const _directorPassword = 'ThrowawayC1dDirector!2026';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initSupabase();
  });

  testWidgets(
    'full cascade: signup -> region -> regional -> branch -> branch '
    'manager -> real PIN login -> staff -> real PIN login -> isolation',
    (tester) async {
      final director = ProviderContainer(
        overrides: [
          backendDataEnabledProvider.overrideWithValue(true),
          backendAuthEnabledProvider.overrideWithValue(true),
        ],
      );
      addTearDown(director.dispose);

      final signup = await director
          .read(tenantProvisioningRepositoryProvider)
          .signUpCompany(
            companyName: 'C1D-IT-COMPANY-$_unique',
            country: 'United Kingdom',
            venueName: 'Main Site',
            firstName: 'IT',
            lastName: 'Director',
            email: _directorEmail,
            password: _directorPassword,
          );
      final dirSignIn = await supabase.auth
          .signInWithPassword(email: _directorEmail, password: _directorPassword);
      director.read(currentSessionTokenProvider.notifier).state =
          dirSignIn.session!.accessToken;

      final region = await director
          .read(regionRepositoryProvider)
          .create(name: 'C1D-IT-REGION', organisationId: signup.organisationId);

      final invite = await director
          .read(tenantProvisioningRepositoryProvider)
          .inviteSenior(
            email: _regionalEmail,
            name: 'IT Regional',
            roleTier: 'regional',
            organisationId: signup.organisationId,
            regionId: region.id,
          );
      await supabase.auth.signOut();

      // Regional: create a branch, provision a branch manager.
      final regional = ProviderContainer(
        overrides: [
          backendDataEnabledProvider.overrideWithValue(true),
          backendAuthEnabledProvider.overrideWithValue(true),
        ],
      );
      addTearDown(regional.dispose);
      final regSignIn = await supabase.auth.signInWithPassword(
        email: _regionalEmail,
        password: invite.temporaryPassword,
      );
      regional.read(currentSessionTokenProvider.notifier).state =
          regSignIn.session!.accessToken;

      final branch = await regional.read(siteRepositoryProvider).create(
            name: 'C1D-IT-BRANCH',
            organisationId: signup.organisationId,
            regionId: region.id,
          );

      final vmResult = await regional
          .read(tenantProvisioningRepositoryProvider)
          .provisionStaffPin(
            callerAccessToken: regSignIn.session!.accessToken,
            name: 'IT Branch Manager',
            jobTitle: 'Manager',
            roleTier: 'venueManager',
            siteId: branch.id,
          );
      await supabase.auth.signOut();

      // Branch manager: THE THING BEING PROVEN -- a real PIN login for an
      // account that has no local Drift row at all, via the actual
      // userRepositoryProvider.authenticate() backend-native path.
      final vmContainer = ProviderContainer(
        overrides: [backendDataEnabledProvider.overrideWithValue(true)],
      );
      addTearDown(vmContainer.dispose);
      final vmOutcome = await vmContainer.read(userRepositoryProvider).authenticate(
            userId: vmResult.localUserId,
            pin: vmResult.pin,
            useBackendAuth: true,
          );
      expect(vmOutcome, isA<PinAuthSuccess>());
      final vmSuccess = vmOutcome as PinAuthSuccess;
      expect(vmSuccess.user.roleTier.name, 'venueManager');
      expect(vmSuccess.accessToken, isNotNull);
      vmContainer.read(currentSessionTokenProvider.notifier).state =
          vmSuccess.accessToken;

      // Wrong PIN still correctly rejected through this same real path.
      final wrongOutcome = await vmContainer.read(userRepositoryProvider).authenticate(
            userId: vmResult.localUserId,
            pin: '0000',
            useBackendAuth: true,
          );
      expect(wrongOutcome, isA<PinAuthIncorrect>());

      // Branch manager provisions a base staff member.
      final baseResult = await vmContainer
          .read(tenantProvisioningRepositoryProvider)
          .provisionStaffPin(
            callerAccessToken: vmSuccess.accessToken!,
            name: 'IT Kitchen Porter',
            jobTitle: 'Kitchen Porter',
            roleTier: 'base',
            siteId: branch.id,
          );

      // That new person's own real PIN login also works.
      final baseContainer = ProviderContainer(
        overrides: [backendDataEnabledProvider.overrideWithValue(true)],
      );
      addTearDown(baseContainer.dispose);
      final baseOutcome = await baseContainer.read(userRepositoryProvider).authenticate(
            userId: baseResult.localUserId,
            pin: baseResult.pin,
            useBackendAuth: true,
          );
      expect(baseOutcome, isA<PinAuthSuccess>());

      // Isolation, at this layer: the branch manager's session sees
      // exactly its own site's two staff (itself + the porter).
      final staff = await vmContainer.read(userRepositoryProvider).getAll();
      expect(staff.length, 2);
      expect(staff.every((u) => u.siteId == branch.id), true);
    },
  );
}
