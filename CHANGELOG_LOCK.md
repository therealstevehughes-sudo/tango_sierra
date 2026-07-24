# CHANGELOG_LOCK.md

## Format
For every sprint, add a new entry using this structure.

---

## Sprint 000
Date: 2026-07-24
Objective: Establish an initial save point — commit the existing working tree exactly as-is, with no code changes, so there is a known rollback point before any reconciliation work begins.
Files changed: none (first commit — all existing files added to version control as-is)
Files unchanged: all (control docs, lib/ prototype, platform folders, pubspec)
Architecture impact: None made in this sprint. Existing drift from ARCHITECTURE_LOCK.md noted but not corrected: no Riverpod (or any state management) in use, no repository layer, no local persistence/offline storage, no core/ or shared/ folders, feature folders limited to auth/tasks/manager.
UI impact: none
Risks: The committed prototype is not aligned to ARCHITECTURE_LOCK.md (see above). Auth is a mock button with no role model, task data and logs are in-memory only (lost on restart), and photo evidence is a boolean toggle rather than real capture. These are pre-existing conditions being recorded, not introduced by this sprint.
Deferred items: Reconciling the prototype to ARCHITECTURE_LOCK.md (state management, repositories, persistence, folder structure) and building out Phase 2 (real auth/roles) — to be scoped in a future sprint.
Save point name: SPRINT_000_LOCK
Notes: Commit ae5cd6ad8f8a86a228ac13f9380e163df4c4d135, message "Sprint 000: initial save point - prototype as-is, architecture drift noted". This is the first git commit in the repo (root commit).

---

## Sprint 001
Date:
Objective:
Files changed:
Files unchanged:
Architecture impact:
UI impact:
Risks:
Deferred items:
Save point name:
Notes: