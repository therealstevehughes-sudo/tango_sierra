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
    venue_setup/
    onboarding/
    branding/
    notifications/
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
Staff UI, Manager UI, and Top-tier UI are different products inside the same app.

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

Top-tier UI:
- dashboards
- trends
- site comparison
- exports
- branding controls
- notification-override controls

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

Sync is additive-only: a synced record must never be merged with or overwritten by a later write.

## Core Entities
The data model must support these entities:
- Organisation
- Brand
- BrandingConfig
- Site
- Area
- User
- Role
- Shift
- EquipmentType
- Equipment
- TaskTemplate
- TaskSchedule
- TaskInstance
- TaskSubmission
- PhotoEvidence
- Incident
- CorrectiveAction
- CleaningItem
- TemperatureRecord
- LegalLimitReference
- Notification
- NotificationRule
- OverrideLog
- ReassignmentLog
- Report
- ThirdPartyContact

Notes on entities above:
- `BrandingConfig` — company/branch branding (colours, logo, contact info), scoped to Organisation/Brand, editable by top tier only.
- `EquipmentType` — the general category of equipment (e.g. "Fridge", "Freezer", "Hot-hold unit"). `Equipment` represents a specific named instance of a type, tied to a Site/Area (e.g. "Fridge 1", "Fridge 2").
- `LegalLimitReference` — reference table of legal min/max values (plus unit) per task/measurement type (e.g. fridge/hot-hold temps), used to validate `TaskTemplate` limits at configuration time.
- `NotificationRule` — configurable trigger-notification rules (which trigger, which tier/user, channel: push and/or email, who set it, override flag). Distinct from `Notification`, which represents an actual sent/logged notification.
- `Role` carries a required tier attribute: `top`, `mid`, or `base`.
- `ThirdPartyContact` — external/internal maintenance and repair contacts (name, company, specialty, phone/email), kept as a directory for staff to act on manually. Not a `User` (no login, no role tier) and not wired into `NotificationRule` targeting — added to this list when the entity was actually built, not part of the original lock.

## Versioning Rule
Task-library configuration (`TaskTemplate` and other configurable setup entities such as `LegalLimitReference`, `NotificationRule`, `BrandingConfig`) follows the same append-only pattern already used for `TaskSubmission`.

Editing a configuration entity must never mutate the existing row in place. Instead, it creates a new row carrying a `previousVersionId` link back to the prior version. Old versions remain queryable and visible — nothing is ever overwritten.

## Permissions Rule
Permissions are role-driven.
Do not hard-code random visibility into widgets.

Role now carries an explicit tier: top, mid, or base. All role-driven checks must key off this tier, not ad hoc string/role-name comparisons.

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
