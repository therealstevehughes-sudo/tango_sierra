import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/repositories/trigger_notification_repository.dart';
import '../../shared/repositories/user_repository.dart';

// Fixed threshold for v1 (Sprint 022) — per-rule configurability is a real,
// separable follow-up, deferred per DECISIONS_LOG's escalation decision.
const escalationThreshold = Duration(minutes: 30);

class EscalationService {
  EscalationService(
    this._triggerNotificationRepository,
    this._userRepository,
  );

  final TriggerNotificationRepository _triggerNotificationRepository;
  final UserRepository _userRepository;

  // Scans unacknowledged notifications and, for any that are past the
  // threshold and haven't already been escalated, creates a new
  // notification addressed to top tier at the same site and marks the
  // original as escalated. Notifications whose firing rule already
  // targeted top tier are skipped — there's nobody further up to escalate
  // to, so they only get visual re-surfacing in the banner UI.
  Future<void> checkAndEscalate() async {
    final unacknowledged = await _triggerNotificationRepository
        .getAllUnacknowledged();
    final now = DateTime.now();

    final due = unacknowledged.where((notification) {
      if (notification.escalatedAt != null) return false;
      if (notification.originTargetRoleTier == RoleTier.top) return false;
      return now.difference(notification.createdAt) >= escalationThreshold;
    }).toList();

    if (due.isEmpty) return;

    final allUsers = await _userRepository.getAll();

    for (final notification in due) {
      final topTierRecipients = allUsers.where(
        (u) => u.roleTier == RoleTier.top && u.siteId == notification.siteId,
      );

      for (final recipient in topTierRecipients) {
        await _triggerNotificationRepository.create(
          notificationRuleId: notification.notificationRuleId,
          taskSubmissionId: notification.taskSubmissionId,
          recipientUserId: recipient.id,
          message: 'ESCALATED (unacknowledged): ${notification.message}',
          siteId: notification.siteId,
          originTargetRoleTier: RoleTier.top,
        );
      }

      await _triggerNotificationRepository.markEscalated(notification.id);
    }
  }
}

final escalationServiceProvider = Provider<EscalationService>((ref) {
  final triggerNotificationRepository = ref.watch(
    triggerNotificationRepositoryProvider,
  );
  final userRepository = ref.watch(userRepositoryProvider);
  return EscalationService(triggerNotificationRepository, userRepository);
});
