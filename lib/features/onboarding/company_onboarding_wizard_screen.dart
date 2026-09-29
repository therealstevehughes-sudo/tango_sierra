import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/data/countries.dart';
import '../../core/data/terms_of_service_content.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/subscription.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/subscription_providers.dart';
import '../../shared/providers/task_submission_providers.dart'
    show appDatabaseProvider;
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../shared/repositories/venue_type_repository.dart';
import '../auth/senior_login_screen.dart';
import '../home/tier_home_screen.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

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
List<String> _stepTitles(AppLocalizations l10n) => [
  l10n.stepYourAccount,
  l10n.stepCompanyDetails,
  l10n.stepOrgStructure,
  l10n.stepFirstVenue,
  l10n.stepStarterSetup,
  l10n.stepSubscription,
  l10n.stepPayment,
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

  // Terms of Service acceptance (2026-09-27) — required before the account
  // can be created at all; the server rejects signup outright without it
  // (fail-closed), this is just the honest UI-side gate on top.
  bool _termsAccepted = false;

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
      case 6:
        return _termsAccepted;
      default:
        return true;
    }
  }

  void _showTermsOfService() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.termsOfServiceTitle),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Text(kTermsOfServiceText),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.closeLabel),
            ),
          ],
        );
      },
    );
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
            termsAccepted: _termsAccepted,
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
    } catch (e) {
      // Fixed (2026-09-25, direct user report: "the set-up wizard keeps
      // cycling to nothing") — any error other than TenantSignupException
      // (a network timeout, an unexpected server response, anything
      // thrown by _activateBackendSession/_startDirectDebitAfterSignup)
      // used to propagate uncaught, leaving _submitting stuck true
      // forever - the button just spins with no way forward and no
      // visible reason why. Same "never leave the user stuck" principle
      // as everywhere else in this app.
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.companySignupGenericError;
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
          .signInWithPassword(
            email: _email.text.trim(),
            password: _password.text,
          );
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
        _directDebitError = AppLocalizations.of(context)!.directDebitStartError;
        _startingDirectDebit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_done != null) {
      return Scaffold(
        appBar: AppScreenHeader(
          title: Text(l10n.companyCreatedTitle),
          actions: const [AssistantIconButton()],
        ),
        body: SafeArea(
          // Layout fix (2026-09-25, direct user report - overflow on this
          // screen): unlike every other wizard step (see the shared
          // Expanded(child: SingleChildScrollView(...)) shell above), this
          // one-off success/invite-team screen was never made scrollable -
          // fine while the invited-staff list is empty, but it grows with
          // every "Add team member" tap and the fixed-height Scaffold body
          // can't absorb that.
          child: SingleChildScrollView(
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
        ),
      );
    }

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(
          l10n.wizardStepOfLabel(
            _stepTitles(l10n)[currentStep],
            currentStep + 1,
            _stepCount,
          ),
        ),
        actions: const [AssistantIconButton()],
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
                        child: Text(l10n.back),
                      )
                    else
                      const SizedBox.shrink(),
                    PrimaryActionButton(
                      label: _submitting
                          ? l10n.creatingEllipsis
                          : currentStep < _stepCount - 1
                          ? l10n.continueButton
                          : l10n.startFreeTrialButton,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.adminAccountIntro),
        const SizedBox(height: 16),
        TextField(
          controller: _firstName,
          decoration: InputDecoration(labelText: l10n.firstNameLabel),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _lastName,
          decoration: InputDecoration(labelText: l10n.lastNameLabel),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          decoration: InputDecoration(labelText: l10n.emailLabel),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            helperText: l10n.passwordMinCharsHelper,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCompanyDetailsStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.companyDetailsIntro),
        const SizedBox(height: 16),
        TextField(
          controller: _companyName,
          decoration: InputDecoration(
            labelText: l10n.tradingCompanyNameLabel,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _legalName,
          decoration: InputDecoration(
            labelText: l10n.legalCompanyNameLabel,
            helperText: l10n.legalCompanyNameHelper,
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
              decoration: InputDecoration(labelText: l10n.countryLabel),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _registeredAddress,
          decoration: InputDecoration(
            labelText: l10n.registeredAddressLabel,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _vatNumber,
          decoration: InputDecoration(
            labelText: l10n.vatNumberLabel,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _billingEmail,
          decoration: InputDecoration(
            labelText: l10n.billingContactEmailLabel,
            helperText: l10n.billingContactEmailHelper(
              _email.text.trim().isEmpty ? l10n.emailLabel : _email.text.trim(),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildStructureStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.structureIntro),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StructureRow(
                icon: Icons.apartment,
                label: l10n.structureYourCompanyLabel,
                sublabel: l10n.structureYourCompanySublabel,
              ),
              _StructureRow(
                icon: Icons.map_outlined,
                label: l10n.structureRegionsLabel,
                sublabel: l10n.structureRegionsSublabel,
                indent: 1,
              ),
              _StructureRow(
                icon: Icons.storefront_outlined,
                label: l10n.structureVenuesLabel,
                sublabel: l10n.structureVenuesSublabel,
                indent: 2,
              ),
              _StructureRow(
                icon: Icons.people_outline,
                label: l10n.structureStaffLabel,
                sublabel: l10n.structureStaffSublabel,
                indent: 3,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.structureOutro),
      ],
    );
  }

  Widget _buildVenueStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WizardHeroBanner(
          image: 'assets/images/kitchen.png',
          title: l10n.wizardFirstVenueHeroTitle,
        ),
        const SizedBox(height: 16),
        Text(l10n.addMoreVenuesLaterText),
        const SizedBox(height: 16),
        TextField(
          controller: _venueName,
          decoration: InputDecoration(labelText: l10n.venueNameLabel),
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _venueAddress,
          decoration: InputDecoration(labelText: l10n.addressOptionalLabel),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _venueRegion,
          decoration: InputDecoration(
            labelText: l10n.regionAreaOptionalLabel,
            helperText: l10n.regionAreaHelper,
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _venueTypeId,
          decoration: InputDecoration(
            labelText: l10n.venueTypeOptionalLabel,
            helperText: l10n.venueTypeHelper,
          ),
          items: _venueTypes
              .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
              .toList(),
          onChanged: (v) => setState(() {
            _venueTypeId = v;
            _venueType = _venueTypes.firstWhere((t) => t.id == v).name;
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
    final l10n = AppLocalizations.of(context)!;
    final venueTypeId = _venueTypeId;
    if (venueTypeId == null) {
      return Text(l10n.payoffSkippedText);
    }
    if (_payoffLoadedForVenueTypeId != venueTypeId) {
      _payoffLoadedForVenueTypeId = venueTypeId;
      _payoffFuture = _loadPayoffData(venueTypeId);
    }
    return FutureBuilder<_PayoffData>(
      future: _payoffFuture,
      builder: (context, snapshot) {
        // Same fix as _submit()'s new catch-all — a FutureBuilder that only
        // checks hasData spins forever if the future ever completes with
        // an error instead of a value, with no way forward and no visible
        // reason why.
        if (snapshot.hasError) {
          return Text(l10n.payoffErrorText);
        }
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
          return Text(l10n.payoffNoStarterSet(_venueType ?? ''));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WizardHeroBanner(
              image: 'assets/images/front_of_house.png',
              title: l10n.payoffHeroTitle,
            ),
            const SizedBox(height: 16),
            AppBanner(
              kind: BannerKind.info,
              child: Text(
                data.equipment.isNotEmpty
                    ? l10n.payoffSummaryWithEquipment(
                        totalTasks,
                        data.tasksBySegment.length,
                        data.equipment.length,
                        _venueType ?? '',
                      )
                    : l10n.payoffSummaryNoEquipment(
                        totalTasks,
                        data.tasksBySegment.length,
                        _venueType ?? '',
                      ),
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
                title: l10n.equipmentSectionLabel,
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
    final l10n = AppLocalizations.of(context)!;
    final headOfficeIncluded = _branchCount >= _headOfficeThreshold;
    final billedUnits = _branchCount + (headOfficeIncluded ? 1 : 0);
    // Pressure-test audit fix (2026-09-22) — this used to restate the
    // £39/branch figure as a bare literal, a second hand-written copy of
    // the same constant `totalMonthlyPricePence` already owns (and which
    // gocardless-confirm-mandate actually charges). No discount code
    // exists yet at this step (never entered at sign-up), so this is
    // always the undiscounted rate.
    final totalPoundsPerMonth = (totalMonthlyPricePence(billedUnits) / 100)
        .toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: BannerKind.info,
          child: Text(l10n.subscriptionBannerText),
        ),
        const SizedBox(height: 16),
        Text(l10n.subscriptionIntroText),
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
                l10n.perBranchPriceLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (headOfficeIncluded) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.headOfficeIncludedLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const Divider(height: 24),
              Text(
                l10n.totalPerMonthLabel(totalPoundsPerMonth, billedUnits),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.discountCodeHint,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: BannerKind.info,
          child: Text(l10n.trialBannerText),
        ),
        const SizedBox(height: 16),
        Text(l10n.paymentStepIntro),
        const SizedBox(height: 16),
        // Migrated off RadioListTile's own deprecated groupValue/onChanged
        // (2026-09-25) to a RadioGroup ancestor, per Flutter's own
        // deprecation guidance.
        RadioGroup<String>(
          groupValue: _paymentProvider,
          onChanged: (v) => setState(() => _paymentProvider = v),
          child: Column(
            children: [
              _PaymentProviderOption(
                value: 'stripe',
                title: l10n.cardPaymentTitle,
                subtitle: l10n.cardPaymentSubtitle,
              ),
              _PaymentProviderOption(
                value: 'gocardless',
                title: l10n.directDebitTitle,
                subtitle: l10n.directDebitSubtitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            // Fixed (2026-09-25, direct user report): this used to just
            // clear the selection with setState — when nothing was picked
            // yet (the common case reaching this button), that produces
            // zero visible change, reading as "doesn't click to anything."
            // A SnackBar confirmation makes every tap visibly register,
            // not just the ones that happen to deselect something.
            onPressed: () {
              setState(() => _paymentProvider = null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.decideLaterSnackbar)),
              );
            },
            child: Text(l10n.decideLaterButton),
          ),
        ),
        const Divider(height: 32),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _termsAccepted,
          onChanged: (v) => setState(() => _termsAccepted = v ?? false),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.agreeToTermsPrefix),
              GestureDetector(
                onTap: _showTermsOfService,
                child: Text(
                  l10n.termsOfServiceTitle,
                  style: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Migrated off RadioListTile's own deprecated groupValue/onChanged
// (2026-09-25) — both are now owned by the RadioGroup ancestor its two call
// sites are wrapped in, per Flutter's own deprecation guidance.
class _PaymentProviderOption extends StatelessWidget {
  const _PaymentProviderOption({
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final String value;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: RadioListTile<String>(
          value: value,
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
                Text(sublabel, style: Theme.of(context).textTheme.bodySmall),
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
    final accessToken =
        gotrue.Supabase.instance.client.auth.currentSession?.accessToken;
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
    final l10n = AppLocalizations.of(context)!;
    final activated = widget.activeSiteId != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: BannerKind.info,
          child: Text(
            activated
                ? l10n.successActivatedBanner
                : l10n.successNotActivatedBanner,
          ),
        ),
        // Sprint 045 — only shown when 'gocardless' was actually chosen
        // as the payment preference; 'stripe'/"decide later" show nothing
        // extra here, same as before this sprint.
        if (widget.paymentProvider == 'gocardless') ...[
          const SizedBox(height: 16),
          if (widget.startingDirectDebit)
            AppBanner(
              kind: BannerKind.info,
              child: Text(l10n.directDebitSettingUp),
            )
          else if (widget.directDebitRedirectUrl != null)
            AppBanner(
              kind: BannerKind.info,
              child: Text(l10n.directDebitOpenedBrowser),
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
            l10n.inviteYourTeamTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(l10n.inviteYourTeamSubtitle),
          const SizedBox(height: 12),
          for (final person in _invited)
            AppCard(
              child: ListTile(
                title: Text(person.name),
                subtitle: Text(l10n.staffPinLabel(person.pin)),
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
                  decoration: InputDecoration(labelText: l10n.nameAxisLabel),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _staffJobTitle,
                  decoration: InputDecoration(labelText: l10n.jobTitleLabel),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                // Pressure-test audit fix (2026-09-22) — this used to
                // hand-type 'base'/'Team Member' etc., a second copy of the
                // labels roleTierDisplayName() already owns (same
                // hardcoded-list pattern that caused the venue-type
                // dropdown bug). Only the first 3 of 5 tiers are offered —
                // someone provisioning staff from their own fresh sign-up
                // can't hand out regional/executive access at this step.
                DropdownButtonFormField<String>(
                  initialValue: _staffRoleTier,
                  decoration: InputDecoration(labelText: l10n.tierFieldLabel),
                  items:
                      [
                            RoleTier.base,
                            RoleTier.supervisor,
                            RoleTier.venueManager,
                          ]
                          .map(
                            (tier) => DropdownMenuItem(
                              value: tier.name,
                              child: Text(roleTierDisplayName(tier, l10n)),
                            ),
                          )
                          .toList(),
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
                      : Text(l10n.addTeamMemberButton),
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
                    MaterialPageRoute(
                      builder: (_) => const SeniorLoginScreen(),
                    ),
                  );
                },
          child: Text(activated ? l10n.goToDashboardButton : l10n.goToSignInButton),
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
