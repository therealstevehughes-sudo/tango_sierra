import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Device rules (2026-10-17): a branch device (e.g. the kitchen tablet)
/// proves it's that device with its own key pair. The private half never
/// leaves this device's protected storage; the server only has the public
/// half and checks a fresh signature at every PIN login.
class BranchDeviceKey {
  BranchDeviceKey([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static final _algorithm = Ed25519();
  static const _seedKey = 'venurite_branch_device_seed';
  static const _idKey = 'venurite_branch_device_id';

  /// The registered device id, or null if this isn't a branch device.
  Future<int?> deviceId() async {
    try {
      return int.tryParse(await _storage.read(key: _idKey) ?? '');
    } catch (_) {
      return null;
    }
  }

  /// A fresh key pair for registration; returns the public key (base64).
  /// Replaces any previous key on this device.
  Future<String> newPublicKey() async {
    final pair = await _algorithm.newKeyPair();
    final seed = await pair.extractPrivateKeyBytes();
    await _storage.write(key: _seedKey, value: base64Encode(seed));
    await _storage.delete(key: _idKey);
    final pub = await pair.extractPublicKey();
    return base64Encode(pub.bytes);
  }

  /// Called once the server has accepted the registration.
  Future<void> saveDeviceId(int id) =>
      _storage.write(key: _idKey, value: '$id');

  Future<void> forget() async {
    await _storage.delete(key: _idKey);
    await _storage.delete(key: _seedKey);
  }

  /// Fields for the pin-login request, or an empty map when this isn't a
  /// registered branch device.
  Future<Map<String, Object>> loginProof(int localUserId) async {
    try {
      final id = await deviceId();
      final seed = await _storage.read(key: _seedKey);
      if (id == null || seed == null) return const {};
      final pair = await _algorithm.newKeyPairFromSeed(base64Decode(seed));
      final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signature = await _algorithm.sign(
        utf8.encode('$id.$localUserId.$ts'),
        keyPair: pair,
      );
      return {
        'device_id': id,
        'device_ts': ts,
        'device_signature': base64Encode(signature.bytes),
      };
    } catch (_) {
      return const {};
    }
  }
}
