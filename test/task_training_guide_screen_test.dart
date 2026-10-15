// "How to do this correctly" screen (2026-10-15) — pins what a worker and
// a manager each see: the standard guide by default, the venue's own
// version when one is saved, and the Edit/Reset controls only for
// venueManager and above.
//
// Run: flutter test test/task_training_guide_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:venurite/features/tasks/task_model.dart';
import 'package:venurite/features/tasks/training/task_training_guide.dart';
import 'package:venurite/features/tasks/training/task_training_guide_screen.dart';
import 'package:venurite/l10n/app_localizations.dart';
import 'package:venurite/shared/models/user.dart';
import 'package:venurite/shared/providers/auth_providers.dart';
import 'package:venurite/features/tasks/training/training_progress.dart';
import 'package:venurite/shared/providers/task_training_guide_providers.dart';
import 'package:venurite/shared/providers/training_progress_providers.dart';
import 'package:venurite/shared/repositories/task_training_guide_repository.dart';
import 'package:venurite/shared/repositories/training_progress_repository.dart';

class _FakeRepo implements TaskTrainingGuideRepository {
  _FakeRepo(this.venueGuide);

  VenueTrainingGuide? venueGuide;

  @override
  Future<VenueTrainingGuide?> getForTask(int siteId, int templateGroupId) async =>
      venueGuide;

  @override
  Future<List<VenueTrainingGuide>> getForSite(int siteId) async =>
      venueGuide == null ? const [] : [venueGuide!];

  @override
  Future<void> save({
    required int siteId,
    required int templateGroupId,
    required TaskTrainingGuide guide,
    required int updatedByUserId,
  }) async {}

  @override
  Future<void> resetToStandard(int siteId, int templateGroupId) async {
    venueGuide = null;
  }
}

class _FakeProgress implements TrainingProgressRepository {
  final acks = <TrainingAcknowledgement>[];

  @override
  Future<List<TrainingAcknowledgement>> getAcknowledgementsForUser(
    int userId,
  ) async => acks.where((a) => a.userId == userId).toList();

  @override
  Future<void> acknowledge({
    required int userId,
    required int siteId,
    required int templateGroupId,
    required String guideVersion,
  }) async => acks.add(
    TrainingAcknowledgement(
      userId: userId,
      siteId: siteId,
      templateGroupId: templateGroupId,
      guideVersion: guideVersion,
      acknowledgedAt: DateTime(2026, 10, 15),
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _task = ResolvedTask(
  templateGroupId: 7,
  title: 'Fridge temperature',
  segment: 'Kitchen',
  method: 'data_photo',
  requiresPhoto: true,
  requiresNotes: false,
  isCritical: true,
  requiresCorrectiveActionOnFail: true,
  assignedByUserId: 1,
);

Future<void> _pump(
  WidgetTester tester, {
  required RoleTier tier,
  VenueTrainingGuide? venueGuide,
  _FakeProgress? progress,
}) async {
  tester.view.physicalSize = const Size(1000, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUserProvider.overrideWith(
          (ref) => User(
            id: 5,
            name: 'Sam',
            jobTitle: 'Chef',
            roleTier: tier,
            siteId: 3,
          ),
        ),
        taskTrainingGuideRepositoryProvider.overrideWithValue(
          _FakeRepo(venueGuide),
        ),
        trainingProgressRepositoryProvider.overrideWithValue(
          progress ?? _FakeProgress(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TaskTrainingGuideScreen(task: _task),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('worker sees the standard guide, no edit controls', (
    tester,
  ) async {
    await _pump(tester, tier: RoleTier.base);
    expect(find.text('STANDARD GUIDE'), findsOneWidget);
    expect(find.textContaining('Pass at 8°C or below'), findsOneWidget);
    expect(find.text('Why it matters'), findsOneWidget);
    expect(find.text('If it fails'), findsOneWidget);
    expect(find.text('Edit for this venue'), findsNothing);
  });

  testWidgets('manager sees Edit, and Reset only on a venue version', (
    tester,
  ) async {
    await _pump(tester, tier: RoleTier.venueManager);
    expect(find.text('Edit for this venue'), findsOneWidget);
    expect(find.text('Reset to standard guide'), findsNothing);

    await _pump(
      tester,
      tier: RoleTier.venueManager,
      venueGuide: const VenueTrainingGuide(
        siteId: 3,
        templateGroupId: 7,
        guide: TaskTrainingGuide(steps: ['Use the blue probe in drawer 2.']),
      ),
    );
    expect(find.text("THIS VENUE'S GUIDE"), findsOneWidget);
    expect(find.text('Use the blue probe in drawer 2.'), findsOneWidget);
    expect(find.text('Reset to standard guide'), findsOneWidget);
  });

  testWidgets('worker can mark the guide read and understood', (
    tester,
  ) async {
    final progress = _FakeProgress();
    await _pump(tester, tier: RoleTier.base, progress: progress);
    await tester.tap(find.text("I've read and understood this"));
    await tester.pumpAndSettle();
    expect(progress.acks, hasLength(1));
    expect(progress.acks.single.templateGroupId, 7);
    expect(find.textContaining('You read and understood this'), findsOneWidget);
  });
}
