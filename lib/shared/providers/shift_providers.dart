import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/backend_polling_stream.dart';
import '../models/shift.dart';
import '../repositories/shift_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => SupabaseShiftRepository(ref.watch(backendRestClientProvider)),
);

/// One-shot fetch of a site's shifts, newest-starting-first-loaded. Callers
/// reload by invalidating this provider after a mutation (post/claim/
/// cancel), same pattern as every other screen-local list in this app.
/// Kept alongside [shiftsStreamForSiteProvider] below rather than replaced
/// by it — some call sites only ever need a single fetch.
final shiftsForSiteProvider = FutureProvider.family<List<Shift>, int>(
  (ref, siteId) => ref.watch(shiftRepositoryProvider).getForSite(siteId),
);

/// Live-ish shift board (R7, 2026-09-27) — polls every 20s and only emits
/// when the shift list actually changed, so a second manager/staff member's
/// action shows up without a manual pull-to-refresh. Uses the app's
/// existing backendPollingStream interim pattern rather than real Supabase
/// Realtime: this app has never verified Realtime's websocket auth model
/// against the PIN-session token BackendRestClient uses (see that class's
/// own doc comment), so polling was the deliberate, lower-risk choice here
/// — see DECISIONS_LOG.md's R7 entry.
final shiftsStreamForSiteProvider = StreamProvider.family<List<Shift>, int>((
  ref,
  siteId,
) {
  final repository = ref.watch(shiftRepositoryProvider);
  return backendPollingStream<List<Shift>>(
    fetch: () => repository.getForSite(siteId),
    identity: (shifts) => listIdentity(
      shifts.map((s) => '${s.id}:${s.status}:${s.claimedByUserId}'),
    ),
  );
});
