// Phase C1a — proves the SEED_DEMO_DATA compile-time flag gates the fake
// company / venue / people, while leaving shipped reference content
// (equipment types, venue types, the ~150-task library) always seeded.
//
// Run it BOTH ways:
//   flutter test integration_test/phase_c1a_seed_gating_test.dart -d windows
//   flutter test integration_test/phase_c1a_seed_gating_test.dart -d windows --dart-define=SEED_DEMO_DATA=false
//
// Each run asserts the state that matches the flag it was built with, so
// together they prove the gate works in both directions. Uses an
// in-memory database (AppDatabase.forTesting) — never touches the real
// on-device file.
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/config/build_flags.dart';
import 'package:flutter_application_1/core/storage/app_database.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // Force beforeOpen to run.
    await db.customSelect('SELECT 1').get();
  });

  tearDown(() => db.close());

  test('shipped reference content is always seeded, regardless of the flag',
      () async {
    final equipmentTypes = await db.select(db.equipmentTypes).get();
    final venueTypes = await db.select(db.venueTypes).get();
    final taskTemplates = await db.select(db.taskTemplates).get();

    expect(equipmentTypes.length, greaterThan(50));
    expect(venueTypes.length, greaterThanOrEqualTo(12));
    expect(taskTemplates.length, greaterThan(100));
  });

  test('demo company / venue / people follow the SEED_DEMO_DATA flag',
      () async {
    final orgs = await db.select(db.organisations).get();
    final sites = await db.select(db.sites).get();
    final users = await db.select(db.users).get();
    final presets = await db.select(db.taskPresets).get();
    // The segment/equipment presets ("Wash-up Tasks", "Ice Machine
    // Tasks", ...) are seeded by the task-library cluster load — that's
    // reference content, not demo data. Only "Standard Fridge Tasks", the
    // one illustrative example, is gated by the flag.
    final hasExamplePreset =
        presets.any((p) => p.name == 'Standard Fridge Tasks');

    if (kSeedDemoData) {
      expect(orgs, isNotEmpty, reason: 'demo build seeds a company');
      expect(sites, isNotEmpty, reason: 'demo build seeds a venue');
      expect(users, isNotEmpty, reason: 'demo build seeds staff');
      expect(hasExamplePreset, true,
          reason: 'demo build seeds the "Standard Fridge Tasks" example');
    } else {
      expect(orgs, isEmpty, reason: 'real build opens with no company');
      expect(sites, isEmpty, reason: 'real build opens with no venue');
      expect(users, isEmpty, reason: 'real build opens with no staff');
      expect(hasExamplePreset, false,
          reason: 'real build seeds no illustrative example preset');
      // Cluster-seeded reference presets DO still exist.
      expect(presets, isNotEmpty,
          reason: 'task-library segment presets are reference content');
    }
  });
}
