-- Equipment library: first checked packs (2026-10-17).
-- Every step and figure below comes from the manufacturer's own document
-- listed in source_urls (read in full, not summarised by a third party).
-- Where a manual gives no fixed interval ("regularly", "as prompted") the
-- check says so rather than inventing one. Re-runnable: replaces the live
-- entries for these models.

begin;

delete from equipment_models where status = 'live' and (manufacturer, model) in (
  ('Merrychef', 'eikon e4s'), ('Rational', 'iCombi Pro'), ('Foster', 'EcoPro G2'),
  ('Winterhalter', 'UC series'), ('Classeq', 'G350 / G400 / G500'),
  ('Lincat', 'Silverlink 600 fryers'), ('Convotherm', 'Convotherm 4'),
  ('Hoshizaki', 'KM-61 / KM-101 / KM-151'));

insert into equipment_models (manufacturer, model, equipment_type_id, aliases, checks, manual_url, source_urls, checked_on, status) values
('Merrychef', 'eikon e4s', 8, 'merry chef e4 e4s high speed oven accelerated',
 $j$[
  {"title":"Daily clean (cold oven)","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["Run the oven's cool-down from the cleaning menu (about 30 minutes, with a container of ice or cold water inside), then carefully remove the cool-down pan.",
            "Remove the air filter at the base, the rack, the air diffuser and the bottom impinger plate. Wash them in warm soapy water, rinse and dry.",
            "Wearing rubber gloves and eye protection, spray non-caustic Merrychef oven cleaner on the inside surfaces (not the door seal, not into the rear fan opening). Clean with a non-abrasive nylon pad.",
            "Wipe off with plenty of clean warm water, dry, refit all parts and wipe the outside with a damp cloth."],
   "why":"The cavity, door, air filter and grease filter must be kept clean for the oven to work properly and hygienically.",
   "if_fails":"Never use caustic cleaners - they permanently damage the catalytic converters. If the oven shows a filter warning, refit a clean air filter."},
  {"title":"Air filter clean and fitted","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["Remove the air filter at the lower front of the oven.","Wash it, rinse and dry it fully.","Refit it - the oven will not run without the air filter in place."],
   "why":"Merrychef says to clean the air filter every day; never use the oven without a clean air filter.",
   "if_fails":"Do not use the oven without the filter. Replace a damaged filter."},
  {"title":"Door and door seal check","frequency":"weekly","method":"tick","critical":true,"photo":false,
   "steps":["Check the door closes properly and the door seals are not damaged.","Clean the door seal only with mild non-abrasive soap on a soft cloth."],
   "why":"This is a microwave oven: it must not be used if the door or door seals are damaged.",
   "if_fails":"Stop using the oven and call a Merrychef service agent."}
 ]$j$::jsonb,
 'https://www.wasserstrom.com/wcsstore/WasserstromCatalogAssetStore/Attachment/E4S-OperatingManual.pdf',
 array['https://www.wasserstrom.com/wcsstore/WasserstromCatalogAssetStore/Attachment/E4S-OperatingManual.pdf'],
 '2026-10-17', 'live'),

('Rational', 'iCombi Pro', 8, 'rational icombi combi oven icare',
 $j$[
  {"title":"Automatic clean when prompted (iCareSystem)","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["Check the cleaning status on the screen: green is clean; yellow means clean when prompted; red means start a clean as soon as possible.",
            "Remove trays and containers (wear safety gloves). If you have the fat drain, remove the drip pan and close the drain pipe.",
            "Wearing tight-fitting safety glasses and chemical-resistant gloves, put the number of Active Green cleaner tabs shown on screen in the floor drain sieve, and the care tabs in the care drawer.",
            "Close the door - cleaning starts. Keep the door closed until the signal tone. Do not leave the core probe hanging out of the cabinet."],
   "why":"The iCareSystem cleans and descales the steam generator. Use only RATIONAL Active Green cleaner tabs and care tabs.",
   "if_fails":"Skin contact: rinse 10 minutes; eyes: rinse 15 minutes; swallowed: rinse mouth, drink two glasses of water, call a doctor. If foam builds up, use fewer tabs; if it continues, call your RATIONAL Service Partner."},
  {"title":"Remove cleaner residue before cooking","frequency":"daily","method":"tick","critical":true,"photo":false,
   "steps":["After a clean, open the door and check for tab residue.","Remove any cleaning products or residue before preheating for cooking."],
   "why":"Cleaning chemicals are corrosive and must not get into food.",
   "if_fails":"Rinse the cabinet with water and check again before use."},
  {"title":"Care (limescale) status check","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["Check the care status indicator: green means the steam generator is free of limescale.","If it is yellow or red, run a cleaning programme with care tabs at the next prompt (red: as soon as possible)."],
   "why":"Limescale in the steam generator affects cooking and damages the unit.",
   "if_fails":"If it stays red after cleaning, contact your RATIONAL Service Partner."}
 ]$j$::jsonb,
 'https://www.rational-online.com/media/downloads/anwendungshinweise/tabs/rational-anwendungshinweise-icombi-pro-activegreen-caretabs-en-us.pdf',
 array['https://www.rational-online.com/media/downloads/anwendungshinweise/tabs/rational-anwendungshinweise-icombi-pro-activegreen-caretabs-en-us.pdf'],
 '2026-10-17', 'live'),

('Foster', 'EcoPro G2', 1, 'foster ecopro g2 cabinet counter fridge freezer',
 $j$[
  {"title":"Condenser clean","frequency":"monthly","method":"tick","critical":false,"photo":true,
   "steps":["Put the unit into standby and switch off at the mains.","Wearing suitable PPE, remove dust from the condenser with a soft brush or vacuum cleaner. Do not use a wire brush.","Brush or vacuum the air filter where fitted.","Switch back on once done and dry. Photograph the clean condenser."],
   "why":"Foster says to clean the condenser every 4 to 6 weeks (trained person); a dirty condenser can stop the unit holding temperature and may invalidate the warranty.",
   "if_fails":"Stubborn grease on or through the condenser: call your supplier for a full service."},
  {"title":"Door gaskets inspected and cleaned","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["Inspect every door gasket for damage.","Clean with a warm damp soapy cloth, then a clean damp cloth, then dry thoroughly."],
   "why":"Damaged gaskets let warm air in.",
   "if_fails":"Replace damaged gaskets - report it to your manager."},
  {"title":"Interior and shelves clean","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["Switch off at the mains and remove product and shelving (beware of cold or sharp parts).","Clean inside and out with mild liquid detergent, then rinse with a damp cloth and clean water. Never use wire wool, scouring pads, bleach, acids or chlorine cleaners.","Shelves are dishwasher safe; clean the vertical supports with warm soapy water, rinse and dry.","Switch back on only when clean and dry."],
   "why":"Clean cabinets stop bacteria spreading to stored food.",
   "if_fails":"Re-clean before restocking."}
 ]$j$::jsonb,
 'https://www.caterkwik.co.uk/shop/downloads/PROG600F_EP700F%20OP%20MAN.pdf',
 array['https://www.caterkwik.co.uk/shop/downloads/PROG600F_EP700F%20OP%20MAN.pdf'],
 '2026-10-17', 'live'),

('Winterhalter', 'UC series', 46, 'winterhalter uc-s uc-m uc-l uc-xl undercounter glasswasher dishwasher',
 $j$[
  {"title":"End-of-day self-clean and interior clean","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["At the end of the working day, switch the machine off using the guided self-cleaning programme, so it is cleaned and emptied.","Wear protective clothing and gloves before touching parts in wash water (filters, wash fields).","Remove dirt from the interior with a brush or cloth. Clean the strainer and filter cylinder; operate only with the filter system fully inserted.","Check the rinse jets are not blocked by limescale."],
   "why":"Daily cleaning and emptying keeps wash results hygienic.",
   "if_fails":"Never use high-pressure cleaners, chlorine or acid cleaners, metal brushes or abrasives. Rinse jets heavily blocked with limescale: call an authorised service technician."},
  {"title":"Regeneration salt topped up (water softener models)","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["If the display shows the salt pictogram, refill the salt container.","Use only regeneration salt or pure evaporated salt (fine grain) - no table salt, de-icing salt or tablets.","Top up before the self-cleaning programme, then run a wash cycle or self-clean to wash away salt residue."],
   "why":"Softened water stops limescale on the machine and glasses.",
   "if_fails":"Never put detergent or rinse aid in the salt container - it damages the softener."},
  {"title":"Annual service booked","frequency":"annually","method":"tick","critical":false,"photo":false,
   "steps":["Check the last service date.","Book an authorised service technician at least once a year."],
   "why":"Winterhalter recommends maintenance at least once a year to check and replace wearing parts.",
   "if_fails":"Tell your manager and book it."}
 ]$j$::jsonb,
 'https://www.caterkwik.co.uk/shop/downloads/UCLG_UC%20Operating%20Instructions.pdf',
 array['https://www.caterkwik.co.uk/shop/downloads/UCLG_UC%20Operating%20Instructions.pdf'],
 '2026-10-17', 'live'),

('Classeq', 'G350 / G400 / G500', 46, 'classeq undercounter glasswasher warewasher d400 d500',
 $j$[
  {"title":"Interior clean after service","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["Drain down the machine after service.","Remove and clean the top and bottom rinse and wash arms, the primary filters and the secondary filters.","Clean the wash tank with a sponge or brush, including apertures and outlets, and around the door hinge.","Refit all arms and filters before switching on. Wipe the outside with a damp (not wet) sponge, then stainless steel cleaner."],
   "why":"Classeq recommends daily cleaning for good hygiene.",
   "if_fails":"Do not use steel wool, wire brushes or abrasives."},
  {"title":"Softener salt refilled (if fitted)","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["If the Refill Salt light is on, open the door, remove the right-hand basket guide and the salt cap.","Fill with granulated salt (not tablets) using the funnel; wipe away spilt salt.","Refit the cap flat and secure (do not overtighten), then drain and refill the machine."],
   "why":"Without salt, limescale builds up - limescale damage is not covered by the warranty.",
   "if_fails":"Never put detergent or rinse aid in the salt reservoir."},
  {"title":"Wash tank descale (hard water)","frequency":"monthly","method":"tick","critical":false,"photo":false,
   "steps":["Wear gloves and goggles.","Take the chemical tubes out of the bottles and prime water through, then fill and drain to clear chemical residue.","Refill, then descale following the descaler packaging - never leave descaler in for more than 2 hours.","Drain, then refill and drain at least 3 times; refit the chemical tubes and prime the pumps."],
   "why":"Limescale ruins wash results. The rinse boiler can only be descaled by a service engineer.",
   "if_fails":"Call your service engineer for rinse boiler scale."}
 ]$j$::jsonb,
 'https://caterkwik.co.uk/shop/downloads/G350_Classeq-G350-User-Manual.pdf',
 array['https://caterkwik.co.uk/shop/downloads/G350_Classeq-G350-User-Manual.pdf'],
 '2026-10-17', 'live'),

('Lincat', 'Silverlink 600 fryers', 7, 'lincat silverlink df33 df36 df39 df49 df66 df612 df618 j6 j9 j18 electric fryer',
 $j$[
  {"title":"Tank and element clean","frequency":"weekly","method":"tick","critical":true,"photo":false,
   "steps":["Isolate the power and let the oil cool below 55°C, then drain it into a suitable container. Never move the fryer with oil in it.","Remove the batter plate, then lift the element with the lifting hook until the stay latches.","Clean the tank and element with hot water and a little mild detergent; use Carb'n'Off or similar for carbon. Make sure every part is completely dry.","Lower the element, refit the batter plate, close the drain valve and refill with oil up to (not over) the high-level mark."],
   "why":"Water in oil causes splashing and overflow; carbon and old oil are a fire risk.",
   "if_fails":"If the green light is on but it won't heat, the high-temperature cut-out on the back panel may need resetting. If it smokes, switch off at once."},
  {"title":"Oil level above minimum","frequency":"daily","method":"tick","critical":true,"photo":false,
   "steps":["Before frying, check the oil is above the minimum mark and not above the high-level mark.","Never leave the fryer unattended while frying."],
   "why":"Low oil can overheat; overfilling can overflow.",
   "if_fails":"Top up with good-quality oil (with the fryer off and cool) or drain the excess."},
  {"title":"Six-monthly service","frequency":"sixMonthly","method":"tick","critical":false,"photo":false,
   "steps":["Check the date of the last service.","Book a competent engineer (Lincat authorised agent) every six months."],
   "why":"Lincat recommends a service every six months.",
   "if_fails":"Tell your manager and book it."}
 ]$j$::jsonb,
 'https://caterkwik.co.uk/shop/downloads/DF618_DF33%20DF36%20DF39%20USER%20MANUAL.pdf',
 array['https://caterkwik.co.uk/shop/downloads/DF618_DF33%20DF36%20DF39%20USER%20MANUAL.pdf'],
 '2026-10-17', 'live'),

('Convotherm', 'Convotherm 4', 8, 'convotherm 4 easydial easytouch combi oven convoclean',
 $j$[
  {"title":"Automatic clean (ConvoClean)","frequency":"daily","method":"tick","critical":false,"photo":false,
   "steps":["Let the oven cool if hot, open and empty it, and check the cleaning agent and rinse aid supply and connections.","Press Clean and choose a level: 1 light to 4 very heavy (all include steam disinfection and drying).","Close the door - cleaning starts automatically.","When done, check the inside, clean the oven drain and leave the door ajar."],
   "why":"Daily cleaning keeps the oven hygienic; refer to the unit's instructions for the schedule.",
   "if_fails":"If the screen says out of rinse aid, out of cleaning agent or not enough water, fix that and restart. Never spray water inside while the oven is hot."},
  {"title":"Weekly manual clean","frequency":"weekly","method":"tick","critical":false,"photo":false,
   "steps":["Clean the fan screen by hand with a slightly damp cloth and dishwashing liquid.","Wipe the hygienic removable door gasket with a soft cloth and dishwashing liquid, then with water.","Clean the door drip tray the same way."],
   "why":"These parts are not fully reached by automatic cleaning.",
   "if_fails":"Replace a damaged gasket - report it to your manager."}
 ]$j$::jsonb,
 'https://res.katom.com/products/768/768-C4ED620GSNG/768-C4ED620GSNG_cleaning.pdf',
 array['https://res.katom.com/products/768/768-C4ED620GSNG/768-C4ED620GSNG_cleaning.pdf'],
 '2026-10-17', 'live'),

('Hoshizaki', 'KM-61 / KM-101 / KM-151', 17, 'hoshizaki km61 km101 km151 ice maker cuber',
 $j$[
  {"title":"Ice scoop washed","frequency":"daily","method":"tick","critical":true,"photo":false,
   "steps":["Wash the scoop with dish soap and rinse well.","Store it outside the ice."],
   "why":"Ice is food - a dirty scoop contaminates it.",
   "if_fails":"Wash and sanitise it before using it again."},
  {"title":"Exterior and bin door wiped","frequency":"monthly","method":"tick","critical":false,"photo":false,
   "steps":["Wipe the exterior with warm water and a clean cloth.","Clean the bin door and top with dish soap and a damp cloth."],
   "why":"Part of Hoshizaki's cleaning schedule.",
   "if_fails":"Clean it now."},
  {"title":"Clean and sanitise (at least yearly)","frequency":"annually","method":"tick","critical":true,"photo":false,
   "steps":["Follow the cleaning label inside the front panel or the instruction manual: clean with Hoshizaki ScaleAway, then sanitise with diluted bleach (about 200 ppm) - never mix the two, and never use ammonia cleaners.","Rinse parts and bin thoroughly; clean the water inlet screen; inspect the condenser and water hoses.","Discard the first batch of ice. Never leave the machine unattended with panels off."],
   "why":"Hoshizaki: the ice maker must be cleaned and sanitised at least once a year (more often in hard-water areas).",
   "if_fails":"Use a Hoshizaki certified service technician if unsure."}
 ]$j$::jsonb,
 'https://cdn.restaurantsupply.com/pdf/5/1/0/51011-KM-61-101-151CleaningSheet.pdf',
 array['https://cdn.restaurantsupply.com/pdf/5/1/0/51011-KM-61-101-151CleaningSheet.pdf'],
 '2026-10-17', 'live');

commit;
