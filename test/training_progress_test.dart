import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/tasks/training/task_training_guide.dart';
import 'package:venurite/features/tasks/training/training_progress.dart';

TrainingAcknowledgement _ack(String version) => TrainingAcknowledgement(
  userId: 1,
  siteId: 1,
  templateGroupId: 1,
  guideVersion: version,
  acknowledgedAt: DateTime(2026, 10, 1),
);

final _signoff = CompetenceSignoff(
  userId: 1,
  siteId: 1,
  templateGroupId: 1,
  signedOffByUserId: 2,
  signedOffAt: DateTime(2026, 10, 2),
);

TrainingStatus _status({
  bool critical = false,
  List<String> read = const [],
  bool signedOff = false,
}) => trainingStatusFor(
  isCritical: critical,
  currentVersion: 'v2',
  acknowledgements: read.map(_ack),
  signoff: signedOff ? _signoff : null,
);

void main() {
  test('guide version is stable and changes when the guide changes', () {
    const a = TaskTrainingGuide(steps: ['One'], whyItMatters: 'Why');
    const same = TaskTrainingGuide(steps: ['One'], whyItMatters: 'Why');
    const edited = TaskTrainingGuide(steps: ['One', 'Two'], whyItMatters: 'Why');
    expect(guideVersion(a), guideVersion(same));
    expect(guideVersion(a), isNot(guideVersion(edited)));
    expect(guideVersion(a), hasLength(8));
  });

  test('non-critical: not read -> read; old version -> updated', () {
    expect(_status(), TrainingStatus.notRead);
    expect(_status(read: ['v2']), TrainingStatus.read);
    expect(_status(read: ['v1']), TrainingStatus.updated);
  });

  test('critical: reading alone waits for a manager sign-off', () {
    expect(_status(critical: true, read: ['v2']), TrainingStatus.awaitingSignoff);
    expect(
      _status(critical: true, read: ['v2'], signedOff: true),
      TrainingStatus.competent,
    );
  });

  test('critical: a sign-off survives a guide edit but asks for a re-read', () {
    expect(
      _status(critical: true, read: ['v1'], signedOff: true),
      TrainingStatus.updated,
    );
  });

  group('quizzes', () {
    test('read but not passed -> quiz to do; passed -> trained', () {
      expect(_quizStatus(), TrainingStatus.quizDue);
      expect(
        _quizStatus(passes: [_pass('v2', DateTime(2026, 10, 2))]),
        TrainingStatus.read,
      );
    });

    test('a pass on an older guide does not count', () {
      expect(
        _quizStatus(passes: [_pass('v1', DateTime(2026, 10, 2))]),
        TrainingStatus.quizDue,
      );
    });

    test('critical: pass, then still needs the manager sign-off', () {
      final passed = [_pass('v2', DateTime(2026, 10, 2))];
      expect(
        _quizStatus(critical: true, passes: passed),
        TrainingStatus.awaitingSignoff,
      );
      expect(
        _quizStatus(critical: true, passes: passed, signedOff: true),
        TrainingStatus.competent,
      );
      expect(
        _quizStatus(critical: true, signedOff: true),
        TrainingStatus.quizDue,
      );
    });

    test('managers: no quiz on routine tasks, no sign-off on critical', () {
      expect(_quizStatus(manager: true), TrainingStatus.read);
      expect(_quizStatus(manager: true, critical: true), TrainingStatus.quizDue);
      expect(
        _quizStatus(
          manager: true,
          critical: true,
          passes: [_pass('v2', DateTime(2026, 10, 2))],
        ),
        TrainingStatus.read,
      );
    });

    test('a pass expires after the refresher period', () {
      final passed = [_pass('v2', DateTime(2026, 4, 2))];
      expect(
        _quizStatus(passes: passed, months: 6, now: DateTime(2026, 10, 1)),
        TrainingStatus.read,
      );
      expect(
        _quizStatus(passes: passed, months: 6, now: DateTime(2026, 10, 3)),
        TrainingStatus.refresherDue,
      );
      expect(
        _quizStatus(
          critical: true,
          signedOff: true,
          passes: passed,
          months: 3,
          now: DateTime(2026, 7, 3),
        ),
        TrainingStatus.refresherDue,
      );
    });

    test('after a refresher re-read, the quiz is the next step', () {
      final reread = [
        TrainingAcknowledgement(
          userId: 1,
          siteId: 1,
          templateGroupId: 1,
          guideVersion: 'v2',
          acknowledgedAt: DateTime(2026, 10, 2),
        ),
      ];
      expect(
        _quizStatus(
          reads: reread,
          passes: [_pass('v2', DateTime(2026, 1, 5))],
          months: 6,
          now: DateTime(2026, 10, 3),
        ),
        TrainingStatus.quizDue,
      );
    });

    test('no quiz: reading expires instead', () {
      expect(
        trainingStatusFor(
          isCritical: false,
          currentVersion: 'v2',
          acknowledgements: [_ack('v2')],
          signoff: null,
          refreshMonths: 6,
          now: DateTime(2027, 4, 2),
        ),
        TrainingStatus.refresherDue,
      );
    });

    test('fully trained only when every item is complete', () {
      expect(isFullyTrained(const []), isFalse);
    });

    test('addMonths clamps to the end of a short month', () {
      expect(addMonths(DateTime(2026, 8, 31), 6), DateTime(2027, 2, 28));
      expect(addMonths(DateTime(2026, 11, 15), 3), DateTime(2027, 2, 15));
    });
  });
}

// Quizzes (2026-10-17): read + pass = green tick; managers skip routine
// quizzes and sign-offs; passes expire after the refresher period.
QuizPass _pass(String version, DateTime at) => QuizPass(
  userId: 1,
  siteId: 1,
  templateGroupId: 1,
  guideVersion: version,
  passedAt: at,
);

TrainingStatus _quizStatus({
  bool critical = false,
  bool manager = false,
  List<QuizPass> passes = const [],
  List<TrainingAcknowledgement>? reads,
  bool signedOff = false,
  int? months,
  DateTime? now,
}) => trainingStatusFor(
  isCritical: critical,
  currentVersion: 'v2',
  // Read before any of the passes below.
  acknowledgements:
      reads ??
      [
        TrainingAcknowledgement(
          userId: 1,
          siteId: 1,
          templateGroupId: 1,
          guideVersion: 'v2',
          acknowledgedAt: DateTime(2026, 1, 1),
        ),
      ],
  signoff: signedOff ? _signoff : null,
  quizPasses: passes,
  quizAvailable: true,
  isManager: manager,
  refreshMonths: months,
  now: now,
);

