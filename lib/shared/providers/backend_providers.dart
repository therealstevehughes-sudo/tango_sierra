import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/backend_rest_client.dart';
import 'auth_providers.dart' show currentBackendAccessTokenProvider;

// Phase B2 — the one BackendRestClient every Supabase*Repository provider
// reads from. Carries whichever token currentBackendAccessTokenProvider
// currently holds, read fresh per request inside the client itself (never
// cached here), so a token obtained after this provider first built its
// client is still picked up correctly.
final backendRestClientProvider = Provider<BackendRestClient>((ref) {
  return BackendRestClient(() => ref.read(currentBackendAccessTokenProvider));
});
