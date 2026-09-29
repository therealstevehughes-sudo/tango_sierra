import 'package:flutter/material.dart';

class SupportedLanguage {
  const SupportedLanguage({
    required this.locale,
    required this.englishName,
    required this.nativeName,
  });

  final Locale locale;
  final String englishName;
  final String nativeName;

  String get storageCode {
    final countryCode = locale.countryCode;
    if (countryCode == null || countryCode.isEmpty) return locale.languageCode;
    return '${locale.languageCode}_$countryCode';
  }

  String get displayName =>
      englishName == nativeName ? englishName : '$englishName - $nativeName';
}

const supportedLanguages = <SupportedLanguage>[
  SupportedLanguage(
    locale: Locale('en'),
    englishName: 'English',
    nativeName: 'English',
  ),
  SupportedLanguage(
    locale: Locale('pl'),
    englishName: 'Polish',
    nativeName: 'Polski',
  ),
  SupportedLanguage(
    locale: Locale('ro'),
    englishName: 'Romanian',
    nativeName: 'Rom\u00e2n\u0103',
  ),
  SupportedLanguage(
    locale: Locale('es'),
    englishName: 'Spanish',
    nativeName: 'Espa\u00f1ol',
  ),
  SupportedLanguage(
    locale: Locale('hr'),
    englishName: 'Croatian',
    nativeName: 'Hrvatski',
  ),
  SupportedLanguage(
    locale: Locale('de'),
    englishName: 'German',
    nativeName: 'Deutsch',
  ),
  SupportedLanguage(
    locale: Locale('ar'),
    englishName: 'Arabic',
    nativeName: '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
  ),
  SupportedLanguage(
    locale: Locale('zh'),
    englishName: 'Simplified Chinese',
    nativeName: '\u7b80\u4f53\u4e2d\u6587',
  ),
  SupportedLanguage(
    locale: Locale('hi'),
    englishName: 'Hindi',
    nativeName: '\u0939\u093f\u0928\u094d\u0926\u0940',
  ),
  SupportedLanguage(
    locale: Locale('ur'),
    englishName: 'Urdu',
    nativeName: '\u0627\u0631\u062f\u0648',
  ),
];

Locale localeFromStorageCode(String? code) {
  if (code == null || code.trim().isEmpty) return const Locale('en');
  final normalized = code.replaceAll('-', '_');
  for (final language in supportedLanguages) {
    if (language.storageCode == normalized ||
        language.locale.languageCode == normalized) {
      return language.locale;
    }
  }
  return const Locale('en');
}

SupportedLanguage languageForLocale(Locale locale) {
  return supportedLanguages.firstWhere(
    (language) => language.locale.languageCode == locale.languageCode,
    orElse: () => supportedLanguages.first,
  );
}
