import 'task_training_guide.dart';

// Standard "How to do this correctly" guides (2026-10-15), one per task in
// the HORECA library, keyed by template title exactly as loaded (the same
// key task_enrichment_data.dart matches on). Content follows UK practice:
// FSA Safer Food Better Business (food safety, allergens, cleaning), HSE
// L8/ACOP (Legionella), BBPA/HSE (cellar gas), Regulatory Reform (Fire
// Safety) Order 2005, Gas Safety (Installation and Use) Regs, Licensing
// Act 2003 / SIA, and UK GDPR for guest data. Figures match the limits the
// tasks themselves already enforce, so the guide never contradicts the
// pass/fail check on the same screen.
//
// Kept short on purpose: 3-5 action steps a worker can read mid-shift.
// Venues can replace any of these with their own version (see
// TaskTrainingGuideRepository) — this is the default, not a lock.
TaskTrainingGuide _g(List<String> steps, String why, String fail) =>
    TaskTrainingGuide(steps: steps, whyItMatters: why, ifItFails: fail);

const _tempFail =
    'Re-check after 15-20 minutes. If still out of range, move food to a working unit, tell your manager, and log the corrective action. Food held above 8°C for over 4 hours must be thrown away.';
const _reportFail =
    'Do not ignore it. Fix it now if you safely can, otherwise tell your manager straight away and log what you found.';
const _certFail =
    'Tell your manager today. Book the inspection/service and record the booking. Stop using the equipment if it is unsafe.';

final Map<String, TaskTrainingGuide> standardTrainingGuides = {
  // ---- Temperature control -------------------------------------------
  'Check Fridge Temperature': _g(
    [
      'Read the fridge display, or probe a sample item (not the air near the door).',
      'Enter the reading.',
      'Photograph the display or probe reading.',
      'Pass if it is 8°C or below (aim for 5°C or below).',
    ],
    'Bacteria grow quickly above 8°C. Above 8°C is a legal breach for most chilled food.',
    _tempFail,
  ),
  'Fridge temperature': _g(
    [
      'Check the door has been closed for a few minutes (a just-opened fridge reads high).',
      'Read the display, or probe a sample item in the middle of the unit.',
      'Enter the number and photograph the display.',
      'Pass at 8°C or below. Best practice is 5°C or below.',
    ],
    'Chilled food must be kept at 8°C or below by law. Bacteria multiply fast above that.',
    _tempFail,
  ),
  'Freezer temperature': _g(
    [
      'Read the freezer display or thermometer.',
      'Enter the number and photograph it.',
      'Pass at -18°C or colder.',
      'Check food is hard frozen with no signs of thawing.',
    ],
    'At -18°C bacteria stop growing. Food that has thawed and refrozen can be unsafe.',
    'Move food to another freezer. Anything soft or thawed: use straight away if safe, or throw away. Tell your manager.',
  ),
  'Walk-in cold room temperature': _g(
    [
      'Close the door behind you so the reading settles.',
      'Read the wall thermometer or display.',
      'Enter the number and photograph it.',
      'Pass at 8°C or below.',
    ],
    'Walk-ins hold large amounts of stock. One failure can put a lot of food at risk.',
    _tempFail,
  ),
  'Blast chiller cycle temperature': _g(
    [
      'Probe the food core when it goes in and record the start temperature.',
      'Run the cycle. Do not overload trays or stack them tightly.',
      'Probe the core again at the end and record the end temperature.',
      'Pass if food went from 70°C to below 3°C (or below 8°C) within 90 minutes.',
    ],
    'Fast cooling stops spores (like C. perfringens) waking up in the danger zone.',
    'Divide food into smaller, shallower portions and re-chill. If it has been over 90 minutes and still warm, tell your manager. It may need to be thrown away.',
  ),
  'Display/serve-over fridge temperature': _g(
    [
      'Probe a sample food item in the display (not the air).',
      'Enter the reading and photograph it.',
      'Pass at 8°C or below.',
      'Check the night blind/door is used when not serving.',
    ],
    'Display units are opened constantly and warm up faster than storage fridges.',
    _tempFail,
  ),
  'Cooked food core temperature': _g(
    [
      'Clean and sanitise the probe first.',
      'Probe the thickest part of the food, away from bone.',
      'Wait for the reading to settle, then record it and photograph it.',
      'Pass at 70°C or above, held for 2 minutes (75°C kills bacteria almost instantly). Rare whole beef/lamb is allowed only if fully seared outside.',
      'Never serve pork, minced meat, burgers, poultry or rolled joints rare.',
    ],
    'Proper cooking kills E. coli, Salmonella and Campylobacter. This is your key safety check.',
    'Keep cooking and probe again. Do not serve until it passes. Record the re-check.',
  ),
  'Reheated food core temperature': _g(
    [
      'Reheat until steaming hot all the way through.',
      'Probe the centre of the thickest part.',
      'Record the reading and photograph it.',
      'Pass at 70°C or above. Aim for 75°C. In Scotland the legal minimum is 82°C.',
    ],
    'Reheated food has already been through the danger zone once. It must be fully hot.',
    'Keep reheating and probe again. If it cannot reach temperature, throw it away. Food can only be reheated once.',
  ),
  'Hot-holding temperature': _g(
    [
      'Probe each hot-held dish in the middle of the container.',
      'Record the reading and photograph it.',
      'Pass at 63°C or above.',
      'Stir and top up hot-holding units; never add new food on top of old.',
    ],
    'Below 63°C bacteria can grow in hot food. It is a legal limit in England, Wales and NI.',
    'Food below 63°C for less than 2 hours: reheat to 75°C once, then hold. Longer, or unsure: throw it away.',
  ),
  'Cooling log (cooked to chilled)': _g(
    [
      'Note the time cooking finished.',
      'Spread food in shallow trays, or portion it, to cool quickly. Use a blast chiller if you have one.',
      'Put it in the fridge as soon as it stops steaming (within 90 minutes).',
      'Record the time and temperature when it reaches 8°C or below.',
    ],
    'Slow cooling is a top cause of food poisoning in catering.',
    'If it was not chilled within 90 minutes, tell your manager. It usually needs throwing away.',
  ),
  'Reheat-once verification': _g(
    [
      'Check the label to see if the item has already been reheated.',
      'If not, reheat to 75°C and mark the label "reheated" with the date.',
      'If it has already been reheated, do not reheat it again.',
    ],
    'Each warm-up gives bacteria another chance to grow. Once is the limit.',
    'Throw away anything already reheated once. Tell your manager if labels are missing.',
  ),
  'Probe calibration check': _g(
    [
      'Fill a cup with crushed ice and a little cold water. Stir, then probe for 1 minute. It should read -1°C to +1°C.',
      'Probe freshly boiling water. It should read 99°C to 101°C.',
      'Record both readings.',
      'Clean and sanitise the probe afterwards.',
    ],
    'A probe that reads wrong makes every temperature record wrong.',
    'Stop using the probe. Label it "do not use", use a spare, and tell your manager to replace it.',
  ),
  'Probe sanitised between uses': _g(
    [
      'Wipe the probe tip with a food-safe sanitiser wipe.',
      'Leave for the wipe\'s contact time (check the pack).',
      'Do this before and after every food you probe, especially raw then cooked.',
    ],
    'A dirty probe can carry bacteria from raw food straight into cooked food.',
    'Sanitise it now. If cooked food was probed with a dirty probe, tell your manager.',
  ),

  // ---- Stock & dates --------------------------------------------------
  'Use-by / best-before date check': _g(
    [
      'Check every shelf in fridges, freezers and the dry store.',
      'Remove anything past its use-by date. Do not use it, cook it or freeze it.',
      'Best-before items: check quality. They may be used if in good condition.',
      'Record what you removed.',
    ],
    'Use-by is a safety date. Using food after it is illegal and unsafe.',
    'Bin the item, record it as waste, and tell your manager if it was stored long past its date.',
  ),
  'FIFO stock rotation': _g(
    [
      'Move older stock to the front.',
      'Put new deliveries behind it.',
      'Check dates as you go: shortest date at the front.',
    ],
    'First in, first out stops food going out of date at the back of the shelf.',
    'Rotate the stock now and remove anything out of date.',
  ),
  'Opened-product date labelling': _g(
    [
      'Check every opened item has a label: product, date opened and use-by.',
      'Use the venue\'s day-dot or label system.',
      'Label anything missing now. If you cannot tell when it was opened, throw it away.',
    ],
    'Once opened, many foods have a short shelf life. Labels show when to bin them.',
    'Unknown opening date: throw it away. Remind the team to label on opening.',
  ),
  'Controlled defrost log': _g(
    [
      'Defrost in the fridge on the bottom shelf, in a tray, covered.',
      'Label it with the date it came out of the freezer.',
      'Record what is defrosting.',
      'Never defrost at room temperature or under warm water.',
    ],
    'Defrosting at room temperature lets the outside warm into the danger zone.',
    'Move it into the fridge now. If it sat out warm for a long time, tell your manager.',
  ),

  // ---- Allergens ------------------------------------------------------
  'Allergen matrix current & accessible': _g(
    [
      'Compare the allergen chart against today\'s menu, including specials.',
      'Check all 14 allergens are covered for every dish.',
      'Confirm staff know where to find it.',
      'Update it if any dish or ingredient has changed.',
    ],
    'Staff must give accurate allergen information on request. It is a legal duty.',
    'Do not sell dishes that are missing from the chart until they are added. Tell your manager.',
  ),
  'Allergen review on new/changed dishes': _g(
    [
      'Check the labels of every ingredient in the new or changed dish.',
      'Record which of the 14 allergens it contains.',
      'Update the allergen chart before the dish goes on sale.',
      'Brief the team on the change.',
    ],
    'A small swap (a sauce, a brand) can add a hidden allergen.',
    'Do not serve the dish until the allergens are recorded.',
  ),
  "PPDS labelling correct (Natasha's Law)": _g(
    [
      'Check each pre-packed-for-direct-sale item has: food name and full ingredient list.',
      'Check the 14 allergens are emphasised (e.g. bold) in the ingredients.',
      'Check the label matches what is actually inside.',
      'Photograph a sample label.',
    ],
    'Natasha\'s Law requires full ingredient labelling on food made and packed on site.',
    'Take incorrectly labelled items off sale, relabel them, and tell your manager.',
  ),
  'Separate allergen prep area/equipment': _g(
    [
      'Clean and sanitise the prep surface before starting.',
      'Use clean, separate equipment (purple boards/knives if you have them).',
      'Wash your hands and change your gloves/apron.',
      'Prepare the allergen-free order first if possible.',
    ],
    'Cross-contact with a tiny amount of allergen can cause a severe reaction.',
    'Stop and start again with clean equipment. Never just scrape off an allergen.',
  ),
  'Allergen-free order verified end-to-end': _g(
    [
      'Check the order ticket for the allergen.',
      'Confirm it was prepped separately with clean equipment.',
      'Keep it covered and separate when plated and carried.',
      'Tell the server it is the allergen-free order, and note the order.',
    ],
    'Mistakes most often happen at hand-over points between kitchen and table.',
    'If in doubt, remake it. Never serve an allergen-free order you are unsure about.',
  ),
  'Purple allergen boards/cloths used': _g(
    [
      'Use purple boards, knives and cloths for allergen-free orders.',
      'Clean them and store them apart from other equipment.',
      'Check they are in good condition (not deeply scored).',
    ],
    'Dedicated colour-coded kit cuts the risk of cross-contact.',
    'If none are available, fully clean and sanitise standard kit first and tell your manager.',
  ),
  'Staff allergen briefing': _g(
    [
      'Before service, go through today\'s dishes and specials.',
      'Highlight any allergen changes.',
      'Remind staff: if a customer asks, check the chart. Never guess.',
      'Confirm everyone on shift has heard it.',
    ],
    'Front-of-house staff are the ones customers ask.',
    'Brief anyone who missed it before they serve customers.',
  ),

  // ---- Personal hygiene -----------------------------------------------
  'Handwashing on entry / between tasks': _g(
    [
      'Wet hands with warm water and apply soap.',
      'Rub palms, backs, between fingers, thumbs and nails for at least 20 seconds.',
      'Rinse and dry with a paper towel. Use the towel to turn off the tap.',
      'Wash on entry, after raw food, bins, toilets, breaks and touching your face.',
    ],
    'Hands are the main way bacteria and viruses get into food.',
    'Wash now. If a sink has no soap/towels, restock it and tell your manager.',
  ),
  'Clean uniform / apron': _g(
    [
      'Put on a clean uniform and apron at the start of the shift.',
      'Change your apron if it gets dirty or after handling raw meat.',
      'Do not wear kitchen clothes outside (e.g. smoking breaks).',
    ],
    'Dirty clothing carries bacteria onto food.',
    'Change into clean clothing before working with food.',
  ),
  'Hair covering / beard net': _g(
    [
      'Tie back long hair.',
      'Wear a hat or hairnet that covers your hair.',
      'Wear a beard net if you have a beard.',
    ],
    'Hair in food is a common complaint and a contamination risk.',
    'Put one on before going back to food prep. Restock if none are available.',
  ),
  'No jewellery / false nails': _g(
    [
      'Remove rings, bracelets, watches and earrings (a plain wedding band is usually allowed).',
      'No false nails or nail varnish.',
      'Keep nails short and clean.',
    ],
    'Jewellery and nails trap bacteria and can fall into food.',
    'Remove it before working with food. Tell your manager if someone refuses.',
  ),
  'Fitness-to-work / illness declaration': _g(
    [
      'Ask each worker: any vomiting, diarrhoea, fever or skin infections?',
      'Anyone with vomiting or diarrhoea must not work with food.',
      'They stay away until 48 hours after symptoms stop.',
      'Record any exclusions.',
    ],
    'Norovirus and other bugs spread through food very easily.',
    'Send the person home and tell your manager. Do not let them handle food.',
  ),
  'Cuts covered (blue plaster)': _g(
    [
      'Clean the cut.',
      'Cover it with a blue, detectable waterproof plaster.',
      'Wear a glove over hand cuts.',
    ],
    'Cuts can carry bacteria. Blue plasters are easy to spot if they fall into food.',
    'Cover it now from the first aid kit. Restock blue plasters if out.',
  ),
  'Gloves available & changed appropriately': _g(
    [
      'Check gloves are stocked in all sizes.',
      'Wash hands before putting gloves on.',
      'Change gloves between raw and ready-to-eat food, and after bins, money or your face.',
    ],
    'Gloves only protect food if they are changed. Dirty gloves spread bacteria.',
    'Restock now. Remind staff that gloves are not a substitute for handwashing.',
  ),

  // ---- Refrigeration condition ----------------------------------------
  'Fridge door seal intact': _g(
    [
      'Run your hand around the rubber seal.',
      'Look for tears, gaps, mould or the seal coming loose.',
      'Close the door on a sheet of paper. It should grip it.',
    ],
    'A broken seal lets warm air in, so the fridge cannot hold temperature.',
    'Clean mould off. Report any damage to your manager for repair.',
  ),
  'Freezer ice build-up check': _g(
    [
      'Look for thick ice on walls, coils and the door.',
      'More than about 5mm (a pound coin thick) needs defrosting.',
      'Note it and plan a defrost.',
    ],
    'Ice build-up makes the freezer work harder and can stop it holding -18°C.',
    'Move stock to another freezer and defrost it, or report it to your manager.',
  ),
  'Walk-in shelving clean & sound': _g(
    [
      'Check shelves are clean, with no spills, rust or flaking paint.',
      'Check they are stable and not bent.',
      'Clean any spills.',
    ],
    'Rust and dirt can fall into food. Broken shelving is a safety risk.',
    _reportFail,
  ),
  'Condenser / vents dust-free': _g(
    [
      'Look at the grille/vents on the unit.',
      'Check they are not blocked by dust or boxes.',
      'Photograph them.',
      'Switch off and brush or vacuum dust away if needed.',
    ],
    'Dusty condensers make units overheat and fail.',
    'Clean it if safe, otherwise report it for maintenance.',
  ),
  'Fridge/freezer alarm functioning': _g(
    [
      'Check the alarm is switched on.',
      'Use the test button if the unit has one.',
      'Confirm it sounds or shows an alert.',
    ],
    'The alarm warns you before food is lost.',
    'Report it to your manager. Check that unit\'s temperature more often until it is fixed.',
  ),
  'Not overloaded (airflow)': _g(
    [
      'Check food is not packed tight against the back wall or fan.',
      'Leave gaps between items so air can flow.',
      'Move stock to another unit if it is too full.',
    ],
    'Cold air has to circulate, or parts of the fridge get warm.',
    'Move stock now, then re-check the temperature.',
  ),

  // ---- Fryers ---------------------------------------------------------
  'Oil temperature': _g(
    [
      'Let the fryer heat up fully.',
      'Read the thermostat or probe the oil with a suitable thermometer.',
      'Record the reading and photograph it.',
      'Pass at 185°C or below. Above 180°C shows amber: turn the thermostat down.',
      'Your venue may set its own amber and fail temperatures.',
    ],
    'Oil running too hot breaks down faster and can create harmful compounds and fire risk.',
    'Above the fail line: turn the thermostat down and re-check. If it will not control, switch off and report it.',
  ),
  'Oil quality (TPM/colour)': _g(
    [
      'Check the oil colour and smell. Dark, smoky, foamy or rancid oil must go.',
      'If you have a TPM tester, take a reading. Change above 24% TPM.',
      'Record the result.',
    ],
    'Old oil makes poor food and can be a health and fire risk.',
    'Change the oil and record it in the oil change log.',
  ),
  'Oil filtering / polishing': _g(
    [
      'Let the oil cool to a safe temperature (follow the fryer instructions).',
      'Filter it using the fryer\'s filter system or a filter cone.',
      'Wear heat-resistant gloves and an apron.',
      'Confirm it was done.',
    ],
    'Filtering removes burnt bits and makes oil last longer.',
    'Filter at the next safe opportunity and tell your manager.',
  ),
  'Oil change & log': _g(
    [
      'Switch off and let the oil cool below 40°C.',
      'Drain into the approved waste oil container.',
      'Clean the vat, then refill to the fill line.',
      'Record the date and which fryer.',
    ],
    'A log shows oil is changed regularly and helps cost control.',
    'Change it as soon as it is safe. Never move hot oil.',
  ),
  'Fryer deep clean': _g(
    [
      'Switch off, cool, and drain the oil.',
      'Use fryer cleaner (boil-out) following the label.',
      'Rinse and dry fully. Water in a fryer causes violent spitting.',
      'Clean the outside and surroundings. Photograph the result.',
    ],
    'Grease build-up is a major kitchen fire risk.',
    _reportFail,
  ),
  'Oil usage log': _g(
    [
      'Record how much oil was added or used today.',
      'Note which fryer.',
    ],
    'Tracks costs and spots fryers using unusual amounts.',
    'Record it now from memory and remind the team to log as they go.',
  ),

  // ---- Cooking equipment ----------------------------------------------
  'Oven working temperature': _g(
    [
      'Set the oven to a known temperature and let it heat.',
      'Check with an oven thermometer.',
      'Record the reading.',
    ],
    'An oven that runs cool can leave food undercooked.',
    'Report it. Probe all food cooked in it until it is fixed.',
  ),
  'Combi self-clean run': _g(
    [
      'Load the cleaning tablets/chemical as the manufacturer instructs.',
      'Start the self-clean cycle.',
      'Wipe the door seal and drain afterwards.',
      'Confirm it was done.',
    ],
    'Combi ovens build up grease and scale that affect cooking and hygiene.',
    'Run it at the next opportunity and tell your manager.',
  ),
  'Grill / salamander clean & working': _g(
    [
      'Switch on and check it heats evenly.',
      'Clean grease trays and bars when cool.',
      'Confirm clean and working.',
    ],
    'Grease build-up under grills is a common cause of kitchen fires.',
    _reportFail,
  ),
  'Hob / burner ignition & flame': _g(
    [
      'Light each burner.',
      'Check the flame is steady and blue.',
      'Yellow, lazy or noisy flames mean a fault.',
    ],
    'A bad flame can mean poor combustion and carbon monoxide risk.',
    'Do not use the burner. Report it for a Gas Safe engineer to check.',
  ),
  'Rotisserie / kebab machine temp & clean': _g(
    [
      'Check it is heating properly.',
      'Probe the cooked meat you slice off: 75°C.',
      'Only slice meat that is fully cooked on the outside.',
      'Clean drip trays and burners at the end of the day.',
    ],
    'Meat on a spit can be raw underneath the cooked outer layer.',
    'Keep cooking the sliced meat until it reaches 75°C. Report faulty heaters.',
  ),
  'Steamer descale': _g(
    [
      'Follow the manufacturer\'s descaling instructions.',
      'Wear gloves and eye protection when handling descaler.',
      'Rinse thoroughly after.',
      'Record when it was done.',
    ],
    'Limescale stops steamers heating properly.',
    'Descale at the next opportunity and tell your manager.',
  ),
  'Extraction canopy filters clean': _g(
    [
      'Check the filters for a sticky grease layer.',
      'Photograph them.',
      'Remove and wash them in hot soapy water or the dishwasher if dirty.',
      'Refit them correctly.',
    ],
    'Grease in extraction is one of the biggest causes of kitchen fires.',
    'Clean them before the next service. Report damaged filters.',
  ),
  'Gas interlock / emergency cut-off test': _g(
    [
      'With your manager\'s permission, switch off the extraction fan.',
      'Check the gas supply cuts off.',
      'Press the emergency stop button and check the gas cuts off.',
      'Reset and confirm gas is back on.',
    ],
    'The interlock stops gas running without ventilation, preventing carbon monoxide build-up.',
    'Stop using gas appliances and call a Gas Safe engineer.',
  ),
  'Equipment guard / cut-out intact': _g(
    [
      'Check guards are fitted on slicers, mixers and mincers.',
      'Check safety cut-outs stop the machine when a guard is opened.',
      'Never use a machine without its guard.',
    ],
    'Guards prevent serious cuts and amputations.',
    'Label the machine "do not use" and report it.',
  ),

  // ---- Warewashing ----------------------------------------------------
  'Dishwasher wash temperature': _g(
    [
      'Run a cycle and read the wash temperature on the display.',
      'Record it.',
      'Pass at about 55-65°C.',
    ],
    'The wash needs to be hot enough to remove grease and food.',
    'Check the heater and detergent. Report it if it will not reach temperature.',
  ),
  'Dishwasher rinse temperature': _g(
    [
      'Run a cycle and read the rinse temperature.',
      'Record it.',
      'Pass at about 82°C.',
    ],
    'The hot final rinse is what kills bacteria.',
    'Use a sanitiser-based method until it is fixed. Report it.',
  ),
  'Detergent / rinse-aid levels': _g(
    [
      'Check the detergent and rinse-aid containers.',
      'Replace if low or empty.',
      'Check the dosing tubes are in the containers.',
    ],
    'Without chemicals the machine is just rinsing, not cleaning.',
    'Refill now. Re-wash anything washed without detergent.',
  ),
  'Dishwasher filter cleaned': _g(
    [
      'Switch off and drain the machine.',
      'Remove the filters and scrap trays.',
      'Rinse off food waste and refit them.',
    ],
    'Blocked filters put dirty water back onto dishes.',
    'Clean it now before the next load.',
  ),
  'Glasswasher functioning & dosed': _g(
    [
      'Run a cycle and check it fills, washes and drains.',
      'Check the detergent and rinse aid are connected and not empty.',
      'Check glasses come out clean with no film.',
    ],
    'Dirty glasses can spread infection and spoil drinks.',
    'Refill chemicals or report the fault. Hand-wash and sanitise until fixed.',
  ),
  'Pot-wash sanitiser strength': _g(
    [
      'Mix sanitiser in the sink using the measured dose on the label.',
      'Use test strips if you have them.',
      'Record the strength or that it was mixed correctly.',
      'Change the water when dirty or cold.',
    ],
    'Too weak won\'t kill bacteria. Too strong is a chemical risk.',
    'Remix to the correct strength and re-sanitise anything done in the weak mix.',
  ),
  'Air-dry (no tea-towel drying)': _g(
    [
      'Leave washed items to drain and air-dry on a rack.',
      'Do not dry them with tea towels or cloths.',
    ],
    'Cloths spread bacteria back onto clean equipment.',
    'Re-wash anything dried with a cloth.',
  ),

  // ---- Cleaning -------------------------------------------------------
  'Prep surfaces cleaned & sanitised': _g(
    [
      'Clear the surface and remove food debris.',
      'Clean with hot soapy water or detergent.',
      'Spray sanitiser and leave it for the contact time on the label.',
      'Wipe off with a clean single-use cloth.',
    ],
    'Two-stage cleaning (clean, then sanitise) is the FSA standard.',
    'Re-do it properly before using the surface.',
  ),
  'Chopping boards colour-coded & sound': _g(
    [
      'Use the right colour: red raw meat, blue raw fish, yellow cooked meat, green salad/fruit, brown veg, white bakery/dairy, purple allergen-free.',
      'Check boards are not deeply scored or warped.',
      'Store them clean and apart.',
    ],
    'Colour-coding stops raw-to-ready cross-contamination. Deep scores trap bacteria.',
    'Replace damaged boards and tell your manager.',
  ),
  'Slicer / mincer strip-down clean': _g(
    [
      'Switch off and unplug.',
      'Wear cut-resistant gloves. Remove the guard and parts as trained.',
      'Clean, sanitise and dry each part.',
      'Reassemble with the guard, then photograph it.',
    ],
    'Slicers are a known E. coli risk when used for raw and cooked meat.',
    'Do not use it until cleaned. Never use the same slicer for raw and ready-to-eat food.',
  ),
  'Can opener blade clean': _g(
    [
      'Remove food from the blade.',
      'Wash, sanitise and dry it.',
      'Check it is not rusty.',
    ],
    'Can opener blades collect food and metal fragments.',
    'Replace a rusty blade.',
  ),
  'Ice machine clean & descaled': _g(
    [
      'Empty the ice and switch off.',
      'Clean and sanitise the bin, scoop and inside surfaces with a food-safe product.',
      'Descale following the manufacturer\'s instructions.',
      'Discard the first batch of ice. Photograph it.',
    ],
    'Ice is food. Dirty ice machines can grow mould and bacteria.',
    'Stop using the ice until it has been cleaned.',
  ),
  'Kitchen floor cleaned': _g(
    [
      'Sweep first to remove debris.',
      'Mop with hot water and detergent.',
      'Put out a wet floor sign.',
      'Clean under equipment where you can.',
    ],
    'Dirty floors attract pests and cause slips.',
    'Finish cleaning before the next service.',
  ),
  'Drains / gullies cleared': _g(
    [
      'Lift the grate and remove debris.',
      'Clean and pour drain cleaner as per the label.',
      'Check for smells or slow drainage.',
    ],
    'Blocked drains smell, attract flies and can flood.',
    'Report blockages for maintenance.',
  ),
  'Walls / splashbacks wiped': _g(
    [
      'Wipe walls and splashbacks with detergent.',
      'Pay attention to areas behind cookers and sinks.',
    ],
    'Grease and splashes build up and attract pests.',
    'Clean it before the next service.',
  ),
  'Bin areas cleaned': _g(
    [
      'Move bins and clean the floor under and around them.',
      'Clean the bin lids and handles.',
      'Check lids close properly.',
    ],
    'Bin areas attract pests and spread bacteria.',
    'Clean it now. Report broken bins.',
  ),
  'Deep clean checklist': _g(
    [
      'Work through each item on the deep-clean list.',
      'Move equipment to clean behind and under it.',
      'Tick off each item as you finish.',
    ],
    'Deep cleans reach the areas daily cleaning misses.',
    'Note what was not done and tell your manager so it can be rescheduled.',
  ),
  'Cleaning schedule signed off': _g(
    [
      'Check every task on today\'s cleaning schedule was done.',
      'Spot-check a few areas yourself.',
      'Sign it off.',
    ],
    'The signed schedule is your evidence for the EHO.',
    'Get missed items done before signing.',
  ),
  'Sanitiser in stock & in date': _g(
    [
      'Check you have enough sanitiser.',
      'Check it is in date.',
      'Check it meets BS EN 1276 or BS EN 13697 (on the label).',
    ],
    'Only tested sanitisers reliably kill bacteria like E. coli.',
    'Order more today and tell your manager.',
  ),
  'Degreaser in stock': _g(
    ['Check you have enough degreaser.', 'Note if more needs ordering.'],
    'Grease build-up is a fire and hygiene risk.',
    'Order more today.',
  ),
  'Blue roll / paper towel stocked': _g(
    [
      'Check blue roll is stocked at prep areas.',
      'Check paper towels are stocked at hand-wash sinks.',
    ],
    'Single-use towels stop bacteria spreading from reused cloths.',
    'Restock now.',
  ),
  'COSHH sheets present & chemicals labelled': _g(
    [
      'Check there is a safety data sheet for every chemical in use.',
      'Check every chemical is in its original or correctly labelled container.',
      'Check chemicals are stored away from food.',
    ],
    'COSHH law requires you to know the dangers of the chemicals you use.',
    'Remove unlabelled chemicals. Get missing data sheets from the supplier.',
  ),
  'Chemical dilution / dosing correct': _g(
    [
      'Check the dilution rate on the label.',
      'Use the dosing system or a measure, never guess.',
      'Record the strength.',
    ],
    'Wrong dilution either doesn\'t work or is a chemical hazard.',
    'Remix correctly. Report broken dosing units.',
  ),

  // ---- Dry store ------------------------------------------------------
  'Dry store temperature / humidity': _g(
    [
      'Read the dry store thermometer (and humidity gauge if fitted).',
      'Record it.',
      'It should be cool and dry, ideally below 25°C.',
    ],
    'Heat and damp spoil dry goods and attract pests.',
    'Improve ventilation and report persistent problems.',
  ),
  'Stock off floor / on shelving': _g(
    [
      'Check nothing is stored on the floor.',
      'Move items onto shelves or pallets.',
    ],
    'Stock on the floor blocks cleaning and attracts pests.',
    'Move it now.',
  ),
  'Open dry goods sealed & dated': _g(
    [
      'Put opened goods into sealed, lidded containers.',
      'Label with product and date opened.',
    ],
    'Open bags attract pests and go stale.',
    'Decant and label now.',
  ),
  'No damaged / bloated / infested packaging': _g(
    [
      'Look for torn bags, dented or bulging cans, and leaking packs.',
      'Look for pest signs: holes, droppings, webbing, insects.',
      'Remove anything damaged and record it.',
    ],
    'Bulging cans can mean dangerous bacteria (botulism). Damage can mean pests.',
    'Bin it and record it. Report pest signs to your manager straight away.',
  ),

  // ---- Deliveries -----------------------------------------------------
  'Chilled goods temp on arrival': _g(
    [
      'Probe between two packs (do not pierce packs).',
      'Record the reading and photograph it.',
      'Accept at 8°C or below (5°C or below is better).',
      'Put chilled goods away within 15 minutes.',
    ],
    'You are responsible for the food once you accept it.',
    'Reject anything above 8°C. Record the rejection and tell the driver.',
  ),
  'Frozen goods temp on arrival': _g(
    [
      'Check items are hard frozen.',
      'Probe between packs if possible: -18°C or colder.',
      'Record and photograph.',
      'Put away immediately.',
    ],
    'Thawed and refrozen food may be unsafe.',
    'Reject soft or thawed items and record why.',
  ),
  'Vehicle / driver hygiene': _g(
    [
      'Check the van is clean and refrigerated if carrying chilled food.',
      'Check the driver looks clean.',
      'Note anything concerning.',
    ],
    'Dirty transport can contaminate food before it arrives.',
    'Record it and tell your manager. Repeated issues need raising with the supplier.',
  ),
  'Packaging intact': _g(
    [
      'Check boxes and packs are not torn, crushed or wet.',
      'Check seals are not broken.',
    ],
    'Damaged packaging can let in bacteria or pests.',
    'Reject damaged items and record it.',
  ),
  'Use-by dates acceptable': _g(
    [
      'Check use-by dates on delivered items.',
      'Make sure there is enough life left to use them.',
    ],
    'Short-dated stock leads to waste or out-of-date food being used.',
    'Reject short-dated items or agree a credit with the supplier.',
  ),
  'Reconciled to order/invoice': _g(
    [
      'Check items and quantities against the delivery note.',
      'Note any missing, extra or substituted items.',
      'Get the driver to sign for shortages.',
    ],
    'Stops paying for goods you didn\'t receive and catches allergen-changing substitutions.',
    'Record discrepancies and tell your manager.',
  ),
  'Rejected items logged': _g(
    [
      'Record what was rejected, how much, and why.',
      'Get the delivery note marked or signed.',
    ],
    'Proves what was refused, for credit and for due diligence.',
    'Log it now.',
  ),
  'Supplier traceability captured': _g(
    [
      'Select the supplier.',
      'Record the delivery date.',
      'Keep the delivery note or invoice.',
    ],
    'If there is a food recall, you must know where food came from.',
    'Find the paperwork and record it now.',
  ),

  // ---- Premises & safety ----------------------------------------------
  'Hot water at sinks': _g(
    [
      'Run the hot tap at each sink.',
      'Check hot water comes through.',
    ],
    'Hot water is needed for proper handwashing and cleaning.',
    'Report it. Do not prepare food if there is no hot water for handwashing.',
  ),
  'Hand-wash sinks stocked': _g(
    [
      'Check soap at every hand-wash sink.',
      'Check paper towels are stocked.',
      'Check sinks are not blocked or used for other things.',
    ],
    'Staff cannot wash hands properly without soap and towels.',
    'Restock now.',
  ),
  'Fire exits clear & unlocked': _g(
    [
      'Walk each escape route.',
      'Check doors open easily and are not locked or blocked.',
      'Check exit signs are lit.',
    ],
    'Blocked exits cost lives in a fire.',
    'Clear it now. Tell your manager if a door won\'t open.',
  ),
  'Fire extinguishers in place & in date': _g(
    [
      'Check each extinguisher is in its place.',
      'Check the pin and seal are intact.',
      'Check the service label is in date (serviced yearly).',
    ],
    'Extinguishers must be ready and working in an emergency.',
    'Tell your manager to arrange replacement or service.',
  ),
  'First aid kit stocked': _g(
    [
      'Open the kit and check against its contents list.',
      'Check blue plasters, dressings, gloves and burn gel.',
      'Note anything used or out of date.',
    ],
    'Kitchen burns and cuts need quick treatment.',
    'Restock from spares or order now.',
  ),
  'Lighting functional': _g(
    [
      'Check every light in the work area works.',
      'Note any that are out or flickering.',
    ],
    'Poor lighting causes accidents and hides dirt.',
    'Report it for repair.',
  ),
  'Gas / electrical no visible faults': _g(
    [
      'Look for damaged cables, plugs or sockets.',
      'Check for gas smells.',
      'Note any faults.',
    ],
    'Electrical and gas faults can cause fires, shocks and explosions.',
    'Gas smell: turn off gas at the meter, no switches or flames, open windows, call 0800 111 999. Electrical fault: unplug and label it.',
  ),

  // ---- Waste ----------------------------------------------------------
  'General waste removed & bins clean': _g(
    [
      'Empty bins before they are overfull.',
      'Clean the bins.',
      'Replace bags and close lids.',
    ],
    'Full bins attract pests and spread smells.',
    'Empty them now.',
  ),
  'Food waste segregated': _g(
    [
      'Put food waste in the food waste bin only.',
      'Keep it separate from general and recycling waste.',
    ],
    'Food waste separation is a legal requirement for many businesses.',
    'Re-sort it and remind the team.',
  ),
  'Used cooking oil stored / collected': _g(
    [
      'Store cooled waste oil in sealed, labelled containers.',
      'Keep them in a safe area away from drains.',
      'Use only a licensed collector and keep the waste transfer note.',
    ],
    'Oil down drains causes blockages. Illegal disposal brings fines.',
    'Move it to sealed storage and arrange collection.',
  ),

  // ---- Pest control ---------------------------------------------------
  'Pest activity check (droppings/gnaw/nest)': _g(
    [
      'Check corners, under equipment and storage areas.',
      'Look for droppings, gnaw marks, nests, dead insects and smears.',
      'Photograph anything you find.',
    ],
    'An active pest problem can lead to immediate closure by the EHO.',
    'Tell your manager straight away. Remove and bin affected food. Call pest control.',
  ),
  'Fly killer / bait stations working': _g(
    [
      'Check fly killer units are on and the tubes glow.',
      'Check bait stations are in place and not damaged.',
      'Do not move or open bait stations yourself.',
    ],
    'They catch pests before they reach food.',
    'Report it to your manager or pest contractor.',
  ),
  'External bin area secure & clean': _g(
    [
      'Check bin lids are closed.',
      'Pick up any spilled waste.',
      'Check the area is not attracting birds or rodents.',
    ],
    'Outside bins are the main draw for rats and foxes.',
    'Clean up now and report broken bins.',
  ),
  'Pest control contract visit log': _g(
    [
      'Record the contractor\'s visit date.',
      'File or photograph their report.',
      'Note any actions they recommended.',
    ],
    'The EHO will ask to see pest control records.',
    'Ask the contractor for a copy of the report.',
  ),

  // ---- Maintenance & certificates -------------------------------------
  'Equipment fault log reviewed': _g(
    [
      'Go through open faults.',
      'Note what has been fixed and what is waiting.',
      'Chase anything overdue.',
    ],
    'Unfixed faults turn into breakdowns or safety risks.',
    'Escalate overdue repairs to your manager.',
  ),
  'Scheduled servicing up to date': _g(
    [
      'Check the service dates for key equipment.',
      'Note anything due or overdue.',
    ],
    'Regular servicing prevents breakdowns and keeps warranties valid.',
    _certFail,
  ),
  'PAT / electrical inspection in date': _g(
    [
      'Check PAT stickers on portable equipment.',
      'Check the dates are in date.',
    ],
    'Electrical safety testing helps prevent shocks and fires.',
    _certFail,
  ),
  'Extraction/duct professional clean in date': _g(
    [
      'Check the last extraction duct clean certificate (TR19 Grease).',
      'Check it is within the required interval for your usage.',
    ],
    'Insurers often require it. Grease in ducts spreads fire through buildings.',
    _certFail,
  ),
  'Gas safety certificate in date': _g(
    [
      'Find the current gas safety certificate.',
      'Check the expiry date.',
      'Check it covers all gas appliances.',
    ],
    'Commercial gas appliances must be checked by a Gas Safe engineer.',
    _certFail,
  ),

  // ---- Stock control --------------------------------------------------
  'Stock count / par levels': _g(
    [
      'Count each item.',
      'Compare against its par level.',
      'Record the count.',
    ],
    'Accurate stock counts cut waste and stop running out.',
    'Flag items below par for ordering.',
  ),
  'Wastage / spoilage log': _g(
    [
      'Record each item wasted.',
      'Note the quantity and the reason (out of date, dropped, overcooked, etc.).',
    ],
    'Wastage records show where money is being lost.',
    'Log it now from memory.',
  ),
  'Low-stock reorder flagged': _g(
    [
      'Note items running low.',
      'Pass the list to whoever orders.',
    ],
    'Running out mid-service causes substitutions, which can introduce allergens.',
    'Tell the person who orders today.',
  ),
  'High-value stock reconciled': _g(
    [
      'Count high-value items (meat, fish, spirits).',
      'Compare against expected levels.',
      'Record any difference.',
    ],
    'Catches theft, waste and recording errors early.',
    'Report unexplained differences to your manager.',
  ),

  // ---- Opening / closing ----------------------------------------------
  'Opening checklist complete': _g(
    [
      'Work through each item on the opening checklist.',
      'Do the temperature checks first.',
      'Confirm each item.',
    ],
    'Opening checks catch overnight problems before food is served.',
    'Fix problems before service. Tell your manager about anything you can\'t fix.',
  ),
  'All refrigeration temps at open': _g(
    [
      'Check and record every fridge and freezer.',
      'Fridges 8°C or below, freezers -18°C or colder.',
    ],
    'Catches overnight breakdowns before food is used.',
    _tempFail,
  ),
  'Equipment switched on & warmed': _g(
    [
      'Switch on cooking and hot-holding equipment.',
      'Check it reaches temperature before service.',
    ],
    'Food put into cold equipment won\'t be held safely.',
    'Report equipment that won\'t heat.',
  ),
  'No overnight pest / leak / fault': _g(
    [
      'Walk the kitchen and stores.',
      'Look for pest signs, water leaks and anything left on.',
      'Note anything found.',
    ],
    'Problems found early cause less damage.',
    _reportFail,
  ),
  'Closing checklist complete': _g(
    [
      'Work through each item on the closing checklist.',
      'Confirm each item.',
    ],
    'Closing checks protect food, the building and tomorrow\'s shift.',
    'Note anything not done for the opening team and your manager.',
  ),
  'Equipment safely off': _g(
    [
      'Switch off cookers, fryers, grills and hot cupboards.',
      'Leave refrigeration ON.',
      'Turn off gas at the isolator if that is your venue\'s procedure.',
    ],
    'Equipment left on is a fire risk.',
    'Switch it off now and tell your manager.',
  ),
  'Perishables stored / covered / dated': _g(
    [
      'Put all perishable food away in fridges.',
      'Cover and label it.',
      'Raw food below cooked/ready-to-eat food.',
    ],
    'Uncovered food can be contaminated. Raw above cooked can drip.',
    'Store it properly now.',
  ),
  'Final clean-down': _g(
    [
      'Clean and sanitise all surfaces.',
      'Clean floors.',
      'Empty bins.',
    ],
    'A clean kitchen at close stops pests overnight.',
    'Finish it before leaving.',
  ),
  'Premises secured / alarm set': _g(
    [
      'Check all doors and windows are locked.',
      'Check nobody is left inside.',
      'Set the alarm.',
    ],
    'Protects the building and stock overnight.',
    'Tell your manager if anything can\'t be secured.',
  ),

  // ---- Service --------------------------------------------------------
  'Mise en place complete': _g(
    [
      'Check all prep for service is done.',
      'Check prepped food is covered, labelled and chilled.',
    ],
    'Good prep means safer, faster service.',
    'Finish prep or tell the head chef what\'s missing.',
  ),
  'Hot-hold / bain-marie pre-heated': _g(
    [
      'Switch on before service.',
      'Check it reaches 63°C or above before food goes in.',
      'Record it.',
    ],
    'Hot-holding only keeps food hot, it cannot heat up cold food safely.',
    'Do not load food until it reaches temperature. Report it if faulty.',
  ),
  'Specials / allergen info briefed': _g(
    [
      'Tell the team the specials.',
      'Tell them the allergens in each.',
      'Update the allergen chart.',
    ],
    'Staff need to answer customers\' allergy questions correctly.',
    'Brief anyone who missed it before they serve.',
  ),
  'Service fridges stocked & at temp': _g(
    [
      'Stock service fridges.',
      'Check and record the temperature: 8°C or below.',
    ],
    'Service fridges get opened most and warm up fastest.',
    _tempFail,
  ),
  'Dining area cleaned & set': _g(
    [
      'Clean tables, chairs and floors.',
      'Set tables.',
    ],
    'First impressions and hygiene for guests.',
    'Finish before doors open.',
  ),
  'Tables / condiments sanitised': _g(
    [
      'Wipe tables with sanitiser between guests.',
      'Wipe condiment bottles, menus and card machines.',
    ],
    'Shared surfaces spread germs between customers.',
    'Do it before seating the next guests.',
  ),
  'Customer toilets checked & stocked': _g(
    [
      'Check toilets are clean.',
      'Restock soap, towels and toilet roll.',
      'Note and fix any issues.',
    ],
    'Dirty toilets damage your hygiene rating and reputation.',
    'Clean and restock now. Report faults.',
  ),
  'Allergen requests relayed to kitchen': _g(
    [
      'Write the allergen clearly on the order.',
      'Tell the chef in person as well.',
      'Note the order number.',
    ],
    'The kitchen can\'t protect a customer it doesn\'t know about.',
    'Tell the kitchen now. If food has gone out, stop it and check with the chef.',
  ),
  'Coffee machine cleaned & backflushed': _g(
    [
      'Backflush the group heads with cleaner as per the machine instructions.',
      'Purge and wipe the steam wand after every use.',
      'Soak and clean portafilters, baskets and the drip tray.',
    ],
    'Milk and coffee oils build up and grow bacteria.',
    'Clean it before next use.',
  ),
  'Hot buffet display temperature': _g(
    [
      'Probe each hot dish on the buffet.',
      'Record and photograph.',
      'Pass at 63°C or above.',
    ],
    'Buffet food sits out longer and must stay hot.',
    'Replace with freshly cooked food. Below 63°C for over 2 hours: throw away.',
  ),
  'Cold buffet display temperature': _g(
    [
      'Probe each cold dish.',
      'Record and photograph.',
      'Pass at 8°C or below.',
    ],
    'Cold food warms up quickly on display.',
    'Return to the fridge or follow the 4-hour rule. Tell your manager.',
  ),
  'Buffet out-of-temperature time log': _g(
    [
      'Record the time food goes out on display.',
      'Cold food can be out of the fridge for up to 4 hours once only.',
      'Hot food below 63°C can be held for up to 2 hours once only.',
      'Throw away anything past its time.',
    ],
    'This is the legal exemption for display. It only works if the time is recorded.',
    'Throw away food with no recorded start time.',
  ),

  // ---- Bar & cellar ---------------------------------------------------
  'Cellar / keg temperature': _g(
    [
      'Read the cellar thermometer.',
      'Record it.',
      'Cask ale is usually kept at 11-13°C.',
    ],
    'Wrong temperatures spoil beer and cause fobbing.',
    'Check the cellar cooler. Report it if faulty.',
  ),
  'Beer line cleaning': _g(
    [
      'Clean lines at least every 7 days, following the line-cleaner instructions.',
      'Wear gloves and eye protection.',
      'Flush with clean water until there is no cleaner left (test with pH paper if you have it).',
      'Record the date.',
    ],
    'Dirty lines grow yeast and bacteria and make beer cloudy and sour.',
    'Clean the lines before serving. Pour away any beer mixed with cleaner.',
  ),
  'Ice well / scoop hygiene': _g(
    [
      'Clean and sanitise the ice well.',
      'Store the scoop outside the ice, in a holder.',
      'Never use a glass to scoop ice.',
    ],
    'Ice is food. Glass chips in ice are a serious hazard.',
    'If glass may have broken in the ice, empty it all ("burn the ice") and clean the well.',
  ),
  'Post-mix / soda gun cleaned': _g(
    [
      'Remove the nozzle and soak it in warm water.',
      'Clean the gun and holster.',
      'Refit and test.',
    ],
    'Sugary syrups grow mould in nozzles.',
    'Clean before use.',
  ),
  'Glassware condition (no chips)': _g(
    [
      'Check glasses as you polish and stack them.',
      'Remove any chipped or cracked glasses.',
      'Dispose of them safely in a glass bin.',
    ],
    'Chipped glasses cause cuts to customers and staff.',
    'Remove them now.',
  ),
  'Optics / measures verified': _g(
    [
      'Check optics and measures are government-stamped (CE/UKCA or crown mark).',
      'Spirits are sold in 25ml or 35ml (not both). Wine in 125ml, 175ml, 250ml (or multiples).',
      'Check the measures sign is on display.',
    ],
    'Weights and Measures law requires legal measures.',
    'Remove damaged or unstamped measures and tell your manager.',
  ),
  'Open wine / vermouth dated': _g(
    [
      'Label opened bottles with the date opened.',
      'Check against your venue\'s shelf life (wine usually 3-5 days with a stopper).',
      'Discard anything past its time.',
    ],
    'Opened wine spoils and sours.',
    'Bin anything undated or past its time.',
  ),

  // ---- Hotels: F&B ----------------------------------------------------
  'Breakfast buffet temperatures': _g(
    [
      'Probe hot items: 63°C or above.',
      'Probe cold items: 8°C or below.',
      'Record and photograph.',
    ],
    'Breakfast buffets run for hours, so temperature control matters.',
    'Replace out-of-temperature food. Follow the 2-hour (hot) and 4-hour (cold) rules.',
  ),
  'Room service tray temp on dispatch': _g(
    [
      'Probe hot food before it leaves the kitchen: 63°C or above.',
      'Cover food.',
      'Record the reading.',
    ],
    'Food cools down on the way to the room.',
    'Reheat or replace before sending.',
  ),
  'Minibar stock & date check': _g(
    [
      'Check every item\'s date.',
      'Replace out-of-date items.',
      'Check the minibar fridge is cold.',
    ],
    'Guests expect in-date stock. Out-of-date food is a complaint and a risk.',
    'Replace items now.',
  ),
  'Banqueting / function hot-hold log': _g(
    [
      'Probe each hot dish regularly during the function.',
      'Record the time and temperature.',
      'Pass at 63°C or above.',
    ],
    'Large events are a known food poisoning risk.',
    'Below 63°C for over 2 hours: throw away. Tell the head chef.',
  ),
  'Guest allergen request (rooms)': _g(
    [
      'Record the guest\'s allergen and room number.',
      'Pass it to the kitchen in writing.',
      'Confirm the kitchen received it.',
    ],
    'Room service and breakfast must know a guest\'s allergies.',
    'Pass it on now and check any food already sent.',
  ),
  'Poolside / satellite bar hygiene': _g(
    [
      'Check the bar is clean and has hand-washing facilities.',
      'Check ice and food are covered.',
      'Use plastic, not glass, near pools.',
    ],
    'Satellite bars are often missed in hygiene checks.',
    _reportFail,
  ),

  // ---- Management -----------------------------------------------------
  'Daily compliance review / sign-off': _g(
    [
      'Review today\'s completed checks.',
      'Look at every fail and confirm a corrective action was taken.',
      'Sign off.',
    ],
    'Manager sign-off proves the system is checked, not just filled in.',
    'Follow up open fails before signing off.',
  ),
  'Weekly food safety walk-round': _g(
    [
      'Walk every area: kitchen, stores, bar, front of house.',
      'Look at cleanliness, storage, labelling and pest signs.',
      'Photograph any issues.',
      'Assign actions.',
    ],
    'Looking with fresh eyes catches what daily checks miss.',
    'Log each issue as an action with a deadline.',
  ),
  'Corrective actions closed out': _g(
    [
      'Review open corrective actions.',
      'Confirm each was fixed.',
      'Close them out.',
    ],
    'Open actions show an inspector problems weren\'t followed up.',
    'Chase anything still open.',
  ),
  'SFBB / HACCP diary reviewed': _g(
    [
      'Review the food safety diary for the period.',
      'Check every day is complete.',
      'Do the 4-weekly review and note changes.',
    ],
    'The 4-weekly review is part of the SFBB system.',
    'Complete missing entries and note why they were missed.',
  ),
  'EHO / audit readiness check': _g(
    [
      'Check records are up to date and easy to find.',
      'Check training records, pest control and certificates.',
      'Walk the premises as an inspector would.',
    ],
    'Inspections are usually unannounced.',
    'Fix gaps now and tell your manager.',
  ),
  'Staff training records current': _g(
    [
      'Check each food handler has food hygiene training.',
      'Check certificates are recorded.',
      'Note anyone needing training or refresher.',
    ],
    'Food handlers must be trained in proportion to their work.',
    'Book training for anyone missing it.',
  ),
  'Supplier approval / due diligence': _g(
    [
      'Check each supplier is approved.',
      'Check you hold their certificates or audit records.',
    ],
    'You must show you use safe, reputable suppliers.',
    'Get documents from the supplier, or stop using them until approved.',
  ),

  // ---- Cellar gas -----------------------------------------------------
  'CO2/gas monitor check & alarm test': _g(
    [
      'Check the gas monitor is on and showing normal.',
      'Press the test button.',
      'Confirm the alarm sounds.',
    ],
    'CO2 has no smell and can kill in a confined cellar.',
    'Do not enter the cellar alone. Report it and get it repaired urgently.',
  ),
  'Cellar CO2 written risk assessment current': _g(
    [
      'Find the CO2 risk assessment.',
      'Check it has been reviewed recently.',
      'Check it matches the current cellar setup.',
    ],
    'Required by law for cellars with gas cylinders.',
    'Tell your manager to review and update it.',
  ),
  'Cellar ventilation (forced extraction) running': _g(
    [
      'Before entering, check the extraction fan is running.',
      'Leave the door open while inside if possible.',
    ],
    'Ventilation clears any leaked gas.',
    'Do not go in. Report it.',
  ),
  'Keg/cylinder change follows safe procedure': _g(
    [
      'Tell someone before you go into the cellar.',
      'Use proper lifting technique. Get help for heavy kegs.',
      'Secure gas cylinders upright with a chain or strap.',
      'Check connections for leaks after changing.',
    ],
    'Manual handling and gas leaks are the main cellar risks.',
    'Stop and get help. If you hear hissing, leave, close the door and tell your manager.',
  ),
  'Cellar access restricted / signed as gas hazard': _g(
    [
      'Check the cellar door is locked or restricted.',
      'Check the gas hazard sign is on the door.',
    ],
    'Stops untrained people entering a dangerous area.',
    'Lock it and put up a sign. Tell your manager.',
  ),

  // ---- Building compliance --------------------------------------------
  'Fixed wiring inspection (EICR) in date': _g(
    [
      'Find the EICR certificate.',
      'Check the next inspection date.',
      'Commercial premises are usually every 5 years.',
    ],
    'Faulty fixed wiring is a fire risk.',
    _certFail,
  ),
  'Portable appliance (PAT) programme up to date': _g(
    [
      'Check PAT stickers or records.',
      'Check handheld and kitchen equipment is included.',
    ],
    'Portable kitchen equipment gets heavy wear.',
    _certFail,
  ),
  'Emergency lighting test': _g(
    [
      'Use the test key switch.',
      'Walk the building and check every emergency light comes on.',
      'Restore power and record the test.',
    ],
    'Emergency lights guide people out in a power cut. Monthly testing is required.',
    'Report any light that fails for repair.',
  ),
  'Commercial gas appliance safety check': _g(
    [
      'Find the Gas Safe engineer\'s certificate.',
      'Check it is in date (usually every 12 months).',
      'Check every gas appliance is listed.',
    ],
    'Required by law for commercial gas appliances.',
    _certFail,
  ),
  'Gas appliance interlock / ventilation not obstructed': _g(
    [
      'Check nothing is blocking air vents and grilles.',
      'Check interlock sensors aren\'t covered.',
    ],
    'Blocked ventilation can cause carbon monoxide build-up.',
    'Clear it now.',
  ),

  // ---- Legionella -----------------------------------------------------
  'Legionella risk assessment current': _g(
    [
      'Find the Legionella risk assessment.',
      'Check it has been reviewed within 2 years, or since any changes to the water system.',
    ],
    'Required under HSE ACOP L8.',
    'Tell your manager to arrange a review.',
  ),
  'Sentinel outlet temperature check': _g(
    [
      'Run the hot tap for 1 minute, then take the temperature: 50°C or above (55°C in healthcare).',
      'Run the cold tap for 2 minutes, then take the temperature: below 20°C.',
      'Record both.',
    ],
    'Legionella bacteria grow between 20°C and 45°C.',
    'Report to whoever manages your water system. It may need flushing or adjusting.',
  ),
  'Little-used outlet flushing (unoccupied rooms/areas)': _g(
    [
      'Run each little-used tap and shower for a few minutes (until the water temperature is stable).',
      'Hold the shower head low to avoid spray.',
      'Do this at least weekly.',
    ],
    'Stagnant water allows Legionella to grow.',
    'Flush it now and record it.',
  ),
  'Calorifier / tank temperature check': _g(
    [
      'Read the hot water tank temperature.',
      'Record it.',
      'Pass at 60°C or above.',
    ],
    'Stored hot water at 60°C kills Legionella.',
    'Report it to maintenance immediately.',
  ),
  'Shower heads/hoses descaled & inspected for biofilm': _g(
    [
      'Remove the shower head.',
      'Soak in descaler, then clean and disinfect.',
      'Check the hose for slime or damage.',
      'Refit and photograph.',
    ],
    'Scale and slime in showers can harbour Legionella.',
    'Replace damaged heads or hoses.',
  ),
  'Water system log book (L8 record) up to date': _g(
    [
      'Check this month\'s temperature and flushing entries are complete.',
      'Note any gaps.',
    ],
    'Records prove the control scheme is working.',
    'Complete missing checks and note why they were missed.',
  ),

  // ---- Fire safety ----------------------------------------------------
  'Fire extinguisher/blanket service': _g(
    [
      'Check the service tag date (yearly).',
      'Check the pressure gauge is in the green.',
      'Check the fire blanket is in place.',
    ],
    'Extinguishers must work first time.',
    _certFail,
  ),
  'Fire alarm system test (call point)': _g(
    [
      'Warn staff and the alarm company (if monitored) before testing.',
      'Use a different call point each week, with the test key.',
      'Confirm the alarm sounds everywhere.',
      'Reset and record which call point you used.',
    ],
    'Weekly testing is the expected standard.',
    'Report any fault to your fire alarm company urgently.',
  ),
  'Fire door self-closes & seals intact': _g(
    [
      'Open each fire door fully and let go.',
      'It should close fully on its own.',
      'Check the seals and gaps aren\'t damaged.',
      'Never wedge fire doors open.',
    ],
    'Fire doors hold back fire and smoke so people can escape.',
    'Remove any wedges. Report doors that don\'t close.',
  ),
  'Fire risk assessment reviewed/current': _g(
    [
      'Find the fire risk assessment.',
      'Check it has been reviewed in the last year or since any major change.',
    ],
    'Required by the Regulatory Reform (Fire Safety) Order 2005.',
    'Tell your manager to arrange a review.',
  ),
  'Fire drill / evacuation practice': _g(
    [
      'Pick a time and warn the alarm monitoring company (and guests if needed).',
      'Sound the alarm. Everyone leaves by the nearest exit to the assembly point.',
      'Time how long it takes and do a roll call against the staff list.',
      'Note problems (blocked routes, slow areas, people who didn\'t hear the alarm) and who took part.',
    ],
    'Staff who have practised get out faster and help others. Fire law requires fire training.',
    'Fix each problem found and run another drill for anyone who missed it.',
  ),
  'Smoke/heat detectors checked (kitchen & public areas)': _g(
    [
      'Walk every area and look at each detector.',
      'Check it is in place, not covered (no bags, tape or paint) and not damaged.',
      'Check the alarm panel shows no faults.',
      'Note any missing, covered or damaged detectors.',
    ],
    'A covered or broken detector won\'t warn anyone. Kitchens use heat detectors because steam sets off smoke detectors.',
    'Uncover it now if safe. Report damage to your fire alarm company.',
  ),
  'Fire alarm professional service (6-monthly)': _g(
    [
      'Find the last service record from your fire alarm engineer.',
      'Check it is less than 6 months old.',
      'Check any faults they listed have been fixed.',
    ],
    'BS 5839-1 expects a competent engineer to service the system at least every 6 months.',
    _certFail,
  ),
  'Staff fire safety training & fire marshals named': _g(
    [
      'Check every staff member has had fire training (at induction and refreshed regularly).',
      'Check fire marshals are named for each shift.',
      'Check staff know the alarm sound, escape routes and assembly point.',
    ],
    'Fire law requires staff to be trained in what to do in a fire.',
    'Book training for anyone missing it and name a marshal for every shift.',
  ),
  'Fire action notices displayed': _g(
    [
      'Check there is a fire action notice by each call point and exit.',
      'Check it is readable and shows the right assembly point.',
    ],
    'Notices tell staff and guests what to do when the alarm sounds.',
    'Replace missing or damaged notices and tell your manager.',
  ),
  'Sprinkler/suppression system service': _g(
    [
      'Find the service certificate.',
      'Check it matches the manufacturer\'s or insurer\'s schedule.',
    ],
    'Suppression systems must work when needed.',
    _certFail,
  ),

  // ---- Building -------------------------------------------------------
  'Building fault/repair log reviewed & actioned': _g(
    [
      'Go through open faults.',
      'Note what is done and what is waiting.',
      'Chase overdue repairs.',
    ],
    'Small faults become big problems.',
    'Escalate overdue items to your manager.',
  ),
  'HVAC/plant room filters & condition': _g(
    [
      'Check filters aren\'t clogged.',
      'Check the plant room is clean and not used for storage.',
    ],
    'Clogged filters reduce air quality and strain equipment.',
    _reportFail,
  ),
  'Lift/escalator service certificate in date': _g(
    [
      'Find the LOLER thorough examination report.',
      'Check it is in date (passenger lifts every 6 months).',
    ],
    'Required by LOLER regulations.',
    _certFail,
  ),
  'Roof/gutters/external fabric inspected': _g(
    [
      'Look from ground level. Do not climb.',
      'Look for damage, blocked gutters or loose materials.',
      'Photograph anything found.',
    ],
    'Small leaks cause damp, damage and pest entry.',
    _reportFail,
  ),
  'Water ingress / damp check': _g(
    [
      'Check known damp areas.',
      'Look for new stains, mould or wet patches.',
      'Photograph anything found.',
    ],
    'Damp leads to mould and damage to the building.',
    _reportFail,
  ),

  // ---- Housekeeping ---------------------------------------------------
  'Room turnover cleaning checklist complete': _g(
    [
      'Work through the full room-cleaning checklist.',
      'Use separate cloths for bathroom and bedroom (colour-coded).',
      'Tick off each item.',
    ],
    'A checklist makes sure nothing is missed.',
    'Finish the missed items before marking the room ready.',
  ),
  'Room inspection sign-off (post-clean)': _g(
    [
      'Inspect the cleaned room against the standard.',
      'Check the bathroom, bed, surfaces and amenities.',
      'Sign it off as ready.',
    ],
    'Inspection catches mistakes before the guest does.',
    'Send it back for re-cleaning.',
  ),
  'Linen change frequency followed': _g(
    [
      'Check when the linen was last changed.',
      'Change it as required by your policy and on each new guest.',
    ],
    'Guests expect clean linen.',
    'Change it now.',
  ),
  'Laundry wash temperature for hygiene (linen)': _g(
    [
      'Check the wash cycle temperature.',
      'Record it.',
      'Pass at 60°C or above (or 71°C for heavily soiled/infected linen).',
    ],
    'High temperatures kill bacteria in linen.',
    'Re-wash at the right temperature. Report the machine if it won\'t reach it.',
  ),
  'Soiled/contaminated linen handled separately & bagged': _g(
    [
      'Wear gloves.',
      'Bag soiled linen separately in a red/soluble bag if used.',
      'Never shake it out.',
    ],
    'Stops infection spreading to staff and other laundry.',
    'Re-bag it correctly and wash your hands.',
  ),
  'Cleaning chemical dilution & COSHH compliance (housekeeping trolley)': _g(
    [
      'Mix chemicals as per the label.',
      'Use labelled bottles only.',
      'Never mix chemicals (bleach + acid makes toxic gas).',
    ],
    'Wrong mixing is a serious chemical risk.',
    'Empty and remix correctly. Report it.',
  ),
  'COSHH data sheets available for housekeeping chemicals': _g(
    [
      'Check there is a data sheet for every housekeeping chemical.',
      'Check staff know where they are.',
    ],
    'Required by COSHH regulations.',
    'Get missing sheets from the supplier.',
  ),
  'Minibar restocking cross-checked against guest charge': _g(
    [
      'Count what is missing.',
      'Check it matches the guest\'s bill.',
      'Restock.',
    ],
    'Stops lost revenue and billing disputes.',
    'Report differences to reception.',
  ),
  'Unoccupied room water outlet flushing (housekeeping)': _g(
    [
      'Run taps and shower in empty rooms for a few minutes.',
      'Do this at least weekly.',
      'Record it.',
    ],
    'Stagnant water lets Legionella grow.',
    'Flush it now and record it.',
  ),
  'Lost property logged & stored securely': _g(
    [
      'Record what was found, where and when.',
      'Store it securely.',
      'Hand valuables to the manager.',
    ],
    'Protects the guest and the venue.',
    'Log it now.',
  ),
  'Room safety check (smoke alarm present/working, fire notice visible)': _g(
    [
      'Press the smoke alarm test button.',
      'Check the fire notice is on the back of the door.',
    ],
    'Guests rely on these in an emergency.',
    'Do not let the room until it is fixed. Report it now.',
  ),
  'Housekeeping trolley/chemical storage secured when unattended': _g(
    [
      'Lock or secure the trolley whenever you step away.',
      'Keep chemicals out of guests\' reach.',
    ],
    'Children and guests could reach chemicals.',
    'Secure it now.',
  ),

  // ---- Reception ------------------------------------------------------
  'Fire register / in-house guest list accuracy': _g(
    [
      'Check the guest list matches who is checked in.',
      'Update any changes.',
    ],
    'In a fire, the list is used to account for everyone.',
    'Correct it now.',
  ),
  'Key/access control (room key issue & return log)': _g(
    [
      'Log every key or card issued.',
      'Log when it is returned.',
    ],
    'Protects guests\' security.',
    'Chase missing keys and record them.',
  ),
  'Lost key / access card deactivation': _g(
    [
      'Deactivate the lost card in the system immediately.',
      'Issue a new one.',
      'Record it.',
    ],
    'A lost key gives access to a guest\'s room.',
    'Deactivate it now.',
  ),
  'Cash handling reconciliation (till/float)': _g(
    [
      'Count the till and float.',
      'Compare with the expected total.',
      'Record any difference.',
    ],
    'Catches errors and theft.',
    'Report any difference to your manager.',
  ),
  'Guest ID/data handling per policy at check-in': _g(
    [
      'Only take the ID details your policy requires.',
      'Store any copies securely.',
      'Never leave guest details on view.',
    ],
    'UK GDPR requires you to minimise and protect personal data.',
    'Secure the data now and tell your manager.',
  ),
  'Guest data disposal/retention policy followed': _g(
    [
      'Check old guest records are deleted or shredded per policy.',
    ],
    'Data must not be kept longer than necessary.',
    'Dispose of it securely now.',
  ),
  'Incident/complaint log completed & escalated (reception)': _g(
    [
      'Record what happened, when, and who was involved.',
      'Escalate to a manager.',
    ],
    'A clear record protects guests, staff and the venue.',
    'Complete the log now.',
  ),
  'Guest with access/mobility needs - evacuation plan (PEEP) noted': _g(
    [
      'Ask the guest if they need help in an evacuation.',
      'Record it against their booking.',
      'Tell the duty manager.',
    ],
    'Staff must know who needs help in an emergency.',
    'Record it now.',
  ),
  'Emergency contact/next-of-kin info accessible in emergency': _g(
    [
      'Check emergency contact details can be found quickly.',
      'Check they are stored securely.',
    ],
    'Needed fast in an emergency.',
    'Update the records.',
  ),

  // ---- Security & licensing -------------------------------------------
  'Door supervisor SIA licence checked & valid': _g(
    [
      'Check each door supervisor\'s SIA licence card.',
      'Check the photo matches and it is in date.',
      'Photograph it at the start of the shift.',
    ],
    'Door supervisors must hold a valid SIA licence by law.',
    'Don\'t let them work. Tell your manager.',
  ),
  'Challenge 25 / age verification applied': _g(
    [
      'Ask for ID from anyone who looks under 25.',
      'Accept only passport, photo driving licence or PASS card.',
      'Refuse if no valid ID, and record the refusal.',
    ],
    'Selling alcohol to under-18s is a criminal offence.',
    'Refuse the sale and record it.',
  ),
  'CCTV system operational & recording': _g(
    [
      'Check every camera shows a live picture.',
      'Check it is recording.',
    ],
    'Often a licence condition.',
    'Report it to your manager urgently.',
  ),
  'CCTV footage retention period met': _g(
    [
      'Check the oldest stored footage.',
      'Check it meets the retention period in your licence.',
    ],
    'Police may ask for footage.',
    'Report it to your manager.',
  ),
  'Incident log (refusals, ejections, disorder) completed': _g(
    [
      'Record what happened, when, who, and what action was taken.',
      'Be factual.',
    ],
    'Evidence for police and licensing.',
    'Complete it now.',
  ),
  'Keyholder/alarm call-out procedure current': _g(
    [
      'Check the keyholder list is current.',
      'Check the call-out procedure is up to date.',
    ],
    'The alarm company needs to reach someone.',
    'Update it and send it to the alarm company.',
  ),
  'Alarm system test (security)': _g(
    [
      'Tell the alarm company you are testing.',
      'Arm and disarm the system.',
      'Confirm it works.',
    ],
    'An untested alarm may fail when needed.',
    'Report it to the alarm company.',
  ),
  'Emergency/duress alarm (till, reception) tested': _g(
    [
      'Tell the monitoring company first.',
      'Press the duress button.',
      'Confirm the alert is received.',
    ],
    'Staff need help quickly in a threatening situation.',
    'Report it urgently.',
  ),
  'Perimeter/external door security check': _g(
    [
      'Check external doors are secure.',
      'Check fire exits are not locked in a way that stops escape.',
    ],
    'Security must not block fire escape.',
    'Fix it now. Tell your manager.',
  ),
  'Licensing conditions register reviewed': _g(
    [
      'Go through each licence condition.',
      'Confirm the venue is meeting it.',
      'Note any gaps.',
    ],
    'Breaking licence conditions can lead to losing the licence.',
    'Tell your manager about any gap straight away.',
  ),
};
