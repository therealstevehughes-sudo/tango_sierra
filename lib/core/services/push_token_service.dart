import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/repositories/user_repository.dart';

/// Realtime push (2026-09-16) — registers the current device's FCM token
/// against a signed-in account, and keeps it current if it refreshes.
/// Android only for now (see main.dart's own note: this app's Windows
/// desktop target has no Firebase app registered at all).
///
/// Deliberately fire-and-forget: a failure here (no network at login, no
/// notification permission granted, a local-only install with a
/// no-op repository write) must never block or interrupt sign-in — the
/// account can always be reached via the app itself; push is a
/// convenience on top, not a requirement.
class PushTokenService {
  StreamSubscription<String>? _refreshSubscription;

  Future<void> registerForCurrentUser(UserRepository repository, int userId) async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      final token = await messaging.getToken();
      if (token != null) {
        await repository.setFcmToken(userId: userId, token: token);
      }
      await _refreshSubscription?.cancel();
      _refreshSubscription = messaging.onTokenRefresh.listen((newToken) {
        repository.setFcmToken(userId: userId, token: newToken);
      });
    } catch (_) {
      // No network, permission denied, or Firebase not actually reachable
      // this session — push just won't work, not a sign-in failure.
    }
  }
}

final pushTokenServiceProvider = Provider<PushTokenService>(
  (ref) => PushTokenService(),
);
