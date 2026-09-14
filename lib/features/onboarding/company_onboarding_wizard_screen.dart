import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
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

const _stepCount = 6;
const _stepTitles = [
  'Your account',
  'Company details',
  'Organisation structure',
  'First venue',
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
  String? _venueType;

  // Step 5 — subscription (no pricing hard-coded; a name only, per the
  // agreed "don't hard-code pricing yet" instruction)
  String _planName = 'starter';

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
        return _buildSubscriptionStep();
      case 5:
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
          "Let's set up your account. You'll be the owner of this "
          'company on VenuRite.',
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
        DropdownButtonFormField<String>(
          initialValue: _venueType,
          decoration: const InputDecoration(labelText: 'Venue type (optional)'),
          items: const [
            DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
            DropdownMenuItem(value: 'Bar', child: Text('Bar')),
            DropdownMenuItem(value: 'Cafe', child: Text('Café')),
            DropdownMenuItem(value: 'Hotel', child: Text('Hotel')),
            DropdownMenuItem(
              value: 'Catering',
              child: Text('Catering / central kitchen'),
            ),
          ],
          onChanged: (v) => setState(() => _venueType = v),
        ),
      ],
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
          value: 'starter',
          groupValue: _planName,
          title: 'Starter',
          subtitle: 'For a single venue getting going',
          onChanged: (v) => setState(() => _planName = v),
        ),
        _PlanOption(
          value: 'growth',
          groupValue: _planName,
          title: 'Growth',
          subtitle: 'For a handful of venues, with room to add more',
          onChanged: (v) => setState(() => _planName = v),
        ),
        _PlanOption(
          value: 'enterprise',
          groupValue: _planName,
          title: 'Enterprise',
          subtitle: 'Large or multi-country groups — negotiated pricing',
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
          "We'll ask you to add a payment method before your trial ends, "
          'from Settings inside the app. Nothing is charged now.',
        ),
      ],
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
  });

  final String value;
  final String groupValue;
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
