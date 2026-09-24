import 'package:flutter/material.dart';

import '../../shared/models/task_extra_field.dart';
import '../utils/date_format.dart';

/// Generic extra fields (2026-09-24) — one input per TaskExtraFieldDef,
/// shared between TaskScreen (the carousel) and AdHocTaskScreen (the
/// delivery/stock library path, where a PO/batch number matters most).
/// 'date' renders as a tap-to-pick button matching the app's existing
/// time/date-picker pattern rather than free-text, so the stored value is
/// always a real, parseable date.
class ExtraFieldsForm extends StatelessWidget {
  const ExtraFieldsForm({
    super.key,
    required this.fields,
    required this.values,
    required this.onChanged,
  });

  final List<TaskExtraFieldDef> fields;
  final Map<String, String> values;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final field in fields)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildField(context, field),
          ),
      ],
    );
  }

  Widget _buildField(BuildContext context, TaskExtraFieldDef field) {
    if (field.type == TaskExtraFieldType.date) {
      final value = values[field.key];
      return Row(
        children: [
          Expanded(
            child: Text(value == null ? field.label : '${field.label}: $value'),
          ),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked == null) return;
              values[field.key] = formatDate(picked);
              onChanged();
            },
            child: Text(value == null ? 'Pick date' : 'Change'),
          ),
        ],
      );
    }
    return TextFormField(
      key: ValueKey(field.key),
      initialValue: values[field.key],
      keyboardType: field.type == TaskExtraFieldType.number
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(labelText: field.label),
      onChanged: (v) {
        values[field.key] = v;
        onChanged();
      },
    );
  }
}
