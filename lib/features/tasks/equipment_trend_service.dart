import 'dart:math';

/// Equipment trend warnings (2026-09-28, direct founder request) — catches
/// two kinds of "not obviously a failure yet" pattern in equipment
/// readings that already pass their safe limit individually, using data
/// the app already collects (no new hardware/sensors):
///
/// - [EquipmentTrendReason.trendingTowardLimit]: the last 3 readings have
///   moved steadily closer to the limit each time — a fridge slowly
///   warming up, say, that would still show three separate "PASS" ticks
///   with nothing to flag it to a passing glance.
/// - [EquipmentTrendReason.repeatedNearMiss]: at least 2 of the last 3
///   readings sat close to the limit, even without a clean worsening
///   trend — e.g. a compressor cycling in and out of a healthy range,
///   never failing outright but clearly not right either.
///
/// Deliberately pure/stateless — no repository access, no I/O — so it can
/// be unit tested directly on a list of readings, same as
/// `reliability_service.dart`'s own compute-only design. The caller
/// (`TaskController.logTaskSubmission`) is responsible for fetching the
/// equipment's recent history and deciding what to do with a result.
enum EquipmentTrendReason { trendingTowardLimit, repeatedNearMiss }

class EquipmentTrendWarning {
  const EquipmentTrendWarning({
    required this.reason,
    required this.latestValue,
    this.minLimit,
    this.maxLimit,
    this.unit,
  });

  final EquipmentTrendReason reason;
  final double latestValue;
  final double? minLimit;
  final double? maxLimit;
  final String? unit;

  String messageFor(String equipmentName) {
    final unitSuffix = unit == null ? '' : unit!;
    final valueText = '${_formatValue(latestValue)}$unitSuffix';
    return switch (reason) {
      EquipmentTrendReason.trendingTowardLimit =>
        'TREND WARNING: $equipmentName readings have moved steadily closer '
            'to the safe limit over the last 3 checks (latest: $valueText). '
            'Worth checking before it becomes a real fail.',
      EquipmentTrendReason.repeatedNearMiss =>
        'TREND WARNING: $equipmentName has had multiple readings close to '
            'the safe limit recently (latest: $valueText). Worth a look '
            'before it becomes a real fail.',
    };
  }

  static String _formatValue(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

/// [valuesAscending] is the equipment's own recent numeric readings for one
/// task template, oldest first, ending with the reading just submitted.
/// At least one of [minLimit]/[maxLimit] must be set — a task with neither
/// has no safe limit to measure closeness against. Returns null when there
/// isn't enough history yet, the latest reading isn't actually close to a
/// limit, or this exact pattern was already flagged one reading ago (so a
/// worsening trend or a run of near-misses raises exactly one warning, not
/// one per check while it persists).
EquipmentTrendWarning? evaluateEquipmentTrend(
  List<double> valuesAscending, {
  double? minLimit,
  double? maxLimit,
  String? unit,
}) {
  if (minLimit == null && maxLimit == null) return null;

  final current = _warningAt(
    valuesAscending,
    minLimit: minLimit,
    maxLimit: maxLimit,
    unit: unit,
  );
  if (current == null) return null;

  // Rising-edge only: if dropping the latest reading would have already
  // flagged the same situation, this isn't new — don't re-fire on every
  // check while the equipment sits in the same worrying state.
  if (valuesAscending.length > 3) {
    final previous = _warningAt(
      valuesAscending.sublist(0, valuesAscending.length - 1),
      minLimit: minLimit,
      maxLimit: maxLimit,
      unit: unit,
    );
    if (previous != null) return null;
  }

  return current;
}

EquipmentTrendWarning? _warningAt(
  List<double> values, {
  required double? minLimit,
  required double? maxLimit,
  required String? unit,
}) {
  if (values.length < 3) return null;
  final window = values.sublist(values.length - 3);

  double distanceToNearestLimit(double v) {
    final distances = <double>[
      if (minLimit != null) (v - minLimit).abs(),
      if (maxLimit != null) (maxLimit - v).abs(),
    ];
    return distances.reduce(min);
  }

  // How close counts as "close": 15% of the full safe range when both
  // bounds are set (a wide range like -18C to -15C for a freezer tolerates
  // more drift before it's worth flagging than a narrow one); otherwise
  // 10% of the single bound's own magnitude, floored at 0.5 so a limit of
  // 0 (or near it) still has a sane, non-zero margin.
  final range = (minLimit != null && maxLimit != null)
      ? (maxLimit - minLimit).abs()
      : null;
  final margin = (range != null && range > 0)
      ? range * 0.15
      : max((minLimit ?? maxLimit)!.abs() * 0.1, 0.5);

  final distances = window.map(distanceToNearestLimit).toList();
  if (distances.last > margin) return null;

  final trending = distances[0] > distances[1] && distances[1] > distances[2];
  if (trending) {
    return EquipmentTrendWarning(
      reason: EquipmentTrendReason.trendingTowardLimit,
      latestValue: window.last,
      minLimit: minLimit,
      maxLimit: maxLimit,
      unit: unit,
    );
  }

  final nearMissCount = distances.where((d) => d <= margin).length;
  if (nearMissCount >= 2) {
    return EquipmentTrendWarning(
      reason: EquipmentTrendReason.repeatedNearMiss,
      latestValue: window.last,
      minLimit: minLimit,
      maxLimit: maxLimit,
      unit: unit,
    );
  }

  return null;
}
