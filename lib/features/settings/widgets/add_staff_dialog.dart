import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/job_title_field.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/job_role.dart';
import '../../../shared/models/user.dart';
import '../../../shared/providers/auth_providers.dart';

/// The shared "add a staff member" form fields (2026-09-27) — used by the
/// venue setup wizard, Staff Management, and the branch organogram, so the
/// actual input widgets exist in exactly one place. Deliberately just the
/// fields, not a full dialog/scaffold: the venue setup wizard renders this
/// inline as part of its own step, while [showAddStaffDialog] below wraps
/// it in a real modal for the other two callers, each fitting its own
/// screen's existing shape rather than forcing one presentation on all
/// three.
class AddStaffFormFields extends StatelessWidget {
  const AddStaffFormFields({
    super.key,
    required this.nameController,
    required this.jobTitleController,
    required this.pinController,
    required this.selectedTier,
    required this.onTierChanged,
    required this.selectedJobRole,
    required this.onJobRoleChanged,
    required this.allowedTiers,
  });

  final TextEditingController nameController;
  final TextEditingController jobTitleController;
  final TextEditingController pinController;
  final RoleTier selectedTier;
  final ValueChanged<RoleTier> onTierChanged;
  final JobRole selectedJobRole;
  final ValueChanged<JobRole> onJobRoleChanged;
  // Outrank check (2026-09-27) — a caller (e.g. a supervisor creating
  // someone new) can only hand out tiers it's actually allowed to; see
  // canChangeTier's own doc comment in user.dart for the same rule applied
  // to changing an existing person's tier. Always includes [selectedTier]
  // itself so the dropdown never shows an empty/invalid current value.
  final List<RoleTier> allowedTiers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tierOptions = allowedTiers.contains(selectedTier)
        ? allowedTiers
        : [selectedTier, ...allowedTiers];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.nameAxisLabel),
        ),
        const SizedBox(height: 12),
        JobTitleField(controller: jobTitleController),
        const SizedBox(height: 12),
        DropdownButtonFormField<RoleTier>(
          initialValue: selectedTier,
          decoration: InputDecoration(labelText: l10n.roleTierLabel),
          items: tierOptions
              .map(
                (tier) => DropdownMenuItem(
                  value: tier,
                  child: Text(roleTierDisplayName(tier, l10n)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onTierChanged(value);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<JobRole>(
          initialValue: selectedJobRole,
          decoration: InputDecoration(labelText: l10n.jobRoleFieldLabel),
          items: JobRole.values
              .where((role) => role != JobRole.everyone)
              .map(
                (role) => DropdownMenuItem(
                  value: role,
                  child: Text(jobRoleDisplayName(role, l10n)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onJobRoleChanged(value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(labelText: l10n.pinFieldLabel),
        ),
      ],
    );
  }
}

/// The modal wrapper around [AddStaffFormFields], for callers that don't
/// already have their own inline form step (Staff Management, the branch
/// organogram). Returns the created [User] on success, or null if
/// cancelled/closed without creating anyone.
Future<User?> showAddStaffDialog(
  BuildContext context, {
  required WidgetRef ref,
  required int siteId,
  required RoleTier actingManagerTier,
}) {
  final allowedTiers = RoleTier.values
      .where(
        (t) => canChangeTier(
          actingTier: actingManagerTier,
          targetTier: RoleTier.base, // a brand-new person outranks nobody yet
          newTier: t,
        ),
      )
      .toList();

  return showDialog<User>(
    context: context,
    builder: (context) => _AddStaffDialogContent(
      siteId: siteId,
      allowedTiers: allowedTiers.isEmpty ? [RoleTier.base] : allowedTiers,
    ),
  );
}

class _AddStaffDialogContent extends ConsumerStatefulWidget {
  const _AddStaffDialogContent({
    required this.siteId,
    required this.allowedTiers,
  });

  final int siteId;
  final List<RoleTier> allowedTiers;

  @override
  ConsumerState<_AddStaffDialogContent> createState() =>
      _AddStaffDialogContentState();
}

class _AddStaffDialogContentState
    extends ConsumerState<_AddStaffDialogContent> {
  final _nameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _pinController = TextEditingController();
  late RoleTier _selectedTier = widget.allowedTiers.first;
  JobRole _selectedJobRole = JobRole.chefCook;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final jobTitle = _jobTitleController.text.trim();
    final pin = _pinController.text.trim();
    if (name.isEmpty || jobTitle.isEmpty || pin.isEmpty) return;

    setState(() => _submitting = true);
    final repo = ref.read(userRepositoryProvider);
    final created = await repo.createStaffMember(
      name: name,
      jobTitle: jobTitle,
      roleTier: _selectedTier,
      jobRole: _selectedJobRole,
      pin: pin,
      siteId: widget.siteId,
    );
    if (!mounted) return;
    Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.addStaffMemberTitle),
      content: SingleChildScrollView(
        child: AddStaffFormFields(
          nameController: _nameController,
          jobTitleController: _jobTitleController,
          pinController: _pinController,
          selectedTier: _selectedTier,
          onTierChanged: (t) => setState(() => _selectedTier = t),
          selectedJobRole: _selectedJobRole,
          onJobRoleChanged: (r) => setState(() => _selectedJobRole = r),
          allowedTiers: widget.allowedTiers,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.addLabel),
        ),
      ],
    );
  }
}
