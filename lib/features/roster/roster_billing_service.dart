import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/backend_rest_client.dart';
import '../../shared/providers/backend_providers.dart' show backendRestClientProvider;
import '../../shared/providers/site_providers.dart' show organisationRepositoryProvider;

// Roster add-on billing (2026-09-27) — calls the `roster-addon-billing`
// Edge Function, which computes real per-branch pricing from current
// active staff counts and creates/cancels a genuine GoCardless subscription
// for the add-on (separate from the main plan subscription). Only meaningful
// in real backend mode — local/demo installs have no real billing system at
// all, so callers should check backendDataEnabledProvider first and fall
// back to a bare local toggle there (see settings_screen.dart's
// _RosterAddonSetting and roster_upsell_screen.dart for the two call sites).
class RosterQuote {
  const RosterQuote({required this.totalPence, required this.breakdown});

  final int totalPence;
  final List<RosterQuoteSiteBreakdown> breakdown;

  String get formatted => '£${(totalPence / 100).toStringAsFixed(2)}/month';
}

class RosterQuoteSiteBreakdown {
  const RosterQuoteSiteBreakdown({
    required this.siteId,
    required this.staffCount,
    required this.pricePence,
  });

  final int siteId;
  final int staffCount;
  final int pricePence;
}

class RosterBillingService {
  RosterBillingService(this._client);

  final BackendRestClient _client;

  Future<RosterQuote> getQuote() async {
    final response = await _client.invokeFunction('roster-addon-billing', {
      'action': 'quote',
    });
    if (response['outcome'] != 'quote') {
      throw Exception(response['error'] ?? 'Could not get a price quote.');
    }
    final breakdown = (response['breakdown'] as List)
        .map(
          (row) => RosterQuoteSiteBreakdown(
            siteId: row['siteId'] as int,
            staffCount: row['staffCount'] as int,
            pricePence: row['pricePence'] as int,
          ),
        )
        .toList();
    return RosterQuote(
      totalPence: response['totalPence'] as int,
      breakdown: breakdown,
    );
  }

  /// Returns null on success, or an error message on failure.
  Future<String?> enable() async {
    final response = await _client.invokeFunction('roster-addon-billing', {
      'action': 'enable',
    });
    if (response['outcome'] != 'enabled') {
      return response['error'] as String? ?? 'Could not enable Roster.';
    }
    return null;
  }

  /// Returns null on success, or an error message on failure.
  Future<String?> disable() async {
    final response = await _client.invokeFunction('roster-addon-billing', {
      'action': 'disable',
    });
    if (response['outcome'] != 'disabled') {
      return response['error'] as String? ?? 'Could not disable Roster.';
    }
    return null;
  }

  /// Event-driven re-pricing (2026-09-27) — call after any write that
  /// changes a site's active staff count for a real backend org (see
  /// SupabaseUserRepository.setActive's call site). No-ops instantly if
  /// Roster isn't enabled or the price hasn't actually changed, so this is
  /// always safe/cheap to call speculatively. Deliberately swallows its own
  /// errors — a billing-side reprice check must never surface as a failure
  /// of the actual action (deactivating someone) that triggered it.
  Future<void> repriceIfNeeded() async {
    try {
      await _client.invokeFunction('roster-addon-billing', {
        'action': 'reprice_if_needed',
      });
    } catch (_) {
      // Best-effort — see doc comment above.
    }
  }
}

final rosterBillingServiceProvider = Provider<RosterBillingService>(
  (ref) => RosterBillingService(ref.watch(backendRestClientProvider)),
);

/// Whether the org currently has Roster switched on — the single read used
/// by the drawer, WorkerHubScreen, and both Roster screens to decide
/// locked-vs-unlocked presentation.
final rosterAddonEnabledProvider = FutureProvider<bool>((ref) async {
  final org = await ref.watch(organisationRepositoryProvider).getDefault();
  return org.rosterAddonEnabled;
});
