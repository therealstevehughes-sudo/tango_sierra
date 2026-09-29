# Translation QA

## Current Status

The launch-language ARB files contain first-pass product translations for the UI strings that are currently wired into localization.

These strings have been reviewed for:

- Clear native-speaker meaning rather than word-for-word English.
- Hospitality and shared-tablet context.
- Conservative compliance/audit meaning.
- Avoiding country flags as language markers.
- Keeping canonical audit records separate from translated display text.

## Required Before Production Rollout

Native review is still required before each language is used with paying customers.

Priority review order:

1. Croatian, because Croatia is a likely first expansion market through Tom's HoReCa contacts.
2. German, because Germany is the likely follow-on expansion market.
3. Polish, Romanian, and Spanish for UK hospitality staffing coverage.
4. Arabic, Simplified Chinese, Hindi, and Urdu, including layout and font checks.

Reviewers should check:

- Whether the tone feels natural to hospitality staff.
- Whether manager, staff, venue, inspection, and audit terms match local usage.
- Whether legal/compliance wording stays accurate without promising too much.
- Whether the text fits on small kitchen tablets.
- Whether right-to-left languages render correctly in real screens.

## Translation Principle

For compliance text, prefer clear operational meaning over literal translation.

Example:

- English source: `Always EHO-ready`
- Better localized meaning: ready for the relevant local health or food-safety inspection.

Do not translate user-entered notes automatically. Preserve the original text and offer optional marked translation later only if the product explicitly supports it.
