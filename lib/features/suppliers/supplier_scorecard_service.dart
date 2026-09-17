import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/issue.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/repositories/issue_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';

// Supplier/Delivery Scorecard (Sprint 038, 2026-09-17) — pure read-model
// aggregation over data that already exists: TaskSubmission's delivery_*
// columns (built 2026-09-15, backend-hosted) and Issue rows of type
// supplyProblem. No new table/column; mirrors LeadershipDashboardService's
// row-list-carrying style so the same click-to-drill-down bottom sheet
// pattern applies unchanged.
//
// Anti-gaming note, considered explicitly (not an oversight): this DOES
// compute a graded breakdown for a single named entity, which at first
// glance looks like the exact thing LeadershipDashboardService's own doc
// comment warns against ("never add a per-user variant... without going
// back to that guideline first"). It's fine here because that guideline
// protects INDIVIDUAL STAFF from being scored/ranked — grading a SUPPLIER
// (an external business, not a person on shift) is the explicit point of
// this feature, confirmed with the user. Nothing here reads, filters, or
// displays which staff member logged any given delivery/issue — the
// breakdown rows are delivery/issue records, not attributed to a reporter,
// and a supplier's score can never go down because someone honestly
// flagged a problem (accurate flagging is the input the score depends on).
//
// Deliberately does NOT merge Issue-sourced supply-problem reports into
// the TaskSubmission delivery counts: the two are structurally unlinked
// in this codebase (see Issue's own doc comment / BACKEND_INFRA.md) and
// merging them would misrepresent what actually happened. Shown as two
// separate sections by the screen that uses this service.
class SupplierDeliveryScorecard {
  const SupplierDeliveryScorecard({
    required this.all,
    required this.late,
    required this.short,
    required this.damaged,
    required this.qualityProblem,
    required this.rejected,
    required this.partial,
  });

  /// Every delivery-task submission for this supplier in range, regardless
  /// of outcome — the denominator for every rate below.
  final List<TaskSubmission> all;
  final List<TaskSubmission> late;
  final List<TaskSubmission> short;
  final List<TaskSubmission> damaged;
  final List<TaskSubmission> qualityProblem;
  final List<TaskSubmission> rejected;
  final List<TaskSubmission> partial;

  int get total => all.length;
  double _rate(int n) => total == 0 ? 0 : n / total;
  double get lateRate => _rate(late.length);
  double get shortRate => _rate(short.length);
  double get damagedRate => _rate(damaged.length);
  double get qualityProblemRate => _rate(qualityProblem.length);
  double get rejectedRate => _rate(rejected.length);
  double get partialRate => _rate(partial.length);
}

class SupplierScorecardService {
  SupplierScorecardService(this._submissionRepository, this._issueRepository);

  final TaskSubmissionRepository _submissionRepository;
  final IssueRepository _issueRepository;

  Future<SupplierDeliveryScorecard> computeDeliveryScorecard({
    required int siteId,
    required int supplierId,
    required DateTime start,
    required DateTime end,
  }) async {
    final submissions = await _submissionRepository.getForSiteAndDateRange(
      siteId: siteId,
      start: start,
      end: end,
    );
    final deliveries = submissions
        .where((s) => s.supplierId == supplierId)
        .toList();

    return SupplierDeliveryScorecard(
      all: deliveries,
      late: deliveries.where((s) => s.deliveryLateDelivery).toList(),
      short: deliveries.where((s) => s.deliveryShortDelivery).toList(),
      damaged: deliveries.where((s) => s.deliveryDamagedStock).toList(),
      qualityProblem: deliveries
          .where((s) => s.deliveryQualityProblem)
          .toList(),
      rejected: deliveries
          .where((s) => s.deliveryOutcome == 'rejected')
          .toList(),
      partial: deliveries.where((s) => s.deliveryOutcome == 'partial').toList(),
    );
  }

  /// Supply-problem Issues raised against this supplier in range — a
  /// separate reporting path from the delivery log above, not joinable to
  /// a specific TaskSubmission (see this file's own doc comment).
  Future<List<Issue>> getReportedIssues({
    required int siteId,
    required int supplierId,
    required DateTime start,
    required DateTime end,
  }) async {
    final issues = await _issueRepository.getForSite(siteId);
    return issues
        .where(
          (i) =>
              i.type == IssueType.supplyProblem &&
              i.supplierId == supplierId &&
              !i.raisedAt.isBefore(start) &&
              i.raisedAt.isBefore(end),
        )
        .toList();
  }
}

final supplierScorecardServiceProvider = Provider<SupplierScorecardService>((
  ref,
) {
  return SupplierScorecardService(
    ref.watch(taskSubmissionRepositoryProvider),
    ref.watch(issueRepositoryProvider),
  );
});
