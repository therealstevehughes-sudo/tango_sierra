import 'training_item.dart';

// Training records (Sprint 031) — append-only, same pattern as
// TaskSubmission: a renewal creates a new row, the old one is never edited
// or deleted. Training history is compliance evidence.
class TrainingRecord {
  final int? id;
  final int userId;
  final int siteId;
  final TrainingItemType itemType;
  // Only meaningful when itemType == other — the free-text title for an
  // item not in the fixed catalogue. Null otherwise.
  final String? customItemTitle;
  final DateTime completedAt;
  // Null means "doesn't expire" (e.g. Induction Completed is one-time).
  final DateTime? expiresAt;
  final int signedOffByUserId;
  // Certificate reference as free text for now (Sprint 031 decision) — real
  // file upload deferred to the backend phase, same reasoning as photo
  // evidence: don't fake local file storage for something that needs a
  // trusted, persistent store to be meaningful.
  final String? certificateReference;
  final DateTime createdAt;

  const TrainingRecord({
    required this.id,
    required this.userId,
    required this.siteId,
    required this.itemType,
    this.customItemTitle,
    required this.completedAt,
    this.expiresAt,
    required this.signedOffByUserId,
    this.certificateReference,
    required this.createdAt,
  });

  String get displayTitle =>
      itemType == TrainingItemType.other && customItemTitle != null
      ? customItemTitle!
      : trainingItemTypeLabel(itemType);

  // Groups renewals of the same catalogue item together; each distinct
  // `other` free-text title is treated as its own separate item (exact
  // string match only — no fuzzy matching of custom entries).
  String get itemKey => itemType == TrainingItemType.other
      ? 'other:${customItemTitle ?? ''}'
      : itemType.name;
}

enum TrainingStatus { current, expiringSoon, expired }

const trainingExpiringSoonWindow = Duration(days: 30);

TrainingStatus computeTrainingStatus(DateTime? expiresAt, {DateTime? now}) {
  if (expiresAt == null) return TrainingStatus.current;
  final effectiveNow = now ?? DateTime.now();
  if (expiresAt.isBefore(effectiveNow)) return TrainingStatus.expired;
  if (expiresAt.difference(effectiveNow) <= trainingExpiringSoonWindow) {
    return TrainingStatus.expiringSoon;
  }
  return TrainingStatus.current;
}

// Reduces a staff member's full (append-only) training history down to just
// the most recent record per item — the only one that reflects their
// current training status. Older, superseded records remain in the list
// passed in; this just picks which one is "the current one" per item.
List<TrainingRecord> latestPerItem(List<TrainingRecord> records) {
  final latest = <String, TrainingRecord>{};
  for (final record in records) {
    final existing = latest[record.itemKey];
    if (existing == null || record.completedAt.isAfter(existing.completedAt)) {
      latest[record.itemKey] = record;
    }
  }
  return latest.values.toList();
}
