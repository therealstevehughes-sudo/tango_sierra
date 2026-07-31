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

Note: now delivered via Sprint 011 (shift handover + summary/report) and Sprint 017 (inspection export, top tier only), on top of the three-tier role model from Sprint 006.

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
Goal: inspection data export, restricted to top tier only.

**018 — Visual/UX redesign**
Goal: a dedicated pass on visual design/UX once the above functional scope is in place — not before, and not incrementally smuggled into earlier sprints.

## Standing Non-Negotiables
- no feature creep
- no generic app drift
- no architecture drift
- no visual drift
- no weakening of audit logging
- no weakening of role-based visibility
- no weakening of audit trail versioning (task configuration changes must never overwrite a prior version)

## Current Priority
Phases 1–4 (foundation, auth, staff task engine, manager control layer) are delivered as of Sprint 005. Current priority is Sprint 006: formalise the three-tier role model, as the foundation the rest of the expanded-vision sequence (007–018) builds on.
