import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/shared/models/backend_shift_log.dart';

void main() {
  group('isShiftPhotoExpired', () {
    test('a photo captured today is not expired', () {
      final now = DateTime(2026, 10, 2);
      expect(
        isShiftPhotoExpired(
          capturedAt: now,
          retentionDays: 90,
          now: now,
        ),
        isFalse,
      );
    });

    test('a photo exactly at the retention cutoff is not yet expired', () {
      final capturedAt = DateTime(2026, 7, 4);
      final now = capturedAt.add(const Duration(days: 90));
      expect(
        isShiftPhotoExpired(
          capturedAt: capturedAt,
          retentionDays: 90,
          now: now,
        ),
        isFalse,
      );
    });

    test('a photo one day past the retention cutoff is expired', () {
      final capturedAt = DateTime(2026, 7, 4);
      final now = capturedAt.add(const Duration(days: 91));
      expect(
        isShiftPhotoExpired(
          capturedAt: capturedAt,
          retentionDays: 90,
          now: now,
        ),
        isTrue,
      );
    });

    test('a shorter configured retention expires sooner', () {
      final capturedAt = DateTime(2026, 10, 1);
      final now = DateTime(2026, 10, 3);
      expect(
        isShiftPhotoExpired(
          capturedAt: capturedAt,
          retentionDays: 1,
          now: now,
        ),
        isTrue,
      );
    });
  });

  group('BackendShiftLog pending flags', () {
    BackendShiftLog logWith({
      String? clockInPhotoPath,
      bool clockInPhotoPurged = false,
      int? clockInVerifiedByUserId,
      DateTime? clockOutAt,
      String? clockOutPhotoPath,
      bool clockOutPhotoPurged = false,
      int? clockOutVerifiedByUserId,
    }) => BackendShiftLog(
      id: 1,
      userId: 2,
      siteId: 3,
      clockInAt: DateTime(2026, 10, 2, 9),
      clockInPhotoPath: clockInPhotoPath,
      clockInPhotoPurged: clockInPhotoPurged,
      clockInVerifiedByUserId: clockInVerifiedByUserId,
      clockOutAt: clockOutAt,
      clockOutPhotoPath: clockOutPhotoPath,
      clockOutPhotoPurged: clockOutPhotoPurged,
      clockOutVerifiedByUserId: clockOutVerifiedByUserId,
    );

    test('a declined clock-in (no photo, not verified) is pending', () {
      expect(logWith().clockInPending, isTrue);
    });

    test('a clock-in with a photo is not pending', () {
      expect(logWith(clockInPhotoPath: 'a/b/c.jpg').clockInPending, isFalse);
    });

    test('a clock-in already verified by a supervisor is not pending', () {
      expect(logWith(clockInVerifiedByUserId: 9).clockInPending, isFalse);
    });

    test(
      'a clock-in whose photo expired and was purged is NOT pending - '
      'it was never declined, it just aged out',
      () {
        expect(logWith(clockInPhotoPurged: true).clockInPending, isFalse);
      },
    );

    test('clock-out is never pending while the shift is still open', () {
      expect(logWith().clockOutPending, isFalse);
    });

    test('a declined clock-out on a closed shift is pending', () {
      expect(
        logWith(clockOutAt: DateTime(2026, 10, 2, 17)).clockOutPending,
        isTrue,
      );
    });
  });
}
