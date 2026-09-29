import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'supported_language.dart';

const _deviceLocalePreferenceKey = 'device_preferred_locale';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      return LocaleController();
    });

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en')) {
    _loadDevicePreference();
  }

  Future<void> _loadDevicePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_deviceLocalePreferenceKey);
    state = localeFromStorageCode(stored);
  }

  Future<void> setDeviceLocale(Locale locale) async {
    final resolved = languageForLocale(locale).locale;
    state = resolved;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _deviceLocalePreferenceKey,
      languageForLocale(resolved).storageCode,
    );
  }

  Future<void> applyUserLocale(String? preferredLocale) async {
    if (preferredLocale == null || preferredLocale.trim().isEmpty) return;
    state = localeFromStorageCode(preferredLocale);
  }

  Future<void> restoreDeviceLocale() async {
    final prefs = await SharedPreferences.getInstance();
    state = localeFromStorageCode(prefs.getString(_deviceLocalePreferenceKey));
  }
}
