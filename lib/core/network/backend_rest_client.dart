import 'dart:convert';
import 'dart:io';

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

  // Real deletion (2026-09-18) — every existing Supabase*Repository so far
  // used a soft `active` flag instead, so this was never needed until a
  // genuine many-to-many join table (SupervisionRepository) needed a
  // real "replace this set" operation, not a status flip.
  Future<void> delete(
    String table, {
    required String filter,
  }) async {
    final response = await http.delete(_uri(table, filter), headers: _headers());
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

  // Roster add-on (2026-09-27) — calls a Postgres RPC function exposed at
  // /rest/v1/rpc/<name> (e.g. claim_shift), needed because PostgREST's
  // plain table endpoints can't express an atomic
  // "update only if still open" race-safe write. Returns the decoded
  // JSON body (a list of rows, since claim_shift is `RETURNS SETOF`) —
  // callers check whether it's empty to distinguish "someone else claimed
  // it first" from a real error, same as _checkOk's status-based check
  // would for a plain table call.
  Future<List<dynamic>> rpc(String functionName, Map<String, dynamic> params) async {
    final response = await http.post(
      Uri.parse('$_base/rpc/$functionName'),
      headers: _headers(json: true),
      body: jsonEncode(params),
    );
    _checkOk(response);
    return jsonDecode(response.body) as List<dynamic>;
  }

  // For an RPC whose Postgres function is `RETURNS void` (e.g. the admin
  // tool's restrict/free-access toggles) — PostgREST sends back an empty
  // body for these, which `rpc()` above can't handle (jsonDecode('')
  // throws, since it expects a JSON array of returned rows). Found via a
  // real bug report: the admin tool's toggle switches went permanently
  // dim with no error shown, because that uncaught decode exception left
  // the caller's `_busy` flag stuck true.
  Future<void> rpcVoid(String functionName, Map<String, dynamic> params) async {
    final response = await http.post(
      Uri.parse('$_base/rpc/$functionName'),
      headers: _headers(json: true),
      body: jsonEncode(params),
    );
    _checkOk(response);
  }

  // Voice-to-text notes (2026-09-27) — the first binary-upload call this
  // client makes. Sends the recorded clip as multipart/form-data (what
  // OpenAI's own transcription endpoint expects server-side anyway), so
  // the Edge Function forwards the bytes through largely unchanged rather
  // than this client base64-encoding into a much larger JSON payload only
  // for the function to decode it straight back out. Deliberately a
  // separate method, not a mode of invokeFunction() — every existing
  // caller of that method depends on its plain JSON-in/JSON-out contract.
  //
  // Deliberately does NOT call _checkOk, same as invokeFunction() —
  // transcribe-audio (like ai-assistant) reports its own errors via an
  // {"outcome": "error", ...} body even on a non-2xx status, so throwing
  // here on a real error response would hide that message from the
  // caller behind a generic exception instead of the actual reason
  // (found via real testing: the error tooltip showed a useless "couldn't
  // reach" message for what was actually a well-formed error reply).
  Future<Map<String, dynamic>> uploadAudioForTranscription(
    String functionName,
    File audioFile,
  ) async {
    final uri = Uri.parse('${BackendConfig.supabaseUrl}/functions/v1/$functionName');
    final request = http.MultipartRequest('POST', uri)
      // No json:true here -- MultipartRequest sets its own
      // "multipart/form-data; boundary=..." Content-Type, and overriding
      // it with "application/json" would break the encoding.
      ..headers.addAll(_headers())
      ..files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Certificate document upload (Phase 2, 2026-09-30) — the first direct
  // Supabase Storage call this client makes (everything else above talks
  // to PostgREST or Edge Functions). Storage's REST API takes the same
  // apikey/bearer headers as PostgREST, just a different base path
  // (`/storage/v1/object/<bucket>/<path>`), so this reuses _headers()
  // rather than adding a second auth mechanism. `x-upsert: true` lets a
  // re-upload against the same path replace the old file instead of
  // erroring, matching this app's "a renewal creates evidence, doesn't
  // need a new filename" pattern.
  Future<void> uploadToStorage(
    String bucket,
    String path,
    List<int> bytes, {
    required String contentType,
  }) async {
    final response = await http.post(
      Uri.parse('${BackendConfig.supabaseUrl}/storage/v1/object/$bucket/$path'),
      headers: {
        ..._headers(),
        'Content-Type': contentType,
        'x-upsert': 'true',
      },
      body: bytes,
    );
    _checkOk(response);
  }

  /// A short-lived signed URL for a file in a PRIVATE Storage bucket
  /// (certification-documents is private — these are personal staff
  /// records, not public files). Supabase's RLS on storage.objects still
  /// applies to who can request a sign at all; the URL it returns is then
  /// usable directly (no further auth header needed) until it expires.
  Future<String> createSignedStorageUrl(
    String bucket,
    String path, {
    int expiresInSeconds = 300,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${BackendConfig.supabaseUrl}/storage/v1/object/sign/$bucket/$path',
      ),
      headers: _headers(json: true),
      body: jsonEncode({'expiresIn': expiresInSeconds}),
    );
    _checkOk(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return '${BackendConfig.supabaseUrl}/storage/v1${decoded['signedURL']}';
  }

  /// Deletes a file from a Storage bucket — used by the shift-photo
  /// retention purge (2026-10-02). Storage's own RLS on storage.objects
  /// still applies, same as every other storage call here.
  Future<void> deleteFromStorage(String bucket, String path) async {
    final response = await http.delete(
      Uri.parse('${BackendConfig.supabaseUrl}/storage/v1/object/$bucket/$path'),
      headers: _headers(),
    );
    _checkOk(response);
  }
}
