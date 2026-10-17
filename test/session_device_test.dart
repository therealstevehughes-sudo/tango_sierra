// Device rules (2026-10-17): the app reads what the server said about the
// login's device from the session token (display only; the database
// enforces the rules).
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/shared/providers/auth_providers.dart';

String _token(Map<String, dynamic> meta) {
  String part(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${part({'alg': 'HS256'})}.${part({'app_metadata': meta})}.sig';
}

SessionDevice _read(String? token) {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  c.read(currentSessionTokenProvider.notifier).state = token;
  return c.read(sessionDeviceProvider);
}

void main() {
  test('own phone at a rota-and-training-only venue', () {
    final d = _read(_token({'device_kind': 'personal', 'device_policy': 'personal_rota_training'}));
    expect(d.rotaAndTrainingOnly, isTrue);
  });

  test('branch device is never restricted', () {
    final d = _read(_token({
      'device_kind': 'branch',
      'device_name': 'Kitchen tablet',
      'device_policy': 'personal_rota_training',
    }));
    expect(d.rotaAndTrainingOnly, isFalse);
    expect(d.name, 'Kitchen tablet');
  });

  test('no token or a broken token means no device info', () {
    expect(_read(null).kind, isNull);
    expect(_read('not-a-jwt').kind, isNull);
  });
}
