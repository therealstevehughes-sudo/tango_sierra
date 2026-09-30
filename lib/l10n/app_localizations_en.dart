// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get personalSection => 'Personal';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageSettingSubtitle =>
      'Choose the language VenuRite uses for you.';

  @override
  String get languageUpdated => 'Language updated.';

  @override
  String get chooseLanguageTitle => 'Choose language';

  @override
  String get languageDeviceScope => 'Used on this device before staff sign in.';

  @override
  String languageUserScope(String name) {
    return 'Saved for $name.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get login => 'LOGIN';

  @override
  String get back => 'Back';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get leadershipAccess => 'Leadership Access';

  @override
  String get notOnThisList => 'Not on this list? Sign in another way';

  @override
  String errorLoadingStaff(String error) {
    return 'Error loading staff: $error';
  }

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Too many wrong attempts. Try again in $minutes min.';
  }

  @override
  String get accountNotFound => 'Account not found';

  @override
  String get getStarted => 'Get started';

  @override
  String get kitchenComplianceDoneRight => 'Kitchen compliance, done right';

  @override
  String get valuePointEhoReady =>
      'Always EHO-ready - real-time compliance, not a once-a-year scramble';

  @override
  String get valuePointHonestRecords =>
      'Built so results can\'t be gamed - every check is honest, every record stands up';

  @override
  String get valuePointAuditExport =>
      'One-tap audit export - hand an inspector a real record, instantly';

  @override
  String get howGetStarted => 'How would you like to get started?';

  @override
  String get setUpMyBusiness => 'Set up my business';

  @override
  String get teamAlreadyUses => 'My team already uses VenuRite';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get needHelpContact => 'Need help? Contact VenuRite';

  @override
  String get signInAnotherWay => 'Sign in another way';

  @override
  String get deviceNotSetUp => 'This tablet isn\'t set up yet';

  @override
  String get askManagerSetupCode =>
      'Ask a manager for this venue\'s setup code.';

  @override
  String get setupCode => 'Setup code';

  @override
  String get connectTablet => 'Connect this tablet';

  @override
  String get couldNotReachServer => 'Could not reach the server';

  @override
  String get stillStuckSetupCode =>
      'Still stuck? A manager can find this in Settings -> Venue Details.';

  @override
  String get askQuestionTitle => 'Ask a question';

  @override
  String get askQuestionLabel => 'What do you want to know?';

  @override
  String get askQuestionHint => 'e.g. What temperature should a fridge be?';

  @override
  String get ask => 'Ask';

  @override
  String get aiQuestionLimitReached => 'AI question limit reached this month';

  @override
  String get home => 'Home';

  @override
  String get logOut => 'Log out';

  @override
  String get endShift => 'End shift';

  @override
  String get workerHubPrompt => 'What would you like to do?';

  @override
  String get myScheduledTasks => 'My scheduled tasks';

  @override
  String get doAdHocTask => 'Do an ad-hoc task';

  @override
  String get logSomethingHappened => 'Log something that just happened';

  @override
  String get claimShift => 'Claim a shift';

  @override
  String get requestDayOff => 'Request a day off';

  @override
  String get thingsIReported => 'Things I\'ve reported';

  @override
  String shiftWelcome(String firstName) {
    return 'Welcome, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Here\'s what\'s on for your shift:';

  @override
  String get startOfShift => 'Start of shift';

  @override
  String get duringYourShift => 'During your shift';

  @override
  String get endOfShift => 'End of shift';

  @override
  String get shiftHandoverTitle => 'Shift Handover';

  @override
  String get shiftHandoverNeedsAttention =>
      'This still needs the next shift\'s attention';

  @override
  String get gotIt => 'Got it';

  @override
  String get openIssues => 'Open issues';

  @override
  String get flaggedEquipment => 'Flagged equipment';

  @override
  String get notYetDoneToday => 'Not yet done today';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get uploadFromFiles => 'Upload from Files';

  @override
  String get seeAllTasksTooltip => 'See all tasks';

  @override
  String get leaveBeforeFinishingTitle => 'Leave before finishing?';

  @override
  String get leaveBeforeFinishingBody =>
      'Some checks aren\'t complete. This will be recorded. You can return and finish anytime this shift.';

  @override
  String get enterValue => 'Enter value';

  @override
  String enterValueWithUnit(String unit) {
    return 'Enter value ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Safe: $min - $max';
  }

  @override
  String get errorNumericRequired => 'A valid numeric value is required';

  @override
  String get errorSelectOption => 'Please select an option';

  @override
  String get errorNotesRequired => 'Notes required';

  @override
  String get errorPhotoRequired => 'Photo required';

  @override
  String get errorCorrectiveActionRequired =>
      'Choose how the corrective action was handled';

  @override
  String get myTasksTitle => 'My Tasks';

  @override
  String get taskTitleFallback => 'Task';

  @override
  String get noTasksAssigned => 'No tasks assigned yet.';

  @override
  String get overdueLabel => 'Overdue';

  @override
  String overdueSinceLabel(String date) {
    return 'Overdue since $date';
  }

  @override
  String get withinRangePass => 'Within range - PASS';

  @override
  String get outsideRangeFail => 'Outside range - FAIL';

  @override
  String get selectOptionLabel => 'Select option';

  @override
  String get notesLabel => 'Notes';

  @override
  String get spotCheckPhotoNotice =>
      'Today\'s spot-check - a photo is needed this time to confirm this was actually done.';

  @override
  String get photoAdded => 'Photo Added';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get passLabel => 'PASS';

  @override
  String get failLabel => 'FAIL';

  @override
  String get readingOutsideSafeRange => 'Reading is outside the safe range';

  @override
  String get hereIsWhatToDo => 'Here\'s what to do:';

  @override
  String get correctiveActionRequired => 'Corrective action required';

  @override
  String get iFixedIt => 'I fixed it';

  @override
  String get reportedToManager => 'Reported to manager';

  @override
  String get correctiveActionNoteLabel => 'What did you do? (optional)';

  @override
  String get managerWillBeNotified => 'Your manager will be notified.';

  @override
  String get submitButton => 'SUBMIT';

  @override
  String availableFrom(String time) {
    return 'Available from $time';
  }

  @override
  String get backToList => 'Back to list';

  @override
  String get skipComesBackLater => 'Skip - comes back later';

  @override
  String get noAdHocTaskTypesSetUp =>
      'No ad-hoc task types are set up at this site yet - ask a manager to assign a delivery-check or temperature-check task template first.';

  @override
  String get whatKindOfThing => 'What kind of thing are you doing?';

  @override
  String get notesOptionalLabel => 'Notes (optional)';

  @override
  String get noteOptionalLabel => 'Note (optional)';

  @override
  String get temperatureCelsiusLabel => 'Temperature (°C)';

  @override
  String get submitLabel => 'Submit';

  @override
  String get logReadingButton => 'Log reading';

  @override
  String get loggedThanksMessage => 'Logged. Thanks for recording this.';

  @override
  String get logAnotherAdHocTask => 'Log another ad-hoc task';

  @override
  String get deliveryCheckLabel => 'Delivery check';

  @override
  String get temperatureCheckLabel => 'Temperature check';

  @override
  String get sessionSummaryTitle => 'Session Summary';

  @override
  String tasksCompletedCount(int count) {
    return 'Tasks completed: $count';
  }

  @override
  String get passedLabel => 'Passed';

  @override
  String get failedLabel => 'Failed';

  @override
  String get triggersFailedTasks => 'Triggers / Failed tasks';

  @override
  String get yourReliability => 'Your reliability';

  @override
  String get reliabilityExplanation =>
      'Last 30 days - checks completed and logged on time. A logged fail counts the same as a logged pass: this only measures whether you checked and when.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% completed';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% on time';
  }

  @override
  String get sendSummaryToManager =>
      'Send this summary to a manager (optional)';

  @override
  String get noManagersSetUp => 'No managers set up yet.';

  @override
  String get managerLabel => 'Manager';

  @override
  String get sentLabel => 'Sent';

  @override
  String get sendLabel => 'Send';

  @override
  String get leaveNoteForNextShift =>
      'Leave a note for the next shift (optional)';

  @override
  String get handoverNoteLabel => 'Handover note';

  @override
  String get doneLabel => 'Done';

  @override
  String get supplierOptionalLabel => 'Supplier (optional)';

  @override
  String supplierWarningRecorded(String status) {
    return 'This supplier is marked $status - the check will still be recorded.';
  }

  @override
  String get reportProblemWithDelivery => 'Report a problem with this delivery';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperature on arrival (°C, optional)';

  @override
  String get problemsTickAnyApply => 'Problems (tick any that apply)';

  @override
  String get shortDeliveryLabel => 'Short delivery';

  @override
  String get damagedStockLabel => 'Damaged stock';

  @override
  String get lateDeliveryLabel => 'Late delivery';

  @override
  String get qualityProblemLabel => 'Quality problem';

  @override
  String get outcomeLabel => 'Outcome';

  @override
  String get acceptedLabel => 'Accepted';

  @override
  String get rejectedLabel => 'Rejected';

  @override
  String get partiallyAcceptedLabel => 'Partially accepted';

  @override
  String get noCameraFound => 'No camera was found on this device.';

  @override
  String couldNotStartCamera(String error) {
    return 'Could not start the camera: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'Could not switch camera: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'Could not capture a photo: $error';
  }

  @override
  String get switchCameraTooltip => 'Switch camera';

  @override
  String get allTasksTitle => 'All Tasks';

  @override
  String get otherSegmentLabel => 'Other';

  @override
  String get reorderTasksTitle => 'Reorder Tasks';

  @override
  String get ungroupedLabel => 'Ungrouped';

  @override
  String get taskOrderSaved => 'Task order saved.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'Could not save task order: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'No venue selected yet. Set an active venue from Venue Details before reordering tasks.';

  @override
  String get noActiveTasksToReorder =>
      'No active tasks to reorder yet. Assign tasks first, then return here to choose their order.';

  @override
  String get savingEllipsis => 'Saving…';

  @override
  String get saveOrderLabel => 'Save Order';

  @override
  String get moveUpTooltip => 'Move up';

  @override
  String get moveDownTooltip => 'Move down';

  @override
  String get accountRestrictedTitle => 'Account restricted';

  @override
  String get accountRestrictedBody =>
      'This organisation\'s Direct Debit needs attention before new checks can be saved. Your work isn\'t lost - please tell a manager or Director to sort out billing, then try again.';

  @override
  String get okLabel => 'OK';

  @override
  String get troubleshootingTitle => 'Troubleshooting';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get helpTitle => 'Help';

  @override
  String get couldntReachAssistant => 'Couldn\'t reach the assistant';

  @override
  String get aiOfflineBody =>
      'The AI assistant isn\'t reachable right now - could be your connection, or the service is temporarily down. In the meantime, FAQ and Troubleshooting below cover the most common questions, or contact VenuRite directly.';

  @override
  String get askQuestionSubtitle => 'Get a straight answer, in plain language';

  @override
  String get faqSubtitle => 'Common questions, answered';

  @override
  String get troubleshootingSubtitle => 'Something not working? Start here';

  @override
  String get contactVenuriteTitle => 'Contact VenuRite';

  @override
  String get contactVenuriteSubtitle => 'Get in touch directly';

  @override
  String get topTierViewTitle => 'Top-Tier View';

  @override
  String get everythingsDone => 'Everything\'s done. Nice work.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks not completed:',
      one: '1 task not completed:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Back to shift';

  @override
  String get finishShiftLabel => 'Finish shift';

  @override
  String get ehoAuditExportTitle => 'EHO / Audit Export';

  @override
  String get ehoExportDescription =>
      'Generates a PDF of this venue\'s compliance records for the chosen date range.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Select date range';

  @override
  String get tapToChooseDates => 'Tap to choose a start and end date.';

  @override
  String get includeFullDetailedLog => 'Include full detailed log';

  @override
  String get fullLogSubtitle =>
      'Off by default - the summary and exceptions above are what an inspector actually reviews; this adds every individual check on top.';

  @override
  String get generateLabel => 'Generate';

  @override
  String get exportFailedTitle => 'Export Failed';

  @override
  String exportFailedBody(String error) {
    return 'Export failed: $error';
  }

  @override
  String get exportCreatedTitle => 'Export Created';

  @override
  String savedToLabel(String path) {
    return 'Saved to:\n$path';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get noVenueFound => 'No venue found.';

  @override
  String get allPermittedVenuesLast30Days =>
      'All permitted venues · last 30 days';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count FAILs (30 days)',
      one: '1 FAIL (30 days)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count overdue';
  }

  @override
  String get venuesSectionTitle => 'Venues';

  @override
  String get teamSectionTitle => 'Team';

  @override
  String get noStaffAtVenue => 'No staff at this venue yet.';

  @override
  String get notEnoughDataYet => 'Not enough data yet';

  @override
  String get venueFallbackLabel => 'Venue';

  @override
  String get trendsTitle => 'Trends';

  @override
  String get trendNeedsHistory =>
      'Trend data: need at least 4 weeks of history to show a trend.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Per-venue weekly completion · last $weeks weeks';
  }

  @override
  String get allVenuesCombined => 'All venues combined';

  @override
  String get noVenuesYet => 'No venues yet.';

  @override
  String get otherVenuesLabel => 'Other venues';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$completed of $total checks logged';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Region #$id';
  }

  @override
  String get dashboardOverviewTitle => 'Dashboard Overview';

  @override
  String get gradedBarsOnTooltip => 'Per-employee graded bars: on';

  @override
  String get gradedBarsOffTooltip => 'Per-employee graded bars: off';

  @override
  String get noBranchesToShow => 'No branches to show yet.';

  @override
  String get supervisorNoScopeMessage =>
      'You haven\'t been assigned to a section or team yet - ask a manager to set this up in Staff Management before this dashboard has anything to show.';

  @override
  String get individualViewNotice =>
      'Individual view - for risk oversight, not a league table.';

  @override
  String get branchLabel => 'Branch';

  @override
  String get allBranchesLabel => 'All branches';

  @override
  String get yourSectionLabel => 'Your section';

  @override
  String get noneAssignedLabel => 'None assigned';

  @override
  String get areaLabel => 'Area';

  @override
  String get allAreasLabel => 'All areas';

  @override
  String get employeeLabel => 'Employee';

  @override
  String get allEmployeesLabel => 'All employees';

  @override
  String get monthLabel => 'Month';

  @override
  String get weekLabel => 'Week';

  @override
  String get dayLabel => 'Day';

  @override
  String get noTaskActivityPeriod => 'No task activity in this period.';

  @override
  String get taskOverviewTitle => 'Task overview';

  @override
  String get incidentsTitle => 'Incidents';

  @override
  String get noIncidentsPeriod => 'No incidents raised in this period.';

  @override
  String urgentCountLabel(int count) {
    return '$count urgent';
  }

  @override
  String get tapForDetailsHint =>
      'Tap a colour section or legend entry for details';

  @override
  String get employeeFallbackLabel => 'Employee';

  @override
  String get plainLookupNotice =>
      'A plain lookup, not a score - completion colour and issue tags here are never graded per person.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Tasks completed ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Issues raised ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Done on time (no issues)';

  @override
  String get doneOnTimeIssuesLogged => 'Done on time (issues logged)';

  @override
  String get doneEarlyLateNoIssues => 'Done early/late (no issues)';

  @override
  String get doneEarlyLateIssuesLogged => 'Done early/late (issues logged)';

  @override
  String get notDoneLabel => 'Not done';

  @override
  String get resolvedLabel => 'Resolved';

  @override
  String get unresolvedLabel => 'Unresolved';

  @override
  String get escalatedLabel => 'Escalated';

  @override
  String get urgentLabel => 'Urgent';

  @override
  String get signInFailed => 'Sign-in failed';

  @override
  String get twoFactorRequiredNoFactor =>
      'Two-factor verification is required but no factor was found.';

  @override
  String get couldNotVerifyCode => 'Could not verify that code';

  @override
  String get codeDidntWork => 'That code didn\'t work.';

  @override
  String get accountNotLinkedToStaff =>
      'This account isn\'t linked to a staff profile yet - contact an admin.';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get enterEmailForResetCode =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String get emailLabel => 'Email';

  @override
  String get sendCodeButton => 'SEND CODE';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String sentCodeToEmail(String email) {
    return 'We sent a code to $email. Enter it below with your new password.';
  }

  @override
  String get sixDigitCodeLabel => '6-digit code';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get resetPasswordButton => 'RESET PASSWORD';

  @override
  String get twoFactorVerificationTitle => 'Two-Factor Verification';

  @override
  String get enterAuthenticatorCode =>
      'Enter the code from your authenticator app.';

  @override
  String get verifyButton => 'VERIFY';

  @override
  String get regionalDirectorSignIn => 'Regional & Director sign-in.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'SIGN IN';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get noBackendConfiguredPin =>
      'No backend is configured for this install - sign in with a PIN, same as everyone else.';

  @override
  String get noDirectorRegionalAccounts =>
      'No Director/Regional accounts on this device.';

  @override
  String get directorLabel => 'Director';

  @override
  String get regionalManagerLabel => 'Regional Manager';

  @override
  String get whoAreYouTitle => 'Who are you?';

  @override
  String get searchLabel => 'Search';

  @override
  String get noMatchesLabel => 'No matches';

  @override
  String get leadershipSectionTitle => 'Leadership';

  @override
  String get kitchenStaffSectionTitle => 'Kitchen Staff';

  @override
  String get chooseASectionTitle => 'Choose a section';

  @override
  String get unassignedLabel => 'Unassigned';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get welcomeToVenurite => 'Welcome to VenuRite';

  @override
  String get helpAssistantTooltip => 'Help & Assistant';

  @override
  String get couldntLoadScreen => 'Couldn\'t load this screen.';

  @override
  String get retryLabel => 'Retry';

  @override
  String get microphonePermissionDenied => 'Microphone permission was denied.';

  @override
  String get couldntRecordTryAgain => 'Couldn\'t record that - try again.';

  @override
  String get couldntTranscribe => 'Couldn\'t transcribe that.';

  @override
  String get couldntReachTranscriptionService =>
      'Couldn\'t reach the transcription service.';

  @override
  String get dictateANote => 'Dictate a note';

  @override
  String get stoppingSoonTapToStop => 'Stopping soon - tap to stop now';

  @override
  String get stopLabel => 'Stop';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerts',
      one: '1 alert',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count unacknowledged';
  }

  @override
  String get allAcknowledgedLabel => 'All acknowledged';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'OVERDUE - unacknowledged for $minutes min';
  }

  @override
  String get escalatedToTopTier => 'Escalated to top tier';

  @override
  String get acknowledgeLabel => 'Acknowledge';

  @override
  String get nothingInCategory => 'Nothing in this category.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Leadership Overview';

  @override
  String get photoEvidence => 'Photo Evidence';

  @override
  String get staffManagement => 'Staff Management';

  @override
  String get addTeamMember => 'Add Team Member';

  @override
  String get shiftLog => 'Shift Log';

  @override
  String get branchTeamStructure => 'Branch Team Structure';

  @override
  String get departmentManagement => 'Department Management';

  @override
  String get rosterBoard => 'Roster Board';

  @override
  String get claimShifts => 'Claim Shifts';

  @override
  String get requestADayOff => 'Request a Day Off';

  @override
  String get shiftFairnessReview => 'Shift Fairness Review';

  @override
  String get venueDetails => 'Venue Details';

  @override
  String get assignTasks => 'Assign Tasks';

  @override
  String get taskPresets => 'Task Presets';

  @override
  String get supplierManagement => 'Supplier Management';

  @override
  String get serviceProviders => 'Service Providers';

  @override
  String get notificationRules => 'Notification Rules';

  @override
  String get documentCentre => 'Document Centre';

  @override
  String get setupWizard => 'Setup Wizard';

  @override
  String get organisationLabel => 'Organisation';

  @override
  String get branchesLabel => 'Branches';

  @override
  String get homeLabel => 'Home';

  @override
  String get oversightLabel => 'Oversight';

  @override
  String get problemsAndIssues => 'Problems & Issues';

  @override
  String get twoFactorAuthentication => 'Two-Factor Authentication';

  @override
  String get backUpNow => 'Back Up Now';

  @override
  String get dailySection => 'Daily';

  @override
  String get insightsSection => 'Insights';

  @override
  String get peopleSection => 'People';

  @override
  String get rosterSection => 'Roster';

  @override
  String get venueSetupSection => 'Venue Setup';

  @override
  String get companySection => 'Company';

  @override
  String get accountSection => 'Account';

  @override
  String get settingsLabel => 'Settings';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% completed today';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count active staff';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count FAILs today',
      one: '1 FAIL today',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Manager View';

  @override
  String showingScopeLabel(String scope) {
    return 'Showing: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'You haven\'t been assigned to a section or team yet - ask a manager to set this up in Staff Management before this log has anything to show.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count FAILs',
      one: '1 FAIL',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'No fails';

  @override
  String get noCompletedTasksLoggedYet => 'No completed tasks logged yet';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count session summaries',
      one: '1 session summary',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount pass / $failCount fail';
  }

  @override
  String get workerFixedIt => 'Worker fixed it';

  @override
  String get noCorrectiveActionRecorded => 'No corrective action recorded';

  @override
  String get taskAlertFallback => 'Task alert';

  @override
  String get loggedByLabel => 'Logged by';

  @override
  String get resultLabel => 'Result';

  @override
  String get correctiveActionLabel => 'Corrective action';

  @override
  String get noteLabel => 'Note';

  @override
  String get closeLabel => 'Close';

  @override
  String get notCompletedSuffix => '- NOT COMPLETED (session ended)';

  @override
  String get todayAllFails => 'Today + all fails';

  @override
  String byAxisLabel(String axis) {
    return 'By $axis';
  }

  @override
  String get nameAxisLabel => 'Name';

  @override
  String get dateAxisLabel => 'Date';

  @override
  String get taskAxisLabel => 'Task';

  @override
  String get filterLabel => 'Filter';

  @override
  String get filterByLabel => 'Filter by:';

  @override
  String get clearFiltersLabel => 'Clear filters';

  @override
  String get staffLabel => 'Staff';

  @override
  String get issueTypeComplaint => 'Complaint';

  @override
  String get issueTypeAccident => 'Accident';

  @override
  String get issueTypeIncident => 'Incident';

  @override
  String get issueTypeSupplyProblem => 'Supply Problem';

  @override
  String get issueTypeVenueProblem => 'Venue Problem';

  @override
  String get issueTypeOther => 'Other';

  @override
  String get incorrectDeliveryLabel => 'Incorrect delivery';

  @override
  String get driverProblemLabel => 'Driver problem';

  @override
  String get otherLabel => 'Other';

  @override
  String get whatKindOfThingHappened => 'What kind of thing happened?';

  @override
  String get whichOneLabel => 'Which one?';

  @override
  String get supplierLabel => 'Supplier';

  @override
  String get whatWasWrongWithDelivery => 'What was wrong with the delivery?';

  @override
  String get receivedByLabel => 'Received by';

  @override
  String get whichSectionOptional => 'Which section is this about? (optional)';

  @override
  String get noSectionLabel => 'No section';

  @override
  String get teamOptionalLabel => 'Team (optional)';

  @override
  String get noSpecificTeamLabel => 'No specific team';

  @override
  String get whatHappenedLabel => 'What happened?';

  @override
  String get markAsUrgentLabel => 'Mark as urgent';

  @override
  String get markUrgentSubtitle =>
      'Needs attention right away, regardless of how long it sits unresolved';

  @override
  String get logItButton => 'Log it';

  @override
  String get escalateToTitle => 'Escalate to';

  @override
  String get sendToLabel => 'Send to';

  @override
  String get escalateButton => 'Escalate';

  @override
  String get savedLabel => 'Saved.';

  @override
  String remindedMessage(String name) {
    return 'Reminded $name.';
  }

  @override
  String get couldNotSendReminder => 'Could not send the reminder.';

  @override
  String get viewSupplierScorecard => 'View supplier scorecard';

  @override
  String raisedAtLabel(String date) {
    return 'Raised $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Escalated to: $name';
  }

  @override
  String get historyLabel => 'History';

  @override
  String get addAnUpdateLabel => 'Add an update';

  @override
  String get addProcessNoteButton => 'Add process note';

  @override
  String get resolveButton => 'Resolve';

  @override
  String get reopenThisIssueTitle => 'Reopen this issue';

  @override
  String get whyReopenLabel => 'Why should this be reopened?';

  @override
  String get reopenButton => 'Reopen';

  @override
  String sentToLabel(String name) {
    return 'Sent to $name';
  }

  @override
  String get remindButton => 'Remind';

  @override
  String get phaseRaisedLabel => 'Raised';

  @override
  String get phaseUpdateLabel => 'Update';

  @override
  String get phaseOutcomeLabel => 'Outcome';

  @override
  String get allLabel => 'All';

  @override
  String get dateRangeLabel => 'Date range';

  @override
  String get allDatesLabel => 'All dates';

  @override
  String get typeLabel => 'Type';

  @override
  String get anyTypeLabel => 'Any type';

  @override
  String get anyoneLabel => 'Anyone';

  @override
  String staffFallback(String id) {
    return 'Staff #$id';
  }

  @override
  String get nothingHereGoodSign => 'Nothing here - that\'s a good sign.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Escalated to $name';
  }

  @override
  String get havenReportedYet => 'You haven\'t reported anything yet.';

  @override
  String get failsAndProblemsRegisterTitle => 'Fails & Problems Register';

  @override
  String get taskProblemsTab => 'Task Problems';

  @override
  String get issuesAndIncidentsTab => 'Issues & Incidents';

  @override
  String get failFilterLabel => 'Fail';

  @override
  String get reportedFilterLabel => 'Reported';

  @override
  String get notCompletedFilterLabel => 'Not Completed';

  @override
  String get abandonedLabel => 'Abandoned';

  @override
  String get noActionTakenLabel => 'No action taken';

  @override
  String get markResolvedButton => 'Mark Resolved';

  @override
  String get openLabel => 'Open';

  @override
  String get enableRosterQuestion => 'Enable Roster?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Based on your current staff numbers, this will add $amount to your monthly Direct Debit, starting with your next payment.';
  }

  @override
  String get confirmAndEnable => 'Confirm and enable';

  @override
  String couldNotReachVenurite(String error) {
    return 'Could not reach VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts => 'Let staff claim their own shifts';

  @override
  String get rosterPitchBody =>
      'Post open shifts and let staff pick them up themselves - no more phone-round or WhatsApp group when someone can\'t make it in. Staff can also request days off, and you approve or decline from the same place.';

  @override
  String get pricingLabel => 'Pricing';

  @override
  String get priceUnder10Staff =>
      '£6/month per branch with fewer than 10 staff';

  @override
  String get price10PlusStaff => '£10/month per branch with 10 or more staff';

  @override
  String get addedToDirectDebitNote =>
      'Added to your existing Direct Debit - no new payment method needed. You\'ll see the exact amount before confirming.';

  @override
  String get enableRosterButton => 'Enable Roster';

  @override
  String get availableShiftsTitle => 'Available Shifts';

  @override
  String get shiftClaimingNotEnabled =>
      'Shift claiming isn\'t switched on for this venue yet. Ask your manager to enable it in Settings.';

  @override
  String couldNotLoadShifts(String error) {
    return 'Could not load shifts: $error';
  }

  @override
  String get noShiftsPostedYet => 'No shifts posted yet.';

  @override
  String get someoneElseClaimedShift =>
      'Someone else just claimed that shift - sorry!';

  @override
  String get shiftClaimedMessage => 'Shift claimed.';

  @override
  String get cancelThisShiftTitle => 'Cancel this shift?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nThis is less than 24 hours before the shift starts - cancelling now may affect your reliability record.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'You will no longer be claimed for this shift.$warning';
  }

  @override
  String get keepShiftButton => 'Keep shift';

  @override
  String get cancelShiftButton => 'Cancel shift';

  @override
  String get yourShiftRecordReliable => 'Your shift record: Reliable';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Your shift record: Needs improvement';

  @override
  String get yourShiftRecordBuilding =>
      'Your shift record: Building a track record';

  @override
  String get claimLabel => 'Claim';

  @override
  String get claimedLabel => 'Claimed';

  @override
  String requestDateOffTitle(String date) {
    return 'Request $date off';
  }

  @override
  String get reasonOptionalLabel => 'Reason (optional)';

  @override
  String get submitRequestButton => 'Submit request';

  @override
  String get offDayRequestsNotEnabled =>
      'Off-day requests aren\'t switched on for this venue yet. Ask your manager to enable Roster in Settings.';

  @override
  String get noOffDayRequestsYet => 'You have no off-day requests yet.';

  @override
  String get yourRequestsLabel => 'Your requests';

  @override
  String get approvedLabel => 'Approved';

  @override
  String get deniedLabel => 'Denied';

  @override
  String get pendingLabel => 'Pending';

  @override
  String get postAShiftTitle => 'Post a shift';

  @override
  String get categoryHint => 'e.g. Refrigeration Repair, Pest Control';

  @override
  String get pickStartTime => 'Pick start time';

  @override
  String get pickEndTime => 'Pick end time';

  @override
  String get postLabel => 'Post';

  @override
  String get assignShiftToTitle => 'Assign this shift to';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get shiftsTabLabel => 'Shifts';

  @override
  String get offDayRequestsTabLabel => 'Off-Day Requests';

  @override
  String get rosterAddonNotEnabledManager =>
      'The Roster add-on isn\'t switched on for this venue. Enable it in Settings > Company to start posting shifts.';

  @override
  String get noShiftsTapPlus => 'No shifts posted yet. Tap + to add one.';

  @override
  String get openStatusLabel => 'Open';

  @override
  String get assignedStatusPrefix => 'Assigned';

  @override
  String get claimedStatusPrefix => 'Claimed';

  @override
  String get assignDirectlyLabel => 'Assign directly';

  @override
  String get removeClaimLabel => 'Remove claim';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'Could not load off-day requests: $error';
  }

  @override
  String get noOffDayRequests => 'No off-day requests.';

  @override
  String get approveLabel => 'Approve';

  @override
  String get denyLabel => 'Deny';

  @override
  String get rosterAddonNotEnabledPlain =>
      'The Roster add-on isn\'t switched on for this venue.';

  @override
  String get noActiveStaffVenue => 'No active staff at this venue yet.';

  @override
  String get last90DaysAlphabetical =>
      'Last 90 days, by shift category. Alphabetical - not a ranking.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shifts',
      one: '1 shift',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'No shifts in this period.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'This creates a complete copy of the local database in your Documents folder. Moving it to a USB drive or cloud-synced folder afterward is a separate manual step.';

  @override
  String get backupNameOptional => 'Backup name (optional)';

  @override
  String get backupNameHint => 'e.g. Pre-inspection backup';

  @override
  String get backupCreatedTitle => 'Backup Created';

  @override
  String get tierTeamMember => 'Team Member';

  @override
  String get tierSupervisor => 'Supervisor';

  @override
  String get tierManager => 'Manager';

  @override
  String get tierRegionalManager => 'Regional Manager';

  @override
  String get tierDirector => 'Director';

  @override
  String get anyTaskFail => 'Any task fail';

  @override
  String taskFailLabel(String title) {
    return '$title fail';
  }

  @override
  String get taskFailTemplateStale => 'Task fail (template no longer current)';

  @override
  String get unknownUserLabel => 'Unknown user';

  @override
  String tierSuffixLabel(String tier) {
    return '$tier tier';
  }

  @override
  String get unsetLabel => 'Unset';

  @override
  String get pushChannelLabel => 'push';

  @override
  String get emailChannelLabel => 'email';

  @override
  String get inAppOnlyLabel => 'in-app only';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'in-app + $channels';
  }

  @override
  String get tierColumnTeam => 'Team';

  @override
  String get tierColumnSupv => 'Supv';

  @override
  String get tierColumnMgr => 'Mgr';

  @override
  String get tierColumnRegnl => 'Regnl';

  @override
  String get tierColumnDir => 'Dir';

  @override
  String get quickSetupSectionTitle =>
      'Quick setup: per-task fail notifications';

  @override
  String get tickTierNotified =>
      'Tick which tier gets notified when a specific task fails.';

  @override
  String get noTaskTemplatesSetUp => 'No task templates set up yet.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Notify: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Set by $tier tier';
  }

  @override
  String get inactiveSuffixLabel => ' - inactive';

  @override
  String get deactivateButton => 'Deactivate';

  @override
  String get reactivateButton => 'Reactivate';

  @override
  String get newRuleTitle => 'New Rule';

  @override
  String get triggerLabel => 'Trigger';

  @override
  String get notifyLabel => 'Notify';

  @override
  String get wholeRoleTierOption => 'A whole role tier';

  @override
  String get specificPersonOption => 'A specific person';

  @override
  String get roleTierLabel => 'Role tier';

  @override
  String get personLabel => 'Person';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Rules are shown in-app now; push/email delivery is not yet connected to a backend and will be added in a later sprint.';

  @override
  String get saveRuleButton => 'Save Rule';

  @override
  String get addRuleButton => 'Add Rule';

  @override
  String get noNotificationRulesYet => 'No notification rules set up yet.';

  @override
  String get stepYourAccount => 'Your account';

  @override
  String get stepCompanyDetails => 'Company details';

  @override
  String get stepOrgStructure => 'Organisation structure';

  @override
  String get stepFirstVenue => 'First venue';

  @override
  String get stepStarterSetup => 'Your starter setup';

  @override
  String get stepSubscription => 'Subscription';

  @override
  String get stepPayment => 'Payment';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get companySignupGenericError =>
      'Something went wrong creating your company. Please try again - if it keeps happening, contact VenuRite.';

  @override
  String get directDebitStartError =>
      'We couldn\'t start Direct Debit setup automatically - you can do this any time from Settings once you\'re signed in.';

  @override
  String get continueButton => 'Continue';

  @override
  String get creatingEllipsis => 'Creating...';

  @override
  String get startFreeTrialButton => 'Start free trial';

  @override
  String get companyCreatedTitle => 'Company created';

  @override
  String get adminAccountIntro =>
      'Let\'s set up your account. You\'ll be the administrator for this company on VenuRite, and can invite your team once you\'re in.';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get passwordMinCharsHelper => 'At least 8 characters';

  @override
  String get companyDetailsIntro => 'Tell us about your company.';

  @override
  String get tradingCompanyNameLabel => 'Trading / company name';

  @override
  String get legalCompanyNameLabel => 'Legal company name (optional)';

  @override
  String get legalCompanyNameHelper =>
      'Leave blank to use the trading name above';

  @override
  String get countryLabel => 'Country';

  @override
  String get registeredAddressLabel =>
      'Registered / business address (optional)';

  @override
  String get vatNumberLabel => 'VAT / tax number (if applicable)';

  @override
  String get billingContactEmailLabel => 'Billing contact email (optional)';

  @override
  String get structureIntro =>
      'Here\'s how VenuRite organises your company. You don\'t need to set anything up now - this is just so the next step makes sense.';

  @override
  String get structureYourCompanyLabel => 'Your company';

  @override
  String get structureYourCompanySublabel =>
      'One consolidated account and bill';

  @override
  String get structureRegionsLabel => 'Regions (optional)';

  @override
  String get structureRegionsSublabel =>
      'Group venues by country or area - skip if you don\'t need it';

  @override
  String get structureVenuesLabel => 'Venues';

  @override
  String get structureVenuesSublabel =>
      'One venue today, hundreds later - add more any time';

  @override
  String get structureStaffLabel => 'Staff';

  @override
  String get structureStaffSublabel =>
      'Each venue\'s team, invited once it exists';

  @override
  String get structureOutro =>
      'We\'ll set up your first venue next - you can add regions and more venues later from inside the app.';

  @override
  String get wizardFirstVenueHeroTitle => 'Let\'s add your first venue';

  @override
  String get addMoreVenuesLaterText => 'You can add more venues later.';

  @override
  String get venueNameLabel => 'Venue name';

  @override
  String get addressOptionalLabel => 'Address (optional)';

  @override
  String get regionAreaOptionalLabel => 'Region / area (optional)';

  @override
  String get regionAreaHelper =>
      'e.g. \"London\" - only needed if you have (or will have) more than one venue';

  @override
  String get venueTypeOptionalLabel => 'Venue type (optional)';

  @override
  String get venueTypeHelper =>
      'Picking one shows you a ready-made starter set next - for tasks and equipment you already know you need.';

  @override
  String get payoffSkippedText =>
      'You skipped choosing a venue type, so there\'s no starter set to show yet - you can add tasks and equipment yourself once you\'re in.';

  @override
  String get payoffErrorText =>
      'Couldn\'t load the starter set for this venue type - you can add tasks and equipment yourself once you\'re in.';

  @override
  String get payoffHeroTitle => 'Here\'s your compliance, ready to go';

  @override
  String get equipmentSectionLabel => 'Equipment';

  @override
  String get subscriptionBannerText =>
      'One company account, one consolidated bill - priced per branch, never per person.';

  @override
  String get subscriptionIntroText =>
      'How many branches do you have today, including head office if you have one? You\'ll only set up your first venue now - add the rest any time from inside the app.';

  @override
  String get perBranchPriceLabel => '£39/branch/month';

  @override
  String get headOfficeIncludedLabel => '+ 1 head office branch (4+ branches)';

  @override
  String get discountCodeHint =>
      'Have a discount code? You can enter it when you set up Direct Debit.';

  @override
  String get trialBannerText =>
      'You\'re starting a 14-day free trial - no card needed today.';

  @override
  String get paymentStepIntro =>
      'We\'ll ask you to set up payment before your trial ends, from Settings inside the app. Nothing is charged now - just tell us how you\'d prefer to pay.';

  @override
  String get cardPaymentTitle => 'Card payment (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Debit/credit card, billed monthly or annually';

  @override
  String get directDebitTitle => 'Direct Debit (GoCardless)';

  @override
  String get directDebitSubtitle => 'Bank-to-bank payment, no card required';

  @override
  String get decideLaterButton => 'I\'ll decide later';

  @override
  String get decideLaterSnackbar =>
      'No problem - you can set this up anytime from Settings.';

  @override
  String get agreeToTermsPrefix => 'I have read and agree to the ';

  @override
  String get successActivatedBanner =>
      'Your company and first venue are set up, and you\'re signed in.';

  @override
  String get successNotActivatedBanner =>
      'Your company and first venue are set up. Sign in with your email and the password you just chose.';

  @override
  String get directDebitSettingUp => 'Setting up Direct Debit...';

  @override
  String get directDebitOpenedBrowser =>
      'We\'ve opened your browser to finish setting up Direct Debit.';

  @override
  String get inviteYourTeamTitle => 'Invite your team';

  @override
  String get inviteYourTeamSubtitle =>
      'Optional - add whoever\'s on shift now, or skip and do this later from Staff Management.';

  @override
  String get jobTitleLabel => 'Job title';

  @override
  String get tierFieldLabel => 'Tier';

  @override
  String get addTeamMemberButton => 'Add team member';

  @override
  String get goToDashboardButton => 'Go to dashboard';

  @override
  String get goToSignInButton => 'Go to sign in';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Step $step of $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Leave blank to use $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'We don\'t have a pre-built starter set for $venueType yet - you can add tasks and equipment yourself once you\'re in.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks tasks across $sectionCount sections and $equipmentCount equipment types already set up for a $venueType.';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks tasks across $sectionCount sections already set up for a $venueType.';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    String _temp0 = intl.Intl.pluralLogic(
      units,
      locale: localeName,
      other: '$units branches',
      one: '$units branch',
    );
    return '£$total/month total ($_temp0 billed)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get jobRoleChefCook => 'Chef/Cook';

  @override
  String get jobRoleKitchenPorter => 'Kitchen Porter';

  @override
  String get jobRoleFrontOfHouse => 'Front of House';

  @override
  String get jobRoleBar => 'Bar';

  @override
  String get jobRoleManagement => 'Management';

  @override
  String get jobRoleEveryone => 'Everyone';

  @override
  String get jobRoleMaintenance => 'Maintenance';

  @override
  String get jobRoleHousekeeping => 'Housekeeping';

  @override
  String get jobRoleReception => 'Reception';

  @override
  String get jobRoleSecurity => 'Security';

  @override
  String get segmentFoodSafety => 'Food Safety & Temperature Control';

  @override
  String get segmentAllergen => 'Allergen Management';

  @override
  String get segmentPersonalHygienePpe => 'Personal Hygiene & PPE';

  @override
  String get segmentRefrigerationColdStorage => 'Refrigeration & Cold Storage';

  @override
  String get segmentCookingLineEquipment => 'Cooking Line Equipment';

  @override
  String get segmentWashupDishwash => 'Wash-up / Dishwash';

  @override
  String get segmentCleaningSanitation => 'Cleaning & Sanitation';

  @override
  String get segmentCleaningChemicals => 'Cleaning Chemicals & Consumables';

  @override
  String get segmentDryAmbientStorage => 'Dry & Ambient Storage';

  @override
  String get segmentDeliveriesGoodsIn => 'Deliveries & Goods In';

  @override
  String get segmentUtilitiesSafety => 'Utilities & Safety';

  @override
  String get segmentWastePestControl => 'Waste & Pest Control';

  @override
  String get segmentPreventiveMaintenance =>
      'Preventive Maintenance (Kitchen Equipment)';

  @override
  String get segmentStockControl => 'Stock Control';

  @override
  String get segmentOpeningProcedures => 'Opening Procedures';

  @override
  String get segmentClosingProcedures => 'Closing Procedures';

  @override
  String get segmentServiceReadiness => 'Service Readiness';

  @override
  String get segmentFrontOfHouse => 'Front of House / Service';

  @override
  String get segmentBarBeverage => 'Bar & Beverage';

  @override
  String get segmentHotelSpecific => 'Hotel-Specific';

  @override
  String get segmentManagementComplianceOversight =>
      'Management & Compliance Oversight';

  @override
  String get segmentMaintenance => 'Maintenance';

  @override
  String get segmentHousekeeping => 'Housekeeping';

  @override
  String get segmentReception => 'Reception';

  @override
  String get segmentSecurity => 'Security';

  @override
  String get freqDaily => 'Daily';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String get freqPerShift => 'Per Shift';

  @override
  String get freqThreeXDaily => '3x Daily';

  @override
  String get freqTwoXDaily => '2x Daily';

  @override
  String get freqPerBatch => 'Per Batch';

  @override
  String get freqPerDelivery => 'Per Delivery';

  @override
  String get freqPerUse => 'Per Use';

  @override
  String get freqPerService => 'Per Service';

  @override
  String get freqTwoXPerService => '2x Per Service';

  @override
  String get freqEventBased => 'Event-Based';

  @override
  String get freqAsNeeded => 'As Needed';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String get freqCustom => 'Custom';

  @override
  String get jobRoleFieldLabel => 'Job role';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Add Staff Member';

  @override
  String get addLabel => 'Add';

  @override
  String get assignTasksTitle => 'Assign Tasks';

  @override
  String get noActiveSiteFoundError => 'No active site found.';

  @override
  String get byPersonLabel => 'By Person';

  @override
  String get byTaskLabel => 'By Task';

  @override
  String get noEquipmentOfTypeSetUp => 'No equipment of this type set up yet.';

  @override
  String get applyButton => 'Apply';

  @override
  String get assignToTitle => 'Assign to';

  @override
  String get noStaffMatchTiers =>
      'No staff match the tier(s) these tasks apply to.';

  @override
  String get assignButton => 'Assign';

  @override
  String get showInstructionsTooltip => 'Show instructions';

  @override
  String get selectTasksToAssignLabel => 'Select tasks to assign';

  @override
  String get taskPresetsSectionTitle => 'Task Presets';

  @override
  String get showAllPresetsButton => 'Show all presets';

  @override
  String get showTasksInGroupTooltip => 'Show tasks in this group';

  @override
  String get applyToMultipleButton => 'Apply to Multiple';

  @override
  String get addCustomTaskButton => 'Add Custom Task';

  @override
  String get customTaskSectionTitle => 'Custom Task';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get departmentSectionLabel => 'Department / section';

  @override
  String get methodLabel => 'Method';

  @override
  String get methodTick => 'Tick';

  @override
  String get methodData => 'Data';

  @override
  String get methodDataTick => 'Data + Tick';

  @override
  String get methodTickPhoto => 'Tick + Photo';

  @override
  String get methodDataPhoto => 'Data + Photo';

  @override
  String get methodNote => 'Note';

  @override
  String get methodDataNote => 'Data + Note';

  @override
  String get methodNotePhoto => 'Note + Photo';

  @override
  String get methodTickNote => 'Tick + Note';

  @override
  String get methodMulti => 'Multi';

  @override
  String get requiresPhotoLabel => 'Requires photo';

  @override
  String get requiresNotesLabel => 'Requires notes';

  @override
  String get minLimitLabel => 'Min limit';

  @override
  String get maxLimitLabel => 'Max limit';

  @override
  String get unitHintLabel => 'Unit (e.g. celsius)';

  @override
  String get equipmentTypeOptionalLabel => 'Equipment type (optional)';

  @override
  String get noneLabel => 'None';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityStandard => 'Standard';

  @override
  String get requiresCorrectiveActionLabel =>
      'Requires corrective action on fail';

  @override
  String get fixInstructionsLabel => 'Fix instructions';

  @override
  String get customFieldsJsonLabel => 'Custom fields (JSON, optional)';

  @override
  String get extraFieldsSectionTitle => 'Extra fields (optional)';

  @override
  String get removeTooltip => 'Remove';

  @override
  String get fieldLabelHint => 'Field label (e.g. PO number)';

  @override
  String get extraFieldTypeText => 'Text';

  @override
  String get extraFieldTypeNumber => 'Number';

  @override
  String get extraFieldTypeDate => 'Date';

  @override
  String get addFieldTooltip => 'Add field';

  @override
  String get saveCustomTaskButton => 'Save Custom Task';

  @override
  String get adHocLabel => 'Ad hoc';

  @override
  String get timeAllocatedLabel => 'Time allocated';

  @override
  String get frequencyPrefixLabel => 'Frequency: ';

  @override
  String get atATimeLabel => 'At a time';

  @override
  String get fromStartOfShiftLabel => 'From start of shift';

  @override
  String get fromClockInLabel => 'From clock-in';

  @override
  String get availableFromEllipsis => 'Available from…';

  @override
  String get untilEllipsis => 'until…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Assign Tasks - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return 'Apply \"$name\" to which one?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'All $name tasks were already assigned';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count tasks',
      one: 'Added $count task',
    );
    return '$_temp0 from $name';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'Apply \"$name\" to';
  }

  @override
  String assignTasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Assign $count tasks to staff…',
      one: 'Assign $count task to staff…',
    );
    return '$_temp0';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count assignments',
      one: 'Added $count assignment',
    );
    String _temp1 = intl.Intl.pluralLogic(
      staffCount,
      locale: localeName,
      other: '$staffCount staff members',
      one: '$staffCount staff member',
    );
    return '$_temp0 across $_temp1';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Section: $segment';
  }

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
    );
    return '$_temp0';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Show all roles (default: $jobRole only)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - no equipment set up for this yet';
  }

  @override
  String fromTimeLabel(String time) {
    return 'From $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'until $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assignments created',
      one: '$count assignment created',
    );
    return '$_temp0$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count skipped - already assigned or role mismatch)';
  }

  @override
  String get serviceProvidersTitle => 'Service Providers';

  @override
  String get myProvidersTab => 'My Providers';

  @override
  String get findProviderTab => 'Find a Provider';

  @override
  String get noBackendProviderNotice1 =>
      'Browsing other venues\' shared providers needs a real company account signed in - this can\'t work from the local demo login alone. Your own contacts under \"My Providers\" work either way.';

  @override
  String get noBackendProviderNotice2 =>
      'Sign in via Leadership Access with a real company account to use this.';

  @override
  String get providerDisclaimerText =>
      'VenuRite doesn\'t vet or endorse any listed provider. Reviews are from other venues, not from VenuRite.';

  @override
  String get addProviderButton => 'Add a Provider';

  @override
  String get noProvidersYetText =>
      'You haven\'t added any service providers yet.';

  @override
  String get addServiceProviderDialogTitle => 'Add a Service Provider';

  @override
  String get categoryLabel => 'Category';

  @override
  String get phoneOptionalLabel => 'Phone (optional)';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get notesOptionalPrivateLabel => 'Notes (optional, private to you)';

  @override
  String get happyToReviewShareLabel => 'I\'m happy to review and share';

  @override
  String get shareVisibilityExplanation =>
      'Other venues will see your ratings and reviews, with the name/contact blurred until they unlock it.';

  @override
  String get rateThisProviderLabel => 'Rate this provider';

  @override
  String get priceRatingLabel => 'Price';

  @override
  String get punctualityRatingLabel => 'Punctuality';

  @override
  String get qualityRatingLabel => 'Quality';

  @override
  String get availabilityRatingLabel => 'Availability';

  @override
  String get reviewOptionalLabel => 'Review (optional)';

  @override
  String get reviewHintText =>
      'Describe your experience - please don\'t name the business or include contact details.';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired - please sign in again.';

  @override
  String get sharedWithOtherVenuesLabel => 'Shared with other venues';

  @override
  String get privateLabel => 'Private';

  @override
  String get rateReviewsButton => 'Rate / Reviews';

  @override
  String get searchByCategoryOrNameHint => 'Search by category or name';

  @override
  String get noContactsUnlockedThisMonth =>
      'No contacts unlocked yet this month.';

  @override
  String get noSharedProvidersYetText =>
      'No shared providers yet - be the first to share one from \"My Providers.\"';

  @override
  String get noProvidersMatchSearchText => 'No providers match your search.';

  @override
  String get noRatingsYetText => 'No ratings yet';

  @override
  String get hiddenUntilUnlockedText => 'Hidden until unlocked';

  @override
  String get unnamedPlaceholder => '(unnamed)';

  @override
  String get readReviewsButton => 'Read reviews';

  @override
  String get unlockContactDetailsButton => 'Unlock contact details';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get noReviewsYetText => 'No reviews yet.';

  @override
  String get addYourRatingLabel => 'Add your rating';

  @override
  String get submittingEllipsis => 'Submitting...';

  @override
  String get submitRatingButton => 'Submit Rating';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Your review looks like it includes $found. Please remove contact details or business names before submitting.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Your review looks like it includes $found. Please remove contact details or business names before submitting - reviews stay useful (and fair) when they describe the experience, not who to call directly.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts unlocked this month.',
      one: '$count contact unlocked this month.',
    );
    return '$_temp0';
  }

  @override
  String priceValueLabel(String value) {
    return 'Price $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Punctuality $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Quality $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Availability $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$parts ($_temp0)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'Price $price - Punctuality $punctuality - Quality $quality - Availability $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Phone: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'Email: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Fresh Produce';

  @override
  String get supplierCategoryMeatPoultry => 'Meat & Poultry';

  @override
  String get supplierCategoryDairyEggs => 'Dairy & Eggs';

  @override
  String get supplierCategoryFrozenGoods => 'Frozen Goods';

  @override
  String get supplierCategoryDryAmbientGoods => 'Dry & Ambient Goods';

  @override
  String get supplierCategoryDrinksBeverages => 'Drinks & Beverages';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Chemicals & Cleaning Supplies';

  @override
  String get supplierCategoryEquipmentMaintenance => 'Equipment & Maintenance';

  @override
  String get supplierCategoryOther => 'Other';

  @override
  String get supplierStatusApproved => 'Approved';

  @override
  String get supplierStatusPending => 'Pending';

  @override
  String get supplierStatusSuspended => 'Suspended';

  @override
  String get addEquipmentTitle => 'Add Equipment';

  @override
  String get venueSetupTitle => 'Venue Setup';

  @override
  String get nextButton => 'Next';

  @override
  String get finishSetupButton => 'Finish Setup';

  @override
  String get renameAreaTitle => 'Rename Area';

  @override
  String get renameEquipmentTitle => 'Rename Equipment';

  @override
  String get saveButton => 'Save';

  @override
  String get retireEquipmentTitle => 'Retire Equipment';

  @override
  String get retireEquipmentConfirmText =>
      'Retiring this equipment will also unassign any tasks currently assigned to it. Past submission history is kept. Continue?';

  @override
  String get retireButton => 'Retire';

  @override
  String get areasStepTitle => 'Areas';

  @override
  String get areasStepIntro => 'Add the operational zones of this venue.';

  @override
  String get areaSuggestionKitchen => 'Kitchen';

  @override
  String get areaSuggestionStorage => 'Storage';

  @override
  String get areaSuggestionReceiving => 'Receiving';

  @override
  String get areaSuggestionFrontOfHouse => 'Front of House';

  @override
  String get areaNameLabel => 'Area name';

  @override
  String get addAreaTooltip => 'Add area';

  @override
  String get renameTooltip => 'Rename';

  @override
  String get equipmentStepTitle => 'Equipment';

  @override
  String get equipmentStepIntro =>
      'Add named equipment instances, e.g. \"Fridge 1\", \"Fridge 2\".';

  @override
  String get showAllEquipmentTypesButton => 'Show all equipment types';

  @override
  String get equipmentTypeLabel => 'Equipment type';

  @override
  String get somethingElseOption => 'Something else...';

  @override
  String get newEquipmentTypeNameLabel => 'New equipment type name';

  @override
  String get confirmNewEquipmentTypeTooltip => 'Confirm new equipment type';

  @override
  String get noAreasForDeptText =>
      'No areas set up for your department yet - equipment can still be added without one.';

  @override
  String get noAreasAddOneText => 'No areas added yet - go back to add one.';

  @override
  String get equipmentNameLabel => 'Equipment name';

  @override
  String get equipmentNameHint =>
      'e.g. Meat Walk-in, Dessert Fridge, Bar Fryer';

  @override
  String get modelOptionalLabel => 'Model (optional)';

  @override
  String get serialNumberOptionalLabel => 'Serial number (optional)';

  @override
  String get retireTooltip => 'Retire';

  @override
  String get reactivateTooltip => 'Reactivate';

  @override
  String get unknownTypeLabel => 'Unknown type';

  @override
  String get unknownAreaLabel => 'Unknown area';

  @override
  String get staffStepTitle => 'Staff';

  @override
  String get staffStepIntro => 'Add staff members and assign their role tier.';

  @override
  String get addStaffMemberButton => 'Add Staff Member';

  @override
  String get suppliersStepTitle => 'Suppliers';

  @override
  String get suppliersStepIntro =>
      'Add the suppliers this venue works with. Approval flags appear on the EHO export - suspended suppliers are surfaced to managers, not silently hidden.';

  @override
  String get supplierNameLabel => 'Supplier name';

  @override
  String get contactOptionalLabel => 'Contact (optional)';

  @override
  String get phoneOrEmailHint => 'Phone or email';

  @override
  String get approvalStatusLabel => 'Approval status';

  @override
  String get addSupplierButton => 'Add Supplier';

  @override
  String venueSetupStepTitle(int step) {
    return 'Venue Setup - Step $step of 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Model: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'S/N: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (retired)';
  }

  @override
  String get addEquipmentTooltip => 'Add equipment';

  @override
  String get newPinLabel => 'New PIN';

  @override
  String get editDetailsTitle => 'Edit Details';

  @override
  String get sectionLabel => 'Section';

  @override
  String get noSectionOption => 'No section';

  @override
  String get inactiveParenSuffix => ' (inactive)';

  @override
  String get noSpecificTeamOption => 'No specific team';

  @override
  String get noSectionsSetupText =>
      'No sections set up at this venue yet - add one under Department Management first.';

  @override
  String get reportsToFieldLabel => 'Reports to';

  @override
  String get notSetOption => 'Not set';

  @override
  String get deactivateStaffMemberTitle => 'Deactivate Staff Member';

  @override
  String get staffManagementTitle => 'Staff Management';

  @override
  String get addStaffTooltip => 'Add Staff';

  @override
  String get bulkImportTooltip => 'Bulk Import';

  @override
  String get deactivatedSuffixLabel => '(deactivated)';

  @override
  String get moreActionsTooltip => 'More actions';

  @override
  String get changeTierMenuItem => 'Change Tier';

  @override
  String get changeSectionMenuItem => 'Change Section';

  @override
  String get assignSupervisionMenuItem => 'Assign Supervision';

  @override
  String get reportsToMenuItem => 'Reports To';

  @override
  String get resetPinMenuItem => 'Reset PIN';

  @override
  String get trainingRecordsMenuItem => 'Training Records';

  @override
  String unknownUserIdFallback(String id) {
    return 'user #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'Reset PIN - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'PIN reset for $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Change Role Tier - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Change Section - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Assign Supervision - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Supervision scope updated for $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'Reports To - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name will no longer be able to log in. Their active task assignments will be unassigned. Their submission history is not affected. This can be reversed later.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Reports to $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return 'on $date by $name';
  }

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get brandIdentityIntro =>
      'One brand identity, shared company-wide - applies to every venue, not per-site.';

  @override
  String get companyNameLabel => 'Company name';

  @override
  String get companyLogoLabel => 'Company logo';

  @override
  String get chooseLogoButton => 'Choose Logo';

  @override
  String get changeLogoButton => 'Change Logo';

  @override
  String get brandColourLabel => 'Brand colour';

  @override
  String get customHexColourLabel => 'Custom hex colour';

  @override
  String get enterValidHexColourError => 'Enter a valid hex colour';

  @override
  String get contactPhoneLabel => 'Contact phone';

  @override
  String get contactEmailLabel => 'Contact email';

  @override
  String get savingEllipsisLabel => 'Saving...';

  @override
  String get saveBrandingButton => 'Save Branding';

  @override
  String get brandingSavedMessage => 'Branding saved';

  @override
  String get customSwatchTooltip => 'Custom';

  @override
  String get rosterAddonTitle => 'Staff Shift/Roster (+£6-£10/branch/month)';

  @override
  String get rosterAddonSubtitle =>
      'Let staff see and claim open shifts themselves - a manager posts shifts, staff pick them up. £6/month per branch under 10 staff, £10/month for 10 or more.';

  @override
  String get enableRosterTitle => 'Enable Roster?';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get clearDemoDataTitle => 'Clear demo data?';

  @override
  String get clearDemoDataConfirmText =>
      'This permanently deletes every demo staff member, branch, and department, and signs you out. This can\'t be undone.';

  @override
  String get clearEverythingButton => 'Clear everything';

  @override
  String get clearDemoDataCardTitle => 'Clear Demo Data';

  @override
  String get clearDemoDataCardBody =>
      'Remove every demo staff member, branch, and department so you can set up your own from scratch.';

  @override
  String get clearDemoDataButton => 'Clear demo data';

  @override
  String get temperatureUnitLabel => 'Temperature unit';

  @override
  String get celsiusLabel => 'Celsius (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'Coming soon';

  @override
  String get presetColorOceanTeal => 'Ocean Teal';

  @override
  String get presetColorNavy => 'Navy';

  @override
  String get presetColorIndigo => 'Indigo';

  @override
  String get presetColorSlate => 'Slate';

  @override
  String get presetColorPlum => 'Plum';

  @override
  String get presetColorForest => 'Forest';

  @override
  String get presetColorUmber => 'Umber';

  @override
  String get presetColorCharcoal => 'Charcoal';

  @override
  String couldNotGetPriceError(String error) {
    return 'Could not get a price: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Based on your current staff numbers, this will add $amount to your monthly Direct Debit.';
  }

  @override
  String get departmentLabel => 'Department';

  @override
  String get noDepartmentOption => 'No department';

  @override
  String get removeAnywayButton => 'Remove anyway';

  @override
  String get branchTeamStructureTitle => 'Branch Team Structure';

  @override
  String get noStaffAtBranchText => 'No staff at this branch yet.';

  @override
  String get changeManagerMenuItem => 'Change manager';

  @override
  String get moveDepartmentMenuItem => 'Move department/team';

  @override
  String get editJobTitleMenuItem => 'Edit job title';

  @override
  String get removeFromBranchMenuItem => 'Remove from this branch';

  @override
  String changeManagerTitle(String name) {
    return 'Change manager - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Move department/team - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Change tier - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Edit job title - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'Remove $name from this branch';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name will no longer be able to log in. This can be reversed later.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0 currently report to $name: $names. Removing $name will leave them unassigned until reassigned.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Reassign them to $name\'s own manager instead';
  }

  @override
  String reportsCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports',
      one: '$count report',
    );
    return '$_temp0';
  }

  @override
  String get regionalManagerAssignedTitle => 'Regional Manager assigned';

  @override
  String get noOrganisationOnSessionError => 'No organisation on this session.';

  @override
  String get newRegionNameTitle => 'New region name';

  @override
  String get renameRegionTitle => 'Rename region';

  @override
  String get renameVenueTitle => 'Rename venue';

  @override
  String get newVenueNameTitle => 'New venue name';

  @override
  String get doneButton => 'Done';

  @override
  String get resetPasswordQuestionTitle => 'Reset password?';

  @override
  String get resetButton => 'Reset';

  @override
  String get passwordResetTitle => 'Password reset';

  @override
  String get giveNewTempPasswordText =>
      'Give this person their new temporary password.';

  @override
  String get organisationTitle => 'Organisation';

  @override
  String get headOfficeLabel => 'Head Office';

  @override
  String get addRegionMenuItem => 'Add Region';

  @override
  String get addVenueNoRegionMenuItem => 'Add Venue (no region)';

  @override
  String get venuesNoRegionLabel => 'Venues (no region)';

  @override
  String get resetPasswordTooltip => 'Reset password';

  @override
  String get addVenueMenuItem => 'Add Venue';

  @override
  String get assignRegionalManagerMenuItem => 'Assign Regional Manager';

  @override
  String get reassignRegionalManagerMenuItem => 'Reassign Regional Manager';

  @override
  String get noRegionalManagerYetText => 'No regional manager yet';

  @override
  String get noVenuesInRegionText => 'No venues in this region yet.';

  @override
  String get noVenueManagerYetText => 'No venue manager yet';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Assign Regional Manager - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'The account is live now. Give $name their sign-in details - they use Leadership Access.';
  }

  @override
  String emailColonLabel(String email) {
    return 'Email: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Temporary password: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'This immediately invalidates $name\'s current password. You\'ll get a new temporary password to pass along.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Venue Manager';
  }

  @override
  String get noSignedInUserError => 'No signed-in user found.';

  @override
  String get customCategoryTitleLabel => 'Custom category title';

  @override
  String get approvalNoteLabel => 'Approval / due-diligence note (optional)';

  @override
  String get supplierManagementTitle => 'Supplier Management';

  @override
  String get noSuppliersAddedYetText => 'No suppliers added yet.';

  @override
  String get inactiveStandaloneLabel => '(inactive)';

  @override
  String get changeApprovalStatusMenuItem => 'Change Approval Status';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Edit Details - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Change Approval Status - $name';
  }

  @override
  String get newVenueTypeTitle => 'New Venue Type';

  @override
  String get renameOrganisationTitle => 'Rename Organisation';

  @override
  String get resetSetupCodeTitle => 'Reset setup code?';

  @override
  String get resetSetupCodeConfirmText =>
      'This will disconnect every tablet currently using this venue until they\'re given the new code. Continue?';

  @override
  String get resetCodeButton => 'Reset code';

  @override
  String get createNewVenueTitle => 'Create New Venue';

  @override
  String get multiSiteSupportPartialText =>
      'Multi-site support is partial: equipment, staff, and task lists are not yet filtered by venue, so day-to-day use of a second venue is not fully supported yet. Creating one is safe, but you\'ll see this venue\'s and the original venue\'s data mixed together in shared lists until that\'s built.';

  @override
  String get createButton => 'Create';

  @override
  String get venueDetailsTitle => 'Venue Details';

  @override
  String get billingLabel => 'Billing';

  @override
  String get billingSubtitleText => 'Plan, status, Direct Debit';

  @override
  String get activeLabel => 'Active';

  @override
  String get setAsActiveButton => 'Set as Active';

  @override
  String get tabletSetupCodeTitle => 'Tablet setup code';

  @override
  String get tabletSetupCodeExplanation =>
      'Enter this once on a new tablet so it can show this venue\'s staff list.';

  @override
  String get generateCodeButton => 'Generate code';

  @override
  String get venueTypeSectionTitle => 'Venue type';

  @override
  String get renamePresetTitle => 'Rename Preset';

  @override
  String get noTaskTemplatesExistYetText => 'No task templates exist yet.';

  @override
  String get addTaskToPresetTitle => 'Add Task to Preset';

  @override
  String get taskFieldLabel => 'Task';

  @override
  String get defaultFrequencyLabel => 'Default frequency';

  @override
  String get noPresetsYetText => 'No presets yet.';

  @override
  String get createPresetButton => 'Create Preset';

  @override
  String get presetVerificationBannerText =>
      'Task limits are researched and sourced (tagged [LAW]/[FSA]/[BEST] in each task\'s instructions) but not yet signed off by a qualified food-safety professional. Do not treat them as legally authoritative until verified.';

  @override
  String get equipmentPresetsSectionTitle => 'Equipment presets';

  @override
  String get sectionPresetsSectionTitle => 'Section presets';

  @override
  String get addTaskButton => 'Add task';

  @override
  String get newPresetSectionTitle => 'New Preset';

  @override
  String get sectionSegmentOptionalLabel => 'Section / segment (optional)';

  @override
  String get setEquipmentOrSectionHint =>
      'Set an equipment type or a section (at least one).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Equipment type #$id';
  }

  @override
  String taskFallback(String id) {
    return 'Task #$id';
  }

  @override
  String get departmentCategoryKitchen => 'Kitchen';

  @override
  String get departmentCategoryFrontOfHouse => 'Front of House';

  @override
  String get departmentCategoryBar => 'Bar';

  @override
  String get departmentCategoryManagement => 'Management';

  @override
  String get departmentCategoryMaintenance => 'Maintenance';

  @override
  String get departmentCategoryHousekeeping => 'Housekeeping';

  @override
  String get departmentCategoryReception => 'Reception';

  @override
  String get departmentCategorySecurity => 'Security';

  @override
  String get addDepartmentButton => 'Add Department';

  @override
  String get departmentManagementTitle => 'Department Management';

  @override
  String get noDepartmentsAddedYetText => 'No departments added yet.';

  @override
  String get noTeamsYetText => 'No teams yet';

  @override
  String get editMenuItem => 'Edit';

  @override
  String get addTeamButton => 'Add Team';

  @override
  String editDepartmentTitle(String name) {
    return 'Edit - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Add Team - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Rename - $name';
  }

  @override
  String teamCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teams',
      one: '$count team',
    );
    return '$_temp0';
  }

  @override
  String get documentCategoryPolicy => 'Policy';

  @override
  String get documentCategoryCertificate => 'Certificate';

  @override
  String get documentCategoryProcedure => 'Procedure';

  @override
  String get documentCategoryEhoReport => 'EHO Report';

  @override
  String get addDocumentTitle => 'Add Document';

  @override
  String get noExpiryDateText => 'No expiry date';

  @override
  String get setExpiryButton => 'Set expiry';

  @override
  String get couldNotOpenFileText => 'Could not open this file.';

  @override
  String get documentCentreTitle => 'Document Centre';

  @override
  String get validLabel => 'Valid';

  @override
  String get expiringSoonLabel => 'Expiring soon';

  @override
  String get expiredLabel => 'Expired';

  @override
  String get allFilterLabel => 'All';

  @override
  String get noDocumentsYetText => 'No documents yet.';

  @override
  String get openMenuItem => 'Open';

  @override
  String expiresOnLabel(String date) {
    return 'Expires $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'No plan selected';

  @override
  String get codeNotRecognisedText => 'That code was not recognised.';

  @override
  String get couldNotReachServerText => 'Could not reach the server.';

  @override
  String get discountAppliedText => 'Discount code applied.';

  @override
  String get couldNotOpenBrowserText => 'Could not open the browser';

  @override
  String get noSubscriptionFoundText =>
      'No subscription found for this organisation.';

  @override
  String get discountAppliedBadge => 'Discount applied';

  @override
  String get directDebitSetUpText =>
      'Direct Debit is set up for this organisation.';

  @override
  String get directDebitNotSetUpText =>
      'You haven\'t set up Direct Debit yet. You\'ll be taken to GoCardless - VenuRite never sees your bank details directly.';

  @override
  String get discountCodeOptionalLabel => 'Discount code (optional)';

  @override
  String get discountCodeHintText => 'Have a \'Friends\' code? Enter it here';

  @override
  String get setUpDirectDebitButton => 'Set up Direct Debit';

  @override
  String get freeAccessCodeTitle => 'Free-access code';

  @override
  String get freeAccessActiveText =>
      'Free access is active for this organisation - no Direct Debit or card payment required.';

  @override
  String get freeAccessPromptText =>
      'Have a free-access code? Enter it here to use the full app without setting up payment.';

  @override
  String get redeemCodeButton => 'Redeem code';

  @override
  String get onTrialText => 'On trial';

  @override
  String get paymentFailedGraceText =>
      'A recent payment failed. Please update your Direct Debit - access continues during this grace period.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Your Direct Debit was cancelled. Access is restricted to read-only until billing is set up again.';

  @override
  String get paymentOverdueRestrictedText =>
      'Payment has been overdue too long. Access is restricted to read-only until this is resolved.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'Could not load billing details: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    String _temp0 = intl.Intl.pluralLogic(
      units,
      locale: localeName,
      other: '$units branches',
      one: '$units branch',
    );
    return '£$price/month ($_temp0 billed)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'On trial until $date';
  }

  @override
  String get reportedIssuesTitle => 'Reported issues';

  @override
  String get noDeliveriesLoggedText =>
      'No deliveries logged against this supplier in this period.';

  @override
  String get scorecardCategoriesExplanation =>
      'Each category below counts independently - a delivery can appear in more than one row (e.g. late AND damaged).';

  @override
  String get rejectedOutrightLabel => 'Rejected outright';

  @override
  String get acceptedPartiallyLabel => 'Accepted partially';

  @override
  String get reportedIssuesExplanation =>
      'Supply-problem issues raised against this supplier - a separate log from the delivery scorecard above, not merged into it.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Delivery scorecard ($count deliveries)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'Missing name';

  @override
  String get missingJobTitleError => 'Missing job title';

  @override
  String get pinMustBe4DigitsError =>
      'PIN must be exactly 4 digits (or left blank)';

  @override
  String get bulkStaffImportTitle => 'Bulk Staff Import';

  @override
  String get csvColumnsInstructionsText =>
      'CSV columns: name, job title, role tier, job role (optional), pin (optional). A header row is fine - it\'s detected automatically. Leave the PIN blank to have one generated for you.';

  @override
  String get chooseCsvFileButton => 'Choose CSV file';

  @override
  String get chooseDifferentFileButton => 'Choose a different file';

  @override
  String get noteDownPinsText =>
      ' Note down each PIN below before leaving this screen.';

  @override
  String get importingEllipsisLabel => 'Importing...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'Role tier must be one of: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'You aren\'t allowed to create a $tier account';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'Job role must be one of: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Example: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows found',
      one: '$count row found',
    );
    return '$fileName - $_temp0';
  }

  @override
  String needFixingSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count need fixing',
      one: '$count needs fixing',
    );
    return ', $_temp0';
  }

  @override
  String createdCountLabel(int count) {
    return '$count created';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count failed';
  }

  @override
  String importStaffCountButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count staff members',
      one: '$count staff member',
    );
    return 'Import $_temp0';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Row $number';
  }

  @override
  String jobTitleTierLabel(String jobTitle, String tier) {
    return '$jobTitle - $tier';
  }

  @override
  String pinSuffixLabel(String pin) {
    return ' - PIN: $pin';
  }

  @override
  String get trainingLevel2FoodHygiene => 'Level 2 Food Hygiene & Safety';

  @override
  String get trainingAllergenAwareness => 'Allergen Awareness';

  @override
  String get trainingCoshh =>
      'COSHH (Control of Substances Hazardous to Health)';

  @override
  String get trainingFireSafety => 'Fire Safety';

  @override
  String get trainingManualHandling => 'Manual Handling';

  @override
  String get trainingFirstAid => 'First Aid at Work';

  @override
  String get trainingInduction => 'Induction Completed';

  @override
  String get itemFieldLabel => 'Item';

  @override
  String get customItemTitleLabel => 'Custom item title';

  @override
  String get expiryNoneLabel => 'Expiry: none';

  @override
  String get clearExpiryTooltip => 'Clear expiry';

  @override
  String get certificateReferenceLabel => 'Certificate reference (optional)';

  @override
  String get certificateReferenceHint => 'e.g. certificate number, provider';

  @override
  String get noTrainingRecordsYetText => 'No training records yet.';

  @override
  String get addRecordButton => 'Add Record';

  @override
  String get currentLabel => 'Current';

  @override
  String get supersededLabel => '(superseded)';

  @override
  String get noExpiryLabel => 'No expiry';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Add Training Record - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Completed: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Expiry: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Training Records - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Full history ($count earlier records)',
      one: 'Full history ($count earlier record)',
    );
    return '$_temp0';
  }

  @override
  String completedDateLabel(String date) {
    return 'Completed $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Ref: $ref';
  }

  @override
  String get twoFactorNowOnText => 'Two-factor authentication is now on.';

  @override
  String get turnOffTwoFactorTitle => 'Turn off two-factor authentication?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'This account will sign in with just a password again.';

  @override
  String get turnOffButton => 'Turn Off';

  @override
  String get twoFactorAuthTitle => 'Two-Factor Authentication';

  @override
  String get twoFactorOnText =>
      'Two-factor authentication is ON for this account.';

  @override
  String get twoFactorOffText =>
      'Two-factor authentication is OFF - add it for an extra layer of protection on this senior account.';

  @override
  String get enableTwoFactorButton => 'Enable Two-Factor Authentication';

  @override
  String get scanAuthenticatorText =>
      'Scan this with your authenticator app (Google Authenticator, Authy, etc.), then enter the 6-digit code it shows.';

  @override
  String get cantScanManualEntryText =>
      'Can\'t scan? Enter this code manually:';

  @override
  String get requiredFieldError => 'Required';

  @override
  String get joinExistingCompanyTitle => 'Join existing company';

  @override
  String get enterInviteCodeText =>
      'Enter the invite code your manager gave you.';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get yourNameLabel => 'Your name';

  @override
  String get yourEmailLabel => 'Your email';

  @override
  String get enterValidEmailError => 'Enter a valid email';

  @override
  String get choosePasswordLabel => 'Choose a password';

  @override
  String get joinButton => 'Join';

  @override
  String get youreInSignInText =>
      'You\'re in. Sign in with your email and the password you just chose.';

  @override
  String get newBranchNameTitle => 'New branch name';

  @override
  String get renameBranchTitle => 'Rename branch';

  @override
  String get branchManagerNameTitle => 'Branch manager\'s name';

  @override
  String get accountCreatedTitle => 'Account created';

  @override
  String get giveNameAndPinText =>
      'Give this person their name (to tap on the login screen) and this PIN.';

  @override
  String get branchesTitle => 'Branches';

  @override
  String get noRegionSetText =>
      'Your account has no region set - contact your Director.';

  @override
  String get noBranchesInRegionText => 'No branches in your region yet.';

  @override
  String get addBranchManagerMenuItem => 'Add branch manager';

  @override
  String nameColonLabel(String name) {
    return 'Name: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'Delete selected evidence?';

  @override
  String get deleteButton => 'Delete';

  @override
  String get photoEvidenceTitle => 'Photo Evidence';

  @override
  String get onThisDeviceLabel => 'On this device';

  @override
  String get deletingFreesSpaceText =>
      'Deleting also frees device space. Exported EHO PDFs already contain their copies and are unaffected.';

  @override
  String get noEvidencePhotosYetText => 'No evidence photos yet.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '$count photo',
    );
    return 'This permanently deletes $_temp0 ($bytes) from this device. Already-exported PDFs are unaffected. This cannot be undone.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count evidence photos',
      one: '$count evidence photo',
    );
    return '$_temp0 · $bytes total';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return 'Delete $count selected ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Add Team Member';

  @override
  String get createsTapNamePinAccountText =>
      'Creates a tap-name + PIN account for your own venue.';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get shiftLogTitle => 'Shift Log';

  @override
  String get noClockInsYetText => 'No clock-ins recorded yet.';

  @override
  String get stillClockedInText => 'Still clocked in';

  @override
  String clockInLabel(String time) {
    return 'In: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Out: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get inviteCreatedTitle => 'Invite created';

  @override
  String get orShareCodeText =>
      'Or share this code - they enter it on the \"Join existing company\" screen:';

  @override
  String shareInviteExpiresText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'Share this with the person joining - it works once and expires in $days days.',
      one:
          'Share this with the person joining - it works once and expires in $days day.',
    );
    return '$_temp0';
  }

  @override
  String get contactVenuRiteTitle => 'Contact VenuRite';

  @override
  String get contactVenuRiteIntroText =>
      'Whether you\'re a large group wanting a hand setting up, or just have a question - we\'re happy to help.';

  @override
  String get emailUsButton => 'Email us';

  @override
  String taskCountOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks overdue',
      one: '$count task overdue',
    );
    return '$_temp0';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Across $count staff members',
      one: 'Across $count staff member',
    );
    return '$_temp0';
  }

  @override
  String moreStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count more staff members',
      one: '+$count more staff member',
    );
    return '$_temp0';
  }

  @override
  String failCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fails',
      one: '$count fail',
    );
    return '$_temp0';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count not completed';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count issues raised',
      one: '$count issue raised',
    );
    return '$_temp0';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Shift summary - $name';
  }

  @override
  String get faqQ1 => 'Who can see what I log?';

  @override
  String get faqA1 =>
      'Your manager and anyone above them in your venue can see the tasks you complete. A named individual is never shown a graded score or league table - only a plain list of what they did and when.';

  @override
  String get faqQ2 => 'What happens if I miss a task during my shift?';

  @override
  String get faqA2 =>
      'It\'s recorded as not completed, not as a fail - an abandoned mid-shift task is expected, allowed behaviour, just never hidden. Your manager sees it as its own distinct status.';

  @override
  String get faqQ3 => 'Can I go back and finish a task I skipped?';

  @override
  String get faqA3 =>
      'Yes, any time before the end of your shift - it stays available in your task list until you complete it or your shift ends.';

  @override
  String get faqQ4 => 'What if I fail a check (e.g. a fridge is too warm)?';

  @override
  String get faqA4 =>
      'Log it as a FAIL, record the corrective action you took (or that you reported it), and add a photo if asked. This is exactly what the system is for - a logged FAIL with a fix is a success story for an inspector, not a problem for you.';

  @override
  String get faqQ5 =>
      'Do I need to clock in and out separately from logging in?';

  @override
  String get faqA5 =>
      'No - logging in with your PIN at the start of your shift is your clock-in. Use \'End shift\' when you finish, which also shows you anything you still need to complete.';

  @override
  String get faqQ6 => 'I raised an issue - what happens to it?';

  @override
  String get faqA6 =>
      'It goes to your manager (or escalates further if not handled in time). You can check its status any time from \"My Raised Issues.\"';

  @override
  String get troubleQ1 => 'My PIN isn\'t working';

  @override
  String get troubleA1 =>
      'Double check you\'re tapping your own name first, then entering the PIN - a wrong PIN on the right name gives a clear rejection message. If it still doesn\'t work, ask a manager to check your account is active and reset your PIN if needed.';

  @override
  String get troubleQ2 => 'A task I should have is missing from my list';

  @override
  String get troubleA2 =>
      'Ask your manager to check it\'s assigned to your role/section in Assign Tasks. Tasks only appear for the roles and departments they\'ve been switched on for.';

  @override
  String get troubleQ3 => 'The app won\'t let me take a photo';

  @override
  String get troubleA3 =>
      'Make sure the app has camera permission (check your device settings). On Windows, if no camera is detected you\'ll be offered a file picker instead.';

  @override
  String get troubleQ4 =>
      'I can\'t submit a check / nothing happens when I press Submit';

  @override
  String get troubleA4 =>
      'This can happen if your organisation\'s account needs billing attention - you\'ll see a clear message if so. Otherwise, check every required field (including any photo) is filled in.';

  @override
  String get troubleQ5 => 'The app looks like it\'s stuck / frozen';

  @override
  String get troubleA5 =>
      'Try closing and reopening it. Your progress up to your last completed task is always saved as you go, so nothing already submitted is lost.';

  @override
  String get troubleQ6 => 'I\'m not seeing the same tasks as yesterday';

  @override
  String get troubleA6 =>
      'That\'s expected if your schedule includes ad hoc tasks, or tasks tied to a time window - they only appear when due. Ask your manager if something looks genuinely wrong.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - overdue since $date';
  }

  @override
  String get uploadCertificateDocumentButton => 'Upload certificate photo';

  @override
  String get certificateDocumentUploadedLabel => 'Certificate uploaded';

  @override
  String get viewCertificateDocumentTooltip => 'View certificate document';

  @override
  String get certificateUploadFailed =>
      'Couldn\'t upload the certificate. Please try again.';

  @override
  String get certificationRequirementsTitle => 'Certification requirements';

  @override
  String get certificationRequirementsFloorNotice =>
      'Some certifications are always required for certain roles and can\'t be removed here (e.g. food handling roles always require Level 2 Food Hygiene and Allergen Awareness). You can add extra requirements on top of those below.';

  @override
  String get noExtraCertificationRequirementsText =>
      'No extra requirements added yet.';

  @override
  String get addRequirementButton => 'Add requirement';

  @override
  String get addCertificationRequirementTitle =>
      'Add certification requirement';

  @override
  String get removeCertificationRequirementTitle => 'Remove this requirement?';

  @override
  String get removeCertificationRequirementBody =>
      'Staff in this role will no longer need this certification to be scheduled. This doesn\'t affect the certifications that are always required.';

  @override
  String get removeButton => 'Remove';

  @override
  String get cannotClaimShiftTitle => 'You can\'t claim this shift yet';

  @override
  String missingCertificationsMessage(String certs) {
    return 'This role requires the following, which are missing or expired: $certs. Ask your manager about getting these renewed.';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'Can\'t assign this shift to $name';
  }

  @override
  String get allergenCelery => 'Celery';

  @override
  String get allergenGluten => 'Cereals containing gluten';

  @override
  String get allergenCrustaceans => 'Crustaceans';

  @override
  String get allergenEggs => 'Eggs';

  @override
  String get allergenFish => 'Fish';

  @override
  String get allergenLupin => 'Lupin';

  @override
  String get allergenMilk => 'Milk';

  @override
  String get allergenMolluscs => 'Molluscs';

  @override
  String get allergenMustard => 'Mustard';

  @override
  String get allergenTreeNuts => 'Tree nuts';

  @override
  String get allergenPeanuts => 'Peanuts';

  @override
  String get allergenSesame => 'Sesame seeds';

  @override
  String get allergenSoya => 'Soya';

  @override
  String get allergenSulphites => 'Sulphur dioxide and sulphites';

  @override
  String get allergenStatusContains => 'Contains';

  @override
  String get allergenStatusMayContain => 'May contain';

  @override
  String get menuManagementTitle => 'Menu & Allergens';

  @override
  String get addDishButton => 'Add dish';

  @override
  String get addDishTitle => 'Add a dish';

  @override
  String get dishNameLabel => 'Dish name';

  @override
  String get dishCategoryLabel => 'Category (optional)';

  @override
  String get noDishesYetText => 'No dishes added yet.';

  @override
  String get draftLabel => 'Draft';

  @override
  String get addIngredientTitle => 'Add ingredient';

  @override
  String get ingredientNameLabel => 'Ingredient name';

  @override
  String get addButton => 'Add';

  @override
  String get addIngredientButton => 'Add ingredient';

  @override
  String get ingredientsHeading => 'Ingredients';

  @override
  String get suggestedAllergensHeading =>
      'Suggested allergens (not yet published)';

  @override
  String get publishedAllergensHeading => 'Published allergens';

  @override
  String get noAllergensIdentifiedText =>
      'No allergens identified from the current ingredients.';

  @override
  String get reviewAllergensTitle => 'Review allergens before publishing';

  @override
  String get allergenStatusNone => 'None';

  @override
  String get approveButton => 'Approve & publish';

  @override
  String get reviewAndApproveButton => 'Review & approve';

  @override
  String get reviewAndReapproveButton => 'Review & re-approve';

  @override
  String get allergenMatrixTitle => 'Allergen matrix';

  @override
  String get allergenMatrixLegend => 'Key';

  @override
  String get noApprovedDishesYetText =>
      'No approved dishes yet. Ask a manager to review and approve dishes in Menu & Allergens.';

  @override
  String get exportAsPdfButton => 'Export as PDF';

  @override
  String get allergenMatrixSubtitle =>
      'Check what\'s in a dish before it reaches a customer';

  @override
  String get assignmentRejectedMessage =>
      'This assignment was rejected. Please check the staff member\'s role and certifications and try again.';
}
