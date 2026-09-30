// Review text screening, layer 1 of 2 (2026-09-29) — proves
// identifyingInfoIn() catches the obvious identifying-info leaks (phone
// numbers, emails, URLs) that a reviewer might otherwise paste into a
// service-provider review, defeating the directory's blurred-contact
// design. Pure function, no I/O.
//
// Run: flutter test test/review_text_screening_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:venurite/features/providers/review_text_screening.dart';

void main() {
  group('identifyingInfoIn', () {
    test('returns null for an ordinary review with no identifying info', () {
      expect(
        identifyingInfoIn('Great service, fixed our fridge same day.'),
        isNull,
      );
    });

    test('flags a UK-style mobile number', () {
      expect(
        identifyingInfoIn('Call them on 07700 900123, very responsive'),
        'a phone number',
      );
    });

    test('flags an email address', () {
      expect(
        identifyingInfoIn('Reach out at dave@example.com if you need him'),
        'an email address',
      );
    });

    test('flags a web address', () {
      expect(
        identifyingInfoIn('Check out www.davesfridges.com for more'),
        'a web address',
      );
    });

    test('flags an https URL', () {
      expect(
        identifyingInfoIn('See https://davesfridges.com'),
        'a web address',
      );
    });

    test('does not false-positive on a short number mentioned in passing', () {
      // A rating or a date-like number shouldn't trip the phone check —
      // the pattern requires at least 9 digits.
      expect(identifyingInfoIn('Rated 5 out of 5, arrived at 10am'), isNull);
    });
  });
}
