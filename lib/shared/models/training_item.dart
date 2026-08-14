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

String trainingItemTypeLabel(TrainingItemType type) {
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
