import 'package:supabase_flutter/supabase_flutter.dart';

// Phase C1 — client wrapper over the privileged bootstrap Edge Functions
// (tenant-signup for C1b; invite-senior / provision-staff-pin follow in
// C1c/C1d). These actions can't be done by a client directly under RLS —
// each function runs service-role, server-side, same as pin-login.

class TenantSignupResult {
  const TenantSignupResult({
    required this.organisationId,
    required this.localUserId,
    required this.siteId,
    required this.email,
    required this.trialEndsAt,
  });

  final int organisationId;
  final int localUserId;
  final int siteId;
  final String email;
  final DateTime trialEndsAt;
}

class TenantSignupException implements Exception {
  TenantSignupException(this.message);
  final String message;
  @override
  String toString() => message;
}

class OrganisationInviteResult {
  const OrganisationInviteResult({
    required this.inviteId,
    required this.token,
    required this.roleTier,
    required this.expiresAt,
  });

  final int inviteId;
  final String token;
  final String roleTier;
  final DateTime expiresAt;
}

class OrganisationInviteException implements Exception {
  OrganisationInviteException(this.message);
  final String message;
  @override
  String toString() => message;
}

class InviteRedeemResult {
  const InviteRedeemResult({
    required this.organisationId,
    required this.localUserId,
    required this.roleTier,
    required this.email,
  });

  final int organisationId;
  final int localUserId;
  final String roleTier;
  final String email;
}

class InviteRedeemException implements Exception {
  InviteRedeemException(this.message);
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

class SeniorPasswordResetResult {
  const SeniorPasswordResetResult({
    required this.localUserId,
    required this.name,
    required this.email,
    required this.temporaryPassword,
  });

  final int localUserId;
  final String name;
  final String email;
  final String temporaryPassword;
}

class SeniorPasswordResetException implements Exception {
  SeniorPasswordResetException(this.message);
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
  /// Sprint 034 (Customer Onboarding & Billing Foundation) — creates a
  /// brand-new isolated tenant in one call: an Organisation (with legal/
  /// billing details), its first executive/owner (a real email+password
  /// account, claims baked in so sign-in resolves), the first venue
  /// (optionally under a named region, with an optional venue type), a
  /// trialing subscription, and optional initial branding. On success the
  /// caller signs in through the normal Leadership Access screen.
  Future<TenantSignupResult> signUpCompany({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String companyName,
    required String country,
    required String venueName,
    String? legalName,
    String? registeredAddress,
    String? vatNumber,
    String? billingEmail,
    String? venueAddress,
    String? venueRegion,
    String? venueType,
    String? planName,
    int? primaryColorArgb,
  });

  /// Sprint 034 — "Join existing company" invite side. Generates a real
  /// single-use, expiring, cryptographically-random token the caller
  /// shares with whoever they're inviting (any tier at least one level
  /// below the caller's own, enforced server-side via the same cascade
  /// rule every other provisioning endpoint uses). Unlike [inviteSenior]/
  /// staff-pin provisioning, this does NOT create the account — the
  /// invitee creates it themselves via [redeemInvite], on their own
  /// device.
  Future<OrganisationInviteResult> createInvite({
    required String roleTier,
    int? regionId,
    int? siteId,
    String? email,
  });

  /// Sprint 034 — "Join existing company" redeem side. Called with no
  /// session at all (the invitee has no account yet); creates a real
  /// email+password GoTrue account with the invite's role/scope claims,
  /// and marks the invite as used (single-use).
  Future<InviteRedeemResult> redeemInvite({
    required String token,
    required String name,
    required String email,
    required String password,
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

  /// Built 2026-09-14 — resets a regional/executive account's password.
  /// No SMTP is configured on this stack (same gap logged on
  /// [inviteSenior]), so this is admin-mediated rather than a
  /// self-service emailed link/code: the caller must be a signed-in
  /// executive of the SAME organisation as [targetLocalUserId] (enforced
  /// server-side), and gets back a freshly generated temporary password
  /// to pass along out-of-band, mirroring [inviteSenior]'s exact pattern.
  Future<SeniorPasswordResetResult> resetSeniorPassword({
    required int targetLocalUserId,
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
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String companyName,
    required String country,
    required String venueName,
    String? legalName,
    String? registeredAddress,
    String? vatNumber,
    String? billingEmail,
    String? venueAddress,
    String? venueRegion,
    String? venueType,
    String? planName,
    int? primaryColorArgb,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'tenant-signup',
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'company_name': companyName,
          'country': country,
          'venue_name': venueName,
          'legal_name': ?legalName,
          'registered_address': ?registeredAddress,
          'vat_number': ?vatNumber,
          'billing_email': ?billingEmail,
          'venue_address': ?venueAddress,
          'venue_region': ?venueRegion,
          'venue_type': ?venueType,
          'plan_name': ?planName,
          'primary_color_argb': ?primaryColorArgb,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return TenantSignupResult(
        organisationId: data['organisation_id'] as int,
        localUserId: data['local_user_id'] as int,
        siteId: data['site_id'] as int,
        email: data['email'] as String,
        trialEndsAt: DateTime.parse(data['trial_ends_at'] as String),
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
  Future<OrganisationInviteResult> createInvite({
    required String roleTier,
    int? regionId,
    int? siteId,
    String? email,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'create-invite',
        body: {
          'role_tier': roleTier,
          'region_id': ?regionId,
          'site_id': ?siteId,
          'email': ?email,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return OrganisationInviteResult(
        inviteId: data['invite_id'] as int,
        token: data['token'] as String,
        roleTier: data['role_tier'] as String,
        expiresAt: DateTime.parse(data['expires_at'] as String),
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'Could not create the invite (${e.status})';
      throw OrganisationInviteException(message);
    } catch (_) {
      throw OrganisationInviteException('Could not reach the server');
    }
  }

  @override
  Future<InviteRedeemResult> redeemInvite({
    required String token,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'redeem-invite',
        body: {
          'token': token,
          'name': name,
          'email': email,
          'password': password,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return InviteRedeemResult(
        organisationId: data['organisation_id'] as int,
        localUserId: data['local_user_id'] as int,
        roleTier: data['role_tier'] as String,
        email: data['email'] as String,
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'That invite could not be used (${e.status})';
      throw InviteRedeemException(message);
    } catch (_) {
      throw InviteRedeemException('Could not reach the server');
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
  Future<SeniorPasswordResetResult> resetSeniorPassword({
    required int targetLocalUserId,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'reset-senior-password',
        body: {'target_local_user_id': targetLocalUserId},
      );
      final data = response.data as Map<String, dynamic>;
      return SeniorPasswordResetResult(
        localUserId: data['local_user_id'] as int,
        name: data['name'] as String,
        email: data['email'] as String,
        temporaryPassword: data['temporary_password'] as String,
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : 'Password reset failed (${e.status})';
      throw SeniorPasswordResetException(message);
    } catch (_) {
      throw SeniorPasswordResetException('Could not reach the server');
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
