// Shift verification photos (2026-10-02) — the backend-hosted shift log,
// distinct from the original local-only ShiftLog (shift_log.dart): this
// one exists specifically so a photo (or a supervisor's confirmation when
// a staff member declined) can be attached to each clock-in/out, and so
// any supervisor on any device can see and confirm a pending one. A site
// with shiftVerificationPhotosEnabled off keeps using the plain local
// habit-tracker; this model only applies once that site turns it on.
class BackendShiftLog {
  const BackendShiftLog({
    required this.id,
    required this.userId,
    required this.siteId,
    required this.clockInAt,
    this.clockInPhotoPath,
    this.clockInPhotoPurged = false,
    this.clockInVerifiedByUserId,
    this.clockInVerifiedAt,
    this.clockOutAt,
    this.clockOutPhotoPath,
    this.clockOutPhotoPurged = false,
    this.clockOutVerifiedByUserId,
    this.clockOutVerifiedAt,
  });

  final int id;
  final int userId;
  final int siteId;
  final DateTime clockInAt;
  final String? clockInPhotoPath;
  // Set once the retention purge has deleted the Storage object and
  // nulled the path — distinguishes "never had a photo, declined" (still
  // genuinely pending verification) from "had a photo, aged out of
  // retention" (already resolved, never belongs in the live queue).
  final bool clockInPhotoPurged;
  final int? clockInVerifiedByUserId;
  final DateTime? clockInVerifiedAt;
  final DateTime? clockOutAt;
  final String? clockOutPhotoPath;
  final bool clockOutPhotoPurged;
  final int? clockOutVerifiedByUserId;
  final DateTime? clockOutVerifiedAt;

  Duration? get duration => clockOutAt?.difference(clockInAt);

  bool get clockInPending =>
      clockInPhotoPath == null &&
      !clockInPhotoPurged &&
      clockInVerifiedByUserId == null;
  bool get clockOutPending =>
      clockOutAt != null &&
      clockOutPhotoPath == null &&
      !clockOutPhotoPurged &&
      clockOutVerifiedByUserId == null;
}

/// Pure retention check, factored out so it's independently testable: a
/// photo captured before the cutoff (now - retentionDays) is expired and
/// should be purged. No cron on this backend (standing architecture
/// choice) — purging is triggered lazily, the next time a supervisor+
/// views the site's shift log, not on a schedule.
bool isShiftPhotoExpired({
  required DateTime capturedAt,
  required int retentionDays,
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final cutoff = at.subtract(Duration(days: retentionDays));
  return capturedAt.isBefore(cutoff);
}
