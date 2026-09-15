// Issues & Incidents (built 2026-09-15) -- freestanding problem capture.
// See app_database.dart's `Issues` table doc comment for why this is
// deliberately separate from the task-fail-triggered ProblemStatusEvent,
// and for the governing anti-gaming rule (individual attribution never
// penalized; aggregate leadership dashboards are legitimate and a later,
// separate piece, not part of this build).
enum IssueType { complaint, accident, incident, supplyProblem, venueProblem, other }

enum IssueStatus { open, resolved, escalated }

enum DeliveryProblemType {
  lateDelivery,
  shortDelivery,
  incorrectDelivery,
  damagedStock,
  driverProblem,
  other,
}

class Issue {
  final int id;
  final int siteId;
  final IssueType type;
  final String? subtype;
  final String details;
  final int raisedByUserId;
  final DateTime raisedAt;
  final IssueStatus status;
  final int? supplierId;
  final DeliveryProblemType? deliveryProblemType;
  final int? receivedByUserId;

  const Issue({
    required this.id,
    required this.siteId,
    required this.type,
    this.subtype,
    required this.details,
    required this.raisedByUserId,
    required this.raisedAt,
    required this.status,
    this.supplierId,
    this.deliveryProblemType,
    this.receivedByUserId,
  });
}

/// The Details -> Process -> Outcome lifecycle, as an append-only event
/// log -- same shape as `ProblemStatusEvent`, generalised to more than
/// two phases (see `IssueEvents`' table doc comment).
enum IssueEventPhase { details, process, outcome }

class IssueEvent {
  final int id;
  final int issueId;
  final IssueEventPhase phase;
  final String note;
  final int changedByUserId;
  final DateTime changedAt;
  final IssueStatus resultingStatus;

  const IssueEvent({
    required this.id,
    required this.issueId,
    required this.phase,
    required this.note,
    required this.changedByUserId,
    required this.changedAt,
    required this.resultingStatus,
  });
}

/// Human-facing labels -- kept here, alongside the models, rather than
/// scattered per-screen so every list/filter/form uses the same wording.
String issueTypeDisplayName(IssueType type) {
  switch (type) {
    case IssueType.complaint:
      return 'Complaint';
    case IssueType.accident:
      return 'Accident';
    case IssueType.incident:
      return 'Incident';
    case IssueType.supplyProblem:
      return 'Supply Problem';
    case IssueType.venueProblem:
      return 'Venue Problem';
    case IssueType.other:
      return 'Other';
  }
}

String issueStatusDisplayName(IssueStatus status) {
  switch (status) {
    case IssueStatus.open:
      return 'Unresolved';
    case IssueStatus.resolved:
      return 'Resolved';
    case IssueStatus.escalated:
      return 'Escalated';
  }
}

String deliveryProblemTypeDisplayName(DeliveryProblemType type) {
  switch (type) {
    case DeliveryProblemType.lateDelivery:
      return 'Late delivery';
    case DeliveryProblemType.shortDelivery:
      return 'Short delivery';
    case DeliveryProblemType.incorrectDelivery:
      return 'Incorrect delivery';
    case DeliveryProblemType.damagedStock:
      return 'Damaged stock';
    case DeliveryProblemType.driverProblem:
      return 'Driver problem';
    case DeliveryProblemType.other:
      return 'Other';
  }
}

/// The subtype options for a given [IssueType] -- empty where a type has
/// no sub-category (venueProblem, other), matching the user's PDF spec
/// exactly.
List<String> issueSubtypesFor(IssueType type) {
  switch (type) {
    case IssueType.complaint:
      return const ['Dish', 'Other'];
    case IssueType.accident:
      return const ['Employee', 'Customer', 'Other'];
    case IssueType.incident:
      return const ['Employee', 'Equipment', 'Other'];
    case IssueType.supplyProblem:
    case IssueType.venueProblem:
    case IssueType.other:
      return const [];
  }
}
