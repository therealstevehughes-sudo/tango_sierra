// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get personalSection => 'व्यक्तिगत';

  @override
  String get languageSettingTitle => 'भाषा';

  @override
  String get languageSettingSubtitle =>
      'वह भाषा चुनें जिसमें आप VenuRite इस्तेमाल करना चाहते हैं.';

  @override
  String get languageUpdated => 'भाषा अपडेट हो गई.';

  @override
  String get chooseLanguageTitle => 'भाषा चुनें';

  @override
  String get languageDeviceScope =>
      'स्टाफ के साइन इन करने से पहले इस डिवाइस पर यही भाषा इस्तेमाल होगी.';

  @override
  String languageUserScope(String name) {
    return '$name के लिए सेव किया गया.';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get done => 'हो गया';

  @override
  String get login => 'लॉग इन';

  @override
  String get back => 'वापस';

  @override
  String get enterPin => 'PIN दर्ज करें';

  @override
  String get leadershipAccess => 'प्रबंधन की पहुंच';

  @override
  String get notOnThisList =>
      'इस सूची में नहीं हैं? दूसरे तरीके से साइन इन करें';

  @override
  String errorLoadingStaff(String error) {
    return 'स्टाफ लोड करते समय त्रुटि: $error';
  }

  @override
  String get incorrectPin => 'गलत PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'बहुत अधिक गलत प्रयास. $minutes मिनट बाद फिर कोशिश करें.';
  }

  @override
  String get accountNotFound => 'खाता नहीं मिला';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get kitchenComplianceDoneRight => 'किचन अनुपालन, साफ और भरोसेमंद';

  @override
  String get valuePointEhoReady =>
      'स्वास्थ्य निरीक्षण के लिए हमेशा तैयार - आखिरी समय की भागदौड़ नहीं, रियल-टाइम रिकॉर्ड';

  @override
  String get valuePointHonestRecords =>
      'इस तरह बनाया गया कि परिणामों से छेड़छाड़ न हो सके - हर जांच का भरोसेमंद रिकॉर्ड';

  @override
  String get valuePointAuditExport =>
      'एक टैप में ऑडिट एक्सपोर्ट - निरीक्षक को तुरंत असली रिकॉर्ड दें';

  @override
  String get howGetStarted => 'आप कैसे शुरू करना चाहेंगे?';

  @override
  String get setUpMyBusiness => 'मेरा स्थान सेट अप करें';

  @override
  String get teamAlreadyUses => 'मेरी टीम पहले से VenuRite इस्तेमाल करती है';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? साइन इन करें';

  @override
  String get needHelpContact => 'मदद चाहिए? VenuRite से संपर्क करें';

  @override
  String get signInAnotherWay => 'दूसरे तरीके से साइन इन करें';

  @override
  String get deviceNotSetUp => 'यह टैबलेट अभी सेट अप नहीं है';

  @override
  String get askManagerSetupCode =>
      'इस स्थान के सेटअप कोड के लिए मैनेजर से पूछें.';

  @override
  String get setupCode => 'सेटअप कोड';

  @override
  String get connectTablet => 'इस टैबलेट को कनेक्ट करें';

  @override
  String get couldNotReachServer => 'सर्वर से संपर्क नहीं हो सका';

  @override
  String get stillStuckSetupCode =>
      'अभी भी आगे नहीं बढ़ पा रहे? मैनेजर इसे Settings -> Venue Details में ढूंढ सकता है.';

  @override
  String get askQuestionTitle => 'सवाल पूछें';

  @override
  String get askQuestionLabel => 'आप क्या जानना चाहते हैं?';

  @override
  String get askQuestionHint => 'जैसे: फ्रिज का तापमान कितना होना चाहिए?';

  @override
  String get ask => 'पूछें';

  @override
  String get aiQuestionLimitReached =>
      'इस महीने AI सवालों की सीमा पूरी हो गई है';

  @override
  String get home => 'होम';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get endShift => 'शिफ्ट समाप्त करें';

  @override
  String get workerHubPrompt => 'आप क्या करना चाहते हैं?';

  @override
  String get myScheduledTasks => 'मेरे तय किए गए काम';

  @override
  String get doAdHocTask => 'एक ad-hoc काम करें';

  @override
  String get logSomethingHappened => 'अभी हुई बात दर्ज करें';

  @override
  String get claimShift => 'शिफ्ट लें';

  @override
  String get requestDayOff => 'छुट्टी का दिन मांगें';

  @override
  String get thingsIReported => 'मेरी रिपोर्ट की गई बातें';

  @override
  String shiftWelcome(String firstName) {
    return 'स्वागत है, $firstName';
  }

  @override
  String get shiftPlanIntro => 'आपकी शिफ्ट के लिए ये काम हैं:';

  @override
  String get startOfShift => 'शिफ्ट की शुरुआत';

  @override
  String get duringYourShift => 'आपकी शिफ्ट के दौरान';

  @override
  String get endOfShift => 'शिफ्ट का अंत';

  @override
  String get shiftHandoverTitle => 'शिफ्ट हैंडओवर';

  @override
  String get shiftHandoverNeedsAttention =>
      'इस पर अभी भी अगली शिफ्ट का ध्यान चाहिए';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get openIssues => 'खुली समस्याएं';

  @override
  String get flaggedEquipment => 'चिह्नित उपकरण';

  @override
  String get notYetDoneToday => 'आज अभी तक नहीं हुआ';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get uploadFromFiles => 'फ़ाइलों से अपलोड करें';

  @override
  String get seeAllTasksTooltip => 'सभी कार्य देखें';

  @override
  String get leaveBeforeFinishingTitle => 'पूरा करने से पहले बाहर जाएं?';

  @override
  String get leaveBeforeFinishingBody =>
      'कुछ जांचें पूरी नहीं हुई हैं। इसे रिकॉर्ड किया जाएगा। आप इस शिफ्ट में कभी भी लौटकर पूरा कर सकते हैं।';

  @override
  String get enterValue => 'मान दर्ज करें';

  @override
  String enterValueWithUnit(String unit) {
    return 'मान दर्ज करें ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'सुरक्षित सीमा: $min - $max';
  }

  @override
  String get errorNumericRequired => 'एक मान्य संख्यात्मक मान आवश्यक है';

  @override
  String get errorSelectOption => 'कृपया एक विकल्प चुनें';

  @override
  String get errorNotesRequired => 'टिप्पणी आवश्यक है';

  @override
  String get errorPhotoRequired => 'फ़ोटो आवश्यक है';

  @override
  String get errorCorrectiveActionRequired =>
      'चुनें कि सुधारात्मक कार्रवाई कैसे की गई';

  @override
  String get myTasksTitle => 'मेरे कार्य';

  @override
  String get taskTitleFallback => 'कार्य';

  @override
  String get noTasksAssigned => 'अभी तक कोई कार्य नहीं सौंपा गया है।';

  @override
  String get overdueLabel => 'बकाया';

  @override
  String overdueSinceLabel(String date) {
    return '$date से बकाया';
  }

  @override
  String get withinRangePass => 'सीमा के भीतर - पास';

  @override
  String get outsideRangeFail => 'सीमा से बाहर - फेल';

  @override
  String get selectOptionLabel => 'एक विकल्प चुनें';

  @override
  String get notesLabel => 'टिप्पणियाँ';

  @override
  String get spotCheckPhotoNotice =>
      'आज की औचक जांच - यह पुष्टि करने के लिए इस बार फ़ोटो की आवश्यकता है कि यह वास्तव में किया गया था।';

  @override
  String get photoAdded => 'फ़ोटो जोड़ी गई';

  @override
  String get addPhoto => 'फ़ोटो जोड़ें';

  @override
  String get passLabel => 'पास';

  @override
  String get failLabel => 'फेल';

  @override
  String get readingOutsideSafeRange => 'रीडिंग सुरक्षित सीमा से बाहर है';

  @override
  String get hereIsWhatToDo => 'यहाँ बताया गया है कि क्या करना है:';

  @override
  String get correctiveActionRequired => 'सुधारात्मक कार्रवाई आवश्यक है';

  @override
  String get iFixedIt => 'मैंने इसे ठीक कर दिया';

  @override
  String get reportedToManager => 'प्रबंधक को सूचित किया गया';

  @override
  String get correctiveActionNoteLabel => 'आपने क्या किया? (वैकल्पिक)';

  @override
  String get managerWillBeNotified => 'आपके प्रबंधक को सूचित किया जाएगा।';

  @override
  String get submitButton => 'सबमिट करें';

  @override
  String availableFrom(String time) {
    return '$time से उपलब्ध';
  }

  @override
  String get backToList => 'सूची पर वापस जाएं';

  @override
  String get skipComesBackLater => 'छोड़ें - बाद में वापस आएगा';

  @override
  String get noAdHocTaskTypesSetUp =>
      'इस साइट पर अभी तक कोई तदर्थ कार्य प्रकार सेट नहीं किया गया है - पहले किसी प्रबंधक से डिलीवरी-जांच या तापमान-जांच टेम्पलेट असाइन करने के लिए कहें।';

  @override
  String get whatKindOfThing => 'आप किस तरह का काम कर रहे हैं?';

  @override
  String get notesOptionalLabel => 'टिप्पणियाँ (वैकल्पिक)';

  @override
  String get noteOptionalLabel => 'टिप्पणी (वैकल्पिक)';

  @override
  String get temperatureCelsiusLabel => 'तापमान (°C)';

  @override
  String get submitLabel => 'सबमिट करें';

  @override
  String get logReadingButton => 'रीडिंग दर्ज करें';

  @override
  String get loggedThanksMessage =>
      'दर्ज किया गया। इसे रिकॉर्ड करने के लिए धन्यवाद।';

  @override
  String get logAnotherAdHocTask => 'एक और तदर्थ कार्य दर्ज करें';

  @override
  String get deliveryCheckLabel => 'डिलीवरी जांच';

  @override
  String get temperatureCheckLabel => 'तापमान जांच';

  @override
  String get sessionSummaryTitle => 'सत्र सारांश';

  @override
  String tasksCompletedCount(int count) {
    return 'पूर्ण किए गए कार्य: $count';
  }

  @override
  String get passedLabel => 'पास';

  @override
  String get failedLabel => 'फेल';

  @override
  String get triggersFailedTasks => 'ट्रिगर / फेल कार्य';

  @override
  String get yourReliability => 'आपकी विश्वसनीयता';

  @override
  String get reliabilityExplanation =>
      'पिछले 30 दिन - समय पर पूरी और दर्ज की गई जांचें। दर्ज किया गया फेल दर्ज किए गए पास के समान ही गिना जाता है: यह केवल यह मापता है कि आपने जांच की या नहीं और कब की।';

  @override
  String completedPercentChip(int percent) {
    return '$percent% पूर्ण';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% समय पर';
  }

  @override
  String get sendSummaryToManager =>
      'यह सारांश किसी प्रबंधक को भेजें (वैकल्पिक)';

  @override
  String get noManagersSetUp => 'अभी तक कोई प्रबंधक सेट नहीं किया गया है।';

  @override
  String get managerLabel => 'प्रबंधक';

  @override
  String get sentLabel => 'भेजा गया';

  @override
  String get sendLabel => 'भेजें';

  @override
  String get leaveNoteForNextShift =>
      'अगली शिफ्ट के लिए एक टिप्पणी छोड़ें (वैकल्पिक)';

  @override
  String get handoverNoteLabel => 'हैंडओवर टिप्पणी';

  @override
  String get doneLabel => 'पूर्ण';

  @override
  String get supplierOptionalLabel => 'आपूर्तिकर्ता (वैकल्पिक)';

  @override
  String supplierWarningRecorded(String status) {
    return 'यह आपूर्तिकर्ता $status के रूप में चिह्नित है - फिर भी जांच दर्ज की जाएगी।';
  }

  @override
  String get reportProblemWithDelivery =>
      'इस डिलीवरी में समस्या की रिपोर्ट करें';

  @override
  String get temperatureOnArrivalLabel => 'आगमन पर तापमान (°C, वैकल्पिक)';

  @override
  String get problemsTickAnyApply => 'समस्याएं (जो भी लागू हों उन्हें चुनें)';

  @override
  String get shortDeliveryLabel => 'कम डिलीवरी';

  @override
  String get damagedStockLabel => 'क्षतिग्रस्त सामान';

  @override
  String get lateDeliveryLabel => 'देर से डिलीवरी';

  @override
  String get qualityProblemLabel => 'गुणवत्ता की समस्या';

  @override
  String get outcomeLabel => 'परिणाम';

  @override
  String get acceptedLabel => 'स्वीकृत';

  @override
  String get rejectedLabel => 'अस्वीकृत';

  @override
  String get partiallyAcceptedLabel => 'आंशिक रूप से स्वीकृत';

  @override
  String get noCameraFound => 'इस डिवाइस पर कोई कैमरा नहीं मिला।';

  @override
  String couldNotStartCamera(String error) {
    return 'कैमरा शुरू नहीं किया जा सका: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'कैमरा स्विच नहीं किया जा सका: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'फ़ोटो कैप्चर नहीं की जा सकी: $error';
  }

  @override
  String get switchCameraTooltip => 'कैमरा स्विच करें';

  @override
  String get allTasksTitle => 'सभी कार्य';

  @override
  String get otherSegmentLabel => 'अन्य';

  @override
  String get reorderTasksTitle => 'कार्यों को पुनः क्रमबद्ध करें';

  @override
  String get ungroupedLabel => 'अवर्गीकृत';

  @override
  String get taskOrderSaved => 'कार्य क्रम सहेज लिया गया।';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'कार्य क्रम सहेजा नहीं जा सका: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'अभी तक कोई वेन्यू नहीं चुना गया है। कार्यों को पुनः क्रमबद्ध करने से पहले वेन्यू विवरण से एक सक्रिय वेन्यू सेट करें।';

  @override
  String get noActiveTasksToReorder =>
      'अभी तक पुनः क्रमबद्ध करने के लिए कोई सक्रिय कार्य नहीं हैं। पहले कार्य असाइन करें, फिर उनका क्रम चुनने के लिए यहां लौटें।';

  @override
  String get savingEllipsis => 'सहेजा जा रहा है…';

  @override
  String get saveOrderLabel => 'क्रम सहेजें';

  @override
  String get moveUpTooltip => 'ऊपर ले जाएं';

  @override
  String get moveDownTooltip => 'नीचे ले जाएं';

  @override
  String get accountRestrictedTitle => 'खाता प्रतिबंधित';

  @override
  String get accountRestrictedBody =>
      'नई जांचें सहेजी जाने से पहले इस संगठन के डायरेक्ट डेबिट पर ध्यान देने की आवश्यकता है। आपका काम खोया नहीं है - कृपया किसी प्रबंधक या डायरेक्टर को बिलिंग सुलझाने के लिए बताएं, फिर पुनः प्रयास करें।';

  @override
  String get okLabel => 'ठीक है';

  @override
  String get troubleshootingTitle => 'समस्या निवारण';

  @override
  String get faqTitle => 'सामान्य प्रश्न';

  @override
  String get helpTitle => 'सहायता';

  @override
  String get couldntReachAssistant => 'सहायक से संपर्क नहीं हो सका';

  @override
  String get aiOfflineBody =>
      'AI सहायक अभी उपलब्ध नहीं है - यह आपका कनेक्शन हो सकता है, या सेवा अस्थायी रूप से बंद हो सकती है। इस बीच, नीचे दिए गए सामान्य प्रश्न और समस्या निवारण सबसे सामान्य सवालों को कवर करते हैं, या सीधे VenuRite से संपर्क करें।';

  @override
  String get askQuestionSubtitle => 'सरल भाषा में सीधा जवाब पाएं';

  @override
  String get faqSubtitle => 'सामान्य प्रश्न, उत्तर सहित';

  @override
  String get troubleshootingSubtitle =>
      'कुछ काम नहीं कर रहा? यहां से शुरू करें';

  @override
  String get contactVenuriteTitle => 'VenuRite से संपर्क करें';

  @override
  String get contactVenuriteSubtitle => 'सीधे संपर्क करें';

  @override
  String get topTierViewTitle => 'शीर्ष-स्तरीय दृश्य';

  @override
  String get everythingsDone => 'सब कुछ हो गया। बहुत बढ़िया काम।';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कार्य पूरे नहीं हुए:',
      one: '1 कार्य पूरा नहीं हुआ:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'शिफ्ट पर वापस जाएं';

  @override
  String get finishShiftLabel => 'शिफ्ट समाप्त करें';

  @override
  String get ehoAuditExportTitle => 'EHO / ऑडिट एक्सपोर्ट';

  @override
  String get ehoExportDescription =>
      'चुनी गई तिथि सीमा के लिए इस वेन्यू के अनुपालन रिकॉर्ड का एक PDF बनाता है।';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'तिथि सीमा चुनें';

  @override
  String get tapToChooseDates =>
      'प्रारंभ और समाप्ति तिथि चुनने के लिए टैप करें।';

  @override
  String get includeFullDetailedLog => 'पूर्ण विस्तृत लॉग शामिल करें';

  @override
  String get fullLogSubtitle =>
      'डिफ़ॉल्ट रूप से बंद - ऊपर दिया गया सारांश और अपवाद वही है जिसे एक निरीक्षक वास्तव में समीक्षा करता है; यह हर व्यक्तिगत जांच को जोड़ता है।';

  @override
  String get generateLabel => 'बनाएं';

  @override
  String get exportFailedTitle => 'एक्सपोर्ट विफल';

  @override
  String exportFailedBody(String error) {
    return 'एक्सपोर्ट विफल: $error';
  }

  @override
  String get exportCreatedTitle => 'एक्सपोर्ट बनाया गया';

  @override
  String savedToLabel(String path) {
    return 'यहां सहेजा गया:\n$path';
  }

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get noVenueFound => 'कोई वेन्यू नहीं मिला।';

  @override
  String get allPermittedVenuesLast30Days => 'सभी अनुमत वेन्यू · पिछले 30 दिन';

  @override
  String get last30Days => 'पिछले 30 दिन';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फेल (30 दिन)',
      one: '1 फेल (30 दिन)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count बकाया';
  }

  @override
  String get venuesSectionTitle => 'वेन्यू';

  @override
  String get teamSectionTitle => 'टीम';

  @override
  String get noStaffAtVenue => 'इस वेन्यू पर अभी तक कोई स्टाफ नहीं है।';

  @override
  String get notEnoughDataYet => 'पर्याप्त डेटा नहीं';

  @override
  String get venueFallbackLabel => 'वेन्यू';

  @override
  String get trendsTitle => 'रुझान';

  @override
  String get trendNeedsHistory =>
      'रुझान डेटा: रुझान दिखाने के लिए कम से कम 4 सप्ताह का इतिहास आवश्यक है।';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'प्रति वेन्यू साप्ताहिक पूर्णता · पिछले $weeks सप्ताह';
  }

  @override
  String get allVenuesCombined => 'सभी वेन्यू संयुक्त';

  @override
  String get noVenuesYet => 'अभी तक कोई वेन्यू नहीं।';

  @override
  String get otherVenuesLabel => 'अन्य वेन्यू';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$total में से $completed जांच दर्ज की गईं';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'क्षेत्र #$id';
  }

  @override
  String get dashboardOverviewTitle => 'डैशबोर्ड अवलोकन';

  @override
  String get gradedBarsOnTooltip => 'प्रति-कर्मचारी ग्रेडेड बार: चालू';

  @override
  String get gradedBarsOffTooltip => 'प्रति-कर्मचारी ग्रेडेड बार: बंद';

  @override
  String get noBranchesToShow => 'अभी तक दिखाने के लिए कोई शाखा नहीं है।';

  @override
  String get supervisorNoScopeMessage =>
      'आपको अभी तक किसी अनुभाग या टीम को नहीं सौंपा गया है - इस डैशबोर्ड में कुछ दिखने से पहले किसी प्रबंधक से स्टाफ प्रबंधन में यह सेट करने के लिए कहें।';

  @override
  String get individualViewNotice =>
      'व्यक्तिगत दृश्य - जोखिम निगरानी के लिए, लीग तालिका नहीं।';

  @override
  String get branchLabel => 'शाखा';

  @override
  String get allBranchesLabel => 'सभी शाखाएं';

  @override
  String get yourSectionLabel => 'आपका अनुभाग';

  @override
  String get noneAssignedLabel => 'कोई नहीं सौंपा गया';

  @override
  String get areaLabel => 'क्षेत्र';

  @override
  String get allAreasLabel => 'सभी क्षेत्र';

  @override
  String get employeeLabel => 'कर्मचारी';

  @override
  String get allEmployeesLabel => 'सभी कर्मचारी';

  @override
  String get monthLabel => 'महीना';

  @override
  String get weekLabel => 'सप्ताह';

  @override
  String get dayLabel => 'दिन';

  @override
  String get noTaskActivityPeriod => 'इस अवधि में कोई कार्य गतिविधि नहीं।';

  @override
  String get taskOverviewTitle => 'कार्य अवलोकन';

  @override
  String get incidentsTitle => 'घटनाएं';

  @override
  String get noIncidentsPeriod => 'इस अवधि में कोई घटना दर्ज नहीं की गई।';

  @override
  String urgentCountLabel(int count) {
    return '$count तत्काल';
  }

  @override
  String get tapForDetailsHint =>
      'विवरण के लिए किसी रंग खंड या लीजेंड प्रविष्टि पर टैप करें';

  @override
  String get employeeFallbackLabel => 'कर्मचारी';

  @override
  String get plainLookupNotice =>
      'यह केवल एक सामान्य खोज है, स्कोर नहीं - पूर्णता रंग और समस्या टैग यहां कभी भी प्रति व्यक्ति ग्रेड नहीं किए जाते।';

  @override
  String tasksCompletedCountParens(int count) {
    return 'पूर्ण किए गए कार्य ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'उठाई गई समस्याएं ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'समय पर पूरा (कोई समस्या नहीं)';

  @override
  String get doneOnTimeIssuesLogged => 'समय पर पूरा (समस्याएं दर्ज)';

  @override
  String get doneEarlyLateNoIssues => 'जल्दी/देरी से पूरा (कोई समस्या नहीं)';

  @override
  String get doneEarlyLateIssuesLogged => 'जल्दी/देरी से पूरा (समस्याएं दर्ज)';

  @override
  String get notDoneLabel => 'पूरा नहीं हुआ';

  @override
  String get resolvedLabel => 'हल किया गया';

  @override
  String get unresolvedLabel => 'अनसुलझा';

  @override
  String get escalatedLabel => 'आगे बढ़ाया गया';

  @override
  String get urgentLabel => 'तत्काल';

  @override
  String get signInFailed => 'साइन-इन विफल';

  @override
  String get twoFactorRequiredNoFactor =>
      'टू-फैक्टर सत्यापन आवश्यक है लेकिन कोई फैक्टर नहीं मिला।';

  @override
  String get couldNotVerifyCode => 'उस कोड को सत्यापित नहीं किया जा सका';

  @override
  String get codeDidntWork => 'वह कोड काम नहीं किया।';

  @override
  String get accountNotLinkedToStaff =>
      'यह खाता अभी तक किसी स्टाफ प्रोफ़ाइल से जुड़ा नहीं है - किसी व्यवस्थापक से संपर्क करें।';

  @override
  String get resetPasswordTitle => 'पासवर्ड रीसेट करें';

  @override
  String get enterEmailForResetCode =>
      'अपना ईमेल दर्ज करें और हम आपको पासवर्ड रीसेट करने के लिए एक कोड भेजेंगे।';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get sendCodeButton => 'कोड भेजें';

  @override
  String get backToSignIn => 'साइन इन पर वापस जाएं';

  @override
  String sentCodeToEmail(String email) {
    return 'हमने $email पर एक कोड भेजा है। इसे नीचे अपने नए पासवर्ड के साथ दर्ज करें।';
  }

  @override
  String get sixDigitCodeLabel => '6-अंकीय कोड';

  @override
  String get newPasswordLabel => 'नया पासवर्ड';

  @override
  String get resetPasswordButton => 'पासवर्ड रीसेट करें';

  @override
  String get twoFactorVerificationTitle => 'टू-फैक्टर सत्यापन';

  @override
  String get enterAuthenticatorCode => 'अपने ऑथेंटिकेटर ऐप से कोड दर्ज करें।';

  @override
  String get verifyButton => 'सत्यापित करें';

  @override
  String get regionalDirectorSignIn => 'क्षेत्रीय और डायरेक्टर साइन-इन।';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get signInButton => 'साइन इन करें';

  @override
  String get forgotPasswordLink => 'पासवर्ड भूल गए?';

  @override
  String get noBackendConfiguredPin =>
      'इस इंस्टॉलेशन के लिए कोई बैकएंड कॉन्फ़िगर नहीं है - बाकी सभी की तरह PIN से साइन इन करें।';

  @override
  String get noDirectorRegionalAccounts =>
      'इस डिवाइस पर कोई डायरेक्टर/क्षेत्रीय खाता नहीं है।';

  @override
  String get directorLabel => 'डायरेक्टर';

  @override
  String get regionalManagerLabel => 'क्षेत्रीय प्रबंधक';

  @override
  String get whoAreYouTitle => 'आप कौन हैं?';

  @override
  String get searchLabel => 'खोजें';

  @override
  String get noMatchesLabel => 'कोई मेल नहीं मिला';

  @override
  String get leadershipSectionTitle => 'नेतृत्व';

  @override
  String get kitchenStaffSectionTitle => 'रसोई स्टाफ';

  @override
  String get chooseASectionTitle => 'एक अनुभाग चुनें';

  @override
  String get unassignedLabel => 'अनसाइन किया गया';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोग',
      one: '$count व्यक्ति',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get welcomeToVenurite => 'VenuRite में आपका स्वागत है';

  @override
  String get helpAssistantTooltip => 'सहायता और सहायक';

  @override
  String get couldntLoadScreen => 'इस स्क्रीन को लोड नहीं किया जा सका।';

  @override
  String get retryLabel => 'पुनः प्रयास करें';

  @override
  String get microphonePermissionDenied =>
      'माइक्रोफ़ोन की अनुमति अस्वीकार कर दी गई।';

  @override
  String get couldntRecordTryAgain =>
      'रिकॉर्ड नहीं किया जा सका - पुनः प्रयास करें।';

  @override
  String get couldntTranscribe => 'उसे ट्रांसक्राइब नहीं किया जा सका।';

  @override
  String get couldntReachTranscriptionService =>
      'ट्रांसक्रिप्शन सेवा तक नहीं पहुंचा जा सका।';

  @override
  String get dictateANote => 'एक टिप्पणी बोलें';

  @override
  String get stoppingSoonTapToStop =>
      'जल्द ही बंद होगा - अभी रोकने के लिए टैप करें';

  @override
  String get stopLabel => 'रोकें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अलर्ट',
      one: '1 अलर्ट',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count अस्वीकृत नहीं';
  }

  @override
  String get allAcknowledgedLabel => 'सभी स्वीकृत';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'बकाया - $minutes मिनट से अस्वीकृत';
  }

  @override
  String get escalatedToTopTier => 'शीर्ष स्तर पर भेजा गया';

  @override
  String get acknowledgeLabel => 'स्वीकार करें';

  @override
  String get nothingInCategory => 'इस श्रेणी में कुछ भी नहीं है।';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'नेतृत्व अवलोकन';

  @override
  String get photoEvidence => 'फोटो साक्ष्य';

  @override
  String get staffManagement => 'स्टाफ प्रबंधन';

  @override
  String get addTeamMember => 'टीम सदस्य जोड़ें';

  @override
  String get shiftLog => 'शिफ्ट लॉग';

  @override
  String get branchTeamStructure => 'शाखा टीम संरचना';

  @override
  String get departmentManagement => 'विभाग प्रबंधन';

  @override
  String get rosterBoard => 'रोस्टर बोर्ड';

  @override
  String get claimShifts => 'शिफ्ट का दावा करें';

  @override
  String get requestADayOff => 'छुट्टी के लिए अनुरोध करें';

  @override
  String get shiftFairnessReview => 'शिफ्ट निष्पक्षता समीक्षा';

  @override
  String get venueDetails => 'वेन्यू विवरण';

  @override
  String get assignTasks => 'कार्य असाइन करें';

  @override
  String get taskPresets => 'कार्य प्रीसेट';

  @override
  String get supplierManagement => 'आपूर्तिकर्ता प्रबंधन';

  @override
  String get serviceProviders => 'सेवा प्रदाता';

  @override
  String get notificationRules => 'सूचना नियम';

  @override
  String get documentCentre => 'दस्तावेज़ केंद्र';

  @override
  String get setupWizard => 'सेटअप विज़ार्ड';

  @override
  String get organisationLabel => 'संगठन';

  @override
  String get branchesLabel => 'शाखाएं';

  @override
  String get homeLabel => 'होम';

  @override
  String get oversightLabel => 'निगरानी';

  @override
  String get problemsAndIssues => 'समस्याएं और मुद्दे';

  @override
  String get twoFactorAuthentication => 'टू-फैक्टर प्रमाणीकरण';

  @override
  String get backUpNow => 'अभी बैकअप लें';

  @override
  String get dailySection => 'दैनिक';

  @override
  String get insightsSection => 'अंतर्दृष्टि';

  @override
  String get peopleSection => 'लोग';

  @override
  String get rosterSection => 'रोस्टर';

  @override
  String get venueSetupSection => 'वेन्यू सेटअप';

  @override
  String get companySection => 'कंपनी';

  @override
  String get accountSection => 'खाता';

  @override
  String get settingsLabel => 'सेटिंग्स';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% आज पूर्ण';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count सक्रिय स्टाफ';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज $count फेल',
      one: 'आज 1 फेल',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'प्रबंधक दृश्य';

  @override
  String showingScopeLabel(String scope) {
    return 'दिखा रहे हैं: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'आपको अभी तक किसी अनुभाग या टीम को नहीं सौंपा गया है - इस लॉग में कुछ दिखने से पहले किसी प्रबंधक से स्टाफ प्रबंधन में यह सेट करने के लिए कहें।';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रविष्टियां',
      one: '1 प्रविष्टि',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फेल',
      one: '1 फेल',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'कोई फेल नहीं';

  @override
  String get noCompletedTasksLoggedYet =>
      'अभी तक कोई पूर्ण कार्य दर्ज नहीं किया गया';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सत्र सारांश',
      one: '1 सत्र सारांश',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount पास / $failCount फेल';
  }

  @override
  String get workerFixedIt => 'कर्मचारी ने इसे ठीक किया';

  @override
  String get noCorrectiveActionRecorded =>
      'कोई सुधारात्मक कार्रवाई दर्ज नहीं की गई';

  @override
  String get taskAlertFallback => 'कार्य चेतावनी';

  @override
  String get loggedByLabel => 'दर्ज किया';

  @override
  String get resultLabel => 'परिणाम';

  @override
  String get correctiveActionLabel => 'सुधारात्मक कार्रवाई';

  @override
  String get noteLabel => 'टिप्पणी';

  @override
  String get closeLabel => 'बंद करें';

  @override
  String get notCompletedSuffix => '- पूरा नहीं हुआ (शिफ्ट समाप्त)';

  @override
  String get todayAllFails => 'आज + सभी फेल';

  @override
  String byAxisLabel(String axis) {
    return '$axis के अनुसार';
  }

  @override
  String get nameAxisLabel => 'नाम';

  @override
  String get dateAxisLabel => 'तिथि';

  @override
  String get taskAxisLabel => 'कार्य';

  @override
  String get filterLabel => 'फ़िल्टर';

  @override
  String get filterByLabel => 'फ़िल्टर करें:';

  @override
  String get clearFiltersLabel => 'फ़िल्टर साफ़ करें';

  @override
  String get staffLabel => 'स्टाफ';

  @override
  String get issueTypeComplaint => 'शिकायत';

  @override
  String get issueTypeAccident => 'दुर्घटना';

  @override
  String get issueTypeIncident => 'घटना';

  @override
  String get issueTypeSupplyProblem => 'आपूर्ति समस्या';

  @override
  String get issueTypeVenueProblem => 'वेन्यू समस्या';

  @override
  String get issueTypeOther => 'अन्य';

  @override
  String get incorrectDeliveryLabel => 'गलत डिलीवरी';

  @override
  String get driverProblemLabel => 'ड्राइवर की समस्या';

  @override
  String get otherLabel => 'अन्य';

  @override
  String get whatKindOfThingHappened => 'किस तरह की चीज़ हुई?';

  @override
  String get whichOneLabel => 'कौन सा?';

  @override
  String get supplierLabel => 'आपूर्तिकर्ता';

  @override
  String get whatWasWrongWithDelivery => 'डिलीवरी में क्या गड़बड़ थी?';

  @override
  String get receivedByLabel => 'प्राप्तकर्ता';

  @override
  String get whichSectionOptional => 'यह किस अनुभाग के बारे में है? (वैकल्पिक)';

  @override
  String get noSectionLabel => 'कोई अनुभाग नहीं';

  @override
  String get teamOptionalLabel => 'टीम (वैकल्पिक)';

  @override
  String get noSpecificTeamLabel => 'कोई विशिष्ट टीम नहीं';

  @override
  String get whatHappenedLabel => 'क्या हुआ?';

  @override
  String get markAsUrgentLabel => 'तत्काल के रूप में चिह्नित करें';

  @override
  String get markUrgentSubtitle =>
      'यह कितने समय से अनसुलझा है, इसकी परवाह किए बिना तुरंत ध्यान देने की आवश्यकता है';

  @override
  String get logItButton => 'दर्ज करें';

  @override
  String get escalateToTitle => 'इसे भेजें';

  @override
  String get sendToLabel => 'इन्हें भेजें';

  @override
  String get escalateButton => 'आगे बढ़ाएं';

  @override
  String get savedLabel => 'सहेजा गया।';

  @override
  String remindedMessage(String name) {
    return '$name को याद दिलाया गया।';
  }

  @override
  String get couldNotSendReminder => 'अनुस्मारक नहीं भेजा जा सका।';

  @override
  String get viewSupplierScorecard => 'आपूर्तिकर्ता स्कोरकार्ड देखें';

  @override
  String raisedAtLabel(String date) {
    return '$date को दर्ज किया गया';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'आगे बढ़ाया गया: $name';
  }

  @override
  String get historyLabel => 'इतिहास';

  @override
  String get addAnUpdateLabel => 'एक अपडेट जोड़ें';

  @override
  String get addProcessNoteButton => 'प्रक्रिया टिप्पणी जोड़ें';

  @override
  String get resolveButton => 'हल करें';

  @override
  String get reopenThisIssueTitle => 'इस समस्या को फिर से खोलें';

  @override
  String get whyReopenLabel => 'इसे फिर से क्यों खोला जाना चाहिए?';

  @override
  String get reopenButton => 'फिर से खोलें';

  @override
  String sentToLabel(String name) {
    return '$name को भेजा गया';
  }

  @override
  String get remindButton => 'याद दिलाएं';

  @override
  String get phaseRaisedLabel => 'दर्ज किया गया';

  @override
  String get phaseUpdateLabel => 'अपडेट';

  @override
  String get phaseOutcomeLabel => 'परिणाम';

  @override
  String get allLabel => 'सभी';

  @override
  String get dateRangeLabel => 'तिथि सीमा';

  @override
  String get allDatesLabel => 'सभी तिथियां';

  @override
  String get typeLabel => 'प्रकार';

  @override
  String get anyTypeLabel => 'कोई भी प्रकार';

  @override
  String get anyoneLabel => 'कोई भी';

  @override
  String staffFallback(String id) {
    return 'स्टाफ #$id';
  }

  @override
  String get nothingHereGoodSign => 'यहां कुछ नहीं है - यह एक अच्छा संकेत है।';

  @override
  String escalatedToNameLabel(String name) {
    return '$name को आगे बढ़ाया गया';
  }

  @override
  String get havenReportedYet => 'आपने अभी तक कुछ भी रिपोर्ट नहीं किया है।';

  @override
  String get failsAndProblemsRegisterTitle => 'फेल और समस्याएं रजिस्टर';

  @override
  String get taskProblemsTab => 'कार्य समस्याएं';

  @override
  String get issuesAndIncidentsTab => 'समस्याएं और घटनाएं';

  @override
  String get failFilterLabel => 'फेल';

  @override
  String get reportedFilterLabel => 'रिपोर्ट किया गया';

  @override
  String get notCompletedFilterLabel => 'पूरा नहीं हुआ';

  @override
  String get abandonedLabel => 'छोड़ दिया गया';

  @override
  String get noActionTakenLabel => 'कोई कार्रवाई नहीं की गई';

  @override
  String get markResolvedButton => 'हल के रूप में चिह्नित करें';

  @override
  String get openLabel => 'खुला';

  @override
  String get enableRosterQuestion => 'रोस्टर सक्षम करें?';

  @override
  String rosterQuoteBody(String amount) {
    return 'आपकी वर्तमान स्टाफ संख्या के आधार पर, यह आपके मासिक डायरेक्ट डेबिट में $amount जोड़ देगा, जो आपके अगले भुगतान से शुरू होगा।';
  }

  @override
  String get confirmAndEnable => 'पुष्टि करें और सक्षम करें';

  @override
  String couldNotReachVenurite(String error) {
    return 'VenuRite तक नहीं पहुंचा जा सका: $error';
  }

  @override
  String get letStaffClaimShifts => 'स्टाफ को अपनी शिफ्ट खुद दावा करने दें';

  @override
  String get rosterPitchBody =>
      'खुली शिफ्ट पोस्ट करें और स्टाफ को उन्हें खुद उठाने दें - जब कोई नहीं आ सकता तो फोन करने या व्हाट्सएप ग्रुप की जरूरत नहीं। स्टाफ छुट्टी के दिनों का अनुरोध भी कर सकता है, और आप उसी जगह से मंजूर या अस्वीकार कर सकते हैं।';

  @override
  String get pricingLabel => 'मूल्य निर्धारण';

  @override
  String get priceUnder10Staff => '10 से कम स्टाफ वाली शाखा के लिए £6/माह';

  @override
  String get price10PlusStaff => '10 या अधिक स्टाफ वाली शाखा के लिए £10/माह';

  @override
  String get addedToDirectDebitNote =>
      'आपके मौजूदा डायरेक्ट डेबिट में जोड़ा गया - किसी नए भुगतान तरीके की आवश्यकता नहीं। पुष्टि करने से पहले आप सटीक राशि देखेंगे।';

  @override
  String get enableRosterButton => 'रोस्टर सक्षम करें';

  @override
  String get availableShiftsTitle => 'उपलब्ध शिफ्ट';

  @override
  String get shiftClaimingNotEnabled =>
      'इस वेन्यू के लिए शिफ्ट दावा अभी तक सक्षम नहीं है। अपने प्रबंधक से सेटिंग्स में इसे सक्षम करने के लिए कहें।';

  @override
  String couldNotLoadShifts(String error) {
    return 'शिफ्ट लोड नहीं की जा सकीं: $error';
  }

  @override
  String get noShiftsPostedYet => 'अभी तक कोई शिफ्ट पोस्ट नहीं की गई है।';

  @override
  String get someoneElseClaimedShift =>
      'किसी और ने अभी वह शिफ्ट दावा कर ली - क्षमा करें!';

  @override
  String get shiftClaimedMessage => 'शिफ्ट दावा की गई।';

  @override
  String get cancelThisShiftTitle => 'इस शिफ्ट को रद्द करें?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nशिफ्ट शुरू होने में 24 घंटे से कम समय बचा है - अभी रद्द करने से आपके विश्वसनीयता रिकॉर्ड पर असर पड़ सकता है।';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'अब आप इस शिफ्ट के लिए दावेदार नहीं रहेंगे।$warning';
  }

  @override
  String get keepShiftButton => 'शिफ्ट रखें';

  @override
  String get cancelShiftButton => 'शिफ्ट रद्द करें';

  @override
  String get yourShiftRecordReliable => 'आपका शिफ्ट रिकॉर्ड: विश्वसनीय';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'आपका शिफ्ट रिकॉर्ड: सुधार की जरूरत';

  @override
  String get yourShiftRecordBuilding =>
      'आपका शिफ्ट रिकॉर्ड: ट्रैक रिकॉर्ड बन रहा है';

  @override
  String get claimLabel => 'दावा करें';

  @override
  String get claimedLabel => 'दावा किया गया';

  @override
  String requestDateOffTitle(String date) {
    return '$date की छुट्टी का अनुरोध करें';
  }

  @override
  String get reasonOptionalLabel => 'कारण (वैकल्पिक)';

  @override
  String get submitRequestButton => 'अनुरोध सबमिट करें';

  @override
  String get offDayRequestsNotEnabled =>
      'इस वेन्यू के लिए छुट्टी के अनुरोध अभी तक सक्षम नहीं हैं। अपने प्रबंधक से सेटिंग्स में रोस्टर सक्षम करने के लिए कहें।';

  @override
  String get noOffDayRequestsYet =>
      'आपके पास अभी तक कोई छुट्टी अनुरोध नहीं है।';

  @override
  String get yourRequestsLabel => 'आपके अनुरोध';

  @override
  String get approvedLabel => 'स्वीकृत';

  @override
  String get deniedLabel => 'अस्वीकृत';

  @override
  String get pendingLabel => 'लंबित';

  @override
  String get postAShiftTitle => 'शिफ्ट पोस्ट करें';

  @override
  String get categoryHint => 'श्रेणी (जैसे, खोलना, बंद करना)';

  @override
  String get pickStartTime => 'प्रारंभ समय चुनें';

  @override
  String get pickEndTime => 'समाप्ति समय चुनें';

  @override
  String get postLabel => 'पोस्ट करें';

  @override
  String get assignShiftToTitle => 'इस शिफ्ट को असाइन करें';

  @override
  String get unknownLabel => 'अज्ञात';

  @override
  String get shiftsTabLabel => 'शिफ्ट';

  @override
  String get offDayRequestsTabLabel => 'छुट्टी के अनुरोध';

  @override
  String get rosterAddonNotEnabledManager =>
      'इस वेन्यू के लिए रोस्टर ऐड-ऑन सक्षम नहीं है। शिफ्ट पोस्ट करना शुरू करने के लिए सेटिंग्स > कंपनी में इसे सक्षम करें।';

  @override
  String get noShiftsTapPlus =>
      'अभी तक कोई शिफ्ट पोस्ट नहीं हुई। एक जोड़ने के लिए + टैप करें।';

  @override
  String get openStatusLabel => 'खुला';

  @override
  String get assignedStatusPrefix => 'असाइन किया गया';

  @override
  String get claimedStatusPrefix => 'दावा किया गया';

  @override
  String get assignDirectlyLabel => 'सीधे असाइन करें';

  @override
  String get removeClaimLabel => 'दावा हटाएं';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'छुट्टी के अनुरोध लोड नहीं हो सके: $error';
  }

  @override
  String get noOffDayRequests => 'कोई छुट्टी अनुरोध नहीं।';

  @override
  String get approveLabel => 'स्वीकृत करें';

  @override
  String get denyLabel => 'अस्वीकार करें';

  @override
  String get rosterAddonNotEnabledPlain =>
      'इस वेन्यू के लिए रोस्टर ऐड-ऑन सक्षम नहीं है।';

  @override
  String get noActiveStaffVenue =>
      'इस वेन्यू में अभी तक कोई सक्रिय स्टाफ नहीं है।';

  @override
  String get last90DaysAlphabetical =>
      'पिछले 90 दिन, शिफ्ट श्रेणी अनुसार। वर्णानुक्रम में - रैंकिंग नहीं।';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शिफ्ट',
      one: '1 शिफ्ट',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'इस अवधि में कोई शिफ्ट नहीं।';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'यह आपके Documents फ़ोल्डर में स्थानीय डेटाबेस की एक पूर्ण प्रति बनाता है। इसे बाद में USB ड्राइव या क्लाउड-सिंक्ड फ़ोल्डर में ले जाना एक अलग मैन्युअल चरण है।';

  @override
  String get backupNameOptional => 'बैकअप नाम (वैकल्पिक)';

  @override
  String get backupNameHint => 'जैसे, निरीक्षण-पूर्व बैकअप';

  @override
  String get backupCreatedTitle => 'बैकअप बनाया गया';

  @override
  String get tierTeamMember => 'टीम सदस्य';

  @override
  String get tierSupervisor => 'सुपरवाइज़र';

  @override
  String get tierManager => 'प्रबंधक';

  @override
  String get tierRegionalManager => 'क्षेत्रीय प्रबंधक';

  @override
  String get tierDirector => 'डायरेक्टर';

  @override
  String get anyTaskFail => 'कोई भी कार्य फेल';

  @override
  String taskFailLabel(String title) {
    return 'फेल: $title';
  }

  @override
  String get taskFailTemplateStale => 'कार्य फेल (टेम्पलेट अब मौजूदा नहीं है)';

  @override
  String get unknownUserLabel => 'अज्ञात उपयोगकर्ता';

  @override
  String tierSuffixLabel(String tier) {
    return '$tier स्तर';
  }

  @override
  String get unsetLabel => 'सेट नहीं';

  @override
  String get pushChannelLabel => 'पुश';

  @override
  String get emailChannelLabel => 'ईमेल';

  @override
  String get inAppOnlyLabel => 'केवल इन-ऐप';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'इन-ऐप + $channels';
  }

  @override
  String get tierColumnTeam => 'टीम';

  @override
  String get tierColumnSupv => 'सुपर';

  @override
  String get tierColumnMgr => 'प्रबं';

  @override
  String get tierColumnRegnl => 'क्षेत्र';

  @override
  String get tierColumnDir => 'डायर';

  @override
  String get quickSetupSectionTitle => 'त्वरित सेटअप: प्रति-कार्य फेल सूचनाएं';

  @override
  String get tickTierNotified =>
      'चुनें कि किसी विशिष्ट कार्य के फेल होने पर किस स्तर को सूचित किया जाए।';

  @override
  String get noTaskTemplatesSetUp =>
      'अभी तक कोई कार्य टेम्पलेट सेट नहीं किया गया है।';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'सूचित करें: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return '$tier स्तर द्वारा सेट किया गया';
  }

  @override
  String get inactiveSuffixLabel => ' - निष्क्रिय';

  @override
  String get deactivateButton => 'निष्क्रिय करें';

  @override
  String get reactivateButton => 'पुनः सक्रिय करें';

  @override
  String get newRuleTitle => 'नया नियम';

  @override
  String get triggerLabel => 'ट्रिगर';

  @override
  String get notifyLabel => 'सूचित करें';

  @override
  String get wholeRoleTierOption => 'एक पूरा भूमिका स्तर';

  @override
  String get specificPersonOption => 'एक विशिष्ट व्यक्ति';

  @override
  String get roleTierLabel => 'भूमिका स्तर';

  @override
  String get personLabel => 'व्यक्ति';

  @override
  String get pushLabel => 'पुश';

  @override
  String get rulesInAppNotice =>
      'नियम अभी इन-ऐप दिखाए जाते हैं; पुश/ईमेल डिलीवरी अभी बैकएंड से जुड़ी नहीं है और बाद के स्प्रिंट में जोड़ी जाएगी।';

  @override
  String get saveRuleButton => 'नियम सहेजें';

  @override
  String get addRuleButton => 'नियम जोड़ें';

  @override
  String get noNotificationRulesYet =>
      'अभी तक कोई सूचना नियम सेट नहीं किया गया है।';

  @override
  String get stepYourAccount => 'तुम्हारा खाता';

  @override
  String get stepCompanyDetails => 'कंपनी विवरण';

  @override
  String get stepOrgStructure => 'संगठन संरचना';

  @override
  String get stepFirstVenue => 'पहला वेन्यू';

  @override
  String get stepStarterSetup => 'तुम्हारा शुरुआती सेटअप';

  @override
  String get stepSubscription => 'सब्सक्रिप्शन';

  @override
  String get stepPayment => 'भुगतान';

  @override
  String get termsOfServiceTitle => 'सेवा की शर्तें';

  @override
  String get companySignupGenericError =>
      'तुम्हारी कंपनी बनाते समय कुछ गलत हो गया। कृपया फिर से कोशिश करें - अगर यह होता रहे, तो VenuRite से संपर्क करें।';

  @override
  String get directDebitStartError =>
      'हम डायरेक्ट डेबिट सेटअप स्वचालित रूप से शुरू नहीं कर सके - लॉग इन करने के बाद तुम इसे सेटिंग्स से कभी भी कर सकते हो।';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get creatingEllipsis => 'बन रहा है...';

  @override
  String get startFreeTrialButton => 'मुफ्त ट्रायल शुरू करें';

  @override
  String get companyCreatedTitle => 'कंपनी बन गई';

  @override
  String get adminAccountIntro =>
      'चलो तुम्हारा खाता सेट करते हैं। तुम VenuRite पर इस कंपनी के एडमिन होगे, और अंदर आते ही अपनी टीम को आमंत्रित कर सकते हो।';

  @override
  String get firstNameLabel => 'पहला नाम';

  @override
  String get lastNameLabel => 'अंतिम नाम';

  @override
  String get passwordMinCharsHelper => 'कम से कम 8 अक्षर';

  @override
  String get companyDetailsIntro => 'हमें अपनी कंपनी के बारे में बताओ।';

  @override
  String get tradingCompanyNameLabel => 'व्यापारिक / कंपनी का नाम';

  @override
  String get legalCompanyNameLabel => 'कंपनी का कानूनी नाम (वैकल्पिक)';

  @override
  String get legalCompanyNameHelper =>
      'ऊपर दिए गए व्यापारिक नाम का उपयोग करने के लिए खाली छोड़ें';

  @override
  String get countryLabel => 'देश';

  @override
  String get registeredAddressLabel => 'पंजीकृत / व्यावसायिक पता (वैकल्पिक)';

  @override
  String get vatNumberLabel => 'वैट / कर संख्या (यदि लागू हो)';

  @override
  String get billingContactEmailLabel => 'बिलिंग संपर्क ईमेल (वैकल्पिक)';

  @override
  String get structureIntro =>
      'यह है कि VenuRite तुम्हारी कंपनी को कैसे व्यवस्थित करता है। अभी तुम्हें कुछ भी सेट करने की ज़रूरत नहीं - यह बस अगले चरण को समझने योग्य बनाने के लिए है।';

  @override
  String get structureYourCompanyLabel => 'तुम्हारी कंपनी';

  @override
  String get structureYourCompanySublabel => 'एक समेकित खाता और बिल';

  @override
  String get structureRegionsLabel => 'क्षेत्र (वैकल्पिक)';

  @override
  String get structureRegionsSublabel =>
      'वेन्यूज़ को देश या क्षेत्र के अनुसार समूहित करें - ज़रूरत न हो तो छोड़ दें';

  @override
  String get structureVenuesLabel => 'वेन्यूज़';

  @override
  String get structureVenuesSublabel =>
      'आज एक वेन्यू, बाद में सैकड़ों - कभी भी और जोड़ें';

  @override
  String get structureStaffLabel => 'स्टाफ';

  @override
  String get structureStaffSublabel =>
      'हर वेन्यू की टीम, वेन्यू बनने पर आमंत्रित';

  @override
  String get structureOutro =>
      'आगे हम तुम्हारा पहला वेन्यू सेट करेंगे - क्षेत्र और अधिक वेन्यूज़ तुम ऐप के अंदर से बाद में जोड़ सकते हो।';

  @override
  String get wizardFirstVenueHeroTitle => 'चलो तुम्हारा पहला वेन्यू जोड़ते हैं';

  @override
  String get addMoreVenuesLaterText => 'तुम बाद में और वेन्यूज़ जोड़ सकते हो।';

  @override
  String get venueNameLabel => 'वेन्यू का नाम';

  @override
  String get addressOptionalLabel => 'पता (वैकल्पिक)';

  @override
  String get regionAreaOptionalLabel => 'क्षेत्र / इलाका (वैकल्पिक)';

  @override
  String get regionAreaHelper =>
      'जैसे \"दिल्ली\" - केवल तभी ज़रूरी जब तुम्हारे पास एक से ज़्यादा वेन्यू हों (या होंगे)';

  @override
  String get venueTypeOptionalLabel => 'वेन्यू का प्रकार (वैकल्पिक)';

  @override
  String get venueTypeHelper =>
      'एक चुनने पर तुम्हें एक तैयार शुरुआती सेट दिखाई देगा - उन कामों और उपकरणों के लिए जिनकी तुम्हें पहले से ज़रूरत पता है।';

  @override
  String get payoffSkippedText =>
      'तुमने वेन्यू प्रकार चुनना छोड़ दिया, इसलिए अभी दिखाने के लिए कोई शुरुआती सेट नहीं है - अंदर आने के बाद तुम खुद काम और उपकरण जोड़ सकते हो।';

  @override
  String get payoffErrorText =>
      'इस वेन्यू प्रकार के लिए शुरुआती सेट लोड नहीं हो सका - अंदर आने के बाद तुम खुद काम और उपकरण जोड़ सकते हो।';

  @override
  String get payoffHeroTitle =>
      'यह रही तुम्हारी अनुपालन तैयारी, उपयोग के लिए तैयार';

  @override
  String get equipmentSectionLabel => 'उपकरण';

  @override
  String get subscriptionBannerText =>
      'एक कंपनी खाता, एक समेकित बिल - प्रति वेन्यू कीमत, कभी प्रति व्यक्ति नहीं।';

  @override
  String get subscriptionIntroText =>
      'आज तुम्हारे पास कितने वेन्यू हैं, मुख्यालय सहित अगर है तो? अभी तुम केवल अपना पहला वेन्यू सेट करोगे - बाकी तुम ऐप के अंदर से कभी भी जोड़ सकते हो।';

  @override
  String get perBranchPriceLabel => '39 पाउंड/वेन्यू/महीना';

  @override
  String get headOfficeIncludedLabel => '+ 1 मुख्यालय वेन्यू (4+ वेन्यूज़)';

  @override
  String get discountCodeHint =>
      'क्या तुम्हारे पास डिस्काउंट कोड है? तुम इसे डायरेक्ट डेबिट सेट करते समय दर्ज कर सकते हो।';

  @override
  String get trialBannerText =>
      'तुम 14-दिन का मुफ्त ट्रायल शुरू कर रहे हो - आज कार्ड की ज़रूरत नहीं।';

  @override
  String get paymentStepIntro =>
      'हम तुम्हारे ट्रायल खत्म होने से पहले भुगतान सेट करने के लिए कहेंगे, ऐप के अंदर सेटिंग्स से। अभी कुछ भी चार्ज नहीं होता - बस हमें बताओ कि तुम कैसे भुगतान करना पसंद करोगे।';

  @override
  String get cardPaymentTitle => 'कार्ड भुगतान (Stripe)';

  @override
  String get cardPaymentSubtitle => 'डेबिट/क्रेडिट कार्ड, मासिक या वार्षिक बिल';

  @override
  String get directDebitTitle => 'डायरेक्ट डेबिट (GoCardless)';

  @override
  String get directDebitSubtitle => 'बैंक-से-बैंक भुगतान, कार्ड की ज़रूरत नहीं';

  @override
  String get decideLaterButton => 'मैं बाद में तय करूँगा/करूँगी';

  @override
  String get decideLaterSnackbar =>
      'कोई बात नहीं - तुम इसे सेटिंग्स से कभी भी सेट कर सकते हो।';

  @override
  String get agreeToTermsPrefix => 'मैंने पढ़ लिया है और सहमत हूँ ';

  @override
  String get successActivatedBanner =>
      'तुम्हारी कंपनी और पहला वेन्यू सेट हो गए हैं, और तुम लॉग इन हो।';

  @override
  String get successNotActivatedBanner =>
      'तुम्हारी कंपनी और पहला वेन्यू सेट हो गए हैं। अपने ईमेल और अभी चुने गए पासवर्ड से लॉग इन करो।';

  @override
  String get directDebitSettingUp => 'डायरेक्ट डेबिट सेट हो रहा है...';

  @override
  String get directDebitOpenedBrowser =>
      'डायरेक्ट डेबिट सेटअप पूरा करने के लिए हमने तुम्हारा ब्राउज़र खोल दिया है।';

  @override
  String get inviteYourTeamTitle => 'अपनी टीम को आमंत्रित करो';

  @override
  String get inviteYourTeamSubtitle =>
      'वैकल्पिक - अभी शिफ्ट पर मौजूद किसी को भी जोड़ो, या छोड़कर बाद में स्टाफ मैनेजमेंट से यह करो।';

  @override
  String get jobTitleLabel => 'पद';

  @override
  String get tierFieldLabel => 'स्तर';

  @override
  String get addTeamMemberButton => 'टीम सदस्य जोड़ें';

  @override
  String get goToDashboardButton => 'डैशबोर्ड पर जाएं';

  @override
  String get goToSignInButton => 'लॉगिन पर जाएं';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - चरण $step / $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return '$email उपयोग करने के लिए खाली छोड़ें';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'हमारे पास अभी $venueType के लिए पहले से बना शुरुआती सेट नहीं है - अंदर आने के बाद तुम खुद काम और उपकरण जोड़ सकते हो।';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$venueType के लिए $sectionCount अनुभागों में $totalTasks काम और $equipmentCount उपकरण प्रकार पहले से सेट किए गए हैं।';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$venueType के लिए $sectionCount अनुभागों में $totalTasks काम पहले से सेट किए गए हैं।';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/महीना कुल ($units वेन्यू बिल किए गए)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'पिन: $pin';
  }
}
