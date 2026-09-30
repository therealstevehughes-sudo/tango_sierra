import '../../l10n/app_localizations.dart';

/// First-pass Help content (2026-09-24) — real, editable copy rather than
/// a "coming soon" placeholder, per the user's own preference for a
/// working first draft over an empty stub. Localized 2026-09-30 — both
/// lists are functions of [AppLocalizations] rather than plain consts,
/// same pattern as `management_drawer.dart`'s `_DrawerItemDef` functions,
/// since every question/answer pair is genuine UI copy shown to every
/// tier.
class HelpEntry {
  const HelpEntry(this.question, this.answer);

  final String question;
  final String answer;
}

List<HelpEntry> faqEntries(AppLocalizations l10n) => [
  HelpEntry(l10n.faqQ1, l10n.faqA1),
  HelpEntry(l10n.faqQ2, l10n.faqA2),
  HelpEntry(l10n.faqQ3, l10n.faqA3),
  HelpEntry(l10n.faqQ4, l10n.faqA4),
  HelpEntry(l10n.faqQ5, l10n.faqA5),
  HelpEntry(l10n.faqQ6, l10n.faqA6),
];

List<HelpEntry> troubleshootingEntries(AppLocalizations l10n) => [
  HelpEntry(l10n.troubleQ1, l10n.troubleA1),
  HelpEntry(l10n.troubleQ2, l10n.troubleA2),
  HelpEntry(l10n.troubleQ3, l10n.troubleA3),
  HelpEntry(l10n.troubleQ4, l10n.troubleA4),
  HelpEntry(l10n.troubleQ5, l10n.troubleA5),
  HelpEntry(l10n.troubleQ6, l10n.troubleA6),
];
