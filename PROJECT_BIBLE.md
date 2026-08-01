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

## Role Tier Model (confirmed — expands the flat Primary/Secondary grouping above)
Every user belongs to one of three tiers. This is the formal permissions model going forward; the named titles above are examples of who typically sits in each tier.
- **Top tier**: C-suite / company-wide oversight. Sees company-wide data and stakeholder-facing reporting. Controls company/branch branding. Can override mid-tier notification settings. Only tier with access to inspection data export.
- **Mid tier**: managers and supervisors. Assign tasks, manage staff, run venue setup, get notified on trigger events (threshold breaches, escalations).
- **Base tier**: workers. Task execution only — see what's due now, what's overdue, what to do next.

Exactly which named titles above map to which tier (e.g. whether Area Manager and Operations Manager both sit at "top", or whether one is "mid") is to be confirmed as part of Sprint 006, not assumed here.

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

## Task Library Source Content (confirmed)
The real task/equipment library content — what the ~100+ tasks in "Task Library Model" above will actually be — comes from a single authoritative source: **"Full check list.docx"** (Documents\AA Tango Sierra\Full check list.docx). This section captures its structure so the app's `segment`, method, priority, and frequency vocabulary stays aligned with it as the real library gets loaded in a future sprint. The full line-by-line task list (~100+ individual rows) is not reproduced here — it lives in the source document; this is the taxonomy, not the data.

### Operational segments
These map directly onto `TaskTemplate.segment` and are the canonical list going forward, in place of the ad hoc placeholder values (`food_safety`, `cleaning`, `custom`) used by Sprint 007/009's illustrative seed data:
1. Food Safety & Temperature Control — Refrigeration Temperatures, Food Temperature Control, Delivery Checks
2. Refrigeration System Control — Physical Condition, Internal Conditions, Storage Compliance, Fault Detection
3. Fryer & Oil Management — Oil Quality, Oil Usage, Fryer Equipment, Cleaning
4. Cooking Line Equipment — Core Equipment, Specialist Equipment, Mechanical Checks
5. Cleaning System — Surface Cleaning, Equipment Cleaning, Floors & Structure, Deep Cleaning
6. Cleaning Chemicals & Consumables — Stock Levels, Correct Usage, Equipment
7. Cooking Consumables — Core Items, Packaging Materials, Operational Consumables
8. Service Consumables
9. Dry Store — Organisation, Compliance, Risk
10. Wash-Up & Serviceware — Machines, Items, Availability
11. Smallwares & Utensils
12. Utilities & Safety
13. Service Readiness
14. Opening & Closing
15. Waste & Pest Control
16. Preventive Maintenance
17. Incident Logging
18. Staff Accountability
19. Stock Control

Segments 17 (Incident Logging) and 18 (Staff Accountability) are different in kind from the rest — they describe behaviour this app already models through other entities (`Incident`, `OverrideLog`, the audit trail) rather than new carousel task types. Segments 1–16 and 19 are genuine task-library content.

### Task method vocabulary (found in the source, not yet fully matched by the schema)
The checklist's real "method" column uses: Tick, Data + Tick, Tick + Photo, Data + Photo, Note, Note + Photo, Tick + Note, and Multi (a multi-part checklist within one task, e.g. "Deep clean checklist"). This is richer than the placeholder `method` strings (`numeric_photo`, `categorical_choice`, `notes_only`) used in Sprint 007/009's example data — a future task-library-loading sprint should treat the checklist's own vocabulary as canonical, not the placeholders.

### Task priority levels (a real gap against the current schema)
The source uses **three** priority levels — Critical, High, Standard — not the binary `isCritical` flag `TaskTemplate` currently has. Flagging this now rather than silently working around it later: loading the real library will need either a 3-level priority field or an agreed mapping down to the current boolean (e.g. Critical → `isCritical: true`, High/Standard → `false`), which loses information either way. Not resolved here — this is a docs-only pass — but the decision shouldn't be made implicitly when that sprint arrives.

### Task frequency vocabulary (broader than the current schema)
The source uses: 3x daily, daily, per use, per batch, 2x per service, per delivery, weekly, event-based, per shift, and as-needed. Sprint 009's `ScheduleFrequency` enum (daily/weekly/per-shift/custom) covers some of these directly and would fold the rest (3x daily, per batch, per delivery, per use, 2x per service, as-needed, event-based) into `custom` with a free-text detail — workable for now, but worth knowing the real vocabulary is wider than the enum suggests.

### Equipment types (already reconciled — Sprint 011)
The equipment-relevant sections above (2, 3, 4, 10) informed the 18-type `EquipmentType` seed list already built in Sprint 011 (Fridge, Freezer, Hot-hold unit, Blast Chiller, Walk-in Fridge, Walk-in Freezer, Fryer, Oven, Grill, Salamander, Hob, Rotisserie, Kebab Machine, Bain-marie, Steamer, Dishwasher, Ice Machine, Prep Station). This part of the reconciliation is done, not pending — noted here for completeness, not as outstanding work.

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

Equipment supports multiple named instances of the same type (e.g. Fridge 1, Fridge 2), set up per venue by the manager/top tier. The seeded equipment type library (18 types as of Sprint 011 — see "Task Library Source Content" above) is derived from the same checklist that will eventually supply the full task library; managers can add further types inline if theirs isn't listed.

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
