# Language Build Checklist

## Planning

- [x] Agree that language support is needed for preferred/native language.
- [x] Agree initial language set.
- [x] Add Croatian for likely Croatia-first expansion.
- [x] Add German for likely Germany follow-on expansion.
- [x] Agree that French, Portuguese, and Italian are deferred.
- [x] Agree Arabic and Urdu require RTL support.
- [x] Agree canonical compliance records must remain stable.
- [x] Create language planning folder.

## Foundation

- [x] Add `flutter_localizations`.
- [x] Add `l10n.yaml`.
- [x] Create initial `app_en.arb`.
- [x] Create ARB files for launch languages.
- [x] Fill first-pass translations for currently wired UI strings.
- [x] Wire `AppLocalizations` into `MaterialApp`.
- [x] Add locale controller/provider.
- [x] Persist device locale.
- [x] Add tests for locale persistence.

## Preferences

- [x] Add user preferred locale to local model.
- [x] Add Drift migration.
- [x] Add backend `users.preferred_locale` migration.
- [x] Update Drift repository mapping.
- [x] Update Supabase repository mapping.
- [x] Apply user locale on login.
- [x] Restore device locale on logout.

## UX

- [x] Add login-screen language picker.
- [ ] Add onboarding language picker.
- [x] Add Settings language picker.
- [x] Add language names in native display.
- [ ] Confirm behavior on shared tablet.

## AI Assistant

- [x] Send active app language with AI assistant questions.
- [x] Instruct assistant to answer in the user's preferred app language.
- [x] Localize AI question screen labels.
- [x] Stage language-aware AI answer cache migration.
- [ ] Apply AI cache migration on production backend.
- [ ] Deploy updated `ai-assistant` Edge Function.
- [ ] Live-test cache separation across English, Croatian, and German.

## Screen Migration

- [x] Login/staff selection foundation strings.
- [x] PIN entry foundation strings.
- [x] Worker hub foundation strings.
- [ ] Task screen.
- [ ] Ad-hoc task.
- [x] Shift welcome foundation strings.
- [ ] End shift.
- [ ] Settings.
- [ ] Staff management.
- [ ] Venue setup.
- [ ] Supplier management.
- [ ] Help/FAQ/Troubleshooting.

## Domain Content

- [ ] Define translation key naming convention for seeded tasks.
- [ ] Map existing seeded task titles to stable keys.
- [ ] Map equipment type names to stable keys.
- [ ] Map issue type/subtype labels to stable keys.
- [ ] Decide bilingual export format.
- [ ] Confirm PDF fonts for all launch languages.

## QA

- [ ] Pseudo-localization pass.
- [ ] Arabic RTL pass.
- [ ] Urdu RTL pass.
- [ ] Chinese font/rendering pass.
- [ ] Hindi font/rendering pass.
- [ ] Small tablet overflow pass.
- [x] Web build pass.
- [ ] Windows build pass.

