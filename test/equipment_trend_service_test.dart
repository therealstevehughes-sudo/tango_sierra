// Equipment trend warnings (direct founder request, 2026-09-28) — proves
// evaluateEquipmentTrend() catches two "not obviously a failure yet"
// patterns using data the app already collects:
//   - a worsening trend over the last 3 readings, even though each one
//     individually still passes
//   - repeated near-miss readings close to the limit without a clean trend
// and that it only fires once per new occurrence (rising-edge), not once
// per check while the pattern persists.
//
// Pure function, no DB/repository involved — same reasoning as this
// app's other compute-only services (see reliability_service.dart).
//
// Run: flutter test test/equipment_trend_service_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:venurite/features/tasks/equipment_trend_service.dart';

void main() {
  group('evaluateEquipmentTrend', () {
    test('returns null with no limit set at all', () {
      final result = evaluateEquipmentTrend([1, 2, 3]);
      expect(result, isNull);
    });

    test('returns null with fewer than 3 readings', () {
      final result = evaluateEquipmentTrend([3.0, 3.5], maxLimit: 5.0);
      expect(result, isNull);
    });

    test('returns null when the latest reading is not close to the limit', () {
      // maxLimit 5, margin (no minLimit) = max(5*0.1, 0.5) = 0.5
      final result = evaluateEquipmentTrend(
        [1.0, 1.5, 2.0],
        maxLimit: 5.0,
      );
      expect(result, isNull);
    });

    test(
      'flags trendingTowardLimit when 3 readings steadily worsen toward '
      'the limit, even though every one individually still passes',
      () {
        // A freezer creeping up toward its -15C maxLimit: -18, -17, -16.2 —
        // each one still passes, but each is closer than the last.
        final result = evaluateEquipmentTrend(
          [-18.0, -17.0, -16.2],
          maxLimit: -15.0,
          unit: 'C',
        );
        expect(result, isNotNull);
        expect(result!.reason, EquipmentTrendReason.trendingTowardLimit);
        expect(result.latestValue, -16.2);
      },
    );

    test(
      'flags repeatedNearMiss when 2+ of the last 3 sit close to the '
      'limit without a clean worsening trend',
      () {
        // Hovering close to the limit rather than steadily worsening:
        // -16.2, -16.6, -16.1 — not monotonic, but 2+ are within margin.
        final result = evaluateEquipmentTrend(
          [-16.2, -16.6, -16.1],
          maxLimit: -15.0,
        );
        expect(result, isNotNull);
        expect(result!.reason, EquipmentTrendReason.repeatedNearMiss);
      },
    );

    test('does not flag a trend that is worsening but still far from the limit', () {
      // Moving toward the limit each time, but the latest is nowhere near
      // it yet — a real trend forming, but too early to say anything.
      final result = evaluateEquipmentTrend(
        [-30.0, -25.0, -20.0],
        maxLimit: -15.0,
      );
      expect(result, isNull);
    });

    test(
      'only fires once for the same worsening run — rising edge, not '
      'repeated on every later check',
      () {
        // Readings 2..4 already formed the exact same worsening pattern
        // one check ago; the 5th reading continues it but shouldn't
        // re-fire a brand new warning every time.
        final firstWarning = evaluateEquipmentTrend(
          [-18.0, -17.0, -16.2],
          maxLimit: -15.0,
        );
        expect(firstWarning, isNotNull);

        final stillTrending = evaluateEquipmentTrend(
          [-18.0, -17.0, -16.2, -15.9],
          maxLimit: -15.0,
        );
        expect(
          stillTrending,
          isNull,
          reason: 'the -17/-16.2 pair already warned one check ago',
        );
      },
    );

    test('fires again once a fresh occurrence starts after a gap', () {
      // Recovered to a safe reading, then started worsening again — a
      // genuinely new occurrence should be able to fire again.
      final result = evaluateEquipmentTrend(
        [-16.2, -20.0, -19.0, -16.3],
        maxLimit: -15.0,
      );
      expect(result, isNotNull);
    });

    test('uses a wider margin for a wide safe range (both limits set)', () {
      // Range 10 (0..10), margin = 1.5. A reading of 8.6 is distance 1.4
      // from the 10 maxLimit — within margin.
      final result = evaluateEquipmentTrend(
        [6.0, 7.5, 8.6],
        minLimit: 0.0,
        maxLimit: 10.0,
      );
      expect(result, isNotNull);
    });

    test('message text names the equipment and includes the latest value', () {
      final result = evaluateEquipmentTrend(
        [-18.0, -17.0, -16.2],
        maxLimit: -15.0,
        unit: 'C',
      );
      final message = result!.messageFor('Walk-in Freezer');
      expect(message, contains('Walk-in Freezer'));
      expect(message, contains('-16.2C'));
      expect(message, contains('TREND WARNING'));
    });
  });
}
