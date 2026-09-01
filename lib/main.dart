import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/network/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Phase 2 (real backend auth) — failure here shouldn't block the app from
  // starting at all: local-only login keeps working with no backend
  // reachable, which is the whole point of the safe-add-on design.
  try {
    await initSupabase();
  } catch (_) {
    // No network / backend unreachable at launch — fine, local auth still
    // works. backendAuthEnabledProvider being on with no live Supabase
    // client would surface as a per-login "could not reach the server"
    // error instead, not a startup crash.
  }
  runApp(const ProviderScope(child: MyApp()));
}
