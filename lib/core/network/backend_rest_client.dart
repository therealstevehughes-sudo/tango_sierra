import 'dart:convert';

import 'package:http/http.dart' as http;

import 'supabase_client.dart';

/// Thrown when a PostgREST call comes back with an error status — most
/// importantly a 403 with Postgres error code 42501, which means the
/// tenant-isolation RLS policy rejected the request. Callers that need to
/// tell "blocked by RLS" apart from "genuine server error" can check
/// [isRlsRejection].
class BackendRequestException implements Exception {
  BackendRequestException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  bool get isRlsRejection =>
      statusCode == 403 && body.contains('42501');

  @override
  String toString() => 'BackendRequestException($statusCode): $body';
}

/// Phase B2 — a small, deliberately generic REST client for Supabase's
/// PostgREST endpoint (`/rest/v1/<table>`), used by every `Supabase*Repository`
/// added in this phase.
///
/// Why not `supabase_flutter`'s own `SupabaseClient.from(table)`: that API
/// reads its auth header from the client's own ambient session
/// (`Supabase.instance.client.auth`), which only Leadership (GoTrue
/// email+password) sessions actually populate. PIN sessions mint their own
/// HS256 token via the `pin-login` Edge Function and never touch
/// `supabase_flutter`'s auth state at all (see `currentSessionTokenProvider`)
/// — so a fixed, per-request bearer token is what both session kinds
/// actually need. [getAccessToken] is called fresh on every request, never
/// cached, so a token obtained after this client was constructed is still
/// picked up.
///
/// Tenant isolation itself is enforced entirely server-side (RLS + the
/// functions proven in Phase B1/B2) — this class does no scoping of its
/// own, on purpose. A request with no/invalid token behaves exactly as
/// Phase B1's "negative control" test proved: PostgREST returns an empty
/// result, not an error.
class BackendRestClient {
  BackendRestClient(this._getAccessToken);

  final String? Function() _getAccessToken;

  static final Uri _base = Uri.parse('${BackendConfig.supabaseUrl}/rest/v1');

  Map<String, String> _headers({bool json = false}) {
    final token = _getAccessToken();
    return {
      'apikey': BackendConfig.supabaseAnonKey,
      if (token != null) 'Authorization': 'Bearer $token',
      if (json) 'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    };
  }

  Uri _uri(String table, String? query) =>
      Uri.parse('$_base/$table${query != null ? '?$query' : ''}');

  void _checkOk(http.Response response) {
    if (response.statusCode >= 400) {
      throw BackendRequestException(response.statusCode, response.body);
    }
  }

  /// `query` is a raw PostgREST query string, e.g.
  /// `'organisation_id=eq.3&order=name.asc'` — deliberately not wrapped in
  /// a query-builder DSL, since every call site here is small and explicit.
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String? query,
  }) async {
    final response = await http.get(_uri(table, query), headers: _headers());
    _checkOk(response);
    final decoded = jsonDecode(response.body) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> insertOne(
    String table,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      _uri(table, null),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );
    _checkOk(response);
    final decoded = jsonDecode(response.body) as List;
    return decoded.first as Map<String, dynamic>;
  }

  Future<void> update(
    String table, {
    required String filter,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.patch(
      _uri(table, filter),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );
    _checkOk(response);
  }

  // Realtime push (2026-09-17) — Edge Functions live under a different
  // path than PostgREST tables, but need the exact same headers (apikey +
  // whichever bearer token this session currently holds), so this reuses
  // _headers() rather than duplicating that logic. Returns the decoded
  // JSON body regardless of status — callers that need fire-and-forget
  // behaviour (send-push) read the body to decide what happened rather
  // than treating a non-200 as an exception.
  Future<Map<String, dynamic>> invokeFunction(
    String name,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('${BackendConfig.supabaseUrl}/functions/v1/$name'),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
