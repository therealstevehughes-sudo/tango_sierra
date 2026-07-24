# SPRINT_RULES.md

## Purpose
This file defines how every sprint must be run.

## Core Sprint Rule
No sprint starts until the objective is stated in one sentence.

## Mandatory Sprint Format
Every sprint must include:
1. Sprint objective
2. Files needed
3. Files to be changed
4. Files that remain unchanged
5. Lock check against control documents
6. Full file outputs only
7. Save point after completion

## Hard Rules
- no guessing
- no hallucinating file names, classes, methods, or dependencies
- no partial snippets if full file replacement is required
- no architecture drift
- no visual drift
- no adding features not in scope
- no changing behaviour without approval

## File Output Rule
When coding, output full updated file contents only.

## Missing File Rule
If a required file is missing, stop and request it before changing anything.

## Sprint Size Rule
Keep sprints small enough to stay safe.
Recommended:
6 to 8 files maximum per sprint

## Approval Rule
No structural changes without explicit approval.

## End of Sprint Rule
At the end of each sprint, record:
- what changed
- what did not change
- risks
- deferred work
- save point name

## Save Rule
After each sprint:
- create a backup point
- update CHANGELOG_LOCK.md
- do not continue until the save point exists