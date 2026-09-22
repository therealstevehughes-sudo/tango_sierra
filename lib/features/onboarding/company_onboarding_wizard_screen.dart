import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/data/countries.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/subscription_providers.dart';
import '../../shared/providers/task_submission_providers.dart' show appDatabaseProvider;
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../shared/repositories/venue_type_repository.dart';
import '../auth/senior_login_screen.dart';
import '../home/tier_home_screen.dart';

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

  // Sprint 045 — set only when payment_provider == 'gocardless' was
  // chosen; shown on the success screen instead of the plain "sign in"
  // message. null/null/false means "not attempted" (a different payment
  // choice), not "failed".
  bool _startingDirectDebit = false;
  String? _directDebitRedirectUrl;
  String? _directDebitError;

  // Sprint 046 — set once _activateBackendSession succeeds; drives both
  // the "Invite your team" step (needs a real site + access token to
  // call provisionStaffPin) and whether the success screen can offer
  // "Go to dashboard" at all (falls back to "Go to sign in" if this
  // never got set).
  int? _activeSiteId;

  // Step 1 — admin account
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
  // Sprint 043 rework (2026-09-22) — plan_name is no longer user-chosen;
  // always 'standard' now (per-branch pricing replaced the tier picker).
  final String _planName = 'standard';

  // How many branches the customer says they have today (including head
  // office) — drives billed_site_count server-side. 4+ automatically
  // adds one head-office unit; see tenant-signup's own doc comment.
  int _branchCount = 1;
  static const _headOfficeThreshold = 4;

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
            branchCount: _branchCount,
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
      // Sprint 046 (Team Invite + Live Landing, 2026-09-22) — always
      // sign the new Director in and switch this running session into
      // real backend mode, regardless of payment choice. Best-effort:
      // the company/venue/subscription are already real either way, so a
      // failure here just falls back to the old "go to sign in manually"
      // path rather than blocking anything.
      await _activateBackendSession(result);
      // Sprint 045 (Real Activation Inside the Wizard, 2026-09-21) —
      // only when the customer actually chose Direct Debit as their
      // payment preference (never for 'stripe', which isn't built, and
      // never for "I'll decide later" — both correctly still defer to
      // Settings, unchanged).
      if (_paymentProvider == 'gocardless') {
        await _startDirectDebitAfterSignup();
      }
    } on TenantSignupException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  // Sprint 046 — the account was just created but this app has no real
  // session yet (tenant-signup never mints one on purpose — it's an
  // unauthenticated bootstrap call). A plain signInWithPassword using the
  // credentials just typed a few seconds ago is enough (no 2FA check
  // needed — a brand-new account has no factor enrolled yet). Once
  // signed in, flips both backend flags — implements Phase C1's own
  // decision #5 ("real installs = both backend flags forced ON"), which
  // had been approved back then but never actually wired up (both were
  // hardcoded `false` literals until this sprint) — and loads the real
  // profile so `currentUserProvider` reflects who's actually signed in,
  // the same thing every other login path in this app already does.
  Future<void> _activateBackendSession(TenantSignupResult result) async {
    try {
      final response = await gotrue.Supabase.instance.client.auth
          .signInWithPassword(email: _email.text.trim(), password: _password.text);
      if (response.session == null) return;

      ref.read(backendAuthEnabledProvider.notifier).state = true;
      ref.read(backendDataEnabledProvider.notifier).state = true;

      final staff = await ref.read(userRepositoryProvider).getAll();
      final self = staff.where((u) => u.id == result.localUserId).firstOrNull;
      if (self == null) return;
      ref.read(currentUserProvider.notifier).state = self;
      if (!mounted) return;
      setState(() => _activeSiteId = result.siteId);
    } catch (_) {
      // Best-effort — the company/venue are already real regardless.
      // _SuccessView falls back to "Go to sign in" manually if this
      // never set a current user.
    }
  }

  Future<void> _startDirectDebitAfterSignup() async {
    setState(() => _startingDirectDebit = true);
    try {
      final result = await ref
          .read(subscriptionRepositoryProvider)
          .startDirectDebitSetup();
      if (!mounted) return;
      setState(() {
        _directDebitRedirectUrl = result.redirectUrl;
        _startingDirectDebit = false;
      });
      await launchUrl(
        Uri.parse(result.redirectUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _directDebitError =
            "We couldn't start Direct Debit setup automatically - "
            "you can do this any time from Settings once you're signed in.";
        _startingDirectDebit = false;
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
              child: _SuccessView(
                result: _done!,
                activeSiteId: _activeSiteId,
                paymentProvider: _paymentProvider,
                startingDirectDebit: _startingDirectDebit,
                directDebitRedirectUrl: _directDebitRedirectUrl,
                directDebitError: _directDebitError,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_stepTitles[currentStep]} - Step ${currentStep + 1} of $_stepCount',
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
                Expanded(
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.03, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(currentStep),
                        child: _buildStep(),
                      ),
                    ),
                  ),
                ),
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
        Autocomplete<String>(
          initialValue: TextEditingValue(text: _country.text),
          optionsBuilder: (value) {
            if (value.text.isEmpty) return const Iterable<String>.empty();
            final query = value.text.toLowerCase();
            return countryNames.where((c) => c.toLowerCase().contains(query));
          },
          onSelected: (selected) {
            _country.text = selected;
            setState(() {});
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            // Keep _country (the field this screen actually reads from
            // and validates on) in sync with whatever's typed, not just a
            // selected suggestion — picking from the list is the
            // expected path, but free text still works exactly like the
            // plain TextField this replaces.
            controller.addListener(() {
              _country.text = controller.text;
            });
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Country'),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            );
          },
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
          'set anything up now - this is just so the next step makes sense.',
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
                sublabel: 'Group venues by country or area - skip if you '
                    "don't need it",
                indent: 1,
              ),
              _StructureRow(
                icon: Icons.storefront_outlined,
                label: 'Venues',
                sublabel: 'One venue today, hundreds later - add more any '
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
          "We'll set up your first venue next - you can add regions and "
          'more venues later from inside the app.',
        ),
      ],
    );
  }

  Widget _buildVenueStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _WizardHeroBanner(
          image: 'assets/images/kitchen.png',
          title: "Let's add your first venue",
        ),
        const SizedBox(height: 16),
        const Text('You can add more venues later.'),
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
            helperText: 'e.g. "London" - only needed if you have (or will '
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
                'next - for tasks and equipment you already know you need.',
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
        "to show yet - you can add tasks and equipment yourself once "
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
            "We don't have a pre-built starter set for $_venueType yet - "
            "you can add tasks and equipment yourself once you're in.",
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _WizardHeroBanner(
              image: 'assets/images/front_of_house.png',
              title: "Here's your compliance, ready to go",
            ),
            const SizedBox(height: 16),
            AppBanner(
              kind: BannerKind.info,
              child: Text(
                '$totalTasks tasks across ${data.tasksBySegment.length} '
                'sections'
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

  // Sprint 043 rework (2026-09-22, per the user's own agreed pricing) —
  // replaces the old friends/standard/premier plan picker entirely.
  // Pricing is now per branch: £39/branch/month standard, discounted to
  // £19/branch/month only via a real code entered later at Direct Debit
  // setup (never here, never at sign-up) — see gocardless-start-mandate's
  // own doc comment. Only ONE real venue is created in this signup call
  // regardless of the number given here (matches the payoff step above,
  // which is scoped to the one venue being set up right now) — this
  // number exists purely to calculate an honest price up front; the rest
  // get added one at a time later, same as before this pricing model.
  Widget _buildSubscriptionStep() {
    final headOfficeIncluded = _branchCount >= _headOfficeThreshold;
    final billedUnits = _branchCount + (headOfficeIncluded ? 1 : 0);
    final totalPoundsPerMonth = billedUnits * 39;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.info,
          child: Text(
            'One company account, one consolidated bill - priced per '
            'branch, never per person.',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'How many branches do you have today, including head office '
          "if you have one? You'll only set up your first venue now — "
          'add the rest any time from inside the app.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton.outlined(
              onPressed: _branchCount > 1
                  ? () => setState(() => _branchCount -= 1)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            Text(
              '$_branchCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 16),
            IconButton.outlined(
              onPressed: () => setState(() => _branchCount += 1),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '£39/branch/month',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (headOfficeIncluded) ...[
                const SizedBox(height: 4),
                Text(
                  '+ 1 head office branch (4+ branches)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const Divider(height: 24),
              Text(
                '£$totalPoundsPerMonth/month total ($billedUnits '
                'branch${billedUnits == 1 ? '' : 'es'} billed)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Have a discount code? You can enter it when you set up '
                'Direct Debit.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
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
            "You're starting a 14-day free trial - no card needed today.",
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "We'll ask you to set up payment before your trial ends, from "
          'Settings inside the app. Nothing is charged now - just tell '
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


// Sprint 046 (Team Invite + Live Landing, 2026-09-22) — converted from a
// StatelessWidget: now owns the "invite your team" mini-form's own state
// (the wizard screen above it is done, this is a genuinely separate
// step). [activeSiteId] is null only if _activateBackendSession failed —
// falls back to the old manual "Go to sign in" path rather than
// offering a dashboard/invite flow with no real session behind it.
class _SuccessView extends ConsumerStatefulWidget {
  const _SuccessView({
    required this.result,
    required this.activeSiteId,
    this.paymentProvider,
    this.startingDirectDebit = false,
    this.directDebitRedirectUrl,
    this.directDebitError,
  });

  final TenantSignupResult result;
  final int? activeSiteId;
  final String? paymentProvider;
  final bool startingDirectDebit;
  final String? directDebitRedirectUrl;
  final String? directDebitError;

  @override
  ConsumerState<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends ConsumerState<_SuccessView> {
  final _staffName = TextEditingController();
  final _staffJobTitle = TextEditingController();
  String _staffRoleTier = 'base';
  bool _inviting = false;
  String? _inviteError;
  final List<StaffPinProvisionResult> _invited = [];

  @override
  void dispose() {
    _staffName.dispose();
    _staffJobTitle.dispose();
    super.dispose();
  }

  Future<void> _inviteStaff() async {
    final siteId = widget.activeSiteId;
    final name = _staffName.text.trim();
    final jobTitle = _staffJobTitle.text.trim();
    if (siteId == null || name.isEmpty || jobTitle.isEmpty) return;
    final accessToken = gotrue
        .Supabase.instance.client.auth.currentSession?.accessToken;
    if (accessToken == null) return;

    setState(() {
      _inviting = true;
      _inviteError = null;
    });
    try {
      final invited = await ref
          .read(tenantProvisioningRepositoryProvider)
          .provisionStaffPin(
            callerAccessToken: accessToken,
            name: name,
            jobTitle: jobTitle,
            roleTier: _staffRoleTier,
            siteId: siteId,
          );
      if (!mounted) return;
      setState(() {
        _invited.add(invited);
        _staffName.clear();
        _staffJobTitle.clear();
        _inviting = false;
      });
    } on StaffPinProvisionException catch (e) {
      if (!mounted) return;
      setState(() {
        _inviteError = e.message;
        _inviting = false;
      });
    }
  }

  void _goToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TierHomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activated = widget.activeSiteId != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: BannerKind.info,
          child: Text(
            activated
                ? "Your company and first venue are set up, and you're "
                      'signed in.'
                : 'Your company and first venue are set up. Sign in with '
                      'your email and the password you just chose.',
          ),
        ),
        // Sprint 045 — only shown when 'gocardless' was actually chosen
        // as the payment preference; 'stripe'/"decide later" show nothing
        // extra here, same as before this sprint.
        if (widget.paymentProvider == 'gocardless') ...[
          const SizedBox(height: 16),
          if (widget.startingDirectDebit)
            const AppBanner(
              kind: BannerKind.info,
              child: Text('Setting up Direct Debit...'),
            )
          else if (widget.directDebitRedirectUrl != null)
            const AppBanner(
              kind: BannerKind.info,
              child: Text(
                "We've opened your browser to finish setting up Direct "
                'Debit.',
              ),
            )
          else if (widget.directDebitError != null)
            AppBanner(
              kind: BannerKind.caution,
              child: Text(widget.directDebitError!),
            ),
        ],
        if (activated) ...[
          const SizedBox(height: 24),
          Text(
            'Invite your team',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            "Optional — add whoever's on shift now, or skip and do this "
            'later from Staff Management.',
          ),
          const SizedBox(height: 12),
          for (final person in _invited)
            AppCard(
              child: ListTile(
                title: Text(person.name),
                subtitle: Text('PIN: ${person.pin}'),
                dense: true,
              ),
            ),
          if (_invited.isNotEmpty) const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _staffName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _staffJobTitle,
                  decoration: const InputDecoration(labelText: 'Job title'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _staffRoleTier,
                  decoration: const InputDecoration(labelText: 'Tier'),
                  items: const [
                    DropdownMenuItem(value: 'base', child: Text('Team Member')),
                    DropdownMenuItem(
                      value: 'supervisor',
                      child: Text('Supervisor'),
                    ),
                    DropdownMenuItem(
                      value: 'venueManager',
                      child: Text('Manager'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _staffRoleTier = v!),
                ),
                if (_inviteError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _inviteError!,
                    style: const TextStyle(color: AppColors.critical),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _inviting ? null : _inviteStaff,
                  child: _inviting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add team member'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: activated
              ? _goToDashboard
              : () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
                  );
                },
          child: Text(activated ? 'Go to dashboard' : 'Go to sign in'),
        ),
      ],
    );
  }
}

// Visual pass (2026-09-22, "considered lift" onboarding redesign) — a
// small compact hero banner used at the top of a couple of wizard steps
// (first venue, payoff) so the wizard doesn't read as a flat sequence of
// plain forms. Same photo + gradient + Fraunces headline treatment as the
// splash screen and the fresh-install value screen, just shorter.
class _WizardHeroBanner extends StatelessWidget {
  const _WizardHeroBanner({required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.tealInk.withValues(alpha: 0.1),
                    AppColors.tealInk.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
