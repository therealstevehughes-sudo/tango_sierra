import 'dart:async';

/// Phase B5 — the interim stand-in for a push feed.
///
/// Every "live" screen in this app is powered by a `Stream` that, on the
/// local Drift path, re-emits reactively whenever that same device writes.
/// The backend path has no equivalent push without Supabase Realtime — a
/// websocket change feed with its own authorization model that this
/// project has never verified, deliberately kept as a separate follow-on
/// (see DECISIONS_LOG.md's B5 entry). Until then, a backend-backed stream
/// method polls: it fetches on listen, then on a fixed interval, and only
/// emits when the result actually changed (by a caller-supplied identity),
/// so a quiet screen isn't spammed with identical frames.
///
/// This delivers the accepted "PULL" guarantee — the manager's phone shows
/// what the tablet logged, at most one poll interval late — not a true
/// instant push. Callers that need tighter latency are what the Realtime
/// follow-on is for.
Stream<T> backendPollingStream<T>({
  required Future<T> Function() fetch,
  required Object? Function(T value) identity,
  Duration interval = const Duration(seconds: 20),
}) {
  late final StreamController<T> controller;
  Timer? timer;
  Object? lastIdentity;
  var hasEmitted = false;

  Future<void> poll() async {
    try {
      final value = await fetch();
      final id = identity(value);
      if (!hasEmitted || id != lastIdentity) {
        hasEmitted = true;
        lastIdentity = id;
        if (!controller.isClosed) controller.add(value);
      }
    } catch (error, stack) {
      if (!controller.isClosed) controller.addError(error, stack);
    }
  }

  controller = StreamController<T>(
    onListen: () {
      poll();
      timer = Timer.periodic(interval, (_) => poll());
    },
    onCancel: () {
      timer?.cancel();
      timer = null;
    },
  );

  return controller.stream;
}

/// Cheap identity for a list of rows: length plus the joined ids. Enough
/// to notice inserts, deletes, and (when an id-like field is included)
/// most updates, without deep-comparing every row.
Object listIdentity(Iterable<Object?> ids) => ids.join(',');
