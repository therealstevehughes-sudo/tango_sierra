import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

String generateSalt({int length = 16}) {
  final random = Random.secure();
  final bytes = List<int>.generate(length, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}

String hashPin(String pin, String salt) {
  final bytes = utf8.encode('$salt:$pin');
  return sha256.convert(bytes).toString();
}
