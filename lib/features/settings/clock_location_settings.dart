import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/errors/friendly_error.dart';
import '../../core/widgets/section_header.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/site.dart';
import '../../shared/providers/site_providers.dart';
import '../auth/clock_location.dart';

/// Venue Details' "Clock-in location check" block (2026-10-15,
/// founder-approved) — venueManager+ only, backend mode only (the caller
/// gates both). Every value is captured on the spot, never typed: the
/// venue's location from this device, its internet connection from this
/// request. A manager does this once, standing in the venue.
class ClockLocationSettings extends ConsumerStatefulWidget {
  const ClockLocationSettings({
    super.key,
    required this.site,
    required this.onChanged,
  });

  final Site site;
  final Future<void> Function() onChanged;

  @override
  ConsumerState<ClockLocationSettings> createState() =>
      _ClockLocationSettingsState();
}

class _ClockLocationSettingsState extends ConsumerState<ClockLocationSettings> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await action();
      await widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setEnabled(bool enabled) => _run(
    () => ref
        .read(siteRepositoryProvider)
        .setClockLocation(siteId: widget.site.id, enabled: enabled),
  );

  Future<void> _useCurrentLocation() => _run(() async {
    final l10n = AppLocalizations.of(context)!;
    final position = await readClockPosition();
    if (position == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.clockVenueLocationUnavailable)),
      );
      return;
    }
    await ref
        .read(siteRepositoryProvider)
        .setClockLocation(
          siteId: widget.site.id,
          enabled: widget.site.clockLocationCheckEnabled,
          latitude: position.latitude,
          longitude: position.longitude,
        );
  });

  Future<void> _editRadius() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: widget.site.clockRadiusM.toString(),
    );
    final value = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clockRadiusTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.metresLabel,
            helperText: l10n.clockRadiusHelper,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, int.tryParse(controller.text.trim())),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
    // Same bounds as the database check — too tight and indoor GPS drift
    // flags everyone; too wide and it stops meaning "on site".
    if (value == null || value < 25 || value > 2000) return;
    await _run(
      () => ref
          .read(siteRepositoryProvider)
          .setClockLocation(
            siteId: widget.site.id,
            enabled: widget.site.clockLocationCheckEnabled,
            radiusM: value,
          ),
    );
  }

  Future<void> _setNetwork({required bool clear}) => _run(
    () => ref
        .read(siteRepositoryProvider)
        .setClockNetwork(widget.site.id, clear: clear),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final site = widget.site;
    final small = Theme.of(context).textTheme.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.clockLocationSectionTitle),
        const SizedBox(height: 4),
        Text(l10n.clockLocationExplanation, style: small),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.enableClockLocationLabel),
          value: site.clockLocationCheckEnabled,
          onChanged: _busy ? null : _setEnabled,
        ),
        if (site.clockLocationCheckEnabled) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  site.hasClockLocation
                      ? l10n.clockVenueLocationSet
                      : l10n.clockVenueLocationNotSet,
                  style: TextStyle(
                    color: site.hasClockLocation
                        ? AppColors.pass
                        : AppColors.caution,
                  ),
                ),
              ),
              TextButton(
                onPressed: _busy ? null : _useCurrentLocation,
                child: Text(l10n.clockUseCurrentLocationButton),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(l10n.clockRadiusLabel(site.clockRadiusM))),
              TextButton(
                onPressed: _busy ? null : _editRadius,
                child: Text(l10n.changeLabel),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  site.clockNetworkSet
                      ? l10n.clockNetworkSet
                      : l10n.clockNetworkNotSet,
                ),
              ),
              if (site.clockNetworkSet)
                TextButton(
                  onPressed: _busy ? null : () => _setNetwork(clear: true),
                  child: Text(l10n.clearLabel),
                ),
              TextButton(
                onPressed: _busy ? null : () => _setNetwork(clear: false),
                child: Text(l10n.clockUseThisNetworkButton),
              ),
            ],
          ),
          Text(l10n.clockNetworkHint, style: small),
        ],
      ],
    );
  }
}
