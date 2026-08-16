import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/contrast.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/branding_config.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';

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
    final currentUser = ref.watch(currentUserProvider);
    final canSeeVenueSettings =
        currentUser != null &&
        roleTierRank(currentUser.roleTier) >= roleTierRank(RoleTier.venueManager);
    final canSeeCompanySettings =
        currentUser != null &&
        roleTierRank(currentUser.roleTier) >= roleTierRank(RoleTier.executive);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const ManagementDrawer(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Personal'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentUser != null)
                  _TemperatureUnitSetting(currentUser: currentUser),
                const Divider(height: 24),
                const _ComingSoonTile(label: 'Dark Mode'),
                const _ComingSoonTile(label: 'Language'),
              ],
            ),
          ),
          if (canSeeVenueSettings) ...[
            const SizedBox(height: 24),
            const SectionHeader(title: 'Venue'),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_ComingSoonTile(label: 'Login Layout')],
              ),
            ),
          ],
          if (canSeeCompanySettings) ...[
            const SizedBox(height: 24),
            const SectionHeader(title: 'Company'),
            _CompanyBrandingSection(currentUser: currentUser),
          ],
        ],
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
const _presetColors = <String, int>{
  'Ocean Teal': 0xFF0E6E77,
  'Navy': 0xFF1B4F72,
  'Indigo': 0xFF4B3F72,
  'Slate': 0xFF33414D,
  'Plum': 0xFF6B3F5C,
  'Forest': 0xFF2F6B4A,
  'Umber': 0xFF6B4423,
  'Charcoal': 0xFF2B2B2B,
};

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

  int _selectedColorArgb = _presetColors.values.first;
  bool _useCustomHex = false;
  BrandingConfig? _loadedConfig;
  bool _loaded = false;
  bool _saving = false;

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
        _useCustomHex = !_presetColors.values.contains(
          current.primaryColorArgb,
        );
        if (_useCustomHex) {
          _customHexController.text = _toHex(current.primaryColorArgb);
        }
      }
    });
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
    );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Branding saved')),
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

    final customHexArgb = _parseHex(_customHexController.text);
    final customHexInvalid =
        _useCustomHex && _customHexController.text.isNotEmpty && customHexArgb == null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'One brand identity, shared company-wide — applies to every '
            'venue, not per-site.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _companyNameController,
            decoration: const InputDecoration(labelText: 'Company name'),
          ),
          const SizedBox(height: 12),
          Text('Brand colour', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final entry in _presetColors.entries)
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
                labelText: 'Custom hex colour',
                hintText: '#0E6E77',
                errorText: customHexInvalid ? 'Enter a valid hex colour' : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const Divider(height: 24),
          TextField(
            controller: _contactPhoneController,
            decoration: const InputDecoration(labelText: 'Contact phone'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactEmailController,
            decoration: const InputDecoration(labelText: 'Contact email'),
          ),
          const SizedBox(height: 16),
          PrimaryActionButton(
            label: _saving ? 'Saving...' : 'Save Branding',
            onPressed: (_saving || (_useCustomHex && customHexArgb == null))
                ? null
                : _save,
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
                ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
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
      message: 'Custom',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: previewArgb == null ? Colors.transparent : Color(previewArgb!),
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
    return Row(
      children: [
        const Expanded(child: Text('Temperature unit')),
        DropdownButton<TemperatureUnit>(
          value: currentUser.preferredTemperatureUnit,
          items: const [
            DropdownMenuItem(
              value: TemperatureUnit.celsius,
              child: Text('Celsius (°C)'),
            ),
            DropdownMenuItem(
              value: TemperatureUnit.fahrenheit,
              child: Text('Fahrenheit (°F)'),
            ),
          ],
          onChanged: (unit) async {
            if (unit == null || unit == currentUser.preferredTemperatureUnit) {
              return;
            }
            final repo = ref.read(userRepositoryProvider);
            await repo.setPreferredTemperatureUnit(
              userId: currentUser.id,
              unit: unit,
            );
            ref.read(currentUserProvider.notifier).state = currentUser
                .copyWith(preferredTemperatureUnit: unit);
          },
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor),
            ),
          ),
          Text(
            'Coming soon',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
