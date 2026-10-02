import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/allergen.dart';
import '../../shared/models/allergen_ingredient_suggestions.dart';
import '../../shared/models/ingredient.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/models/menu_item_allergen_tag.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/menu_item_providers.dart';

// Dish detail + approval (Phase 2, allergen module, 2026-09-30) — the
// actual Natasha's Law workflow: draft the ingredient list (anyone at the
// site), review the system-suggested allergens, then a supervisor+
// approves, which is the moment the tags actually publish (see
// MenuItemRepository.approve's own doc comment on why this is a
// deliberate, reviewed freeze rather than a live derivation).
class MenuItemDetailScreen extends ConsumerStatefulWidget {
  const MenuItemDetailScreen({super.key, required this.menuItem});

  final MenuItem menuItem;

  @override
  ConsumerState<MenuItemDetailScreen> createState() =>
      _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends ConsumerState<MenuItemDetailScreen> {
  bool _loading = true;
  String? _error;
  List<Ingredient> _ingredients = [];
  List<MenuItemAllergenTag> _approvedTags = [];
  MenuItem? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.menuItem;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(menuItemRepositoryProvider);
      final ingredients = await repo.getIngredients(widget.menuItem.id!);
      final tags = _current?.status == MenuItemStatus.approved
          ? await repo.getAllergenTags(widget.menuItem.id!)
          : <MenuItemAllergenTag>[];
      if (!mounted) return;
      setState(() {
        _ingredients = ingredients;
        _approvedTags = tags;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addIngredient() async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addIngredientTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.ingredientNameLabel),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.addButton),
          ),
        ],
      ),
    );
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.siteId == null) return;
    final ingredient = await ref
        .read(ingredientRepositoryProvider)
        .findOrCreate(siteId: currentUser!.siteId!, name: trimmed);

    final updatedIds = [..._ingredients.map((i) => i.id!), ingredient.id!];
    await ref
        .read(menuItemRepositoryProvider)
        .setIngredients(widget.menuItem.id!, updatedIds);
    if (!mounted) return;
    setState(() {
      _current = MenuItem(
        id: _current!.id,
        siteId: _current!.siteId,
        name: _current!.name,
        category: _current!.category,
        status: MenuItemStatus.draft,
        createdByUserId: _current!.createdByUserId,
        createdAt: _current!.createdAt,
      );
    });
    await _load();
  }

  Future<void> _removeIngredient(Ingredient ingredient) async {
    final updatedIds = _ingredients
        .where((i) => i.id != ingredient.id)
        .map((i) => i.id!)
        .toList();
    await ref
        .read(menuItemRepositoryProvider)
        .setIngredients(widget.menuItem.id!, updatedIds);
    await _load();
  }

  Future<void> _reviewAndApprove(User currentUser) async {
    final suggested = suggestedTagsFromIngredients(
      menuItemId: widget.menuItem.id!,
      ingredients: _ingredients,
    );
    // Start from the suggested "contains" set, then overlay whatever was
    // manually chosen before (a chef's earlier override, or a "may
    // contain" cross-contamination note that no ingredient list could
    // ever derive on its own) — see suggestedTagsFromIngredients' own
    // doc comment on why "may contain" is never ingredient-suggested.
    final byAllergen = <Allergen, AllergenTagStatus>{
      for (final tag in suggested) tag.allergen: tag.status,
      for (final tag in _approvedTags) tag.allergen: tag.status,
    };

    final result = await showDialog<Map<Allergen, AllergenTagStatus?>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.reviewAllergensTitle),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final allergen in Allergen.values)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(allergenDisplayName(allergen, l10n)),
                        trailing: DropdownButton<AllergenTagStatus?>(
                          value: byAllergen[allergen],
                          hint: Text(l10n.allergenStatusNone),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(l10n.allergenStatusNone),
                            ),
                            for (final status in AllergenTagStatus.values)
                              DropdownMenuItem(
                                value: status,
                                child: Text(
                                  allergenTagStatusLabel(status, l10n),
                                ),
                              ),
                          ],
                          onChanged: (value) => setDialogState(() {
                            if (value == null) {
                              byAllergen.remove(allergen);
                            } else {
                              byAllergen[allergen] = value;
                            }
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, byAllergen),
                child: Text(l10n.approveButton),
              ),
            ],
          );
        },
      ),
    );

    if (result == null) return;

    await ref.read(menuItemRepositoryProvider).approve(
      menuItemId: widget.menuItem.id!,
      approvedByUserId: currentUser.id,
      tags: [
        for (final entry in result.entries)
          MenuItemAllergenTag(
            id: null,
            menuItemId: widget.menuItem.id!,
            allergen: entry.key,
            status: entry.value!,
          ),
      ],
    );
    if (!mounted) return;
    setState(() {
      _current = MenuItem(
        id: _current!.id,
        siteId: _current!.siteId,
        name: _current!.name,
        category: _current!.category,
        status: MenuItemStatus.approved,
        createdByUserId: _current!.createdByUserId,
        createdAt: _current!.createdAt,
        approvedByUserId: currentUser.id,
        approvedAt: DateTime.now(),
      );
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final canApprove =
        currentUser != null &&
        roleTierRank(currentUser.roleTier) >= roleTierRank(RoleTier.supervisor);
    final item = _current ?? widget.menuItem;
    final suggested = suggestedTagsFromIngredients(
      menuItemId: item.id!,
      ingredients: _ingredients,
    );

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(item.name),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? LoadErrorView(error: _error!, onRetry: _load)
          : SafeArea(
              child: ResponsiveContent(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    StatusBadge(
                      kind: item.status == MenuItemStatus.approved
                          ? StatusKind.pass
                          : StatusKind.caution,
                      label: item.status == MenuItemStatus.approved
                          ? l10n.approvedLabel
                          : l10n.draftLabel,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.ingredientsHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final ingredient in _ingredients)
                          Chip(
                            label: Text(ingredient.name),
                            onDeleted: () => _removeIngredient(ingredient),
                          ),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 18),
                          label: Text(l10n.addIngredientButton),
                          onPressed: _addIngredient,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      item.status == MenuItemStatus.approved
                          ? l10n.publishedAllergensHeading
                          : l10n.suggestedAllergensHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: (item.status == MenuItemStatus.approved
                                ? _approvedTags
                                : suggested)
                            .isEmpty
                            ? Text(l10n.noAllergensIdentifiedText)
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final tag
                                      in item.status == MenuItemStatus.approved
                                          ? _approvedTags
                                          : suggested)
                                    Chip(
                                      label: Text(
                                        '${allergenDisplayName(tag.allergen, l10n)} '
                                        '(${allergenTagStatusLabel(tag.status, l10n)})',
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                    if (canApprove) ...[
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _reviewAndApprove(currentUser),
                        icon: const Icon(Icons.verified_outlined),
                        label: Text(
                          item.status == MenuItemStatus.approved
                              ? l10n.reviewAndReapproveButton
                              : l10n.reviewAndApproveButton,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
