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

## Role Principle
Not everyone sees everything.

Each role sees only what it needs to execute or control its responsibilities.

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

## Language Principle
The UI must support multilingual use.

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

## Data Integrity Rules
- no editing after submission
- every submission tied to user ID
- every submission tied to timestamp
- every action tied to site, area, and task
- failed critical tasks require corrective action or escalation
- immutable logs are non-negotiable

## Shift Model
Each day is structured into:
- Open
- Mid
- Close

Critical tasks may block completion of a phase.

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