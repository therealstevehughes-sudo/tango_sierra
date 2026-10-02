import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_shift_log_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/site_providers.dart' show siteRepositoryProvider;
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../tasks/task_controller.dart';
import 'shift_verification_flow.dart';

// "End shift" (2026-09-24, direct user request) — replaces a plain
// "Log out" for base tier: shows what's still not done before actually
// signing out, then records clockOutAt on today's open ShiftLog (see its
// own doc comment for why this is a habit-tracking signal, not a payroll
// record). Shared between hub screens rather than duplicated in each.
Future<void> endShift(
  BuildContext context,
  WidgetRef ref,
  User user,
) async {
  final controller = TaskController(
    ref.read(taskSubmissionRepositoryProvider),
    ref.read(taskScheduleRepositoryProvider),
    ref.read(taskTemplateRepositoryProvider),
    ref.read(equipmentRepositoryProvider),
    user,
    ref.read(notificationRuleRepositoryProvider),
    ref.read(triggerNotificationRepositoryProvider),
    ref.read(userRepositoryProvider),
    ref.read(problemRegisterRepositoryProvider),
    null,
    ref.read(shiftLogRepositoryProvider),
  );

  List<String> missedTitles = [];
  try {
    await controller.loadTasks();
    missedTitles = controller.tasks
        .where((t) => t.isOverdue)
        .map((t) => t.displayTitle)
        .toList();
  } catch (_) {
    // Best-effort — a failed lookup should never trap someone at the end
    // of their shift; fall through to the confirmation with an empty list.
  }

  if (!context.mounted) return;

  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.endShift),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (missedTitles.isEmpty)
            Text(l10n.everythingsDone)
          else ...[
            Text(
              l10n.tasksNotCompletedCount(missedTitles.length),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (final title in missedTitles)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '- $title',
                  style: const TextStyle(color: AppColors.critical),
                ),
              ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.backToShiftLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.finishShiftLabel),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    final shiftLogRepo = ref.read(shiftLogRepositoryProvider);
    final open = await shiftLogRepo.getOpenShift(user.id);
    if (open != null) await shiftLogRepo.clockOut(open.id);
  } catch (_) {
    // Best-effort, same reasoning as clock-in — never blocks logging out.
  }

  // Shift verification photos — additive, backend-only, no-op unless the
  // site has it enabled. Same reasoning as the Shift Welcome screen's own
  // wiring: runs after the plain habit-tracker clock-out above, never
  // instead of it.
  final siteId = user.siteId;
  if (siteId != null && context.mounted) {
    try {
      final site = await ref.read(siteRepositoryProvider).getById(siteId);
      if (site != null && context.mounted) {
        final open = await ref
            .read(backendShiftLogRepositoryProvider)
            .getOpenShift(userId: user.id, siteId: siteId);
        if (open != null && context.mounted) {
          await runShiftVerificationStep(
            context: context,
            ref: ref,
            user: user,
            site: site,
            which: 'out',
            existingShiftLogId: open.id,
          );
        }
      }
    } catch (_) {
      // Best-effort, same reasoning as above.
    }
  }

  ref.read(currentUserProvider.notifier).state = null;
}
