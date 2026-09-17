import 'package:flutter/material.dart';

import '../../core/widgets/app_banner.dart';
import '../../shared/models/supplier.dart';

// Extracted (2026-09-17, ad-hoc task path build) from task_screen.dart's
// inline delivery-detail block so the new ad-hoc "Delivery check" flow can
// reuse the exact same form instead of duplicating it — TaskScreen was
// refactored to use this too, not left on its own inline copy.
//
// Self-contained state, reported upward via [onChanged] — the caller owns
// what happens with the value (TaskScreen keeps its own submitTask() logic
// unchanged in shape, just reading from this instead of its own local
// fields). Give this widget a fresh `key` (e.g. `ValueKey(taskIndex)`) per
// distinct task so its internal state doesn't carry over between two
// different delivery tasks in the same session.
class DeliveryDetailValue {
  const DeliveryDetailValue({
    this.supplierId,
    this.temperatureC,
    this.shortDelivery = false,
    this.damagedStock = false,
    this.lateDelivery = false,
    this.qualityProblem = false,
    this.outcome = 'accepted',
  });

  final int? supplierId;
  final double? temperatureC;
  final bool shortDelivery;
  final bool damagedStock;
  final bool lateDelivery;
  final bool qualityProblem;
  final String outcome; // accepted | rejected | partial
}

class DeliveryDetailForm extends StatefulWidget {
  const DeliveryDetailForm({
    super.key,
    required this.suppliers,
    this.initialSupplierId,
    required this.onChanged,
  });

  final List<Supplier> suppliers;
  final int? initialSupplierId;
  final ValueChanged<DeliveryDetailValue> onChanged;

  @override
  State<DeliveryDetailForm> createState() => _DeliveryDetailFormState();
}

class _DeliveryDetailFormState extends State<DeliveryDetailForm> {
  int? _supplierId;
  bool _hasProblem = false;
  final _temperatureController = TextEditingController();
  bool _shortDelivery = false;
  bool _damagedStock = false;
  bool _lateDelivery = false;
  bool _qualityProblem = false;
  String _outcome = 'accepted';

  @override
  void initState() {
    super.initState();
    _supplierId = widget.initialSupplierId;
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  // Fast path never forces a choice, per "one tap if all fine" — reports
  // every problem field as its unset default unless the checkbox below is
  // actually on, same as the original inline behaviour.
  void _notify() {
    widget.onChanged(
      DeliveryDetailValue(
        supplierId: _supplierId,
        temperatureC: _hasProblem
            ? double.tryParse(_temperatureController.text.trim())
            : null,
        shortDelivery: _hasProblem && _shortDelivery,
        damagedStock: _hasProblem && _damagedStock,
        lateDelivery: _hasProblem && _lateDelivery,
        qualityProblem: _hasProblem && _qualityProblem,
        outcome: _hasProblem ? _outcome : 'accepted',
      ),
    );
  }

  String? get _selectedSupplierWarning {
    if (_supplierId == null) return null;
    final selected = widget.suppliers.where((s) => s.id == _supplierId);
    if (selected.isEmpty ||
        selected.first.approvalStatus == SupplierApprovalStatus.approved) {
      return null;
    }
    return 'This supplier is marked '
        '${supplierApprovalStatusLabel(selected.first.approvalStatus)} — the '
        'check will still be recorded.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _supplierId,
          decoration: const InputDecoration(labelText: 'Supplier (optional)'),
          items: widget.suppliers
              .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
              .toList(),
          onChanged: (value) {
            setState(() => _supplierId = value);
            _notify();
          },
        ),
        if (_selectedSupplierWarning != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AppBanner(
              kind: BannerKind.caution,
              child: Text(_selectedSupplierWarning!),
            ),
          ),
        const SizedBox(height: 8),
        // Fast path is this one checkbox, unchecked by default — ticking
        // it is the only way to see the extra fields below, so a fine
        // delivery costs nothing extra.
        CheckboxListTile(
          value: _hasProblem,
          onChanged: (checked) {
            setState(() => _hasProblem = checked ?? false);
            _notify();
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: const Text('Report a problem with this delivery'),
        ),
        if (_hasProblem) ...[
          TextField(
            controller: _temperatureController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Temperature on arrival (°C, optional)',
            ),
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: [
              FilterChip(
                label: const Text('Short delivery'),
                selected: _shortDelivery,
                onSelected: (v) {
                  setState(() => _shortDelivery = v);
                  _notify();
                },
              ),
              FilterChip(
                label: const Text('Damaged stock'),
                selected: _damagedStock,
                onSelected: (v) {
                  setState(() => _damagedStock = v);
                  _notify();
                },
              ),
              FilterChip(
                label: const Text('Late delivery'),
                selected: _lateDelivery,
                onSelected: (v) {
                  setState(() => _lateDelivery = v);
                  _notify();
                },
              ),
              FilterChip(
                label: const Text('Quality problem'),
                selected: _qualityProblem,
                onSelected: (v) {
                  setState(() => _qualityProblem = v);
                  _notify();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _outcome,
            decoration: const InputDecoration(labelText: 'Outcome'),
            items: const [
              DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
              DropdownMenuItem(
                value: 'partial',
                child: Text('Partially accepted'),
              ),
            ],
            onChanged: (v) {
              setState(() => _outcome = v ?? _outcome);
              _notify();
            },
          ),
        ],
      ],
    );
  }
}
