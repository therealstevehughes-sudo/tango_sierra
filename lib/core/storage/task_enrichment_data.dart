import '../../shared/models/job_role.dart';

// Data for HORECA_TASK_ENRICHMENT.md's load (Sprint 031) — job-role tag +
// worker-facing guidance text per task title, matched against the current
// version of each already-loaded TaskTemplate (see _ensureTaskEnrichment in
// app_database.dart). 149 of the source doc's 150 rows are here: "Cooling
// log (cooked→chilled)" is deliberately excluded — its title uses an
// arrow character matching HORECA_TASK_LIBRARY.md's own original wording,
// but the template actually loaded by Cluster A (Sprint 030) used "Cooling
// log (cooked to chilled)" instead, so it can't be matched by title without
// guessing. Logged in DECISIONS_LOG.md for the source doc to be corrected.
class TaskEnrichmentRow {
  const TaskEnrichmentRow({
    required this.title,
    required this.jobRole,
    required this.guidanceText,
  });

  final String title;
  final JobRole jobRole;
  final String guidanceText;
}

final List<TaskEnrichmentRow> taskEnrichmentData = [
  TaskEnrichmentRow(
    title: "Fridge temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Read the fridge's display or probe an item. Record the number. Photo the display. Flag if above 8°C.",
  ),
  TaskEnrichmentRow(
    title: "Freezer temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Read the display, record the number, photo it. Flag if warmer than -18°C.",
  ),
  TaskEnrichmentRow(
    title: "Walk-in cold room temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Read the wall thermometer, record it, photo it. Flag if above 8°C.",
  ),
  TaskEnrichmentRow(
    title: "Blast chiller cycle temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Record start and end temperature of the cycle. Food should go from 70°C to below 3°C within 90 minutes.",
  ),
  TaskEnrichmentRow(
    title: "Display/serve-over fridge temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Check the chilled display holding food for service. Record the reading, photo it. Must stay at or below 8°C.",
  ),
  TaskEnrichmentRow(
    title: "Cooked food core temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Probe the thickest part of the food. Record the number, photo it. Must reach 70°C for 2 min (or 75°C).",
  ),
  TaskEnrichmentRow(
    title: "Reheated food core temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Probe the centre of the reheated item. Record it, photo it. Must be piping hot throughout (~70°C; Scotland 82°C).",
  ),
  TaskEnrichmentRow(
    title: "Hot-holding temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Probe food held hot for service. Record it, photo it. Must stay at or above 63°C.",
  ),
  TaskEnrichmentRow(
    title: "Reheat-once verification",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm this item hasn't been reheated before. Food may only be reheated once, then discarded.",
  ),
  TaskEnrichmentRow(
    title: "Probe calibration check",
    jobRole: JobRole.chefCook,
    guidanceText: "Test the probe in iced water (should read ~0°C) and boiling water (~100°C). Record both. Flag if off by more than 1°C.",
  ),
  TaskEnrichmentRow(
    title: "Probe sanitised between uses",
    jobRole: JobRole.chefCook,
    guidanceText: "Wipe the probe with a sanitiser wipe before and after each use.",
  ),
  TaskEnrichmentRow(
    title: "Use-by / best-before date check",
    jobRole: JobRole.chefCook,
    guidanceText: "Check opened and stored items for their dates. Note and remove anything past its use-by date.",
  ),
  TaskEnrichmentRow(
    title: "FIFO stock rotation",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm older stock is in front / used first. Move newer deliveries behind existing stock.",
  ),
  TaskEnrichmentRow(
    title: "Opened-product date labelling",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm opened items are labelled with the date opened. Label any that aren't.",
  ),
  TaskEnrichmentRow(
    title: "Controlled defrost log",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm items are defrosting in the fridge (below 8°C), not at room temperature. Note what's defrosting.",
  ),
  TaskEnrichmentRow(
    title: "Allergen matrix current & accessible",
    jobRole: JobRole.management,
    guidanceText: "Confirm the allergen chart matches the current menu and staff can find it. Update if the menu changed.",
  ),
  TaskEnrichmentRow(
    title: "Allergen review on new/changed dishes",
    jobRole: JobRole.management,
    guidanceText: "For any new or changed dish, record which of the 14 allergens it contains.",
  ),
  TaskEnrichmentRow(
    title: "PPDS labelling correct (Natasha's Law)",
    jobRole: JobRole.management,
    guidanceText: "Check pre-packed-for-direct-sale items have a full ingredient list with allergens emphasised. Photo a sample label.",
  ),
  TaskEnrichmentRow(
    title: "Separate allergen prep area/equipment",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm allergen-free orders are prepped with clean, separate equipment and surfaces.",
  ),
  TaskEnrichmentRow(
    title: "Allergen-free order verified end-to-end",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm the specific allergen-free order was kept separate from prep to plate. Note the order.",
  ),
  TaskEnrichmentRow(
    title: "Purple allergen boards/cloths used",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm the purple (allergen) boards and cloths are used for allergen-free prep.",
  ),
  TaskEnrichmentRow(
    title: "Staff allergen briefing",
    jobRole: JobRole.management,
    guidanceText: "Confirm staff on shift have been briefed on today's allergen info.",
  ),
  TaskEnrichmentRow(
    title: "Handwashing on entry / between tasks",
    jobRole: JobRole.everyone,
    guidanceText: "Confirm hands washed on entering the kitchen and between tasks.",
  ),
  TaskEnrichmentRow(
    title: "Clean uniform / apron",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm clean uniform/apron worn at start of shift.",
  ),
  TaskEnrichmentRow(
    title: "Hair covering / beard net",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm hair covering / beard net worn.",
  ),
  TaskEnrichmentRow(
    title: "No jewellery / false nails",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm no jewellery, false nails, or nail varnish.",
  ),
  TaskEnrichmentRow(
    title: "Fitness-to-work / illness declaration",
    jobRole: JobRole.management,
    guidanceText: "Confirm each worker is fit to work and free of sickness/diarrhoea (48-hour rule). Note any exclusions.",
  ),
  TaskEnrichmentRow(
    title: "Cuts covered (blue plaster)",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm any cuts/grazes are covered with a blue detectable plaster.",
  ),
  TaskEnrichmentRow(
    title: "Gloves available & changed appropriately",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm gloves are stocked and changed between different tasks.",
  ),
  TaskEnrichmentRow(
    title: "Fridge door seal intact",
    jobRole: JobRole.chefCook,
    guidanceText: "Check the rubber seal isn't torn or loose. Note any damage.",
  ),
  TaskEnrichmentRow(
    title: "Freezer ice build-up check",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Check for excessive ice. Note if it needs defrosting.",
  ),
  TaskEnrichmentRow(
    title: "Walk-in shelving clean & sound",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm shelves are clean and not rusted/damaged.",
  ),
  TaskEnrichmentRow(
    title: "Condenser / vents dust-free",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Check the vents/grille are clear of dust. Photo. Clean if needed.",
  ),
  TaskEnrichmentRow(
    title: "Fridge/freezer alarm functioning",
    jobRole: JobRole.management,
    guidanceText: "Confirm the temperature alarm works.",
  ),
  TaskEnrichmentRow(
    title: "Not overloaded (airflow)",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm units aren't so packed that air can't circulate.",
  ),
  TaskEnrichmentRow(
    title: "Oil temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Read the fryer's set temperature, record it, photo it. Typically at or below 180°C.",
  ),
  TaskEnrichmentRow(
    title: "Oil quality (TPM/colour)",
    jobRole: JobRole.chefCook,
    guidanceText: "Check oil colour/smell or TPM reading. Record it. Discard if dark/foul or over the meter's limit.",
  ),
  TaskEnrichmentRow(
    title: "Oil filtering / polishing",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm oil filtered/polished as scheduled.",
  ),
  TaskEnrichmentRow(
    title: "Oil change & log",
    jobRole: JobRole.chefCook,
    guidanceText: "Record when oil was changed and in which fryer.",
  ),
  TaskEnrichmentRow(
    title: "Fryer deep clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Drain, clean, and confirm the fryer is degreased. Photo.",
  ),
  TaskEnrichmentRow(
    title: "Oil usage log",
    jobRole: JobRole.chefCook,
    guidanceText: "Record oil added/used today.",
  ),
  TaskEnrichmentRow(
    title: "Oven working temperature",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm the oven reaches and holds its set temperature. Record.",
  ),
  TaskEnrichmentRow(
    title: "Combi self-clean run",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm the combi's self-clean cycle was run.",
  ),
  TaskEnrichmentRow(
    title: "Grill / salamander clean & working",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm clean and heating properly.",
  ),
  TaskEnrichmentRow(
    title: "Hob / burner ignition & flame",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm all burners light and burn with a clean blue flame. Flag any that don't.",
  ),
  TaskEnrichmentRow(
    title: "Rotisserie / kebab machine temp & clean",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm at temperature and clean. Record.",
  ),
  TaskEnrichmentRow(
    title: "Steamer descale",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm descaled as scheduled.",
  ),
  TaskEnrichmentRow(
    title: "Extraction canopy filters clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Check the extraction filters are grease-free. Photo. Grease build-up is a fire risk.",
  ),
  TaskEnrichmentRow(
    title: "Gas interlock / emergency cut-off test",
    jobRole: JobRole.management,
    guidanceText: "Confirm the gas interlock/emergency cut-off works.",
  ),
  TaskEnrichmentRow(
    title: "Equipment guard / cut-out intact",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm safety guards and cut-outs are in place and working.",
  ),
  TaskEnrichmentRow(
    title: "Dishwasher wash temperature",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Read the wash-cycle temperature, record it. Should be ~55-65°C.",
  ),
  TaskEnrichmentRow(
    title: "Dishwasher rinse temperature",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Read the rinse temperature, record it. Should reach ~82°C to sanitise.",
  ),
  TaskEnrichmentRow(
    title: "Detergent / rinse-aid levels",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Check detergent and rinse-aid aren't empty. Refill if low.",
  ),
  TaskEnrichmentRow(
    title: "Dishwasher filter cleaned",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Remove and clean the filter. Confirm done.",
  ),
  TaskEnrichmentRow(
    title: "Glasswasher functioning & dosed",
    jobRole: JobRole.bar,
    guidanceText: "Confirm the glasswasher runs and is dosed with detergent.",
  ),
  TaskEnrichmentRow(
    title: "Pot-wash sanitiser strength",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm the sanitiser sink is mixed to the right strength. Record.",
  ),
  TaskEnrichmentRow(
    title: "Air-dry (no tea-towel drying)",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm items are left to air-dry, not dried with cloths.",
  ),
  TaskEnrichmentRow(
    title: "Prep surfaces cleaned & sanitised",
    jobRole: JobRole.chefCook,
    guidanceText: "Clean then sanitise prep surfaces. Confirm the sanitiser's contact time was left before wiping.",
  ),
  TaskEnrichmentRow(
    title: "Chopping boards colour-coded & sound",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm the right colour board is used for each food type and none are deeply scored.",
  ),
  TaskEnrichmentRow(
    title: "Slicer / mincer strip-down clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Strip down, clean, and sanitise the slicer/mincer. Photo. Mind the blade.",
  ),
  TaskEnrichmentRow(
    title: "Can opener blade clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm the blade is clean and rust-free.",
  ),
  TaskEnrichmentRow(
    title: "Ice machine clean & descaled",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm the ice machine is clean and descaled. Photo.",
  ),
  TaskEnrichmentRow(
    title: "Kitchen floor cleaned",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Sweep and mop. Confirm done.",
  ),
  TaskEnrichmentRow(
    title: "Drains / gullies cleared",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Clear and sanitise floor drains. Confirm no blockage/smell.",
  ),
  TaskEnrichmentRow(
    title: "Walls / splashbacks wiped",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Wipe down walls and splashbacks.",
  ),
  TaskEnrichmentRow(
    title: "Bin areas cleaned",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Clean around and under bins.",
  ),
  TaskEnrichmentRow(
    title: "Deep clean checklist",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Work through the deep-clean checklist items and confirm each done.",
  ),
  TaskEnrichmentRow(
    title: "Cleaning schedule signed off",
    jobRole: JobRole.management,
    guidanceText: "Confirm the day's cleaning schedule is complete and sign it off (this is your EHO evidence).",
  ),
  TaskEnrichmentRow(
    title: "Sanitiser in stock & in date",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm sanitiser is available and in date.",
  ),
  TaskEnrichmentRow(
    title: "Degreaser in stock",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm degreaser available.",
  ),
  TaskEnrichmentRow(
    title: "Blue roll / paper towel stocked",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm blue roll and hand towels stocked.",
  ),
  TaskEnrichmentRow(
    title: "COSHH sheets present & chemicals labelled",
    jobRole: JobRole.management,
    guidanceText: "Confirm COSHH data sheets are on file and chemicals correctly labelled.",
  ),
  TaskEnrichmentRow(
    title: "Chemical dilution / dosing correct",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm chemicals are mixed/dosed to the right strength. Record.",
  ),
  TaskEnrichmentRow(
    title: "Dry store temperature / humidity",
    jobRole: JobRole.chefCook,
    guidanceText: "Record the dry store temperature/humidity.",
  ),
  TaskEnrichmentRow(
    title: "Stock off floor / on shelving",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm all stock is off the floor on shelving.",
  ),
  TaskEnrichmentRow(
    title: "Open dry goods sealed & dated",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm opened dry goods are sealed and date-labelled.",
  ),
  TaskEnrichmentRow(
    title: "No damaged / bloated / infested packaging",
    jobRole: JobRole.chefCook,
    guidanceText: "Check for damaged, bloated, or pest-damaged packaging. Note and remove any.",
  ),
  TaskEnrichmentRow(
    title: "Chilled goods temp on arrival",
    jobRole: JobRole.chefCook,
    guidanceText: "Probe chilled items on delivery. Record, photo. Reject if above 8°C.",
  ),
  TaskEnrichmentRow(
    title: "Frozen goods temp on arrival",
    jobRole: JobRole.chefCook,
    guidanceText: "Check frozen items are solid/frozen. Record, photo. Reject if soft.",
  ),
  TaskEnrichmentRow(
    title: "Vehicle / driver hygiene",
    jobRole: JobRole.chefCook,
    guidanceText: "Note the delivery vehicle/driver looks clean and hygienic.",
  ),
  TaskEnrichmentRow(
    title: "Packaging intact",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm packaging isn't damaged or open.",
  ),
  TaskEnrichmentRow(
    title: "Use-by dates acceptable",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm delivered items have acceptable dates (enough shelf life).",
  ),
  TaskEnrichmentRow(
    title: "Reconciled to order/invoice",
    jobRole: JobRole.management,
    guidanceText: "Confirm what arrived matches the order/invoice. Note discrepancies.",
  ),
  TaskEnrichmentRow(
    title: "Rejected items logged",
    jobRole: JobRole.chefCook,
    guidanceText: "Note any items rejected and why.",
  ),
  TaskEnrichmentRow(
    title: "Supplier traceability captured",
    jobRole: JobRole.management,
    guidanceText: "Confirm delivery records kept (supplier, date) for traceability.",
  ),
  TaskEnrichmentRow(
    title: "Hot water at sinks",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm hot water available at all sinks.",
  ),
  TaskEnrichmentRow(
    title: "Hand-wash sinks stocked",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm soap and towels at every hand-wash sink.",
  ),
  TaskEnrichmentRow(
    title: "Fire exits clear & unlocked",
    jobRole: JobRole.management,
    guidanceText: "Confirm fire exits are clear and unlocked.",
  ),
  TaskEnrichmentRow(
    title: "Fire extinguishers in place & in date",
    jobRole: JobRole.management,
    guidanceText: "Confirm extinguishers present and in date.",
  ),
  TaskEnrichmentRow(
    title: "First aid kit stocked",
    jobRole: JobRole.management,
    guidanceText: "Confirm first aid kit stocked.",
  ),
  TaskEnrichmentRow(
    title: "Lighting functional",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm work-area lighting works. Note any out.",
  ),
  TaskEnrichmentRow(
    title: "Gas / electrical no visible faults",
    jobRole: JobRole.chefCook,
    guidanceText: "Note any visible gas or electrical faults.",
  ),
  TaskEnrichmentRow(
    title: "General waste removed & bins clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Empty bins and confirm clean.",
  ),
  TaskEnrichmentRow(
    title: "Food waste segregated",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm food waste separated correctly.",
  ),
  TaskEnrichmentRow(
    title: "Used cooking oil stored / collected",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm used oil stored for licensed collection.",
  ),
  TaskEnrichmentRow(
    title: "Pest activity check (droppings/gnaw/nest)",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Look for droppings, gnaw marks, nests, or flies. Note and report any signs.",
  ),
  TaskEnrichmentRow(
    title: "Fly killer / bait stations working",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm fly killer/bait stations are working.",
  ),
  TaskEnrichmentRow(
    title: "External bin area secure & clean",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm outside bin area is clean and lids closed.",
  ),
  TaskEnrichmentRow(
    title: "Pest control contract visit log",
    jobRole: JobRole.management,
    guidanceText: "Record the pest control contractor's visit/report.",
  ),
  TaskEnrichmentRow(
    title: "Equipment fault log reviewed",
    jobRole: JobRole.management,
    guidanceText: "Review outstanding equipment faults. Note status.",
  ),
  TaskEnrichmentRow(
    title: "Scheduled servicing up to date",
    jobRole: JobRole.management,
    guidanceText: "Confirm scheduled servicing is current.",
  ),
  TaskEnrichmentRow(
    title: "PAT / electrical inspection in date",
    jobRole: JobRole.management,
    guidanceText: "Confirm portable appliance testing is in date.",
  ),
  TaskEnrichmentRow(
    title: "Extraction/duct professional clean in date",
    jobRole: JobRole.management,
    guidanceText: "Confirm the extraction/duct deep-clean certificate is in date.",
  ),
  TaskEnrichmentRow(
    title: "Gas safety certificate in date",
    jobRole: JobRole.management,
    guidanceText: "Confirm the gas safety certificate is in date.",
  ),
  TaskEnrichmentRow(
    title: "Stock count / par levels",
    jobRole: JobRole.management,
    guidanceText: "Count stock against par levels. Record.",
  ),
  TaskEnrichmentRow(
    title: "Wastage / spoilage log",
    jobRole: JobRole.chefCook,
    guidanceText: "Record any food wasted or spoiled and why.",
  ),
  TaskEnrichmentRow(
    title: "Low-stock reorder flagged",
    jobRole: JobRole.chefCook,
    guidanceText: "Note items running low that need reordering.",
  ),
  TaskEnrichmentRow(
    title: "High-value stock reconciled",
    jobRole: JobRole.management,
    guidanceText: "Reconcile high-value stock (e.g. meat, spirits). Record.",
  ),
  TaskEnrichmentRow(
    title: "Opening checklist complete",
    jobRole: JobRole.chefCook,
    guidanceText: "Work through the opening checklist. Confirm each item.",
  ),
  TaskEnrichmentRow(
    title: "All refrigeration temps at open",
    jobRole: JobRole.chefCook,
    guidanceText: "Check and record all fridge/freezer temps at opening.",
  ),
  TaskEnrichmentRow(
    title: "Equipment switched on & warmed",
    jobRole: JobRole.chefCook,
    guidanceText: "Switch on and confirm cooking equipment is up to temperature.",
  ),
  TaskEnrichmentRow(
    title: "No overnight pest / leak / fault",
    jobRole: JobRole.chefCook,
    guidanceText: "Check for any overnight pest signs, leaks, or faults. Note any.",
  ),
  TaskEnrichmentRow(
    title: "Closing checklist complete",
    jobRole: JobRole.chefCook,
    guidanceText: "Work through the closing checklist. Confirm each item.",
  ),
  TaskEnrichmentRow(
    title: "Equipment safely off",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm all cooking equipment safely switched off.",
  ),
  TaskEnrichmentRow(
    title: "Perishables stored / covered / dated",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm perishables are covered, dated, and stored correctly.",
  ),
  TaskEnrichmentRow(
    title: "Final clean-down",
    jobRole: JobRole.kitchenPorter,
    guidanceText: "Confirm final clean-down of surfaces and floors done.",
  ),
  TaskEnrichmentRow(
    title: "Premises secured / alarm set",
    jobRole: JobRole.management,
    guidanceText: "Confirm premises locked and alarm set.",
  ),
  TaskEnrichmentRow(
    title: "Mise en place complete",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm prep for service is complete.",
  ),
  TaskEnrichmentRow(
    title: "Hot-hold / bain-marie pre-heated",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm bain-marie is up to temperature (63°C+) before service. Record.",
  ),
  TaskEnrichmentRow(
    title: "Specials / allergen info briefed",
    jobRole: JobRole.management,
    guidanceText: "Confirm the team is briefed on specials and allergens.",
  ),
  TaskEnrichmentRow(
    title: "Service fridges stocked & at temp",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm service fridges stocked and at temperature. Record.",
  ),
  TaskEnrichmentRow(
    title: "Dining area cleaned & set",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Confirm dining area cleaned and tables set.",
  ),
  TaskEnrichmentRow(
    title: "Tables / condiments sanitised",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Confirm tables and condiments wiped/sanitised.",
  ),
  TaskEnrichmentRow(
    title: "Customer toilets checked & stocked",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Check toilets clean and stocked. Note and fix issues.",
  ),
  TaskEnrichmentRow(
    title: "Allergen requests relayed to kitchen",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Confirm any customer allergen request was clearly passed to the kitchen. Note the order.",
  ),
  TaskEnrichmentRow(
    title: "Coffee machine cleaned & backflushed",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Confirm coffee machine cleaned and backflushed.",
  ),
  TaskEnrichmentRow(
    title: "Hot buffet display temperature",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Probe hot buffet food. Record, photo. Must stay at or above 63°C.",
  ),
  TaskEnrichmentRow(
    title: "Cold buffet display temperature",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Probe cold buffet food. Record, photo. Must stay at or below 8°C.",
  ),
  TaskEnrichmentRow(
    title: "Buffet out-of-temperature time log",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Note when food went on display. Cold food out of temperature max 4 hours, then discard.",
  ),
  TaskEnrichmentRow(
    title: "Cellar / keg temperature",
    jobRole: JobRole.bar,
    guidanceText: "Read and record the cellar/keg temperature. Cask usually 11-13°C.",
  ),
  TaskEnrichmentRow(
    title: "Beer line cleaning",
    jobRole: JobRole.bar,
    guidanceText: "Confirm beer lines cleaned (usually every 7 days). Note date.",
  ),
  TaskEnrichmentRow(
    title: "Ice well / scoop hygiene",
    jobRole: JobRole.bar,
    guidanceText: "Confirm ice well clean and scoop stored hygienically (not in the ice).",
  ),
  TaskEnrichmentRow(
    title: "Post-mix / soda gun cleaned",
    jobRole: JobRole.bar,
    guidanceText: "Confirm soda gun/nozzles cleaned.",
  ),
  TaskEnrichmentRow(
    title: "Glassware condition (no chips)",
    jobRole: JobRole.bar,
    guidanceText: "Check glasses for chips/cracks. Remove any damaged.",
  ),
  TaskEnrichmentRow(
    title: "Optics / measures verified",
    jobRole: JobRole.bar,
    guidanceText: "Confirm optics and measures are correct (legal measures).",
  ),
  TaskEnrichmentRow(
    title: "Open wine / vermouth dated",
    jobRole: JobRole.bar,
    guidanceText: "Confirm open bottles are dated. Discard past their window.",
  ),
  TaskEnrichmentRow(
    title: "Breakfast buffet temperatures",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Probe hot and cold buffet items. Record, photo. Hot ≥63°C, cold ≤8°C.",
  ),
  TaskEnrichmentRow(
    title: "Room service tray temp on dispatch",
    jobRole: JobRole.chefCook,
    guidanceText: "Confirm room service food is at the right temperature when it leaves. Record.",
  ),
  TaskEnrichmentRow(
    title: "Minibar stock & date check",
    jobRole: JobRole.frontOfHouse,
    guidanceText: "Check minibar stock and dates. Note and replace expired items.",
  ),
  TaskEnrichmentRow(
    title: "Banqueting / function hot-hold log",
    jobRole: JobRole.chefCook,
    guidanceText: "Record hot-hold temperatures for function food. Must stay ≥63°C.",
  ),
  TaskEnrichmentRow(
    title: "Guest allergen request (rooms)",
    jobRole: JobRole.management,
    guidanceText: "Confirm guest allergen requests handled and recorded.",
  ),
  TaskEnrichmentRow(
    title: "Poolside / satellite bar hygiene",
    jobRole: JobRole.bar,
    guidanceText: "Confirm satellite bar clean and stocked hygienically.",
  ),
  TaskEnrichmentRow(
    title: "Daily compliance review / sign-off",
    jobRole: JobRole.management,
    guidanceText: "Review the day's checks, address any fails, and sign off.",
  ),
  TaskEnrichmentRow(
    title: "Weekly food safety walk-round",
    jobRole: JobRole.management,
    guidanceText: "Do a full walk-round. Note and photo any issues.",
  ),
  TaskEnrichmentRow(
    title: "Corrective actions closed out",
    jobRole: JobRole.management,
    guidanceText: "Confirm outstanding corrective actions are resolved.",
  ),
  TaskEnrichmentRow(
    title: "SFBB / HACCP diary reviewed",
    jobRole: JobRole.management,
    guidanceText: "Review the food-safety diary (4-weekly cycle). Confirm complete.",
  ),
  TaskEnrichmentRow(
    title: "EHO / audit readiness check",
    jobRole: JobRole.management,
    guidanceText: "Confirm records and premises are inspection-ready.",
  ),
  TaskEnrichmentRow(
    title: "Staff training records current",
    jobRole: JobRole.management,
    guidanceText: "Confirm staff food-hygiene training is current.",
  ),
  TaskEnrichmentRow(
    title: "Supplier approval / due diligence",
    jobRole: JobRole.management,
    guidanceText: "Confirm suppliers are approved and due-diligence records held.",
  ),
];
