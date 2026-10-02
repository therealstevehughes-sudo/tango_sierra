import 'package:flutter/material.dart';

import '../repositories/admin_repository.dart';

const _statusFilterOptions = ['All', 'open', 'resolved'];

/// Reported bugs/errors (2026-10-02) — closes a gap flagged against the
/// original admin tool spec: nothing in the app ever let a customer
/// report a software bug anywhere VenuRite could see it (the Issues
/// feature is for operational/venue incidents, not app bugs;
/// ContactVenuRiteScreen was just a mailto link). See
/// features/support/report_bug_screen.dart for the customer-facing side
/// that writes these rows.
class AdminBugReportsScreen extends StatefulWidget {
  const AdminBugReportsScreen({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminBugReportsScreen> createState() => _AdminBugReportsScreenState();
}

class _AdminBugReportsScreenState extends State<AdminBugReportsScreen> {
  late Future<List<AdminBugReport>> _future;
  String _statusFilter = 'open';
  final _busyIds = <int>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.repository.getAllBugReports();
  }

  Future<void> _toggleResolved(AdminBugReport report) async {
    setState(() => _busyIds.add(report.id));
    try {
      await widget.repository.setBugReportStatus(
        report.id,
        resolved: !report.isResolved,
      );
      setState(_load);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _busyIds.remove(report.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_load),
          ),
        ],
      ),
      body: FutureBuilder<List<AdminBugReport>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load: ${snapshot.error}'));
          }
          final reports = snapshot.data!
              .where(
                (r) => _statusFilter == 'All' || r.status == _statusFilter,
              )
              .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('${reports.length} report(s)'),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _statusFilter,
                      items: _statusFilterOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _statusFilter = value ?? 'All'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: reports.isEmpty
                    ? const Center(child: Text('No bug reports match this filter.'))
                    : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final r = reports[index];
                          final busy = _busyIds.contains(r.id);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Chip(
                                        label: Text(r.status),
                                        backgroundColor: r.isResolved
                                            ? const Color(0xFFD4EDDA)
                                            : const Color(0xFFFFF3CD),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${r.organisationName}'
                                    '${r.reportedByName != null ? ' - ${r.reportedByName}' : ''}'
                                    '${r.appVersion != null ? ' - v${r.appVersion}' : ''}'
                                    '${r.platform != null ? ' (${r.platform})' : ''}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(r.description),
                                  if (r.adminNote != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Note: ${r.adminNote}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${r.createdAt.year}-${r.createdAt.month.toString().padLeft(2, '0')}-${r.createdAt.day.toString().padLeft(2, '0')}',
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(width: 12),
                                      OutlinedButton(
                                        onPressed: busy
                                            ? null
                                            : () => _toggleResolved(r),
                                        child: Text(
                                          r.isResolved
                                              ? 'Reopen'
                                              : 'Mark resolved',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
