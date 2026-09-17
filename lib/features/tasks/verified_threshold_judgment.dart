// Ad-hoc temperature checks — the switch-on seam (2026-09-17).
//
// The legal/FSA temperature thresholds already loaded onto TaskTemplate
// (minLimit/maxLimit/legalLimitCategory — see app_database.dart's Cluster A
// seed data) have NOT gone through the food-safety professional's sign-off
// yet (an existing, logged, open gate — see DECISIONS_LOG.md). The scheduled
// carousel already auto-judges some numeric tasks against them regardless
// (a pre-existing choice, not touched by this file); this build takes a
// deliberately MORE cautious line for the brand-new ad-hoc temperature
// check path specifically, per the user's explicit instruction: record the
// reading only, assert no pass/fail judgment, and hard-code no threshold
// value anywhere.
//
// This function is the ONLY place that can ever change that. It returns
// null today — every ad-hoc temperature submission gets the neutral
// 'LOGGED' status as a result (see AdHocTaskScreen). Once the sign-off gate
// closes and real verified thresholds exist, wiring them in here is the
// ONLY change needed to switch on auto-judgment for every ad-hoc
// temperature check submitted from that point on — no rebuild of the
// ad-hoc feature itself, no changes to AdHocTaskScreen, AdHocTaskKind, or
// anything that calls this.
String? verifiedJudgmentFor(String? legalLimitCategory, double valueCelsius) {
  return null;
}
