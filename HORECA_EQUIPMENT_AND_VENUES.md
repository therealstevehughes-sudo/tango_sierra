HORECA_EQUIPMENT_AND_VENUES.md — Equipment Types & Venue Applicability (researched)

Companion to HORECA_TASK_LIBRARY.md. Answers questions 2 (equipment) and 3 (venue types) from a researched base. **Content document for review — not yet loaded.**

---

## PART A — EQUIPMENT TYPES (question 2)

The app currently seeds 18 equipment types. Below is the researched comprehensive list a full HoReCa operation could handle, grouped by function. **Bold = likely already in your 18. (NEW) = probably missing and worth adding.** Not every venue has every item — that's what Part B (venue tagging) handles.

### Cold storage / refrigeration
- **Fridge (reach-in)**
- **Freezer (reach-in)**
- **Walk-in cold room**
- Walk-in freezer (NEW — distinct from cold room)
- **Blast chiller**
- Prep/counter fridge (refrigerated prep table / saladette) (NEW)
- Undercounter fridge (NEW)
- **Display / serve-over fridge**
- Refrigerated display case (cakes/desserts) (NEW)
- Bottle / back-bar fridge (NEW)
- Ice cream / gelato dipping cabinet (NEW)

### Cooking — hot line
- **Oven (convection / combi)**
- Deck oven (NEW — bakery/pizza)
- Conveyor oven (NEW — pizza/high volume)
- Pizza oven (wood/deck) (NEW)
- **Grill / chargrill**
- **Salamander / broiler**
- **Hob / range / burners**
- Griddle / flat-top (NEW)
- **Fryer**
- Pressure fryer (NEW — chicken QSR)
- **Steamer**
- Bratt pan / tilting kettle (NEW — high-volume/catering)
- Boiling pan / stock kettle (NEW)
- **Rotisserie**
- **Kebab machine / vertical grill**
- Wok range (NEW — Asian)
- Microwave (NEW)
- Sous-vide bath / water bath (NEW)
- Induction hob (NEW)

### Holding / warming
- **Bain-marie / hot hold**
- Heated gantry / pass / heat lamp (NEW)
- Holding / proving cabinet (NEW — bakery + hot holding)
- Soup kettle / wet well (NEW)

### Prep / processing
- Food processor (NEW)
- Planetary mixer (NEW — bakery/kitchen)
- Slicer (meat/deli) (NEW — currently only a task, not an equipment type?)
- Mincer (NEW)
- Dough sheeter / divider (NEW — bakery)
- Blender / immersion blender (NEW — bar/café/kitchen)
- Vacuum packer (NEW)

### Wash-up / warewashing
- **Dishwasher (pass-through/hood)**
- Glasswasher (NEW — distinct from dishwasher, bar-critical)
- Conveyor/flight dishwasher (NEW — high volume/hotel)
- Pot wash sink / 3-compartment sink (NEW)
- Hand-wash sink (NEW — legally required, worth tracking)

### Beverage
- Coffee machine / espresso (NEW)
- Bean-to-cup / filter brewer (NEW)
- **Ice machine**
- Post-mix / soda system (NEW)
- Beer dispense / cellar cooler (NEW)
- Draught / keg system (NEW)
- Water boiler / hot water dispenser (NEW)
- Juicer (NEW)
- Frozen drink / slush machine (NEW)

### Ventilation / utilities / safety
- Extraction canopy / hood (NEW — currently a task, worth being an equipment type)
- Grease trap / interceptor (NEW)
- Gas interlock system (NEW)
- Fire suppression system (NEW)

### Storage (non-refrigerated)
- Dry store area (NEW — as a checkable "unit")
- Chemical store (NEW)

**Summary:** your 18 cover the core hot line + main cold storage well. The biggest gaps are **beverage** (coffee, glasswasher, beer/cellar, post-mix), **prep machinery** (mixer, processor, slicer as equipment), **bakery** (deck oven, proofer, sheeter), and a few **cold-storage variants** (walk-in freezer, prep fridge, display case). Roughly 30-40 more types for genuinely full coverage — but see Part B: most venues only use a subset.

---

## PART B — VENUE TYPES & APPLICABILITY (question 3)

Researched venue categories in HoReCa, and which task-segments / equipment each realistically uses. This is the basis for **venue-type tagging** so a small café isn't shown banqueting or cellar tasks.

### Core venue types
1. **Quick Service (QSR) / fast food** — high-volume fryers, griddles, pressure fryers; simple menu; heavy on hot-hold and cleaning; usually no table service.
2. **Fast Casual** — QSR + more prep; some FOH.
3. **Casual Dining restaurant** — full hot line, full FOH, bar often present.
4. **Fine Dining** — full hot line + specialist (sous-vide, blast chill), heavy allergen/prep rigour, full FOH, bar/cellar.
5. **Café / Coffee shop** — coffee machines dominant, light food, display fridge, minimal hot line.
6. **Bakery / Patisserie** — deck ovens, proofers, sheeters, mixers, display cases; retail-facing.
7. **Bar / Pub (wet-led)** — cellar, beer lines, glasswasher, ice, optics; limited food.
8. **Gastropub (food-led)** — full kitchen + full bar/cellar.
9. **Hotel** — multiple outlets: breakfast buffet, room service, banqueting, bars, sometimes fine dining — the most complex, multi-segment.
10. **Contract / Institutional catering** (schools, hospitals, care homes) — bratt pans, boiling kettles, cook-chill, extra-strict (vulnerable groups); Scotland reheating rules bite hardest here.
11. **Event / Mobile / Street food** — compact, portable; delivery-temp and handwash challenges.
12. **Dark / Ghost kitchen (delivery-only)** — hot line + packaging/dispatch temp, no FOH.

### Segment applicability matrix (which segments apply)
| Segment | QSR | Café | Restaurant | Fine | Bakery | Bar | Hotel | Catering |
|---|---|---|---|---|---|---|---|---|
| Food safety & temp | ✓ | ✓ | ✓ | ✓ | ✓ | ~ | ✓ | ✓ |
| Allergen | ✓ | ✓ | ✓ | ✓ | ✓ | ~ | ✓ | ✓ |
| Personal hygiene/PPE | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Cooking line equip | ✓ | ~ | ✓ | ✓ | ✓ | ~ | ✓ | ✓ |
| Fryer/oil | ✓ | ~ | ✓ | ~ | ~ | ✗ | ✓ | ✓ |
| Wash-up | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Cleaning/sanitation | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Deliveries/goods-in | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Front of house | ~ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ~ |
| Bar & beverage | ✗ | ~ | ~ | ✓ | ✗ | ✓ | ✓ | ~ |
| Hotel-specific | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ |
| Bakery-specific | ✗ | ~ | ✗ | ~ | ✓ | ✗ | ~ | ~ |
| Waste/pest | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Maintenance | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Stock control | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
✓ = core / ~ = sometimes / ✗ = rarely

### My recommendation on how to use this
- Add a **venue-type tag** to each task/preset, so setup filters to what's relevant.
- When a venue is created, the manager picks its type(s) — the app then offers only relevant presets. This directly attacks the setup-burden problem: a café operator never wades through cellar-line tasks.
- Keep it as **tags, not hard rules** — a café that happens to have a fryer can still add fryer tasks manually. Tags drive the *default* offering, not a lockout.

---

## RECOMMENDATIONS SUMMARY
1. **Equipment:** expand the seeded list from 18 to ~45-55, prioritising beverage, prep machinery, bakery, and cold-storage variants. Full list above.
2. **Venue types:** add ~12 venue types as tags; use them to filter presets/tasks at setup. Biggest single lever against setup burden.
3. **Still needs you / an expert:** confirm which venue types are actually your target ICP (all 12, or a focused subset first?), and a food-safety pro to sign off the Part A limits in the task library before go-live.