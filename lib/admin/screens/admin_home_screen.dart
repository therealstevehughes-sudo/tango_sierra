import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../repositories/admin_repository.dart';
import 'admin_org_detail_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late Future<List<AdminOrgSummary>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.repository.getAllOrgSummaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VenuRite Admin — Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_load),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await gotrue.Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AdminOrgSummary>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load: ${snapshot.error}'));
          }
          final orgs = snapshot.data!;
          final totalStaff = orgs.fold<int>(0, (sum, o) => sum + o.staffCount);
          final activeCount = orgs
              .where((o) => o.subscriptionStatus == 'active')
              .length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    _statTile('Total customers', orgs.length.toString()),
                    _statTile('Active subscriptions', activeCount.toString()),
                    _statTile('Total staff', totalStaff.toString()),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Business')),
                        DataColumn(label: Text('Key contact')),
                        DataColumn(label: Text('Branches')),
                        DataColumn(label: Text('Staff')),
                        DataColumn(label: Text('Plan')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Joined')),
                      ],
                      rows: [
                        for (final org in orgs)
                          DataRow(
                            onSelectChanged: (_) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminOrgDetailScreen(
                                  repository: widget.repository,
                                  org: org,
                                ),
                              ),
                            ).then((_) => setState(_load)),
                            cells: [
                              DataCell(Text(org.name)),
                              DataCell(
                                Text(org.ownerName ?? org.billingEmail ?? '—'),
                              ),
                              DataCell(Text(org.branchCount.toString())),
                              DataCell(Text(org.staffCount.toString())),
                              DataCell(
                                Text(
                                  '${org.billedSiteCount} branch(es)'
                                  '${org.rosterAddonEnabled ? ' + Roster' : ''}',
                                ),
                              ),
                              DataCell(_statusChip(org)),
                              DataCell(
                                Text(
                                  '${org.createdAt.year}-${org.createdAt.month.toString().padLeft(2, '0')}-${org.createdAt.day.toString().padLeft(2, '0')}',
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

  Widget _statTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _statusChip(AdminOrgSummary org) {
    if (org.restrictedAt != null) {
      return const Chip(
        label: Text('Restricted'),
        backgroundColor: Color(0xFFF8D7DA),
      );
    }
    if (org.freeAccessGranted) {
      return const Chip(
        label: Text('Free access'),
        backgroundColor: Color(0xFFD1ECF1),
      );
    }
    final status = org.subscriptionStatus ?? 'unknown';
    final color = switch (status) {
      'active' => const Color(0xFFD4EDDA),
      'past_due' => const Color(0xFFFFF3CD),
      'cancelled' => const Color(0xFFF8D7DA),
      _ => const Color(0xFFE2E3E5),
    };
    return Chip(label: Text(status), backgroundColor: color);
  }
}
