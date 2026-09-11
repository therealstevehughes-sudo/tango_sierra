import 'package:supabase_flutter/supabase_flutter.dart';

// Phase 2 (real backend auth). ANON_KEY is meant to be public — it ships
// inside the compiled app on every device, protected by row-level security
// and server-side checks, not by secrecy. SERVICE_ROLE_KEY must NEVER
// appear anywhere in this app.
class BackendConfig {
  static const supabaseUrl = 'https://api.venurite.com';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzg4MTg1NDkzLCJleHAiOjIxMDM1NDU0OTN9.-6jGDfhNRlvx3pyrZ7st_0Hf5V-L94REOaDW0FgUdNI';
}

Future<void> initSupabase() async {
  // anonKey (not the newer publishableKey) deliberately — the newer
  // publishable/secret key format isn't configured on this self-hosted
  // stack yet (still blank in its .env); the legacy anon/service_role JWT
  // keys are what every other part of this backend actually uses today.
  await Supabase.initialize(
    url: BackendConfig.supabaseUrl,
    // The self-hosted stack currently uses the legacy anon JWT key.
    // ignore: deprecated_member_use
    anonKey: BackendConfig.supabaseAnonKey,
  );
}

SupabaseClient get supabase => Supabase.instance.client;
