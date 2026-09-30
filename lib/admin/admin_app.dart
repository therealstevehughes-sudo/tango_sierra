import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../core/network/backend_rest_client.dart';
import 'repositories/admin_repository.dart';
import 'screens/admin_home_screen.dart';
import 'screens/admin_login_screen.dart';

enum _AuthState { checking, signedOut, notSuperadmin, signedIn }

/// Root widget for the admin tool's own entry point (main_admin.dart) —
/// entirely separate from MyApp (app.dart), never touches the tenant
/// staff system (RoleTier/PIN login/currentUserProvider). Deliberately
/// not wired through this project's Riverpod provider tree either - the
/// admin tool is small enough that plain StatefulWidget + a single
/// AdminRepository instance is simpler than importing the tenant app's
/// whole provider graph for one small tool.
class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  _AuthState _state = _AuthState.checking;
  late final AdminRepository _repository;

  @override
  void initState() {
    super.initState();
    final client = BackendRestClient(
      () => gotrue.Supabase.instance.client.auth.currentSession?.accessToken,
    );
    _repository = AdminRepository(client);
    _checkAuth();
    gotrue.Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final session = gotrue.Supabase.instance.client.auth.currentSession;
    if (session == null) {
      if (mounted) setState(() => _state = _AuthState.signedOut);
      return;
    }
    try {
      final isSuperadmin = await _repository.isCurrentUserSuperadmin();
      if (!mounted) return;
      setState(
        () => _state = isSuperadmin
            ? _AuthState.signedIn
            : _AuthState.notSuperadmin,
      );
    } catch (_) {
      if (mounted) setState(() => _state = _AuthState.signedOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VenuRite Admin',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0E6E77)),
      home: switch (_state) {
        _AuthState.checking => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        _AuthState.signedOut => AdminLoginScreen(onSignedIn: _checkAuth),
        _AuthState.notSuperadmin => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('This account is not authorized for admin access.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await gotrue.Supabase.instance.client.auth.signOut();
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        _AuthState.signedIn => AdminHomeScreen(repository: _repository),
      },
    );
  }
}
