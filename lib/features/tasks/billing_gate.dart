import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/providers/subscription_providers.dart';

// Billing enforcement (2026-09-24) — the one place every task-submission
// call site checks before actually writing. See isBillingRestrictedProvider's
// own doc comment for the fail-open reasoning. Deliberately a plain
// function, not baked into TaskController itself — TaskController has no
// provider/ref access (it's constructed with concrete repositories, used
// from both Riverpod and plain-Dart contexts), so the gate lives at the
// UI layer, right before each of the 3 places that call
// TaskController.logTaskSubmission.
//
// Returns true if the submission should proceed. On a restricted
// account, shows a plain explanation (never a silent failure -- the
// worker did the work, they deserve to know why it wasn't saved).
// Deliberately no "Go to Billing" shortcut here -- Billing is exec-only
// (see BillingScreen's own doc comment), and most people hitting this
// gate won't be executives; the dialog tells them who to actually go to
// instead of offering a link that would fail for their tier.
Future<bool> canSubmitTask(BuildContext context, WidgetRef ref) async {
  final restricted = await ref.read(isBillingRestrictedProvider.future);
  if (!restricted) return true;
  if (!context.mounted) return false;

  await showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(l10n.accountRestrictedTitle),
        content: Text(l10n.accountRestrictedBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      );
    },
  );
  return false;
}
