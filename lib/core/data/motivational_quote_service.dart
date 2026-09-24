import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'motivational_quotes.dart';

// Per-person, non-repeating quote rotation (2026-09-24, direct user
// request: "once 1 has been used, it isn't shown again to that person
// until all others have been shown"). A shuffle-bag: each user keeps
// their own persisted pool of not-yet-shown quote indices; picking a
// quote removes one at random from that pool, and once the pool empties
// it's refilled with all 200 indices (reshuffled) and the cycle starts
// again. Stored in SharedPreferences per user id, same mechanism
// device-pairing already uses for its own small bits of local state.
class MotivationalQuoteService {
  const MotivationalQuoteService();

  String _poolKey(int userId) => 'motivational_quote_pool_$userId';

  Future<String> nextQuoteFor(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _poolKey(userId);
    var pool = _readPool(prefs, key);

    if (pool.isEmpty) {
      pool = List<int>.generate(motivationalQuotes.length, (i) => i)
        ..shuffle();
    }

    final index = pool.removeLast();
    await prefs.setString(key, jsonEncode(pool));
    return motivationalQuotes[index];
  }

  List<int> _readPool(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null) return [];
    try {
      final decoded = (jsonDecode(raw) as List).cast<int>();
      // Defensive: the library size can change between app versions
      // (it grew from 10 to 200 this session) -- drop any stored index
      // that's no longer valid rather than crashing on it.
      return decoded
          .where((i) => i >= 0 && i < motivationalQuotes.length)
          .toList();
    } catch (_) {
      return [];
    }
  }
}

final motivationalQuoteService = MotivationalQuoteService();

// Fallback for any caller that genuinely has no user id to key by (should
// not normally happen -- ShiftWelcomeScreen always has a real user).
String randomMotivationalQuote() {
  final random = Random();
  return motivationalQuotes[random.nextInt(motivationalQuotes.length)];
}
