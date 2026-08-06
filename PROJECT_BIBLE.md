# PROJECT_BIBLE.md

## Product Name
Working title: Kitchen Control

## Product Definition
This product is a back-of-house operational compliance and execution platform.

It is not a generic checklist app.

It is a digital enforcement system designed to ensure that required kitchen tasks are completed correctly, on time, and with verifiable records.

## Core Principle
If a task was not logged correctly, in the required way, within the correct time window, it is treated as not completed.

## What This Product Is Not
This product must not drift into:
- POS
- rota scheduling
- recipe costing
- supplier ordering
- payroll
- menu engineering
- generic note-taking
- general to-do app behaviour

## Primary Business Purpose
The app exists to:
- enforce discipline
- improve food safety compliance
- improve cleaning consistency
- create audit-ready records
- give managers live visibility
- give multi-site leadership operational visibility

## Core User Groups
Primary:
- Kitchen Porter
- Prep Cook / Commis
- Line Cook / Chef de Partie
- Sous Chef / Shift Lead
- Head Chef / Kitchen Manager

Secondary:
- General Manager
- Area Manager
- Operations Manager
- Group Executive Chef
- Director / MD

## Role Tier Model (confirmed — five tiers, supersedes the original three-tier model)
Every user belongs to one of five tiers (Sprint 027; originally three — top/mid/base — split further once real multi-venue operators were considered). Each tier is a distinct escalation/visibility boundary: an unresolved problem rolls up exactly one level, not straight to the top. Job titles are labels mapped onto tiers, not the tiers themselves.
- **Base**: workers — does tasks, logs proof. Task execution only. (Kitchen Porter, Commis, Line Chef, Server, Bar Staff.)
- **Supervisor**: runs a shift, first responder to a failed check on the floor. (Head Chef on shift, Duty Manager.)
- **Venue Manager**: accountable for one venue — sets up the venue, assigns tasks, gets that site's escalations.
- **Regional**: oversees a cluster of venues, gets escalations a Venue Manager didn't close.
- **Executive/Director**: company-wide — sets policy and branding, sees everything, owns the audit relationship. Only tier with access to inspection data export.

Exactly which real job titles map to which tier is a per-organisation judgment call, correctable per-user via Staff Management's "Change Tier" action — not fixed rigidly by title.

## Role Principle
Not everyone sees everything.

Each role sees only what it needs to execute or control its responsibilities, per its tier (top / mid / base).

## Operational Reality
This app is for real kitchens where:
- staff are busy
- English may not be first language
- WiFi may be weak
- tasks are often skipped or backfilled on paper
- roles can overlap during pressure periods
- managers need both discipline and flexibility

## UX Principle
Staff must never browse for work.

Staff should see:
- what is due now
- what is overdue
- what they must do next

Managers should see:
- full operational visibility
- task status across users
- reassignment and override tools
- incident and corrective action controls

Directors should see:
- dashboards
- trends
- missed critical tasks
- site comparison
- exports

## Task Execution Model
Staff use a one-task-at-a-time flow.

Rules:
- one task per screen
- no free skipping
- no bulk ticking
- minimal typing
- large buttons
- clear pass/fail states
- photo and evidence only where required

Managers do not use the one-task carousel as their main view.
Managers use list and board views.

## Task Library Model (confirmed, expands Task Execution Model)
Tasks are no longer a fixed hardcoded set. The app is built around a configurable task library:
- Tasks are grouped by operational segment and by role
- The task library is site-editable — a venue's manager/top tier can configure it for that venue
- Each task can define trigger events, firing when a reading falls outside a configured min/max
- Each task can carry fix instructions (what to do when it fails)
- Tasks support if/then conditional logic (e.g. if a critical task fails, then require a corrective action before continuing — generalised beyond a single hardcoded rule)
- Each task has a configurable **method** — not limited to pass/fail/temperature. Examples: thermometer reading + photo, a choice of filter types, or other custom fields as the task requires
- This does not relax the existing Task Execution Model rules (one task per screen, minimal typing, large buttons, no bulk ticking) — it only widens what a single task's input can look like

## Task Library Source Content (confirmed, rewritten Sprint 030)
The real task/equipment library content — what the tasks in "Task Library Model" above actually are — now comes from **`HORECA_TASK_LIBRARY.md`** (v2, researched, project root), a comprehensively researched, UK-sourced document built for the full ALL-HoReCa target market. **This supersedes the original source, "Full check list.docx"** (Documents\AA Tango Sierra\Full check list.docx) — that document is retired as the library source; nothing further is loaded from it. `HORECA_TASK_LIBRARY.md`'s full ~150-task content has now been loaded into the app in its entirety, across Sprint 030 and five follow-up sprints (Clusters A-F, one per group of segments) — this section captures the resulting taxonomy for reference, not as a still-pending future step.

### Operational segments (21, all loaded)
These map directly onto `TaskTemplate.segment`, replacing the old 19-segment taxonomy above (retired along with its source document):
1. `food_safety` — Food Safety & Temperature Control (refrigeration, cooking/reheating/cooling, date marking & rotation)
2. `allergen` — Allergen Management (Natasha's Law / PPDS labelling, allergen matrix, prep separation)
3. `personal_hygiene_ppe` — Personal Hygiene & PPE
4. `refrigeration_cold_storage` — Refrigeration & Cold Storage (equipment condition, not temperature readings — those are segment 1)
5. `cooking_line_equipment` — Cooking Line Equipment (fryer & oil, ovens/grills/hobs, mechanical & safety)
6. `washup_dishwash` — Wash-up / Dishwash
7. `cleaning_sanitation` — Cleaning & Sanitation (food-contact surfaces, floors/walls/drains, schedule sign-off)
8. `cleaning_chemicals` — Cleaning Chemicals & Consumables
9. `dry_ambient_storage` — Dry & Ambient Storage
10. `deliveries_goods_in` — Deliveries & Goods In
11. `utilities_safety` — Utilities & Safety (hand-wash sinks, fire exits, first aid)
12. `waste_pest_control` — Waste & Pest Control
13. `preventive_maintenance` — Preventive Maintenance (PAT testing, gas safety certification, servicing)
14. `stock_control` — Stock Control
15. `opening_procedures` — Opening Procedures
16. `closing_procedures` — Closing Procedures
17. `service_readiness` — Service Readiness
18. `front_of_house` — Front of House / Service *(new — no equivalent in the old taxonomy)*
19. `bar_beverage` — Bar & Beverage *(new)*
20. `hotel_specific` — Hotel-Specific *(new; hotels only — the narrowest venue-type applicability of any segment)*
21. `management_compliance_oversight` — Management & Compliance Oversight (replaces the old taxonomy's "Incident Logging"/"Staff Accountability", which described behaviour this app already models through other entities — `Incident`, `OverrideLog`, the audit trail — rather than carousel task types)

Every segment is tagged by which of the app's 12 seeded venue types it applies to, via `TaskTemplateVenueTypes` (Sprint 029's join table, populated as each cluster loaded) — see "Venue Setup and Equipment Configuration" below.

### Task method vocabulary (10 values, all in use)
`Tick`, `Data`, `Data + Tick`, `Data + Note`, `Tick + Photo`, `Data + Photo`, `Note`, `Note + Photo`, `Tick + Note`, `Multi` (a multi-part checklist within one task, e.g. "Deep clean checklist"). The original 8 (Sprint 023) gained `Data` and `Data + Note` during Cluster A, once real tasks needing a plain numeric reading (no tick/photo) or a numeric-reading-plus-note combination actually came up.

### Task priority levels (unchanged — three levels)
Critical / High / Standard, stored in `TaskTemplate.priority` (Sprint 023) alongside the legacy `isCritical` boolean (`isCritical = priority == critical`, one source of truth). No change from the original taxonomy.

### Task frequency vocabulary (13 named values + a free-text escape hatch)
`Daily`, `Weekly`, `Per Shift`, `3x Daily`, `2x Daily`, `Per Batch`, `Per Delivery`, `Per Use`, `Per Service`, `2x Per Service`, `Event-Based`, `As Needed`, `Monthly` — plus `Custom` (free-text detail, for anything the named vocabulary doesn't cover). Sprint 023 established the first 11; Sprint 030 (Clusters A/B) added `2x Daily`, `Per Service`, and `Monthly` once real tasks needing them appeared. "Per order", "Per menu change", and "Per visit" (contractor visits) all fold into `Event-Based` rather than getting their own values — treated as instances of the same underlying concept (an irregular, trigger-driven cadence rather than a fixed schedule).

### Equipment types (63, not 18 — Sprint 028)
Expanded from the original 18-type list (Sprint 011, derived from the now-retired "Full check list.docx") to 63 types via `HORECA_EQUIPMENT_AND_VENUES.md` Part A, covering the ALL-HoReCa target market's full range (beverage, prep machinery, bakery, cold-storage variants, wash-up, ventilation/safety, non-refrigerated storage). See `staff_management_screen.dart`'s and the venue setup wizard's equipment picker for the live list; managers can still add anything missing via "Something else...".

### Venue types (12, tagging structure — Sprint 029/030)
12 canonical venue types (Quick Service/QSR, Fast Casual, Casual Dining, Fine Dining, Café, Bakery/Patisserie, Bar/Pub, Gastropub, Hotel, Contract/Institutional Catering, Event/Mobile/Street Food, Dark/Ghost Kitchen), from `HORECA_EQUIPMENT_AND_VENUES.md` Part B. Sites are tagged with one or more venue types (Sprint 029); tasks, presets, and equipment types can each be tagged too, filtering what's offered at setup — a **default-offering aid, not a hard lockout** (a café that happens to have a fryer can still add fryer tasks manually). All 21 segments are now tagged (Sprint 030); equipment-type and preset-level tagging remain schema-ready but unpopulated — see "Open / Not yet decided" in DECISIONS_LOG.md.

## Legal Limit Compliance (confirmed)
Where a task's limits relate to a legal requirement (e.g. fridge, freezer, and hot-hold temperatures), those limits are checked against a legal-minimum reference table.

An attempt to configure a task's limit outside the legally allowed range must trigger a warning at setup time.

## Enforcement Model
The app must support:
- time-based task triggering
- role-based task assignment
- hard blocking for critical incomplete tasks
- logged manager override
- task escalation
- immutable submission history

## Override Rules
Overrides are allowed only for authorised roles.

Every override must record:
- who overrode
- when
- why
- what task was overridden

Overrides must remain permanently visible in logs and reporting.

## Reassignment Rules
Managers may reassign tasks when needed.

Every reassignment must record:
- original owner or role
- new owner or role
- reason
- timestamp
- manager identity

The system must support temporary role flexibility without destroying accountability.

## Venue Setup and Equipment Configuration (confirmed)
Venues are configured through a guided, intuitive setup wizard covering:
- equipment
- operational points/areas
- staff and their roles

Equipment supports multiple named instances of the same type (e.g. Fridge 1, Fridge 2), set up per venue by the manager/top tier. The seeded equipment type library (63 types as of Sprint 028 — see "Task Library Source Content" above) is derived from the same research source that now supplies the full task library; managers can add further types inline if theirs isn't listed.

## Company Branding (confirmed)
Company/branch branding — colours, logo, contact info — is controlled by the top tier.

## Staff Onboarding and Task Assignment (confirmed)
During onboarding, a manager:
- selects staff for the venue
- assigns tasks and frequency to staff, using a tick-box library of pre-built tasks
- can add custom tasks beyond the library

## Language Principle
The UI must support multilingual use.

Each staff member selects their own display language — this is a per-user setting, not a single device-wide setting, since devices are shared across a shift.

The app must not rely on language alone to function.
Tasks must be supported by icons, colour, simple controls, and obvious task states.

Supported roadmap languages:
- English
- Arabic
- Turkish
- Mandarin Chinese
- Urdu
- Hindi
- Bengali
- Punjabi
- Italian
- Portuguese
- Spanish
- Polish
- Romanian

Compliance logs and formal exports remain in English.

## Offline-First Principle
The app must work offline.

Rules:
- submissions must work without internet
- local device timestamp must be preserved
- sync timestamp must also be stored
- no data loss
- no fake re-timestamping during sync
- each device queues entries locally with a timestamp and syncs when reconnected
- sync is additive only — entries are never merged or overwritten
- the manager dashboard must show a "not yet synced" indicator for entries pending sync

## Units (confirmed)
The app must support both metric and imperial units, and both Celsius and Fahrenheit, wherever a task records a measurement.

## Data Integrity Rules
- no editing after submission
- every submission tied to user ID
- every submission tied to timestamp
- every action tied to site, area, and task
- failed critical tasks require corrective action or escalation
- immutable logs are non-negotiable

## Audit Trail and Versioning (confirmed, extends Data Integrity Rules)
The audit trail is append-only and versioned. Nothing is ever overwritten.

When a manager changes task setup (e.g. limits, frequency), that change creates a new version. The old version remains visible in the audit trail rather than being replaced.

## Shift Model
Each day is structured into:
- Open
- Mid
- Close

Critical tasks may block completion of a phase.

Shift handover carries notes forward between shifts.

At the end of a session, an end-of-session summary (pass/fail results plus any triggers fired) can be sent to a selected manager.

## Notifications (confirmed)
Trigger notifications (e.g. a reading outside its configured limit) are configurable by top and/or mid tier, via push and/or email.

Top tier can override mid-tier notification settings.

## MVP Scope
MVP includes only:
- task engine
- role-based task delivery
- HACCP logging
- cleaning schedules
- manager view
- incident logging
- daily reporting
- basic multi-site dashboard

MVP excludes:
- payroll
- rota scheduling
- recipe management
- supplier ordering
- advanced AI features
- IoT integration
- maintenance platform complexity beyond fault logging

## Expanded Scope — Full Vision (confirmed, supersedes the MVP boundary above)
The product scope has expanded beyond the original MVP definition above. The following are now confirmed in scope, sequenced across Sprints 006–018 in MASTER_PLAN.md:
- three-tier role model (top / mid / base)
- configurable task library (grouped by segment/role, site-editable, trigger events, fix instructions, if/then logic, custom fields and methods)
- legal-limit reference checking
- venue setup wizard (equipment, operational points, staff and roles)
- multi-instance equipment configuration per venue
- company/branch branding controlled by top tier
- staff onboarding with task assignment from a tick-box library, plus custom tasks
- shift handover and end-of-session summary/report
- configurable trigger notifications (push/email), with top-tier override of mid-tier settings
- per-user multilingual selection
- versioned, append-only audit trail covering task configuration changes, not just submissions
- offline queue with additive-only sync and a manager-visible "not yet synced" indicator
- unit support (metric/imperial, Celsius/Fahrenheit)
- inspection data export restricted to top tier
- a later visual/UX redesign pass

The original MVP exclusions above (payroll, rota scheduling, recipe management, supplier ordering, advanced AI, IoT, maintenance-platform complexity) still stand — none of the expanded scope above changes what this product must not become (see "What This Product Is Not").

## Success Definition
The product succeeds if:
- staff complete the right tasks at the right times
- managers can see missed work immediately
- directors can compare sites and spot risk
- compliance records are stronger than paper
- the system is faster and harder to fake than paper

## Non-Negotiables
The following must never change without explicit approval:
- one-task-at-a-time staff flow
- role-based visibility
- hard enforcement logic
- immutable logs
- offline-first behaviour
- multilingual readiness
- minimal typing
- action-first UX
- append-only, versioned audit trail — task configuration changes must never overwrite a prior version
