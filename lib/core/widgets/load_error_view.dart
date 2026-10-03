import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../errors/friendly_error.dart';
import '../../l10n/app_localizations.dart';
import 'primary_action_button.dart';

/// Shown in a screen's body when its initial data load throws (2026-09-28,
/// direct founder report of a screen hanging on a spinner forever with no
/// way to tell why or retry). Pairs with the loading-guard rule: the real
/// `Scaffold`/header always renders regardless of load state, so this
/// only ever replaces the body — never strands the user on a blank screen.
///
/// Takes the raw error ([error] can be a `String` already built by a
/// caller, or the original caught `Object`) and translates it itself via
/// [friendlyErrorMessage] (2026-10-03, direct founder feedback: showing
/// the raw `e.toString()` — e.g. a `BackendRequestException` with a raw
/// Postgres error code — is "undecipherable text"; a user who hits a
/// permission error needs to be told to ask a manager, not shown JSON).
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.critical, size: 40),
            const SizedBox(height: 12),
            Text(l10n.couldntLoadScreen),
            const SizedBox(height: 4),
            Text(
              friendlyErrorMessage(l10n, error),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            PrimaryActionButton(label: l10n.retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
