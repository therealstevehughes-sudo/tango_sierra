import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/shared/models/backend_shift_log.dart';
import 'package:venurite/shared/repositories/backend_shift_log_repository.dart';

void main() {
  test('server status strings parse, unknown/absent means not checked', () {
    expect(parseClockLocationStatus('on_site_gps'), ClockLocationStatus.onSiteGps);
    expect(
      parseClockLocationStatus('on_site_network'),
      ClockLocationStatus.onSiteNetwork,
    );
    expect(parseClockLocationStatus('off_site'), ClockLocationStatus.offSite);
    expect(parseClockLocationStatus('no_location'), ClockLocationStatus.noLocation);
    expect(parseClockLocationStatus(null), isNull);
    expect(parseClockLocationStatus('something_else'), isNull);
  });

  test('only off-site / no-location need review, until reviewed', () {
    const onSite = ClockLocationResult(status: ClockLocationStatus.onSiteGps);
    const network = ClockLocationResult(
      status: ClockLocationStatus.onSiteNetwork,
    );
    const away = ClockLocationResult(
      status: ClockLocationStatus.offSite,
      distanceM: 420,
    );
    const awayReviewed = ClockLocationResult(
      status: ClockLocationStatus.offSite,
      reviewedByUserId: 3,
    );
    const none = ClockLocationResult(status: ClockLocationStatus.noLocation);
    expect(onSite.needsReview, isFalse);
    expect(network.needsReview, isFalse);
    expect(away.needsReview, isTrue);
    expect(none.needsReview, isTrue);
    expect(awayReviewed.needsReview, isFalse);
  });

  test('a shift log without a location result is never flagged', () {
    final log = BackendShiftLog(
      id: 1,
      userId: 1,
      siteId: 1,
      clockInAt: DateTime(2026, 10, 15, 9),
    );
    expect(log.clockInLocationFlagged, isFalse);
    expect(log.clockOutLocationFlagged, isFalse);
  });

  test('position is sent as the RPC params the server expects', () {
    const p = ClockPosition(latitude: 51.5, longitude: -0.12, accuracyM: 18);
    expect(p.toParams(), {'p_lat': 51.5, 'p_lng': -0.12, 'p_accuracy_m': 18});
  });
}
