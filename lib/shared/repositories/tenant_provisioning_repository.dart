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

class SeniorInviteResult {
  const SeniorInviteResult({
    required this.email,
    required this.temporaryPassword,
    required this.localUserId,
  });

  final String email;
  final String temporaryPassword;
  final int localUserId;
}

class SeniorInviteException implements Exception {
  SeniorInviteException(this.message);
  final String message;
  @override
  String toString() => message;
}

class StaffPinProvisionResult {
  const StaffPinProvisionResult({
    required this.localUserId,
    required this.name,
    required this.pin,
  });

  final int localUserId;
  final String name;
  final String pin;
}

class StaffPinProvisionException implements Exception {
  StaffPinProvisionException(this.message);
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

  /// Phase C1c — invites a regional or executive account. Must be called
  /// by a signed-in executive of [organisationId] (enforced server-side,
  /// not just by the UI only offering this to executives). Returns a
  /// temporary password for the inviting Director to pass on — there's no
  /// SMTP configured yet, so this isn't a real emailed invite (logged
  /// follow-on).
  Future<SeniorInviteResult> inviteSenior({
    required String email,
    required String name,
    required String roleTier,
    required int organisationId,
    int? regionId,
  });

  /// Phase C1d — creates a PIN-tier account (venueManager/supervisor/base)
  /// at [siteId]. Must be called by a session at least one full tier above
  /// [roleTier] (enforced server-side, matching the cascade rule). Unlike
  /// [inviteSenior], the caller here may be a PIN session (a venueManager
  /// has no GoTrue session at all), so [callerAccessToken] is passed
  /// explicitly rather than relying on an ambient GoTrue session.
  Future<StaffPinProvisionResult> provisionStaffPin({
    required String callerAccessToken,
    required String name,
    required String jobTitle,
    required String roleTier,
    required int siteId,
    String? jobRole,
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

  @override
  Future<SeniorInviteResult> inviteSenior({
    required String email,
    required String name,
    required String roleTier,
    required int organisationId,
    int? regionId,
  }) async {
    try {
      // functions.invoke attaches the current GoTrue session's bearer
      // token automatically -- executives always sign in via GoTrue
      // (Leadership Access), never PIN, so this is always populated for
      // the only caller this endpoint accepts.
      final response = await _client.functions.invoke(
        'invite-senior',
        body: {
          'email': email,
          'name': name,
          'role_tier': roleTier,
          'organisation_id': organisationId,
          'region_id': ?regionId,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return SeniorInviteResult(
        email: data['email'] as String,
        temporaryPassword: data['temporary_password'] as String,
        localUserId: data['local_user_id'] as int,
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'Invite failed (${e.status})';
      throw SeniorInviteException(message);
    } catch (_) {
      throw SeniorInviteException('Could not reach the server');
    }
  }

  @override
  Future<StaffPinProvisionResult> provisionStaffPin({
    required String callerAccessToken,
    required String name,
    required String jobTitle,
    required String roleTier,
    required int siteId,
    String? jobRole,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'provision-staff-pin',
        headers: {'Authorization': 'Bearer $callerAccessToken'},
        body: {
          'name': name,
          'job_title': jobTitle,
          'role_tier': roleTier,
          'site_id': siteId,
          'job_role': ?jobRole,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return StaffPinProvisionResult(
        localUserId: data['local_user_id'] as int,
        name: data['name'] as String,
        pin: data['pin'] as String,
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'Could not create the account (${e.status})';
      throw StaffPinProvisionException(message);
    } catch (_) {
      throw StaffPinProvisionException('Could not reach the server');
    }
  }
}
