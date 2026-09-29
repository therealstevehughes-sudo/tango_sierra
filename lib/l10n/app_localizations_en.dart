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
}
