import 'supplier_category.dart';

// approved / pending / suspended (Sprint 031) — flagged for manager
// visibility when used on a delivery, never a hard block on submission
// (same "defaults not lockouts" principle used throughout this app — a
// worker can't refuse a delivery already at the door).
enum SupplierApprovalStatus { approved, pending, suspended }

String supplierApprovalStatusLabel(SupplierApprovalStatus status) {
  switch (status) {
    case SupplierApprovalStatus.approved:
      return 'Approved';
    case SupplierApprovalStatus.pending:
      return 'Pending';
    case SupplierApprovalStatus.suspended:
      return 'Suspended';
  }
}

// Supplier register (Sprint 031, finalized beta build order item 4).
// Editable, not append-only — ARCHITECTURE_LOCK.md's Versioning Rule names
// only TaskTemplate/LegalLimitReference/NotificationRule/BrandingConfig as
// append-only; a supplier's contact details/status are live operational
// data, same category as EquipmentInstance (active/inactive flag, no
// version chain).
class Supplier {
  final int? id;
  final String name;
  final String? contact;
  final SupplierCategory category;
  final String? customCategoryTitle;
  final SupplierApprovalStatus approvalStatus;
  final String? approvalNote;
  final int siteId;
  final bool active;
  final DateTime createdAt;

  const Supplier({
    this.id,
    required this.name,
    this.contact,
    required this.category,
    this.customCategoryTitle,
    required this.approvalStatus,
    this.approvalNote,
    required this.siteId,
    this.active = true,
    required this.createdAt,
  });

  String get displayCategory =>
      category == SupplierCategory.other && customCategoryTitle != null
      ? customCategoryTitle!
      : supplierCategoryLabel(category);
}
