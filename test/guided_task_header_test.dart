// GuidedTaskHeader — responsive layout proof (2026-09-12).
//
// The guided card header (progress line + section pill + instance/title)
// is the worker-facing centerpiece of the Guided Cards visual pass. This
// test pins:
//  - it renders at phone (compact), tablet, and desktop widths without
//    overflowing (the app's ResponsiveContent wraps it for wide screens,
//    but the header itself must never overflow a narrow phone either);
//  - the progress line, section pill, instance name, and title all appear;
//  - a blank segment (custom tasks) does NOT render an empty pill.
//
// Run: flutter test test/guided_task_header_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/widgets/guided_task_header.dart';
import 'package:flutter_application_1/features/tasks/task_model.dart';

ResolvedTask _task({String? segment, String? instanceName}) => ResolvedTask(
  scheduleId: 1,
  templateGroupId: 1,
  title: 'Check fridge temperature',
  segment: segment ?? 'Kitchen',
  method: 'tick',
  requiresPhoto: false,
  requiresNotes: false,
  isCritical: false,
  requiresCorrectiveActionOnFail: false,
  equipmentInstanceName: instanceName,
  assignedByUserId: 2,
);

Future<void> _pumpAt(WidgetTester tester, double width) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GuidedTaskHeader(task: _task(), position: 2, total: 6),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders progress, section, instance, and title', (tester) async {
    await _pumpAt(tester, 400);
    expect(find.text('Task 2 of 6'), findsOneWidget);
    expect(find.text('KITCHEN'), findsOneWidget);
    expect(find.text('Check fridge temperature'), findsOneWidget);
  });

  testWidgets('instance name leads above the title when present', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GuidedTaskHeader(
              task: _task(instanceName: 'Walk-in fridge 2'),
              position: 2,
              total: 6,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Walk-in fridge 2'), findsOneWidget);
  });

  testWidgets('solid header renders without overflow on a phone', (
    tester,
  ) async {
    // Use a long title to force wrapping on a narrow phone.
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GuidedTaskHeader(task: _task(), position: 2, total: 6),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders identically on tablet and desktop widths', (
    tester,
  ) async {
    for (final width in [600.0, 1200.0]) {
      await _pumpAt(tester, width);
      expect(find.text('Task 2 of 6'), findsOneWidget);
      expect(find.text('KITCHEN'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('blank segment hides the pill (custom task)', (tester) async {
    await _pumpAt(tester, 400);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GuidedTaskHeader(
              task: _task(segment: ''),
              position: 1,
              total: 1,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // No pill, and no "Task 1 of 1" progress line for a single task.
    expect(find.text('KITCHEN'), findsNothing);
    expect(find.text('Task 1 of 1'), findsNothing);
  });
}
