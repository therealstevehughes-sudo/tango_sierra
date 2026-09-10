import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/notification_rule_repository.dart';
import '../repositories/supabase_notification_rule_repository.dart';
import '../repositories/supabase_trigger_notification_repository.dart';
import '../repositories/trigger_notification_repository.dart';
import 'auth_providers.dart'
    show backendDataEnabledProvider, currentBackendOrganisationIdProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final notificationRuleRepositoryProvider =
    Provider<NotificationRuleRepository>((ref) {
      if (ref.watch(backendDataEnabledProvider)) {
        return SupabaseNotificationRuleRepository(
          ref.watch(backendRestClientProvider),
          () => ref.read(currentBackendOrganisationIdProvider) ??
              (throw StateError(
                'No organisation_id claim on the current session — cannot '
                'save a tenant-scoped notification rule.',
              )),
        );
      }
      final db = ref.watch(appDatabaseProvider);
      return DriftNotificationRuleRepository(db);
    });

final triggerNotificationRepositoryProvider =
    Provider<TriggerNotificationRepository>((ref) {
      if (ref.watch(backendDataEnabledProvider)) {
        return SupabaseTriggerNotificationRepository(
          ref.watch(backendRestClientProvider),
        );
      }
      final db = ref.watch(appDatabaseProvider);
      return DriftTriggerNotificationRepository(db);
    });
