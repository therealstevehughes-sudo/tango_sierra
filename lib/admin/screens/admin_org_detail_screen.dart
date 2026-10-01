import 'package:flutter/material.dart';

import '../repositories/admin_repository.dart';

/// Org detail + manual actions (Plan B, 2026-09-30) — v1 scope is manual
/// only ("automation is a fast-follow", agreed before building). No
/// automatic block/notify on missed payment yet - a superadmin reads the
/// facts here and decides.
class AdminOrgDetailScreen extends StatefulWidget {
  const AdminOrgDetailScreen({
    super.key,
    required this.repository,
    required this.org,
  });

  final AdminRepository repository;
  final AdminOrgSummary org;

  @override
  State<AdminOrgDetailScreen> createState() => _AdminOrgDetailScreenState();
}

class _AdminOrgDetailScreenState extends State<AdminOrgDetailScreen> {
  late AdminOrgSummary _org;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _org = widget.org;
  }

  Future<void> _toggleRestricted() async {
    setState(() => _busy = true);
    try {
      await widget.repository.setRestricted(
        _org.id,
        _org.restrictedAt == null,
      );
      final refreshed = await widget.repository.getAllOrgSummaries();
      if (!mounted) return;
      setState(() => _org = refreshed.firstWhere((o) => o.id == _org.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleFreeAccess() async {
    setState(() => _busy = true);
    try {
      await widget.repository.setFreeAccess(
        _org.id,
        !_org.freeAccessGranted,
      );
      final refreshed = await widget.repository.getAllOrgSummaries();
      if (!mounted) return;
      setState(() => _org = refreshed.firstWhere((o) => o.id == _org.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_org.name)),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _row('Key contact', _org.ownerName ?? '—'),
            _row('Billing email', _org.billingEmail ?? '—'),
            _row('Branches', _org.branchCount.toString()),
            _row('Total staff', _org.staffCount.toString()),
            _row('Billed branches', _org.billedSiteCount.toString()),
            _row('Roster add-on', _org.rosterAddonEnabled ? 'Enabled' : 'Off'),
            _row('Service provider unlocks', _org.serviceProviderUnlockCount.toString()),
            _row('Subscription status', _org.subscriptionStatus ?? '—'),
            _row(
              'Trial ends',
              _org.trialEndsAt == null ? '—' : _formatDate(_org.trialEndsAt!),
            ),
            _row(
              'Current period ends',
              _org.currentPeriodEnd == null
                  ? '—'
                  : _formatDate(_org.currentPeriodEnd!),
            ),
            _row('Joined', _formatDate(_org.createdAt)),
            const Divider(height: 32),
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Account restricted (blocked)'),
              subtitle: Text(
                _org.restrictedAt == null
                    ? 'Customer has full access'
                    : 'Restricted since ${_formatDate(_org.restrictedAt!)}',
              ),
              value: _org.restrictedAt != null,
              onChanged: _busy ? null : (_) => _toggleRestricted(),
            ),
            SwitchListTile(
              title: const Text('Free access granted'),
              subtitle: const Text(
                'Bypasses billing entirely — for internal testing/comp accounts only',
              ),
              value: _org.freeAccessGranted,
              onChanged: _busy ? null : (_) => _toggleFreeAccess(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
