import 'package:flutter/material.dart';

import '../repositories/admin_repository.dart';

const _billedFilterOptions = ['All', 'Billed', 'Not billed'];

/// Service-provider-access purchases (2026-10-02) — closes a gap flagged
/// against the original admin tool spec: unlocks were only ever shown as
/// a per-org count on the customers list, never their own list. Billing
/// itself now happens automatically at unlock time (see
/// unlock-service-provider-billed's own doc comment) — "Mark billed" here
/// is a manual correction tool for when a charge failed and was settled
/// another way, not the primary billing path.
class AdminServiceProviderPurchasesScreen extends StatefulWidget {
  const AdminServiceProviderPurchasesScreen({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminServiceProviderPurchasesScreen> createState() =>
      _AdminServiceProviderPurchasesScreenState();
}

class _AdminServiceProviderPurchasesScreenState
    extends State<AdminServiceProviderPurchasesScreen> {
  late Future<List<AdminServiceProviderPurchase>> _future;
  String _billedFilter = 'All';
  final _busyIds = <int>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.repository.getAllServiceProviderPurchases();
  }

  Future<void> _toggleBilled(AdminServiceProviderPurchase purchase) async {
    setState(() => _busyIds.add(purchase.id));
    try {
      await widget.repository.setUnlockBilled(purchase.id, !purchase.billed);
      setState(_load);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _busyIds.remove(purchase.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service provider purchases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_load),
          ),
        ],
      ),
      body: FutureBuilder<List<AdminServiceProviderPurchase>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load: ${snapshot.error}'));
          }
          final purchases = snapshot.data!.where((p) {
            if (_billedFilter == 'All') return true;
            return _billedFilter == 'Billed' ? p.billed : !p.billed;
          }).toList();
          final totalPence = purchases.fold<int>(0, (sum, p) => sum + p.feePence);
          final unbilledCount = purchases.where((p) => !p.billed).length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      '${purchases.length} purchase(s), '
                      '£${(totalPence / 100).toStringAsFixed(2)} total, '
                      '$unbilledCount unbilled',
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _billedFilter,
                      items: _billedFilterOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _billedFilter = value ?? 'All'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: purchases.isEmpty
                    ? const Center(child: Text('No purchases match this filter.'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Business')),
                              DataColumn(label: Text('Provider')),
                              DataColumn(label: Text('Fee'), numeric: true),
                              DataColumn(label: Text('Billed')),
                              DataColumn(label: Text('Unlocked')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              for (final p in purchases)
                                DataRow(
                                  cells: [
                                    DataCell(Text(p.organisationName)),
                                    DataCell(Text(p.providerName)),
                                    DataCell(
                                      Text('£${(p.feePence / 100).toStringAsFixed(2)}'),
                                    ),
                                    DataCell(
                                      Chip(
                                        label: Text(p.billed ? 'Billed' : 'Not billed'),
                                        backgroundColor: p.billed
                                            ? const Color(0xFFD4EDDA)
                                            : const Color(0xFFFFF3CD),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${p.unlockedAt.year}-${p.unlockedAt.month.toString().padLeft(2, '0')}-${p.unlockedAt.day.toString().padLeft(2, '0')}',
                                      ),
                                    ),
                                    DataCell(
                                      TextButton(
                                        onPressed: _busyIds.contains(p.id)
                                            ? null
                                            : () => _toggleBilled(p),
                                        child: Text(
                                          p.billed ? 'Mark unbilled' : 'Mark billed',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
