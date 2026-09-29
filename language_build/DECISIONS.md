# Language Build Decisions

## 1. Use User Preferred Language, Not Only Device Language

Decision: VenuRite will support both a device/tablet language and a staff member preferred language.

Reason: The app is commonly used on shared tablets. Device language works before sign-in, but after a staff member logs in the app should use that person's preference.

Expected behavior:

- Before login: device/tablet preference.
- After login: current user's preferred language.
- After logout: return to device/tablet preference.
- If a user has no preference: fall back to site/company default, then device preference, then English.

## 2. Keep Canonical Compliance Records Stable

Decision: Compliance records and seeded task identities should remain stable, with translated text used for display.

Reason: Audit records must be understandable and defensible even if the display language changes later.

Example:

- Canonical key: `task.fridge_temperature.title`
- Canonical English: `Fridge temperature`
- Display in Spanish: `Temperatura del frigorifico`
- Display in Polish: `Temperatura lodowki`

The database should not rely on translated text as the identifier for seeded compliance tasks.

## 3. Initial Language Set

Decision: Launch languages are English, Polish, Romanian, Spanish, Croatian, German, Arabic, Simplified Chinese, Hindi, and Urdu.

Reason: This better fits likely hospitality staffing needs than starting with French, Portuguese, and Italian.

Croatian is included because Tom has strong HoReCa-sector contacts in Croatia and Croatia is a likely first expansion market. German is included because Germany is the likely follow-on expansion market.

Deferred languages include Bengali, Turkish, Ukrainian, Lithuanian, French, Portuguese, and Italian.

## 4. Right-To-Left Is In Scope

Decision: Arabic and Urdu mean RTL support is part of the initial language build.

Reason: Excluding RTL would make those languages feel broken. Supporting them from the start avoids retrofitting layout assumptions later.

Implications:

- Test drawer direction.
- Test task cards.
- Test forms and input labels.
- Test segmented controls and chips.
- Test PDF/export rendering separately.

## 5. Do Not Machine-Translate User-Entered Content By Default

Decision: Staff notes, supplier names, venue names, uploaded document titles, and custom manager-written tasks are not automatically translated.

Reason: Automatic translation can alter meaning, introduce compliance risk, and misrepresent what the user actually recorded.

Future option: offer optional "translate for reading" on notes, clearly marked as a translation, while preserving the original.

## 6. Build In Phases

Decision: Build the language engine first, then migrate screens by customer value.

Reason: The codebase has many hardcoded strings. Translating everything at once would be slow and risky. A foundation-first approach lets the app switch languages cleanly while screens are migrated in controlled passes.

