// Supplier register (Sprint 031). Mirrors TrainingItemType's shape: a fixed
// enum of common UK/HORECA supplier categories plus `other` with free text,
// same pattern as ScheduleFrequency's custom/customFrequencyDetail.
enum SupplierCategory {
  freshProduce,
  meatPoultry,
  dairyEggs,
  frozenGoods,
  dryAmbientGoods,
  drinksBeverages,
  chemicalsCleaningSupplies,
  equipmentMaintenance,
  other,
}

String supplierCategoryLabel(SupplierCategory category) {
  switch (category) {
    case SupplierCategory.freshProduce:
      return 'Fresh Produce';
    case SupplierCategory.meatPoultry:
      return 'Meat & Poultry';
    case SupplierCategory.dairyEggs:
      return 'Dairy & Eggs';
    case SupplierCategory.frozenGoods:
      return 'Frozen Goods';
    case SupplierCategory.dryAmbientGoods:
      return 'Dry & Ambient Goods';
    case SupplierCategory.drinksBeverages:
      return 'Drinks & Beverages';
    case SupplierCategory.chemicalsCleaningSupplies:
      return 'Chemicals & Cleaning Supplies';
    case SupplierCategory.equipmentMaintenance:
      return 'Equipment & Maintenance';
    case SupplierCategory.other:
      return 'Other';
  }
}
