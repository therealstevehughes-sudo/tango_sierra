import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/task_submission_providers.dart' show appDatabaseProvider;
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../shared/repositories/venue_type_repository.dart';
import '../auth/senior_login_screen.dart';

/// Sprint 034 (Customer Onboarding & Billing Foundation) — replaces the
/// old single-screen `TenantSignupScreen` with the full step-by-step
/// wizard: admin account, company details, an org-structure explainer,
/// first venue, subscription, and a payment placeholder (no real Stripe
/// call yet — see `tenant-signup`'s doc comment and DECISIONS_LOG.md's
/// Sprint 034 entry, decision #3). Mirrors `VenueSetupWizardScreen`'s
/// already-proven step pattern (single StatefulWidget, `currentStep`
/// index, Back/Next) rather than inventing a new one — every controller
/// lives in this one State, so moving back and forth never loses what
/// was typed.
class CompanyOnboardingWizardScreen extends ConsumerStatefulWidget {
  const CompanyOnboardingWizardScreen({super.key});

  @override
  ConsumerState<CompanyOnboardingWizardScreen> createState() =>
      _CompanyOnboardingWizardScreenState();
}

const _stepCount = 7;
const _stepTitles = [
  'Your account',
  'Company details',
  'Organisation structure',
  'First venue',
  'Your starter setup',
  'Subscription',
  'Payment',
];

class _CompanyOnboardingWizardScreenState
    extends ConsumerState<CompanyOnboardingWizardScreen> {
  int currentStep = 0;
  bool _submitting = false;
  String? _error;
  TenantSignupResult? _done;

  // Step 1 — admin account
  final _inviteCode = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  // Step 2 — company details
  final _companyName = TextEditingController();
  final _legalName = TextEditingController();
  final _country = TextEditingController();
  final _registeredAddress = TextEditingController();
  final _vatNumber = TextEditingController();
  final _billingEmail = TextEditingController();

  // Step 4 — first venue
  final _venueName = TextEditingController();
  final _venueAddress = TextEditingController();
  final _venueRegion = TextEditingController();
  // Sprint 044 (2026-09-21) fix, found building the payoff step: this
  // used to be a hand-typed dropdown with 5 made-up values
  // ('Restaurant'/'Bar'/'Cafe'/'Hotel'/'Catering') that matched none of
  // the real 12 seeded venue types except 'Hotel' — every other choice
  // silently failed to tag anything, all the way back to whenever this
  // step was first built. Now loaded from the real local library so it
  // can never drift out of sync again. `_venueType` (the name, sent to
  // tenant-signup unchanged) and `_venueTypeId` (used locally by the
  // payoff step below) are set together from the same selection.
  List<VenueType> _venueTypes = [];
  String? _venueType;
  int? _venueTypeId;

  // Step 5 — subscription. Sprint 043 (2026-09-21) — reconciled to the
  // real plan keys GoCardless billing actually charges against
  // ('friends'/'standard'/'premier', see subscription.dart's own doc
  // comment) — this used to offer 'starter'/'growth'/'enterprise', which
  // didn't correspond to anything the billing side understood.
  String _planName = 'standard';

  // Payment provider preference (2026-09-14) -- captured now, not wired
  // to any real payment API yet (see decision #3 in DECISIONS_LOG.md).
  // null is a valid, deliberate choice: "decide later" shouldn't block
  // finishing sign-up.
  String? _paymentProvider;

  @override
  void initState() {
    super.initState();
    _loadVenueTypes();
  }

  Future<void> _loadVenueTypes() async {
    final db = ref.read(appDatabaseProvider);
    final types = await DriftVenueTypeRepository(db).getAll();
    if (!mounted) return;
    setState(() => _venueTypes = types);
  }

  @override
  void dispose() {
    _inviteCode.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _companyName.dispose();
    _legalName.dispose();
    _country.dispose();
    _registeredAddress.dispose();
    _vatNumber.dispose();
    _billingEmail.dispose();
    _venueName.dispose();
    _venueAddress.dispose();
    _venueRegion.dispose();
    super.dispose();
  }

  bool get _step0Valid =>
      _inviteCode.text.trim().isNotEmpty &&
      _firstName.text.trim().isNotEmpty &&
      _lastName.text.trim().isNotEmpty &&
      _email.text.trim().contains('@') &&
      _password.text.length >= 8;

  bool get _step1Valid =>
      _companyName.text.trim().isNotEmpty && _country.text.trim().isNotEmpty;

  bool get _step3Valid => _venueName.text.trim().isNotEmpty;

  bool get _canAdvance {
    switch (currentStep) {
      case 0:
        return _step0Valid;
      case 1:
        return _step1Valid;
      case 3:
        return _step3Valid;
      default:
        return true;
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _submitting = true;
    });
    try {
      final result = await ref
          .read(tenantProvisioningRepositoryProvider)
          .signUpCompany(
            inviteCode: _inviteCode.text.trim(),
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            companyName: _companyName.text.trim(),
            country: _country.text.trim(),
            venueName: _venueName.text.trim(),
            legalName: _legalName.text.trim().isEmpty
                ? null
                : _legalName.text.trim(),
            registeredAddress: _registeredAddress.text.trim().isEmpty
                ? null
                : _registeredAddress.text.trim(),
            vatNumber: _vatNumber.text.trim().isEmpty
                ? null
                : _vatNumber.text.trim(),
            billingEmail: _billingEmail.text.trim().isEmpty
                ? null
                : _billingEmail.text.trim(),
            venueAddress: _venueAddress.text.trim().isEmpty
                ? null
                : _venueAddress.text.trim(),
            venueRegion: _venueRegion.text.trim().isEmpty
                ? null
                : _venueRegion.text.trim(),
            venueType: _venueType,
            planName: _planName,
            paymentProvider: _paymentProvider,
          );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _done = result;
      });
    } on TenantSignupException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Company created')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ResponsiveContent(
              maxWidth: 440,
              alignment: Alignment.center,
              child: _SuccessView(result: _done!),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_stepTitles[currentStep]} — Step ${currentStep + 1} of $_stepCount',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 480,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SingleChildScrollView(child: _buildStep())),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  AppBanner(kind: BannerKind.critical, child: Text(_error!)),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentStep > 0)
                      TextButton(
                        onPressed: _submitting
                            ? null
                            : () => setState(() => currentStep -= 1),
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox.shrink(),
                    PrimaryActionButton(
                      label: _submitting
                          ? 'Creating...'
                          : currentStep < _stepCount - 1
                          ? 'Continue'
                          : 'Start free trial',
                      onPressed: _submitting || !_canAdvance
                          ? null
                          : () {
                              if (currentStep < _stepCount - 1) {
                                setState(() => currentStep += 1);
                              } else {
                                _submit();
                              }
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _buildAdminAccountStep();
      case 1:
        return _buildCompanyDetailsStep();
      case 2:
        return _buildStructureStep();
      case 3:
        return _buildVenueStep();
      case 4:
        return _buildPayoffStep();
      case 5:
        return _buildSubscriptionStep();
      case 6:
        return _buildPaymentStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAdminAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Let's set up your account. You'll be the administrator for "
          'this company on VenuRite, and can invite your team once '
          "you're in.",
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _inviteCode,
          decoration: const InputDecoration(
            labelText: 'Invite code',
            helperText:
                "Don't have one? Contact us to get started.",
          ),
          textCapitalization: TextCapitalization.characters,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _firstName,
          decoration: const InputDecoration(labelText: 'First name'),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _lastName,
          decoration: const InputDecoration(labelText: 'Last name'),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: 'At least 8 characters',
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCompanyDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Tell us about your company.'),
        const SizedBox(height: 16),
        TextField(
          controller: _companyName,
          decoration: const InputDecoration(
            labelText: 'Trading / company name',
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _legalName,
          decoration: const InputDecoration(
            labelText: 'Legal company name (optional)',
            helperText: "Leave blank to use the trading name above",
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _country,
          decoration: const InputDecoration(labelText: 'Country'),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _registeredAddress,
          decoration: const InputDecoration(
            labelText: 'Registered / business address (optional)',
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _vatNumber,
          decoration: const InputDecoration(
            labelText: 'VAT / tax number (if applicable)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _billingEmail,
          decoration: InputDecoration(
            labelText: 'Billing contact email (optional)',
            helperText: 'Leave blank to use ${_email.text.trim().isEmpty ? "your email" : _email.text.trim()}',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildStructureStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Here's how VenuRite organises your company. You don't need to "
          'set anything up now — this is just so the next step makes sense.',
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _StructureRow(
                icon: Icons.apartment,
                label: 'Your company',
                sublabel: 'One consolidated account and bill',
              ),
              _StructureRow(
                icon: Icons.map_outlined,
                label: 'Regions (optional)',
                sublabel: 'Group venues by country or area — skip if you '
                    "don't need it",
                indent: 1,
              ),
              _StructureRow(
                icon: Icons.storefront_outlined,
                label: 'Venues',
                sublabel: 'One venue today, hundreds later — add more any '
                    'time',
                indent: 2,
              ),
              _StructureRow(
                icon: Icons.people_outline,
                label: 'Staff',
                sublabel: "Each venue's team, invited once it exists",
                indent: 3,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "We'll set up your first venue next — you can add regions and "
          'more venues later from inside the app.',
        ),
      ],
    );
  }

  Widget _buildVenueStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Let's add your first venue. You can add more later.",
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _venueName,
          decoration: const InputDecoration(labelText: 'Venue name'),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _venueAddress,
          decoration: const InputDecoration(
            labelText: 'Address (optional)',
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _venueRegion,
          decoration: const InputDecoration(
            labelText: 'Region / area (optional)',
            helperText: 'e.g. "London" — only needed if you have (or will '
                'have) more than one venue',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _venueTypeId,
          decoration: const InputDecoration(
            labelText: 'Venue type (optional)',
            helperText: "Picking one shows you a ready-made starter set "
                'next — for tasks and equipment you already know you need.',
          ),
          items: _venueTypes
              .map(
                (t) => DropdownMenuItem(value: t.id, child: Text(t.name)),
              )
              .toList(),
          onChanged: (v) => setState(() {
            _venueTypeId = v;
            _venueType = _venueTypes
                .firstWhere((t) => t.id == v)
                .name;
          }),
        ),
      ],
    );
  }

  // Sprint 044 (The Payoff Moment, 2026-09-21) — shown before the plan/
  // payment steps, per the user's own spec: "here's your compliance,
  // ready to go," using ONLY venue type (already chosen, above) — no
  // section/team choice at this point, since no staff exist yet to
  // assign anything to (confirmed with the user; see DECISIONS_LOG.md).
  // Reads the local task/equipment TYPE library directly via
  // Drift*Repository, bypassing the usual Provider switching on purpose:
  // this is universal reference data seeded into every install
  // (HORECA_TASK_LIBRARY.md), not tenant data, and there is no backend
  // session yet to read it through even if it were.
  Future<_PayoffData>? _payoffFuture;
  int? _payoffLoadedForVenueTypeId;

  Future<_PayoffData> _loadPayoffData(int venueTypeId) async {
    final db = ref.read(appDatabaseProvider);
    final templateRepo = DriftTaskTemplateRepository(db);
    final equipmentRepo = DriftEquipmentRepository(db);

    final allTemplates = await templateRepo.getAllCurrentVersions();
    final matchingTasks = <TaskTemplate>[];
    for (final template in allTemplates) {
      final venueTypeIds = await templateRepo.getVenueTypeIds(
        template.templateGroupId,
      );
      if (venueTypeIds.contains(venueTypeId)) matchingTasks.add(template);
    }

    final allEquipmentTypes = await equipmentRepo.getEquipmentTypes();
    final matchingEquipment = <EquipmentType>[];
    for (final type in allEquipmentTypes) {
      final venueTypeIds = await equipmentRepo.getVenueTypeIds(type.id);
      if (venueTypeIds.contains(venueTypeId)) matchingEquipment.add(type);
    }

    final bySegment = <String, List<TaskTemplate>>{};
    for (final task in matchingTasks) {
      bySegment.putIfAbsent(task.segment, () => []).add(task);
    }

    return _PayoffData(tasksBySegment: bySegment, equipment: matchingEquipment);
  }

  Widget _buildPayoffStep() {
    final venueTypeId = _venueTypeId;
    if (venueTypeId == null) {
      return const Text(
        "You skipped choosing a venue type, so there's no starter set "
        "to show yet — you can add tasks and equipment yourself once "
        "you're in.",
      );
    }
    if (_payoffLoadedForVenueTypeId != venueTypeId) {
      _payoffLoadedForVenueTypeId = venueTypeId;
      _payoffFuture = _loadPayoffData(venueTypeId);
    }
    return FutureBuilder<_PayoffData>(
      future: _payoffFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data!;
        final totalTasks = data.tasksBySegment.values.fold(
          0,
          (sum, tasks) => sum + tasks.length,
        );
        if (totalTasks == 0 && data.equipment.isEmpty) {
          return Text(
            "We don't have a pre-built starter set for $_venueType yet — "
            "you can add tasks and equipment yourself once you're in.",
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBanner(
              kind: BannerKind.info,
              child: Text(
                "Here's your compliance, ready to go — $totalTasks tasks "
                'across ${data.tasksBySegment.length} sections'
                '${data.equipment.isNotEmpty ? ' and ${data.equipment.length} equipment types' : ''} '
                'already set up for a $_venueType.',
              ),
            ),
            const SizedBox(height: 16),
            for (final entry in data.tasksBySegment.entries)
              _PayoffSection(
                title: entry.key,
                items: entry.value.map((t) => t.title).toList(),
              ),
            if (data.equipment.isNotEmpty)
              _PayoffSection(
                title: 'Equipment',
                items: data.equipment.map((e) => e.name).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSubscriptionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.info,
          child: Text(
            'One company account, one consolidated bill — priced per '
            'active venue, never per person.',
          ),
        ),
        const SizedBox(height: 16),
        const Text('Choose a starting plan — you can change this any time.'),
        const SizedBox(height: 12),
        _PlanOption(
          value: 'friends',
          groupValue: _planName,
          title: 'Friends — £19/month',
          subtitle: 'For a single small venue',
          onChanged: (v) => setState(() => _planName = v),
        ),
        _PlanOption(
          value: 'standard',
          groupValue: _planName,
          title: 'Standard — £39/month',
          subtitle: 'The right plan for most venues',
          onChanged: (v) => setState(() => _planName = v),
        ),
        _PlanOption(
          value: 'premier',
          groupValue: _planName,
          title: 'Premier — coming soon',
          subtitle: 'Larger or multi-venue groups — pricing not set yet',
          enabled: false,
          onChanged: (v) => setState(() => _planName = v),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.info,
          child: Text(
            "You're starting a 14-day free trial — no card needed today.",
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "We'll ask you to set up payment before your trial ends, from "
          'Settings inside the app. Nothing is charged now — just tell '
          "us how you'd prefer to pay.",
        ),
        const SizedBox(height: 16),
        _PaymentProviderOption(
          value: 'stripe',
          groupValue: _paymentProvider,
          title: 'Card payment (Stripe)',
          subtitle: 'Debit/credit card, billed monthly or annually',
          onChanged: (v) => setState(() => _paymentProvider = v),
        ),
        _PaymentProviderOption(
          value: 'gocardless',
          groupValue: _paymentProvider,
          title: 'Direct Debit (GoCardless)',
          subtitle: 'Bank-to-bank payment, no card required',
          onChanged: (v) => setState(() => _paymentProvider = v),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _paymentProvider = null),
            child: const Text("I'll decide later"),
          ),
        ),
      ],
    );
  }
}

class _PaymentProviderOption extends StatelessWidget {
  const _PaymentProviderOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final String value;
  final String? groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: RadioListTile<String>(
          value: value,
          groupValue: groupValue,
          onChanged: (v) => onChanged(v!),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

class _StructureRow extends StatelessWidget {
  const _StructureRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    this.indent = 0,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final int indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent * 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  sublabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    this.enabled = true,
  });

  final String value;
  final String groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<String> onChanged;
  // Sprint 043 — 'premier' has no price yet, so it's shown (not hidden —
  // people should know it's coming) but not selectable.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: RadioListTile<String>(
          value: value,
          groupValue: groupValue,
          onChanged: enabled ? (v) => onChanged(v!) : null,
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.result});

  final TenantSignupResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.info,
          child: Text(
            'Your company and first venue are set up. Sign in with your '
            'email and the password you just chose.',
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            );
          },
          child: const Text('Go to sign in'),
        ),
      ],
    );
  }
}

// Sprint 044 — a plain data holder, not a model (this is a one-screen
// preview computed from the local library, never persisted or sent
// anywhere).
class _PayoffData {
  const _PayoffData({required this.tasksBySegment, required this.equipment});

  final Map<String, List<TaskTemplate>> tasksBySegment;
  final List<EquipmentType> equipment;
}

// Capped display (2026-09-21) — a real venue type can tag 20-40+ tasks;
// showing every single one mid-wizard would turn the "aha moment" into a
// wall of text. Shows the first few plus a plain count of the rest —
// enough to feel real and specific without demanding to be read in full.
class _PayoffSection extends StatelessWidget {
  const _PayoffSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  static const _previewCount = 5;

  @override
  Widget build(BuildContext context) {
    final shown = items.take(_previewCount).toList();
    final remaining = items.length - shown.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${items.length})',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            for (final item in shown)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            if (remaining > 0)
              Text(
                '+ $remaining more',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
