import '../../core/network/backend_rest_client.dart';

// Payment status, surfaced plainly (2026-10-02) — mirrors
// billing_service.dart's effectiveBillingState() grace-period rule
// (14 days from the first failed payment) but expressed in the terms a
// superadmin reading this list actually wants: has this org paid, is a
// payment late but still in grace, or has it been missed long enough to
// matter. `trialing` is kept as its own value rather than folded into
// `paid` — a trial isn't a payment at all yet.
enum AdminPaymentStatus { trialing, paid, late, missed, unknown }

const _paymentGracePeriod = Duration(days: 14);

AdminPaymentStatus computeAdminPaymentStatus(
  AdminOrgSummary org, {
  DateTime? now,
}) {
  if (org.subscriptionStatus == null) return AdminPaymentStatus.unknown;
  if (org.subscriptionStatus == 'trialing') return AdminPaymentStatus.trialing;
  if (org.subscriptionStatus == 'active') return AdminPaymentStatus.paid;
  if (org.subscriptionStatus == 'cancelled') return AdminPaymentStatus.missed;
  if (org.subscriptionStatus != 'past_due') return AdminPaymentStatus.unknown;

  final failedAt = org.lastPaymentFailedAt;
  if (failedAt == null) return AdminPaymentStatus.paid;
  final at = now ?? DateTime.now();
  return at.difference(failedAt) >= _paymentGracePeriod
      ? AdminPaymentStatus.missed
      : AdminPaymentStatus.late;
}

class AdminBugReport {
  const AdminBugReport({
    required this.id,
    required this.organisationName,
    required this.reportedByName,
    required this.title,
    required this.description,
    required this.appVersion,
    required this.platform,
    required this.status,
    required this.createdAt,
    required this.resolvedAt,
    required this.adminNote,
  });

  final int id;
  final String organisationName;
  final String? reportedByName;
  final String title;
  final String description;
  final String? appVersion;
  final String? platform;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? adminNote;

  bool get isResolved => status == 'resolved';
}

class AdminServiceProviderPurchase {
  const AdminServiceProviderPurchase({
    required this.id,
    required this.organisationName,
    required this.providerName,
    required this.feePence,
    required this.billed,
    required this.unlockedAt,
  });

  final int id;
  final String organisationName;
  final String providerName;
  final int feePence;
  final bool billed;
  final DateTime unlockedAt;
}

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
    required this.lastPaymentFailedAt,
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
  final DateTime? lastPaymentFailedAt;
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
          'select=organisation_id,status,billed_site_count,trial_ends_at,current_period_end,restricted_at,free_access_granted,last_payment_failed_at',
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
        lastPaymentFailedAt: sub?['last_payment_failed_at'] == null
            ? null
            : DateTime.parse(sub!['last_payment_failed_at'] as String),
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

  // Reported bugs/errors (2026-10-02) — surfaces bug_reports, the
  // capture mechanism added alongside this view (nothing existed before:
  // ContactVenuRiteScreen was only ever a mailto link). Cross-tenant read
  // via superadmin_read_bug_reports, same pattern as every other admin
  // read in this file.
  Future<List<AdminBugReport>> getAllBugReports() async {
    final reports = await _client.select(
      'bug_reports',
      query: 'select=id,organisation_id,site_id,reported_by_user_id,title,'
          'description,app_version,platform,status,created_at,resolved_at,'
          'admin_note&order=created_at.desc',
    );
    if (reports.isEmpty) return [];

    final orgIds = reports.map((r) => r['organisation_id'] as int).toSet();
    final orgs = await _client.select(
      'organisations',
      query: 'select=id,name&id=in.(${orgIds.join(',')})',
    );
    final orgNameById = {
      for (final row in orgs) row['id'] as int: row['name'] as String,
    };

    final reporterIds = reports
        .map((r) => r['reported_by_user_id'] as int?)
        .whereType<int>()
        .toSet();
    final reporters = reporterIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await _client.select(
            'users',
            query: 'select=id,name&id=in.(${reporterIds.join(',')})',
          );
    final reporterNameById = {
      for (final row in reporters) row['id'] as int: row['name'] as String,
    };

    return reports.map((row) {
      return AdminBugReport(
        id: row['id'] as int,
        organisationName:
            orgNameById[row['organisation_id'] as int] ?? 'Unknown',
        reportedByName: reporterNameById[row['reported_by_user_id'] as int?],
        title: row['title'] as String,
        description: row['description'] as String,
        appVersion: row['app_version'] as String?,
        platform: row['platform'] as String?,
        status: row['status'] as String,
        createdAt: DateTime.parse(row['created_at'] as String),
        resolvedAt: row['resolved_at'] == null
            ? null
            : DateTime.parse(row['resolved_at'] as String),
        adminNote: row['admin_note'] as String?,
      );
    }).toList();
  }

  Future<void> setBugReportStatus(
    int bugReportId, {
    required bool resolved,
    String? adminNote,
  }) async {
    await _client.rpcVoid('admin_set_bug_report_status', {
      'p_bug_report_id': bugReportId,
      'p_resolved': resolved,
      'p_admin_note': adminNote,
    });
  }

  // Service-provider-access purchases (2026-10-02) — reads
  // service_provider_unlocks directly (superadmin_read_service_provider_unlocks
  // already existed from the original admin tool migration; this is the
  // first screen to actually surface it as its own view rather than just
  // a per-org count).
  Future<List<AdminServiceProviderPurchase>> getAllServiceProviderPurchases() async {
    final unlocks = await _client.select(
      'service_provider_unlocks',
      query: 'select=id,service_provider_id,unlocking_organisation_id,'
          'fee_pence,billed,unlocked_at&order=unlocked_at.desc',
    );
    if (unlocks.isEmpty) return [];

    final orgIds = unlocks
        .map((u) => u['unlocking_organisation_id'] as int)
        .toSet();
    final orgs = await _client.select(
      'organisations',
      query: 'select=id,name&id=in.(${orgIds.join(',')})',
    );
    final orgNameById = {
      for (final row in orgs) row['id'] as int: row['name'] as String,
    };

    final providerIds = unlocks
        .map((u) => u['service_provider_id'] as int)
        .toSet();
    final providers = await _client.select(
      'service_providers',
      query: 'select=id,name&id=in.(${providerIds.join(',')})',
    );
    final providerNameById = {
      for (final row in providers) row['id'] as int: row['name'] as String,
    };

    return unlocks.map((row) {
      return AdminServiceProviderPurchase(
        id: row['id'] as int,
        organisationName:
            orgNameById[row['unlocking_organisation_id'] as int] ?? 'Unknown',
        providerName:
            providerNameById[row['service_provider_id'] as int] ?? 'Unknown',
        feePence: row['fee_pence'] as int,
        billed: row['billed'] as bool,
        unlockedAt: DateTime.parse(row['unlocked_at'] as String),
      );
    }).toList();
  }

  Future<void> setUnlockBilled(int unlockId, bool billed) async {
    await _client.rpcVoid('admin_set_unlock_billed', {
      'p_unlock_id': unlockId,
      'p_billed': billed,
    });
  }
}
