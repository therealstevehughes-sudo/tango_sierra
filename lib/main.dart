import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  // Realtime push (2026-09-16) — only the Android app is registered with
  // Firebase so far (google-services.json is Android-only); Windows is
  // this app's primary desktop target and has no Firebase config at all.
  // Skipping outright on non-Android rather than calling
  // Firebase.initializeApp() and catching the guaranteed failure — same
  // "don't block startup" principle as the Supabase try/catch above, just
  // decided before the call instead of after it.
  if (!kIsWeb && Platform.isAndroid) {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // No network at launch, or the config is somehow missing — push
      // just won't work this session, not a startup crash.
    }
  }
  runApp(const ProviderScope(child: MyApp()));
}
