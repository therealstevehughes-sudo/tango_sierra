// Friendly labels for TaskTemplate.segment (2026-09-24, visual pass
// follow-up) -- the stored slug (e.g. 'food_safety') never changes, only
// what's rendered wherever a segment groups a list of tasks for a human
// to read. Every one of the 24 segment slugs seeded across Clusters A-G
// is listed here so a new one added later doesn't silently fall through
// to the raw slug.
String segmentDisplayName(String segment) {
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
