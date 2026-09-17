import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/backend_rest_client.dart';
import '../../shared/models/issue.dart';
import '../../shared/providers/backend_providers.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/repositories/issue_repository.dart';
import 'task_model.dart';

/// End-of-shift digest (2026-09-17) — the other half of the push-vs-digest
/// split the user asked for: Accident/Incident, escalations, and
/// damaged-stock supply problems already push immediately (see
/// `SupabaseIssueRepository`); everything routine (task FAILs, Not
/// Completed, ordinary Complaints, Venue/Other issues, undamaged supply
/// problems) batches into ONE push sent when a worker's session ends,
/// rather than pinging a manager's phone all day for routine activity.
///
/// Backend-only (same as every other push feature) — a local-only install
/// has nowhere to send a push, so this is a silent no-op there, not an
/// error.
class EndOfShiftDigestService {
  EndOfShiftDigestService(this._client, this._issueRepository);

  final BackendRestClient _client;
  final IssueRepository _issueRepository;

  /// Sends one digest push to every active supervisor+ at [siteId],
  /// summarising [workerName]'s just-ended session. Silently sends
  /// nothing if there's genuinely nothing to report — a manager
  /// shouldn't be pinged about a shift with zero fails, zero not-
  /// completed, and zero routine issues.
  Future<void> sendDigest({
    required int siteId,
    required int workerId,
    required String workerName,
    required DateTime sessionStartedAt,
    required SessionStats stats,
    // Only meaningful on an early-exit session (leaving before finishing
    // — see TaskController.logRemainingAsNotCompleted): the number of
    // tasks that session just logged as NOT_COMPLETED. A naturally
    // completed session always passes 0 here, since by definition
    // nothing was left unfinished.
    int notCompletedCount = 0,
  }) async {
    try {
      final raised = await _issueRepository.getRaisedByUser(workerId);
      final routineIssues = raised.where((i) {
        if (i.raisedAt.isBefore(sessionStartedAt)) return false;
        // The exact inverse of SupabaseIssueRepository's "urgent" set —
        // those already pushed immediately and must not be double-counted
        // here.
        final isUrgent =
            i.type == IssueType.accident ||
            i.type == IssueType.incident ||
            (i.type == IssueType.supplyProblem &&
                i.deliveryProblemType == DeliveryProblemType.damagedStock);
        return !isUrgent;
      }).toList();

      if (stats.failCount == 0 &&
          notCompletedCount == 0 &&
          routineIssues.isEmpty) {
        return;
      }

      final parts = <String>[];
      if (stats.failCount > 0) {
        parts.add('${stats.failCount} fail${stats.failCount == 1 ? '' : 's'}');
      }
      if (notCompletedCount > 0) {
        parts.add('$notCompletedCount not completed');
      }
      if (routineIssues.isNotEmpty) {
        parts.add(
          '${routineIssues.length} issue${routineIssues.length == 1 ? '' : 's'} raised',
        );
      }

      final managers = await _client.select(
        'users',
        query:
            'site_id=eq.$siteId'
            '&role_tier=in.(supervisor,venueManager,regional,executive)'
            '&active=eq.true&select=id',
      );
      for (final manager in managers) {
        await _client.invokeFunction('send-push', {
          'user_id': manager['id'],
          'title': 'Shift summary — $workerName',
          'body': parts.join(', '),
        });
      }
    } catch (_) {
      // No network, no managers with a registered device, or the
      // function itself unreachable — the shift's own data is already
      // safely recorded regardless of whether the digest could be sent.
    }
  }
}

final endOfShiftDigestServiceProvider = Provider<EndOfShiftDigestService>((
  ref,
) {
  return EndOfShiftDigestService(
    ref.watch(backendRestClientProvider),
    ref.watch(issueRepositoryProvider),
  );
});
