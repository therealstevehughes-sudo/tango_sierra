import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../shared/models/issue.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/supplier_providers.dart';

// PART 2 of the branch-hub build (2026-09-15) — the "Log something that
// just happened" destination from WorkerHubScreen (base) and
// TierHomeScreen (supervisor+). ANY staff member can raise an issue —
// this screen is deliberately reachable by every tier, with no
// tier-gating on the raise action itself; only Process/Outcome handling
// (issue_detail_screen.dart) is a supervisor+ concern.
//
// Anti-gaming: raising an issue here never touches this user's own task
// completion status or any personal score — it only writes a new `Issue`
// + its first `details`-phase `IssueEvent`. See app_database.dart's
// `Issues` table doc comment for the full governing rule.
class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({
    super.key,
    required this.siteId,
    required this.raisedByUserId,
  });

  final int siteId;
  final int raisedByUserId;

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _detailsController = TextEditingController();
  IssueType? _type;
  String? _subtype;
  bool _submitting = false;
  bool _manualUrgent = false;

  // Supply Problem-only fields.
  List<Supplier> _suppliers = [];
  List<User> _staff = [];
  bool _loadingPickers = false;
  int? _supplierId;
  DeliveryProblemType? _deliveryProblemType;
  int? _receivedByUserId;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _loadPickersIfNeeded() async {
    if (_type != IssueType.supplyProblem || _loadingPickers) return;
    if (_suppliers.isNotEmpty || _staff.isNotEmpty) return;
    setState(() => _loadingPickers = true);
    final suppliers = await ref
        .read(supplierRepositoryProvider)
        .getForSite(widget.siteId);
    final staff = await ref.read(userRepositoryProvider).getForSite(
      widget.siteId,
    );
    if (!mounted) return;
    setState(() {
      _suppliers = suppliers.where((s) => s.active).toList();
      _staff = staff.where((u) => u.active).toList();
      _loadingPickers = false;
    });
  }

  bool get _canSubmit {
    if (_type == null || _detailsController.text.trim().isEmpty) return false;
    if (_type == IssueType.supplyProblem) {
      return _supplierId != null &&
          _deliveryProblemType != null &&
          _receivedByUserId != null;
    }
    return true;
  }

  Future<void> _submit() async {
    final type = _type;
    if (type == null || !_canSubmit) return;
    setState(() => _submitting = true);
    try {
      await ref.read(issueRepositoryProvider).raise(
        siteId: widget.siteId,
        type: type,
        subtype: _subtype,
        details: _detailsController.text.trim(),
        raisedByUserId: widget.raisedByUserId,
        supplierId: _supplierId,
        deliveryProblemType: _deliveryProblemType,
        receivedByUserId: _receivedByUserId,
        manualUrgent: _manualUrgent,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged. Thanks for reporting this.')),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // Pop to root before nulling currentUserProvider — this screen is
  // reachable via Navigator.push (WorkerHubScreen/TierHomeScreen both push
  // it), so without this a pushed copy would stay mounted underneath after
  // logout while MaterialApp.home reactively swapped to LoginScreen. Same
  // fix already applied in TaskScreen._confirmLogOut, mirrored here since
  // this screen had no logout affordance at all otherwise — base tier
  // reaching it from WorkerHubScreen has no drawer to fall back on.
  void _logOut() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(currentUserProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final subtypes = _type == null ? const <String>[] : issueSubtypesFor(_type!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log something that just happened'),
        actions: [
          TextButton.icon(
            onPressed: _logOut,
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Log out'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'What kind of thing happened?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<IssueType>(
                      initialValue: _type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: IssueType.values
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(issueTypeDisplayName(t)),
                            ),
                          )
                          .toList(),
                      onChanged: (t) {
                        setState(() {
                          _type = t;
                          _subtype = null;
                          _supplierId = null;
                          _deliveryProblemType = null;
                          _receivedByUserId = null;
                        });
                        _loadPickersIfNeeded();
                      },
                    ),
                    if (subtypes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _subtype,
                        decoration: const InputDecoration(labelText: 'Which one?'),
                        items: subtypes
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (s) => setState(() => _subtype = s),
                      ),
                    ],
                    if (_type == IssueType.supplyProblem) ...[
                      const SizedBox(height: 12),
                      if (_loadingPickers)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      else ...[
                        DropdownButtonFormField<int>(
                          initialValue: _supplierId,
                          decoration: const InputDecoration(labelText: 'Supplier'),
                          items: _suppliers
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s.id,
                                  child: Text(s.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _supplierId = v),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<DeliveryProblemType>(
                          initialValue: _deliveryProblemType,
                          decoration: const InputDecoration(
                            labelText: 'What was wrong with the delivery?',
                          ),
                          items: DeliveryProblemType.values
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(deliveryProblemTypeDisplayName(d)),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _deliveryProblemType = v),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          initialValue: _receivedByUserId,
                          decoration: const InputDecoration(
                            labelText: 'Received by',
                          ),
                          items: _staff
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u.id,
                                  child: Text(u.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _receivedByUserId = v),
                        ),
                      ],
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: _detailsController,
                      decoration: const InputDecoration(
                        labelText: 'What happened?',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 4),
                    // Manual urgency override (2026-09-17) — additive only:
                    // ticking this always shows the issue as urgent
                    // regardless of age, but leaving it unticked never
                    // suppresses the automatic time-based urgency grading
                    // the register applies later.
                    CheckboxListTile(
                      value: _manualUrgent,
                      onChanged: (v) =>
                          setState(() => _manualUrgent = v ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mark as urgent'),
                      subtitle: const Text(
                        'Needs attention right away, regardless of how long it sits unresolved',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _submitting || !_canSubmit ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Log it'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
