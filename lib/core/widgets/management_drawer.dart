import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigator_key.dart';
import '../../app/theme/app_colors.dart';
import '../../features/export/eho_export_dialog.dart';
import '../../features/help/help_screen.dart';
import '../../features/roster/roster_billing_service.dart'
    show rosterAddonEnabledProvider;
import '../../features/roster/roster_upsell_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/subscription_providers.dart';
import '../navigation/app_menu.dart';

/// The side menu (menu redesign 2026-10-17, founder-approved — see
/// app_menu.dart for what each tier sees and why).
///
///  - Supervisor: one short flat list (their home screen is tiles).
///  - Venue Manager and up: a "Find a screen…" search, then the headings
///    Today / Team / Venue / Reports (+ Company for regional/executive).
///  - Help, Settings and Log out are always at the bottom.
///
/// Navigation goes through this Drawer's own context before it closes;
/// Audit Export uses `rootNavigatorKey` because its dialog outlives the
/// Drawer (the drawer's own context is disposed the moment it closes — a
/// real, previously-hit crash; see navigator_key.dart).
class ManagementDrawer extends ConsumerStatefulWidget {
  const ManagementDrawer({super.key, required this.title, this.onLogout});

  /// The current screen's title — the matching menu item is highlighted.
  final String title;

  /// Only TaskScreen supplies this (its own "you still have tasks"
  /// confirmation). Everywhere else: pop to root, then sign out.
  final VoidCallback? onLogout;

  @override
  ConsumerState<ManagementDrawer> createState() => _ManagementDrawerState();
}

class _ManagementDrawerState extends ConsumerState<ManagementDrawer> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(MenuEntry entry, MenuContext c) {
    switch (entry.action) {
      case MenuActionKind.home:
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
      case MenuActionKind.auditExport:
        Navigator.pop(context);
        showEhoExportDialog(
          rootNavigatorKey.currentContext!,
          ProviderScope.containerOf(
            rootNavigatorKey.currentContext!,
            listen: false,
          ),
        );
      case MenuActionKind.push:
        final locked = entry.rotaAddon && !c.rotaEnabled;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: locked ? (_) => const RosterUpsellScreen() : entry.screen,
          ),
        );
    }
  }

  Widget _tile(MenuEntry entry, MenuContext c, {String? where}) {
    final active = entry.label == widget.title;
    final locked = entry.rotaAddon && !c.rotaEnabled;
    final subtitle = where ?? entry.subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: active ? AppColors.tealTint : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          dense: subtitle == null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            entry.icon,
            color: locked
                ? AppColors.muted
                : active
                ? AppColors.tealInk
                : null,
          ),
          title: Text(
            entry.label,
            style: TextStyle(
              fontSize: 15,
              color: locked
                  ? AppColors.muted
                  : active
                  ? AppColors.tealInk
                  : null,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
          trailing: locked
              ? const Icon(Icons.lock_outline, size: 18, color: AppColors.muted)
              : null,
          onTap: () => _open(entry, c),
        ),
      ),
    );
  }

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 16, 4),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.tealInk,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final tier = user?.roleTier ?? RoleTier.supervisor;
    final c = MenuContext(
      tier: tier,
      rotaEnabled: ref
          .watch(rosterAddonEnabledProvider)
          .maybeWhen(data: (v) => v, orElse: () => false),
      canSeeBilling: ref.watch(billingAccessProvider).value?.allowed ?? false,
      // Per-person "on the rota" switch, set by the manager (2026-10-17).
      onRota: user?.booksShifts ?? false,
    );
    final isManager = c.atLeast(RoleTier.venueManager);
    final sections = isManager ? managerMenu(l10n, c) : const <MenuSection>[];

    final List<Widget> body;
    if (!isManager) {
      body = [for (final e in supervisorMenu(l10n, c)) _tile(e, c)];
    } else if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      final hits = searchableEntries(sections)
          .where(
            (h) =>
                h.$1.label.toLowerCase().contains(q) ||
                (h.$1.subtitle?.toLowerCase().contains(q) ?? false),
          )
          .toList();
      body = hits.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.menuNoMatches,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ),
            ]
          : [for (final h in hits) _tile(h.$1, c, where: h.$2)];
    } else {
      body = [
        for (final s in sections) ...[
          _heading(s.title),
          for (final e in s.entries) _tile(e, c),
        ],
      ];
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.tealTint,
            padding: EdgeInsets.fromLTRB(
              20,
              20 + MediaQuery.of(context).padding.top,
              20,
              isManager ? 12 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? widget.title,
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                if (user != null)
                  Text(
                    user.jobTitle,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                if (isManager) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _search,
                    onChanged: (v) => setState(() => _query = v.trim()),
                    decoration: InputDecoration(
                      hintText: l10n.menuFindScreen,
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...body,
          const Divider(height: 24),
          _tile(
            MenuEntry(
              icon: Icons.help_outline,
              label: l10n.helpTitle,
              builder: (_) => const HelpScreen(),
            ),
            c,
          ),
          _tile(
            MenuEntry(
              icon: Icons.settings_outlined,
              label: l10n.settingsLabel,
              builder: (_) => const SettingsScreen(),
            ),
            c,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.logout),
              title: Text(l10n.logOut, style: const TextStyle(fontSize: 15)),
              onTap: () {
                Navigator.pop(context);
                if (widget.onLogout != null) {
                  widget.onLogout!();
                  return;
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
                ref.read(currentUserProvider.notifier).state = null;
              },
            ),
          ),
          // Clear of the phone's gesture bar and the AI button.
          SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
