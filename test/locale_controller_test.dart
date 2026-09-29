import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/core/localization/locale_controller.dart';
import 'package:flutter_application_1/core/localization/supported_language.dart';

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
}
