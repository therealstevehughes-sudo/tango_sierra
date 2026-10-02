import '../../l10n/app_localizations.dart';

// Job title localization (2026-10-02, direct founder bug report) —
// `User.jobTitle` is free text (a label mapped onto a RoleTier, not an
// enum — see job_role.dart's own doc comment on why JobRole and jobTitle
// are deliberately separate concepts), so it was never translated
// anywhere it's shown: switching the app to Spanish still showed "Line
// Chef", "Kitchen Porter" etc. in English, because there was nothing to
// translate FROM — a stored string has no language of its own to detect.
//
// Fix, in two parts:
//  1. A fixed list of common hospitality titles (matching every title
//     this app's own demo data seeds, plus a few other common real-world
//     ones) gets a real translation in all 10 locales. Staff setup now
//     offers these from a dropdown instead of a bare text field, so a
//     NEW staff member's title is stored as one of these exact English
//     canonical strings (same "store the canonical key, localize only at
//     display time" pattern as RoleTier/JobRole).
//  2. `localizedJobTitle()` is the one function every DISPLAY call site
//     now goes through: a canonical title translates: anything else (a
//     genuinely custom title typed via "Custom...", or any pre-existing
//     real customer data from before this fix) passes through unchanged
//     — there is no way to auto-translate truly free text, the same as
//     there's no way to translate a person's actual name.
//
// Deliberately NOT applied to a jobTitle that's already been baked into
// a historical record (TaskSubmission.completedBy, end-of-session
// staffName) — those are a snapshot of who did something at the time,
// not live UI chrome, same reasoning as this app's device-clock
// timestamps never being retroactively reinterpreted either.
const List<String> commonJobTitles = [
  'Kitchen Porter',
  'Commis Chef',
  'Prep Chef',
  'Line Chef',
  'Grill Chef',
  'Sous Chef',
  'Head Chef / Kitchen Manager',
  'Executive Chef',
  'Duty Manager',
  'General Manager',
  'F&B Manager',
  'Functions & Events Supervisor',
  'Regional Manager',
  'Managing Director',
  'Director / MD',
  'Waiter',
  'Waitress',
  'Bartender',
  'Bar Manager',
  'Receptionist',
  'Housekeeping Assistant',
  'Maintenance Technician',
];

String localizedJobTitle(String jobTitle, [AppLocalizations? l10n]) {
  if (l10n == null) return jobTitle;
  switch (jobTitle) {
    case 'Kitchen Porter':
      return l10n.jobTitleKitchenPorter;
    case 'Commis Chef':
      return l10n.jobTitleCommisChef;
    case 'Prep Chef':
      return l10n.jobTitlePrepChef;
    case 'Line Chef':
      return l10n.jobTitleLineChef;
    case 'Grill Chef':
      return l10n.jobTitleGrillChef;
    case 'Sous Chef':
      return l10n.jobTitleSousChef;
    case 'Head Chef / Kitchen Manager':
      return l10n.jobTitleHeadChefKitchenManager;
    case 'Executive Chef':
      return l10n.jobTitleExecutiveChef;
    case 'Duty Manager':
      return l10n.jobTitleDutyManager;
    case 'General Manager':
      return l10n.jobTitleGeneralManager;
    case 'F&B Manager':
      return l10n.jobTitleFbManager;
    case 'Functions & Events Supervisor':
      return l10n.jobTitleFunctionsEventsSupervisor;
    case 'Regional Manager':
      return l10n.jobTitleRegionalManager;
    case 'Managing Director':
      return l10n.jobTitleManagingDirector;
    case 'Director / MD':
      return l10n.jobTitleDirectorMd;
    case 'Waiter':
      return l10n.jobTitleWaiter;
    case 'Waitress':
      return l10n.jobTitleWaitress;
    case 'Bartender':
      return l10n.jobTitleBartender;
    case 'Bar Manager':
      return l10n.jobTitleBarManager;
    case 'Receptionist':
      return l10n.jobTitleReceptionist;
    case 'Housekeeping Assistant':
      return l10n.jobTitleHousekeepingAssistant;
    case 'Maintenance Technician':
      return l10n.jobTitleMaintenanceTechnician;
    default:
      // A genuinely custom title (or pre-existing real data) — there is
      // nothing to translate it from, same as a person's name.
      return jobTitle;
  }
}
