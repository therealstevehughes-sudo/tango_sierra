# UX & User-Flow Research — VenuRite

**Date:** 2026-09-13
**Status:** Research report only — no code changed. Recommendations are
proposals awaiting your approval before any build. This report is code-grounded:
every tier's "what exists today" is verified against `lib/` files, and every
recommendation names the file(s) it would touch.

---

## Grounding sources

- **Code** — full `lib/` walk: `main.dart`, `app/app.dart`, all tier-home /
  oversight / task / settings / onboarding / export / problems / regions /
  supplier / notifications / drawer / guided-task-header files.
- **Control docs** — `MASTER_PLAN.md`, `SPRINT_RULES.md`, `DESIGN_SYSTEM_LOCK.md`,
  `DRIFT_GUARD.md`, `HANDOFF_NEXT_CHAT.md`, `HANDOFF_PROMPT.md` (project does
  **not** use `ARCHITECTURE_LOCK.md`/`SPRINT.md` — those files don't exist here).
- **UX literature** — Nielsen Norman Group (progressive disclosure / staged
  disclosure, F-shaped reading, 10 usability heuristics: error prevention,
  recognition vs. recall, aesthetic & minimalist design, consistency &
  standards, visibility of system status).
- **Competitor research** — `COMPETITIVE_ANALYSIS.md` (UK + international
  HACCP / food-safety / SFBB apps: Lumiform, Zip HACCP, ComplianceMate,
  Operandio, Jolt, SafetyCulture/iAuditor, FoodDocs, FoodReady, Checkit,
  Navitas, Safefood 360°, SFBB Pro, SFBB+, Hubl, Culinary Key).

---

## 1. The five tiers, with roles, education/skill profile, and today's flow

The tier model lives in `lib/shared/models/user.dart` (`RoleTier` enum, rank
= declaration order) and roles map in `lib/shared/models/job_role.dart` (not
`role.dart`).

| Tier | `RoleTier` (code) | Typical job titles | Skill/education profile | Today's landing & flow (verified) |
|---|---|---|---|---|
| 1 — Staff | `base` | Kitchen Porter, Line Cook, Commis | Lowest; often low literacy, **typing-hostile**, non-native-language, shift workers; work under time pressure & heat; compliance is not their job, tasks are. **Novice, high-frequency, short sessions.** | **Directly into `TaskScreen`** (`lib/features/tasks/task_screen.dart`) — no home hub, no drawer (`TierHomeScreen` is not shown; base gets `task_screen` as `home` in `main.dart`). One task at a time, PASS/FAIL + evidence, guided header with progress + section pill. Fallback = `EndOfSessionSummaryScreen`, then auto-logout. |
| 2 — Supervisor | `supervisor` | Shift lead, Kitchen Shift Supervisor, senior KP | Literate, some typing, knows the venue processes; is a **working supervisor** (assigned tasks too). | **`TierHomeScreen`** (`lib/features/home/tier_home_screen.dart`) hub: "My Tasks" → `TaskScreen` (they also do tasks), "Oversight" → `ManagerScreen` (`lib/features/manager/manager_screen.dart`) — venue-wide tracker, alert banner, overdue summary. Plus `ManagementDrawer` (`lib/core/widgets/management_drawer.dart`). |
| 3 — Manager | `venueManager` | Branch / Venue Manager, Chef de Cuisine as manager, General Manager | Literate, tech-comfortable-enough, owns compliance accountability at one site. **Intermediate** user. | **`TierHomeScreen`** hub: "My Tasks" → `TaskScreen`; "Oversight" → `ManagerScreen`. Drawer: setup checklist, venue details, branch management, staff mgmt, reorder tasks, presets, suppliers, notification rules, maintenance/3rd-party contacts, departments, settings, log out. (Manager tier sees the full venue dashboard — same `ManagerScreen` as supervisor.) |
| 4 — Regional | `regional` | Regional Manager, Area Manager | Comfortable with software, wants at-a-glance multi-site status. **Intermediate → advanced.** | **`TierHomeScreen`** hub; Oversight → **`TopScreen`** (`lib/features/dashboard/top_screen.dart`) — aggregate oversight across the region's sites (regional+ route to `TopScreen`, not `ManagerScreen`, per `TierHomeScreen.oversightScreenFor`). Drawer: also Branch/Region management. |
| 5 — Director/Executive | `executive` | Director, Owner, Operations Director, EHO-facing leadership | Advanced; wants trends, red flags, comparisons, dashboards; low tolerance for drill-in noise. **Advanced, low-frequency.** | **`TierHomeScreen`** hub; Oversight → **`TopScreen`** (same as regional — executive and regional share `TopScreen`, the code routes both here via `oversightScreenFor` since they lack `siteId`). Senior (senior-tier) login is via **`SeniorLoginScreen`** (`lib/features/auth/senior_login_screen.dart`) — the discreet lock icon on the walk-up `LoginScreen`. Drawer: adds Regions management. |

**Key structural observation (verified):** there are effectively **3 distinct
home shells**, not 5: (a) base → straight into `TaskScreen`; (b)
supervisor + manager → `TierHomeScreen` with `ManagerScreen` oversight;
(c) regional + executive → `TierHomeScreen` with `TopScreen` oversight.
The **landing screen logic** is in `lib/main.dart` + `lib/app/app.dart`
(`home:` switch on `roleTier`); the **hub → oversight routing** is in
`TierHomeScreen.oversightScreenFor`. This is good separation — but it means
supervisor and manager currently share the *same master-scoped screen*,
and regional + executive share the *same top screen*, which creates the
per-tier UX gaps below.

---

## 2. Applying UX psychology + heuristics to each tier

### Guiding framework (what the evidence says)

- **Progressive disclosure** (NN/g): show core first, defer advanced to a
  secondary level. Applies to how much management/oversight each tier sees
  and how tasks reveal evidence/pass-fail fields.
- **Staged disclosure** (NN/g): linear one-step-at-a-time wizards are the
  classic fit when a task is a clear sequence with little back-and-forth —
  ideal for **onboarding/setup** and for a **guided task flow**.
- **F-shaped reading** (NN/g): users scan top-left → across → down the left
  edge. Put the tier's **most important action top-left, short scannable
  labels, no walls of text**.
- **Recognition over recall**: show options visibly; don't make managers
  remember multi-site context or staff remember unit conversions.
- **Error prevention / aesthetic & minimalist**: fewer, larger, obvious
  controls; colour for state only (`DESIGN_SYSTEM_LOCK.md` rules).
- **Visibility of system status**: staff need to always know "what am I on
  / what's left" (already partially done via the guided task header's
  "Task 2 of 6" + section pill).
- **Workforce reality (psychology, not just UI):** kitchen staff are
  **tired, rushed, non-technical, often non-native-language, and
  compliance-apathetic** — the app must make the *honest* path the *easy*
  path)Skip any design that asks a base worker to *think* more than a tap.

---

## 3. Evidence-based findings per tier

### Tier 1 — Staff (`base`)

**What's good (keep):**
- Straight to `TaskScreen`, one task at a time, no hub, no menus
  (`task_screen.dart`; `main.dart` base branch). This is textbook
  **staged disclosure + minimal reading** — exactly right for this profile.
- Guided task header (`lib/core/widgets/guided_task_header.dart`): progress
  ("Task 2 of 6"), section pill, instance name — strong **visibility of
  status**.
- Pass/fail + photo + notes, `canSubmit` hard-gating, corrective-action
  path — **error prevention**, honest completion.

**Gaps + recommendations:**

1. **Photo evidence is a stub (now BUILT — 2026-09-13).** At research
   time, `task_screen.dart` set `photoTaken = true` (simulated capture)
   with no real camera/gallery flow. **Resolved in Sprint 032 P0**:
   `task_screen.dart` now runs a real camera-first capture (gallery
   fallback) via `EvidenceStore`, persisting JPEGs into
   `<documents>/evidence/`, and the EHO export's full detailed log embeds
   the actual image bytes. See `PHOTO_EVIDENCE_PLAN.md` /
   `AGENT_CHANGELOG.md` session 6.

2. **No "what's left / light at end of tunnel" between tasks.** The header
   shows per-card progress but there's no session-level "3 of 8 remaining"
   overview screen. Staff on a long shift lose motivation / context.
   → **Recommend:** after each submit return, show a compact "✔ done —
   N remaining in this session" toast/line (recognition + status
   visibility). Touches `task_screen.dart` + `task_controller.dart`
   (already tracks session stats via `EndOfSessionSummaryScreen`).

3. **Skill-tier-agnostic training/handover on entry.** There is a
   `trigger_notifications_banner.dart` and the guided header, and
   `EndOfSessionSummaryScreen` shows a manager-picker — but base staff
   have **no onboarding/training indicator of "what does this task look
   like first"**. For very-low-skill users, a first-run "show me an
   example" inline hint beats trial-and-error.
   → **Recommend (optional):** per-task first-run inline example/helper
   (progressive disclosure of guidance). Touches `task_screen.dart` +
   `task_library`.

### Tier 2 — Supervisor (`supervisor`)

**What's good:**
- Shared `TierHomeScreen` keeps supervisor on a **hub** (My Tasks /
  Oversight) — better than dumping them straight into oversight; they're
  still doing tasks too.
- `ManagerScreen` gives venue-level who/what/status/overdue/reassign/
  sign-off — matches the **Manager Board Rule** in `DESIGN_SYSTEM_LOCK.md`.

**Gaps + recommendations:**

4. **Supervisor sees the exact same `ManagerScreen` as a full venue
   manager.** No supervisor-specific lite view (their scope is the *team
   on shift now*, not the whole venue's full oversight + setup). Same
   `ManagerScreen` = same cognitive load for a lesser-skilled role.
   → **Recommend:** a supervisor-scoped `ManagerScreen` variant (or a
   param) that hides setup/venue-details/supplier/admin drawer items and
   defaults the board to "this shift's site" — progressive disclosure for
   a less-powerful user. Touches `manager/screen.dart` + drawer gating in
   `management_drawer.dart` + `tier_home_screen.dart`.

5. **No "escalation happened" awareness built in at the drawer level.**
   Overdue/FAIL escalation to management is one-directional (worker picks a
   manager in `EndOfSessionSummaryScreen`; no ack loop back to the worker,
   per `SHIFT_HANDOVER`/session summary code). A supervisor who flagged a
   problem can't see it was received.
   → **Recommend:** a lightweight "escalations — pending/acknowledged"
   read for supervisor+ (could piggyback on the existing
   `trigger_notifications_banner.dart` pattern). Touches manager + a small
   provider.

### Tier 3 — Venue Manager (`venueManager`)

**What's good:**
- Hub + full `ManagerScreen` + rich `ManagementDrawer` (staff, tasks,
  presets, suppliers, rules, contacts, departments, settings) — complete
  control surface, consistent with the Drawer Rule.

**Gaps + recommendations:**

6. **Setup checklist (`setup_checklist_card`, `lib/features/onboarding/`)
   is advisory-only; no single "set up my venue" path.** Onboarding is
   split across many separate drawer screens (venue details, staff, branch,
   suppliers, departments, notification rules). A venue manager setting up a
   new site must know which drawer items matter first — high **learning
   curve** for a mid-skill user.
   → **Recommend:** a **staged onboarding/setup wizard** (progressive +
   staged disclosure): Step 1 venue details → Step 2 staff → Step 3 tasks/
   presets → Step 4 suppliers/departments → done. This is the **single
   highest-ROI UX change** for the manager tier Doppler. Keep the existing
   per-screen routes as the advanced/"edit later" secondary level. Touches:
   a new `lib/features/onboarding/venue_setup_wizard_screen.dart`,
   `setup_checklist_card.dart` (each tick deep-links), drawer.

7. **Supplier/equipment/third-party flows are separate screens with no
   link from the guided task form beyond a dropdown.** From reading
   `supplier_management_screen.dart` + the guided task header, a manager
   managing an unapproved supplier must leave the flow to act.
   Minor: acceptable, but the task-form supplier warning (already present)
   could get an inline "manage supplier" shortcut. Low priority.

8. **Multi-site isolation is confirmed correct** (Sprint 02x isolation
   proof) — do not regress it. Any new manager screen must stay
   site-scoped (`getForSite`/`getForOrganisation`), never `getAll()`.

### Tier 4 — Regional (`regional`)

**What's good:**
- `TopScreen` aggregate oversight + region-scoped drawer + regions
  management. Matches Director/executive "red flags + comparisons" rules.

**Gaps + recommendations:**

9. **Regional and executive share the same `TopScreen`.** A regional wants
   per-branch drill-down within *their* region; an executive wants
   cross-region comparison + org-wide red flags. Today both get identical
   aggregate treatment (`oversightScreenFor` returns `TopScreen` for both).
   → **Recommend:** split the "top" view by tier — regional gets
   region-scoped branch list with drill-in; executive gets org-wide
   comparison + trend/red-flag dashboard. Touches `top_screen.dart`/
   `dashboard/top_screen.dart` + a param. **Progressive disclosure of
   scope.**

10. **No per-site filter semantic in `TopScreen` for a multi-site regional.**
    Because regional has no `siteId`, everything resolves via
    `getForRegion`/`getForOrganisation`. Fine — but confirm the UI labels
    "All sites in your region" rather than a generic aggregate, so the
    mental model (recognition) matches. Low-code/QA-only.

### Tier 5 — Director / Executive (`executive`)

**What's good:**
- `TopScreen` + `SeniorLoginScreen` (real Supabase auth) + org-level
  branding + regions management. Matches the Director Rule (dashboards,
  trends, red flags, comparisons).

**Gaps + recommendations:**

11. **Executive and regional share `TopScreen`** (same issue as #9 but
    more acute): a director wants **comparisons across regions/branches**
    and **trends over time**, not just a live aggregate list. The
    `COMPETITIVE_ANALYSIS.md` notes competitors (Checkit, FoodDocs,
    Lumiform) lead with **trend dashboards + per-site comparisons** —
    exactly what the Director tier should own.
    → **Recommend:** an **executive dashboard** (`DashboardScreen` family)
    showing: red flags across all sites, overdue/failed trends over time,
    site-vs-site comparisons. Touches `dashboard/` + `top_screen.dart` +
    `tier_home_screen.dart` routing. **Biggest Tier-5 ROI.**

12. **Branding is partly wired but the brand lockup** (`BrandHeader` in
    `lib/core/widgets/brand_header.dart`) is used on tier-home; confirm it
    also surfaces on the executive/regional oversight screens so leadership
    sees the org identity everywhere (branding consistency). QA/consistency.

---

## 4. Cross-tier / structural findings (all tiers)

13. **Login model is intentionally walk-up for base, but the tier switch is
    hidden.** `LoginScreen` (`auth/login_screen.dart`) lists staff for
    walk-up PIN login; leadership uses a discreet lock →
    `SeniorLoginScreen`. This is a deliberate **progressive-disclosure**
    split (good) — but a new user (any tier) has **no onboarding wizard on
    first launch**: they land on the staff list, and org setup is only
    reachable once you have an executive account. For a product whose
    differentiator is enforcement-heavy setup, a first-run "set up your
    company" path (or a clear "I'm the manager/owner" entry point) would
    close the adoption hook. Touches `login_screen.dart` + onboarding.

14. **Navigation is push-based and tier-home is the only hub.** All deeper
    screens push on top; there's no persistent bottom nav / breadcrumb
    beyond the drawer on non-base tiers. For manager+ users with many tools
    this is fine (drawer), but the **base tier's exit is `Log out` in the
    AppBar** (`TaskScreen` app bar actions) — any staff who finish their
    session correctly auto-route to `EndOfSessionSummaryScreen` (good).
    Verify base never gets stranded after a summary (current code pops to
    root + logs out — consistent).

15. **Language/multilingual is planned but not visible.** With a
    non-native-language workforce (a stated market reality), translation is
    a **differentiator** — keep it on the roadmap; design labels short
    (already enforced by `DESIGN_SYSTEM_LOCK.md` Language Rule).

---

## 5. Prioritised recommendation backlog (for your approval)

Priorities by (value × effort) — all are **proposals**; nothing is built
without your go-ahead.

| # | Priority | Tier(s) | Change | Primary files | Why |
|---|---|---|---|---|---|
| A | **P0** | Manager | **Staged "set up my venue" wizard** (venue → staff → tasks → suppliers) + deep-linkable setup checklist | new `onboarding/venue_setup_wizard_screen.dart`, `setup_checklist_card.dart`, `management_drawer.dart` | #1 adoption/onboarding barrier; our biggest differentiator is enforcement-heavy setup; competitors all excel here |
| B | **P0** | Executive | **Executive/trend dashboard**: org-wide red flags, overdue/failed trends, site-vs-site comparison | `dashboard/`, `top_screen.dart`, `tier_home_screen.dart` | #11; matches market leaders (Checkit/FoodDocs/Lumiform) + Director Rule |
| C | ~~P1~~ **DONE** | Base | ~~Real camera/photo capture (currently a stub), evidence stored + exported~~ **Built 2026-09-13 (Sprint 032 P0)** | `task_screen.dart`, `evidence_store.dart`, EHO export | Load-bearing compliance artifact; security-relevant |
| D | **P1** | Supervisor | **Supervisor-scoped oversight view** (hide admin drawer items; default to this shift's site) | `manager/manager_screen.dart`, `management_drawer.dart`, `tier_home_screen.dart` | #4; right cognitive load for a lesser-skill tier |
| E | **P2** | Regional/Exec | **Split the top view by tier** (regional: region branch drill-in; executive: cross-region comparison) | `dashboard/top_screen.dart`, `tier_home_screen.dart` | #9/#11; progressive disclosure of scope |
| F | **P2** | Base | Session-level "N remaining" feedback after each submit | `task_screen.dart`, `task_controller.dart` | #2; status visibility + motivation |
| G | **P2** | All | First-run onboarding entry point on login for new tenants/managers | `login_screen.dart`, onboarding | #13; closes the adoption hook |
| H | **P3** | Base | Per-task first-run inline example/helper | `task_screen.dart`, task library | #3; low-skill learnability |

---

## 6. What I deliberately did NOT recommend (scope guard)

Per `SPRINT_RULES.md` / `HANDOFF_PROMPT.md` — no drift, no feature creep,
no UX changes without approval:
- **No IoT/temperature sensors** (backend + hardware partnerships; long
  horizon, per `COMPETITIVE_ANALYSIS.md` — explicitly deferred).
- **No AI plan generation** (v2; needs backend first; keep AI at
  setup/config layer, never daily logging).
- **No changing the base staff minimalism** (one-task-at-a-time, no menus —
  this is a strength; recommendations only add state visibility, not
  options).
- **No multi-site repo API changes** (isolation is proven; any new manager
  screen stays site-scoped).
- **No launcher/app-icon work suggested here** — that's a separate,
  already-tracked branding item (see `HANDOFF_NEXT_CHAT.md`), not a UX-flow
  change.
- **No removal of existing screens** — all recommendations are additive /
  split / gating, preserving the existing drawer + per-screen routes as
  the advanced disclosure level.

---

## 7. Suggested next step

Pick one of the P0s and I'll write the specific **sprint preamble** (objective +
files needed + files to change + files unchanged + lock check) exactly per
`SPRINT_RULES.md` before touching any code. My recommendation order:
**A (set-up wizard) first** — it converts the product's core differentiator
into onboarding and is the change with the clearest, most immediate value
for the tier best able to drive adoption.
