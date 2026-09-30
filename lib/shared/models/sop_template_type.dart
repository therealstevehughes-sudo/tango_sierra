import '../../l10n/app_localizations.dart';

// SOP/HACCP AI-assisted document generation (Phase 2, 2026-09-30) — a
// fixed starter set of common UK food-safety SOPs, matching
// generate-sop-document's own TEMPLATE_PROMPTS map exactly (the .name
// string is sent as-is to that Edge Function). Fixed list for v1, not a
// free-text prompt — keeps output predictable and reviewable.
enum SopTemplateType {
  cleaningSchedule,
  allergenControl,
  deliveryAndStorage,
  personalHygiene,
  pestControl,
}

String sopTemplateTypeLabel(SopTemplateType type, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (type) {
      case SopTemplateType.cleaningSchedule:
        return 'Cleaning Schedule';
      case SopTemplateType.allergenControl:
        return 'Allergen Control';
      case SopTemplateType.deliveryAndStorage:
        return 'Delivery and Storage';
      case SopTemplateType.personalHygiene:
        return 'Personal Hygiene';
      case SopTemplateType.pestControl:
        return 'Pest Control';
    }
  }
  switch (type) {
    case SopTemplateType.cleaningSchedule:
      return l10n.sopTemplateCleaningSchedule;
    case SopTemplateType.allergenControl:
      return l10n.sopTemplateAllergenControl;
    case SopTemplateType.deliveryAndStorage:
      return l10n.sopTemplateDeliveryAndStorage;
    case SopTemplateType.personalHygiene:
      return l10n.sopTemplatePersonalHygiene;
    case SopTemplateType.pestControl:
      return l10n.sopTemplatePestControl;
  }
}
