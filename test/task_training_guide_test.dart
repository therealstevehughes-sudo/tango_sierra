import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/core/storage/task_enrichment_data.dart';
import 'package:venurite/features/tasks/task_model.dart';
import 'package:venurite/features/tasks/training/standard_guide_for.dart';
import 'package:venurite/features/tasks/training/task_training_guide.dart';
import 'package:venurite/features/tasks/training/task_training_guide_data.dart';

ResolvedTask _task({
  required String title,
  String method = 'tick',
  double? min,
  double? max,
  String? unit,
  String? guidance,
  String? fix,
}) => ResolvedTask(
  templateGroupId: 1,
  title: title,
  segment: '',
  method: method,
  requiresPhoto: method.contains('photo'),
  requiresNotes: false,
  minLimit: min,
  maxLimit: max,
  unit: unit,
  isCritical: false,
  requiresCorrectiveActionOnFail: false,
  fixInstructions: fix,
  guidanceText: guidance,
  assignedByUserId: 1,
);

void main() {
  test('every HORECA library task has a hand-written standard guide', () {
    final missing = taskEnrichmentData
        .map((r) => r.title)
        .where((t) => !standardTrainingGuides.containsKey(t))
        .toList();
    expect(missing, isEmpty);
  });

  test('every standard guide has steps, a why and an if-it-fails', () {
    standardTrainingGuides.forEach((title, g) {
      expect(g.steps, isNotEmpty, reason: title);
      expect(g.whyItMatters, isNotNull, reason: title);
      expect(g.ifItFails, isNotNull, reason: title);
    });
  });

  test('custom task falls back to a guide built from its own setup', () {
    final g = standardGuideFor(
      _task(
        title: 'Our own pizza oven check',
        method: 'data_photo',
        min: 300,
        unit: '°C',
        guidance: 'Use the infrared gun. Aim at the oven floor.',
        fix: 'Wait and re-check.',
      ),
    );
    expect(g.steps.first, 'Use the infrared gun.');
    expect(g.steps, contains('Take the reading and enter it. It must be 300°C or above.'));
    expect(g.steps, contains('Take a clear photo as proof.'));
    expect(g.ifItFails, 'Wait and re-check.');
  });

  test('venue guide JSON round-trips and drops blank steps', () {
    const g = TaskTrainingGuide(
      steps: ['One', 'Two'],
      whyItMatters: 'Because',
      ifItFails: null,
    );
    final back = TaskTrainingGuide.fromJson({
      ...g.toJson(),
      'steps': ['One', '  ', 'Two'],
    });
    expect(back.steps, ['One', 'Two']);
    expect(back.whyItMatters, 'Because');
    expect(back.ifItFails, isNull);
  });
}
