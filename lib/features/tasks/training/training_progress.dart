import 'dart:convert';

import '../task_model.dart';
import 'task_training_guide.dart';

// Training section (2026-10-15, founder-approved). A person's training
// list is derived from the tasks they're actually assigned — never
// assigned by hand — so it can't go stale. Two kinds of evidence:
//  - "I've read and understood" for every task's guide (re-asked when the
//    venue edits the guide, via guideVersion below);
//  - a manager's competence sign-off ("I watched them do it") for
//    critical tasks only, the evidence that actually carries weight.

/// Short, stable content hash of a guide (FNV-1a, 32-bit). Deliberately
/// not String.hashCode, which isn't guaranteed identical across platforms
/// (VM vs web) — an acknowledgement made on the tablet must still match
/// when a manager checks it on the web app.
String guideVersion(TaskTrainingGuide guide) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(jsonEncode(guide.toJson()))) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

class TrainingAcknowledgement {
  const TrainingAcknowledgement({
    required this.userId,
    required this.siteId,
    required this.templateGroupId,
    required this.guideVersion,
    required this.acknowledgedAt,
  });

  final int userId;
  final int siteId;
  final int templateGroupId;
  final String guideVersion;
  final DateTime acknowledgedAt;
}

class CompetenceSignoff {
  const CompetenceSignoff({
    required this.userId,
    required this.siteId,
    required this.templateGroupId,
    required this.signedOffByUserId,
    required this.signedOffAt,
  });

  final int userId;
  final int siteId;
  final int templateGroupId;
  final int signedOffByUserId;
  final DateTime signedOffAt;
}

/// A passed 3-question quiz on one version of a task's guide (2026-10-17).
/// Marked on the server; the app only ever sees that it passed.
class QuizPass {
  const QuizPass({
    required this.userId,
    required this.siteId,
    required this.templateGroupId,
    required this.guideVersion,
    required this.passedAt,
  });

  final int userId;
  final int siteId;
  final int templateGroupId;
  final String guideVersion;
  final DateTime passedAt;
}

enum TrainingStatus {
  /// Never read this task's guide.
  notRead,

  /// Read an older version — the venue has since changed the guide.
  updated,

  /// Read the current guide, but not yet passed its quiz.
  quizDue,

  /// Was trained, but the venue's refresher period has run out: read the
  /// guide again (and retake the quiz, when the task has one).
  refresherDue,

  /// Trained: read the current guide and, when the task has a quiz,
  /// passed it. Final state for non-critical tasks (the green tick).
  read,

  /// Critical task, guide read, waiting for a manager to watch them do it.
  awaitingSignoff,

  /// Critical task, manager has signed them off as competent.
  competent,
}

/// One task on one person's training list.
class TrainingItem {
  const TrainingItem({
    required this.task,
    required this.guide,
    required this.isVenueGuide,
    required this.status,
    this.acknowledgedAt,
    this.signoff,
    this.quizRequired = false,
    this.quizPassedAt,
  });

  final ResolvedTask task;
  final TaskTrainingGuide guide;
  final bool isVenueGuide;
  final TrainingStatus status;
  final DateTime? acknowledgedAt;
  final CompetenceSignoff? signoff;

  /// This person must pass the task's quiz (there is one, and they aren't
  /// a manager on a routine task).
  final bool quizRequired;

  /// Latest pass on the current guide, if any.
  final DateTime? quizPassedAt;

  bool get needsReading =>
      status == TrainingStatus.notRead || status == TrainingStatus.updated;

  /// Something the person themselves has to do (read, quiz, refresher) —
  /// as opposed to waiting for a manager's sign-off.
  bool get needsAction =>
      needsReading ||
      status == TrainingStatus.quizDue ||
      status == TrainingStatus.refresherDue;

  bool get isComplete =>
      status == TrainingStatus.read || status == TrainingStatus.competent;
}

/// "Fully trained" (2026-10-17): every task on the person's list is done.
bool isFullyTrained(Iterable<TrainingItem> items) =>
    items.isNotEmpty && items.every((i) => i.isComplete);

/// [from] plus [months] calendar months (clamped to the month's last day).
DateTime addMonths(DateTime from, int months) {
  final total = from.month - 1 + months;
  final year = from.year + total ~/ 12;
  final month = total % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(
    year,
    month,
    from.day > lastDay ? lastDay : from.day,
    from.hour,
    from.minute,
  );
}

/// Pure status rule, kept separate from loading so it's unit-testable.
///
/// Quizzes (2026-10-17, founder-approved): when the task has a quiz, the
/// green tick also needs a pass on the current guide. Managers skip the
/// quiz on routine tasks, and don't need a sign-off themselves (their
/// formal certificates live in Training records). With [refreshMonths],
/// the evidence (quiz pass, or reading when there's no quiz) expires.
TrainingStatus trainingStatusFor({
  required bool isCritical,
  required String currentVersion,
  required Iterable<TrainingAcknowledgement> acknowledgements,
  required CompetenceSignoff? signoff,
  Iterable<QuizPass> quizPasses = const [],
  bool quizAvailable = false,
  bool isManager = false,
  int? refreshMonths,
  DateTime? now,
}) {
  final currentReads = acknowledgements
      .where((a) => a.guideVersion == currentVersion)
      .toList();
  final needsSignoff = isCritical && !isManager;
  if (currentReads.isEmpty) {
    // A competence sign-off stands even if the guide is later reworded —
    // the manager watched them do the task itself, not read the text —
    // but they're still asked to re-read the changed guide.
    if (needsSignoff && signoff != null) return TrainingStatus.updated;
    return acknowledgements.isEmpty
        ? TrainingStatus.notRead
        : TrainingStatus.updated;
  }

  final quizRequired = quizAvailable && (isCritical || !isManager);
  final DateTime evidenceAt;
  if (quizRequired) {
    final passes = quizPasses
        .where((p) => p.guideVersion == currentVersion)
        .map((p) => p.passedAt)
        .toList();
    if (passes.isEmpty) return TrainingStatus.quizDue;
    evidenceAt = passes.reduce((a, b) => a.isAfter(b) ? a : b);
  } else {
    evidenceAt = currentReads
        .map((a) => a.acknowledgedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }
  if (refreshMonths != null &&
      now != null &&
      addMonths(evidenceAt, refreshMonths).isBefore(now)) {
    // A refresher re-read (newer than the expired pass) is what unlocks
    // the retake, so show the quiz as the next step once that's done.
    final reread = currentReads.any((a) => a.acknowledgedAt.isAfter(evidenceAt));
    return quizRequired && reread
        ? TrainingStatus.quizDue
        : TrainingStatus.refresherDue;
  }
  if (needsSignoff) {
    return signoff != null
        ? TrainingStatus.competent
        : TrainingStatus.awaitingSignoff;
  }
  return TrainingStatus.read;
}
