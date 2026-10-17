import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../repositories/admin_repository.dart';

/// Discount code generator (2026-10-17, founder request). Each code is
/// random (e.g. VR-7KQ2-M9XD), works once for one company, then it's used
/// up. Three types — see admin_generate_discount_code() in
/// tools/billing_v2_migration.sql; the customer enters the code on the
/// billing screen and gocardless-start-mandate applies it server-side.
class AdminDiscountCodesScreen extends StatefulWidget {
  const AdminDiscountCodesScreen({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminDiscountCodesScreen> createState() =>
      _AdminDiscountCodesScreenState();
}

const discountCodeTypeLabels = {
  'half_life': '50% off for life',
  'half_year': '50% off for 12 months',
  'free_life': 'Free for life (owners)',
};

class _AdminDiscountCodesScreenState extends State<AdminDiscountCodesScreen> {
  late Future<List<AdminDiscountCode>> _future;
  String _type = 'half_life';
  final _noteController = TextEditingController();
  bool _generating = false;
  String? _justCreated;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.listDiscountCodes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() => _generating = true);
    try {
      final code = await widget.repository.generateDiscountCode(
        type: _type,
        note: _noteController.text,
      );
      if (!mounted) return;
      _noteController.clear();
      setState(() {
        _justCreated = code;
        _future = widget.repository.listDiscountCodes();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not generate a code: $e')),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied $code')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount codes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate a one-time code',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Works once, for one company, then it is used up. '
                    'The customer enters it on their Billing screen.',
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Code type'),
                    items: [
                      for (final e in discountCodeTypeLabels.entries)
                        DropdownMenuItem(value: e.key, child: Text(e.value)),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? _type),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Who is it for? (note, optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate code'),
                    onPressed: _generating ? null : _generate,
                  ),
                  if (_justCreated != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SelectableText(
                          _justCreated!,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          tooltip: 'Copy',
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copy(_justCreated!),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('All codes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<AdminDiscountCode>>(
            future: _future,
            builder: (context, snap) {
              if (snap.hasError) {
                return Text('Could not load codes: ${snap.error}');
              }
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final codes = snap.data!;
              if (codes.isEmpty) return const Text('No codes yet.');
              return Column(
                children: [
                  for (final c in codes)
                    Card(
                      child: ListTile(
                        title: Text(c.code),
                        subtitle: Text(
                          [
                            discountCodeTypeLabels[c.type] ?? c.type,
                            if (c.note != null) c.note!,
                            c.usedAt == null
                                ? 'Unused'
                                : 'Used by ${c.usedByOrgName ?? 'organisation ${c.usedByOrgId}'} '
                                      'on ${c.usedAt!.day}/${c.usedAt!.month}/${c.usedAt!.year}',
                          ].join(' · '),
                        ),
                        trailing: c.usedAt == null
                            ? IconButton(
                                tooltip: 'Copy',
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copy(c.code),
                              )
                            : const Icon(Icons.check_circle_outline),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
