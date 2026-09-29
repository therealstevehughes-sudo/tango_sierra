# Content and Translation Rules

## Translate

Translate user interface text:

- Navigation.
- Buttons.
- Menus.
- Dialog titles and content.
- Snackbars and error messages.
- Form labels and helper text.
- Tooltips.
- Empty states.
- Settings labels.
- Onboarding and sign-in text.
- Worker task controls.
- Help and troubleshooting content.

## Translate By Stable Key

Translate seeded domain content by stable keys:

- Task titles.
- Task guidance.
- Equipment type names.
- Task segments.
- Issue types and subtypes.
- Priority labels.
- Frequency labels.
- Evidence requirement labels.
- Legal/compliance category labels.

Do not use the translated string as the durable identifier.

## Do Not Automatically Translate

Do not automatically translate:

- Staff names.
- Venue names.
- Organisation names.
- Supplier names.
- User-entered notes.
- Uploaded document titles.
- Custom task titles written by a manager.
- Free-text issue descriptions.

Reason: these are authored records. Translating them by default can change meaning or hide what was actually entered.

## Canonical Audit Rule

Every compliance/audit-sensitive item should be traceable to a canonical source value.

Recommended display pattern for exports:

```text
Fridge temperature / Temperatura del frigorifico
```

The first value is canonical English/source text. The second is the user's display language where available.

## Translation Quality

Translations must be plain, operational, and easy for non-technical staff.

Avoid:

- Marketing language.
- Legal overclaiming.
- Idioms.
- Long formal wording where short operational text works.
- Ambiguous action words.

Prefer:

- Clear verbs.
- Short labels.
- Consistent words for recurring actions.
- Native-language review where possible for compliance-critical terms.

## Compliance and Legal Text

Terms of Service, privacy text, food-safety guidance, and legal/compliance statements require extra review.

Machine translation may be used as a draft aid, but final wording should be reviewed before production use.

