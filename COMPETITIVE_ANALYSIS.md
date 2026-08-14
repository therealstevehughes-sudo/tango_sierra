# COMPETITIVE_ANALYSIS.md — What competitors have, and what it means for us

Researched Aug 2026. UK + international food-safety / HACCP compliance apps. Sourced from current comparison guides and vendor sites. Purpose: find what leaders have that we don't, spot trends, decide what's worth adopting.

## The players
- **UK, SFBB-focused, cheap:** SFBB Pro (~£24.95/site/mo), SFBB+ (£4.99/site/mo), the free FSA-data "UK Food Safety App", Culinary Key (£33-40/site), Hubl (from £19/site, unlimited users)
- **UK/global platforms:** Navitas, Trail, Checkit, FoodDocs (UK-based, AI plans)
- **International leaders:** Lumiform, Zip HACCP, ComplianceMate, Operandio, Jolt, SafetyCulture (iAuditor), FoodReady, Safefood 360°

---

## What they have that WE DON'T (ranked by how much it matters for us)

### 1. IoT / Bluetooth temperature sensors + probes — THE dominant trend
Nearly every serious platform now integrates hardware: Bluetooth probes (Zip HACCP, Jolt, BAPI) and wireless fridge/freezer sensors that **log temperature automatically, 24/7, with no human involvement** (ComplianceMate, Operandio's 5-year-battery sensors, Navitas). This is the single biggest thing we lack.
- **Why it matters:** it removes the exact weakness we've flagged repeatedly — human, fakeable, point-in-time readings. A sensor logs the fridge at 3am when no staff are there. It's the strongest possible answer to "is this data trustworthy?"
- **Reality for us:** this needs the backend AND hardware partnerships — a long way off. But it's where the market is going, and worth knowing our manual-probe-plus-photo approach is the *entry-level* model, not the premium one.

### 2. AI HACCP-plan / checklist generation
FoodDocs, FoodReady, Lumiform, Hubl ("Orbit" AI) all now **auto-generate a compliant HACCP plan or SFBB pack from a short business profile** — "setup takes days, not weeks." Some do natural-language logging ("log 4°C on Fridge 1, initials AB") and AI-generated reports.
- **Why it matters:** setup burden is the #1 adoption barrier (we've fought this ourselves with presets). AI onboarding is becoming table stakes for the mid-market.
- **For us:** our researched 150-task library + presets is actually a strong manual version of this. An "auto-suggest tasks from venue type" step later would close much of the gap without full AI.

### 3. One-tap EHO / audit export
Universal. Every UK app leads with "EHO-ready PDF at the touch of a button" / "audit pack in one click." Inspectors expect records that *look like* the SFBB pages they know.
- **Why it matters:** this is THE moment of value for a UK operator — the unannounced EHO visit. We have this logged as a feature ("inspection export") but not built. It's arguably more important than the dashboard.
- **For us:** worth pulling FORWARD. It's the single most-marketed UK feature and we're missing it.

### 4. Offline capability
Repeatedly cited as essential: "works in basements, walk-in freezers, poor-signal areas without losing data" then syncs. Lumiform, Paddl, FoodDocs all stress this.
- **For us:** we're offline-by-default right now (local drift DB) — ironically an accidental strength — but real offline+sync needs the backend done properly.

### 5. Multi-language for staff — validated
SFBB Pro explicitly markets "AI-powered language change" for diverse kitchen teams. Confirms our multilingual plan is a real market expectation, not a nice-to-have.

### 6. Training records + staff onboarding/induction
Culinary Key, Operandio, SafetyCulture bundle staff training records, new-starter induction, and per-staff safe-method sign-off. Culinary Key includes "new starter induction records" and "staff training record" print-outs as core.
- **For us:** we have staff management but not training-record tracking. A real gap for the UK market (EHOs ask for training evidence).

### 7. Supplier / delivery / traceability registers
Culinary Key, FoodDocs, Safefood 360° include supplier approval registers, delivery records, and one-step traceability as standard.
- **For us:** we have delivery *tasks* but not a supplier register / traceability record. Partial gap.

### 8. FHRS rating integration
Some UK apps pull the venue's official FSA hygiene rating and inspection history into the app.
- **For us:** minor, but a nice UK-specific touch.

---

## What WE HAVE that many DON'T (our strengths — keep and lean into)

- **Enforcement, not just recording.** Most competitors are "digital diaries" — they record what you type. Our corrective-action gating, trigger escalation (one-tier-up, non-acknowledgment), and "reported-to-manager-and-continue" flow are genuinely stronger accountability than a checklist app. Lumiform's "automated corrective action workflows" is the closest, and it's their premium differentiator.
- **Five-tier role hierarchy with escalation.** Most apps have flat "manager/staff." Our tier structure + escalation path is more sophisticated than the mid-market.
- **Anti-cheating design intent** (time-windows, honest-completion scoring, fails-never-hidden). Competitors rarely think about staff *gaming* the system — we've designed against it from the start.
- **Job-role task matching** (porter vs chef). Novel — didn't see this elsewhere.
- **Researched, sourced task library with LAW/FSA/BEST tagging.** More rigorous than a generic template pack.

---

## RECOMMENDATIONS — what to adjust

**Pull forward (high value, mostly buildable now-ish):**
1. **EHO/audit export** — this is the #1 UK selling point and we don't have it. Move it up the roadmap. A clean, one-tap, inspector-friendly PDF/report of a date range's records. Arguably before the dashboard.
2. **Training records** — add per-staff training/induction sign-off. UK EHOs ask for it; competitors all have it. Fits our existing staff management.
3. **Supplier register + traceability** — formalise delivery records into a supplier list + traceable delivery log. Legal requirement, competitors standard.

**Confirm on the roadmap (already planned, market validates):**
4. Multilingual — validated as expected, keep it (still last).
5. Dashboard/site-comparison — Lumiform's per-site performance comparison is exactly our planned dashboard. On track.
6. Offline+sync — we're accidentally ahead here; formalise with the backend.

**Long-horizon (needs backend + partnerships, but it's where the market is):**
7. **IoT temperature sensors** — the dominant premium trend. Not now, but design the backend so sensor-fed readings could slot into the same TaskSubmission model later. Knowing this is coming should shape backend design.
8. **AI onboarding** — auto-suggest tasks from venue profile. Our library+presets is a strong manual base; an AI layer later closes the gap.

**Positioning insight:** the UK market splits into cheap SFBB-diary clones (£5-25/site) and richer multi-site platforms (£19-69/site). Our enforcement/escalation/anti-cheating depth positions us at the **premium/multi-site end** — competing with Lumiform/Hubl/Checkit, not the £5 SFBB clones. Our differentiator is "it actually enforces compliance and resists gaming," not "it's a cheaper diary." Worth leaning into that in how the product is framed.

---

## SCOPE DECISION — this iteration (beta) vs future (v2)

### BUILD NOW (beta-ready core):
- Due/overdue + time-windows (the daily loop)
- EHO/audit export (the #1 UK seller)
- Training records (EHOs expect it)
- Supplier register + traceability (legal requirement)
- Dashboard + worker recognition
- Branding
- Multilingual (last, once wording is settled)
- **The backend** — gates trust, multi-device, real timestamps, sync, real senior auth. The big one; nothing above is truly deployable without it.
- Before deployment: professional sign-off of legal figures; professional translation of task content.

### HOLD FOR v2 (post-beta, let real users guide it):
- **IoT / Bluetooth temperature sensors** — big project, needs backend + hardware partnerships. Premium upsell. Design the backend now so a reading can come from human OR sensor, but build nothing yet.
- **AI-assisted onboarding** (suggest tasks/config from venue profile) — cheap and powerful, but needs the backend first, and beta feedback should shape it before automating. Realistic v1.1. Keep AI at the setup/config layer (infrequent = cheap), never the daily-logging layer (constant = costly).
- **AI must never invent compliance figures** — AI may draft, a human always signs off. Non-negotiable.

### Positioning reminder
Premium/multi-site end of the market. Differentiator = enforcement + anti-gaming, not "cheap checklist." Beta's job is to learn what real kitchens need — launch a strong core, let paying customers pull IoT/AI forward.