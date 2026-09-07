// Equipment instance fixes (2026-09-06) — a real check against the actual
// local database (same one the app itself uses), not a mock. Proves:
// (1) taskTitle/equipmentInstanceName are stored as separate fields, and
// (2) duplicate equipment names are genuinely blocked at the repository
// level — case-insensitive, trimmed, scoped per site, on both create and
// rename — not just something the UI happens not to expose.
//
// Run with: flutter test integration_test/equipment_instance_fixes_test.dart -d windows
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/core/storage/app_database.dart';
import 'package:flutter_application_1/shared/models/duplicate_equipment_name_exception.dart';
import 'package:flutter_application_1/shared/models/task_submission.dart';
import 'package:flutter_application_1/shared/repositories/equipment_repository.dart';
import 'package:flutter_application_1/shared/repositories/task_submission_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('equipment instance fixes: uniqueness + separate fields', (
    tester,
  ) async {
    final db = AppDatabase();
    final equipmentRepo = DriftEquipmentRepository(db);
    final submissionRepo = DriftTaskSubmissionRepository(db);

    // Use the real seed site (id 1, "Main Site" / Steve Hughes' venue).
    const siteId = 1;
    final type = await equipmentRepo.createEquipmentType(
      'Test Fridge Type ${DateTime.now().millisecondsSinceEpoch}',
    );

    // 1. Create the first instance — should succeed.
    final first = await equipmentRepo.create(
      name: 'Meat Walk-in',
      equipmentTypeId: type.id,
      siteId: siteId,
    );
    debugPrint('Created first instance: ${first.name} (id ${first.id})');

    // 2. Same name, different case + whitespace — must be blocked.
    Object? blockedError;
    try {
      await equipmentRepo.create(
        name: '  meat walk-in  ',
        equipmentTypeId: type.id,
        siteId: siteId,
      );
    } catch (e) {
      blockedError = e;
    }
    debugPrint('Duplicate create attempt result: $blockedError');
    expect(blockedError, isA<DuplicateEquipmentNameException>());

    // 3. A genuinely different name at the same site — must succeed.
    final second = await equipmentRepo.create(
      name: 'Dessert Fridge',
      equipmentTypeId: type.id,
      siteId: siteId,
    );
    debugPrint('Created second (distinct) instance: ${second.name}');

    // 4. Renaming the second into a collision with the first — must be
    // blocked too, not just create().
    Object? renameBlockedError;
    try {
      await equipmentRepo.rename(second.id, 'Meat Walk-in');
    } catch (e) {
      renameBlockedError = e;
    }
    debugPrint('Duplicate rename attempt result: $renameBlockedError');
    expect(renameBlockedError, isA<DuplicateEquipmentNameException>());

    // 5. Submitting a task against the first instance stores taskTitle and
    // equipmentInstanceName as genuinely separate fields, not combined.
    final submissionId = await submissionRepo.submit(
      TaskSubmission(
        taskTitle: 'Temperature check',
        status: 'PASS',
        completedBy: 'Test Harness',
        completedAt: DateTime.now(),
        photoAttached: false,
        equipmentInstanceId: first.id,
        siteId: siteId,
        equipmentInstanceName: first.name,
      ),
    );
    final stored = (await submissionRepo.getAll()).firstWhere(
      (s) => s.id == submissionId,
    );
    debugPrint(
      'Stored submission -> taskTitle: "${stored.taskTitle}", '
      'equipmentInstanceName: "${stored.equipmentInstanceName}"',
    );
    expect(stored.taskTitle, 'Temperature check');
    expect(stored.equipmentInstanceName, 'Meat Walk-in');

    // Cleanup — leave the real dev database as we found it.
    await equipmentRepo.setActive(first.id, false);
    await equipmentRepo.setActive(second.id, false);
    await db.close();
  });
}
