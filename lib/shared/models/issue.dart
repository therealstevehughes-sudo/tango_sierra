import '../../l10n/app_localizations.dart';

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
  // Chain of command (2026-09-15) -- who this issue currently sits with,
  // if it's been escalated. Free choice at escalation time, not
  // automatically the raiser's own line manager (the issue may be about
  // that manager) -- see the Issues table's own doc comment.
  final int? escalatedToUserId;
  // Manual urgency override (2026-09-17) -- set at raise time by the
  // reporter/supervisor. Additive only: the UI's automatic time-based
  // urgency grading never lets this take an issue DOWN from urgent.
  final bool manualUrgent;
  // Section tagging (2026-09-18) -- which section/team this issue is about,
  // nominated by whoever raised it (defaults to their own section/team,
  // changeable). Both nullable: an untagged issue just has no section.
  final int? departmentId;
  final int? teamId;

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
    this.escalatedToUserId,
    this.manualUrgent = false,
    this.departmentId,
    this.teamId,
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
  // Only meaningful on an 'escalated' event -- who was chosen as the
  // target at that moment. Kept per-event, not just on the parent Issue,
  // so the history shows who it went to each time if escalated more than
  // once.
  final int? targetUserId;

  const IssueEvent({
    required this.id,
    required this.issueId,
    required this.phase,
    required this.note,
    required this.changedByUserId,
    required this.changedAt,
    required this.resultingStatus,
    this.targetUserId,
  });
}

/// Human-facing labels -- kept here, alongside the models, rather than
/// scattered per-screen so every list/filter/form uses the same wording.
///
/// [l10n] is optional because one call site (SupabaseIssueRepository's
/// push-notification title) runs server-side with no BuildContext/locale
/// available -- that path always gets the English fallback below. Every
/// UI call site passes it for a properly localized label.
String issueTypeDisplayName(IssueType type, [AppLocalizations? l10n]) {
  if (l10n == null) {
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
  switch (type) {
    case IssueType.complaint:
      return l10n.issueTypeComplaint;
    case IssueType.accident:
      return l10n.issueTypeAccident;
    case IssueType.incident:
      return l10n.issueTypeIncident;
    case IssueType.supplyProblem:
      return l10n.issueTypeSupplyProblem;
    case IssueType.venueProblem:
      return l10n.issueTypeVenueProblem;
    case IssueType.other:
      return l10n.issueTypeOther;
  }
}

String issueStatusDisplayName(IssueStatus status, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (status) {
      case IssueStatus.open:
        return 'Unresolved';
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.escalated:
        return 'Escalated';
    }
  }
  switch (status) {
    case IssueStatus.open:
      return l10n.unresolvedLabel;
    case IssueStatus.resolved:
      return l10n.resolvedLabel;
    case IssueStatus.escalated:
      return l10n.escalatedLabel;
  }
}

String deliveryProblemTypeDisplayName(
  DeliveryProblemType type, [
  AppLocalizations? l10n,
]) {
  if (l10n == null) {
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
  switch (type) {
    case DeliveryProblemType.lateDelivery:
      return l10n.lateDeliveryLabel;
    case DeliveryProblemType.shortDelivery:
      return l10n.shortDeliveryLabel;
    case DeliveryProblemType.incorrectDelivery:
      return l10n.incorrectDeliveryLabel;
    case DeliveryProblemType.damagedStock:
      return l10n.damagedStockLabel;
    case DeliveryProblemType.driverProblem:
      return l10n.driverProblemLabel;
    case DeliveryProblemType.other:
      return l10n.otherLabel;
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
