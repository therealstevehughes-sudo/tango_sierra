# VenuRite Language Build

This folder records the product and engineering plan for adding preferred-language support to VenuRite.

The goal is not just to translate labels. VenuRite is used on shared hospitality tablets, records compliance activity, exports audit evidence, and contains a seeded operational task library. Language support therefore has to preserve audit clarity while letting each staff member work in the language they understand best.

## What We Are Building

VenuRite will support:

- A device/tablet language used before anyone signs in.
- A staff member preferred language used after PIN or email sign-in.
- A company/site default language for new users and new devices.
- Instant language switching from a language picker, without app restart.
- Right-to-left layout support for Arabic and Urdu.
- Canonical English compliance records with translated display text.

## Initial Launch Languages

The agreed initial set is:

- English
- Polish
- Romanian
- Spanish
- Croatian
- German
- Arabic
- Simplified Chinese
- Hindi
- Urdu

Croatian is included because Tom has strong HoReCa contacts in Croatia and that market is a likely first expansion target. German is included because Germany is the likely next expansion path.

French, Portuguese, and Italian are deliberately deferred because many speakers in the target customer base are more likely to have workable English. They remain future additions.

## Why It Is Built This Way

VenuRite is a shared-device operational app, not a single-user content app. A kitchen tablet may be used by several staff members in one shift, each with a different preferred language. The app therefore cannot rely only on the phone/tablet system language.

The app also needs audit reliability. A task such as "Fridge temperature" may be displayed in Polish, Spanish, Arabic, or Hindi, but the compliance record must still map back to a stable source task. For that reason, seeded task and compliance content should use stable keys and canonical English/source values, with translated display values layered on top.

## Files In This Folder

- `DECISIONS.md` - decisions made so far and the reasoning behind them.
- `IMPLEMENTATION_PLAN.md` - phased technical plan.
- `CHECKLIST.md` - live progress tracker.
- `CONTENT_RULES.md` - rules for what gets translated and what stays canonical.
- `LANGUAGE_SELECTOR_UX.md` - product behavior for choosing and applying languages.

