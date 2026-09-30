// "Urgent" badge on the Leadership Dashboard's Incidents card (2026-09-20)
// — pure-model coverage for IncidentsBreakdown.urgent, since the getter's
// whole point is a specific, easy-to-get-wrong rule: additive-only,
// resolution-status-orthogonal, and never counting an already-resolved
// issue no matter how stale it once was.
import 'package:venurite/features/dashboard/leadership_dashboard_service.dart';
import 'package:venurite/shared/models/issue.dart';
import 'package:flutter_test/flutter_test.dart';

Issue _issue({
  required int id,
  required IssueStatus status,
  required DateTime raisedAt,
  bool manualUrgent = false,
}) {
  return Issue(
    id: id,
    siteId: 1,
    type: IssueType.other,
    details: 'test issue $id',
    raisedByUserId: 1,
    raisedAt: raisedAt,
    status: status,
    manualUrgent: manualUrgent,
  );
}

void main() {
  final now = DateTime.now();

  test('a fresh unresolved issue (under 24h) is not urgent', () {
    final breakdown = IncidentsBreakdown(
      resolved: const [],
      unresolved: [
        _issue(id: 1, status: IssueStatus.open, raisedAt: now.subtract(const Duration(hours: 1))),
      ],
      escalated: const [],
    );
    expect(breakdown.urgent, isEmpty);
  });

  test('an unresolved issue older than 72h is urgent', () {
    final stale = _issue(
      id: 2,
      status: IssueStatus.open,
      raisedAt: now.subtract(const Duration(hours: 73)),
    );
    final breakdown = IncidentsBreakdown(
      resolved: const [],
      unresolved: [stale],
      escalated: const [],
    );
    expect(breakdown.urgent, [stale]);
  });

  test('every escalated issue counts as urgent regardless of age', () {
    final freshlyEscalated = _issue(
      id: 3,
      status: IssueStatus.escalated,
      raisedAt: now.subtract(const Duration(minutes: 5)),
    );
    final breakdown = IncidentsBreakdown(
      resolved: const [],
      unresolved: const [],
      escalated: [freshlyEscalated],
    );
    expect(breakdown.urgent, [freshlyEscalated]);
  });

  test('manualUrgent forces urgency even on a brand-new unresolved issue', () {
    final manuallyFlagged = _issue(
      id: 4,
      status: IssueStatus.open,
      raisedAt: now,
      manualUrgent: true,
    );
    final breakdown = IncidentsBreakdown(
      resolved: const [],
      unresolved: [manuallyFlagged],
      escalated: const [],
    );
    expect(breakdown.urgent, [manuallyFlagged]);
  });

  test(
    'a resolved issue never counts as urgent, even if it sat unresolved '
    'past 72h before being resolved',
    () {
      final oldButResolved = _issue(
        id: 5,
        status: IssueStatus.resolved,
        raisedAt: now.subtract(const Duration(days: 10)),
      );
      final breakdown = IncidentsBreakdown(
        resolved: [oldButResolved],
        unresolved: const [],
        escalated: const [],
      );
      expect(breakdown.urgent, isEmpty);
    },
  );

  test('urgent count reflects a mix of qualifying and non-qualifying issues', () {
    final freshUnresolved = _issue(
      id: 6,
      status: IssueStatus.open,
      raisedAt: now.subtract(const Duration(hours: 2)),
    );
    final staleUnresolved = _issue(
      id: 7,
      status: IssueStatus.open,
      raisedAt: now.subtract(const Duration(hours: 100)),
    );
    final escalated = _issue(
      id: 8,
      status: IssueStatus.escalated,
      raisedAt: now,
    );
    final resolved = _issue(
      id: 9,
      status: IssueStatus.resolved,
      raisedAt: now.subtract(const Duration(hours: 200)),
    );
    final breakdown = IncidentsBreakdown(
      resolved: [resolved],
      unresolved: [freshUnresolved, staleUnresolved],
      escalated: [escalated],
    );
    expect(breakdown.urgent, unorderedEquals([staleUnresolved, escalated]));
  });
}
