import 'package:supabase_flutter/supabase_flutter.dart';

// Phase C1 — client wrapper over the privileged bootstrap Edge Functions
// (tenant-signup for C1b; invite-senior / provision-staff-pin follow in
// C1c/C1d). These actions can't be done by a client directly under RLS —
// each function runs service-role, server-side, same as pin-login.

class TenantSignupResult {
  const TenantSignupResult({
    required this.organisationId,
    required this.localUserId,
    required this.email,
  });

  final int organisationId;
  final int localUserId;
  final String email;
}

class TenantSignupException implements Exception {
  TenantSignupException(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract class TenantProvisioningRepository {
  /// Creates a brand-new isolated tenant: an Organisation, its first
  /// executive (a real email+password account, claims baked in so sign-in
  /// resolves), and optional initial branding. On success the caller signs
  /// in through the normal Leadership Access screen.
  Future<TenantSignupResult> signUpCompany({
    required String companyName,
    required String directorName,
    required String email,
    required String password,
    int? primaryColorArgb,
  });
}

class SupabaseTenantProvisioningRepository
    implements TenantProvisioningRepository {
  SupabaseTenantProvisioningRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<TenantSignupResult> signUpCompany({
    required String companyName,
    required String directorName,
    required String email,
    required String password,
    int? primaryColorArgb,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'tenant-signup',
        body: {
          'company_name': companyName,
          'director_name': directorName,
          'email': email,
          'password': password,
          'primary_color_argb': ?primaryColorArgb,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return TenantSignupResult(
        organisationId: data['organisation_id'] as int,
        localUserId: data['local_user_id'] as int,
        email: data['email'] as String,
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'Sign-up failed (${e.status})';
      throw TenantSignupException(message);
    } catch (_) {
      throw TenantSignupException('Could not reach the server');
    }
  }
}
