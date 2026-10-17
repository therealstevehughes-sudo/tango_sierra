// Training quiz screen (2026-10-17): three questions, all must be right;
// a retry needs the guide read again first. The repository is faked, so
// this drives the real screen without a server.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/tasks/task_model.dart';
import 'package:venurite/features/tasks/training/task_quiz_screen.dart';
import 'package:venurite/features/tasks/training/task_training_guide.dart';
import 'package:venurite/features/tasks/training/training_progress.dart';
import 'package:venurite/l10n/app_localizations.dart';
import 'package:venurite/shared/providers/training_progress_providers.dart';
import 'package:venurite/shared/repositories/task_quiz_repository.dart';

class _FakeQuizzes implements TaskQuizRepository {
  _FakeQuizzes({this.passes = true, this.rereadFirst = false});

  final bool passes;
  final bool rereadFirst;
  List<int>? submitted;

  @override
  Future<QuizAttempt?> start({
    required int siteId,
    required int templateGroupId,
    required String taskTitle,
    required String guideVersion,
    required int userId,
  }) async {
    if (rereadFirst) throw const QuizRereadRequired();
    return const QuizAttempt(
      attemptId: 7,
      questions: [
        QuizQuestion(number: 1, text: 'Q one?', options: ['A1', 'B1', 'C1']),
        QuizQuestion(number: 2, text: 'Q two?', options: ['A2', 'B2', 'C2']),
        QuizQuestion(number: 3, text: 'Q three?', options: ['A3', 'B3', 'C3']),
      ],
    );
  }

  @override
  Future<QuizResult> submit({
    required int attemptId,
    required List<int> answers,
  }) async {
    submitted = answers;
    return passes
        ? const QuizResult(passed: true, correct: 3, total: 3, wrongQuestions: [])
        : const QuizResult(passed: false, correct: 2, total: 3, wrongQuestions: [3]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ResolvedTask _task() => ResolvedTask(
  templateGroupId: 1,
  title: 'Fridge temperature',
  segment: 'food_safety',
  method: 'data',
  requiresPhoto: false,
  requiresNotes: false,
  maxLimit: 8,
  isCritical: false,
  requiresCorrectiveActionOnFail: true,
  assignedByUserId: 1,
);

Future<void> _pump(WidgetTester tester, _FakeQuizzes fake) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [taskQuizRepositoryProvider.overrideWithValue(fake)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TaskQuizScreen(
          task: _task(),
          siteId: 1,
          userId: 1,
          guideVersion: guideVersion(const TaskTrainingGuide(steps: ['x'])),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _answerAll(WidgetTester tester) async {
  await tester.tap(find.text('B1'));
  await tester.tap(find.text('A2'));
  await tester.tap(find.text('C3'));
  await tester.pump();
}

void main() {
  testWidgets('check is disabled until every question is answered', (tester) async {
    await _pump(tester, _FakeQuizzes());
    final button = find.widgetWithText(FilledButton, 'Check my answers');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await _answerAll(tester);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });

  testWidgets('sends the chosen positions and shows a pass', (tester) async {
    final fake = _FakeQuizzes();
    await _pump(tester, fake);
    await _answerAll(tester);
    await tester.tap(find.text('Check my answers'));
    await tester.pumpAndSettle();
    expect(fake.submitted, [1, 0, 2]);
    expect(find.text('Passed - well done!'), findsOneWidget);
  });

  testWidgets('a fail says how many were right and to re-read', (tester) async {
    await _pump(tester, _FakeQuizzes(passes: false));
    await _answerAll(tester);
    await tester.tap(find.text('Check my answers'));
    await tester.pumpAndSettle();
    expect(find.text('Not quite - 2 of 3 right'), findsOneWidget);
    expect(find.textContaining('Read the guide again'), findsOneWidget);
  });

  testWidgets('a retry without re-reading is turned back', (tester) async {
    await _pump(tester, _FakeQuizzes(rereadFirst: true));
    expect(find.text('Read the guide again before you retry.'), findsOneWidget);
    expect(find.text('Back to the guide'), findsOneWidget);
  });
}
