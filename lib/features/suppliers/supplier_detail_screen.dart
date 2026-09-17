import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/breakdown_sheet.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/issue.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/task_submission.dart';
import 'supplier_scorecard_service.dart';

// Supplier/Delivery Scorecard (Sprint 038, 2026-09-17) — reachable both
// from Supplier Management (tap a supplier) and from a raised
// supply-problem Issue's detail screen (jump straight to that supplier).
// Deliberately no single composite score: per the user's explicit call,
// a flattened percentage would hide severity (one temperature failure is
// far worse than one late delivery) — each category is its own row with
// its own count and rate, never combined into one number.
class SupplierDetailScreen extends ConsumerStatefulWidget {
  const SupplierDetailScreen({super.key, required this.supplier});

  final Supplier supplier;

  @override
  ConsumerState<SupplierDetailScreen> createState() =>
      _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends ConsumerState<SupplierDetailScreen> {
  DateTimeRange _range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  bool _loading = true;
  SupplierDeliveryScorecard? _scorecard;
  List<Issue> _reportedIssues = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final supplierId = widget.supplier.id;
    final siteId = widget.supplier.siteId;
    if (supplierId == null) {
      setState(() => _loading = false);
      return;
    }
    final service = ref.read(supplierScorecardServiceProvider);
    final results = await Future.wait([
      service.computeDeliveryScorecard(
        siteId: siteId,
        supplierId: supplierId,
        start: _range.start,
        end: _range.end,
      ),
      service.getReportedIssues(
        siteId: siteId,
        supplierId: supplierId,
        start: _range.start,
        end: _range.end,
      ),
    ]);
    if (!mounted) return;
    setState(() {
      _scorecard = results[0] as SupplierDeliveryScorecard;
      _reportedIssues = results[1] as List<Issue>;
      _loading = false;
    });
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (picked == null) return;
    setState(() => _range = picked);
    await _load();
  }

  void _showDeliveryBreakdown(String title, List<TaskSubmission> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BreakdownSheet(
        title: title,
        count: items.length,
        rows: [
          for (final s in items)
            BreakdownRow(
              title: s.displayTitle,
              subtitle: formatDateTime(s.completedAt),
            ),
        ],
      ),
    );
  }

  void _showIssueBreakdown() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BreakdownSheet(
        title: 'Reported issues',
        count: _reportedIssues.length,
        rows: [
          for (final i in _reportedIssues)
            BreakdownRow(
              title: i.deliveryProblemType != null
                  ? deliveryProblemTypeDisplayName(i.deliveryProblemType!)
                  : issueTypeDisplayName(i.type),
              subtitle: '${i.details} — ${formatDateTime(i.raisedAt)}',
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supplier = widget.supplier;
    return Scaffold(
      appBar: AppBar(title: Text(supplier.name)),
      body: ResponsiveContent(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16),
              _buildDateRangePicker(),
              const SizedBox(height: 16),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                _buildDeliveryScorecard(),
                const SizedBox(height: 16),
                _buildReportedIssuesCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final supplier = widget.supplier;
    final (kind, label) = switch (supplier.approvalStatus) {
      SupplierApprovalStatus.approved => (StatusKind.pass, 'Approved'),
      SupplierApprovalStatus.pending => (StatusKind.caution, 'Pending'),
      SupplierApprovalStatus.suspended => (StatusKind.critical, 'Suspended'),
    };
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.displayCategory,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (supplier.contact != null)
                  Text(
                    supplier.contact!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          StatusBadge(kind: kind, label: label),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return InkWell(
      onTap: _pickDateRange,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date range',
          isDense: true,
          suffixIcon: Icon(Icons.date_range),
        ),
        child: Text('${formatDate(_range.start)} — ${formatDate(_range.end)}'),
      ),
    );
  }

  Widget _buildDeliveryScorecard() {
    final scorecard = _scorecard;
    if (scorecard == null || scorecard.total == 0) {
      return const AppCard(
        child: Text(
          'No deliveries logged against this supplier in this period.',
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery scorecard (${scorecard.total} deliveries)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Each category below counts independently — a delivery can '
            'appear in more than one row (e.g. late AND damaged).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _scoreRow(
            'Late delivery',
            scorecard.late,
            scorecard.lateRate,
            AppColors.caution,
          ),
          _scoreRow(
            'Short delivery',
            scorecard.short,
            scorecard.shortRate,
            AppColors.caution,
          ),
          _scoreRow(
            'Damaged stock',
            scorecard.damaged,
            scorecard.damagedRate,
            AppColors.critical,
          ),
          _scoreRow(
            'Quality problem',
            scorecard.qualityProblem,
            scorecard.qualityProblemRate,
            AppColors.critical,
          ),
          _scoreRow(
            'Rejected outright',
            scorecard.rejected,
            scorecard.rejectedRate,
            AppColors.critical,
          ),
          _scoreRow(
            'Accepted partially',
            scorecard.partial,
            scorecard.partialRate,
            AppColors.caution,
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(
    String label,
    List<TaskSubmission> items,
    double rate,
    Color color,
  ) {
    return InkWell(
      onTap: items.isEmpty ? null : () => _showDeliveryBreakdown(label, items),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: items.isEmpty ? AppColors.line : color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
            Text(
              '${items.length} (${(rate * 100).round()}%)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportedIssuesCard() {
    return AppCard(
      child: InkWell(
        onTap: _reportedIssues.isEmpty ? null : _showIssueBreakdown,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reported issues',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supply-problem issues raised against this supplier — a '
                    'separate log from the delivery scorecard above, not '
                    'merged into it.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${_reportedIssues.length}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
