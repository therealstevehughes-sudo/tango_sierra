# IoT temperature sensors — pre-trade-show brief (2026-10-16)

For the founder's London trade show (Chinese manufacturers, Nov 2026). Desk research only; supplier claims below are unverified marketing until certificates are seen.

## What VenuRite needs from a sensor
- Fridge/freezer/walk-in air temperature, plus a **probe option** (food-simulant or cable probe through the door seal) — air readings swing every time a door opens.
- Accuracy ±0.5°C or better (records need roughly ±1°C; tighter avoids false alarms).
- Works through steel and from cellars: **LoRaWAN** is the best fit (long range, years of battery, one gateway per venue). Zigbee/WiFi consumer sensors are cheaper but weaker indoors and not food-grade.
- Stores readings when the connection drops and re-sends them (no gaps in the record).
- Food-safe, washable housing (IP65+), works at -30°C.
- **Open data format / standard LoRaWAN** so VenuRite can read it directly — avoid sensors locked to the maker's own cloud app.

## Names to look for at the show
| Maker | Type | Notes |
|---|---|---|
| Milesight (Xiamen) | LoRaWAN — EM320-TH, TS30x (probe) | Sold internationally, IP67, on-device storage; markets HACCP use |
| Dragino (Shenzhen) | LoRaWAN — LHT65N (external probe), LTC2-FS food-safety probe | Standard LoRaWAN, ~US$80 for the probe unit |
| Tzone (Shenzhen) | LoRa/LoRaWAN sensors + gateways | Since 2006, cold chain + catering |
| Nantong Super Intelligence | LoRaWAN TS301/TS302 | Listed US$149 small orders → US$59 at 1,000+ |
| Freshliance (Zhengzhou) | Freezer kit + 4G LoRa gateway | ~US$120–160, MOQ 10 |
| Elitech | Standalone USB/Bluetooth loggers | Cheap but not networked — not suitable for live alerts |
| Tuya (many white-labels) | Zigbee/WiFi consumer | Avoid for compliance: consumer-grade, cloud-locked |

## Price benchmarks (UK)
- Consumer WiFi sensors: ~£25–35 each, no fees.
- Professional (e.g. Aranet): ~£65 per sensor + ~£249 gateway, ex VAT.
- Commercial loggers (Comark RF311): ~£160 each + subscription.
- Incumbent UK systems (Checkit, SmartSense, Navitas, Food Alert): prices not published — quote-only, usually hardware + monthly fee.
- Typical venue: 4–10 sensors + 1 gateway. At ~US$60–80/sensor wholesale, hardware cost per venue ~£300–700.

## Questions to ask every supplier
1. Is it standard LoRaWAN (EU868)? Can we decode the data ourselves (payload documentation)?
2. Accuracy and calibration certificate per unit? Can it be recalibrated?
3. Probe options for food simulant / through-seal cable? Operating range down to -40°C?
4. Battery life at a 5–10 minute reading interval?
5. Buffers readings when offline and re-sends?
6. Certificates: CE/UKCA (Radio Equipment Regulations), RoHS, ISO 9001 — and a **UK PSTI** security statement (required for connectable products sold in the UK). Ask for the actual documents, not a logo.
7. White-label / our logo, MOQ, unit price at 100 / 500 / 1,000, warranty, UK spares lead time.
8. Gateway: Ethernet + 4G backup? Who supplies the network server (we'd want our own or a standard one like The Things Stack)?

## Compliance watch-outs
- UK: Radio Equipment Regulations 2017 (UKCA, CE currently accepted) and the PSTI regime are separate — RED compliance doesn't cover PSTI.
- EU: radio-equipment cyber requirements apply from 1 Aug 2025; Cyber Resilience Act from 2027. Matters when expanding.
- "HACCP-compliant" on a sensor is a marketing phrase — there is no HACCP certificate for a sensor. Compliance comes from the records VenuRite keeps.

## Suggested approach
Buy 3–5 sample units each from 2–3 LoRaWAN makers (Milesight + Dragino first), plus one gateway, and run them in a real kitchen for a month before any volume order.

## Sources
- https://www.milesight.com/iot/product/lorawan-sensor/ts30x
- https://www.milesight.com/iot/solution/cold-chain-temperature-monitoring
- https://mydevices.com/product/dragino-ltc2-fs-food-safety-type-industrial-lorawan-temperature-transmitter/
- https://invibitshop.com/products/dragino-ltc2-fs-lorawan-food-safe-temp-transmitter
- https://www.tzonetemperature.com/tzdlpre/freezer-monitoring-system
- https://super-intelligence.en.made-in-china.com/product/yUNpejOTkuhk/China-HACCP-Compliant-Lorawan-Temperature-Sensor-for-Food-Safety-Monitoring.html
- https://www.accio.com/plp/wireless-pharmaceutical-freezer-monitoring
- https://www.gmciuk.com/Food_Storage_Temperature_Monitoring
- https://flux-iot.com/blog/best-temperature-monitoring-devices-for-restaurants
- https://flux-iot.com/blog/best-temperature-data-loggers-food-businesses
- https://smarthomescene.com/reviews/best-selling-zigbee-temperature-sensors-tested/
- https://www.element.com/resources/white-papers/understanding-the-cybersecurity-requirements-for-red-psti-and-cra
- https://www.bsigroup.com/siteassets/pdf/en/insights-and-media/media/webinars/bsi-md-eu-radio-equipment-directive-webinar-110325-en-gb.pdf
