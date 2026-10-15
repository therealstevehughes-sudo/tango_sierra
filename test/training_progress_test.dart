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
}
