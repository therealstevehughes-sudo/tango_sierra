// Menu item / dish (Phase 2, allergen module, 2026-09-30). Draft/approved
// shape (not append-only like TrainingRecord, not soft-delete like
// Supplier/Department) - a dish is drafted with its ingredients, then a
// senior chef/supervisor+ approves it, which is the moment its allergen
// tags actually get published for staff/customers to see. Editing an
// approved item's ingredients drops it back to draft until re-approved -
// see MenuItemRepository.updateIngredients' own doc comment.
enum MenuItemStatus { draft, approved }

MenuItemStatus menuItemStatusFromString(String value) {
  switch (value) {
    case 'draft':
      return MenuItemStatus.draft;
    case 'approved':
      return MenuItemStatus.approved;
    default:
      throw ArgumentError('Unknown menu item status: $value');
  }
}

String menuItemStatusToString(MenuItemStatus status) {
  switch (status) {
    case MenuItemStatus.draft:
      return 'draft';
    case MenuItemStatus.approved:
      return 'approved';
  }
}

class MenuItem {
  final int? id;
  final int siteId;
  final String name;
  final String? category;
  final MenuItemStatus status;
  final int createdByUserId;
  final DateTime createdAt;
  final int? approvedByUserId;
  final DateTime? approvedAt;

  const MenuItem({
    required this.id,
    required this.siteId,
    required this.name,
    this.category,
    required this.status,
    required this.createdByUserId,
    required this.createdAt,
    this.approvedByUserId,
    this.approvedAt,
  });
}
