import '../../l10n/app_localizations.dart';
import '../network/backend_rest_client.dart';

/// Turns a caught error into something a user can actually act on
/// (2026-10-03, direct founder feedback: a raw
/// `BackendRequestException(401): {"code":"42501",...}` snackbar is
/// "undecipherable text" — if something caused the error, the message
/// should say how to fix it, not just that it happened).
///
/// Only [BackendRequestException] carries enough structure to say
/// anything specific (its `isRlsRejection` getter already distinguishes
/// "blocked by a permission policy" from any other failure); everything
/// else — a timeout, a parse failure, a plain network drop — gets one
/// generic, still-actionable message rather than its raw `toString()`.
String friendlyErrorMessage(AppLocalizations l10n, Object error) {
  // A caller that already built its own user-facing string (e.g.
  // `LoadErrorView(error: l10n.noSignedInUserError, ...)`) is trusted
  // as-is — only a raw thrown exception gets translated.
  if (error is String) return error;
  if (error is BackendRequestException) {
    if (error.isRlsRejection || error.statusCode == 401 || error.statusCode == 403) {
      return l10n.permissionDeniedMessage;
    }
    return l10n.genericSaveFailedMessage;
  }
  return l10n.somethingWentWrong;
}

/// Same distinction as [friendlyErrorMessage], in plain English — for the
/// admin console, which is internal-only (superadmin/support staff) and
/// has no localization of its own.
String friendlyAdminErrorMessage(Object error) {
  if (error is BackendRequestException) {
    if (error.isRlsRejection || error.statusCode == 401 || error.statusCode == 403) {
      return "You don't have permission to do this.";
    }
    return "This didn't save. Please try again, and let engineering know if it keeps happening.";
  }
  return 'Something went wrong. Please try again.';
}
