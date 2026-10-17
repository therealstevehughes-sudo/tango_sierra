// One-sided limits (2026-10-17): fridge checks have only a maximum, cooking
// checks only a minimum. Both must still ask for a reading and judge it.
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/tasks/task_model.dart';

ResolvedTask _task({double? min, double? max}) => ResolvedTask(
  templateGroupId: 1,
  title: 'Check',
  segment: 'food_safety',
  method: 'data',
  requiresPhoto: false,
  requiresNotes: false,
  minLimit: min,
  maxLimit: max,
  isCritical: true,
  requiresCorrectiveActionOnFail: true,
  assignedByUserId: 1,
);

void main() {
  test('fridge (max only) asks for a reading and judges it', () {
    final fridge = _task(max: 8);
    expect(fridge.hasNumericRange, isTrue);
    expect(fridge.withinLimits(4.5), isTrue);
    expect(fridge.withinLimits(8), isTrue);
    expect(fridge.withinLimits(9.1), isFalse);
  });

  test('cooking (min only) asks for a reading and judges it', () {
    final cooked = _task(min: 70);
    expect(cooked.hasNumericRange, isTrue);
    expect(cooked.withinLimits(74), isTrue);
    expect(cooked.withinLimits(65), isFalse);
  });

  test('a range checks both ends', () {
    final dishwasher = _task(min: 55, max: 65);
    expect(dishwasher.withinLimits(60), isTrue);
    expect(dishwasher.withinLimits(50), isFalse);
    expect(dishwasher.withinLimits(70), isFalse);
  });

  test('no limits means no reading', () {
    expect(_task().hasNumericRange, isFalse);
  });
}
