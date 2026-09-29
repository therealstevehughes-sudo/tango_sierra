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

  ///
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

  ///
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

  /// No description provided for @todayAllFails.
  ///
  /// In en, this message translates to:
  /// **'Today + all fails'**
  String get todayAllFails;

  /// No description provided for @byAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'By {axis}'**
  String byAxisLabel(String axis);

  /// No description provided for @nameAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameAxisLabel;

  /// No description provided for @dateAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateAxisLabel;

  /// No description provided for @taskAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskAxisLabel;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterLabel;

  /// No description provided for @filterByLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by:'**
  String get filterByLabel;

  /// No description provided for @clearFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFiltersLabel;

  /// No description provided for @staffLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffLabel;

  /// No description provided for @issueTypeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get issueTypeComplaint;

  /// No description provided for @issueTypeAccident.
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get issueTypeAccident;

  /// No description provided for @issueTypeIncident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get issueTypeIncident;

  /// No description provided for @issueTypeSupplyProblem.
  ///
  /// In en, this message translates to:
  /// **'Supply Problem'**
  String get issueTypeSupplyProblem;

  /// No description provided for @issueTypeVenueProblem.
  ///
  /// In en, this message translates to:
  /// **'Venue Problem'**
  String get issueTypeVenueProblem;

  /// No description provided for @issueTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issueTypeOther;

  /// No description provided for @incorrectDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect delivery'**
  String get incorrectDeliveryLabel;

  /// No description provided for @driverProblemLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver problem'**
  String get driverProblemLabel;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @whatKindOfThingHappened.
  ///
  /// In en, this message translates to:
  /// **'What kind of thing happened?'**
  String get whatKindOfThingHappened;

  /// No description provided for @whichOneLabel.
  ///
  /// In en, this message translates to:
  /// **'Which one?'**
  String get whichOneLabel;

  /// No description provided for @supplierLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplierLabel;

  /// No description provided for @whatWasWrongWithDelivery.
  ///
  /// In en, this message translates to:
  /// **'What was wrong with the delivery?'**
  String get whatWasWrongWithDelivery;

  /// No description provided for @receivedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Received by'**
  String get receivedByLabel;

  /// No description provided for @whichSectionOptional.
  ///
  /// In en, this message translates to:
  /// **'Which section is this about? (optional)'**
  String get whichSectionOptional;

  /// No description provided for @noSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'No section'**
  String get noSectionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Team (optional)'**
  String get teamOptionalLabel;

  /// No description provided for @noSpecificTeamLabel.
  ///
  /// In en, this message translates to:
  /// **'No specific team'**
  String get noSpecificTeamLabel;

  /// No description provided for @whatHappenedLabel.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get whatHappenedLabel;

  /// No description provided for @markAsUrgentLabel.
  ///
  /// In en, this message translates to:
  /// **'Mark as urgent'**
  String get markAsUrgentLabel;

  /// No description provided for @markUrgentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Needs attention right away, regardless of how long it sits unresolved'**
  String get markUrgentSubtitle;

  /// No description provided for @logItButton.
  ///
  /// In en, this message translates to:
  /// **'Log it'**
  String get logItButton;

  /// No description provided for @escalateToTitle.
  ///
  /// In en, this message translates to:
  /// **'Escalate to'**
  String get escalateToTitle;

  /// No description provided for @sendToLabel.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendToLabel;

  /// No description provided for @escalateButton.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get escalateButton;

  /// No description provided for @savedLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get savedLabel;

  /// No description provided for @remindedMessage.
  ///
  /// In en, this message translates to:
  /// **'Reminded {name}.'**
  String remindedMessage(String name);

  /// No description provided for @couldNotSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not send the reminder.'**
  String get couldNotSendReminder;

  /// No description provided for @viewSupplierScorecard.
  ///
  /// In en, this message translates to:
  /// **'View supplier scorecard'**
  String get viewSupplierScorecard;

  /// No description provided for @raisedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Raised {date}'**
  String raisedAtLabel(String date);

  /// No description provided for @escalatedToColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Escalated to: {name}'**
  String escalatedToColonLabel(String name);

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @addAnUpdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Add an update'**
  String get addAnUpdateLabel;

  /// No description provided for @addProcessNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Add process note'**
  String get addProcessNoteButton;

  /// No description provided for @resolveButton.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolveButton;

  /// No description provided for @reopenThisIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Reopen this issue'**
  String get reopenThisIssueTitle;

  /// No description provided for @whyReopenLabel.
  ///
  /// In en, this message translates to:
  /// **'Why should this be reopened?'**
  String get whyReopenLabel;

  /// No description provided for @reopenButton.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopenButton;

  /// No description provided for @sentToLabel.
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String sentToLabel(String name);

  /// No description provided for @remindButton.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remindButton;

  /// No description provided for @phaseRaisedLabel.
  ///
  /// In en, this message translates to:
  /// **'Raised'**
  String get phaseRaisedLabel;

  /// No description provided for @phaseUpdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get phaseUpdateLabel;

  /// No description provided for @phaseOutcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get phaseOutcomeLabel;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// No description provided for @dateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRangeLabel;

  /// No description provided for @allDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get allDatesLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @anyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Any type'**
  String get anyTypeLabel;

  /// No description provided for @anyoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Anyone'**
  String get anyoneLabel;

  /// No description provided for @staffFallback.
  ///
  /// In en, this message translates to:
  /// **'Staff #{id}'**
  String staffFallback(String id);

  /// No description provided for @nothingHereGoodSign.
  ///
  /// In en, this message translates to:
  /// **'Nothing here - that\'s a good sign.'**
  String get nothingHereGoodSign;

  /// No description provided for @escalatedToNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Escalated to {name}'**
  String escalatedToNameLabel(String name);

  /// No description provided for @havenReportedYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t reported anything yet.'**
  String get havenReportedYet;

  /// No description provided for @failsAndProblemsRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Fails & Problems Register'**
  String get failsAndProblemsRegisterTitle;

  /// No description provided for @taskProblemsTab.
  ///
  /// In en, this message translates to:
  /// **'Task Problems'**
  String get taskProblemsTab;

  /// No description provided for @issuesAndIncidentsTab.
  ///
  /// In en, this message translates to:
  /// **'Issues & Incidents'**
  String get issuesAndIncidentsTab;

  /// No description provided for @failFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get failFilterLabel;

  /// No description provided for @reportedFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get reportedFilterLabel;

  /// No description provided for @notCompletedFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get notCompletedFilterLabel;

  /// No description provided for @abandonedLabel.
  ///
  /// In en, this message translates to:
  /// **'Abandoned'**
  String get abandonedLabel;

  /// No description provided for @noActionTakenLabel.
  ///
  /// In en, this message translates to:
  /// **'No action taken'**
  String get noActionTakenLabel;

  /// No description provided for @markResolvedButton.
  ///
  /// In en, this message translates to:
  /// **'Mark Resolved'**
  String get markResolvedButton;

  /// No description provided for @openLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// No description provided for @enableRosterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enable Roster?'**
  String get enableRosterQuestion;

  /// No description provided for @rosterQuoteBody.
  ///
  /// In en, this message translates to:
  /// **'Based on your current staff numbers, this will add {amount} to your monthly Direct Debit, starting with your next payment.'**
  String rosterQuoteBody(String amount);

  /// No description provided for @confirmAndEnable.
  ///
  /// In en, this message translates to:
  /// **'Confirm and enable'**
  String get confirmAndEnable;

  /// No description provided for @couldNotReachVenurite.
  ///
  /// In en, this message translates to:
  /// **'Could not reach VenuRite: {error}'**
  String couldNotReachVenurite(String error);

  /// No description provided for @letStaffClaimShifts.
  ///
  /// In en, this message translates to:
  /// **'Let staff claim their own shifts'**
  String get letStaffClaimShifts;

  /// No description provided for @rosterPitchBody.
  ///
  /// In en, this message translates to:
  /// **'Post open shifts and let staff pick them up themselves - no more phone-round or WhatsApp group when someone can\'t make it in. Staff can also request days off, and you approve or decline from the same place.'**
  String get rosterPitchBody;

  /// No description provided for @pricingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricingLabel;

  /// No description provided for @priceUnder10Staff.
  ///
  /// In en, this message translates to:
  /// **'£6/month per branch with fewer than 10 staff'**
  String get priceUnder10Staff;

  /// No description provided for @price10PlusStaff.
  ///
  /// In en, this message translates to:
  /// **'£10/month per branch with 10 or more staff'**
  String get price10PlusStaff;

  /// No description provided for @addedToDirectDebitNote.
  ///
  /// In en, this message translates to:
  /// **'Added to your existing Direct Debit - no new payment method needed. You\'ll see the exact amount before confirming.'**
  String get addedToDirectDebitNote;

  /// No description provided for @enableRosterButton.
  ///
  /// In en, this message translates to:
  /// **'Enable Roster'**
  String get enableRosterButton;

  /// No description provided for @availableShiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available Shifts'**
  String get availableShiftsTitle;

  /// No description provided for @shiftClaimingNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Shift claiming isn\'t switched on for this venue yet. Ask your manager to enable it in Settings.'**
  String get shiftClaimingNotEnabled;

  /// No description provided for @couldNotLoadShifts.
  ///
  /// In en, this message translates to:
  /// **'Could not load shifts: {error}'**
  String couldNotLoadShifts(String error);

  /// No description provided for @noShiftsPostedYet.
  ///
  /// In en, this message translates to:
  /// **'No shifts posted yet.'**
  String get noShiftsPostedYet;

  /// No description provided for @someoneElseClaimedShift.
  ///
  /// In en, this message translates to:
  /// **'Someone else just claimed that shift - sorry!'**
  String get someoneElseClaimedShift;

  /// No description provided for @shiftClaimedMessage.
  ///
  /// In en, this message translates to:
  /// **'Shift claimed.'**
  String get shiftClaimedMessage;

  /// No description provided for @cancelThisShiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this shift?'**
  String get cancelThisShiftTitle;

  /// No description provided for @cancelShiftLateWarning.
  ///
  /// In en, this message translates to:
  /// **'\n\nThis is less than 24 hours before the shift starts - cancelling now may affect your reliability record.'**
  String get cancelShiftLateWarning;

  /// No description provided for @willNoLongerBeClaimed.
  ///
  /// In en, this message translates to:
  /// **'You will no longer be claimed for this shift.{warning}'**
  String willNoLongerBeClaimed(String warning);

  /// No description provided for @keepShiftButton.
  ///
  /// In en, this message translates to:
  /// **'Keep shift'**
  String get keepShiftButton;

  /// No description provided for @cancelShiftButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel shift'**
  String get cancelShiftButton;

  /// No description provided for @yourShiftRecordReliable.
  ///
  /// In en, this message translates to:
  /// **'Your shift record: Reliable'**
  String get yourShiftRecordReliable;

  /// No description provided for @yourShiftRecordNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Your shift record: Needs improvement'**
  String get yourShiftRecordNeedsImprovement;

  /// No description provided for @yourShiftRecordBuilding.
  ///
  /// In en, this message translates to:
  /// **'Your shift record: Building a track record'**
  String get yourShiftRecordBuilding;

  /// No description provided for @claimLabel.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claimLabel;

  /// No description provided for @claimedLabel.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimedLabel;

  /// No description provided for @requestDateOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Request {date} off'**
  String requestDateOffTitle(String date);

  /// No description provided for @reasonOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get reasonOptionalLabel;

  /// No description provided for @submitRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequestButton;

  /// No description provided for @offDayRequestsNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Off-day requests aren\'t switched on for this venue yet. Ask your manager to enable Roster in Settings.'**
  String get offDayRequestsNotEnabled;

  /// No description provided for @noOffDayRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no off-day requests yet.'**
  String get noOffDayRequestsYet;

  /// No description provided for @yourRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your requests'**
  String get yourRequestsLabel;

  /// No description provided for @approvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedLabel;

  /// No description provided for @deniedLabel.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get deniedLabel;

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingLabel;

  /// No description provided for @postAShiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Post a shift'**
  String get postAShiftTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'e.g. Refrigeration Repair, Pest Control'**
  String get categoryHint;

  /// No description provided for @pickStartTime.
  ///
  /// In en, this message translates to:
  /// **'Pick start time'**
  String get pickStartTime;

  /// No description provided for @pickEndTime.
  ///
  /// In en, this message translates to:
  /// **'Pick end time'**
  String get pickEndTime;

  /// No description provided for @postLabel.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postLabel;

  /// No description provided for @assignShiftToTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign this shift to'**
  String get assignShiftToTitle;

  /// No description provided for @unknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// No description provided for @shiftsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shiftsTabLabel;

  /// No description provided for @offDayRequestsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Off-Day Requests'**
  String get offDayRequestsTabLabel;

  /// No description provided for @rosterAddonNotEnabledManager.
  ///
  /// In en, this message translates to:
  /// **'The Roster add-on isn\'t switched on for this venue. Enable it in Settings > Company to start posting shifts.'**
  String get rosterAddonNotEnabledManager;

  /// No description provided for @noShiftsTapPlus.
  ///
  /// In en, this message translates to:
  /// **'No shifts posted yet. Tap + to add one.'**
  String get noShiftsTapPlus;

  /// No description provided for @openStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openStatusLabel;

  /// No description provided for @assignedStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assignedStatusPrefix;

  /// No description provided for @claimedStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimedStatusPrefix;

  /// No description provided for @assignDirectlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign directly'**
  String get assignDirectlyLabel;

  /// No description provided for @removeClaimLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove claim'**
  String get removeClaimLabel;

  /// No description provided for @couldNotLoadOffDayRequests.
  ///
  /// In en, this message translates to:
  /// **'Could not load off-day requests: {error}'**
  String couldNotLoadOffDayRequests(String error);

  /// No description provided for @noOffDayRequests.
  ///
  /// In en, this message translates to:
  /// **'No off-day requests.'**
  String get noOffDayRequests;

  /// No description provided for @approveLabel.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveLabel;

  /// No description provided for @denyLabel.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get denyLabel;

  /// No description provided for @rosterAddonNotEnabledPlain.
  ///
  /// In en, this message translates to:
  /// **'The Roster add-on isn\'t switched on for this venue.'**
  String get rosterAddonNotEnabledPlain;

  /// No description provided for @noActiveStaffVenue.
  ///
  /// In en, this message translates to:
  /// **'No active staff at this venue yet.'**
  String get noActiveStaffVenue;

  /// No description provided for @last90DaysAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days, by shift category. Alphabetical - not a ranking.'**
  String get last90DaysAlphabetical;

  /// No description provided for @shiftsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 shift} other{{count} shifts}}'**
  String shiftsCountLabel(int count);

  /// No description provided for @noShiftsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No shifts in this period.'**
  String get noShiftsInPeriod;

  /// No description provided for @categoryCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{category}: {count}'**
  String categoryCountLabel(String category, int count);

  /// No description provided for @backupExplanation.
  ///
  /// In en, this message translates to:
  /// **'This creates a complete copy of the local database in your Documents folder. Moving it to a USB drive or cloud-synced folder afterward is a separate manual step.'**
  String get backupExplanation;

  /// No description provided for @backupNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Backup name (optional)'**
  String get backupNameOptional;

  /// No description provided for @backupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pre-inspection backup'**
  String get backupNameHint;

  /// No description provided for @backupCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup Created'**
  String get backupCreatedTitle;

  /// No description provided for @tierTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Team Member'**
  String get tierTeamMember;

  /// No description provided for @tierSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get tierSupervisor;

  /// No description provided for @tierManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get tierManager;

  /// No description provided for @tierRegionalManager.
  ///
  /// In en, this message translates to:
  /// **'Regional Manager'**
  String get tierRegionalManager;

  /// No description provided for @tierDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get tierDirector;

  /// No description provided for @anyTaskFail.
  ///
  /// In en, this message translates to:
  /// **'Any task fail'**
  String get anyTaskFail;

  /// No description provided for @taskFailLabel.
  ///
  /// In en, this message translates to:
  /// **'{title} fail'**
  String taskFailLabel(String title);

  /// No description provided for @taskFailTemplateStale.
  ///
  /// In en, this message translates to:
  /// **'Task fail (template no longer current)'**
  String get taskFailTemplateStale;

  /// No description provided for @unknownUserLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get unknownUserLabel;

  /// No description provided for @tierSuffixLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier} tier'**
  String tierSuffixLabel(String tier);

  /// No description provided for @unsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Unset'**
  String get unsetLabel;

  /// No description provided for @pushChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'push'**
  String get pushChannelLabel;

  /// No description provided for @emailChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get emailChannelLabel;

  /// No description provided for @inAppOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'in-app only'**
  String get inAppOnlyLabel;

  /// No description provided for @inAppPlusChannelsLabel.
  ///
  /// In en, this message translates to:
  /// **'in-app + {channels}'**
  String inAppPlusChannelsLabel(String channels);

  /// No description provided for @tierColumnTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get tierColumnTeam;

  /// No description provided for @tierColumnSupv.
  ///
  /// In en, this message translates to:
  /// **'Supv'**
  String get tierColumnSupv;

  /// No description provided for @tierColumnMgr.
  ///
  /// In en, this message translates to:
  /// **'Mgr'**
  String get tierColumnMgr;

  /// No description provided for @tierColumnRegnl.
  ///
  /// In en, this message translates to:
  /// **'Regnl'**
  String get tierColumnRegnl;

  /// No description provided for @tierColumnDir.
  ///
  /// In en, this message translates to:
  /// **'Dir'**
  String get tierColumnDir;

  /// No description provided for @quickSetupSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick setup: per-task fail notifications'**
  String get quickSetupSectionTitle;

  /// No description provided for @tickTierNotified.
  ///
  /// In en, this message translates to:
  /// **'Tick which tier gets notified when a specific task fails.'**
  String get tickTierNotified;

  /// No description provided for @noTaskTemplatesSetUp.
  ///
  /// In en, this message translates to:
  /// **'No task templates set up yet.'**
  String get noTaskTemplatesSetUp;

  /// No description provided for @notifyPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Notify: {target} ({channels})'**
  String notifyPrefixLabel(String target, String channels);

  /// No description provided for @setByTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Set by {tier} tier'**
  String setByTierLabel(String tier);

  /// No description provided for @inactiveSuffixLabel.
  ///
  /// In en, this message translates to:
  /// **' - inactive'**
  String get inactiveSuffixLabel;

  /// No description provided for @deactivateButton.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivateButton;

  /// No description provided for @reactivateButton.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivateButton;

  /// No description provided for @newRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRuleTitle;

  /// No description provided for @triggerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger'**
  String get triggerLabel;

  /// No description provided for @notifyLabel.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notifyLabel;

  /// No description provided for @wholeRoleTierOption.
  ///
  /// In en, this message translates to:
  /// **'A whole role tier'**
  String get wholeRoleTierOption;

  /// No description provided for @specificPersonOption.
  ///
  /// In en, this message translates to:
  /// **'A specific person'**
  String get specificPersonOption;

  /// No description provided for @roleTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Role tier'**
  String get roleTierLabel;

  /// No description provided for @personLabel.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get personLabel;

  /// No description provided for @pushLabel.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get pushLabel;

  /// No description provided for @rulesInAppNotice.
  ///
  /// In en, this message translates to:
  /// **'Rules are shown in-app now; push/email delivery is not yet connected to a backend and will be added in a later sprint.'**
  String get rulesInAppNotice;

  /// No description provided for @saveRuleButton.
  ///
  /// In en, this message translates to:
  /// **'Save Rule'**
  String get saveRuleButton;

  /// No description provided for @addRuleButton.
  ///
  /// In en, this message translates to:
  /// **'Add Rule'**
  String get addRuleButton;

  /// No description provided for @noNotificationRulesYet.
  ///
  /// In en, this message translates to:
  /// **'No notification rules set up yet.'**
  String get noNotificationRulesYet;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get stepYourAccount;

  ///
  ///
  /// In en, this message translates to:
  /// **'Company details'**
  String get stepCompanyDetails;

  ///
  ///
  /// In en, this message translates to:
  /// **'Organisation structure'**
  String get stepOrgStructure;

  ///
  ///
  /// In en, this message translates to:
  /// **'First venue'**
  String get stepFirstVenue;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your starter setup'**
  String get stepStarterSetup;

  ///
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get stepSubscription;

  ///
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get stepPayment;

  ///
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Something went wrong creating your company. Please try again - if it keeps happening, contact VenuRite.'**
  String get companySignupGenericError;

  ///
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t start Direct Debit setup automatically - you can do this any time from Settings once you\'re signed in.'**
  String get directDebitStartError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingEllipsis;

  ///
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get startFreeTrialButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Company created'**
  String get companyCreatedTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your account. You\'ll be the administrator for this company on VenuRite, and can invite your team once you\'re in.'**
  String get adminAccountIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinCharsHelper;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tell us about your company.'**
  String get companyDetailsIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Trading / company name'**
  String get tradingCompanyNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Legal company name (optional)'**
  String get legalCompanyNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Leave blank to use the trading name above'**
  String get legalCompanyNameHelper;

  ///
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Registered / business address (optional)'**
  String get registeredAddressLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'VAT / tax number (if applicable)'**
  String get vatNumberLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Billing contact email (optional)'**
  String get billingContactEmailLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Here\'s how VenuRite organises your company. You don\'t need to set anything up now - this is just so the next step makes sense.'**
  String get structureIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your company'**
  String get structureYourCompanyLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'One consolidated account and bill'**
  String get structureYourCompanySublabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Regions (optional)'**
  String get structureRegionsLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Group venues by country or area - skip if you don\'t need it'**
  String get structureRegionsSublabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Venues'**
  String get structureVenuesLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'One venue today, hundreds later - add more any time'**
  String get structureVenuesSublabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get structureStaffLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Each venue\'s team, invited once it exists'**
  String get structureStaffSublabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'We\'ll set up your first venue next - you can add regions and more venues later from inside the app.'**
  String get structureOutro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Let\'s add your first venue'**
  String get wizardFirstVenueHeroTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'You can add more venues later.'**
  String get addMoreVenuesLaterText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Venue name'**
  String get venueNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get addressOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Region / area (optional)'**
  String get regionAreaOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'e.g. \"London\" - only needed if you have (or will have) more than one venue'**
  String get regionAreaHelper;

  ///
  ///
  /// In en, this message translates to:
  /// **'Venue type (optional)'**
  String get venueTypeOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Picking one shows you a ready-made starter set next - for tasks and equipment you already know you need.'**
  String get venueTypeHelper;

  ///
  ///
  /// In en, this message translates to:
  /// **'You skipped choosing a venue type, so there\'s no starter set to show yet - you can add tasks and equipment yourself once you\'re in.'**
  String get payoffSkippedText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the starter set for this venue type - you can add tasks and equipment yourself once you\'re in.'**
  String get payoffErrorText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Here\'s your compliance, ready to go'**
  String get payoffHeroTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentSectionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'One company account, one consolidated bill - priced per branch, never per person.'**
  String get subscriptionBannerText;

  ///
  ///
  /// In en, this message translates to:
  /// **'How many branches do you have today, including head office if you have one? You\'ll only set up your first venue now - add the rest any time from inside the app.'**
  String get subscriptionIntroText;

  ///
  ///
  /// In en, this message translates to:
  /// **'£39/branch/month'**
  String get perBranchPriceLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'+ 1 head office branch (4+ branches)'**
  String get headOfficeIncludedLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Have a discount code? You can enter it when you set up Direct Debit.'**
  String get discountCodeHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'You\'re starting a 14-day free trial - no card needed today.'**
  String get trialBannerText;

  ///
  ///
  /// In en, this message translates to:
  /// **'We\'ll ask you to set up payment before your trial ends, from Settings inside the app. Nothing is charged now - just tell us how you\'d prefer to pay.'**
  String get paymentStepIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Card payment (Stripe)'**
  String get cardPaymentTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Debit/credit card, billed monthly or annually'**
  String get cardPaymentSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Direct Debit (GoCardless)'**
  String get directDebitTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Bank-to-bank payment, no card required'**
  String get directDebitSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'I\'ll decide later'**
  String get decideLaterButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'No problem - you can set this up anytime from Settings.'**
  String get decideLaterSnackbar;

  ///
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the '**
  String get agreeToTermsPrefix;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your company and first venue are set up, and you\'re signed in.'**
  String get successActivatedBanner;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your company and first venue are set up. Sign in with your email and the password you just chose.'**
  String get successNotActivatedBanner;

  ///
  ///
  /// In en, this message translates to:
  /// **'Setting up Direct Debit...'**
  String get directDebitSettingUp;

  ///
  ///
  /// In en, this message translates to:
  /// **'We\'ve opened your browser to finish setting up Direct Debit.'**
  String get directDebitOpenedBrowser;

  ///
  ///
  /// In en, this message translates to:
  /// **'Invite your team'**
  String get inviteYourTeamTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Optional - add whoever\'s on shift now, or skip and do this later from Staff Management.'**
  String get inviteYourTeamSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitleLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get tierFieldLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add team member'**
  String get addTeamMemberButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Go to dashboard'**
  String get goToDashboardButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Go to sign in'**
  String get goToSignInButton;

  /// No description provided for @wizardStepOfLabel.
  ///
  /// In en, this message translates to:
  /// **'{title} - Step {step} of {total}'**
  String wizardStepOfLabel(String title, int step, int total);

  /// No description provided for @billingContactEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to use {email}'**
  String billingContactEmailHelper(String email);

  /// No description provided for @payoffNoStarterSet.
  ///
  /// In en, this message translates to:
  /// **'We don\'t have a pre-built starter set for {venueType} yet - you can add tasks and equipment yourself once you\'re in.'**
  String payoffNoStarterSet(String venueType);

  /// No description provided for @payoffSummaryWithEquipment.
  ///
  /// In en, this message translates to:
  /// **'{totalTasks} tasks across {sectionCount} sections and {equipmentCount} equipment types already set up for a {venueType}.'**
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  );

  /// No description provided for @payoffSummaryNoEquipment.
  ///
  /// In en, this message translates to:
  /// **'{totalTasks} tasks across {sectionCount} sections already set up for a {venueType}.'**
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  );

  /// No description provided for @totalPerMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'£{total}/month total ({units, plural, one{{units} branch} other{{units} branches}} billed)'**
  String totalPerMonthLabel(String total, int units);

  /// No description provided for @staffPinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN: {pin}'**
  String staffPinLabel(String pin);

  ///
  ///
  /// In en, this message translates to:
  /// **'Chef/Cook'**
  String get jobRoleChefCook;

  ///
  ///
  /// In en, this message translates to:
  /// **'Kitchen Porter'**
  String get jobRoleKitchenPorter;

  ///
  ///
  /// In en, this message translates to:
  /// **'Front of House'**
  String get jobRoleFrontOfHouse;

  ///
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get jobRoleBar;

  ///
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get jobRoleManagement;

  ///
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get jobRoleEveryone;

  ///
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get jobRoleMaintenance;

  ///
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get jobRoleHousekeeping;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get jobRoleReception;

  ///
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get jobRoleSecurity;

  ///
  ///
  /// In en, this message translates to:
  /// **'Food Safety & Temperature Control'**
  String get segmentFoodSafety;

  ///
  ///
  /// In en, this message translates to:
  /// **'Allergen Management'**
  String get segmentAllergen;

  ///
  ///
  /// In en, this message translates to:
  /// **'Personal Hygiene & PPE'**
  String get segmentPersonalHygienePpe;

  ///
  ///
  /// In en, this message translates to:
  /// **'Refrigeration & Cold Storage'**
  String get segmentRefrigerationColdStorage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Cooking Line Equipment'**
  String get segmentCookingLineEquipment;

  ///
  ///
  /// In en, this message translates to:
  /// **'Wash-up / Dishwash'**
  String get segmentWashupDishwash;

  ///
  ///
  /// In en, this message translates to:
  /// **'Cleaning & Sanitation'**
  String get segmentCleaningSanitation;

  ///
  ///
  /// In en, this message translates to:
  /// **'Cleaning Chemicals & Consumables'**
  String get segmentCleaningChemicals;

  ///
  ///
  /// In en, this message translates to:
  /// **'Dry & Ambient Storage'**
  String get segmentDryAmbientStorage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Deliveries & Goods In'**
  String get segmentDeliveriesGoodsIn;

  ///
  ///
  /// In en, this message translates to:
  /// **'Utilities & Safety'**
  String get segmentUtilitiesSafety;

  ///
  ///
  /// In en, this message translates to:
  /// **'Waste & Pest Control'**
  String get segmentWastePestControl;

  ///
  ///
  /// In en, this message translates to:
  /// **'Preventive Maintenance (Kitchen Equipment)'**
  String get segmentPreventiveMaintenance;

  ///
  ///
  /// In en, this message translates to:
  /// **'Stock Control'**
  String get segmentStockControl;

  ///
  ///
  /// In en, this message translates to:
  /// **'Opening Procedures'**
  String get segmentOpeningProcedures;

  ///
  ///
  /// In en, this message translates to:
  /// **'Closing Procedures'**
  String get segmentClosingProcedures;

  ///
  ///
  /// In en, this message translates to:
  /// **'Service Readiness'**
  String get segmentServiceReadiness;

  ///
  ///
  /// In en, this message translates to:
  /// **'Front of House / Service'**
  String get segmentFrontOfHouse;

  ///
  ///
  /// In en, this message translates to:
  /// **'Bar & Beverage'**
  String get segmentBarBeverage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Hotel-Specific'**
  String get segmentHotelSpecific;

  ///
  ///
  /// In en, this message translates to:
  /// **'Management & Compliance Oversight'**
  String get segmentManagementComplianceOversight;

  ///
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get segmentMaintenance;

  ///
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get segmentHousekeeping;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get segmentReception;

  ///
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get segmentSecurity;

  ///
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get freqDaily;

  ///
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get freqWeekly;

  ///
  ///
  /// In en, this message translates to:
  /// **'Per Shift'**
  String get freqPerShift;

  ///
  ///
  /// In en, this message translates to:
  /// **'3x Daily'**
  String get freqThreeXDaily;

  ///
  ///
  /// In en, this message translates to:
  /// **'2x Daily'**
  String get freqTwoXDaily;

  ///
  ///
  /// In en, this message translates to:
  /// **'Per Batch'**
  String get freqPerBatch;

  ///
  ///
  /// In en, this message translates to:
  /// **'Per Delivery'**
  String get freqPerDelivery;

  ///
  ///
  /// In en, this message translates to:
  /// **'Per Use'**
  String get freqPerUse;

  ///
  ///
  /// In en, this message translates to:
  /// **'Per Service'**
  String get freqPerService;

  ///
  ///
  /// In en, this message translates to:
  /// **'2x Per Service'**
  String get freqTwoXPerService;

  ///
  ///
  /// In en, this message translates to:
  /// **'Event-Based'**
  String get freqEventBased;

  ///
  ///
  /// In en, this message translates to:
  /// **'As Needed'**
  String get freqAsNeeded;

  ///
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get freqMonthly;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get freqCustom;

  ///
  ///
  /// In en, this message translates to:
  /// **'Job role'**
  String get jobRoleFieldLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pinFieldLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Staff Member'**
  String get addStaffMemberTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Assign Tasks'**
  String get assignTasksTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No active site found.'**
  String get noActiveSiteFoundError;

  ///
  ///
  /// In en, this message translates to:
  /// **'By Person'**
  String get byPersonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'By Task'**
  String get byTaskLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'No equipment of this type set up yet.'**
  String get noEquipmentOfTypeSetUp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get assignToTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No staff match the tier(s) these tasks apply to.'**
  String get noStaffMatchTiers;

  ///
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assignButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show instructions'**
  String get showInstructionsTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Select tasks to assign'**
  String get selectTasksToAssignLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Task Presets'**
  String get taskPresetsSectionTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show all presets'**
  String get showAllPresetsButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show tasks in this group'**
  String get showTasksInGroupTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Apply to Multiple'**
  String get applyToMultipleButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Custom Task'**
  String get addCustomTaskButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom Task'**
  String get customTaskSectionTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleFieldLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Department / section'**
  String get departmentSectionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get methodLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tick'**
  String get methodTick;

  ///
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get methodData;

  ///
  ///
  /// In en, this message translates to:
  /// **'Data + Tick'**
  String get methodDataTick;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tick + Photo'**
  String get methodTickPhoto;

  ///
  ///
  /// In en, this message translates to:
  /// **'Data + Photo'**
  String get methodDataPhoto;

  ///
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get methodNote;

  ///
  ///
  /// In en, this message translates to:
  /// **'Data + Note'**
  String get methodDataNote;

  ///
  ///
  /// In en, this message translates to:
  /// **'Note + Photo'**
  String get methodNotePhoto;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tick + Note'**
  String get methodTickNote;

  ///
  ///
  /// In en, this message translates to:
  /// **'Multi'**
  String get methodMulti;

  ///
  ///
  /// In en, this message translates to:
  /// **'Requires photo'**
  String get requiresPhotoLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Requires notes'**
  String get requiresNotesLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Min limit'**
  String get minLimitLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Max limit'**
  String get maxLimitLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unit (e.g. celsius)'**
  String get unitHintLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment type (optional)'**
  String get equipmentTypeOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priorityCritical;

  ///
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  ///
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get priorityStandard;

  ///
  ///
  /// In en, this message translates to:
  /// **'Requires corrective action on fail'**
  String get requiresCorrectiveActionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Fix instructions'**
  String get fixInstructionsLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom fields (JSON, optional)'**
  String get customFieldsJsonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Extra fields (optional)'**
  String get extraFieldsSectionTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Field label (e.g. PO number)'**
  String get fieldLabelHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get extraFieldTypeText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get extraFieldTypeNumber;

  ///
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get extraFieldTypeDate;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get addFieldTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Save Custom Task'**
  String get saveCustomTaskButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Ad hoc'**
  String get adHocLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Time allocated'**
  String get timeAllocatedLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Frequency: '**
  String get frequencyPrefixLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'At a time'**
  String get atATimeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'From start of shift'**
  String get fromStartOfShiftLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'From clock-in'**
  String get fromClockInLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Available from…'**
  String get availableFromEllipsis;

  ///
  ///
  /// In en, this message translates to:
  /// **'until…'**
  String get untilEllipsis;

  /// No description provided for @assignTasksForStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Tasks - {name}'**
  String assignTasksForStaffTitle(String name);

  /// No description provided for @applyPresetToWhichOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply \"{name}\" to which one?'**
  String applyPresetToWhichOneTitle(String name);

  /// No description provided for @allPresetTasksAlreadyAssigned.
  ///
  /// In en, this message translates to:
  /// **'All {name} tasks were already assigned'**
  String allPresetTasksAlreadyAssigned(String name);

  /// No description provided for @addedTasksFromPreset.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Added {count} task} other{Added {count} tasks}} from {name}'**
  String addedTasksFromPreset(int count, String name);

  /// No description provided for @applyPresetToTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply \"{name}\" to'**
  String applyPresetToTitle(String name);

  /// No description provided for @assignTasksCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Assign {count} task to staff…} other{Assign {count} tasks to staff…}}'**
  String assignTasksCountLabel(int count);

  /// No description provided for @addedTasksAcrossStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Added {count} assignment} other{Added {count} assignments}} across {staffCount, plural, one{{staffCount} staff member} other{{staffCount} staff members}}'**
  String addedTasksAcrossStaffLabel(int count, int staffCount);

  /// No description provided for @presetSectionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Section: {segment}'**
  String presetSectionPrefix(String segment);

  /// No description provided for @taskCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} task} other{{count} tasks}}'**
  String taskCountLabel(int count);

  /// No description provided for @showAllRolesLabel.
  ///
  /// In en, this message translates to:
  /// **'Show all roles (default: {jobRole} only)'**
  String showAllRolesLabel(String jobRole);

  /// No description provided for @extraFieldSummary.
  ///
  /// In en, this message translates to:
  /// **'{label} ({type})'**
  String extraFieldSummary(String label, String type);

  /// No description provided for @noEquipmentSetUpForTemplate.
  ///
  /// In en, this message translates to:
  /// **'{title} - no equipment set up for this yet'**
  String noEquipmentSetUpForTemplate(String title);

  /// No description provided for @fromTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'From {time}'**
  String fromTimeLabel(String time);

  /// No description provided for @untilTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String untilTimeLabel(String time);

  /// No description provided for @createdAssignmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} assignment created} other{{count} assignments created}}{skippedNote}.'**
  String createdAssignmentsLabel(int count, String skippedNote);

  /// No description provided for @skippedNoteLabel.
  ///
  /// In en, this message translates to:
  /// **' ({count} skipped - already assigned or role mismatch)'**
  String skippedNoteLabel(int count);

  ///
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get serviceProvidersTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'My Providers'**
  String get myProvidersTab;

  ///
  ///
  /// In en, this message translates to:
  /// **'Find a Provider'**
  String get findProviderTab;

  ///
  ///
  /// In en, this message translates to:
  /// **'Browsing other venues\' shared providers needs a real company account signed in - this can\'t work from the local demo login alone. Your own contacts under \"My Providers\" work either way.'**
  String get noBackendProviderNotice1;

  ///
  ///
  /// In en, this message translates to:
  /// **'Sign in via Leadership Access with a real company account to use this.'**
  String get noBackendProviderNotice2;

  ///
  ///
  /// In en, this message translates to:
  /// **'VenuRite doesn\'t vet or endorse any listed provider. Reviews are from other venues, not from VenuRite.'**
  String get providerDisclaimerText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add a Provider'**
  String get addProviderButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any service providers yet.'**
  String get noProvidersYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add a Service Provider'**
  String get addServiceProviderDialogTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Notes (optional, private to you)'**
  String get notesOptionalPrivateLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'I\'m happy to review and share'**
  String get happyToReviewShareLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Other venues will see your ratings and reviews, with the name/contact blurred until they unlock it.'**
  String get shareVisibilityExplanation;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rate this provider'**
  String get rateThisProviderLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceRatingLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Punctuality'**
  String get punctualityRatingLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get qualityRatingLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availabilityRatingLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Review (optional)'**
  String get reviewOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Describe your experience - please don\'t name the business or include contact details.'**
  String get reviewHintText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your session has expired - please sign in again.'**
  String get sessionExpiredMessage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Shared with other venues'**
  String get sharedWithOtherVenuesLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rate / Reviews'**
  String get rateReviewsButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Search by category or name'**
  String get searchByCategoryOrNameHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'No contacts unlocked yet this month.'**
  String get noContactsUnlockedThisMonth;

  ///
  ///
  /// In en, this message translates to:
  /// **'No shared providers yet - be the first to share one from \"My Providers.\"'**
  String get noSharedProvidersYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'No providers match your search.'**
  String get noProvidersMatchSearchText;

  ///
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Hidden until unlocked'**
  String get hiddenUntilUnlockedText;

  ///
  ///
  /// In en, this message translates to:
  /// **'(unnamed)'**
  String get unnamedPlaceholder;

  ///
  ///
  /// In en, this message translates to:
  /// **'Read reviews'**
  String get readReviewsButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unlock contact details'**
  String get unlockContactDetailsButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add your rating'**
  String get addYourRatingLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submittingEllipsis;

  ///
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRatingButton;

  /// No description provided for @reviewContainsInfoWarningShort.
  ///
  /// In en, this message translates to:
  /// **'Your review looks like it includes {found}. Please remove contact details or business names before submitting.'**
  String reviewContainsInfoWarningShort(String found);

  /// No description provided for @reviewContainsInfoWarningLong.
  ///
  /// In en, this message translates to:
  /// **'Your review looks like it includes {found}. Please remove contact details or business names before submitting - reviews stay useful (and fair) when they describe the experience, not who to call directly.'**
  String reviewContainsInfoWarningLong(String found);

  /// No description provided for @contactsUnlockedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} contact unlocked this month.} other{{count} contacts unlocked this month.}}'**
  String contactsUnlockedThisMonth(int count);

  /// No description provided for @priceValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Price {value}'**
  String priceValueLabel(String value);

  /// No description provided for @punctualityValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Punctuality {value}'**
  String punctualityValueLabel(String value);

  /// No description provided for @qualityValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Quality {value}'**
  String qualityValueLabel(String value);

  /// No description provided for @availabilityValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Availability {value}'**
  String availabilityValueLabel(String value);

  /// No description provided for @ratingReviewCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'{parts} ({count, plural, one{{count} review} other{{count} reviews}})'**
  String ratingReviewCountSuffix(String parts, int count);

  /// No description provided for @reviewRatingsLine.
  ///
  /// In en, this message translates to:
  /// **'Price {price} - Punctuality {punctuality} - Quality {quality} - Availability {availability}'**
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  );

  /// No description provided for @phonePrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: {value}'**
  String phonePrefixLabel(String value);

  /// No description provided for @emailPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Email: {value}'**
  String emailPrefixLabel(String value);

  ///
  ///
  /// In en, this message translates to:
  /// **'Fresh Produce'**
  String get supplierCategoryFreshProduce;

  ///
  ///
  /// In en, this message translates to:
  /// **'Meat & Poultry'**
  String get supplierCategoryMeatPoultry;

  ///
  ///
  /// In en, this message translates to:
  /// **'Dairy & Eggs'**
  String get supplierCategoryDairyEggs;

  ///
  ///
  /// In en, this message translates to:
  /// **'Frozen Goods'**
  String get supplierCategoryFrozenGoods;

  ///
  ///
  /// In en, this message translates to:
  /// **'Dry & Ambient Goods'**
  String get supplierCategoryDryAmbientGoods;

  ///
  ///
  /// In en, this message translates to:
  /// **'Drinks & Beverages'**
  String get supplierCategoryDrinksBeverages;

  ///
  ///
  /// In en, this message translates to:
  /// **'Chemicals & Cleaning Supplies'**
  String get supplierCategoryChemicalsCleaningSupplies;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment & Maintenance'**
  String get supplierCategoryEquipmentMaintenance;

  ///
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supplierCategoryOther;

  ///
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get supplierStatusApproved;

  ///
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get supplierStatusPending;

  ///
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get supplierStatusSuspended;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Equipment'**
  String get addEquipmentTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Venue Setup'**
  String get venueSetupTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Finish Setup'**
  String get finishSetupButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename Area'**
  String get renameAreaTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename Equipment'**
  String get renameEquipmentTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Retire Equipment'**
  String get retireEquipmentTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Retiring this equipment will also unassign any tasks currently assigned to it. Past submission history is kept. Continue?'**
  String get retireEquipmentConfirmText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Retire'**
  String get retireButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get areasStepTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add the operational zones of this venue.'**
  String get areasStepIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get areaSuggestionKitchen;

  ///
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get areaSuggestionStorage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get areaSuggestionReceiving;

  ///
  ///
  /// In en, this message translates to:
  /// **'Front of House'**
  String get areaSuggestionFrontOfHouse;

  ///
  ///
  /// In en, this message translates to:
  /// **'Area name'**
  String get areaNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add area'**
  String get addAreaTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentStepTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add named equipment instances, e.g. \"Fridge 1\", \"Fridge 2\".'**
  String get equipmentStepIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show all equipment types'**
  String get showAllEquipmentTypesButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment type'**
  String get equipmentTypeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Something else...'**
  String get somethingElseOption;

  ///
  ///
  /// In en, this message translates to:
  /// **'New equipment type name'**
  String get newEquipmentTypeNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Confirm new equipment type'**
  String get confirmNewEquipmentTypeTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'No areas set up for your department yet - equipment can still be added without one.'**
  String get noAreasForDeptText;

  ///
  ///
  /// In en, this message translates to:
  /// **'No areas added yet - go back to add one.'**
  String get noAreasAddOneText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Equipment name'**
  String get equipmentNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'e.g. Meat Walk-in, Dessert Fridge, Bar Fryer'**
  String get equipmentNameHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Model (optional)'**
  String get modelOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Serial number (optional)'**
  String get serialNumberOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Retire'**
  String get retireTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivateTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unknown type'**
  String get unknownTypeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Unknown area'**
  String get unknownAreaLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffStepTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add staff members and assign their role tier.'**
  String get staffStepIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Staff Member'**
  String get addStaffMemberButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliersStepTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add the suppliers this venue works with. Approval flags appear on the EHO export - suspended suppliers are surfaced to managers, not silently hidden.'**
  String get suppliersStepIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplierNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Contact (optional)'**
  String get contactOptionalLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmailHint;

  ///
  ///
  /// In en, this message translates to:
  /// **'Approval status'**
  String get approvalStatusLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get addSupplierButton;

  /// No description provided for @venueSetupStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue Setup - Step {step} of 4'**
  String venueSetupStepTitle(int step);

  /// No description provided for @modelPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Model: {value}'**
  String modelPrefixLabel(String value);

  /// No description provided for @serialPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'S/N: {value}'**
  String serialPrefixLabel(String value);

  /// No description provided for @retiredSuffixLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} (retired)'**
  String retiredSuffixLabel(String name);

  ///
  ///
  /// In en, this message translates to:
  /// **'Add equipment'**
  String get addEquipmentTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPinLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetailsTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get sectionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'No section'**
  String get noSectionOption;

  ///
  ///
  /// In en, this message translates to:
  /// **' (inactive)'**
  String get inactiveParenSuffix;

  ///
  ///
  /// In en, this message translates to:
  /// **'No specific team'**
  String get noSpecificTeamOption;

  ///
  ///
  /// In en, this message translates to:
  /// **'No sections set up at this venue yet - add one under Department Management first.'**
  String get noSectionsSetupText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reports to'**
  String get reportsToFieldLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSetOption;

  ///
  ///
  /// In en, this message translates to:
  /// **'Deactivate Staff Member'**
  String get deactivateStaffMemberTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get staffManagementTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get addStaffTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Bulk Import'**
  String get bulkImportTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'(deactivated)'**
  String get deactivatedSuffixLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActionsTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Change Tier'**
  String get changeTierMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Change Section'**
  String get changeSectionMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Assign Supervision'**
  String get assignSupervisionMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reports To'**
  String get reportsToMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reset PIN'**
  String get resetPinMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Training Records'**
  String get trainingRecordsMenuItem;

  /// No description provided for @unknownUserIdFallback.
  ///
  /// In en, this message translates to:
  /// **'user #{id}'**
  String unknownUserIdFallback(String id);

  /// No description provided for @resetPinForUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN - {name}'**
  String resetPinForUserTitle(String name);

  /// No description provided for @pinResetForUserMessage.
  ///
  /// In en, this message translates to:
  /// **'PIN reset for {name}'**
  String pinResetForUserMessage(String name);

  /// No description provided for @changeRoleTierTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Role Tier - {name}'**
  String changeRoleTierTitle(String name);

  /// No description provided for @changeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Section - {name}'**
  String changeSectionTitle(String name);

  /// No description provided for @assignSupervisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Supervision - {name}'**
  String assignSupervisionTitle(String name);

  /// No description provided for @supervisionScopeUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Supervision scope updated for {name}'**
  String supervisionScopeUpdatedMessage(String name);

  /// No description provided for @reportsToTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports To - {name}'**
  String reportsToTitle(String name);

  /// No description provided for @deactivateStaffConfirmText.
  ///
  /// In en, this message translates to:
  /// **'{name} will no longer be able to log in. Their active task assignments will be unassigned. Their submission history is not affected. This can be reversed later.'**
  String deactivateStaffConfirmText(String name);

  /// No description provided for @reportsToSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reports to {name}'**
  String reportsToSubtitle(String name);

  /// No description provided for @deactivatedOnByLabel.
  ///
  /// In en, this message translates to:
  /// **'on {date} by {name}'**
  String deactivatedOnByLabel(String date, String name);

  ///
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'One brand identity, shared company-wide - applies to every venue, not per-site.'**
  String get brandIdentityIntro;

  ///
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyNameLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Company logo'**
  String get companyLogoLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Choose Logo'**
  String get chooseLogoButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Change Logo'**
  String get changeLogoButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Brand colour'**
  String get brandColourLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom hex colour'**
  String get customHexColourLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enter a valid hex colour'**
  String get enterValidHexColourError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Contact phone'**
  String get contactPhoneLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get contactEmailLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingEllipsisLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Save Branding'**
  String get saveBrandingButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Branding saved'**
  String get brandingSavedMessage;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customSwatchTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Staff Shift/Roster (+£6-£10/branch/month)'**
  String get rosterAddonTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Let staff see and claim open shifts themselves - a manager posts shifts, staff pick them up. £6/month per branch under 10 staff, £10/month for 10 or more.'**
  String get rosterAddonSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Enable Roster?'**
  String get enableRosterTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear demo data?'**
  String get clearDemoDataTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes every demo staff member, branch, and department, and signs you out. This can\'t be undone.'**
  String get clearDemoDataConfirmText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear everything'**
  String get clearEverythingButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear Demo Data'**
  String get clearDemoDataCardTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove every demo staff member, branch, and department so you can set up your own from scratch.'**
  String get clearDemoDataCardBody;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear demo data'**
  String get clearDemoDataButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Temperature unit'**
  String get temperatureUnitLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsiusLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheitLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Ocean Teal'**
  String get presetColorOceanTeal;

  ///
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get presetColorNavy;

  ///
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get presetColorIndigo;

  ///
  ///
  /// In en, this message translates to:
  /// **'Slate'**
  String get presetColorSlate;

  ///
  ///
  /// In en, this message translates to:
  /// **'Plum'**
  String get presetColorPlum;

  ///
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get presetColorForest;

  ///
  ///
  /// In en, this message translates to:
  /// **'Umber'**
  String get presetColorUmber;

  ///
  ///
  /// In en, this message translates to:
  /// **'Charcoal'**
  String get presetColorCharcoal;

  /// No description provided for @couldNotGetPriceError.
  ///
  /// In en, this message translates to:
  /// **'Could not get a price: {error}'**
  String couldNotGetPriceError(String error);

  /// No description provided for @enableRosterConfirmText.
  ///
  /// In en, this message translates to:
  /// **'Based on your current staff numbers, this will add {amount} to your monthly Direct Debit.'**
  String enableRosterConfirmText(String amount);

  ///
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departmentLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'No department'**
  String get noDepartmentOption;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove anyway'**
  String get removeAnywayButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Branch Team Structure'**
  String get branchTeamStructureTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No staff at this branch yet.'**
  String get noStaffAtBranchText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Change manager'**
  String get changeManagerMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Move department/team'**
  String get moveDepartmentMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Edit job title'**
  String get editJobTitleMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Remove from this branch'**
  String get removeFromBranchMenuItem;

  /// No description provided for @changeManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Change manager - {name}'**
  String changeManagerTitle(String name);

  /// No description provided for @moveDepartmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Move department/team - {name}'**
  String moveDepartmentTitle(String name);

  /// No description provided for @changeTierTitle2.
  ///
  /// In en, this message translates to:
  /// **'Change tier - {name}'**
  String changeTierTitle2(String name);

  /// No description provided for @editJobTitleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit job title - {name}'**
  String editJobTitleTitle(String name);

  /// No description provided for @removeFromBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from this branch'**
  String removeFromBranchTitle(String name);

  /// No description provided for @removeFromBranchConfirmText.
  ///
  /// In en, this message translates to:
  /// **'{name} will no longer be able to log in. This can be reversed later.'**
  String removeFromBranchConfirmText(String name);

  /// No description provided for @reportsWillBeUnassignedText.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} person} other{{count} people}} currently report to {name}: {names}. Removing {name} will leave them unassigned until reassigned.'**
  String reportsWillBeUnassignedText(int count, String name, String names);

  /// No description provided for @reassignToManagerLabel.
  ///
  /// In en, this message translates to:
  /// **'Reassign them to {name}\'s own manager instead'**
  String reassignToManagerLabel(String name);

  /// No description provided for @reportsCountBadge.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} report} other{{count} reports}}'**
  String reportsCountBadge(int count);

  ///
  ///
  /// In en, this message translates to:
  /// **'Regional Manager assigned'**
  String get regionalManagerAssignedTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No organisation on this session.'**
  String get noOrganisationOnSessionError;

  ///
  ///
  /// In en, this message translates to:
  /// **'New region name'**
  String get newRegionNameTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename region'**
  String get renameRegionTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rename venue'**
  String get renameVenueTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'New venue name'**
  String get newVenueNameTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reset password?'**
  String get resetPasswordQuestionTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get passwordResetTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Give this person their new temporary password.'**
  String get giveNewTempPasswordText;

  ///
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get organisationTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Head Office'**
  String get headOfficeLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Region'**
  String get addRegionMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Venue (no region)'**
  String get addVenueNoRegionMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Venues (no region)'**
  String get venuesNoRegionLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTooltip;

  ///
  ///
  /// In en, this message translates to:
  /// **'Add Venue'**
  String get addVenueMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Assign Regional Manager'**
  String get assignRegionalManagerMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reassign Regional Manager'**
  String get reassignRegionalManagerMenuItem;

  ///
  ///
  /// In en, this message translates to:
  /// **'No regional manager yet'**
  String get noRegionalManagerYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'No venues in this region yet.'**
  String get noVenuesInRegionText;

  ///
  ///
  /// In en, this message translates to:
  /// **'No venue manager yet'**
  String get noVenueManagerYetText;

  /// No description provided for @assignRegionalManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Regional Manager - {region}'**
  String assignRegionalManagerTitle(String region);

  /// No description provided for @accountLiveGiveSignInDetails.
  ///
  /// In en, this message translates to:
  /// **'The account is live now. Give {name} their sign-in details - they use Leadership Access.'**
  String accountLiveGiveSignInDetails(String name);

  /// No description provided for @emailColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String emailColonLabel(String email);

  /// No description provided for @temporaryPasswordColonLabel.
  ///
  /// In en, this message translates to:
  /// **'Temporary password: {password}'**
  String temporaryPasswordColonLabel(String password);

  /// No description provided for @resetPasswordConfirmText.
  ///
  /// In en, this message translates to:
  /// **'This immediately invalidates {name}\'s current password. You\'ll get a new temporary password to pass along.'**
  String resetPasswordConfirmText(String name);

  /// No description provided for @venueManagerSuffixLabel.
  ///
  /// In en, this message translates to:
  /// **'{name}  ·  Venue Manager'**
  String venueManagerSuffixLabel(String name);

  ///
  ///
  /// In en, this message translates to:
  /// **'No signed-in user found.'**
  String get noSignedInUserError;

  ///
  ///
  /// In en, this message translates to:
  /// **'Custom category title'**
  String get customCategoryTitleLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Approval / due-diligence note (optional)'**
  String get approvalNoteLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Supplier Management'**
  String get supplierManagementTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'No suppliers added yet.'**
  String get noSuppliersAddedYetText;

  ///
  ///
  /// In en, this message translates to:
  /// **'(inactive)'**
  String get inactiveStandaloneLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Change Approval Status'**
  String get changeApprovalStatusMenuItem;

  /// No description provided for @editDetailsForSupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Details - {name}'**
  String editDetailsForSupplierTitle(String name);

  /// No description provided for @changeApprovalStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Approval Status - {name}'**
  String changeApprovalStatusTitle(String name);
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
