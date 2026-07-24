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

## Phase 6: Offline Persistence
Goals:
- local storage
- queued sync-ready model
- sync state tracking

Deliverables:
- offline submission storage
- sync status fields
- audit-safe timestamps

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

## Phase 8: Language Support
Goals:
- translation structure
- language switch support
- translation-safe UI

Deliverables:
- localisation groundwork
- short label compliance
- language-ready components

## Standing Non-Negotiables
- no feature creep
- no generic app drift
- no architecture drift
- no visual drift
- no weakening of audit logging
- no weakening of role-based visibility

## Current Priority
Build the smallest solid version of the staff task engine and manager control layer without compromising architecture.