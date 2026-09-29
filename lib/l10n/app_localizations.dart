import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('hr'),
    Locale('pl'),
    Locale('ro'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VenuRite'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @personalSection.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personalSection;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingTitle;

  /// No description provided for @languageSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language VenuRite uses for you.'**
  String get languageSettingSubtitle;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated.'**
  String get languageUpdated;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguageTitle;

  /// No description provided for @languageDeviceScope.
  ///
  /// In en, this message translates to:
  /// **'Used on this device before staff sign in.'**
  String get languageDeviceScope;

  /// No description provided for @languageUserScope.
  ///
  /// In en, this message translates to:
  /// **'Saved for {name}.'**
  String languageUserScope(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @leadershipAccess.
  ///
  /// In en, this message translates to:
  /// **'Leadership Access'**
  String get leadershipAccess;

  /// No description provided for @notOnThisList.
  ///
  /// In en, this message translates to:
  /// **'Not on this list? Sign in another way'**
  String get notOnThisList;

  /// No description provided for @errorLoadingStaff.
  ///
  /// In en, this message translates to:
  /// **'Error loading staff: {error}'**
  String errorLoadingStaff(String error);

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @tooManyWrongAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong attempts. Try again in {minutes} min.'**
  String tooManyWrongAttempts(int minutes);

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFound;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @kitchenComplianceDoneRight.
  ///
  /// In en, this message translates to:
  /// **'Kitchen compliance, done right'**
  String get kitchenComplianceDoneRight;

  /// No description provided for @valuePointEhoReady.
  ///
  /// In en, this message translates to:
  /// **'Always EHO-ready - real-time compliance, not a once-a-year scramble'**
  String get valuePointEhoReady;

  /// No description provided for @valuePointHonestRecords.
  ///
  /// In en, this message translates to:
  /// **'Built so results can\'t be gamed - every check is honest, every record stands up'**
  String get valuePointHonestRecords;

  /// No description provided for @valuePointAuditExport.
  ///
  /// In en, this message translates to:
  /// **'One-tap audit export - hand an inspector a real record, instantly'**
  String get valuePointAuditExport;

  /// No description provided for @howGetStarted.
  ///
  /// In en, this message translates to:
  /// **'How would you like to get started?'**
  String get howGetStarted;

  /// No description provided for @setUpMyBusiness.
  ///
  /// In en, this message translates to:
  /// **'Set up my business'**
  String get setUpMyBusiness;

  /// No description provided for @teamAlreadyUses.
  ///
  /// In en, this message translates to:
  /// **'My team already uses VenuRite'**
  String get teamAlreadyUses;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @needHelpContact.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact VenuRite'**
  String get needHelpContact;

  /// No description provided for @signInAnotherWay.
  ///
  /// In en, this message translates to:
  /// **'Sign in another way'**
  String get signInAnotherWay;

  /// No description provided for @deviceNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'This tablet isn\'t set up yet'**
  String get deviceNotSetUp;

  /// No description provided for @askManagerSetupCode.
  ///
  /// In en, this message translates to:
  /// **'Ask a manager for this venue\'s setup code.'**
  String get askManagerSetupCode;

  /// No description provided for @setupCode.
  ///
  /// In en, this message translates to:
  /// **'Setup code'**
  String get setupCode;

  /// No description provided for @connectTablet.
  ///
  /// In en, this message translates to:
  /// **'Connect this tablet'**
  String get connectTablet;

  /// No description provided for @couldNotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server'**
  String get couldNotReachServer;

  /// No description provided for @stillStuckSetupCode.
  ///
  /// In en, this message translates to:
  /// **'Still stuck? A manager can find this in Settings -> Venue Details.'**
  String get stillStuckSetupCode;

  /// No description provided for @askQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askQuestionTitle;

  /// No description provided for @askQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you want to know?'**
  String get askQuestionLabel;

  /// No description provided for @askQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. What temperature should a fridge be?'**
  String get askQuestionHint;

  /// No description provided for @ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get ask;

  /// No description provided for @aiQuestionLimitReached.
  ///
  /// In en, this message translates to:
  /// **'AI question limit reached this month'**
  String get aiQuestionLimitReached;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @endShift.
  ///
  /// In en, this message translates to:
  /// **'End shift'**
  String get endShift;

  /// No description provided for @workerHubPrompt.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get workerHubPrompt;

  /// No description provided for @myScheduledTasks.
  ///
  /// In en, this message translates to:
  /// **'My scheduled tasks'**
  String get myScheduledTasks;

  /// No description provided for @doAdHocTask.
  ///
  /// In en, this message translates to:
  /// **'Do an ad-hoc task'**
  String get doAdHocTask;

  /// No description provided for @logSomethingHappened.
  ///
  /// In en, this message translates to:
  /// **'Log something that just happened'**
  String get logSomethingHappened;

  /// No description provided for @claimShift.
  ///
  /// In en, this message translates to:
  /// **'Claim a shift'**
  String get claimShift;

  /// No description provided for @requestDayOff.
  ///
  /// In en, this message translates to:
  /// **'Request a day off'**
  String get requestDayOff;

  /// No description provided for @thingsIReported.
  ///
  /// In en, this message translates to:
  /// **'Things I\'ve reported'**
  String get thingsIReported;

  /// No description provided for @shiftWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {firstName}'**
  String shiftWelcome(String firstName);

  /// No description provided for @shiftPlanIntro.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s on for your shift:'**
  String get shiftPlanIntro;

  /// No description provided for @startOfShift.
  ///
  /// In en, this message translates to:
  /// **'Start of shift'**
  String get startOfShift;

  /// No description provided for @duringYourShift.
  ///
  /// In en, this message translates to:
  /// **'During your shift'**
  String get duringYourShift;

  /// No description provided for @endOfShift.
  ///
  /// In en, this message translates to:
  /// **'End of shift'**
  String get endOfShift;

  /// No description provided for @shiftHandoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Shift Handover'**
  String get shiftHandoverTitle;

  /// No description provided for @shiftHandoverNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'This still needs the next shift\'s attention'**
  String get shiftHandoverNeedsAttention;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @openIssues.
  ///
  /// In en, this message translates to:
  /// **'Open issues'**
  String get openIssues;

  /// No description provided for @flaggedEquipment.
  ///
  /// In en, this message translates to:
  /// **'Flagged equipment'**
  String get flaggedEquipment;

  /// No description provided for @notYetDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Not yet done today'**
  String get notYetDoneToday;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @uploadFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload from Files'**
  String get uploadFromFiles;

  /// No description provided for @seeAllTasksTooltip.
  ///
  /// In en, this message translates to:
  /// **'See all tasks'**
  String get seeAllTasksTooltip;

  /// No description provided for @leaveBeforeFinishingTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave before finishing?'**
  String get leaveBeforeFinishingTitle;

  /// No description provided for @leaveBeforeFinishingBody.
  ///
  /// In en, this message translates to:
  /// **'Some checks aren\'t complete. This will be recorded. You can return and finish anytime this shift.'**
  String get leaveBeforeFinishingBody;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @enterValueWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Enter value ({unit})'**
  String enterValueWithUnit(String unit);

  /// No description provided for @safeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Safe: {min} - {max}'**
  String safeRangeLabel(String min, String max);

  /// No description provided for @errorNumericRequired.
  ///
  /// In en, this message translates to:
  /// **'A valid numeric value is required'**
  String get errorNumericRequired;

  /// No description provided for @errorSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get errorSelectOption;

  /// No description provided for @errorNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Notes required'**
  String get errorNotesRequired;

  /// No description provided for @errorPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Photo required'**
  String get errorPhotoRequired;

  /// No description provided for @errorCorrectiveActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose how the corrective action was handled'**
  String get errorCorrectiveActionRequired;

  /// No description provided for @myTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasksTitle;

  /// No description provided for @taskTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskTitleFallback;

  /// No description provided for @noTasksAssigned.
  ///
  /// In en, this message translates to:
  /// **'No tasks assigned yet.'**
  String get noTasksAssigned;

  /// No description provided for @overdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdueLabel;

  /// No description provided for @overdueSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String overdueSinceLabel(String date);

  /// No description provided for @withinRangePass.
  ///
  /// In en, this message translates to:
  /// **'Within range - PASS'**
  String get withinRangePass;

  /// No description provided for @outsideRangeFail.
  ///
  /// In en, this message translates to:
  /// **'Outside range - FAIL'**
  String get outsideRangeFail;

  /// No description provided for @selectOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get selectOptionLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @spotCheckPhotoNotice.
  ///
  /// In en, this message translates to:
  /// **'Today\'s spot-check - a photo is needed this time to confirm this was actually done.'**
  String get spotCheckPhotoNotice;

  /// No description provided for @photoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo Added'**
  String get photoAdded;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @passLabel.
  ///
  /// In en, this message translates to:
  /// **'PASS'**
  String get passLabel;

  /// No description provided for @failLabel.
  ///
  /// In en, this message translates to:
  /// **'FAIL'**
  String get failLabel;

  /// No description provided for @readingOutsideSafeRange.
  ///
  /// In en, this message translates to:
  /// **'Reading is outside the safe range'**
  String get readingOutsideSafeRange;

  /// No description provided for @hereIsWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what to do:'**
  String get hereIsWhatToDo;

  /// No description provided for @correctiveActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Corrective action required'**
  String get correctiveActionRequired;

  /// No description provided for @iFixedIt.
  ///
  /// In en, this message translates to:
  /// **'I fixed it'**
  String get iFixedIt;

  /// No description provided for @reportedToManager.
  ///
  /// In en, this message translates to:
  /// **'Reported to manager'**
  String get reportedToManager;

  /// No description provided for @correctiveActionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'What did you do? (optional)'**
  String get correctiveActionNoteLabel;

  /// No description provided for @managerWillBeNotified.
  ///
  /// In en, this message translates to:
  /// **'Your manager will be notified.'**
  String get managerWillBeNotified;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submitButton;

  /// No description provided for @availableFrom.
  ///
  /// In en, this message translates to:
  /// **'Available from {time}'**
  String availableFrom(String time);

  /// No description provided for @backToList.
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get backToList;

  /// No description provided for @skipComesBackLater.
  ///
  /// In en, this message translates to:
  /// **'Skip - comes back later'**
  String get skipComesBackLater;

  /// No description provided for @noAdHocTaskTypesSetUp.
  ///
  /// In en, this message translates to:
  /// **'No ad-hoc task types are set up at this site yet - ask a manager to assign a delivery-check or temperature-check task template first.'**
  String get noAdHocTaskTypesSetUp;

  /// No description provided for @whatKindOfThing.
  ///
  /// In en, this message translates to:
  /// **'What kind of thing are you doing?'**
  String get whatKindOfThing;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptionalLabel;

  /// No description provided for @noteOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptionalLabel;

  /// No description provided for @temperatureCelsiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperatureCelsiusLabel;

  /// No description provided for @submitLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitLabel;

  /// No description provided for @logReadingButton.
  ///
  /// In en, this message translates to:
  /// **'Log reading'**
  String get logReadingButton;

  /// No description provided for @loggedThanksMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged. Thanks for recording this.'**
  String get loggedThanksMessage;

  /// No description provided for @logAnotherAdHocTask.
  ///
  /// In en, this message translates to:
  /// **'Log another ad-hoc task'**
  String get logAnotherAdHocTask;

  /// No description provided for @deliveryCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery check'**
  String get deliveryCheckLabel;

  /// No description provided for @temperatureCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'Temperature check'**
  String get temperatureCheckLabel;

  /// No description provided for @sessionSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionSummaryTitle;

  /// No description provided for @tasksCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'Tasks completed: {count}'**
  String tasksCompletedCount(int count);

  /// No description provided for @passedLabel.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passedLabel;

  /// No description provided for @failedLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedLabel;

  /// No description provided for @triggersFailedTasks.
  ///
  /// In en, this message translates to:
  /// **'Triggers / Failed tasks'**
  String get triggersFailedTasks;

  /// No description provided for @yourReliability.
  ///
  /// In en, this message translates to:
  /// **'Your reliability'**
  String get yourReliability;

  /// No description provided for @reliabilityExplanation.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days - checks completed and logged on time. A logged fail counts the same as a logged pass: this only measures whether you checked and when.'**
  String get reliabilityExplanation;

  /// No description provided for @completedPercentChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed'**
  String completedPercentChip(int percent);

  /// No description provided for @onTimePercentChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% on time'**
  String onTimePercentChip(int percent);

  /// No description provided for @sendSummaryToManager.
  ///
  /// In en, this message translates to:
  /// **'Send this summary to a manager (optional)'**
  String get sendSummaryToManager;

  /// No description provided for @noManagersSetUp.
  ///
  /// In en, this message translates to:
  /// **'No managers set up yet.'**
  String get noManagersSetUp;

  /// No description provided for @managerLabel.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get managerLabel;

  /// No description provided for @sentLabel.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sentLabel;

  /// No description provided for @sendLabel.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendLabel;

  /// No description provided for @leaveNoteForNextShift.
  ///
  /// In en, this message translates to:
  /// **'Leave a note for the next shift (optional)'**
  String get leaveNoteForNextShift;

  /// No description provided for @handoverNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Handover note'**
  String get handoverNoteLabel;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// No description provided for @supplierOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier (optional)'**
  String get supplierOptionalLabel;

  /// No description provided for @supplierWarningRecorded.
  ///
  /// In en, this message translates to:
  /// **'This supplier is marked {status} - the check will still be recorded.'**
  String supplierWarningRecorded(String status);

  /// No description provided for @reportProblemWithDelivery.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with this delivery'**
  String get reportProblemWithDelivery;

  /// No description provided for @temperatureOnArrivalLabel.
  ///
  /// In en, this message translates to:
  /// **'Temperature on arrival (°C, optional)'**
  String get temperatureOnArrivalLabel;

  /// No description provided for @problemsTickAnyApply.
  ///
  /// In en, this message translates to:
  /// **'Problems (tick any that apply)'**
  String get problemsTickAnyApply;

  /// No description provided for @shortDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Short delivery'**
  String get shortDeliveryLabel;

  /// No description provided for @damagedStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Damaged stock'**
  String get damagedStockLabel;

  /// No description provided for @lateDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Late delivery'**
  String get lateDeliveryLabel;

  /// No description provided for @qualityProblemLabel.
  ///
  /// In en, this message translates to:
  /// **'Quality problem'**
  String get qualityProblemLabel;

  /// No description provided for @outcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get outcomeLabel;

  /// No description provided for @acceptedLabel.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedLabel;

  /// No description provided for @rejectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedLabel;

  /// No description provided for @partiallyAcceptedLabel.
  ///
  /// In en, this message translates to:
  /// **'Partially accepted'**
  String get partiallyAcceptedLabel;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera was found on this device.'**
  String get noCameraFound;

  /// No description provided for @couldNotStartCamera.
  ///
  /// In en, this message translates to:
  /// **'Could not start the camera: {error}'**
  String couldNotStartCamera(String error);

  /// No description provided for @couldNotSwitchCamera.
  ///
  /// In en, this message translates to:
  /// **'Could not switch camera: {error}'**
  String couldNotSwitchCamera(String error);

  /// No description provided for @couldNotCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not capture a photo: {error}'**
  String couldNotCapturePhoto(String error);

  /// No description provided for @switchCameraTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCameraTooltip;

  /// No description provided for @allTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasksTitle;

  /// No description provided for @otherSegmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherSegmentLabel;

  /// No description provided for @reorderTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder Tasks'**
  String get reorderTasksTitle;

  /// No description provided for @ungroupedLabel.
  ///
  /// In en, this message translates to:
  /// **'Ungrouped'**
  String get ungroupedLabel;

  /// No description provided for @taskOrderSaved.
  ///
  /// In en, this message translates to:
  /// **'Task order saved.'**
  String get taskOrderSaved;

  /// No description provided for @couldNotSaveTaskOrder.
  ///
  /// In en, this message translates to:
  /// **'Could not save task order: {error}'**
  String couldNotSaveTaskOrder(String error);

  /// No description provided for @noVenueSelectedReorder.
  ///
  /// In en, this message translates to:
  /// **'No venue selected yet. Set an active venue from Venue Details before reordering tasks.'**
  String get noVenueSelectedReorder;

  /// No description provided for @noActiveTasksToReorder.
  ///
  /// In en, this message translates to:
  /// **'No active tasks to reorder yet. Assign tasks first, then return here to choose their order.'**
  String get noActiveTasksToReorder;

  /// No description provided for @savingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingEllipsis;

  /// No description provided for @saveOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Order'**
  String get saveOrderLabel;

  /// No description provided for @moveUpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUpTooltip;

  /// No description provided for @moveDownTooltip.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDownTooltip;

  /// No description provided for @accountRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account restricted'**
  String get accountRestrictedTitle;

  /// No description provided for @accountRestrictedBody.
  ///
  /// In en, this message translates to:
  /// **'This organisation\'s Direct Debit needs attention before new checks can be saved. Your work isn\'t lost - please tell a manager or Director to sort out billing, then try again.'**
  String get accountRestrictedBody;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okLabel;

  /// No description provided for @troubleshootingTitle.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get troubleshootingTitle;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @couldntReachAssistant.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the assistant'**
  String get couldntReachAssistant;

  /// No description provided for @aiOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant isn\'t reachable right now - could be your connection, or the service is temporarily down. In the meantime, FAQ and Troubleshooting below cover the most common questions, or contact VenuRite directly.'**
  String get aiOfflineBody;

  /// No description provided for @askQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a straight answer, in plain language'**
  String get askQuestionSubtitle;

  /// No description provided for @faqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Common questions, answered'**
  String get faqSubtitle;

  /// No description provided for @troubleshootingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Something not working? Start here'**
  String get troubleshootingSubtitle;

  /// No description provided for @contactVenuriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact VenuRite'**
  String get contactVenuriteTitle;

  /// No description provided for @contactVenuriteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get in touch directly'**
  String get contactVenuriteSubtitle;

  /// No description provided for @topTierViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Top-Tier View'**
  String get topTierViewTitle;

  /// No description provided for @everythingsDone.
  ///
  /// In en, this message translates to:
  /// **'Everything\'s done. Nice work.'**
  String get everythingsDone;

  /// No description provided for @tasksNotCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 task not completed:} other{{count} tasks not completed:}}'**
  String tasksNotCompletedCount(int count);

  /// No description provided for @backToShiftLabel.
  ///
  /// In en, this message translates to:
  /// **'Back to shift'**
  String get backToShiftLabel;

  /// No description provided for @finishShiftLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish shift'**
  String get finishShiftLabel;

  /// No description provided for @ehoAuditExportTitle.
  ///
  /// In en, this message translates to:
  /// **'EHO / Audit Export'**
  String get ehoAuditExportTitle;

  /// No description provided for @ehoExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Generates a PDF of this venue\'s compliance records for the chosen date range.'**
  String get ehoExportDescription;

  /// No description provided for @dateRangeValue.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}'**
  String dateRangeValue(String start, String end);

  /// No description provided for @selectDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRangeLabel;

  /// No description provided for @tapToChooseDates.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a start and end date.'**
  String get tapToChooseDates;

  /// No description provided for @includeFullDetailedLog.
  ///
  /// In en, this message translates to:
  /// **'Include full detailed log'**
  String get includeFullDetailedLog;

  /// No description provided for @fullLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off by default - the summary and exceptions above are what an inspector actually reviews; this adds every individual check on top.'**
  String get fullLogSubtitle;

  /// No description provided for @generateLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateLabel;

  /// No description provided for @exportFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Failed'**
  String get exportFailedTitle;

  /// No description provided for @exportFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedBody(String error);

  /// No description provided for @exportCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Created'**
  String get exportCreatedTitle;

  /// No description provided for @savedToLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved to:\n{path}'**
  String savedToLabel(String path);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @noVenueFound.
  ///
  /// In en, this message translates to:
  /// **'No venue found.'**
  String get noVenueFound;

  /// No description provided for @allPermittedVenuesLast30Days.
  ///
  /// In en, this message translates to:
  /// **'All permitted venues · last 30 days'**
  String get allPermittedVenuesLast30Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @failCountBadge.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 FAIL (30 days)} other{{count} FAILs (30 days)}}'**
  String failCountBadge(int count);

  /// No description provided for @overdueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String overdueCountLabel(int count);

  /// No description provided for @venuesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Venues'**
  String get venuesSectionTitle;

  /// No description provided for @teamSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamSectionTitle;

  /// No description provided for @noStaffAtVenue.
  ///
  /// In en, this message translates to:
  /// **'No staff at this venue yet.'**
  String get noStaffAtVenue;

  /// No description provided for @notEnoughDataYet.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get notEnoughDataYet;

  /// No description provided for @venueFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venueFallbackLabel;

  /// No description provided for @trendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trendsTitle;

  /// No description provided for @trendNeedsHistory.
  ///
  /// In en, this message translates to:
  /// **'Trend data: need at least 4 weeks of history to show a trend.'**
  String get trendNeedsHistory;

  /// No description provided for @perVenueWeeklyCompletion.
  ///
  /// In en, this message translates to:
  /// **'Per-venue weekly completion · last {weeks} weeks'**
  String perVenueWeeklyCompletion(int weeks);

  /// No description provided for @allVenuesCombined.
  ///
  /// In en, this message translates to:
  /// **'All venues combined'**
  String get allVenuesCombined;

  /// No description provided for @noVenuesYet.
  ///
  /// In en, this message translates to:
  /// **'No venues yet.'**
  String get noVenuesYet;

  /// No description provided for @otherVenuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other venues'**
  String get otherVenuesLabel;

  /// No description provided for @lowLoggingFlagLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} checks logged'**
  String lowLoggingFlagLabel(int completed, int total);

  /// No description provided for @regionFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Region #{id}'**
  String regionFallbackLabel(int id);

  /// No description provided for @dashboardOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Overview'**
  String get dashboardOverviewTitle;

  /// No description provided for @gradedBarsOnTooltip.
  ///
  /// In en, this message translates to:
  /// **'Per-employee graded bars: on'**
  String get gradedBarsOnTooltip;

  /// No description provided for @gradedBarsOffTooltip.
  ///
  /// In en, this message translates to:
  /// **'Per-employee graded bars: off'**
  String get gradedBarsOffTooltip;

  /// No description provided for @noBranchesToShow.
  ///
  /// In en, this message translates to:
  /// **'No branches to show yet.'**
  String get noBranchesToShow;

  /// No description provided for @supervisorNoScopeMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t been assigned to a section or team yet - ask a manager to set this up in Staff Management before this dashboard has anything to show.'**
  String get supervisorNoScopeMessage;

  /// No description provided for @individualViewNotice.
  ///
  /// In en, this message translates to:
  /// **'Individual view - for risk oversight, not a league table.'**
  String get individualViewNotice;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @allBranchesLabel.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranchesLabel;

  /// No description provided for @yourSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Your section'**
  String get yourSectionLabel;

  /// No description provided for @noneAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'None assigned'**
  String get noneAssignedLabel;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @allAreasLabel.
  ///
  /// In en, this message translates to:
  /// **'All areas'**
  String get allAreasLabel;

  /// No description provided for @employeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeLabel;

  /// No description provided for @allEmployeesLabel.
  ///
  /// In en, this message translates to:
  /// **'All employees'**
  String get allEmployeesLabel;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekLabel;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @noTaskActivityPeriod.
  ///
  /// In en, this message translates to:
  /// **'No task activity in this period.'**
  String get noTaskActivityPeriod;

  /// No description provided for @taskOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Task overview'**
  String get taskOverviewTitle;

  /// No description provided for @incidentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get incidentsTitle;

  /// No description provided for @noIncidentsPeriod.
  ///
  /// In en, this message translates to:
  /// **'No incidents raised in this period.'**
  String get noIncidentsPeriod;

  /// No description provided for @urgentCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} urgent'**
  String urgentCountLabel(int count);

  /// No description provided for @tapForDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a colour section or legend entry for details'**
  String get tapForDetailsHint;

  /// No description provided for @employeeFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeFallbackLabel;

  /// No description provided for @plainLookupNotice.
  ///
  /// In en, this message translates to:
  /// **'A plain lookup, not a score - completion colour and issue tags here are never graded per person.'**
  String get plainLookupNotice;

  /// No description provided for @tasksCompletedCountParens.
  ///
  /// In en, this message translates to:
  /// **'Tasks completed ({count})'**
  String tasksCompletedCountParens(int count);

  /// No description provided for @issuesRaisedCountParens.
  ///
  /// In en, this message translates to:
  /// **'Issues raised ({count})'**
  String issuesRaisedCountParens(int count);

  /// No description provided for @doneOnTimeNoIssues.
  ///
  /// In en, this message translates to:
  /// **'Done on time (no issues)'**
  String get doneOnTimeNoIssues;

  /// No description provided for @doneOnTimeIssuesLogged.
  ///
  /// In en, this message translates to:
  /// **'Done on time (issues logged)'**
  String get doneOnTimeIssuesLogged;

  /// No description provided for @doneEarlyLateNoIssues.
  ///
  /// In en, this message translates to:
  /// **'Done early/late (no issues)'**
  String get doneEarlyLateNoIssues;

  /// No description provided for @doneEarlyLateIssuesLogged.
  ///
  /// In en, this message translates to:
  /// **'Done early/late (issues logged)'**
  String get doneEarlyLateIssuesLogged;

  /// No description provided for @notDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get notDoneLabel;

  /// No description provided for @resolvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolvedLabel;

  /// No description provided for @unresolvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get unresolvedLabel;

  /// No description provided for @escalatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get escalatedLabel;

  /// No description provided for @urgentLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgentLabel;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get signInFailed;

  /// No description provided for @twoFactorRequiredNoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification is required but no factor was found.'**
  String get twoFactorRequiredNoFactor;

  /// No description provided for @couldNotVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Could not verify that code'**
  String get couldNotVerifyCode;

  /// No description provided for @codeDidntWork.
  ///
  /// In en, this message translates to:
  /// **'That code didn\'t work.'**
  String get codeDidntWork;

  /// No description provided for @accountNotLinkedToStaff.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t linked to a staff profile yet - contact an admin.'**
  String get accountNotLinkedToStaff;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @enterEmailForResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code to reset your password.'**
  String get enterEmailForResetCode;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @sendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'SEND CODE'**
  String get sendCodeButton;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @sentCodeToEmail.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {email}. Enter it below with your new password.'**
  String sentCodeToEmail(String email);

  /// No description provided for @sixDigitCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get sixDigitCodeLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'RESET PASSWORD'**
  String get resetPasswordButton;

  /// No description provided for @twoFactorVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Verification'**
  String get twoFactorVerificationTitle;

  /// No description provided for @enterAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your authenticator app.'**
  String get enterAuthenticatorCode;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verifyButton;

  /// No description provided for @regionalDirectorSignIn.
  ///
  /// In en, this message translates to:
  /// **'Regional & Director sign-in.'**
  String get regionalDirectorSignIn;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signInButton;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @noBackendConfiguredPin.
  ///
  /// In en, this message translates to:
  /// **'No backend is configured for this install - sign in with a PIN, same as everyone else.'**
  String get noBackendConfiguredPin;

  /// No description provided for @noDirectorRegionalAccounts.
  ///
  /// In en, this message translates to:
  /// **'No Director/Regional accounts on this device.'**
  String get noDirectorRegionalAccounts;

  /// No description provided for @directorLabel.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get directorLabel;

  /// No description provided for @regionalManagerLabel.
  ///
  /// In en, this message translates to:
  /// **'Regional Manager'**
  String get regionalManagerLabel;

  /// No description provided for @whoAreYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get whoAreYouTitle;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @noMatchesLabel.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatchesLabel;

  /// No description provided for @leadershipSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get leadershipSectionTitle;

  /// No description provided for @kitchenStaffSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Staff'**
  String get kitchenStaffSectionTitle;

  /// No description provided for @chooseASectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a section'**
  String get chooseASectionTitle;

  /// No description provided for @unassignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassignedLabel;

  /// No description provided for @personCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} person} other{{count} people}}'**
  String personCountLabel(int count);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @welcomeToVenurite.
  ///
  /// In en, this message translates to:
  /// **'Welcome to VenuRite'**
  String get welcomeToVenurite;

  /// No description provided for @helpAssistantTooltip.
  ///
  /// In en, this message translates to:
  /// **'Help & Assistant'**
  String get helpAssistantTooltip;

  /// No description provided for @couldntLoadScreen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this screen.'**
  String get couldntLoadScreen;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @microphonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission was denied.'**
  String get microphonePermissionDenied;

  /// No description provided for @couldntRecordTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t record that - try again.'**
  String get couldntRecordTryAgain;

  /// No description provided for @couldntTranscribe.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t transcribe that.'**
  String get couldntTranscribe;

  /// No description provided for @couldntReachTranscriptionService.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the transcription service.'**
  String get couldntReachTranscriptionService;

  /// No description provided for @dictateANote.
  ///
  /// In en, this message translates to:
  /// **'Dictate a note'**
  String get dictateANote;

  /// No description provided for @stoppingSoonTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Stopping soon - tap to stop now'**
  String get stoppingSoonTapToStop;

  /// No description provided for @stopLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopLabel;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @alertsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 alert} other{{count} alerts}}'**
  String alertsCountLabel(int count);

  /// No description provided for @unacknowledgedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} unacknowledged'**
  String unacknowledgedCountLabel(int count);

  /// No description provided for @allAcknowledgedLabel.
  ///
  /// In en, this message translates to:
  /// **'All acknowledged'**
  String get allAcknowledgedLabel;

  /// No description provided for @overdueUnacknowledgedMinutes.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE - unacknowledged for {minutes} min'**
  String overdueUnacknowledgedMinutes(int minutes);

  /// No description provided for @escalatedToTopTier.
  ///
  /// In en, this message translates to:
  /// **'Escalated to top tier'**
  String get escalatedToTopTier;

  /// No description provided for @acknowledgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledgeLabel;

  /// No description provided for @nothingInCategory.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this category.'**
  String get nothingInCategory;

  /// No description provided for @categoryWithCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{title} ({count})'**
  String categoryWithCountLabel(String title, int count);

  /// No description provided for @leadershipOverview.
  ///
  /// In en, this message translates to:
  /// **'Leadership Overview'**
  String get leadershipOverview;

  /// No description provided for @photoEvidence.
  ///
  /// In en, this message translates to:
  /// **'Photo Evidence'**
  String get photoEvidence;

  /// No description provided for @staffManagement.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get staffManagement;

  /// No description provided for @addTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Add Team Member'**
  String get addTeamMember;

  /// No description provided for @shiftLog.
  ///
  /// In en, this message translates to:
  /// **'Shift Log'**
  String get shiftLog;

  /// No description provided for @branchTeamStructure.
  ///
  /// In en, this message translates to:
  /// **'Branch Team Structure'**
  String get branchTeamStructure;

  /// No description provided for @departmentManagement.
  ///
  /// In en, this message translates to:
  /// **'Department Management'**
  String get departmentManagement;

  /// No description provided for @rosterBoard.
  ///
  /// In en, this message translates to:
  /// **'Roster Board'**
  String get rosterBoard;

  /// No description provided for @claimShifts.
  ///
  /// In en, this message translates to:
  /// **'Claim Shifts'**
  String get claimShifts;

  /// No description provided for @requestADayOff.
  ///
  /// In en, this message translates to:
  /// **'Request a Day Off'**
  String get requestADayOff;

  /// No description provided for @shiftFairnessReview.
  ///
  /// In en, this message translates to:
  /// **'Shift Fairness Review'**
  String get shiftFairnessReview;

  /// No description provided for @venueDetails.
  ///
  /// In en, this message translates to:
  /// **'Venue Details'**
  String get venueDetails;

  /// No description provided for @assignTasks.
  ///
  /// In en, this message translates to:
  /// **'Assign Tasks'**
  String get assignTasks;

  /// No description provided for @taskPresets.
  ///
  /// In en, this message translates to:
  /// **'Task Presets'**
  String get taskPresets;

  /// No description provided for @supplierManagement.
  ///
  /// In en, this message translates to:
  /// **'Supplier Management'**
  String get supplierManagement;

  /// No description provided for @serviceProviders.
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get serviceProviders;

  /// No description provided for @notificationRules.
  ///
  /// In en, this message translates to:
  /// **'Notification Rules'**
  String get notificationRules;

  /// No description provided for @documentCentre.
  ///
  /// In en, this message translates to:
  /// **'Document Centre'**
  String get documentCentre;

  /// No description provided for @setupWizard.
  ///
  /// In en, this message translates to:
  /// **'Setup Wizard'**
  String get setupWizard;

  /// No description provided for @organisationLabel.
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get organisationLabel;

  /// No description provided for @branchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesLabel;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @oversightLabel.
  ///
  /// In en, this message translates to:
  /// **'Oversight'**
  String get oversightLabel;

  /// No description provided for @problemsAndIssues.
  ///
  /// In en, this message translates to:
  /// **'Problems & Issues'**
  String get problemsAndIssues;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @backUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back Up Now'**
  String get backUpNow;

  /// No description provided for @dailySection.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailySection;

  /// No description provided for @insightsSection.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsSection;

  /// No description provided for @peopleSection.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleSection;

  /// No description provided for @rosterSection.
  ///
  /// In en, this message translates to:
  /// **'Roster'**
  String get rosterSection;

  /// No description provided for @venueSetupSection.
  ///
  /// In en, this message translates to:
  /// **'Venue Setup'**
  String get venueSetupSection;

  /// No description provided for @companySection.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companySection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @percentCompletedTodayChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed today'**
  String percentCompletedTodayChip(int percent);

  /// No description provided for @activeStaffCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} active staff'**
  String activeStaffCountLabel(int count);

  /// No description provided for @failCountTodayBadge.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 FAIL today} other{{count} FAILs today}}'**
  String failCountTodayBadge(int count);

  /// No description provided for @managerViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Manager View'**
  String get managerViewTitle;

  /// No description provided for @showingScopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Showing: {scope}'**
  String showingScopeLabel(String scope);

  /// No description provided for @supervisorNoScopeMessageLog.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t been assigned to a section or team yet - ask a manager to set this up in Staff Management before this log has anything to show.'**
  String get supervisorNoScopeMessageLog;

  /// No description provided for @entriesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 entry} other{{count} entries}}'**
  String entriesCountLabel(int count);

  /// No description provided for @failCountPlain.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 FAIL} other{{count} FAILs}}'**
  String failCountPlain(int count);

  /// No description provided for @noFailsLabel.
  ///
  /// In en, this message translates to:
  /// **'No fails'**
  String get noFailsLabel;

  /// No description provided for @noCompletedTasksLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks logged yet'**
  String get noCompletedTasksLoggedYet;

  /// No description provided for @sessionSummariesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 session summary} other{{count} session summaries}}'**
  String sessionSummariesCountLabel(int count);

  /// No description provided for @passFailCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{passCount} pass / {failCount} fail'**
  String passFailCountLabel(int passCount, int failCount);

  /// No description provided for @workerFixedIt.
  ///
  /// In en, this message translates to:
  /// **'Worker fixed it'**
  String get workerFixedIt;

  /// No description provided for @noCorrectiveActionRecorded.
  ///
  /// In en, this message translates to:
  /// **'No corrective action recorded'**
  String get noCorrectiveActionRecorded;

  /// No description provided for @taskAlertFallback.
  ///
  /// In en, this message translates to:
  /// **'Task alert'**
  String get taskAlertFallback;

  /// No description provided for @loggedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Logged by'**
  String get loggedByLabel;

  /// No description provided for @resultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultLabel;

  /// No description provided for @correctiveActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Corrective action'**
  String get correctiveActionLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @notCompletedSuffix.
  ///
  /// In en, this message translates to:
  /// **'- NOT COMPLETED (session ended)'**
  String get notCompletedSuffix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'hi',
    'hr',
    'pl',
    'ro',
    'ur',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'pl':
      return AppLocalizationsPl();
    case 'ro':
      return AppLocalizationsRo();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
