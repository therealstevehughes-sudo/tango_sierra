import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/theme/contrast.dart';
import '../../core/config/build_flags.dart';
import '../../core/localization/language_picker.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/branding_config.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_submission_providers.dart' show appDatabaseProvider;
import '../roster/roster_billing_service.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

// Settings shell (Sprint 031, Build Order item 5, Sub-sprint C; Company
// section added for branding, finalized beta build order item 7). Three
// sections: Personal (any user, self-serve), Venue (venueManager tier and
// above — matches the "Settings layer" decision), and Company (executive
// tier only — company brand identity is Organisation-scoped, one shared
// identity for the whole chain, so a single venue manager must not be able
// to override it; a single-venue independent owner is already their own
// executive-tier user, so this doesn't cost them anything). Deliberately
// does NOT duplicate ManagementDrawer's operational tools (Assign Tasks,
// Staff Management, Department/Supplier Management, etc.) — those already
// have one home, reached via Oversight's drawer, per the explicit "one
// path to each tool" instruction from the tier-home-screen build. This
// screen is for preferences/config, not a second way to reach existing
// screens.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final canSeeCompanySettings =
        currentUser != null &&
        roleTierRank(currentUser.roleTier) >= roleTierRank(RoleTier.executive);

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.settingsTitle),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.settingsTitle),
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionHeader(title: l10n.personalSection),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentUser != null)
                    _TemperatureUnitSetting(currentUser: currentUser),
                  const Divider(height: 24),
                  const _LanguageSetting(),
                  const Divider(height: 24),
                  _ComingSoonTile(label: l10n.darkModeLabel),
                ],
              ),
            ),
            if (canSeeCompanySettings) ...[
              const SizedBox(height: 24),
              SectionHeader(title: l10n.companySection),
              _CompanyBrandingSection(currentUser: currentUser),
              const SizedBox(height: 16),
              const _RosterAddonSetting(),
              if (kSeedDemoData) ...[
                const SizedBox(height: 16),
                const _ClearDemoDataSetting(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// Curated preset palette (Sprint 031, finalized beta build order item 7) —
// each colour chosen to keep good contrast with its computed foreground
// (never triggers isLowContrast, see contrast.dart) and to stay visually
// distinct from AppColors.pass/caution/critical, so a brand colour never
// reads as coincidentally similar to a safety colour even though it's
// structurally impossible for it to actually override one. Confirmed
// deliberate choice over an unconstrained colour wheel, per the user's
// explicit instruction: "NOT an unconstrained colour wheel (which lets
// someone pick a colour that makes text unreadable)."
const _presetColorArgbs = <int>[
  0xFF0E6E77,
  0xFF1B4F72,
  0xFF4B3F72,
  0xFF33414D,
  0xFF6B3F5C,
  0xFF2F6B4A,
  0xFF6B4423,
  0xFF2B2B2B,
];

Map<String, int> _presetColors(AppLocalizations l10n) => {
  l10n.presetColorOceanTeal: _presetColorArgbs[0],
  l10n.presetColorNavy: _presetColorArgbs[1],
  l10n.presetColorIndigo: _presetColorArgbs[2],
  l10n.presetColorSlate: _presetColorArgbs[3],
  l10n.presetColorPlum: _presetColorArgbs[4],
  l10n.presetColorForest: _presetColorArgbs[5],
  l10n.presetColorUmber: _presetColorArgbs[6],
  l10n.presetColorCharcoal: _presetColorArgbs[7],
};

class _LanguageSetting extends ConsumerWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language),
      title: Text(l10n.languageSettingTitle),
      subtitle: Text(l10n.languageSettingSubtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showLanguagePicker(context, ref),
    );
  }
}

class _CompanyBrandingSection extends ConsumerStatefulWidget {
  const _CompanyBrandingSection({required this.currentUser});

  final User currentUser;

  @override
  ConsumerState<_CompanyBrandingSection> createState() =>
      _CompanyBrandingSectionState();
}

class _CompanyBrandingSectionState
    extends ConsumerState<_CompanyBrandingSection> {
  final _companyNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _customHexController = TextEditingController();

  int _selectedColorArgb = _presetColorArgbs.first;
  bool _useCustomHex = false;
  BrandingConfig? _loadedConfig;
  bool _loaded = false;
  bool _saving = false;
  String? _logoPath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _customHexController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final orgRepo = ref.read(organisationRepositoryProvider);
    final brandingRepo = ref.read(brandingConfigRepositoryProvider);
    final org = await orgRepo.getDefault();
    final current = await brandingRepo.getCurrent(org.id);

    if (!mounted) return;
    setState(() {
      _loadedConfig = current;
      _loaded = true;
      if (current != null) {
        _companyNameController.text = current.companyName ?? '';
        _contactPhoneController.text = current.contactPhone ?? '';
        _contactEmailController.text = current.contactEmail ?? '';
        _selectedColorArgb = current.primaryColorArgb;
        _useCustomHex = !_presetColorArgbs.contains(
          current.primaryColorArgb,
        );
        if (_useCustomHex) {
          _customHexController.text = _toHex(current.primaryColorArgb);
        }
        _logoPath = current.logoPath;
      }
    });
  }

  // Copies the picked file into this app's own local storage rather than
  // referencing wherever the user originally picked it from (a Downloads
  // folder, a USB drive, a network share) — that source location could be
  // renamed, moved, or disconnected later, which would silently break the
  // logo. Same reasoning as TaskSubmissions.photoPath's design intent.
  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final pickedPath = result?.files.single.path;
    if (pickedPath == null) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final brandingDir = Directory(p.join(docsDir.path, 'branding'));
    if (!await brandingDir.exists()) {
      await brandingDir.create(recursive: true);
    }

    final extension = p.extension(pickedPath);
    final destPath = p.join(
      brandingDir.path,
      'logo_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    await File(pickedPath).copy(destPath);

    if (!mounted) return;
    setState(() => _logoPath = destPath);
  }

  void _removeLogo() {
    setState(() => _logoPath = null);
  }

  String _toHex(int argb) =>
      '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  int? _parseHex(String input) {
    final cleaned = input.trim().replaceFirst('#', '');
    if (cleaned.length != 6) return null;
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    return 0xFF000000 | value;
  }

  Future<void> _save() async {
    final colorArgb = _useCustomHex
        ? _parseHex(_customHexController.text)
        : _selectedColorArgb;
    if (colorArgb == null) return;

    setState(() => _saving = true);

    final orgRepo = ref.read(organisationRepositoryProvider);
    final brandingRepo = ref.read(brandingConfigRepositoryProvider);
    final org = await orgRepo.getDefault();

    await brandingRepo.saveNewVersion(
      configGroupId: _loadedConfig?.configGroupId,
      organisationId: org.id,
      companyName: _companyNameController.text.trim().isEmpty
          ? null
          : _companyNameController.text.trim(),
      primaryColorArgb: colorArgb,
      contactPhone: _contactPhoneController.text.trim().isEmpty
          ? null
          : _contactPhoneController.text.trim(),
      contactEmail: _contactEmailController.text.trim().isEmpty
          ? null
          : _contactEmailController.text.trim(),
      setByUserId: widget.currentUser.id,
      logoPath: _logoPath,
    );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.brandingSavedMessage)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    final presetColors = _presetColors(l10n);
    final customHexArgb = _parseHex(_customHexController.text);
    final customHexInvalid =
        _useCustomHex &&
        _customHexController.text.isNotEmpty &&
        customHexArgb == null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.brandIdentityIntro,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _companyNameController,
            decoration: InputDecoration(labelText: l10n.companyNameLabel),
          ),
          const SizedBox(height: 16),
          Text(l10n.companyLogoLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_logoPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_logoPath!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_outlined),
                ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _pickLogo,
                child: Text(_logoPath == null ? l10n.chooseLogoButton : l10n.changeLogoButton),
              ),
              if (_logoPath != null)
                TextButton(onPressed: _removeLogo, child: Text(l10n.removeTooltip)),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.brandColourLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final entry in presetColors.entries)
                _ColorSwatch(
                  label: entry.key,
                  argb: entry.value,
                  selected: !_useCustomHex && _selectedColorArgb == entry.value,
                  onTap: () => setState(() {
                    _useCustomHex = false;
                    _selectedColorArgb = entry.value;
                  }),
                ),
              _CustomSwatch(
                selected: _useCustomHex,
                previewArgb: customHexArgb,
                onTap: () => setState(() => _useCustomHex = true),
              ),
            ],
          ),
          if (_useCustomHex) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customHexController,
              decoration: InputDecoration(
                labelText: l10n.customHexColourLabel,
                hintText: '#0E6E77',
                errorText: customHexInvalid ? l10n.enterValidHexColourError : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const Divider(height: 24),
          TextField(
            controller: _contactPhoneController,
            decoration: InputDecoration(labelText: l10n.contactPhoneLabel),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactEmailController,
            decoration: InputDecoration(labelText: l10n.contactEmailLabel),
          ),
          const SizedBox(height: 16),
          PrimaryActionButton(
            label: _saving ? l10n.savingEllipsisLabel : l10n.saveBrandingButton,
            onPressed: (_saving || (_useCustomHex && customHexArgb == null))
                ? null
                : _save,
          ),
        ],
      ),
    );
  }
}

// Roster add-on (2026-09-27) — the paid shift-claiming/rota feature, off
// by default. Same shape as _EmployeeGradedBarsSetting above (a single
// per-org boolean flag, executive-only since this affects billing).
class _RosterAddonSetting extends ConsumerStatefulWidget {
  const _RosterAddonSetting();

  @override
  ConsumerState<_RosterAddonSetting> createState() =>
      _RosterAddonSettingState();
}

class _RosterAddonSettingState extends ConsumerState<_RosterAddonSetting> {
  bool _loaded = false;
  bool _enabled = false;
  int? _organisationId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final org = await ref.read(organisationRepositoryProvider).getDefault();
    if (!mounted) return;
    setState(() {
      _organisationId = org.id;
      _enabled = org.rosterAddonEnabled;
      _loaded = true;
    });
  }

  // Real billing (2026-09-27, direct founder request) — a local/demo
  // install has no real billing system at all (matches how Billing itself
  // already hides for local installs elsewhere), so it keeps the old bare
  // toggle. A real backend org routes through roster-addon-billing: turning
  // ON needs an explicit price confirmation first (RosterUpsellScreen is
  // the primary path for that; this switch is a secondary entry point for
  // someone who already knows they want it, so it gets its own inline
  // confirmation rather than a full-screen detour), turning OFF actually
  // cancels the add-on's GoCardless subscription, not just flips a flag.
  Future<void> _toggle(bool value) async {
    final orgId = _organisationId;
    if (orgId == null) return;

    if (!ref.read(backendDataEnabledProvider)) {
      setState(() {
        _enabled = value;
        _saving = true;
      });
      await ref
          .read(organisationRepositoryProvider)
          .setRosterAddonEnabled(orgId, value);
      if (!mounted) return;
      setState(() => _saving = false);
      return;
    }

    if (value) {
      RosterQuote quote;
      try {
        quote = await ref.read(rosterBillingServiceProvider).getQuote();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.couldNotGetPriceError(e.toString()),
            ),
          ),
        );
        return;
      }
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.enableRosterTitle),
            content: Text(l10n.enableRosterConfirmText(quote.formatted)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.confirmButton),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;
    }

    setState(() => _saving = true);
    final error = value
        ? await ref.read(rosterBillingServiceProvider).enable()
        : await ref.read(rosterBillingServiceProvider).disable();
    if (!mounted) return;
    if (error != null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() {
      _enabled = value;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const AppCard(child: Center(child: CircularProgressIndicator()));
    }
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.rosterAddonTitle),
        subtitle: Text(l10n.rosterAddonSubtitle),
        value: _enabled,
        onChanged: _saving ? null : _toggle,
      ),
    );
  }
}

// "Clear Demo Data" (2026-09-28, direct founder request) — only ever
// shown in a demo-seeded build (kSeedDemoData, checked by the call site
// in SettingsScreen.build, not here) and only while still in local mode
// (a device that's already converted to a real backend org has no more
// local demo data left to clear). One irreversible action: wipe every
// seeded staff member, branch, and department, then log out. LoginScreen
// reactively shows its own real empty-state entry point (_FreshInstallEntry
// -> "Get started" -> "Set up my business"/"My team already uses
// VenuRite") the instant the staff list comes back empty — no new landing
// screen needed here, that path already exists for a genuine
// --dart-define=SEED_DEMO_DATA=false install.
class _ClearDemoDataSetting extends ConsumerStatefulWidget {
  const _ClearDemoDataSetting();

  @override
  ConsumerState<_ClearDemoDataSetting> createState() =>
      _ClearDemoDataSettingState();
}

class _ClearDemoDataSettingState
    extends ConsumerState<_ClearDemoDataSetting> {
  bool _clearing = false;

  Future<void> _clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.clearDemoDataTitle),
          content: Text(l10n.clearDemoDataConfirmText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.clearEverythingButton),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    setState(() => _clearing = true);
    await ref.read(appDatabaseProvider).clearDemoData();
    if (!mounted) return;

    ref.invalidate(staffDirectoryProvider);
    // Pop back to root before logging out — same reasoning ManagementDrawer's
    // own logout action documents: without this, a pushed screen (this
    // very Settings screen) would stay mounted underneath while
    // MaterialApp.home reactively swaps to LoginScreen.
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(currentUserProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.clearDemoDataCardTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(l10n.clearDemoDataCardBody),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _clearing ? null : _clear,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            child: _clearing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.clearDemoDataButton),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.label,
    required this.argb,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int argb;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(argb),
            shape: BoxShape.circle,
            border: selected
                ? Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 3,
                  )
                : null,
          ),
          child: selected
              ? Icon(Icons.check, color: readableForegroundOn(Color(argb)))
              : null,
        ),
      ),
    );
  }
}

class _CustomSwatch extends StatelessWidget {
  const _CustomSwatch({
    required this.selected,
    required this.previewArgb,
    required this.onTap,
  });

  final bool selected;
  final int? previewArgb;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.customSwatchTooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: previewArgb == null
                ? Colors.transparent
                : Color(previewArgb!),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).dividerColor,
              width: selected ? 3 : 1,
            ),
          ),
          child: previewArgb == null
              ? const Icon(Icons.edit_outlined, size: 18)
              : null,
        ),
      ),
    );
  }
}

class _TemperatureUnitSetting extends ConsumerWidget {
  const _TemperatureUnitSetting({required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Visual pass follow-up (2026-09-24, app-wide tick-box sweep) — a
    // plain 2-way choice, converted from a dropdown to chips.
    Future<void> select(TemperatureUnit unit) async {
      if (unit == currentUser.preferredTemperatureUnit) return;
      final repo = ref.read(userRepositoryProvider);
      await repo.setPreferredTemperatureUnit(
        userId: currentUser.id,
        unit: unit,
      );
      ref.read(currentUserProvider.notifier).state = currentUser.copyWith(
        preferredTemperatureUnit: unit,
      );
    }

    return Row(
      children: [
        Expanded(child: Text(l10n.temperatureUnitLabel)),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(l10n.celsiusLabel),
              selected:
                  currentUser.preferredTemperatureUnit ==
                  TemperatureUnit.celsius,
              onSelected: (_) => select(TemperatureUnit.celsius),
            ),
            ChoiceChip(
              label: Text(l10n.fahrenheitLabel),
              selected:
                  currentUser.preferredTemperatureUnit ==
                  TemperatureUnit.fahrenheit,
              onSelected: (_) => select(TemperatureUnit.fahrenheit),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComingSoonTile extends StatelessWidget {
  const _ComingSoonTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.comingSoonLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
