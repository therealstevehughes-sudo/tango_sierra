import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu_item.dart';
import '../repositories/ingredient_repository.dart';
import '../repositories/menu_item_repository.dart';
import '../repositories/supabase_ingredient_repository.dart';
import '../repositories/supabase_menu_item_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final ingredientRepositoryProvider = Provider<IngredientRepository>(
  (ref) => SupabaseIngredientRepository(ref.watch(backendRestClientProvider)),
);

final menuItemRepositoryProvider = Provider<MenuItemRepository>(
  (ref) => SupabaseMenuItemRepository(ref.watch(backendRestClientProvider)),
);

final menuItemsForSiteProvider = FutureProvider.family<List<MenuItem>, int>(
  (ref, siteId) => ref.watch(menuItemRepositoryProvider).getForSite(siteId),
);
