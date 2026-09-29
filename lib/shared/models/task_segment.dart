import '../../l10n/app_localizations.dart';

// Friendly labels for TaskTemplate.segment (2026-09-24, visual pass
// follow-up) -- the stored slug (e.g. 'food_safety') never changes, only
// what's rendered wherever a segment groups a list of tasks for a human
// to read. Every one of the 24 segment slugs seeded across Clusters A-G
// is listed here so a new one added later doesn't silently fall through
// to the raw slug.
String segmentDisplayName(String segment, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (segment) {
      case 'food_safety':
        return 'Food Safety & Temperature Control';
      case 'allergen':
        return 'Allergen Management';
      case 'personal_hygiene_ppe':
        return 'Personal Hygiene & PPE';
      case 'refrigeration_cold_storage':
        return 'Refrigeration & Cold Storage';
      case 'cooking_line_equipment':
        return 'Cooking Line Equipment';
      case 'washup_dishwash':
        return 'Wash-up / Dishwash';
      case 'cleaning_sanitation':
        return 'Cleaning & Sanitation';
      case 'cleaning_chemicals':
        return 'Cleaning Chemicals & Consumables';
      case 'dry_ambient_storage':
        return 'Dry & Ambient Storage';
      case 'deliveries_goods_in':
        return 'Deliveries & Goods In';
      case 'utilities_safety':
        return 'Utilities & Safety';
      case 'waste_pest_control':
        return 'Waste & Pest Control';
      case 'preventive_maintenance':
        return 'Preventive Maintenance (Kitchen Equipment)';
      case 'stock_control':
        return 'Stock Control';
      case 'opening_procedures':
        return 'Opening Procedures';
      case 'closing_procedures':
        return 'Closing Procedures';
      case 'service_readiness':
        return 'Service Readiness';
      case 'front_of_house':
        return 'Front of House / Service';
      case 'bar_beverage':
        return 'Bar & Beverage';
      case 'hotel_specific':
        return 'Hotel-Specific';
      case 'management_compliance_oversight':
        return 'Management & Compliance Oversight';
      case 'maintenance':
        return 'Maintenance';
      case 'housekeeping':
        return 'Housekeeping';
      case 'reception':
        return 'Reception';
      case 'security':
        return 'Security';
      default:
        return segment;
    }
  }
  switch (segment) {
    case 'food_safety':
      return l10n.segmentFoodSafety;
    case 'allergen':
      return l10n.segmentAllergen;
    case 'personal_hygiene_ppe':
      return l10n.segmentPersonalHygienePpe;
    case 'refrigeration_cold_storage':
      return l10n.segmentRefrigerationColdStorage;
    case 'cooking_line_equipment':
      return l10n.segmentCookingLineEquipment;
    case 'washup_dishwash':
      return l10n.segmentWashupDishwash;
    case 'cleaning_sanitation':
      return l10n.segmentCleaningSanitation;
    case 'cleaning_chemicals':
      return l10n.segmentCleaningChemicals;
    case 'dry_ambient_storage':
      return l10n.segmentDryAmbientStorage;
    case 'deliveries_goods_in':
      return l10n.segmentDeliveriesGoodsIn;
    case 'utilities_safety':
      return l10n.segmentUtilitiesSafety;
    case 'waste_pest_control':
      return l10n.segmentWastePestControl;
    case 'preventive_maintenance':
      return l10n.segmentPreventiveMaintenance;
    case 'stock_control':
      return l10n.segmentStockControl;
    case 'opening_procedures':
      return l10n.segmentOpeningProcedures;
    case 'closing_procedures':
      return l10n.segmentClosingProcedures;
    case 'service_readiness':
      return l10n.segmentServiceReadiness;
    case 'front_of_house':
      return l10n.segmentFrontOfHouse;
    case 'bar_beverage':
      return l10n.segmentBarBeverage;
    case 'hotel_specific':
      return l10n.segmentHotelSpecific;
    case 'management_compliance_oversight':
      return l10n.segmentManagementComplianceOversight;
    case 'maintenance':
      return l10n.segmentMaintenance;
    case 'housekeeping':
      return l10n.segmentHousekeeping;
    case 'reception':
      return l10n.segmentReception;
    case 'security':
      return l10n.segmentSecurity;
    default:
      return segment;
  }
}

/// Every seeded segment slug (2026-09-24) — used to populate a department/
/// section picker for a venue's own custom tasks, so a custom task files
/// under a real department (e.g. 'maintenance') instead of a hidden,
/// separate 'custom' bucket. Order matches `segmentDisplayName`'s own case
/// order, which already reads as a sensible grouping (food-safety-adjacent
/// first, front-of-house/hotel/management last).
const List<String> allTaskSegments = [
  'food_safety',
  'allergen',
  'personal_hygiene_ppe',
  'refrigeration_cold_storage',
  'cooking_line_equipment',
  'washup_dishwash',
  'cleaning_sanitation',
  'cleaning_chemicals',
  'dry_ambient_storage',
  'deliveries_goods_in',
  'utilities_safety',
  'waste_pest_control',
  'preventive_maintenance',
  'stock_control',
  'opening_procedures',
  'closing_procedures',
  'service_readiness',
  'front_of_house',
  'bar_beverage',
  'hotel_specific',
  'management_compliance_oversight',
  'maintenance',
  'housekeeping',
  'reception',
  'security',
];
