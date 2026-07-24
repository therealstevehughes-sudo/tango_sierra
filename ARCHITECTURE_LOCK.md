# ARCHITECTURE_LOCK.md

## Purpose
This file prevents architecture drift.

No sprint may introduce a new architecture pattern without explicit approval.

## App Stack
Flutter app built in VS Code.

## Architecture Style
Use a clean, practical feature-first structure.

The project should separate:
- presentation
- domain logic
- data access
- shared design system
- shared services

## Folder Structure Rule
Use this base structure under `lib/`:

lib/
  app/
    app.dart
    routes/
    theme/
  core/
    constants/
    errors/
    utils/
    services/
    storage/
    widgets/
  features/
    auth/
    dashboard/
    tasks/
    shifts/
    incidents/
    cleaning/
    food_safety/
    reports/
    settings/
  shared/
    models/
    enums/
    repositories/
    providers/

## State Management Rule
Use one consistent state management approach only.

Recommended:
Riverpod

If Riverpod is not used, do not mix patterns.
Do not combine Provider, Bloc, setState-heavy architecture, and ad hoc services randomly.

## Routing Rule
Use a single central route strategy.
Do not scatter route logic across random files.

## Model Rule
Shared models live in:
lib/shared/models/

Feature-specific models live inside the relevant feature only if not reused elsewhere.

## Repository Rule
Data access must go through repositories.

UI must not read and write raw storage directly.

## Service Rule
Business logic must not live inside widgets.

Widgets display state and trigger actions.
Services and controllers handle behaviour.

## UI Rule
Staff UI and Manager UI are different products inside the same app.

Staff UI:
- task-first
- minimal text
- fast action
- one thing at a time

Manager UI:
- overview
- list visibility
- issue handling
- reassignment
- override
- sign-off

## Data Layers
The architecture must support:
- local storage first
- sync layer later
- API layer later
- audit-safe logging now

## Offline Rule
Local persistence must be built in from the start.

Every submission record must support:
- local creation timestamp
- sync timestamp
- sync state

## Core Entities
The data model must support these entities:
- Organisation
- Brand
- Site
- Area
- User
- Role
- Shift
- TaskTemplate
- TaskSchedule
- TaskInstance
- TaskSubmission
- PhotoEvidence
- Incident
- CorrectiveAction
- Equipment
- CleaningItem
- TemperatureRecord
- Notification
- OverrideLog
- ReassignmentLog
- Report

## Permissions Rule
Permissions are role-driven.
Do not hard-code random visibility into widgets.

## Design Rule
All styling must come from the design system.
Do not create one-off screen styling unless explicitly approved.

## File Change Rule
Never rename, move, or restructure files casually.
If structural change is needed, it must be stated before coding.

## Sprint Protection Rule
Every sprint must state:
- files being changed
- architecture areas affected
- what remains unchanged