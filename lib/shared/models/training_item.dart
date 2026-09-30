import '../../l10n/app_localizations.dart';

// Training/induction record catalogue (Sprint 031). Mirrors the
// ScheduleFrequency shape in task_schedule.dart: a fixed enum of common UK
// items plus a single `other` escape hatch for anything not listed, paired
// with a free-text detail field on the record itself (customItemTitle).
enum TrainingItemType {
  level2FoodHygiene,
  allergenAwareness,
  coshh,
  fireSafety,
  manualHandling,
  firstAid,
  induction,
  other,
}

String trainingItemTypeLabel(TrainingItemType type, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (type) {
      case TrainingItemType.level2FoodHygiene:
        return 'Level 2 Food Hygiene & Safety';
      case TrainingItemType.allergenAwareness:
        return 'Allergen Awareness';
      case TrainingItemType.coshh:
        return 'COSHH (Control of Substances Hazardous to Health)';
      case TrainingItemType.fireSafety:
        return 'Fire Safety';
      case TrainingItemType.manualHandling:
        return 'Manual Handling';
      case TrainingItemType.firstAid:
        return 'First Aid at Work';
      case TrainingItemType.induction:
        return 'Induction Completed';
      case TrainingItemType.other:
        return 'Other';
    }
  }
  switch (type) {
    case TrainingItemType.level2FoodHygiene:
      return l10n.trainingLevel2FoodHygiene;
    case TrainingItemType.allergenAwareness:
      return l10n.trainingAllergenAwareness;
    case TrainingItemType.coshh:
      return l10n.trainingCoshh;
    case TrainingItemType.fireSafety:
      return l10n.trainingFireSafety;
    case TrainingItemType.manualHandling:
      return l10n.trainingManualHandling;
    case TrainingItemType.firstAid:
      return l10n.trainingFirstAid;
    case TrainingItemType.induction:
      return l10n.trainingInduction;
    case TrainingItemType.other:
      return l10n.supplierCategoryOther;
  }
}
