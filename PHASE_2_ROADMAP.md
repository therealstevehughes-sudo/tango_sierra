# PHASE_2_ROADMAP.md

Ideas and decisions for VenuRite's next phase, agreed 2026-09-30 following competitor research (Food Alert, JOLT/SmartSense, Trail, FoodDocs, Kafoodle, Deputy, HotSchedules — full report in `reports/VenuRite competitor landscape.md`). This is a living list, not a sprint plan — items move out of here into `DECISIONS_LOG.md`/an actual build plan once scheduled.

## Building now (not Phase 2 — pulled forward, in progress)

- **Natasha's Law / allergen matrix module** — direct founder request (2026-09-30), highest-priority competitive gap identified (Kafoodle does this, VenuRite doesn't). Validate real customer demand alongside the build, don't assume it purely from competitor presence.
- **Certification-expiry-linked shift eligibility** — direct founder request (2026-09-30). Certifications (food hygiene, allergen training, etc.) gain an expiry date; a worker whose relevant cert has expired can't be scheduled/can't claim a shift requiring it. Employee AND employer/manager get advance notification before expiry — default 30 days' warning, confirmed by founder.

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
