# Compliance Library — Source Documents

Downloaded 2026-09-24, UK-only scope (England/Scotland/Wales/Northern Ireland).
This is the source material for the AI helper's knowledge base — the
assistant should only ever answer from what's in here (or a future addition
to it), never from general model knowledge, per the "grounded, not
hallucinated" requirement agreed with the user.

Not yet committed to git — see note at the bottom on the size tradeoff.

## legislation/ — primary law (citation source, not the main retrieval corpus)

| File | Document | Source |
|---|---|---|
| `food_safety_hygiene_england_regs_2013.pdf` | The Food Safety and Hygiene (England) Regulations 2013 | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/2013/2996/contents) |
| `food_hygiene_scotland_regs_2006.pdf` | The Food Hygiene (Scotland) Regulations 2006 | [legislation.gov.uk](https://www.legislation.gov.uk/ssi/2006/3/contents) |
| `food_hygiene_wales_regs_2006.pdf` | The Food Hygiene (Wales) Regulations 2006 | [legislation.gov.uk](https://www.legislation.gov.uk/wsi/2006/31/contents) |
| `food_hygiene_ni_regs_2006.pdf` | The Food Hygiene Regulations (Northern Ireland) 2006 | [legislation.gov.uk](https://www.legislation.gov.uk/nisr/2006/3/contents) |
| `regulation_ec_852_2004_hygiene_foodstuffs_retained.pdf` | Regulation (EC) No 852/2004 on the hygiene of foodstuffs — retained UK law, latest revised version | [legislation.gov.uk](https://www.legislation.gov.uk/eur/2004/852/contents) |
| `regulation_ec_178_2002_general_food_law_retained.pdf` | Regulation (EC) No 178/2002 — General Food Law (traceability, due diligence) — retained UK law, latest revised version | [legislation.gov.uk](https://www.legislation.gov.uk/eur/2002/178/contents) |
| `food_safety_temperature_control_regs_1995.pdf` | The Food Safety (Temperature Control) Regulations 1995 — the 8°C/63°C rule | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/1995/2200/contents/made) |
| `food_information_regs_2014.pdf` | The Food Information Regulations 2014 — labelling law backbone | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/2014/1855/contents) |
| `health_safety_at_work_act_1974.pdf` | Health and Safety at Work etc. Act 1974 | [legislation.gov.uk](https://www.legislation.gov.uk/ukpga/1974/37/contents) |
| `regulatory_reform_fire_safety_order_2005.pdf` | Regulatory Reform (Fire Safety) Order 2005 | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/2005/1541/contents) |
| `gas_safety_installation_use_regs_1998.pdf` | Gas Safety (Installation and Use) Regulations 1998 | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/1998/2451/contents) |
| `environmental_protection_act_1990.pdf` | Environmental Protection Act 1990 (s.34 Duty of Care — waste, incl. waste oil) | [legislation.gov.uk](https://www.legislation.gov.uk/ukpga/1990/43/contents) |
| `workplace_health_safety_welfare_regs_1992.pdf` | Workplace (Health, Safety and Welfare) Regulations 1992 | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/1992/3004/contents) |
| `manual_handling_operations_regs_1992.pdf` | Manual Handling Operations Regulations 1992 | [legislation.gov.uk](https://www.legislation.gov.uk/uksi/1992/2793/contents) |

## guidance/ — practical guidance (the main retrieval corpus — this is the language staff/managers actually use)

| File | Document | Source |
|---|---|---|
| `fsa_safer_food_better_business_caterers_pack.pdf` | Safer Food Better Business (SFBB) for Caterers — FSA's plain-language HACCP pack | [food.gov.uk](https://www.food.gov.uk/business-guidance/safer-food-better-business-for-caterers) |
| `fsa_food_law_code_of_practice_england.pdf` | Food Law Code of Practice (England) — what an EHO actually checks against | [gov.uk](https://www.gov.uk/government/publications/food-law-code-of-practice-and-guidance) |
| `fsa_fhrs_brand_standard.pdf` | Food Hygiene Rating Scheme — Brand Standard | [gov.uk](https://www.gov.uk/government/publications/guidance-on-implementation-and-operation-of-the-food-hygiene-rating-scheme-the-brand-standard-and-statutory-guidance) |
| `fsa_allergen_guidance.html` | FSA Allergen Guidance for Food Businesses (the 14 allergens) | [food.gov.uk](https://www.food.gov.uk/business-guidance/allergen-guidance-for-food-businesses) |
| `fsa_ppds_labelling_guidance.html` | Labelling guidance for prepacked for direct sale (PPDS) food — Natasha's Law | [gov.uk](https://www.gov.uk/government/publications/labelling-guidance-for-prepacked-for-direct-sale-ppds-food-products) |
| `fsa_how_food_hygiene_ratings_work.html` | How Food Hygiene Ratings work | [food.gov.uk](https://www.food.gov.uk/business-guidance/how-food-hygiene-ratings-work) |
| `hse_indg136_coshh_brief_guide.pdf` | HSE INDG136 — COSHH: a brief guide to the Regulations | [hse.gov.uk](https://www.hse.gov.uk/pubns/indg136.htm) |
| `hse_indg458_legionnaires_brief_guide.pdf` | HSE INDG458 — Legionnaires' disease: a brief guide for dutyholders | [hse.gov.uk](https://www.hse.gov.uk/pubns/indg458.htm) |
| `hse_indg143_manual_handling_brief_guide.pdf` | HSE INDG143 — Getting to grips with manual handling | [hse.gov.uk](https://www.hse.gov.uk/pubns/indg143.htm) |

## Known gaps — commercial HSE Approved Codes of Practice, not freely downloadable

These are the fuller, official Approved Codes of Practice behind three of the
free guides above. HSE sells them as printed/PDF books (HSE Books) rather
than publishing them free — the INDG "brief guide" versions above cover the
same legal duties in plain language and are what most businesses actually
work from, but flagging the gap rather than silently substituting:
- **L8** — Legionnaires' disease: The control of legionella bacteria in water systems (full ACOP, INDG458 above is the free summary)
- **L23** — Manual handling: Guidance on the Regulations (full ACOP, INDG143 above is the free summary)
- **L5** — COSHH: Approved Code of Practice and guidance (full ACOP, INDG136 above is the free summary)

If the AI assistant's grounding turns out to need the fuller technical detail
these contain, purchasing them (a few pounds each from HSE Books) would be
needed — not something to source from a free download.

## app_guide/ — first-party VenuRite app-usage content (2026-10-04)

A separate category from the two above, added so the AI assistant could
help with "the entire app" per direct founder request, not just food-
safety/compliance questions (see DECISIONS_LOG.md's 2026-10-04 entry).
Written in-house (no external source URL, unlike legislation/guidance),
plain `.html` files with one `<h2>` per topic so each becomes its own
retrievable chunk — same extraction path `embed_compliance_library.py`
already uses for the FSA `.html` guidance documents above.

| File | Covers |
|---|---|
| `staff_guide.html` | Login, tasks, reporting problems, claiming shifts/days off, shift-verification photos, offline behaviour |
| `manager_guide.html` | Rota calendar, approvals, Master Rota Settings, Fair Auto-Assign, Shift Fairness Review, staff/department management |

Small (plain text, no PDFs) — committed to git directly regardless of
whatever's eventually decided for the legislation/guidance PDF corpus
below.

## On committing this to git

Total size: legislation/ ~9.9 MB + guidance/ ~12.5 MB ≈ **22 MB of binary
PDFs**. Not yet added to git — worth a decision: commit as real project
reference material (permanently in repo history), or keep this folder local
/ `.gitignore`d and treat it as a working cache the future embedding
pipeline reads from directly, re-downloadable from this manifest if lost.
