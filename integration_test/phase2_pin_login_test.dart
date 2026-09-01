// Phase 2 (real backend auth) — a real, live-backend integration check,
// not a mock. Runs on the real Windows target with real plugins and real
// networking (unlike a plain `flutter test`, which fakes both), so this
// genuinely exercises: DriftUserRepository.authenticate ->
// supabase_flutter -> the real deployed pin-login Edge Function -> the
// real Postgres lockout function -> a real signed session token.
//
// Needs internet access and the test staff accounts already provisioned
// server-side (Steve Hughes, see BACKEND_INFRA.md's Phase 2 notes) — not
// something CI should run unattended, hence kept separate from the
// regular unit-test suite. Run with:
//   flutter test integration_test/phase2_pin_login_test.dart -d windows
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/network/supabase_client.dart';
import 'package:flutter_application_1/core/storage/app_database.dart';
import 'package:flutter_application_1/shared/models/pin_auth_outcome.dart';
import 'package:flutter_application_1/shared/repositories/user_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tap-name -> PIN -> real Supabase session round trip', (
    tester,
  ) async {
    await initSupabase();

    final db = AppDatabase();
    final repository = DriftUserRepository(db);

    // Link the known test account to its already-provisioned Supabase
    // identity, if not already linked (idempotent).
    await (db.update(db.users)..where((u) => u.id.equals(1))).write(
      const UsersCompanion(
        supabaseUserId: Value('16393d62-d0ca-48bb-9525-9e95144a4de5'),
      ),
    );

    debugPrint('--- Correct PIN (1111) for Steve Hughes, backend auth ON ---');
    final success = await repository.authenticate(
      userId: 1,
      pin: '1111',
      useBackendAuth: true,
    );
    debugPrint(success.toString());
    expect(success, isA<PinAuthSuccess>());
    final token = (success as PinAuthSuccess).accessToken;
    expect(token, isNotNull);
    expect(token, contains('.')); // looks like a JWT
    debugPrint('User: ${success.user.name} (${success.user.roleTier})');
    debugPrint('Access token (first 40 chars): ${token!.substring(0, 40)}...');

    debugPrint('\n--- Wrong PIN (0000) for Steve Hughes, backend auth ON ---');
    final wrong = await repository.authenticate(
      userId: 1,
      pin: '0000',
      useBackendAuth: true,
    );
    debugPrint(wrong.toString());
    expect(wrong, isA<PinAuthIncorrect>());

    debugPrint('\n--- Same login, backend auth OFF (existing local behaviour) ---');
    final localOnly = await repository.authenticate(userId: 1, pin: '1111');
    debugPrint(localOnly.toString());
    expect(localOnly, isA<PinAuthSuccess>());
    expect((localOnly as PinAuthSuccess).accessToken, isNull);

    await db.close();
  });
}
