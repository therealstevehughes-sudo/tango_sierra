# PHASE_2_ROADMAP.md

Ideas and decisions for VenuRite's next phase, agreed 2026-09-30 following competitor research (Food Alert, JOLT/SmartSense, Trail, FoodDocs, Kafoodle, Deputy, HotSchedules — full report in `reports/VenuRite competitor landscape.md`). This is a living list, not a sprint plan — items move out of here into `DECISIONS_LOG.md`/an actual build plan once scheduled.

## Building now (not Phase 2 — pulled forward, in progress)

- **Natasha's Law / allergen matrix module** — direct founder request (2026-09-30), highest-priority competitive gap identified (Kafoodle does this, VenuRite doesn't). Validate real customer demand alongside the build, don't assume it purely from competitor presence. **DONE except one follow-up, 2026-09-30**: the 14 UK allergens + contains/mayContain status; a shared, site-wide Ingredient library with keyword-suggested starting allergens (simple substring matching, not real ML — honest vs. FoodDocs' own "AI" claim); MenuItem draft/approved workflow — any site-accessible staff can draft a dish and its ingredients, only supervisor+ can review and approve, which is the only moment tags actually publish (editing ingredients always drops an approved item back to draft); `MenuManagementScreen`/`MenuItemDetailScreen` for the manager side; `AllergenMatrixScreen` (reached via HelpScreen, so base tier can reach it too) as the read-only staff-facing grid, with its own standalone PDF export. Localized throughout as each piece was built, not deferred to a separate pass. **EHO export integration CLOSED, 2026-09-30**: read the full 1100-line file first, then added an allergen matrix section as its own resilient block (same pattern every other block in that file uses), showing every approved dish's published tags. Not smoke-tested end-to-end with real data (no test harness exists for that file) — recommend a real export run before relying on it in front of an inspector.
- **Certification-expiry-linked shift eligibility** — direct founder request (2026-09-30). **DONE, 2026-09-30**: certificate document upload (photo/scan, private Storage bucket); role-based required-certification floor (`systemRequiredCertifications`, fixed per job role, not removable in-app) plus leadership-addable extras (`CertificationRequirementsScreen`, regional/executive-only); client-side blocking on both self-claim and manager-assignment with a specific "you need X" message; server-side enforcement in the `claim_shift` Postgres RPC (the client checks alone aren't real enforcement); 30-day advance warning to both employee and manager via a new cron-triggered Edge Function (`cert-expiry-notifications`), English-only for now (flagged, not silently shipped). **Follow-up gap CLOSED, 2026-09-30**: `managerAssign` now calls a dedicated `manager_assign_shift` RPC (not a plain table update) enforcing both the venueManager+ role gate and cert eligibility server-side — confirmed via direct query that the old plain UPDATE's only RLS policy was tenant_isolation with no role or cert check at all.

## Committed Phase 2 ideas

### SOP / HACCP AI-assisted document generation
FoodDocs is the only researched competitor with a credible "AI" story — auto-generating HACCP plans/SOPs from a venue's setup answers, not predictive risk AI. Founder confirmed this is a good fit for VenuRite. **DONE, 2026-09-30**: new `generate-sop-document` Edge Function (genuine synthesis, not the citation-grounded `ai-assistant` RAG Q&A — a deliberately different trust level, flagged as such in the UI), 5 starter templates, generate → review/edit → save-as-PDF-to-Document-Centre flow. Every generated document is explicitly framed as an AI-drafted first draft requiring manager review before use.

### Rota calendar + fair auto-assign
Direct founder request (2026-10-01), after seeing Roster's current screens are flat claim/post lists with no visual calendar at all. Agreed scope:
- **Shift periods**: leadership configures 2 or 3 named periods per site (e.g. Morning/Afternoon/Night) with time-of-day boundaries — a shift's period is always derived live from this config + its start time, never stored on the shift itself, so changing the config reclassifies everything automatically.
- **Week grid** (primary view): rows = staff/department, columns = the 7 days, shifts as time blocks — the standard rota-tool layout (Deputy/When I Work).
- **Month grid** (secondary view): compact per-day shift/unfilled counts, drill into a day or its week.
- Both filterable by period, department, person.
- **Fair auto-assign**: manager ticks staff to include + shifts/days to fill, hits one button. Hard constraints (cert-eligibility, no approved-day-off conflicts, no double-booking) always enforced; fairness is explainable round-robin (hardest-to-fill shifts assigned first, then whoever has the fewest hours assigned so far in that run gets each shift) — never a black-box score. **Always produces a preview the manager confirms before anything commits** — same "never auto-publish unreviewed" principle as the allergen tags and AI-drafted SOPs.

Sequencing: shift period config → week grid → month grid → wire into staff/manager screens → auto-assign (depends on the calendar existing). Sprint 1 (shift period config) in progress.

### Bluetooth/WiFi temperature probe integration
Middle step before any full IoT sensor network (JOLT/SmartSense's model — Bluetooth + LoRa hardware, opaque enterprise pricing $200-300+/mo). Achievable first step: Bluetooth temperature probes that write readings directly into the existing temperature-check task flow, removing manual entry. Hardware partner/SDK TBD.

### Account-management / admin tool (VenuRite team internal)
**Decision: separate web app** (Next.js or Flutter web — not decided which), reading the same Supabase backend the customer app uses, gated behind a superadmin role. Not built inside the customer-facing Flutter app.

Tracks: signed-up companies, business name + key contact, branch/staff counts, plans/products purchased, service-provider-access purchases, payment status (paid/late/missed) with automated notifications/blocks, account status, reported bugs/errors, join dates — all viewable by month/year/full-history.

Founder confirmed: build it, and link both apps fully (shared backend, no duplicated data). Full architecture to be scoped as its own plan before build starts (per standing process rule — plan review before implementation).

### On-site paid onboarding service
£99–£299 per branch, size-dependent. Founder confirmed pricing is realistic — matches market norms for white-glove SaaS setup services. Business/ops process, not a software build; revisit once account-management tool exists to track these as a paid line item per customer.

### Third-party freelance food-safety auditor marketplace
Food Alert's model (freelance auditors contracted for periodic on-site audits, VenuRite takes a referral/booking cut) — founder confirmed, locked in as a direction. Must-haves before build: contracts placing audit liability on the auditor (not VenuRite), proof of insurance/certification on file per auditor before they're bookable.

### Vetted third-party service-provider booking portal
Extension of the existing Service Providers directory feature. Founder confirmed, locked in as a direction. Gate before build: signed indemnity/waiver per provider, displayed proof of insurance + certifications on their profile, clear T&Cs that VenuRite facilitates introductions but isn't a party to the service contract. Solicitor sign-off required on the legal groundwork before any payment/booking flow is written.

## Positioning takeaways from competitor research (not a build item)

- No researched competitor bundles deep HACCP/compliance with real shift-scheduling/roster-claiming in one product — lean into "compliance + scheduling in one app" as explicit market positioning.
- Trail (closest UK competitor) is browser-based, not a native app, and its own reviewers want a real app — native reliability is a genuine, evidenced differentiator for VenuRite to market on.
- Transparent published pricing and a fast-support-response SLA are cheap, high-value differentiators — several competitors (JOLT, Food Alert) have opaque/quote-only pricing, and Deputy/HotSchedules both show support quality collapsing at scale in reviews.
