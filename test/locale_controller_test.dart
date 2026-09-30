import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:venurite/core/localization/locale_controller.dart';
import 'package:venurite/core/localization/supported_language.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('localeFromStorageCode falls back to English for unknown values', () {
    expect(localeFromStorageCode(null), const Locale('en'));
    expect(localeFromStorageCode('not-real'), const Locale('en'));
  });

  test('LocaleController persists and reloads the device locale', () async {
    SharedPreferences.setMockInitialValues({});

    final controller = LocaleController();
    await controller.setDeviceLocale(const Locale('pl'));

    expect(controller.state, const Locale('pl'));

    final reloaded = LocaleController();
    await Future<void>.delayed(Duration.zero);

    expect(reloaded.state, const Locale('pl'));
  });

  // Direct regression for the branch-device / per-worker locale split:
  // a shared tablet is set to the branch's own language (e.g. English for
  // a UK branch); an individual worker's own preferredLocale (e.g. Arabic
  // or Spanish) only applies while they're signed in, and logging out must
  // hand the screen back to the branch's language, not strand it on
  // whichever worker used the device last.
  test(
    'logging out restores the branch device locale, not the last worker\'s',
    () async {
      SharedPreferences.setMockInitialValues({});
      final controller = LocaleController();

      // Branch tablet is configured for English (the pre-login state).
      await controller.setDeviceLocale(const Locale('en'));
      expect(controller.state, const Locale('en'));

      // An Arabic-speaking worker signs in — this is what app.dart's
      // currentUserProvider listener calls on login.
      await controller.applyUserLocale('ar');
      expect(controller.state, const Locale('ar'));

      // They sign out — app.dart's listener calls this on logout.
      await controller.restoreDeviceLocale();
      expect(controller.state, const Locale('en'));

      // A different worker (Spanish) signs in next on the same device.
      await controller.applyUserLocale('es');
      expect(controller.state, const Locale('es'));

      await controller.restoreDeviceLocale();
      expect(controller.state, const Locale('en'));
    },
  );
}
