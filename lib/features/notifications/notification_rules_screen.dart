import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';

import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/common_job_title.dart';
import '../../shared/models/notification_rule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

enum _TargetMode { tier, user }

class NotificationRulesScreen extends ConsumerStatefulWidget {
  const NotificationRulesScreen({super.key});

  @override
  ConsumerState<NotificationRulesScreen> createState() =>
      _NotificationRulesScreenState();
}

class _NotificationRulesScreenState
    extends ConsumerState<NotificationRulesScreen> {
  bool loading = true;
  String? loadError;
  List<NotificationRule> rules = [];
  List<TaskTemplate> templates = [];
  List<User> allUsers = [];

  bool showForm = false;
  int? formTaskTemplateGroupId;
  _TargetMode formTargetMode = _TargetMode.tier;
  RoleTier formTargetTier = RoleTier.supervisor;
  int? formTargetUserId;
  bool formChannelPush = false;
  bool formChannelEmail = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    // One silent retry before showing an error — see
    // venue_setup_wizard_screen.dart's own _loadData() for the full
    // explanation: reading `currentSiteProvider.future` this early can hit
    // a rare Riverpod internal race ("_listenedElement was called on
    // null"), caught live during a demo. A persistent failure still
    // surfaces via loadError on the second attempt.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final ruleRepo = ref.read(notificationRuleRepositoryProvider);
        final templateRepo = ref.read(taskTemplateRepositoryProvider);
        final userRepo = ref.read(userRepositoryProvider);
        final currentUser = ref.read(currentUserProvider);
        final siteId =
            ref.read(activeSiteProvider)?.id ??
            currentUser?.siteId ??
            (await ref.read(currentSiteProvider.future)).id;

        final loadedRules = await ruleRepo.getAllCurrentVersions();
        final loadedTemplates = await templateRepo.getAllCurrentVersions();
        final loadedUsers = await userRepo.getForSite(siteId);

        if (!mounted) return;
        setState(() {
          rules = loadedRules;
          templates = loadedTemplates;
          allUsers = loadedUsers;
          loading = false;
        });
        return;
      } catch (e) {
        if (!mounted) return;
        if (attempt == 0) continue;
        setState(() {
          loadError = e.toString();
          loading = false;
        });
      }
    }
  }

  Future<void> _saveRule() async {
    final setBy = ref.read(currentUserProvider);
    if (setBy == null) return;
    if (formTargetMode == _TargetMode.user && formTargetUserId == null) {
      return;
    }

    final ruleRepo = ref.read(notificationRuleRepositoryProvider);
    await ruleRepo.saveNewVersion(
      taskTemplateGroupId: formTaskTemplateGroupId,
      targetRoleTier: formTargetMode == _TargetMode.tier
          ? formTargetTier
          : null,
      targetUserId: formTargetMode == _TargetMode.user
          ? formTargetUserId
          : null,
      channelPush: formChannelPush,
      channelEmail: formChannelEmail,
      setByUserId: setBy.id,
      setByTier: setBy.roleTier,
      active: true,
      siteId: setBy.siteId,
    );

    if (!mounted) return;
    setState(() {
      showForm = false;
      formTaskTemplateGroupId = null;
      formTargetMode = _TargetMode.tier;
      formTargetTier = RoleTier.supervisor;
      formTargetUserId = null;
      formChannelPush = false;
      formChannelEmail = false;
    });
    await _loadData();
  }

  Future<void> _setActive(NotificationRule rule, bool active) async {
    final setBy = ref.read(currentUserProvider);
    if (setBy == null) return;

    final ruleRepo = ref.read(notificationRuleRepositoryProvider);
    await ruleRepo.saveNewVersion(
      ruleGroupId: rule.ruleGroupId,
      taskTemplateGroupId: rule.taskTemplateGroupId,
      targetRoleTier: rule.targetRoleTier,
      targetUserId: rule.targetUserId,
      channelPush: rule.channelPush,
      channelEmail: rule.channelEmail,
      setByUserId: setBy.id,
      setByTier: setBy.roleTier,
      active: active,
      siteId: rule.siteId,
    );

    await _loadData();
  }

  String _triggerLabel(NotificationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    if (rule.taskTemplateGroupId == null) return l10n.anyTaskFail;
    for (final template in templates) {
      if (template.templateGroupId == rule.taskTemplateGroupId) {
        return l10n.taskFailLabel(template.title);
      }
    }
    return l10n.taskFailTemplateStale;
  }

  String _targetLabel(NotificationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    if (rule.targetUserId != null) {
      for (final user in allUsers) {
        if (user.id == rule.targetUserId) return user.name;
      }
      return l10n.unknownUserLabel;
    }
    if (rule.targetRoleTier != null) {
      return l10n.tierSuffixLabel(roleTierDisplayName(rule.targetRoleTier!, l10n));
    }
    return l10n.unsetLabel;
  }

  String _channelsLabel(NotificationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    final channels = <String>[
      if (rule.channelPush) l10n.pushChannelLabel,
      if (rule.channelEmail) l10n.emailChannelLabel,
    ];
    if (channels.isEmpty) return l10n.inAppOnlyLabel;
    return l10n.inAppPlusChannelsLabel(channels.join(' + '));
  }

  // Short labels so all 5 tier columns fit the quick-setup grid (Sprint 027
  // expanded this from 2 hardcoded Top/Mid columns to one per tier).
  // Sprint 031 (Tier display names): abbreviated from roleTierDisplayName,
  // not the raw enum — 'Exec' would now contradict 'Director' shown
  // everywhere else for the same tier.
  String _tierColumnLabel(RoleTier tier) {
    final l10n = AppLocalizations.of(context)!;
    switch (tier) {
      case RoleTier.base:
        return l10n.tierColumnTeam;
      case RoleTier.supervisor:
        return l10n.tierColumnSupv;
      case RoleTier.venueManager:
        return l10n.tierColumnMgr;
      case RoleTier.regional:
        return l10n.tierColumnRegnl;
      case RoleTier.executive:
        return l10n.tierColumnDir;
    }
  }

  NotificationRule? _currentQuickRuleFor(int templateGroupId, RoleTier tier) {
    for (final rule in rules) {
      if (rule.taskTemplateGroupId == templateGroupId &&
          rule.targetRoleTier == tier &&
          rule.targetUserId == null) {
        return rule;
      }
    }
    return null;
  }

  Future<void> _toggleQuickRule(
    int templateGroupId,
    RoleTier tier,
    bool enable,
  ) async {
    final setBy = ref.read(currentUserProvider);
    if (setBy == null) return;

    final existing = _currentQuickRuleFor(templateGroupId, tier);
    final ruleRepo = ref.read(notificationRuleRepositoryProvider);

    await ruleRepo.saveNewVersion(
      ruleGroupId: existing?.ruleGroupId,
      taskTemplateGroupId: templateGroupId,
      targetRoleTier: tier,
      channelPush: existing?.channelPush ?? false,
      channelEmail: existing?.channelEmail ?? false,
      setByUserId: setBy.id,
      setByTier: setBy.roleTier,
      active: enable,
      siteId: existing?.siteId ?? setBy.siteId,
    );

    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.notificationRules),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.notificationRules),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? LoadErrorView(error: loadError!, onRetry: _loadData)
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Responsive foundation: wider than the 480 default — the
          // quick-setup section below has a role-tier x task-template
          // table that's already built to scroll horizontally rather than
          // fit any fixed width, so a wider cap keeps that scrolling to a
          // minimum while still capping the plain rule-list/form content.
          child: ResponsiveContent(
            maxWidth: 560,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildQuickSetupSection(),
                  const Divider(),
                  if (rules.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(l10n.noNotificationRulesYet),
                    )
                  else
                    ...rules.map(_buildRuleTile),
                  const Divider(),
                  if (!showForm)
                    PrimaryActionButton(
                      label: l10n.addRuleButton,
                      onPressed: () => setState(() => showForm = true),
                    )
                  else
                    _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSetupSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.quickSetupSectionTitle),
        Text(
          l10n.tickTierNotified,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        if (templates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.noTaskTemplatesSetUp),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              columnWidths: {
                0: const FixedColumnWidth(160),
                for (var i = 1; i <= RoleTier.values.length; i++)
                  i: const FixedColumnWidth(90),
              },
              children: [
                TableRow(
                  children: [
                    const SizedBox.shrink(),
                    for (final tier in RoleTier.values)
                      Center(
                        child: Text(
                          _tierColumnLabel(tier),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                ...templates.map((template) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(template.title),
                      ),
                      for (final tier in RoleTier.values)
                        Center(
                          child: Checkbox(
                            value:
                                _currentQuickRuleFor(
                                  template.templateGroupId,
                                  tier,
                                )?.active ??
                                false,
                            onChanged: (value) => _toggleQuickRule(
                              template.templateGroupId,
                              tier,
                              value ?? false,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRuleTile(NotificationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        title: Text(_triggerLabel(rule)),
        subtitle: Text(
          '${l10n.notifyPrefixLabel(_targetLabel(rule), _channelsLabel(rule))}\n'
          '${l10n.setByTierLabel(roleTierDisplayName(rule.setByTier, l10n))}'
          '${rule.active ? '' : l10n.inactiveSuffixLabel}',
        ),
        isThreeLine: true,
        trailing: TextButton(
          onPressed: () => _setActive(rule, !rule.active),
          child: Text(rule.active ? l10n.deactivateButton : l10n.reactivateButton),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        SectionHeader(title: l10n.newRuleTitle),
        DropdownButtonFormField<int?>(
          initialValue: formTaskTemplateGroupId,
          decoration: InputDecoration(labelText: l10n.triggerLabel),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(l10n.anyTaskFail),
            ),
            ...templates.map(
              (t) => DropdownMenuItem<int?>(
                value: t.templateGroupId,
                child: Text(l10n.taskFailLabel(t.title)),
              ),
            ),
          ],
          onChanged: (value) => setState(() => formTaskTemplateGroupId = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<_TargetMode>(
          initialValue: formTargetMode,
          decoration: InputDecoration(labelText: l10n.notifyLabel),
          items: [
            DropdownMenuItem(
              value: _TargetMode.tier,
              child: Text(l10n.wholeRoleTierOption),
            ),
            DropdownMenuItem(
              value: _TargetMode.user,
              child: Text(l10n.specificPersonOption),
            ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => formTargetMode = value);
          },
        ),
        const SizedBox(height: 12),
        if (formTargetMode == _TargetMode.tier)
          DropdownButtonFormField<RoleTier>(
            initialValue: formTargetTier,
            decoration: InputDecoration(labelText: l10n.roleTierLabel),
            items: RoleTier.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(roleTierDisplayName(t, l10n)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => formTargetTier = value);
            },
          )
        else
          DropdownButtonFormField<int?>(
            initialValue: formTargetUserId,
            decoration: InputDecoration(labelText: l10n.personLabel),
            items: allUsers
                .map(
                  (u) => DropdownMenuItem<int?>(
                    value: u.id,
                    child: Text(
                      '${u.name} (${localizedJobTitle(u.jobTitle, l10n)})',
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => formTargetUserId = value),
          ),
        CheckboxListTile(
          title: Text(l10n.pushLabel),
          value: formChannelPush,
          onChanged: (v) => setState(() => formChannelPush = v ?? false),
        ),
        CheckboxListTile(
          title: Text(l10n.emailLabel),
          value: formChannelEmail,
          onChanged: (v) => setState(() => formChannelEmail = v ?? false),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.rulesInAppNotice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showForm = false),
              child: Text(l10n.cancel),
            ),
            PrimaryActionButton(
              label: l10n.saveRuleButton,
              onPressed:
                  formTargetMode == _TargetMode.user && formTargetUserId == null
                  ? null
                  : _saveRule,
            ),
          ],
        ),
      ],
    );
  }
}
