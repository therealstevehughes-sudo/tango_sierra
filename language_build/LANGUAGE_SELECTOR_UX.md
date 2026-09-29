# Language Selector UX

## Entry Points

Language selection should be available in three places:

1. First-run/onboarding.
2. Login/staff selection screen.
3. Settings/preferences.

Use a globe icon where space is limited.

## Before Login

Before login, the picker changes the device/tablet language.

This setting is stored locally and controls:

- Splash screen.
- First-run value screen.
- Sign-in and join-company flows.
- Staff selection.
- PIN entry.
- Device pairing.

## After Login

After login, the picker changes the current user's preferred language.

This setting should:

- Update the UI immediately.
- Persist to the local user row.
- Sync to the backend user row when backend data is enabled.
- Follow the user across devices where possible.

## Shared Tablet Behavior

Example:

1. Tablet default language is English.
2. Maria logs in and chooses Spanish.
3. App switches to Spanish.
4. Maria logs out.
5. Tablet returns to English staff selection.
6. Ahmed logs in and chooses Arabic.
7. App switches to Arabic and RTL layout.

This is the target behavior.

## Language List

Launch list:

- English
- Polski
- Română
- Español
- Hrvatski
- Deutsch
- العربية
- 简体中文
- हिन्दी
- اردو

Note: native display names need typographic/font checks on all supported platforms.

## Confirmation

Language changes should not require a restart.

For signed-in users, use a quiet confirmation such as a snackbar:

```text
Language updated.
```

Do not interrupt task completion with a blocking dialog unless a restart is genuinely required.

## Accessibility

The selector should:

- Have a tooltip/semantic label.
- Be reachable from keyboard navigation on desktop/web.
- Use sufficient text size for kitchen tablet use.
- Avoid flags as the primary selector, because languages are not countries.
