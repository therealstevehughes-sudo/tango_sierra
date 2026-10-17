# Equipment library: plan for review (2026-10-17)

**What you asked for:** a database of niche equipment, such as combi ovens, pizza ovens, rotisseries, ice machines and sous-vide baths. It must be available to every venue without making the app heavy.

## How it works today
- There are 63 general equipment **types** (Fridge, Freezer, Fryer, …), each a name only.
- A venue adds an item, e.g. "Fridge 2", picks its type, and assigns tasks from the library.
- There is nothing **model-specific**: no "Rational iCombi Pro 6-1/1" with its own cleaning cycle, descale interval or manual.

## Proposal

**1. A server-side catalogue, not in the app**
- New `equipment_models` table on the server. Each entry holds:
  - manufacturer, model and type;
  - typical checks, with frequencies;
  - training-guide steps, plus quiz questions;
  - service and descale intervals;
  - the manufacturer's manual link;
  - safe operating ranges, e.g. fryer 160–185°C.
- The app downloads nothing up front. When a manager adds equipment, they **search** ("iCombi", "Frima", "Hoshizaki") and only that one entry is fetched.
- This keeps the app small however big the library grows.

**2. Adding a model brings its "pack"**
- Picking a model offers its checks, guides and quiz in one tap, to assign to staff.
- This uses the existing task and guide system, so nothing new for staff to learn.
- Everyone at that branch gets it on their next app open. No downloads or plug-ins (as agreed earlier).
- Optional push to staff: "New equipment added: Frima VarioCooking — guide ready" (you said yes earlier).

**3. When a model isn't listed**
- The manager types the make and model. VenuRite's AI drafts a pack from public information: manual, cleaning cycle, service interval.
- The **manager must review and approve** it before staff see it. This is the same rule as the AI quiz questions.
- Approved packs from venues go into a **review queue for us**. Once checked, they're added to the shared library, so the library grows with use.

**4. Building the library**
- **Start with about 150 models**: the most common UK commercial kitchen brands (Rational, Frima, Merrychef, Lincat, Falcon, Foster, Williams, Hoshizaki, Winterhalter, Hobart, Valentine, Pitco, Turbochef).
- I research and write each pack, then check it like the quiz bank: numbers checked against manufacturer documents, and sources recorded.
- Manufacturer manuals are **linked, not copied**, because of copyright.

**5. Later**
- Sensor pairing: a model entry can say which sensor/probe fits, e.g. a fryer oil probe.
- Equipment age and service history, giving reminders when a service is due.

## Costs and limits
- **Hosting:** negligible. Text and links only, a few MB.
- **AI drafts:** roughly 1–2p each.
- **Honest limit:** manufacturer details change. Each pack shows "checked on <date>" and links the source. The venue's own manual always wins.
- **Effort:** the database and screens are about 2–3 days. The first 150 models take longer, because each needs checking.

## Decisions for you or your helper
```
1. Approve the plan: server catalogue + search, one-tap packs, AI drafts for unlisted models (manager approves), community packs reviewed by us?
2. Start with ~150 common UK models from the brands listed? Add any brands you know your pilot venues use.
3. Notify staff when new equipment is added? (You said yes earlier — confirm it still stands.)
```
