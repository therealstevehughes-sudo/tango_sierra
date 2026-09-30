import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/training_item.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_role_certification_requirement_providers.dart';

// Certification requirements (Phase 2, 2026-09-30) — leadership-only
// screen (regional/executive, see management_drawer.dart's gate) for
// adding EXTRA required certifications per job role, on top of the fixed
// floor in certification_requirement.dart's systemRequiredCertifications().
// Deliberately no way to remove a floor item here — the floor isn't even
// loaded from this screen's data, it's shown as read-only reference text
// so leadership understands what's already mandatory before adding more.
class CertificationRequirementsScreen extends ConsumerStatefulWidget {
  const CertificationRequirementsScreen({super.key});

  @override
  ConsumerState<CertificationRequirementsScreen> createState() =>
      _CertificationRequirementsScreenState();
}

class _CertificationRequirementsScreenState
    extends ConsumerState<CertificationRequirementsScreen> {
  Future<void> _addRequirement(int siteId, int addedByUserId) async {
    var jobRole = JobRole.chefCook;
    var itemType = TrainingItemType.firstAid;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.addCertificationRequirementTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<JobRole>(
                  initialValue: jobRole,
                  decoration: InputDecoration(labelText: l10n.jobRoleFieldLabel),
                  items: JobRole.values
                      .where((r) => r != JobRole.everyone)
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(jobRoleDisplayName(r, l10n)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => jobRole = value ?? jobRole),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TrainingItemType>(
                  initialValue: itemType,
                  decoration: InputDecoration(labelText: l10n.itemFieldLabel),
                  items: TrainingItemType.values
                      .where((t) => t != TrainingItemType.other)
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(trainingItemTypeLabel(t, l10n)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => itemType = value ?? itemType),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true) return;

    final repo = ref.read(siteRoleCertificationRequirementRepositoryProvider);
    await repo.add(
      SiteRoleCertificationRequirement(
        id: null,
        siteId: siteId,
        jobRole: jobRole,
        itemType: itemType,
        addedByUserId: addedByUserId,
        createdAt: DateTime.now(),
      ),
    );
    if (!mounted) return;
    ref.invalidate(siteRoleCertificationRequirementsForSiteProvider(siteId));
  }

  Future<void> _remove(int siteId, int id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeCertificationRequirementTitle),
        content: Text(l10n.removeCertificationRequirementBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removeButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final repo = ref.read(siteRoleCertificationRequirementRepositoryProvider);
    await repo.remove(id);
    if (!mounted) return;
    ref.invalidate(siteRoleCertificationRequirementsForSiteProvider(siteId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final siteId = currentUser?.siteId;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.certificationRequirementsTitle),
        actions: const [AssistantIconButton()],
      ),
      body: siteId == null
          ? Center(child: Text(l10n.noSignedInUserError))
          : SafeArea(
              child: ResponsiveContent(
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncRequirements = ref.watch(
                      siteRoleCertificationRequirementsForSiteProvider(
                        siteId,
                      ),
                    );
                    return asyncRequirements.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => LoadErrorView(
                        error: error.toString(),
                        onRetry: () => ref.invalidate(
                          siteRoleCertificationRequirementsForSiteProvider(
                            siteId,
                          ),
                        ),
                      ),
                      data: (requirements) => ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                l10n.certificationRequirementsFloorNotice,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (requirements.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                              ),
                              child: Text(
                                l10n.noExtraCertificationRequirementsText,
                              ),
                            )
                          else
                            for (final requirement in requirements)
                              Card(
                                child: ListTile(
                                  title: Text(
                                    trainingItemTypeLabel(
                                      requirement.itemType,
                                      l10n,
                                    ),
                                  ),
                                  subtitle: Text(
                                    jobRoleDisplayName(
                                      requirement.jobRole,
                                      l10n,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: l10n.removeButton,
                                    onPressed: () =>
                                        _remove(siteId, requirement.id!),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: siteId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: currentUser == null
                  ? null
                  : () => _addRequirement(siteId, currentUser.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.addRequirementButton),
            ),
    );
  }
}
