import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/menu_item_providers.dart';
import 'menu_item_detail_screen.dart';

// Menu management (Phase 2, allergen module, 2026-09-30) — the entry
// point for the Natasha's Law allergen matrix: list every dish at this
// site, its approval status, and a way to add a new one. Any
// site-accessible staff member can reach this and draft a dish; the
// supervisor+ approval gate lives one screen deeper, in
// MenuItemDetailScreen, since approving requires reviewing the specific
// dish's ingredients/tags, not something done from a bare list row.
class MenuManagementScreen extends ConsumerStatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  ConsumerState<MenuManagementScreen> createState() =>
      _MenuManagementScreenState();
}

class _MenuManagementScreenState extends ConsumerState<MenuManagementScreen> {
  Future<void> _addDish(int siteId, int createdByUserId) async {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addDishTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.dishNameLabel),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: l10n.dishCategoryLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );

    final name = nameController.text.trim();
    if (confirmed != true || name.isEmpty) return;

    final item = await ref.read(menuItemRepositoryProvider).create(
      siteId: siteId,
      name: name,
      category: categoryController.text.trim().isEmpty
          ? null
          : categoryController.text.trim(),
      createdByUserId: createdByUserId,
    );
    if (!mounted) return;
    ref.invalidate(menuItemsForSiteProvider(siteId));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MenuItemDetailScreen(menuItem: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final siteId = currentUser?.siteId;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.menuManagementTitle),
        actions: const [AssistantIconButton()],
      ),
      body: siteId == null
          ? Center(child: Text(l10n.noSignedInUserError))
          : SafeArea(
              child: ResponsiveContent(
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncItems = ref.watch(
                      menuItemsForSiteProvider(siteId),
                    );
                    return asyncItems.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => LoadErrorView(
                        error: error.toString(),
                        onRetry: () =>
                            ref.invalidate(menuItemsForSiteProvider(siteId)),
                      ),
                      data: (items) => items.isEmpty
                          ? Center(child: Text(l10n.noDishesYetText))
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                for (final item in items)
                                  Card(
                                    child: ListTile(
                                      title: Text(item.name),
                                      subtitle: item.category == null
                                          ? null
                                          : Text(item.category!),
                                      trailing: StatusBadge(
                                        kind: item.status ==
                                                MenuItemStatus.approved
                                            ? StatusKind.pass
                                            : StatusKind.caution,
                                        label: item.status ==
                                                MenuItemStatus.approved
                                            ? l10n.approvedLabel
                                            : l10n.draftLabel,
                                      ),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              MenuItemDetailScreen(
                                                menuItem: item,
                                              ),
                                        ),
                                      ).then((_) => ref.invalidate(
                                            menuItemsForSiteProvider(siteId),
                                          )),
                                    ),
                                  ),
                              ],
                            ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: siteId == null || currentUser == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _addDish(siteId, currentUser.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.addDishButton),
            ),
    );
  }
}
