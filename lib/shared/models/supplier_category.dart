import '../../l10n/app_localizations.dart';

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

String supplierCategoryLabel(SupplierCategory category, [AppLocalizations? l10n]) {
  if (l10n == null) {
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
  switch (category) {
    case SupplierCategory.freshProduce:
      return l10n.supplierCategoryFreshProduce;
    case SupplierCategory.meatPoultry:
      return l10n.supplierCategoryMeatPoultry;
    case SupplierCategory.dairyEggs:
      return l10n.supplierCategoryDairyEggs;
    case SupplierCategory.frozenGoods:
      return l10n.supplierCategoryFrozenGoods;
    case SupplierCategory.dryAmbientGoods:
      return l10n.supplierCategoryDryAmbientGoods;
    case SupplierCategory.drinksBeverages:
      return l10n.supplierCategoryDrinksBeverages;
    case SupplierCategory.chemicalsCleaningSupplies:
      return l10n.supplierCategoryChemicalsCleaningSupplies;
    case SupplierCategory.equipmentMaintenance:
      return l10n.supplierCategoryEquipmentMaintenance;
    case SupplierCategory.other:
      return l10n.supplierCategoryOther;
  }
}
