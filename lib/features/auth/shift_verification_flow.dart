import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/models/backend_shift_log.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_shift_log_providers.dart';
import '../../shared/repositories/backend_shift_log_repository.dart';
import 'clock_location.dart';

// Shift verification photos (2026-10-02), direct founder request — a
// photo at shift start/end to deter buddy-punching/fraudulent clock-in-
// out. Framed to staff as NOTICE + ACKNOWLEDGMENT, deliberately not as
// free "consent" in the strict legal sense: UK ICO guidance treats
// workplace consent as legally fragile (an employee can't easily refuse
// without feeling it may count against them), so the actual lawful basis
// is legitimate interests (fraud prevention), not consent. What this
// screen gives the person is a REAL alternative with no detriment —
// decline, and a supervisor verifies their shift instead — which is what
// makes the choice genuine rather than theatre.
//
// Not solicitor-reviewed — same flag already on the Terms of Service and
// the service-provider directory's disclaimer wording.
const shiftPhotoConsentVersion = '2026-10-02';

/// Call from Shift Welcome (which: 'in') and End Shift (which: 'out').
/// No-ops entirely (returns null, no dialog, nothing captured) unless the
/// active site has photo checks and/or the location check (2026-10-15)
/// turned on — existing installs/sites are completely unaffected. On success, returns the resulting
/// [BackendShiftLog] so the caller can track the open shift id for the
/// matching clock-out later.
Future<BackendShiftLog?> runShiftVerificationStep({
  required BuildContext context,
  required WidgetRef ref,
  required User user,
  required Site site,
  required String which,
  int? existingShiftLogId,
}) async {
  final photosOn = site.shiftVerificationPhotosEnabled;
  final locationOn = site.clockLocationCheckEnabled;
  if ((!photosOn && !locationOn) || user.siteId == null) {
    return null;
  }
  final siteId = user.siteId!;

  var consent = photosOn ? user.shiftPhotoConsent : 'declined';
  if (consent == null) {
    if (!context.mounted) return null;
    consent = await _askConsent(context);
    if (consent == null) return null; // dialog dismissed — try again next time
    try {
      await ref.read(userRepositoryProvider).setShiftPhotoConsent(
        userId: user.id,
        consent: consent,
        version: shiftPhotoConsentVersion,
      );
      ref.read(currentUserProvider.notifier).state = user.copyWith(
        shiftPhotoConsent: consent,
        shiftPhotoConsentAt: DateTime.now(),
        shiftPhotoConsentVersion: shiftPhotoConsentVersion,
      );
    } catch (_) {
      // Best-effort — if saving the choice fails, fall through using the
      // choice just made for this one event; it'll be asked again next
      // shift, which is a minor annoyance, not a blocker to clocking in.
    }
  }

  List<int>? photoBytes;
  if (photosOn && consent == 'allowed') {
    if (!context.mounted) return null;
    photoBytes = await _capturePhoto(context);
    // A cancelled camera still proceeds (consent was "allowed", but
    // nobody can be forced to actually take the photo in the moment) —
    // falls through with no bytes, same as a decline for this one event,
    // landing in the supervisor-verification queue rather than blocking
    // the person from clocking in/out at all.
  }

  // Location-checked clock-in (2026-10-15) — see clock_location.dart.
  // The server decides on-site/off-site; a null position is still sent
  // (the venue-network check may pass it, else it's flagged for review).
  ClockPosition? position;
  if (locationOn) {
    if (!context.mounted) return null;
    await showClockLocationNoticeOnce(context, user.id);
    position = await readClockPosition();
  }

  final repo = ref.read(backendShiftLogRepositoryProvider);
  try {
    if (which == 'in') {
      return await repo.clockIn(
        siteId: siteId,
        userId: user.id,
        photoBytes: photoBytes,
        position: position,
      );
    } else if (existingShiftLogId != null) {
      return await repo.clockOut(
        shiftLogId: existingShiftLogId,
        siteId: siteId,
        userId: user.id,
        photoBytes: photoBytes,
        position: position,
      );
    }
  } catch (_) {
    // Best-effort, same as the original local habit-tracker's own
    // reasoning — a missed row never blocks getting to or leaving work.
  }
  return null;
}

Future<String?> _askConsent(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(l10n.shiftPhotoConsentTitle),
      content: Text(l10n.shiftPhotoConsentBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'declined'),
          child: Text(l10n.declinePhotoButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, 'allowed'),
          child: Text(l10n.allowPhotoButton),
        ),
      ],
    ),
  );
}

/// Deliberately small: this only needs to be big enough for a human
/// supervisor to glance at and confirm identity later, not a high-
/// resolution image — direct founder request to keep server storage
/// costs down. maxWidth/maxHeight downscale the capture itself (not just
/// JPEG-compress it after), so the file is small from the moment it's
/// taken, not compressed after the fact.
Future<List<int>?> _capturePhoto(BuildContext context) async {
  final picker = ImagePicker();
  XFile? file;
  try {
    file = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 480,
      maxHeight: 480,
      imageQuality: 50,
    );
  } catch (_) {
    // Camera unavailable (e.g. desktop) — same fallback EvidenceStore and
    // the certificate-upload flow both already use.
    try {
      file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 480,
        maxHeight: 480,
        imageQuality: 50,
      );
    } catch (_) {
      return null;
    }
  }
  if (file == null) return null;
  return file.readAsBytes();
}
