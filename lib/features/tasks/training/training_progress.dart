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

enum TrainingStatus {
  /// Never read this task's guide.
  notRead,

  /// Read an older version — the venue has since changed the guide.
  updated,

  /// Read the current guide. Final state for non-critical tasks.
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
  });

  final ResolvedTask task;
  final TaskTrainingGuide guide;
  final bool isVenueGuide;
  final TrainingStatus status;
  final DateTime? acknowledgedAt;
  final CompetenceSignoff? signoff;

  bool get needsReading =>
      status == TrainingStatus.notRead || status == TrainingStatus.updated;

  bool get isComplete =>
      status == TrainingStatus.read || status == TrainingStatus.competent;
}

/// Pure status rule, kept separate from loading so it's unit-testable.
TrainingStatus trainingStatusFor({
  required bool isCritical,
  required String currentVersion,
  required Iterable<TrainingAcknowledgement> acknowledgements,
  required CompetenceSignoff? signoff,
}) {
  final readCurrent = acknowledgements.any(
    (a) => a.guideVersion == currentVersion,
  );
  // A competence sign-off stands even if the guide is later reworded —
  // the manager watched them do the task itself, not read the text — but
  // they're still asked to re-read the changed guide.
  if (isCritical && signoff != null) {
    return readCurrent ? TrainingStatus.competent : TrainingStatus.updated;
  }
  if (readCurrent) {
    return isCritical ? TrainingStatus.awaitingSignoff : TrainingStatus.read;
  }
  return acknowledgements.isEmpty
      ? TrainingStatus.notRead
      : TrainingStatus.updated;
}
