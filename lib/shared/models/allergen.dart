import '../../l10n/app_localizations.dart';

// Natasha's Law / allergen matrix module (Phase 2, 2026-09-30) — the 14
// allergens the UK Food Information Regulations 2014 (as amended by
// Natasha's Law, 2021) require to be declared for food sold prepacked for
// direct sale or on a menu. Fixed list, not a manager-editable catalogue —
// this is a legal list, not a business preference.
enum Allergen {
  celery,
  gluten,
  crustaceans,
  eggs,
  fish,
  lupin,
  milk,
  molluscs,
  mustard,
  treeNuts,
  peanuts,
  sesame,
  soya,
  sulphites,
}

String allergenDisplayName(Allergen allergen, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (allergen) {
      case Allergen.celery:
        return 'Celery';
      case Allergen.gluten:
        return 'Cereals containing gluten';
      case Allergen.crustaceans:
        return 'Crustaceans';
      case Allergen.eggs:
        return 'Eggs';
      case Allergen.fish:
        return 'Fish';
      case Allergen.lupin:
        return 'Lupin';
      case Allergen.milk:
        return 'Milk';
      case Allergen.molluscs:
        return 'Molluscs';
      case Allergen.mustard:
        return 'Mustard';
      case Allergen.treeNuts:
        return 'Tree nuts';
      case Allergen.peanuts:
        return 'Peanuts';
      case Allergen.sesame:
        return 'Sesame seeds';
      case Allergen.soya:
        return 'Soya';
      case Allergen.sulphites:
        return 'Sulphur dioxide and sulphites';
    }
  }
  switch (allergen) {
    case Allergen.celery:
      return l10n.allergenCelery;
    case Allergen.gluten:
      return l10n.allergenGluten;
    case Allergen.crustaceans:
      return l10n.allergenCrustaceans;
    case Allergen.eggs:
      return l10n.allergenEggs;
    case Allergen.fish:
      return l10n.allergenFish;
    case Allergen.lupin:
      return l10n.allergenLupin;
    case Allergen.milk:
      return l10n.allergenMilk;
    case Allergen.molluscs:
      return l10n.allergenMolluscs;
    case Allergen.mustard:
      return l10n.allergenMustard;
    case Allergen.treeNuts:
      return l10n.allergenTreeNuts;
    case Allergen.peanuts:
      return l10n.allergenPeanuts;
    case Allergen.sesame:
      return l10n.allergenSesame;
    case Allergen.soya:
      return l10n.allergenSoya;
    case Allergen.sulphites:
      return l10n.allergenSulphites;
  }
}

/// How strongly an [Allergen] applies to a menu item — "contains" is a
/// direct ingredient, "mayContain" is a cross-contamination risk (shared
/// fryer, same prep surface, etc.). Founder confirmed both are essential,
/// not just a single yes/no per allergen (2026-09-30).
enum AllergenTagStatus { contains, mayContain }

AllergenTagStatus allergenTagStatusFromString(String value) {
  switch (value) {
    case 'contains':
      return AllergenTagStatus.contains;
    case 'may_contain':
      return AllergenTagStatus.mayContain;
    default:
      throw ArgumentError('Unknown allergen tag status: $value');
  }
}

String allergenTagStatusToString(AllergenTagStatus status) {
  switch (status) {
    case AllergenTagStatus.contains:
      return 'contains';
    case AllergenTagStatus.mayContain:
      return 'may_contain';
  }
}

String allergenTagStatusLabel(
  AllergenTagStatus status, [
  AppLocalizations? l10n,
]) {
  if (l10n == null) {
    switch (status) {
      case AllergenTagStatus.contains:
        return 'Contains';
      case AllergenTagStatus.mayContain:
        return 'May contain';
    }
  }
  switch (status) {
    case AllergenTagStatus.contains:
      return l10n.allergenStatusContains;
    case AllergenTagStatus.mayContain:
      return l10n.allergenStatusMayContain;
  }
}
