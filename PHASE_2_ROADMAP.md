# PHASE_2_ROADMAP.md

Ideas and decisions for VenuRite's next phase, agreed 2026-09-30 following competitor research (Food Alert, JOLT/SmartSense, Trail, FoodDocs, Kafoodle, Deputy, HotSchedules — full report in `reports/VenuRite competitor landscape.md`). This is a living list, not a sprint plan — items move out of here into `DECISIONS_LOG.md`/an actual build plan once scheduled.

## Building now (not Phase 2 — pulled forward, in progress)

- **Natasha's Law / allergen matrix module** — direct founder request (2026-09-30), highest-priority competitive gap identified (Kafoodle does this, VenuRite doesn't). Validate real customer demand alongside the build, don't assume it purely from competitor presence. **DONE except one follow-up, 2026-09-30**: the 14 UK allergens + contains/mayContain status; a shared, site-wide Ingredient library with keyword-suggested starting allergens (simple substring matching, not real ML — honest vs. FoodDocs' own "AI" claim); MenuItem draft/approved workflow — any site-accessible staff can draft a dish and its ingredients, only supervisor+ can review and approve, which is the only moment tags actually publish (editing ingredients always drops an approved item back to draft); `MenuManagementScreen`/`MenuItemDetailScreen` for the manager side; `AllergenMatrixScreen` (reached via HelpScreen, so base tier can reach it too) as the read-only staff-facing grid, with its own standalone PDF export. Localized throughout as each piece was built, not deferred to a separate pass. **Known gap, not fixed here**: no integration into the existing EHO export PDF (`eho_export_service.dart`) — that's a large, already-shipped compliance document, and adding a section to it needs its own careful pass reading the full file, not a rushed addition. Follow-up, not forgotten.
- **Certification-expiry-linked shift eligibility** — direct founder request (2026-09-30). **DONE, 2026-09-30**: certificate document upload (photo/scan, private Storage bucket); role-based required-certification floor (`systemRequiredCertifications`, fixed per job role, not removable in-app) plus leadership-addable extras (`CertificationRequirementsScreen`, regional/executive-only); client-side blocking on both self-claim and manager-assignment with a specific "you need X" message; server-side enforcement in the `claim_shift` Postgres RPC (the client checks alone aren't real enforcement); 30-day advance warning to both employee and manager via a new cron-triggered Edge Function (`cert-expiry-notifications`), English-only for now (flagged, not silently shipped). Known gap: `managerAssign` (direct shift assignment) isn't routed through `claim_shift`, so server-side enforcement currently only covers self-claims — a follow-up RPC would be needed to close that.

## Committed Phase 2 ideas

### SOP / HACCP AI-assisted document generation
FoodDocs is the only researched competitor with a credible "AI" story — auto-generating HACCP plans/SOPs from a venue's setup answers, not predictive risk AI. Founder confirmed this is a good fit for VenuRite. Not yet scoped — needs its own design pass (what triggers generation, what "AI-assisted" means concretely here, review/approval step before a generated SOP goes live).

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
