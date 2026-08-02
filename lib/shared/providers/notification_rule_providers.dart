import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/notification_rule_repository.dart';
import '../repositories/trigger_notification_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final notificationRuleRepositoryProvider =
    Provider<NotificationRuleRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return DriftNotificationRuleRepository(db);
    });

final triggerNotificationRepositoryProvider =
    Provider<TriggerNotificationRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return DriftTriggerNotificationRepository(db);
    });
