# FEATURE_AUDIT.md

Devil's-advocate pass over every feature built or planned so far. For each: entry/input/edit/exit criteria, then real gaps worth deciding on. Not all of these need fixing — some are fine to accept as-is. Flagged where I think action is actually warranted vs. just worth knowing about.

---

## 1. Auth & Roles (three-tier)
**Entry:** name tile + PIN. **Edit:** none yet. **Exit:** auto-return to login on session end (base) / manual logout (mid/top).

Gaps:
- **No PIN reset flow.** If staff forgets their PIN, who fixes it? Right now: nobody, in-app. Needs a manager-initiated reset. **Worth fixing soon** — this will happen constantly in real use.
- **No deactivate-staff-member flow.** Someone leaves the job — can they still log in forever? Need an `active` flag (not delete, matches your append-only pattern), settable by mid/top.
- **No lockout/throttling on repeated wrong PINs.** Low risk on a local device, but worth a basic attempt-limit eventually.
- **Single top-tier user is a single point of failure.** If Alex Rivera's device is lost, is anyone else able to act as top tier? Worth at least two top-tier accounts per real deployment — a documentation/process note, not necessarily a code fix.

## 2. Venue Setup (Areas/Equipment)
**Entry:** wizard, mid/top only. **Input:** name + type. **Edit:** none built — add-only so far. **Exit:** none, ongoing.

Gaps:
- **No edit or retire for Areas/Equipment.** A fridge breaks and gets replaced — do you rename the old row, or is there no way to mark equipment as retired while preserving its submission history? **This will happen in real kitchens constantly — worth prioritizing.**
- **No venue detail edit (name/address).** Schema exists, no UI.
- **What happens to a TaskSchedule if its equipment instance is retired?** Needs a defined behavior (auto-deactivate the schedule, or orphan it silently — the latter is bad).

## 3. Task Library (TaskTemplate)
**Entry:** manager creates during assignment, or from the seeded library. **Edit:** versioned (Option B). **Exit:** n/a, persistent.

Gaps:
- **The three open taxonomy gaps already logged** (priority levels, method vocabulary, frequency vocabulary) — still blocking the real 100+ task library from loading. This is the single biggest thing standing between "prototype" and "real product."
- **No template duplication/"start from an existing task."** Manager wants a near-identical task for a second fryer with a slightly different limit — currently has to build from scratch every time.
- **No preview.** Manager can't see what a task will actually look like to staff before assigning it.
- **No archiving distinct from versioning.** If a task genuinely stops applying (equipment removed, process changed), does it just sit forever as an assignable option?

## 4. Staff Assignment (TaskSchedule)
**Entry:** manager picks staff → ticks tasks. **Edit:** toggle active/inactive. **Exit:** n/a.

Gaps:
- **No bulk assignment.** Assigning the same task to 6 base-tier staff members is 6 separate ticks. Real friction at real venue setup.
- **No temporary pause vs. permanent unassign** (staff on holiday/leave — do they still show as assigned?).
- **Deliberately no due/overdue tracking yet** (already flagged as out of scope for Sprint 010) — worth revisiting priority on this, since "did anyone actually do the 9am fridge check" is core to compliance, and today the carousel is just "everything assigned," with no sense of *when* it's due.

## 5. Task Carousel / Submission
**Entry:** login → assigned tasks. **Input:** varies by method. **Edit:** none — submissions are final by design. **Exit:** all-done → summary.

Gaps:
- **No draft/resume if interrupted.** Phone dies, app force-closes mid-task — is partial input lost? Given kitchen conditions, this will happen.
- **No multi-photo support.** Some tasks may genuinely need two photos (e.g., display reading + stock arrangement). Right now it's one toggle.
- **Timestamp trust: device clock, not server time.** Since it's local-only right now, a staff member could theoretically change their phone's clock. Worth flagging as a known limitation, address when backend/sync exists.
- **Pass/fail indicated by color alone in places?** Worth an accessibility check once visual design (Sprint 018) happens — colorblind staff shouldn't rely on red/green alone.

## 6. Shift Handover
**Entry:** end-of-session screen. **Input:** free text, optional. **Edit:** none. **Exit:** shown once at next login.

Gaps:
- **No history.** Once the next person logs in and it's shown, is the old note gone, or does it just get overwritten by the next one? If overwritten, there's no record of what handover info existed on a given day — worth deciding if that matters for compliance.
- **Free text only, no structure.** A genuinely important note ("fryer 2 heating element is failing") could get buried in unrelated chit-chat text. A simple "flag as important" checkbox might help.

## 7. Notifications
**Entry:** rule-based, auto-fires on FAIL. **Edit:** versioned. **Exit:** acknowledge.

Gaps:
- **No escalation on non-acknowledgment.** If a critical trigger fires and nobody acknowledges it in, say, 30 minutes, does anything happen? Right now: nothing. This is a real compliance gap — the whole point of a trigger is someone acts on it.
- **No acknowledgment audit trail visible later** (who acknowledged, when) — worth confirming this is actually retained, not just cleared from the inbox view.
- **Third-party/maintenance contacts** — already logged as queued, not yet built.

## 8. Multi-Site Foundation
**Entry:** schema exists. **Input/Edit/Exit:** no UI at all yet.

Gaps:
- **No way to actually add a second site.** The whole point of building this early was to support real multi-venue operators — but there's currently zero UI to create a second Site. This needs to exist before it's useful to anyone.
- **No site switcher for a top-tier user overseeing multiple venues.**

## Cross-cutting (affects everything)
- **No backup/export of the local database.** Everything lives on one device's local drift DB. If that device is lost or damaged, is the data gone? This matters a lot for a compliance app — worth prioritizing before real deployment, even ahead of some feature work.
- **No search** across submissions/tasks/history as data volume grows.
- **No admin audit log viewer** — top tier can't currently see "who changed this task template" or "who assigned this" as a consolidated view, even though the underlying versioned data supports it.

---

## My honest priority read
If I had to pick where real risk sits, in order:
1. **Data backup/export** — losing a device shouldn't mean losing compliance history
2. **Equipment/area edit + retire** — will be needed almost immediately in real use
3. **Non-acknowledgment escalation** — the point of a trigger is someone acts on it
4. **The three task-taxonomy gaps** — blocking the real task library, which is the actual product
5. **PIN reset + staff deactivation** — basic operational necessity

Everything else on this list is real, but lower-stakes or can wait for natural placement in the existing sequence (Sprint 018 for visual/accessibility, multi-site UI once you have a second real site to test with, etc.).
