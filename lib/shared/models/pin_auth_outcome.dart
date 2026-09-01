import 'user.dart';

// Phase 2 (real backend auth) — replaces a plain User?/null return so the
// UI can tell "wrong PIN" apart from "temporarily locked" (a real,
// server-enforced state once backend auth is live) rather than showing the
// same generic error for both. The local-only path (backend auth off, or
// this user not yet synced to the backend) only ever produces success or
// incorrect — locked/error are backend-specific outcomes.
sealed class PinAuthOutcome {
  const PinAuthOutcome();
}

class PinAuthSuccess extends PinAuthOutcome {
  const PinAuthSuccess(this.user, {this.accessToken});
  final User user;
  // Null when authenticated via the local-only fallback (no backend
  // session exists in that case) — non-null once verified via the backend.
  final String? accessToken;
}

class PinAuthIncorrect extends PinAuthOutcome {
  const PinAuthIncorrect();
}

class PinAuthLocked extends PinAuthOutcome {
  const PinAuthLocked(this.lockedUntil);
  final DateTime lockedUntil;
}

class PinAuthNotFound extends PinAuthOutcome {
  const PinAuthNotFound();
}

// Network/server trouble reaching the backend — distinct from "wrong PIN"
// so the UI can say "couldn't reach the server" instead of implying the
// PIN itself was wrong.
class PinAuthError extends PinAuthOutcome {
  const PinAuthError(this.message);
  final String message;
}
