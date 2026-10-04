import '../../l10n/app_localizations.dart';

/// Help content (2026-09-24, expanded 2026-10-04 — direct founder request:
/// the AI assistant can't help at all with no internet, so the offline
/// FAQ/Troubleshooting content needed to cover a lot more ground, not stay
/// a thin first-pass draft). Fully bundled with the app — no network
/// dependency, unlike the AI assistant's "Ask a question" — so this is
/// what a worker has when the AI genuinely can't be reached.
class HelpEntry {
  const HelpEntry(this.question, this.answer, {this.category});

  final String question;
  final String answer;

  /// Null entries render ungrouped, ahead of any categorised ones — used
  /// for the original handful of day-to-day task questions so they stay
  /// the first thing a base-tier worker sees.
  final String? category;
}

List<HelpEntry> faqEntries(AppLocalizations l10n) => [
  HelpEntry(l10n.faqQ1, l10n.faqA1),
  HelpEntry(l10n.faqQ2, l10n.faqA2),
  HelpEntry(l10n.faqQ3, l10n.faqA3),
  HelpEntry(l10n.faqQ4, l10n.faqA4),
  HelpEntry(l10n.faqQ5, l10n.faqA5),
  HelpEntry(l10n.faqQ6, l10n.faqA6),
  HelpEntry(l10n.faqQ7, l10n.faqA7, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ8, l10n.faqA8, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ9, l10n.faqA9, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ10, l10n.faqA10, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ11, l10n.faqA11, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ14, l10n.faqA14, category: l10n.faqCategoryRosterLabel),
  HelpEntry(l10n.faqQ12, l10n.faqA12, category: l10n.faqCategoryAccountLabel),
  HelpEntry(l10n.faqQ13, l10n.faqA13, category: l10n.faqCategoryAccountLabel),
  HelpEntry(l10n.faqQ15, l10n.faqA15, category: l10n.faqCategoryManagersLabel),
  HelpEntry(l10n.faqQ16, l10n.faqA16, category: l10n.faqCategoryManagersLabel),
  HelpEntry(l10n.faqQ17, l10n.faqA17, category: l10n.faqCategoryManagersLabel),
  HelpEntry(l10n.faqQ18, l10n.faqA18, category: l10n.faqCategoryManagersLabel),
  HelpEntry(l10n.faqQ19, l10n.faqA19, category: l10n.faqCategoryManagersLabel),
  HelpEntry(l10n.faqQ20, l10n.faqA20, category: l10n.faqCategoryManagersLabel),
];

List<HelpEntry> troubleshootingEntries(AppLocalizations l10n) => [
  HelpEntry(l10n.troubleQ1, l10n.troubleA1),
  HelpEntry(l10n.troubleQ2, l10n.troubleA2),
  HelpEntry(l10n.troubleQ3, l10n.troubleA3),
  HelpEntry(l10n.troubleQ4, l10n.troubleA4),
  HelpEntry(l10n.troubleQ5, l10n.troubleA5),
  HelpEntry(l10n.troubleQ6, l10n.troubleA6),
  HelpEntry(
    l10n.troubleQ7,
    l10n.troubleA7,
    category: l10n.troubleCategoryConnectionLabel,
  ),
  HelpEntry(
    l10n.troubleQ8,
    l10n.troubleA8,
    category: l10n.troubleCategoryConnectionLabel,
  ),
  HelpEntry(
    l10n.troubleQ9,
    l10n.troubleA9,
    category: l10n.troubleCategoryConnectionLabel,
  ),
  HelpEntry(
    l10n.troubleQ10,
    l10n.troubleA10,
    category: l10n.troubleCategoryAccessLabel,
  ),
  HelpEntry(
    l10n.troubleQ11,
    l10n.troubleA11,
    category: l10n.troubleCategoryAccessLabel,
  ),
  HelpEntry(
    l10n.troubleQ12,
    l10n.troubleA12,
    category: l10n.troubleCategoryAccessLabel,
  ),
];
