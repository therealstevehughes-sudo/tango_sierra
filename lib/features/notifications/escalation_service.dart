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
  EscalationService(this._triggerNotificationRepository, this._userRepository);

  final TriggerNotificationRepository _triggerNotificationRepository;
  final UserRepository _userRepository;

  // Scans unacknowledged notifications and, for any that are past the
  // threshold and haven't already been escalated, creates a new
  // notification addressed to the NEXT tier up and marks the original as
  // escalated (Sprint 027: a problem rolls up one level, not straight to
  // the top). The reference tier is the firing rule's target tier for
  // tier-targeted notifications, or the specific recipient's own actual
  // tier for person-targeted ones (originTargetRoleTier null) — both cases
  // reduce to "escalate one level up from the relevant tier." Notifications
  // already at executive are skipped — nothing further up to escalate to,
  // so they only get visual re-surfacing in the banner UI.
  Future<void> checkAndEscalate() async {
    final unacknowledged = await _triggerNotificationRepository
        .getAllUnacknowledged();
    final now = DateTime.now();
    final allUsers = await _userRepository.getAll();

    for (final notification in unacknowledged) {
      if (notification.escalatedAt != null) continue;
      if (now.difference(notification.createdAt) < escalationThreshold) {
        continue;
      }

      var referenceTier = notification.originTargetRoleTier;
      if (referenceTier == null) {
        User? recipient;
        for (final u in allUsers) {
          if (u.id == notification.recipientUserId) {
            recipient = u;
            break;
          }
        }
        referenceTier = recipient?.roleTier;
      }
      if (referenceTier == null) continue;

      final nextTier = nextRoleTierUp(referenceTier);
      if (nextTier == null) continue;

      final nextTierRecipients = allUsers.where(
        (u) => u.roleTier == nextTier && u.siteId == notification.siteId,
      );

      for (final recipient in nextTierRecipients) {
        await _triggerNotificationRepository.create(
          notificationRuleId: notification.notificationRuleId,
          taskSubmissionId: notification.taskSubmissionId,
          recipientUserId: recipient.id,
          message: 'ESCALATED (unacknowledged): ${notification.message}',
          siteId: notification.siteId,
          originTargetRoleTier: nextTier,
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
