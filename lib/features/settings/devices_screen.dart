import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/errors/friendly_error.dart';
import '../../core/security/branch_device_key.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_providers.dart'
    show backendRestClientProvider;
import '../../shared/providers/site_providers.dart';

class _DeviceRow {
  const _DeviceRow({
    required this.id,
    required this.name,
    required this.lastUsedAt,
    required this.revoked,
  });

  final int id;
  final String name;
  final DateTime? lastUsedAt;
  final bool revoked;
}

class _Rules {
  const _Rules({
    this.siteDevice,
    this.siteClock,
    required this.orgDevice,
    required this.orgClock,
  });

  final String? siteDevice;
  final String? siteClock;
  final String orgDevice;
  final String orgClock;
}

class _Data {
  const _Data(this.rules, this.devices, this.thisDeviceId);

  final _Rules rules;
  final List<_DeviceRow> devices;
  final int? thisDeviceId;
}

final _devicesProvider = FutureProvider.autoDispose.family<_Data, int>((
  ref,
  siteId,
) async {
  final client = ref.watch(backendRestClientProvider);
  final (ruleRows, deviceRows, thisId) = await (
    client.rpc('device_rules_for_site', {'p_site_id': siteId}),
    client.rpc('list_branch_devices', {'p_site_id': siteId}),
    BranchDeviceKey().deviceId(),
  ).wait;
  final r = ruleRows.isEmpty
      ? const <String, dynamic>{}
      : ruleRows.first as Map<String, dynamic>;
  return _Data(
    _Rules(
      siteDevice: r['site_device_policy'] as String?,
      siteClock: r['site_clock_policy'] as String?,
      orgDevice: r['org_device_policy'] as String? ?? 'branch_and_personal',
      orgClock: r['org_clock_policy'] as String? ?? 'any',
    ),
    [
      for (final d in deviceRows.cast<Map<String, dynamic>>())
        _DeviceRow(
          id: d['id'] as int,
          name: d['name'] as String,
          lastUsedAt: d['last_used_at'] == null
              ? null
              : DateTime.parse(d['last_used_at'] as String).toLocal(),
          revoked: d['revoked_at'] != null,
        ),
    ],
    thisId,
  );
});

String devicePolicyLabel(AppLocalizations l10n, String p) => switch (p) {
  'branch_only' => l10n.devicePolicyBranchOnly,
  'personal_rota_training' => l10n.devicePolicyPersonalRotaTraining,
  _ => l10n.devicePolicyBranchAndPersonal,
};

String clockPolicyLabel(AppLocalizations l10n, String p) =>
    p == 'branch_only' ? l10n.clockPolicyBranchOnly : l10n.clockPolicyAny;

/// "Devices & access" (2026-10-17, founder-approved device rules): where
/// staff can use VenuRite and clock in, and this branch's own registered
/// devices. Venue managers set their branch (or follow head office);
/// directors also set the head-office default.
class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final siteId =
        ref.watch(activeSiteProvider)?.id ??
        ref.watch(currentUserProvider)?.siteId;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.devicesTitle)),
      body: siteId == null
          ? const SizedBox.shrink()
          : ref
                .watch(_devicesProvider(siteId))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => LoadErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(_devicesProvider(siteId)),
                  ),
                  data: (d) => _Body(siteId: siteId, data: d),
                ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.siteId, required this.data});

  final int siteId;
  final _Data data;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, {String? done}) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(_devicesProvider(widget.siteId));
      if (!mounted || done == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setSite(String? device, String? clock) {
    final l10n = AppLocalizations.of(context)!;
    return _run(
      () =>
          ref.read(backendRestClientProvider).rpcVoid('set_site_device_rules', {
            'p_site_id': widget.siteId,
            'p_device_policy': device,
            'p_clock_policy': clock,
          }),
      done: l10n.deviceRulesSaved,
    );
  }

  Future<void> _setOrg(String device, String clock) {
    final l10n = AppLocalizations.of(context)!;
    return _run(
      () => ref.read(backendRestClientProvider).rpcVoid(
        'set_org_device_rules',
        {'p_device_policy': device, 'p_clock_policy': clock},
      ),
      done: l10n.deviceRulesSaved,
    );
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final me = ref.read(currentUserProvider);
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.registerThisDeviceButton),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(hintText: l10n.deviceNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await _run(() async {
      final key = BranchDeviceKey();
      final publicKey = await key.newPublicKey();
      final rows = await ref
          .read(backendRestClientProvider)
          .rpc('register_branch_device', {
            'p_site_id': widget.siteId,
            'p_name': name,
            'p_public_key': publicKey,
            'p_user_id': me?.id,
          });
      await key.saveDeviceId(
        (rows.first as Map<String, dynamic>)['device_id'] as int,
      );
    }, done: l10n.deviceRegistered);
  }

  Future<void> _remove(_DeviceRow d) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.removeDeviceConfirm(d.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.removeDeviceButton),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() async {
      await ref.read(backendRestClientProvider).rpcVoid(
        'revoke_branch_device',
        {'p_device_id': d.id},
      );
      if (widget.data.thisDeviceId == d.id) await BranchDeviceKey().forget();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final me = ref.watch(currentUserProvider);
    final isDirector = me?.roleTier == RoleTier.executive;
    final rules = widget.data.rules;
    final thisRegistered = widget.data.devices.any(
      (d) => d.id == widget.data.thisDeviceId && !d.revoked,
    );

    Widget picker<T>({
      required String label,
      required T value,
      required List<(T, String)> items,
      required ValueChanged<T> onChanged,
    }) => DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final (v, text) in items)
          DropdownMenuItem(
            value: v,
            child: Text(text, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: _busy ? null : (v) => onChanged(v as T),
    );

    const devicePolicies = [
      'branch_and_personal',
      'personal_rota_training',
      'branch_only',
    ];
    return ResponsiveContent(
      maxWidth: 640,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppBanner(kind: BannerKind.info, child: Text(l10n.devicesHelp)),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                picker<String?>(
                  label: l10n.deviceRulesWhoLabel,
                  value: rules.siteDevice,
                  items: [
                    (
                      null,
                      l10n.deviceRulesFollowHeadOffice(
                        devicePolicyLabel(l10n, rules.orgDevice),
                      ),
                    ),
                    for (final p in devicePolicies)
                      (p, devicePolicyLabel(l10n, p)),
                  ],
                  onChanged: (v) => _setSite(v, rules.siteClock),
                ),
                const SizedBox(height: 12),
                picker<String?>(
                  label: l10n.deviceRulesClockLabel,
                  value: rules.siteClock,
                  items: [
                    (
                      null,
                      l10n.deviceRulesFollowHeadOffice(
                        clockPolicyLabel(l10n, rules.orgClock),
                      ),
                    ),
                    ('any', l10n.clockPolicyAny),
                    ('branch_only', l10n.clockPolicyBranchOnly),
                  ],
                  onChanged: (v) => _setSite(rules.siteDevice, v),
                ),
              ],
            ),
          ),
          if (isDirector) ...[
            const SizedBox(height: 16),
            Text(
              l10n.deviceRulesHeadOfficeTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  picker<String>(
                    label: l10n.deviceRulesWhoLabel,
                    value: rules.orgDevice,
                    items: [
                      for (final p in devicePolicies)
                        (p, devicePolicyLabel(l10n, p)),
                    ],
                    onChanged: (v) => _setOrg(v, rules.orgClock),
                  ),
                  const SizedBox(height: 12),
                  picker<String>(
                    label: l10n.deviceRulesClockLabel,
                    value: rules.orgClock,
                    items: [
                      ('any', l10n.clockPolicyAny),
                      ('branch_only', l10n.clockPolicyBranchOnly),
                    ],
                    onChanged: (v) => _setOrg(rules.orgDevice, v),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.branchDevicesHeading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (thisRegistered)
            AppBanner(
              kind: BannerKind.info,
              child: Text(l10n.thisDeviceIsBranch),
            )
          else
            FilledButton.icon(
              icon: const Icon(Icons.tablet_android),
              label: Text(l10n.registerThisDeviceButton),
              onPressed: _busy ? null : _register,
            ),
          const SizedBox(height: 12),
          if (widget.data.devices.isEmpty)
            Text(
              l10n.branchDevicesNone,
              style: const TextStyle(color: AppColors.muted),
            ),
          for (final d in widget.data.devices)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.tablet_android,
                      color: d.revoked ? AppColors.mutedLight : AppColors.teal,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            d.revoked
                                ? l10n.deviceRemovedLabel
                                : d.lastUsedAt == null
                                ? l10n.deviceNeverUsed
                                : l10n.deviceLastUsed(
                                    formatDateTime(d.lastUsedAt!),
                                  ),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!d.revoked)
                      TextButton(
                        onPressed: _busy ? null : () => _remove(d),
                        child: Text(l10n.removeDeviceButton),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
