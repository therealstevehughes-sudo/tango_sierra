# MASTER_PLAN.md

## Purpose
This file is the high-level build roadmap.

It keeps every sprint aligned to the same overall direction.

## Product Goal
Build a strict, fast, multilingual, offline-capable kitchen operations and compliance app that is harder to fake than paper and easier to use under pressure.

## Phase 1: Foundation
Goals:
- project control files complete
- Flutter app structure confirmed
- architecture locked
- design system locked
- sprint process locked

Deliverables:
- control file suite
- feature-first folder structure
- base theme and app shell

## Phase 2: Core Authentication and Roles
Goals:
- simple user sign-in flow
- role identification
- role-based landing experience
- shared device workflow readiness

Deliverables:
- basic auth shell
- role model
- user session handling

## Phase 3: Staff Task Engine
Goals:
- one-task-at-a-time task flow
- required input handling
- pass/fail logic
- evidence capture support
- task completion logic

Deliverables:
- staff home screen
- task screen
- task submission flow

## Phase 4: Manager Control Layer
Goals:
- manager board
- task overview
- reassign task
- override task
- incident logging
- sign-off flow

Deliverables:
- manager dashboard
- task detail view
- reassignment and override controls

## Phase 5: Compliance and Cleaning Modules
Goals:
- food safety tasks
- cleaning tasks
- delivery checks
- temperature checks
- corrective action handling

Deliverables:
- reusable task types
- compliance-specific forms
- cleaning and HACCP task templates

Note: this phase's fixed task types are superseded by the configurable Task Library Model below (Sprints 007, 010) — the goals here still apply, but are now delivered as configurable task definitions rather than hardcoded types.

## Phase 6: Offline Persistence
Goals:
- local storage
- queued sync-ready model
- sync state tracking

Deliverables:
- offline submission storage
- sync status fields
- audit-safe timestamps

Note: local storage (Sprints 001–002) and auth (Sprints 003–004) are already delivered. The remaining queue/sync-indicator work is now Sprint 014 below, with the additive-only sync rule confirmed in PROJECT_BIBLE.md.

## Phase 7: Reporting and Leadership Visibility
Goals:
- daily summary
- missed critical task view
- site comparison concept
- basic reporting structure

Deliverables:
- daily report screen
- high-level dashboard
- export-ready data structure

Note: now delivered via Sprint 011 (shift handover + summary/report) and Sprint 017 (inspection export — venue manager tier and above as of Sprint 031, not top tier only as originally planned here), on top of the three-tier role model from Sprint 006.

## Phase 8: Language Support
Goals:
- translation structure
- language switch support
- translation-safe UI

Deliverables:
- localisation groundwork
- short label compliance
- language-ready components

Note: now delivered via Sprint 016, refined to per-user language selection (each staff member picks their own language) rather than a single device-wide switch.

## Sprint Sequence (Post Sprint 005) — Expanded Vision
Sprints 000–005 delivered Phases 1–4 above (foundation, local persistence, real auth, manager wiring, and two small bug fixes). The product scope has since expanded significantly, per DECISIONS_LOG.md's "Full product vision." The phases above still describe true, standing goals, but the sequence below is the authoritative, confirmed build order going forward, and is more specific than Phases 5–8.

**006 — Three-tier roles**
Goal: formalise top / mid / base tiers (see PROJECT_BIBLE.md Role Tier Model), beyond the current two-tier staff/manager split. Confirm which named titles map to which tier.

**007 — Task library data model**
Goal: replace the hardcoded task list with a configurable data model — method, limits (incl. legal-limit reference checking), trigger events, if/then logic, custom fields. Data model only, per the established build-then-wire pattern.

**008 — Venue setup wizard**
Goal: guided setup flow for a venue's equipment (including multiple named instances per type), operational points/areas, and staff + roles.

**009 — Staff onboarding + task assignment**
Goal: manager selects staff for the venue, assigns tasks and frequency from a tick-box library, can add custom tasks.

**010 — Richer task input UI**
Goal: wire the Sprint 007 data model into the task screen — configurable methods (e.g. thermometer + photo, categorical choices) and custom fields, plus unit display (metric/imperial, °C/°F), without relaxing the one-task-at-a-time, minimal-typing rules.

**011 — Shift handover + summary/report**
Goal: carry-over notes between shifts; end-of-session summary (pass/fail + triggers fired) sendable to a selected manager.

**012 — Notifications**
Goal: configurable trigger notifications (push and/or email) for top/mid tier, with top-tier override of mid-tier settings.

**013 — Audit trail versioning**
Goal: extend immutability from submissions to task configuration itself — changes to task setup (limits, frequency) create a new version; old versions stay visible, nothing is overwritten.

**014 — Offline queue + sync indicator**
Goal: local queuing with timestamp, additive-only sync (no merge/overwrite), manager-visible "not yet synced" indicator.

**015 — Branding**
Goal: company/branch branding (colours, logo, contact info), controlled by top tier.

**016 — Multilingual**
Goal: per-user language selection; compliance logs and exports remain in English.

**017 — Inspection export**
Goal: EHO/audit-ready PDF export of a venue's compliance records for a chosen date range. Built Sprint 031 — venue manager tier and above (reconsidered from an originally-planned top-tier-only restriction: an EHO inspection is unannounced and happens at the venue, so requiring the Director specifically would defeat the feature's point).

**018 — Visual/UX redesign**
Goal: a dedicated pass on visual design/UX once the above functional scope is in place — not before, and not incrementally smuggled into earlier sprints.

## Phase 9: Multi-tenant Backend Foundation (Phases B0-B5) — DELIVERED
Goal: move from a single-device local database to a real, proven multi-tenant backend (self-hosted Supabase/Postgres on a shared VPS), so many separate companies can use the same deployed app with provable data isolation between them.

Delivered (see DECISIONS_LOG.md and BACKEND_INFRA.md for full detail):
- B0: Region schema (local, foundation for the cluster below).
- B1: claims + Row-Level-Security foundation, cross-tenant isolation proven with real curl matrices and real Dart integration tests — the highest-risk build in the project, done first and proven before anything else was layered on.
- B2: Foundation cluster (Organisations, Regions, Sites, VenueTypes, Departments, Areas, EquipmentTypes) on the backend, RLS proven.
- B3: People cluster (Users, TrainingRecords) on the backend — the trickiest interaction, since Users underpins auth; proven auth kept working before/after.
- B4: Operational config cluster (TaskTemplates, TaskSchedules, NotificationRules, BrandingConfigs) — RLS proven to correctly handle version-chained (append-only) data, not just flat rows.
- B5: Live/transactional cluster (equipment instances, task submissions, trigger notifications, session summaries, shift handover notes, problem register) — the payoff cluster; real multi-device sync proven, not oversold.

A genuine architectural finding was made and fixed during this phase: a self-referential RLS policy bug (a table's policy querying itself broke `INSERT ... RETURNING` for `sites`/`regions`) — found empirically, fixed, and the full B1/B2 proof matrix re-run to confirm no regression. See DECISIONS_LOG.md's C1c entry for detail.

**Still pending before real customer data goes live on this foundation**: a human security review of the RLS design, and a dedicated server (currently shares a VPS with another app) — both logged as launch gates in the 2026-09-14 roadmap entry in DECISIONS_LOG.md.

## Phase 10: Tenant Onboarding (Phase C1) — DELIVERED
Goal: let a brand-new company sign up and become a fully isolated tenant on the Phase 9 foundation, with a cascading setup flow matching the role-tier cascade rule (nobody sets up more than one level below them).

Delivered (see DECISIONS_LOG.md for full detail, including the real findings made along the way):
- C1a: demo-seed gating — a real build (`SEED_DEMO_DATA=false`) opens genuinely empty, no fake company/staff.
- C1b: tenant signup — a fresh company becomes an isolated tenant with its own first Director account. Found and fixed: `public.users` had no `organisation_id` (a site-less executive couldn't be RLS-scoped at all), and `User.siteId` had to become nullable app-wide (~22 call sites).
- C1c: invite-senior (regional/executive accounts) + Region/Branch management screens. Found and fixed: the self-referential RLS bug noted under Phase 9 above.
- C1d: provision-staff-pin (PIN-tier accounts) + staff onboarding + the per-tier setup checklist. Found and fixed a three-part chain: `SupabaseUserRepository.authenticate()` didn't work for backend-only accounts, the fix's first attempt hit a chicken-and-egg RLS problem at login time, and the `users` RLS policy's site-less branch let any tier read every executive's profile.

**Explicitly scoped OUT of C1, logged as separate later phases**: the branded-per-branch home screen (Phase C2, not yet planned) and the interactive org-builder/organogram (Phase C3, not yet planned) — both named in the original Phase C vision but deliberately deferred so C1's onboarding scope stayed shippable.

## Phase 11: App Health-Check Fixes (2026-09-14) — DELIVERED
Not a planned phase — a full app walkthrough (prompted by several parallel coding-assistant sessions having worked on the codebase) surfaced and fixed a run of real, previously-undetected runtime bugs that neither `flutter analyze` nor the unit/widget test suite could catch (all are runtime-only failures): a `BrandHeader` crash that broke the login screen on every real launch, a broken photo-evidence capture flow (a genuine Dart async/catch gotcha combined with a Windows plugin gap), no live camera support on Windows at all, an illegible compiled app icon, no way to reset a Director/Regional password, shift handover notes that never cleared, and Leadership Access being completely unreachable in a local/demo build. Full detail in DECISIONS_LOG.md's dated entries. Also logged (not built) a major v1 product-scope update from a strategy session — see DECISIONS_LOG.md's "Major product-scope update" entry and `VENURITE_ROADMAP.md`.

## Standing Non-Negotiables
- no feature creep
- no generic app drift
- no architecture drift
- no visual drift
- no weakening of audit logging
- no weakening of role-based visibility
- no weakening of audit trail versioning (task configuration changes must never overwrite a prior version)

## Current Priority (updated 2026-09-14)
Phases 1–8 (Sprints 000–032, including the 18-item expanded-vision sequence above) are delivered. Phase 9 (multi-tenant backend foundation, B0–B5) and Phase 10 (tenant onboarding, C1a–C1d) are delivered and proven. Phase 11 (today's app health-check fixes) is delivered.

**Current priority: Sprint 033, Guided Cards visual refresh — reconciliation & completion** (see SPRINT.md). After that, in order:
1. Phase C2 — branded-per-branch home screen (not yet planned in detail).
2. Phase C3 — interactive org-builder/organogram (not yet planned in detail).
3. The new v1 roadmap features logged 2026-09-14 (detailed delivery records, per-food legal temp thresholds, AI compliance assistant, per-task AI help, central compliance knowledge base) — **logged only, not started**, and blocked on the v1 launch gates (food-safety professional sign-off is now on the critical path — see DECISIONS_LOG.md).
