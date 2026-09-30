import '../../core/network/backend_rest_client.dart';
import '../models/allergen.dart';
import '../models/ingredient.dart';
import '../models/menu_item.dart';
import '../models/menu_item_allergen_tag.dart';
import 'menu_item_repository.dart';

class SupabaseMenuItemRepository implements MenuItemRepository {
  SupabaseMenuItemRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<MenuItem>> getForSite(int siteId) async {
    final rows = await _client.select(
      'menu_items',
      query: 'site_id=eq.$siteId&order=name.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<MenuItem> create({
    required int siteId,
    required String name,
    String? category,
    required int createdByUserId,
  }) async {
    final row = await _client.insertOne('menu_items', {
      'site_id': siteId,
      'name': name,
      'category': category,
      'status': 'draft',
      'created_by_user_id': createdByUserId,
    });
    return _toModel(row);
  }

  @override
  Future<List<Ingredient>> getIngredients(int menuItemId) async {
    // PostgREST embed through the join table straight to ingredients, one
    // round trip — same pattern getClaimHistoryForUser's shifts(starts_at)
    // embed already uses in shift_repository.dart.
    final rows = await _client.select(
      'menu_item_ingredients',
      query: 'menu_item_id=eq.$menuItemId&select=ingredients(*)',
    );
    return rows
        .map((row) => row['ingredients'] as Map<String, dynamic>)
        .map(_ingredientFromRow)
        .toList();
  }

  @override
  Future<void> setIngredients(int menuItemId, List<int> ingredientIds) async {
    await _client.delete(
      'menu_item_ingredients',
      filter: 'menu_item_id=eq.$menuItemId',
    );
    for (final ingredientId in ingredientIds) {
      await _client.insertOne('menu_item_ingredients', {
        'menu_item_id': menuItemId,
        'ingredient_id': ingredientId,
      });
    }
    // Ingredients changed - drop back to draft (see this method's own doc
    // comment in the interface for why this is unconditional).
    await _client.update(
      'menu_items',
      filter: 'id=eq.$menuItemId',
      body: {'status': 'draft'},
    );
  }

  @override
  Future<List<MenuItemAllergenTag>> getAllergenTags(int menuItemId) async {
    final rows = await _client.select(
      'menu_item_allergen_tags',
      query: 'menu_item_id=eq.$menuItemId',
    );
    return rows.map(_tagFromRow).toList();
  }

  @override
  Future<void> approve({
    required int menuItemId,
    required int approvedByUserId,
    required List<MenuItemAllergenTag> tags,
  }) async {
    await _client.delete(
      'menu_item_allergen_tags',
      filter: 'menu_item_id=eq.$menuItemId',
    );
    for (final tag in tags) {
      await _client.insertOne('menu_item_allergen_tags', {
        'menu_item_id': menuItemId,
        'allergen': tag.allergen.name,
        'status': allergenTagStatusToString(tag.status),
      });
    }
    await _client.update(
      'menu_items',
      filter: 'id=eq.$menuItemId',
      body: {
        'status': 'approved',
        'approved_by_user_id': approvedByUserId,
        'approved_at': DateTime.now().toIso8601String(),
      },
    );
  }

  MenuItem _toModel(Map<String, dynamic> row) => MenuItem(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    name: row['name'] as String,
    category: row['category'] as String?,
    status: menuItemStatusFromString(row['status'] as String),
    createdByUserId: row['created_by_user_id'] as int,
    createdAt: DateTime.parse(row['created_at'] as String),
    approvedByUserId: row['approved_by_user_id'] as int?,
    approvedAt: row['approved_at'] == null
        ? null
        : DateTime.parse(row['approved_at'] as String),
  );

  Ingredient _ingredientFromRow(Map<String, dynamic> row) => Ingredient(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    name: row['name'] as String,
    defaultAllergens: ((row['default_allergens'] as List?) ?? [])
        .map((a) => Allergen.values.byName(a as String))
        .toSet(),
    createdAt: DateTime.parse(row['created_at'] as String),
  );

  MenuItemAllergenTag _tagFromRow(Map<String, dynamic> row) =>
      MenuItemAllergenTag(
        id: row['id'] as int,
        menuItemId: row['menu_item_id'] as int,
        allergen: Allergen.values.byName(row['allergen'] as String),
        status: allergenTagStatusFromString(row['status'] as String),
      );
}
