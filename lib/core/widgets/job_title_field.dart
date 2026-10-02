import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/models/common_job_title.dart';

// Job title field (2026-10-02, direct founder bug report) — replaces a
// bare free-text TextField everywhere a staff member's job title is set.
// See common_job_title.dart's own doc comment for the full reasoning:
// free text has no language of its own, so it never translated. This
// widget stores the SAME canonical English string into [controller] that
// every existing call site already reads (createStaffMember, rename,
// etc.) — no API change needed anywhere a TextEditingController was
// already being passed around, only what's rendered to fill it in.
class JobTitleField extends StatefulWidget {
  const JobTitleField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<JobTitleField> createState() => _JobTitleFieldState();
}

// Sentinel for the dropdown's "Custom..." entry — distinct from any real
// job title string, including an empty one.
const _customSentinel = '__custom__';

class _JobTitleFieldState extends State<JobTitleField> {
  late bool _isCustom;

  @override
  void initState() {
    super.initState();
    // A pre-filled controller (editing an existing staff member) starts
    // in dropdown mode if it already holds one of the known canonical
    // titles, otherwise in custom mode (a genuinely custom title, or
    // pre-existing real data from before this fix) with its real value
    // kept visible and editable, never silently discarded.
    _isCustom = !commonJobTitles.contains(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentValue = commonJobTitles.contains(widget.controller.text)
        ? widget.controller.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _isCustom ? _customSentinel : currentValue,
          decoration: InputDecoration(labelText: l10n.jobTitleLabel),
          items: [
            ...commonJobTitles.map(
              (title) => DropdownMenuItem(
                value: title,
                child: Text(localizedJobTitle(title, l10n)),
              ),
            ),
            DropdownMenuItem(
              value: _customSentinel,
              child: Text(l10n.jobTitleCustomOption),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              if (value == _customSentinel) {
                _isCustom = true;
                // A prior dropdown pick left a canonical string in the
                // controller — clear it so "Custom..." starts blank
                // rather than pre-filled with the last pick.
                if (commonJobTitles.contains(widget.controller.text)) {
                  widget.controller.text = '';
                }
              } else {
                _isCustom = false;
                widget.controller.text = value;
              }
            });
          },
        ),
        if (_isCustom) ...[
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: l10n.jobTitleCustomFieldLabel,
            ),
          ),
        ],
      ],
    );
  }
}
