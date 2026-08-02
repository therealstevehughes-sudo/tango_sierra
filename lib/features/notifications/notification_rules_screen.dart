import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/notification_rule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/task_template_providers.dart';

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
  List<NotificationRule> rules = [];
  List<TaskTemplate> templates = [];
  List<User> allUsers = [];

  bool showForm = false;
  int? formTaskTemplateGroupId;
  _TargetMode formTargetMode = _TargetMode.tier;
  RoleTier formTargetTier = RoleTier.mid;
  int? formTargetUserId;
  bool formChannelPush = false;
  bool formChannelEmail = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ruleRepo = ref.read(notificationRuleRepositoryProvider);
    final templateRepo = ref.read(taskTemplateRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    final loadedRules = await ruleRepo.getAllCurrentVersions();
    final loadedTemplates = await templateRepo.getAllCurrentVersions();
    final loadedUsers = await userRepo.getAll();

    if (!mounted) return;
    setState(() {
      rules = loadedRules;
      templates = loadedTemplates;
      allUsers = loadedUsers;
      loading = false;
    });
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
      formTargetTier = RoleTier.mid;
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
    if (rule.taskTemplateGroupId == null) return 'Any task fail';
    for (final template in templates) {
      if (template.templateGroupId == rule.taskTemplateGroupId) {
        return '${template.title} fail';
      }
    }
    return 'Task fail (template no longer current)';
  }

  String _targetLabel(NotificationRule rule) {
    if (rule.targetUserId != null) {
      for (final user in allUsers) {
        if (user.id == rule.targetUserId) return user.name;
      }
      return 'Unknown user';
    }
    if (rule.targetRoleTier != null) {
      return '${rule.targetRoleTier!.name} tier';
    }
    return 'Unset';
  }

  String _channelsLabel(NotificationRule rule) {
    final channels = <String>[
      if (rule.channelPush) 'push',
      if (rule.channelEmail) 'email',
    ];
    if (channels.isEmpty) return 'in-app only';
    return 'in-app + ${channels.join(' + ')}';
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Rules')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuickSetupSection(),
                const Divider(),
                if (rules.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No notification rules set up yet.'),
                  )
                else
                  ...rules.map(_buildRuleTile),
                const Divider(),
                if (!showForm)
                  ElevatedButton(
                    onPressed: () => setState(() => showForm = true),
                    child: const Text('Add Rule'),
                  )
                else
                  _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSetupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quick setup: per-task fail notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tick which tier gets notified when a specific task fails.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        if (templates.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No task templates set up yet.'),
          )
        else
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(70),
              2: FixedColumnWidth(70),
            },
            children: [
              const TableRow(
                children: [
                  SizedBox.shrink(),
                  Center(
                    child: Text(
                      'Top',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Mid',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...templates.map((template) {
                final topRule = _currentQuickRuleFor(
                  template.templateGroupId,
                  RoleTier.top,
                );
                final midRule = _currentQuickRuleFor(
                  template.templateGroupId,
                  RoleTier.mid,
                );
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(template.title),
                    ),
                    Center(
                      child: Checkbox(
                        value: topRule?.active ?? false,
                        onChanged: (value) => _toggleQuickRule(
                          template.templateGroupId,
                          RoleTier.top,
                          value ?? false,
                        ),
                      ),
                    ),
                    Center(
                      child: Checkbox(
                        value: midRule?.active ?? false,
                        onChanged: (value) => _toggleQuickRule(
                          template.templateGroupId,
                          RoleTier.mid,
                          value ?? false,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildRuleTile(NotificationRule rule) {
    return Card(
      child: ListTile(
        title: Text(_triggerLabel(rule)),
        subtitle: Text(
          'Notify: ${_targetLabel(rule)} (${_channelsLabel(rule)})\n'
          'Set by ${rule.setByTier.name} tier'
          '${rule.active ? '' : ' — inactive'}',
        ),
        isThreeLine: true,
        trailing: TextButton(
          onPressed: () => _setActive(rule, !rule.active),
          child: Text(rule.active ? 'Deactivate' : 'Reactivate'),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const Text(
          'New Rule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int?>(
          initialValue: formTaskTemplateGroupId,
          decoration: const InputDecoration(labelText: 'Trigger'),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Any task fail'),
            ),
            ...templates.map(
              (t) => DropdownMenuItem<int?>(
                value: t.templateGroupId,
                child: Text('${t.title} fail'),
              ),
            ),
          ],
          onChanged: (value) =>
              setState(() => formTaskTemplateGroupId = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<_TargetMode>(
          initialValue: formTargetMode,
          decoration: const InputDecoration(labelText: 'Notify'),
          items: const [
            DropdownMenuItem(
              value: _TargetMode.tier,
              child: Text('A whole role tier'),
            ),
            DropdownMenuItem(
              value: _TargetMode.user,
              child: Text('A specific person'),
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
            decoration: const InputDecoration(labelText: 'Role tier'),
            items: RoleTier.values
                .map(
                  (t) => DropdownMenuItem(value: t, child: Text(t.name)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => formTargetTier = value);
            },
          )
        else
          DropdownButtonFormField<int?>(
            initialValue: formTargetUserId,
            decoration: const InputDecoration(labelText: 'Person'),
            items: allUsers
                .map(
                  (u) => DropdownMenuItem<int?>(
                    value: u.id,
                    child: Text('${u.name} (${u.jobTitle})'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => formTargetUserId = value),
          ),
        CheckboxListTile(
          title: const Text('Push'),
          value: formChannelPush,
          onChanged: (v) => setState(() => formChannelPush = v ?? false),
        ),
        CheckboxListTile(
          title: const Text('Email'),
          value: formChannelEmail,
          onChanged: (v) => setState(() => formChannelEmail = v ?? false),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Rules are shown in-app now; push/email delivery is not yet '
            'connected to a backend and will be added in a later sprint.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showForm = false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed:
                  formTargetMode == _TargetMode.user &&
                      formTargetUserId == null
                  ? null
                  : _saveRule,
              child: const Text('Save Rule'),
            ),
          ],
        ),
      ],
    );
  }
}
