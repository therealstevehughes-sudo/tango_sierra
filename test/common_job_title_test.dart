import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/shared/models/common_job_title.dart';

void main() {
  group('localizedJobTitle', () {
    test('returns the raw title unchanged when l10n is null', () {
      expect(localizedJobTitle('Line Chef'), 'Line Chef');
    });

    test('returns a genuinely custom title unchanged', () {
      // No AppLocalizations instance needed here - the whole point of a
      // custom title is that it falls through untouched, same as a
      // person's name would, since it's real free text with no entry in
      // the canonical lookup table at all.
      expect(localizedJobTitle('Pizza Flipper Extraordinaire'), 'Pizza Flipper Extraordinaire');
    });

    test('every common job title has a canonical English string that is non-empty', () {
      for (final title in commonJobTitles) {
        expect(title.trim(), isNotEmpty);
      }
    });

    test('commonJobTitles has no duplicate entries', () {
      expect(commonJobTitles.toSet().length, commonJobTitles.length);
    });
  });
}
