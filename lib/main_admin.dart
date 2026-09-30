import 'package:flutter/material.dart';

import 'admin/admin_app.dart';
import 'core/network/supabase_client.dart';

/// Separate entry point for the VenuRite team's own admin tool (Plan B,
/// 2026-09-30) — built with `flutter build web -t lib/main_admin.dart`,
/// deployed to its own subdomain, never bundled into the customer-facing
/// app. See PHASE_2_ROADMAP.md for why this is a second entry point in
/// the same project rather than a separate codebase: it shares
/// core/network and admin/repositories' own use of the exact same
/// Supabase backend and Dart models, at zero duplication cost.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const AdminApp());
}
