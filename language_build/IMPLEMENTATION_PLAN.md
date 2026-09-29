# Implementation Plan

## Phase 1 - Localization Foundation

Add Flutter localization infrastructure.

Tasks:

- Add `flutter_localizations` support.
- Add ARB translation files under `lib/l10n/`.
- Add `l10n.yaml`.
- Generate `AppLocalizations`.
- Add `supportedLocales` and `localizationsDelegates` to `MaterialApp`.
- Add a Riverpod locale controller.
- Persist device language using `shared_preferences`.
- Ensure language changes rebuild the app immediately.

Deliverable: Selecting a language changes translated foundation strings without restart.

## Phase 2 - Language Preferences

Add persistent language preferences.

Tasks:

- Add `preferredLocale` or `preferredLanguageCode` to the `User` model.
- Add the matching Drift column.
- Add backend `users.preferred_locale` migration.
- Map the field in `DriftUserRepository` and `SupabaseUserRepository`.
- Add company/site default locale later if needed.
- On login, apply the current user's preferred language.
- On logout, return to the device language.

Deliverable: Different staff members on the same tablet can use different languages.

## Phase 3 - Language Selector UX

Add language selection UI.

Locations:

- Login/staff selection screen.
- First-run/onboarding flow.
- Settings/preferences.

Behavior:

- Changing device language before login persists for the tablet.
- Changing language while signed in updates the user preference.
- Change is immediate.
- Language names should be shown in their own language where practical.

Deliverable: Users can choose their preferred language without manager/developer help.

## Phase 4 - AI Assistant Language Contract

Make the AI assistant follow the same preferred language as the signed-in user.

Tasks:

- Send the active app locale with every AI assistant question.
- Instruct the assistant to answer in the user's preferred app language unless the user explicitly asks otherwise.
- Keep citations/source documents canonical and separate from translated answer text.
- Make the AI answer cache language-aware so cached English answers are not served to Croatian, German, Polish, or other-language users.
- Localize the AI assistant question screen labels.

Deliverable: A user asking the assistant from a localized profile gets assistant UI and answers in that same language without extra choices or prompts.

## Phase 5 - Migrate Core Staff Flow Text

Translate the screens used most by base-tier staff.

Priority screens:

- Splash/value screen.
- Login/staff selection.
- PIN entry.
- Worker hub.
- Task screen.
- Ad-hoc task.
- Shift welcome.
- End shift.
- Urgent/trigger notification banners.
- Common dialogs, snackbars, and errors.

Deliverable: A normal worker can start a shift, complete tasks, log issues, and finish a shift in their selected language.

## Phase 6 - Migrate Manager and Setup Screens

Translate manager and admin workflows.

Priority screens:

- Settings.
- Staff management.
- Venue setup.
- Task assignment.
- Supplier management.
- Department/team management.
- Document centre.
- Billing.
- Help/FAQ/Troubleshooting.

Deliverable: Managers can configure and operate the app in supported languages.

## Phase 7 - Task Library and Domain Translations

Add translation keys for seeded operational content.

Content areas:

- Task titles.
- Task guidance text.
- Equipment type names.
- Task segments.
- Issue types and subtypes.
- Priority labels.
- Frequency labels.
- Evidence labels.
- Legal limit categories.

Rules:

- Store stable identifiers.
- Display translated labels.
- Preserve English canonical labels for audit/export.

Deliverable: Operational task content appears in the user's language without losing audit traceability.

## Phase 8 - Exports, PDFs, and Audit Output

Design export behavior.

Recommended output:

- English canonical labels always present.
- Optional selected-language display labels beside them.
- User-entered notes kept exactly as written.
- Include a report language and generated-at locale marker.

Deliverable: EHO/audit exports remain clear even when staff used non-English UI.

## Phase 9 - QA and Hardening

Test layout and behavior thoroughly.

Required checks:

- Pseudo-localization for overflow.
- Arabic RTL pass.
- Urdu RTL pass.
- Small Android tablet.
- Windows tablet.
- Web build.
- Long staff names and venue names.
- Task cards with long translated labels.
- PDF font coverage for Chinese, Arabic, Hindi, and Urdu.

Deliverable: Language support feels robust, not experimental.

