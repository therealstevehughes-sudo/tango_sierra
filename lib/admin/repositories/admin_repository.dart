import '../../core/network/backend_rest_client.dart';

// Account-management/admin tool (Plan B, 2026-09-30) — Tom/founder-only,
// reads cross-tenant data via the superadmin RLS policies added in
// tools/phase2_admin_tool_migration.sql. Deliberately several plain
// queries combined client-side rather than one deeply nested PostgREST
// embed — organisations<->users has two FK paths (owner_user_id and
// organisation_id), which needs constraint-name disambiguation and gets
// fragile fast; four flat queries are simpler to get right and to read.
class AdminOrgSummary {
  const AdminOrgSummary({
    required this.id,
    required this.name,
    required this.billingEmail,
    required this.ownerName,
    required this.branchCount,
    required this.staffCount,
    required this.billedSiteCount,
    required this.rosterAddonEnabled,
    required this.subscriptionStatus,
    required this.trialEndsAt,
    required this.currentPeriodEnd,
    required this.restrictedAt,
    required this.freeAccessGranted,
    required this.serviceProviderUnlockCount,
    required this.createdAt,
    required this.archivedAt,
  });

  final int id;
  final String name;
  final String? billingEmail;
  final String? ownerName;
  final int branchCount;
  final int staffCount;
  final int billedSiteCount;
  final bool rosterAddonEnabled;
  final String? subscriptionStatus;
  final DateTime? trialEndsAt;
  final DateTime? currentPeriodEnd;
  final DateTime? restrictedAt;
  final bool freeAccessGranted;
  final int serviceProviderUnlockCount;
  final DateTime createdAt;
  final DateTime? archivedAt;
}

class AdminRepository {
  AdminRepository(this._client);

  final BackendRestClient _client;

  Future<List<AdminOrgSummary>> getAllOrgSummaries() async {
    final orgs = await _client.select(
      'organisations',
      query: 'select=id,name,billing_email,owner_user_id,created_at,roster_addon_enabled,archived_at&order=created_at.desc',
    );
    final subscriptions = await _client.select(
      'subscriptions',
      query:
          'select=organisation_id,status,billed_site_count,trial_ends_at,current_period_end,restricted_at,free_access_granted',
    );
    final sites = await _client.select(
      'sites',
      query: 'select=id,organisation_id',
    );
    final users = await _client.select('users', query: 'select=id,site_id');
    final unlocks = await _client.select(
      'service_provider_unlocks',
      query: 'select=id,unlocking_organisation_id',
    );

    final ownerIds = orgs
        .map((o) => o['owner_user_id'] as int?)
        .whereType<int>()
        .toSet();
    final owners = ownerIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await _client.select(
            'users',
            query: 'select=id,name&id=in.(${ownerIds.join(',')})',
          );
    final ownerNameById = {
      for (final row in owners) row['id'] as int: row['name'] as String,
    };

    final subscriptionByOrg = {
      for (final row in subscriptions) row['organisation_id'] as int: row,
    };
    final orgIdBySiteId = {
      for (final row in sites) row['id'] as int: row['organisation_id'] as int,
    };
    final siteCountByOrg = <int, int>{};
    for (final row in sites) {
      final orgId = row['organisation_id'] as int;
      siteCountByOrg[orgId] = (siteCountByOrg[orgId] ?? 0) + 1;
    }
    final staffCountByOrg = <int, int>{};
    for (final row in users) {
      final siteId = row['site_id'] as int?;
      final orgId = siteId == null ? null : orgIdBySiteId[siteId];
      if (orgId == null) continue;
      staffCountByOrg[orgId] = (staffCountByOrg[orgId] ?? 0) + 1;
    }
    final unlockCountByOrg = <int, int>{};
    for (final row in unlocks) {
      final orgId = row['unlocking_organisation_id'] as int;
      unlockCountByOrg[orgId] = (unlockCountByOrg[orgId] ?? 0) + 1;
    }

    return orgs.map((org) {
      final id = org['id'] as int;
      final sub = subscriptionByOrg[id];
      return AdminOrgSummary(
        id: id,
        name: org['name'] as String,
        billingEmail: org['billing_email'] as String?,
        ownerName: ownerNameById[org['owner_user_id'] as int?],
        branchCount: siteCountByOrg[id] ?? 0,
        staffCount: staffCountByOrg[id] ?? 0,
        billedSiteCount: sub?['billed_site_count'] as int? ?? 0,
        rosterAddonEnabled: org['roster_addon_enabled'] as bool? ?? false,
        subscriptionStatus: sub?['status'] as String?,
        trialEndsAt: sub?['trial_ends_at'] == null
            ? null
            : DateTime.parse(sub!['trial_ends_at'] as String),
        currentPeriodEnd: sub?['current_period_end'] == null
            ? null
            : DateTime.parse(sub!['current_period_end'] as String),
        restrictedAt: sub?['restricted_at'] == null
            ? null
            : DateTime.parse(sub!['restricted_at'] as String),
        freeAccessGranted: sub?['free_access_granted'] as bool? ?? false,
        serviceProviderUnlockCount: unlockCountByOrg[id] ?? 0,
        createdAt: DateTime.parse(org['created_at'] as String),
        archivedAt: org['archived_at'] == null
            ? null
            : DateTime.parse(org['archived_at'] as String),
      );
    }).toList();
  }

  Future<void> setArchived(int organisationId, bool archived) async {
    await _client.rpcVoid('admin_set_organisation_archived', {
      'p_organisation_id': organisationId,
      'p_archived': archived,
    });
  }

  Future<void> setRestricted(int organisationId, bool restricted) async {
    await _client.rpcVoid('admin_set_subscription_restricted', {
      'p_organisation_id': organisationId,
      'p_restricted': restricted,
    });
  }

  Future<void> setFreeAccess(int organisationId, bool granted) async {
    await _client.rpcVoid('admin_set_free_access', {
      'p_organisation_id': organisationId,
      'p_granted': granted,
    });
  }

  /// Whether the currently signed-in GoTrue session belongs to a
  /// superadmin — checked by reading admin_users (its own RLS only ever
  /// returns the caller's own row, see admin_users_self_read).
  Future<bool> isCurrentUserSuperadmin() async {
    final rows = await _client.select('admin_users', query: 'select=id');
    return rows.isNotEmpty;
  }
}
