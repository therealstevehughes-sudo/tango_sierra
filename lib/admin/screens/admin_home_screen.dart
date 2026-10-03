import '../../core/errors/friendly_error.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../repositories/admin_repository.dart';
import 'admin_bug_reports_screen.dart';
import 'admin_org_detail_screen.dart';
import 'admin_service_provider_purchases_screen.dart';

enum _SortColumn { business, branches, staff, joined }

const _statusFilterOptions = [
  'All',
  'active',
  'trialing',
  'past_due',
  'cancelled',
  'Restricted',
  'Free access',
  'Archived',
];

const _paymentFilterOptions = [
  'All',
  'Paid',
  'Trialing',
  'Late',
  'Missed',
];

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late Future<List<AdminOrgSummary>> _future;
  final _searchController = TextEditingController();
  String _statusFilter = 'All';
  String _paymentFilter = 'All';
  _SortColumn _sortColumn = _SortColumn.business;
  bool _sortAscending = true;
  final _selectedIds = <int>{};
  bool _archiving = false;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    _future = widget.repository.getAllOrgSummaries();
    _selectedIds.clear();
  }

  List<AdminOrgSummary> _applyFiltersAndSort(List<AdminOrgSummary> orgs) {
    final query = _searchController.text.trim().toLowerCase();
    // Archived companies are hidden unless explicitly asked for (direct
    // request, 2026-10-01) — "All" means all active customers, not a
    // literal everything-including-archived dump.
    var filtered = orgs.where((o) {
      if (_statusFilter == 'Archived') return o.archivedAt != null;
      if (o.archivedAt != null) return false;
      if (query.isNotEmpty) {
        final haystack = [
          o.name,
          o.ownerName ?? '',
          o.billingEmail ?? '',
        ].join(' ').toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      final statusMatch = switch (_statusFilter) {
        'All' => true,
        'Restricted' => o.restrictedAt != null,
        'Free access' => o.freeAccessGranted,
        _ => o.subscriptionStatus == _statusFilter,
      };
      if (!statusMatch) return false;
      if (_paymentFilter == 'All') return true;
      final payment = computeAdminPaymentStatus(o);
      return switch (_paymentFilter) {
        'Paid' => payment == AdminPaymentStatus.paid,
        'Trialing' => payment == AdminPaymentStatus.trialing,
        'Late' => payment == AdminPaymentStatus.late,
        'Missed' => payment == AdminPaymentStatus.missed,
        _ => true,
      };
    }).toList();

    int compare(AdminOrgSummary a, AdminOrgSummary b) {
      return switch (_sortColumn) {
        _SortColumn.business => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        _SortColumn.branches => a.branchCount.compareTo(b.branchCount),
        _SortColumn.staff => a.staffCount.compareTo(b.staffCount),
        _SortColumn.joined => a.createdAt.compareTo(b.createdAt),
      };
    }

    filtered.sort(_sortAscending ? compare : (a, b) => compare(b, a));
    return filtered;
  }

  void _onSort(_SortColumn column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
    });
  }

  Future<void> _archiveSelected({required bool archived}) async {
    setState(() => _archiving = true);
    try {
      for (final id in _selectedIds) {
        await widget.repository.setArchived(id, archived);
      }
      setState(_load);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyAdminErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _archiving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VenuRite Admin — Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Bug reports',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminBugReportsScreen(repository: widget.repository),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'Service provider purchases',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AdminServiceProviderPurchasesScreen(repository: widget.repository),
              ),
            ),
          ),
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
          final allOrgs = snapshot.data!;
          final orgs = _applyFiltersAndSort(allOrgs);
          final activeOrgs = allOrgs.where((o) => o.archivedAt == null);
          final totalStaff = activeOrgs.fold<int>(
            0,
            (sum, o) => sum + o.staffCount,
          );
          final activeCount = activeOrgs
              .where((o) => o.subscriptionStatus == 'active')
              .length;
          final visibleSelectedCount = _selectedIds
              .where((id) => orgs.any((o) => o.id == id))
              .length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    _statTile('Total customers', activeOrgs.length.toString()),
                    _statTile('Active subscriptions', activeCount.toString()),
                    _statTile('Total staff', totalStaff.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search business, contact or email',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _statusFilter,
                      items: _statusFilterOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _statusFilter = value ?? 'All';
                        _selectedIds.clear();
                      }),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _paymentFilter,
                      items: _paymentFilterOptions
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s == 'All' ? 'Payment: All' : s),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _paymentFilter = value ?? 'All';
                        _selectedIds.clear();
                      }),
                    ),
                    if (visibleSelectedCount > 0) ...[
                      const SizedBox(width: 16),
                      Text('$visibleSelectedCount selected'),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _archiving
                            ? null
                            : () => _archiveSelected(
                                archived: _statusFilter != 'Archived',
                              ),
                        icon: Icon(
                          _statusFilter == 'Archived'
                              ? Icons.unarchive_outlined
                              : Icons.archive_outlined,
                        ),
                        label: Text(
                          _statusFilter == 'Archived'
                              ? 'Unarchive selected'
                              : 'Archive selected',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              Expanded(
                child: orgs.isEmpty
                    ? const Center(child: Text('No customers match this search/filter.'))
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      sortColumnIndex: switch (_sortColumn) {
                        _SortColumn.business => 0,
                        _SortColumn.branches => 2,
                        _SortColumn.staff => 3,
                        _SortColumn.joined => 6,
                      },
                      sortAscending: _sortAscending,
                      onSelectAll: (selectAll) {
                        setState(() {
                          if (selectAll ?? false) {
                            _selectedIds.addAll(orgs.map((o) => o.id));
                          } else {
                            _selectedIds.removeAll(orgs.map((o) => o.id));
                          }
                        });
                      },
                      columns: [
                        DataColumn(
                          label: const Text('Business'),
                          onSort: (_, asc) => _onSort(_SortColumn.business, asc),
                        ),
                        const DataColumn(label: Text('Key contact')),
                        DataColumn(
                          label: const Text('Branches'),
                          numeric: true,
                          onSort: (_, asc) => _onSort(_SortColumn.branches, asc),
                        ),
                        DataColumn(
                          label: const Text('Staff'),
                          numeric: true,
                          onSort: (_, asc) => _onSort(_SortColumn.staff, asc),
                        ),
                        const DataColumn(label: Text('Plan')),
                        const DataColumn(label: Text('Status')),
                        const DataColumn(label: Text('Payment')),
                        DataColumn(
                          label: const Text('Joined'),
                          onSort: (_, asc) => _onSort(_SortColumn.joined, asc),
                        ),
                      ],
                      rows: [
                        for (final org in orgs)
                          DataRow(
                            // Checkbox ONLY selects for bulk actions now —
                            // navigation moved to tapping the business
                            // name specifically (direct bug report,
                            // 2026-10-01: ticking the box used to also
                            // open the detail screen).
                            selected: _selectedIds.contains(org.id),
                            onSelectChanged: (selected) => setState(() {
                              if (selected ?? false) {
                                _selectedIds.add(org.id);
                              } else {
                                _selectedIds.remove(org.id);
                              }
                            }),
                            cells: [
                              DataCell(
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminOrgDetailScreen(
                                        repository: widget.repository,
                                        org: org,
                                      ),
                                    ),
                                  ).then((_) => setState(_load)),
                                  child: Text(
                                    org.name,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
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
                              DataCell(_paymentChip(org)),
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
    if (org.archivedAt != null) {
      return const Chip(
        label: Text('Archived'),
        backgroundColor: Color(0xFFE2E3E5),
      );
    }
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

  Widget _paymentChip(AdminOrgSummary org) {
    if (org.freeAccessGranted) {
      return const Chip(
        label: Text('Free access'),
        backgroundColor: Color(0xFFD1ECF1),
      );
    }
    final payment = computeAdminPaymentStatus(org);
    final (label, color) = switch (payment) {
      AdminPaymentStatus.paid => ('Paid', const Color(0xFFD4EDDA)),
      AdminPaymentStatus.trialing => ('Trialing', const Color(0xFFE2E3E5)),
      AdminPaymentStatus.late => ('Late', const Color(0xFFFFF3CD)),
      AdminPaymentStatus.missed => ('Missed', const Color(0xFFF8D7DA)),
      AdminPaymentStatus.unknown => ('-', const Color(0xFFE2E3E5)),
    };
    return Chip(label: Text(label), backgroundColor: color);
  }
}
