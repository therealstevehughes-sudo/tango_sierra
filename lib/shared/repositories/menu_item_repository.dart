import '../models/ingredient.dart';
import '../models/menu_item.dart';
import '../models/menu_item_allergen_tag.dart';

abstract class MenuItemRepository {
  Future<List<MenuItem>> getForSite(int siteId);

  Future<MenuItem> create({
    required int siteId,
    required String name,
    String? category,
    required int createdByUserId,
  });

  Future<List<Ingredient>> getIngredients(int menuItemId);

  /// Replaces the full ingredient list for [menuItemId]. Always drops the
  /// item back to [MenuItemStatus.draft] if it was approved — an
  /// ingredient change means the previously-approved allergen tags no
  /// longer reflect what's actually in the dish, so they can't stay live
  /// unreviewed. A manager must re-approve (see [approve]) before the
  /// matrix/EHO export shows this item as current again.
  Future<void> setIngredients(int menuItemId, List<int> ingredientIds);

  Future<List<MenuItemAllergenTag>> getAllergenTags(int menuItemId);

  /// Publishes [tags] as the item's reviewed, live allergen tags and marks
  /// it [MenuItemStatus.approved]. [tags] is whatever the approving
  /// supervisor+ ended up confirming — normally seeded from
  /// suggestedTagsFromIngredients() and then edited in the UI, but this
  /// repository has no opinion on where they came from, only that they're
  /// final.
  Future<void> approve({
    required int menuItemId,
    required int approvedByUserId,
    required List<MenuItemAllergenTag> tags,
  });
}
