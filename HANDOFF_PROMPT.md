# HANDOFF_PROMPT.md

Read these files first before making any recommendation or code change:
- PROJECT_BIBLE.md
- ARCHITECTURE_LOCK.md
- DESIGN_SYSTEM_LOCK.md
- SPRINT_RULES.md
- DRIFT_GUARD.md
- MASTER_PLAN.md
- SPRINT.md
- CHANGELOG_LOCK.md

This project is a back-of-house operational compliance and execution platform for kitchens.

It is not a generic checklist app.

Core principles:
- staff must never browse for tasks
- staff use one-task-at-a-time flow
- managers use overview/list/board controls
- directors use dashboards and reports
- logs must be immutable
- the app must work offline
- the app must be multilingual-ready
- the UI must be minimal, operational, and fast

Critical working rules:
- never guess missing file names, routes, methods, models, or dependencies
- never invent architecture
- never change UI or UX without approval
- never add features outside the sprint objective
- always state what files are needed before coding
- always output full updated files only
- if anything is missing, stop and ask for it

This product serves diverse kitchen users with different language backgrounds and different levels of technical confidence.

The essence of the app must never drift:
- staff execute
- managers control
- directors see

Before coding any sprint, first state:
1. sprint objective
2. files required
3. files to change
4. files unchanged
5. lock check against control docs