// TriggerNotificationsBanner — shared alert banner proof (2026-09-12).
//
// The banner was extracted from manager_screen.dart + top_screen.dart's
// duplicated private _TriggerNotificationsBanner during the Guided Cards
// visual-consistency pass. This test pins the behavior both screens
// depend on:
//  - the alert tally ("N alerts") and unacknowledged count;
//  - the instance-name prominence (bold teal lead line);
//  - the OVERDUE treatment once past the escalation threshold;
//  - the Acknowledge action;
//  - the optional row-tap (alert → task drill-down) that only the manager
//    screen wires (top-tier leaves rows plain).
//
// Run: flutter test test/trigger_notifications_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/widgets/trigger_notifications_banner.dart';
import 'package:flutter_application_1/shared/models/trigger_notification.dart';

TriggerNotification _alert({
  required int id,
  required String message,
  String? instanceName,
  bool acknowledged = false,
  DateTime? createdAt,
  DateTime? escalatedAt,
}) => TriggerNotification(
  id: id,
  notificationRuleId: 1,
  taskSubmissionId: 10,
  recipientUserId: 2,
  message: message,
  siteId: 1,
  createdAt: createdAt ?? DateTime.now(),
  acknowledged: acknowledged,
  escalatedAt: escalatedAt,
  equipmentInstanceName: instanceName,
);

Future<void> _pump(
  WidgetTester tester, {
  required List<TriggerNotification> notifications,
  void Function(int id)? onAcknowledge,
  void Function(TriggerNotification)? onRowTap,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: TriggerNotificationsBanner(
          notifications: notifications,
          onAcknowledge: onAcknowledge ?? (_) {},
          onRowTap: onRowTap,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows tally and unacknowledged count', (tester) async {
    await _pump(
      tester,
      notifications: [
        _alert(id: 1, message: 'Fridge 1 too warm'),
        _alert(id: 2, message: 'Fryer 2 too cold', acknowledged: true),
      ],
    );

    expect(find.text('2 alerts'), findsOneWidget);
    expect(find.text('1 unacknowledged'), findsOneWidget);
    expect(find.text('Fridge 1 too warm'), findsOneWidget);
    expect(find.text('Fryer 2 too cold'), findsOneWidget);
  });

  testWidgets('renders instance name as prominence lead', (tester) async {
    await _pump(
      tester,
      notifications: [
        _alert(id: 1, message: 'Too warm', instanceName: 'Fridge A'),
      ],
    );

    expect(find.text('Fridge A'), findsOneWidget);
    expect(find.text('Too warm'), findsOneWidget);
  });

  testWidgets('acknowledged rows show check, unacknowledged show button', (
    tester,
  ) async {
    var acknowledgedId = 0;
    await _pump(
      tester,
      notifications: [
        _alert(id: 1, message: 'Too warm'),
        _alert(id: 2, message: 'Too cold', acknowledged: true),
      ],
      onAcknowledge: (id) => acknowledgedId = id,
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Acknowledge'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Acknowledge'));
    await tester.pumpAndSettle();
    expect(acknowledgedId, 1);
  });

  testWidgets('marks overdue rows when past escalation threshold', (
    tester,
  ) async {
    await _pump(
      tester,
      notifications: [
        _alert(
          id: 1,
          message: 'Too warm',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    );

    expect(find.textContaining('OVERDUE'), findsOneWidget);
  });

  testWidgets('row tap opens drill-down only when onRowTap is wired', (
    tester,
  ) async {
    // Without onRowTap — rows are plain, no InkWell-tappable behavior.
    final notifications = [
      _alert(id: 1, message: 'Too warm', instanceName: 'Fridge A'),
    ];
    await _pump(tester, notifications: notifications);

    // Tap where the row is; nothing should crash or navigate.
    await tester.tap(find.text('Too warm'));
    await tester.pumpAndSettle();
    expect(find.text('Fridge A'), findsOneWidget);

    // With onRowTap — tapping the row fires the drill-down callback.
    TriggerNotification? tapped;
    await _pump(
      tester,
      notifications: notifications,
      onRowTap: (n) => tapped = n,
    );
    await tester.tap(find.text('Too warm'));
    await tester.pumpAndSettle();
    expect(tapped?.id, 1);
  });
}
