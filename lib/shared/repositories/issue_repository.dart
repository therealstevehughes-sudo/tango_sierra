import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/issue.dart';

// Issues & Incidents (built 2026-09-15). Deliberately never date-bounded,
// same reasoning as ProblemRegisterRepository: an unresolved issue must
// stay visible until someone actually closes it, not age out of a list.
enum IssueFilter { all, open, resolved, escalated }

abstract class IssueRepository {
  /// Every issue at [siteId], newest first. Any staff member can see
  /// this (matches "any staff raises, managers resolve" — raising and
  /// seeing the register are both open; only adding process/outcome
  /// events is gated by the caller's own screen access).
  Future<List<Issue>> getForSite(int siteId, {IssueFilter filter});

  /// An individual's own raised issues — read-only view for a base
  /// worker to see the live status of what they raised (confirmed with
  /// the user: yes, they should be able to, so "nothing silently
  /// disappears" means something to the person who raised it).
  Future<List<Issue>> getRaisedByUser(int userId);

  Future<List<IssueEvent>> getHistory(int issueId);

  /// Raises a new issue — any staff tier. Writes the issue row and its
  /// first event (phase=details) atomically.
  Future<Issue> raise({
    required int siteId,
    required IssueType type,
    String? subtype,
    required String details,
    required int raisedByUserId,
    int? supplierId,
    DeliveryProblemType? deliveryProblemType,
    int? receivedByUserId,
  });

  /// Adds a process update — the issue stays open (or escalated, if it
  /// already was) rather than resolving it; use [resolve]/[escalate]
  /// for those. Supervisor+ only, enforced by the calling screen.
  Future<void> addProcessNote({
    required int issueId,
    required String note,
    required int byUserId,
  });

  Future<void> resolve({
    required int issueId,
    required String note,
    required int byUserId,
  });

  /// Manual escalation only in this build (confirmed with the user —
  /// automatic threshold-based escalation is deferred; issue types would
  /// need different SLAs decided first, e.g. an accident vs. a late
  /// delivery).
  Future<void> escalate({
    required int issueId,
    required String note,
    required int byUserId,
  });
}

class DriftIssueRepository implements IssueRepository {
  DriftIssueRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Issue>> getForSite(
    int siteId, {
    IssueFilter filter = IssueFilter.all,
  }) async {
    final query = _db.select(_db.issues)
      ..where((i) => i.siteId.equals(siteId))
      ..orderBy([(i) => OrderingTerm.desc(i.raisedAt)]);
    switch (filter) {
      case IssueFilter.all:
        break;
      case IssueFilter.open:
        query.where((i) => i.status.equals('open'));
      case IssueFilter.resolved:
        query.where((i) => i.status.equals('resolved'));
      case IssueFilter.escalated:
        query.where((i) => i.status.equals('escalated'));
    }
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Issue>> getRaisedByUser(int userId) async {
    final query = _db.select(_db.issues)
      ..where((i) => i.raisedByUserId.equals(userId))
      ..orderBy([(i) => OrderingTerm.desc(i.raisedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<IssueEvent>> getHistory(int issueId) async {
    final query = _db.select(_db.issueEvents)
      ..where((e) => e.issueId.equals(issueId))
      ..orderBy([(e) => OrderingTerm.asc(e.changedAt)]);
    final rows = await query.get();
    return rows.map(_toEventModel).toList();
  }

  @override
  Future<Issue> raise({
    required int siteId,
    required IssueType type,
    String? subtype,
    required String details,
    required int raisedByUserId,
    int? supplierId,
    DeliveryProblemType? deliveryProblemType,
    int? receivedByUserId,
  }) async {
    final now = DateTime.now();
    late int issueId;
    await _db.transaction(() async {
      issueId = await _db
          .into(_db.issues)
          .insert(
            IssuesCompanion.insert(
              siteId: siteId,
              type: type.name,
              subtype: Value(subtype),
              details: details,
              raisedByUserId: raisedByUserId,
              raisedAt: now,
              status: const Value('open'),
              supplierId: Value(supplierId),
              deliveryProblemType: Value(deliveryProblemType?.name),
              receivedByUserId: Value(receivedByUserId),
            ),
          );
      await _db
          .into(_db.issueEvents)
          .insert(
            IssueEventsCompanion.insert(
              issueId: issueId,
              phase: IssueEventPhase.details.name,
              note: details,
              changedByUserId: raisedByUserId,
              changedAt: now,
              resultingStatus: 'open',
            ),
          );
    });
    final row = await (_db.select(
      _db.issues,
    )..where((i) => i.id.equals(issueId))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> addProcessNote({
    required int issueId,
    required String note,
    required int byUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.process,
    note: note,
    byUserId: byUserId,
    resultingStatus: null, // status unchanged
  );

  @override
  Future<void> resolve({
    required int issueId,
    required String note,
    required int byUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.outcome,
    note: note,
    byUserId: byUserId,
    resultingStatus: IssueStatus.resolved,
  );

  @override
  Future<void> escalate({
    required int issueId,
    required String note,
    required int byUserId,
  }) => _recordEvent(
    issueId: issueId,
    phase: IssueEventPhase.process,
    note: note,
    byUserId: byUserId,
    resultingStatus: IssueStatus.escalated,
  );

  Future<void> _recordEvent({
    required int issueId,
    required IssueEventPhase phase,
    required String note,
    required int byUserId,
    required IssueStatus? resultingStatus,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(
        _db.issues,
      )..where((i) => i.id.equals(issueId))).getSingle();
      final newStatus = resultingStatus?.name ?? current.status;
      await _db
          .into(_db.issueEvents)
          .insert(
            IssueEventsCompanion.insert(
              issueId: issueId,
              phase: phase.name,
              note: note,
              changedByUserId: byUserId,
              changedAt: DateTime.now(),
              resultingStatus: newStatus,
            ),
          );
      if (resultingStatus != null) {
        await (_db.update(
          _db.issues,
        )..where((i) => i.id.equals(issueId))).write(
          IssuesCompanion(status: Value(newStatus)),
        );
      }
    });
  }

  Issue _toModel(IssueEntity row) => Issue(
    id: row.id,
    siteId: row.siteId,
    type: IssueType.values.byName(row.type),
    subtype: row.subtype,
    details: row.details,
    raisedByUserId: row.raisedByUserId,
    raisedAt: row.raisedAt,
    status: IssueStatus.values.byName(row.status),
    supplierId: row.supplierId,
    deliveryProblemType: row.deliveryProblemType == null
        ? null
        : DeliveryProblemType.values.byName(row.deliveryProblemType!),
    receivedByUserId: row.receivedByUserId,
  );

  IssueEvent _toEventModel(IssueEventEntity row) => IssueEvent(
    id: row.id,
    issueId: row.issueId,
    phase: IssueEventPhase.values.byName(row.phase),
    note: row.note,
    changedByUserId: row.changedByUserId,
    changedAt: row.changedAt,
    resultingStatus: IssueStatus.values.byName(row.resultingStatus),
  );
}
