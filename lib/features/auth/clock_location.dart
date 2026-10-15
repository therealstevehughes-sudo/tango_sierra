import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/repositories/backend_shift_log_repository.dart';

// Location-checked clock-in (2026-10-15, founder-approved). One reading at
// the moment of clock-in/out — never tracked, never in the background.
// Every failure (no permission, location off, desktop with no GPS, a slow
// fix indoors) returns null: the server then records "no location" for a
// supervisor to review, and the person still clocks in. Flag, never block.

/// The device's current position, or null if it can't be had quickly.
Future<ClockPosition?> readClockPosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return ClockPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyM: position.accuracy.round(),
    );
  } catch (_) {
    return null;
  }
}

// Bump when the notice wording changes materially, so everyone sees it
// again (same idea as shiftPhotoConsentVersion).
const _noticeVersion = '2026-10-15';

/// UK GDPR / ICO monitoring-at-work guidance: staff must be told before
/// their location is used. Shown once per person per device. Lawful basis
/// is legitimate interests (preventing false clock-ins), not consent, so
/// it's a notice with a plain "OK" — the genuine no-detriment alternative
/// is that denying the OS permission simply means a supervisor reviews
/// that clock-in instead.
Future<void> showClockLocationNoticeOnce(
  BuildContext context,
  int userId,
) async {
  final key = 'clock_location_notice_${_noticeVersion}_$userId';
  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key) == true) return;
  } catch (_) {
    // Storage unavailable — show the notice anyway; better twice than never.
  }
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.clockLocationNoticeTitle),
      content: Text(l10n.clockLocationNoticeBody),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l10n.clockLocationNoticeOk),
        ),
      ],
    ),
  );
  try {
    await prefs?.setBool(key, true);
  } catch (_) {}
}
