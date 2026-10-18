# VenuRite: where things stand (18 Oct 2026)

Plain-English summary of what's done and what's left. Detail lives in
DECISIONS_LOG.md (what and why) and BACKEND_INFRA.md (server specifics).

## Done (week of 13–18 Oct 2026)

**App features**
- Rota tiers, training quizzes (1,070 questions), anti-faking flags, mid-shift reminders, device rules.
- Fryer oil limits: amber over 180°C, red over 185°C, adjustable per venue.
- Business Setup Wizard: step-by-step company setup, AI fill-in, Google Maps branch search, saved progress, one-time logins.
- Equipment library: search by make/model, 8 manufacturer-sourced check packs, AI-drafted packs approved by the manager.
- Menu: one "Trends" screen with tabs instead of three separate screens.
- Fixes: overlapping AI button, bulky buttons, presets now save to the server.

**Fixed today (18 Oct)**
- Directors could not sign in on a new phone/browser (saw a demo PIN screen). Fixed and checked live.
- AI assistant had been down since 16 Oct (missing database change). Fixed and checked live.

**Business / infrastructure**
- GoCardless: full sandbox test passed, then switched to **live** (18 Oct). Account verified.
- Off-site backups: nightly, encrypted, to Backblaze B2 (30-day lock, can't be deleted). Unlock passphrase in `Desktop\passwords` on Steve's PC and on the server.
- Website: real app screenshots, including a real AI answer ("Ask a question" section).
- Tom (Greekos Gyros): free-for-life code `VR-Y5JH-QGR9`, entered on the Billing screen after sign-up.
- Decision: VenuRite is **web only** for now (no Android/Apple app store versions).
- Drafted: security scope, client agreement, DPA (to be reviewed by someone else later).

**Steve's PC (dev tools, not VenuRite)**
- OmniRoute restarted, now starts automatically with Windows, connected to a free Google Gemini key. Use it in VS Code Chat by picking an OmniRoute model.
- Gemini Code Assist extension installed (separate, signs in with Google).

## Still to do (next week)

1. **Check staff PIN sign-in on a brand-new device**: may have the same problem the directors' sign-in had. Do first.
2. **Watch the first real Direct Debit** (e.g. SFO) go through end to end.
3. **More equipment models**: only 8 so far, aim ~150; each needs its manufacturer manual read.
4. **Quiz translations**: the 1,070 questions are English only.
5. Move venue-made task presets to the server (currently saved only on the device that made them).
6. Save the Backblaze passphrase in a password manager too (it's currently a file on the PC).
7. Mention Backblaze (US storage) in the DPA as an international transfer.

**Waiting on decisions / other people**
- Equipment library plan: approve later (built as if approved).
- Legal docs (client agreement, DPA): review by someone else, later.
- Security scope: post on Upwork, not yet.
