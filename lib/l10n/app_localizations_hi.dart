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
}
