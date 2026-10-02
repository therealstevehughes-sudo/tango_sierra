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
  String get shortDeliveryLabel => 'अधूरी डिलीवरी';

  @override
  String get damagedStockLabel => 'क्षतिग्रस्त स्टॉक';

  @override
  String get lateDeliveryLabel => 'देर से डिलीवरी';

  @override
  String get qualityProblemLabel => 'गुणवत्ता समस्या';

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
  String get venuesSectionTitle => 'वेन्यूज़';

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
  String get sixDigitCodeLabel => '6 अंकों का कोड';

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
  String get dateRangeLabel => 'तारीख सीमा';

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
  String get categoryHint => 'जैसे रेफ्रिजरेशन मरम्मत, कीट नियंत्रण';

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

  @override
  String get jobRoleChefCook => 'शेफ/रसोइया';

  @override
  String get jobRoleKitchenPorter => 'किचन पोर्टर';

  @override
  String get jobRoleFrontOfHouse => 'फ्रंट ऑफ हाउस';

  @override
  String get jobRoleBar => 'बार';

  @override
  String get jobRoleManagement => 'प्रबंधन';

  @override
  String get jobRoleEveryone => 'सभी';

  @override
  String get jobRoleMaintenance => 'रखरखाव';

  @override
  String get jobRoleHousekeeping => 'हाउसकीपिंग';

  @override
  String get jobRoleReception => 'रिसेप्शन';

  @override
  String get jobRoleSecurity => 'सुरक्षा';

  @override
  String get segmentFoodSafety => 'खाद्य सुरक्षा और तापमान नियंत्रण';

  @override
  String get segmentAllergen => 'एलर्जन प्रबंधन';

  @override
  String get segmentPersonalHygienePpe => 'व्यक्तिगत स्वच्छता और पीपीई';

  @override
  String get segmentRefrigerationColdStorage => 'प्रशीतन और कोल्ड स्टोरेज';

  @override
  String get segmentCookingLineEquipment => 'कुकिंग लाइन उपकरण';

  @override
  String get segmentWashupDishwash => 'बर्तन धोना';

  @override
  String get segmentCleaningSanitation => 'सफाई और स्वच्छता';

  @override
  String get segmentCleaningChemicals => 'सफाई रसायन और उपभोग्य वस्तुएं';

  @override
  String get segmentDryAmbientStorage => 'सूखा और सामान्य तापमान भंडारण';

  @override
  String get segmentDeliveriesGoodsIn => 'डिलीवरी और माल प्राप्ति';

  @override
  String get segmentUtilitiesSafety => 'उपयोगिताएं और सुरक्षा';

  @override
  String get segmentWastePestControl => 'कचरा और कीट नियंत्रण';

  @override
  String get segmentPreventiveMaintenance => 'निवारक रखरखाव (किचन उपकरण)';

  @override
  String get segmentStockControl => 'स्टॉक नियंत्रण';

  @override
  String get segmentOpeningProcedures => 'खोलने की प्रक्रियाएं';

  @override
  String get segmentClosingProcedures => 'बंद करने की प्रक्रियाएं';

  @override
  String get segmentServiceReadiness => 'सेवा तैयारी';

  @override
  String get segmentFrontOfHouse => 'फ्रंट ऑफ हाउस / सेवा';

  @override
  String get segmentBarBeverage => 'बार और पेय';

  @override
  String get segmentHotelSpecific => 'होटल-विशिष्ट';

  @override
  String get segmentManagementComplianceOversight =>
      'प्रबंधन और अनुपालन निगरानी';

  @override
  String get segmentMaintenance => 'रखरखाव';

  @override
  String get segmentHousekeeping => 'हाउसकीपिंग';

  @override
  String get segmentReception => 'रिसेप्शन';

  @override
  String get segmentSecurity => 'सुरक्षा';

  @override
  String get freqDaily => 'रोज़ाना';

  @override
  String get freqWeekly => 'साप्ताहिक';

  @override
  String get freqPerShift => 'प्रति शिफ्ट';

  @override
  String get freqThreeXDaily => 'दिन में 3 बार';

  @override
  String get freqTwoXDaily => 'दिन में 2 बार';

  @override
  String get freqPerBatch => 'प्रति बैच';

  @override
  String get freqPerDelivery => 'प्रति डिलीवरी';

  @override
  String get freqPerUse => 'प्रति उपयोग';

  @override
  String get freqPerService => 'प्रति सेवा';

  @override
  String get freqTwoXPerService => 'प्रति सेवा 2 बार';

  @override
  String get freqEventBased => 'इवेंट आधारित';

  @override
  String get freqAsNeeded => 'आवश्यकतानुसार';

  @override
  String get freqMonthly => 'मासिक';

  @override
  String get freqCustom => 'कस्टम';

  @override
  String get jobRoleFieldLabel => 'नौकरी भूमिका';

  @override
  String get pinFieldLabel => 'पिन';

  @override
  String get addStaffMemberTitle => 'स्टाफ सदस्य जोड़ें';

  @override
  String get addLabel => 'जोड़ें';

  @override
  String get assignTasksTitle => 'कार्य असाइन करें';

  @override
  String get noActiveSiteFoundError => 'कोई सक्रिय वेन्यू नहीं मिला।';

  @override
  String get byPersonLabel => 'व्यक्ति के अनुसार';

  @override
  String get byTaskLabel => 'कार्य के अनुसार';

  @override
  String get noEquipmentOfTypeSetUp =>
      'इस प्रकार का कोई उपकरण अभी तक सेट नहीं है।';

  @override
  String get applyButton => 'लागू करें';

  @override
  String get assignToTitle => 'किसे असाइन करें';

  @override
  String get noStaffMatchTiers =>
      'कोई स्टाफ उन स्तरों से मेल नहीं खाता जिन पर ये कार्य लागू होते हैं।';

  @override
  String get assignButton => 'असाइन करें';

  @override
  String get showInstructionsTooltip => 'निर्देश दिखाएं';

  @override
  String get selectTasksToAssignLabel => 'असाइन करने के लिए कार्य चुनें';

  @override
  String get taskPresetsSectionTitle => 'कार्य प्रीसेट';

  @override
  String get showAllPresetsButton => 'सभी प्रीसेट दिखाएं';

  @override
  String get showTasksInGroupTooltip => 'इस समूह में कार्य दिखाएं';

  @override
  String get applyToMultipleButton => 'कई लोगों पर लागू करें';

  @override
  String get addCustomTaskButton => 'कस्टम कार्य जोड़ें';

  @override
  String get customTaskSectionTitle => 'कस्टम कार्य';

  @override
  String get titleFieldLabel => 'शीर्षक';

  @override
  String get departmentSectionLabel => 'विभाग / अनुभाग';

  @override
  String get methodLabel => 'तरीका';

  @override
  String get methodTick => 'टिक';

  @override
  String get methodData => 'डेटा';

  @override
  String get methodDataTick => 'डेटा + टिक';

  @override
  String get methodTickPhoto => 'टिक + फोटो';

  @override
  String get methodDataPhoto => 'डेटा + फोटो';

  @override
  String get methodNote => 'नोट';

  @override
  String get methodDataNote => 'डेटा + नोट';

  @override
  String get methodNotePhoto => 'नोट + फोटो';

  @override
  String get methodTickNote => 'टिक + नोट';

  @override
  String get methodMulti => 'मल्टी';

  @override
  String get requiresPhotoLabel => 'फोटो आवश्यक';

  @override
  String get requiresNotesLabel => 'नोट्स आवश्यक';

  @override
  String get minLimitLabel => 'न्यूनतम सीमा';

  @override
  String get maxLimitLabel => 'अधिकतम सीमा';

  @override
  String get unitHintLabel => 'इकाई (जैसे सेल्सियस)';

  @override
  String get equipmentTypeOptionalLabel => 'उपकरण प्रकार (वैकल्पिक)';

  @override
  String get noneLabel => 'कोई नहीं';

  @override
  String get priorityLabel => 'प्राथमिकता';

  @override
  String get priorityCritical => 'गंभीर';

  @override
  String get priorityHigh => 'उच्च';

  @override
  String get priorityStandard => 'मानक';

  @override
  String get requiresCorrectiveActionLabel =>
      'विफल होने पर सुधारात्मक कार्रवाई आवश्यक';

  @override
  String get fixInstructionsLabel => 'सुधार निर्देश';

  @override
  String get customFieldsJsonLabel => 'कस्टम फ़ील्ड (JSON, वैकल्पिक)';

  @override
  String get extraFieldsSectionTitle => 'अतिरिक्त फ़ील्ड (वैकल्पिक)';

  @override
  String get removeTooltip => 'हटाएं';

  @override
  String get fieldLabelHint => 'फ़ील्ड लेबल (जैसे PO नंबर)';

  @override
  String get extraFieldTypeText => 'टेक्स्ट';

  @override
  String get extraFieldTypeNumber => 'संख्या';

  @override
  String get extraFieldTypeDate => 'तारीख';

  @override
  String get addFieldTooltip => 'फ़ील्ड जोड़ें';

  @override
  String get saveCustomTaskButton => 'कस्टम कार्य सहेजें';

  @override
  String get adHocLabel => 'तदर्थ';

  @override
  String get timeAllocatedLabel => 'समय आवंटित';

  @override
  String get frequencyPrefixLabel => 'आवृत्ति: ';

  @override
  String get atATimeLabel => 'एक निश्चित समय पर';

  @override
  String get fromStartOfShiftLabel => 'शिफ्ट शुरू होने से';

  @override
  String get fromClockInLabel => 'क्लॉक-इन से';

  @override
  String get availableFromEllipsis => 'उपलब्ध…';

  @override
  String get untilEllipsis => 'तक…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'कार्य असाइन करें - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return '\"$name\" किस पर लागू करें?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return '$name के सभी कार्य पहले से ही असाइन किए गए थे';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    return '$name से $count कार्य जोड़े गए';
  }

  @override
  String applyPresetToTitle(String name) {
    return '\"$name\" लागू करें';
  }

  @override
  String assignTasksCountLabel(int count) {
    return 'स्टाफ को $count कार्य असाइन करें…';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return '$staffCount स्टाफ सदस्यों में $count असाइनमेंट जोड़े गए';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'अनुभाग: $segment';
  }

  @override
  String taskCountLabel(int count) {
    return '$count कार्य';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'सभी भूमिकाएं दिखाएं (डिफ़ॉल्ट: केवल $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - इसके लिए अभी तक कोई उपकरण सेट नहीं किया गया';
  }

  @override
  String fromTimeLabel(String time) {
    return '$time से';
  }

  @override
  String untilTimeLabel(String time) {
    return '$time तक';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return '$count असाइनमेंट बनाए गए$skippedNote।';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count छोड़े गए - पहले से असाइन या भूमिका बेमेल)';
  }

  @override
  String get serviceProvidersTitle => 'सेवा प्रदाता';

  @override
  String get myProvidersTab => 'मेरे प्रदाता';

  @override
  String get findProviderTab => 'प्रदाता खोजें';

  @override
  String get noBackendProviderNotice1 =>
      'अन्य वेन्यू के साझा प्रदाताओं को ब्राउज़ करने के लिए वास्तविक कंपनी खाता लॉग इन होना ज़रूरी है - यह केवल लोकल डेमो लॉगिन से काम नहीं कर सकता। \"मेरे प्रदाता\" के तहत तुम्हारे अपने संपर्क दोनों तरह से काम करते हैं।';

  @override
  String get noBackendProviderNotice2 =>
      'इसका उपयोग करने के लिए वास्तविक कंपनी खाते के साथ लीडरशिप एक्सेस से लॉग इन करो।';

  @override
  String get providerDisclaimerText =>
      'VenuRite किसी भी सूचीबद्ध प्रदाता की जांच या समर्थन नहीं करता। समीक्षाएं अन्य वेन्यू से हैं, VenuRite से नहीं।';

  @override
  String get addProviderButton => 'प्रदाता जोड़ें';

  @override
  String get noProvidersYetText =>
      'तुमने अभी तक कोई सेवा प्रदाता नहीं जोड़ा है।';

  @override
  String get addServiceProviderDialogTitle => 'एक सेवा प्रदाता जोड़ें';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get phoneOptionalLabel => 'फोन (वैकल्पिक)';

  @override
  String get emailOptionalLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get notesOptionalPrivateLabel =>
      'नोट्स (वैकल्पिक, केवल तुम्हारे लिए निजी)';

  @override
  String get happyToReviewShareLabel =>
      'मुझे समीक्षा और साझा करने में खुशी होगी';

  @override
  String get shareVisibilityExplanation =>
      'अन्य वेन्यू तुम्हारी रेटिंग और समीक्षाएं देखेंगे, नाम/संपर्क तब तक धुंधला रहेगा जब तक वे इसे अनलॉक न करें।';

  @override
  String get rateThisProviderLabel => 'इस प्रदाता को रेट करें';

  @override
  String get priceRatingLabel => 'कीमत';

  @override
  String get punctualityRatingLabel => 'समयपालन';

  @override
  String get qualityRatingLabel => 'गुणवत्ता';

  @override
  String get availabilityRatingLabel => 'उपलब्धता';

  @override
  String get reviewOptionalLabel => 'समीक्षा (वैकल्पिक)';

  @override
  String get reviewHintText =>
      'अपने अनुभव का वर्णन करें - कृपया व्यवसाय का नाम न बताएं या संपर्क विवरण शामिल न करें।';

  @override
  String get sessionExpiredMessage =>
      'तुम्हारा सत्र समाप्त हो गया है - कृपया फिर से लॉग इन करो।';

  @override
  String get sharedWithOtherVenuesLabel => 'अन्य वेन्यू के साथ साझा किया गया';

  @override
  String get privateLabel => 'निजी';

  @override
  String get rateReviewsButton => 'रेट करें / समीक्षाएं';

  @override
  String get searchByCategoryOrNameHint => 'श्रेणी या नाम से खोजें';

  @override
  String get noContactsUnlockedThisMonth =>
      'इस महीने अभी तक कोई संपर्क अनलॉक नहीं हुआ।';

  @override
  String get noSharedProvidersYetText =>
      'अभी तक कोई साझा प्रदाता नहीं - \"मेरे प्रदाता\" से एक साझा करने वाले पहले व्यक्ति बनो।';

  @override
  String get noProvidersMatchSearchText =>
      'तुम्हारी खोज से कोई प्रदाता मेल नहीं खाता।';

  @override
  String get noRatingsYetText => 'अभी तक कोई रेटिंग नहीं';

  @override
  String get hiddenUntilUnlockedText => 'अनलॉक होने तक छिपा हुआ';

  @override
  String get unnamedPlaceholder => '(अनाम)';

  @override
  String get readReviewsButton => 'समीक्षाएं पढ़ें';

  @override
  String get unlockContactDetailsButton => 'संपर्क विवरण अनलॉक करें';

  @override
  String get reviewsTitle => 'समीक्षाएं';

  @override
  String get noReviewsYetText => 'अभी तक कोई समीक्षा नहीं।';

  @override
  String get addYourRatingLabel => 'अपनी रेटिंग जोड़ें';

  @override
  String get submittingEllipsis => 'सबमिट हो रहा है...';

  @override
  String get submitRatingButton => 'रेटिंग सबमिट करें';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'तुम्हारी समीक्षा में $found शामिल लगता है। सबमिट करने से पहले कृपया संपर्क विवरण या व्यवसाय के नाम हटा दो।';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'तुम्हारी समीक्षा में $found शामिल लगता है। सबमिट करने से पहले कृपया संपर्क विवरण या व्यवसाय के नाम हटा दो - समीक्षाएं तब उपयोगी (और निष्पक्ष) रहती हैं जब वे अनुभव का वर्णन करती हैं, न कि सीधे किसे कॉल करें।';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    return 'इस महीने $count संपर्क अनलॉक किए गए।';
  }

  @override
  String priceValueLabel(String value) {
    return 'कीमत $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'समयपालन $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'गुणवत्ता $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'उपलब्धता $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    return '$parts ($count समीक्षाएं)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'कीमत $price - समयपालन $punctuality - गुणवत्ता $quality - उपलब्धता $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'फोन: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'ईमेल: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'ताज़ा उपज';

  @override
  String get supplierCategoryMeatPoultry => 'मांस और मुर्गी';

  @override
  String get supplierCategoryDairyEggs => 'डेयरी और अंडे';

  @override
  String get supplierCategoryFrozenGoods => 'जमे हुए सामान';

  @override
  String get supplierCategoryDryAmbientGoods => 'सूखा और सामान्य तापमान सामान';

  @override
  String get supplierCategoryDrinksBeverages => 'पेय पदार्थ';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'रसायन और सफाई सामग्री';

  @override
  String get supplierCategoryEquipmentMaintenance => 'उपकरण और रखरखाव';

  @override
  String get supplierCategoryOther => 'अन्य';

  @override
  String get supplierStatusApproved => 'स्वीकृत';

  @override
  String get supplierStatusPending => 'लंबित';

  @override
  String get supplierStatusSuspended => 'निलंबित';

  @override
  String get addEquipmentTitle => 'उपकरण जोड़ें';

  @override
  String get venueSetupTitle => 'वेन्यू सेटअप';

  @override
  String get nextButton => 'अगला';

  @override
  String get finishSetupButton => 'सेटअप समाप्त करें';

  @override
  String get renameAreaTitle => 'क्षेत्र का नाम बदलें';

  @override
  String get renameEquipmentTitle => 'उपकरण का नाम बदलें';

  @override
  String get saveButton => 'सहेजें';

  @override
  String get retireEquipmentTitle => 'उपकरण हटाएं';

  @override
  String get retireEquipmentConfirmText =>
      'इस उपकरण को हटाने से इसे सौंपे गए सभी कार्य भी अनअसाइन हो जाएंगे। पिछला सबमिशन इतिहास सुरक्षित रहता है। जारी रखें?';

  @override
  String get retireButton => 'हटाएं';

  @override
  String get areasStepTitle => 'क्षेत्र';

  @override
  String get areasStepIntro => 'इस वेन्यू के परिचालन क्षेत्र जोड़ें।';

  @override
  String get areaSuggestionKitchen => 'रसोई';

  @override
  String get areaSuggestionStorage => 'भंडारण';

  @override
  String get areaSuggestionReceiving => 'प्राप्ति';

  @override
  String get areaSuggestionFrontOfHouse => 'फ्रंट ऑफ हाउस';

  @override
  String get areaNameLabel => 'क्षेत्र का नाम';

  @override
  String get addAreaTooltip => 'क्षेत्र जोड़ें';

  @override
  String get renameTooltip => 'नाम बदलें';

  @override
  String get equipmentStepTitle => 'उपकरण';

  @override
  String get equipmentStepIntro =>
      'नामित उपकरण इंस्टेंस जोड़ें, जैसे \"फ्रिज 1\", \"फ्रिज 2\"।';

  @override
  String get showAllEquipmentTypesButton => 'सभी उपकरण प्रकार दिखाएं';

  @override
  String get equipmentTypeLabel => 'उपकरण प्रकार';

  @override
  String get somethingElseOption => 'कुछ और...';

  @override
  String get newEquipmentTypeNameLabel => 'नए उपकरण प्रकार का नाम';

  @override
  String get confirmNewEquipmentTypeTooltip => 'नए उपकरण प्रकार की पुष्टि करें';

  @override
  String get noAreasForDeptText =>
      'तुम्हारे विभाग के लिए अभी तक कोई क्षेत्र सेट नहीं किया गया - उपकरण फिर भी बिना क्षेत्र के जोड़ा जा सकता है।';

  @override
  String get noAreasAddOneText =>
      'अभी तक कोई क्षेत्र नहीं जोड़ा गया - एक जोड़ने के लिए वापस जाओ।';

  @override
  String get equipmentNameLabel => 'उपकरण का नाम';

  @override
  String get equipmentNameHint => 'जैसे मीट वॉक-इन, डेज़र्ट फ्रिज, बार फ्रायर';

  @override
  String get modelOptionalLabel => 'मॉडल (वैकल्पिक)';

  @override
  String get serialNumberOptionalLabel => 'सीरियल नंबर (वैकल्पिक)';

  @override
  String get retireTooltip => 'हटाएं';

  @override
  String get reactivateTooltip => 'पुनः सक्रिय करें';

  @override
  String get unknownTypeLabel => 'अज्ञात प्रकार';

  @override
  String get unknownAreaLabel => 'अज्ञात क्षेत्र';

  @override
  String get staffStepTitle => 'स्टाफ';

  @override
  String get staffStepIntro =>
      'स्टाफ सदस्य जोड़ें और उनका भूमिका स्तर असाइन करें।';

  @override
  String get addStaffMemberButton => 'स्टाफ सदस्य जोड़ें';

  @override
  String get suppliersStepTitle => 'आपूर्तिकर्ता';

  @override
  String get suppliersStepIntro =>
      'इस वेन्यू के साथ काम करने वाले आपूर्तिकर्ता जोड़ें। EHO एक्सपोर्ट पर अनुमोदन फ्लैग दिखाई देते हैं - निलंबित आपूर्तिकर्ता प्रबंधकों को दिखाए जाते हैं, चुपचाप छिपाए नहीं जाते।';

  @override
  String get supplierNameLabel => 'आपूर्तिकर्ता का नाम';

  @override
  String get contactOptionalLabel => 'संपर्क (वैकल्पिक)';

  @override
  String get phoneOrEmailHint => 'फोन या ईमेल';

  @override
  String get approvalStatusLabel => 'अनुमोदन स्थिति';

  @override
  String get addSupplierButton => 'आपूर्तिकर्ता जोड़ें';

  @override
  String venueSetupStepTitle(int step) {
    return 'वेन्यू सेटअप - चरण $step / 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'मॉडल: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'सीरियल नंबर: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (सेवानिवृत्त)';
  }

  @override
  String get addEquipmentTooltip => 'उपकरण जोड़ें';

  @override
  String get newPinLabel => 'नया पिन';

  @override
  String get editDetailsTitle => 'विवरण संपादित करें';

  @override
  String get sectionLabel => 'अनुभाग';

  @override
  String get noSectionOption => 'कोई अनुभाग नहीं';

  @override
  String get inactiveParenSuffix => ' (निष्क्रिय)';

  @override
  String get noSpecificTeamOption => 'कोई विशिष्ट टीम नहीं';

  @override
  String get noSectionsSetupText =>
      'इस वेन्यू में अभी तक कोई अनुभाग सेट नहीं किया गया - पहले विभाग प्रबंधन में एक जोड़ें।';

  @override
  String get reportsToFieldLabel => 'रिपोर्ट करता है';

  @override
  String get notSetOption => 'सेट नहीं';

  @override
  String get deactivateStaffMemberTitle => 'स्टाफ सदस्य निष्क्रिय करें';

  @override
  String get staffManagementTitle => 'स्टाफ प्रबंधन';

  @override
  String get addStaffTooltip => 'स्टाफ जोड़ें';

  @override
  String get bulkImportTooltip => 'बल्क आयात';

  @override
  String get deactivatedSuffixLabel => '(निष्क्रिय)';

  @override
  String get moreActionsTooltip => 'अधिक कार्रवाइयां';

  @override
  String get changeTierMenuItem => 'स्तर बदलें';

  @override
  String get changeSectionMenuItem => 'अनुभाग बदलें';

  @override
  String get assignSupervisionMenuItem => 'पर्यवेक्षण असाइन करें';

  @override
  String get reportsToMenuItem => 'रिपोर्ट करता है';

  @override
  String get resetPinMenuItem => 'पिन रीसेट करें';

  @override
  String get trainingRecordsMenuItem => 'प्रशिक्षण रिकॉर्ड';

  @override
  String unknownUserIdFallback(String id) {
    return 'उपयोगकर्ता #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'पिन रीसेट करें - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return '$name के लिए पिन रीसेट किया गया';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'भूमिका स्तर बदलें - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'अनुभाग बदलें - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'पर्यवेक्षण असाइन करें - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return '$name के लिए पर्यवेक्षण दायरा अपडेट किया गया';
  }

  @override
  String reportsToTitle(String name) {
    return 'रिपोर्ट करता है - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name अब लॉग इन नहीं कर पाएंगे। उनके सक्रिय कार्य असाइनमेंट अनअसाइन हो जाएंगे। उनका सबमिशन इतिहास प्रभावित नहीं होगा। इसे बाद में वापस पलटा जा सकता है।';
  }

  @override
  String reportsToSubtitle(String name) {
    return '$name को रिपोर्ट करता है';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return '$date को $name द्वारा';
  }

  @override
  String get darkModeLabel => 'डार्क मोड';

  @override
  String get brandIdentityIntro =>
      'एक ब्रांड पहचान, पूरी कंपनी में साझा - हर वेन्यू पर लागू होती है, प्रति-साइट नहीं।';

  @override
  String get companyNameLabel => 'कंपनी का नाम';

  @override
  String get companyLogoLabel => 'कंपनी लोगो';

  @override
  String get chooseLogoButton => 'लोगो चुनें';

  @override
  String get changeLogoButton => 'लोगो बदलें';

  @override
  String get brandColourLabel => 'ब्रांड रंग';

  @override
  String get customHexColourLabel => 'कस्टम हेक्स रंग';

  @override
  String get enterValidHexColourError => 'एक मान्य हेक्स रंग दर्ज करें';

  @override
  String get contactPhoneLabel => 'संपर्क फोन';

  @override
  String get contactEmailLabel => 'संपर्क ईमेल';

  @override
  String get savingEllipsisLabel => 'सहेजा जा रहा है...';

  @override
  String get saveBrandingButton => 'ब्रांडिंग सहेजें';

  @override
  String get brandingSavedMessage => 'ब्रांडिंग सहेजी गई';

  @override
  String get customSwatchTooltip => 'कस्टम';

  @override
  String get rosterAddonTitle => 'स्टाफ शिफ्ट/रोस्टर (+£6-£10/शाखा/महीना)';

  @override
  String get rosterAddonSubtitle =>
      'स्टाफ को खुद खुली शिफ्ट देखने और लेने दें - मैनेजर शिफ्ट पोस्ट करता है, स्टाफ उन्हें चुनता है। 10 से कम स्टाफ वाली शाखा के लिए £6/महीना, 10 या अधिक के लिए £10/महीना।';

  @override
  String get enableRosterTitle => 'रोस्टर सक्षम करें?';

  @override
  String get confirmButton => 'पुष्टि करें';

  @override
  String get clearDemoDataTitle => 'डेमो डेटा साफ़ करें?';

  @override
  String get clearDemoDataConfirmText =>
      'यह हर डेमो स्टाफ सदस्य, शाखा और विभाग को स्थायी रूप से हटा देता है, और तुम्हें लॉग आउट कर देता है। इसे वापस नहीं किया जा सकता।';

  @override
  String get clearEverythingButton => 'सब कुछ साफ़ करें';

  @override
  String get clearDemoDataCardTitle => 'डेमो डेटा साफ़ करें';

  @override
  String get clearDemoDataCardBody =>
      'हर डेमो स्टाफ सदस्य, शाखा और विभाग हटाओ ताकि तुम अपना खुद का सेटअप शुरुआत से कर सको।';

  @override
  String get clearDemoDataButton => 'डेमो डेटा साफ़ करें';

  @override
  String get temperatureUnitLabel => 'तापमान इकाई';

  @override
  String get celsiusLabel => 'सेल्सियस (°C)';

  @override
  String get fahrenheitLabel => 'फ़ारेनहाइट (°F)';

  @override
  String get comingSoonLabel => 'जल्द आ रहा है';

  @override
  String get presetColorOceanTeal => 'ओशन टील';

  @override
  String get presetColorNavy => 'नेवी';

  @override
  String get presetColorIndigo => 'इंडिगो';

  @override
  String get presetColorSlate => 'स्लेट';

  @override
  String get presetColorPlum => 'प्लम';

  @override
  String get presetColorForest => 'फॉरेस्ट';

  @override
  String get presetColorUmber => 'अंबर';

  @override
  String get presetColorCharcoal => 'चारकोल';

  @override
  String couldNotGetPriceError(String error) {
    return 'कीमत प्राप्त नहीं हो सकी: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'तुम्हारे मौजूदा स्टाफ की संख्या के आधार पर, यह तुम्हारे मासिक डायरेक्ट डेबिट में $amount जोड़ देगा।';
  }

  @override
  String get departmentLabel => 'विभाग';

  @override
  String get noDepartmentOption => 'कोई विभाग नहीं';

  @override
  String get removeAnywayButton => 'फिर भी हटाएं';

  @override
  String get branchTeamStructureTitle => 'शाखा टीम संरचना';

  @override
  String get noStaffAtBranchText => 'इस शाखा में अभी तक कोई स्टाफ नहीं है।';

  @override
  String get changeManagerMenuItem => 'प्रबंधक बदलें';

  @override
  String get moveDepartmentMenuItem => 'विभाग/टीम बदलें';

  @override
  String get editJobTitleMenuItem => 'पद संपादित करें';

  @override
  String get removeFromBranchMenuItem => 'इस शाखा से हटाएं';

  @override
  String changeManagerTitle(String name) {
    return 'प्रबंधक बदलें - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'विभाग/टीम बदलें - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'स्तर बदलें - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'पद संपादित करें - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return '$name को इस शाखा से हटाएं';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name अब लॉग इन नहीं कर पाएंगे। इसे बाद में वापस पलटा जा सकता है।';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    return 'फिलहाल $count लोग $name को रिपोर्ट करते हैं: $names। $name को हटाने से वे तब तक अनअसाइन रह जाएंगे जब तक पुनः असाइन न किया जाए।';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'इसके बजाय उन्हें $name के अपने प्रबंधक को पुनः सौंपें';
  }

  @override
  String reportsCountBadge(int count) {
    return '$count अधीनस्थ';
  }

  @override
  String get regionalManagerAssignedTitle => 'क्षेत्रीय प्रबंधक असाइन किया गया';

  @override
  String get noOrganisationOnSessionError => 'इस सत्र में कोई कंपनी नहीं है।';

  @override
  String get newRegionNameTitle => 'नया क्षेत्र नाम';

  @override
  String get renameRegionTitle => 'क्षेत्र का नाम बदलें';

  @override
  String get renameVenueTitle => 'वेन्यू का नाम बदलें';

  @override
  String get newVenueNameTitle => 'नया वेन्यू नाम';

  @override
  String get doneButton => 'हो गया';

  @override
  String get resetPasswordQuestionTitle => 'पासवर्ड रीसेट करें?';

  @override
  String get resetButton => 'रीसेट करें';

  @override
  String get passwordResetTitle => 'पासवर्ड रीसेट किया गया';

  @override
  String get giveNewTempPasswordText =>
      'इस व्यक्ति को उनका नया अस्थायी पासवर्ड दें।';

  @override
  String get organisationTitle => 'कंपनी';

  @override
  String get headOfficeLabel => 'मुख्यालय';

  @override
  String get addRegionMenuItem => 'क्षेत्र जोड़ें';

  @override
  String get addVenueNoRegionMenuItem => 'वेन्यू जोड़ें (कोई क्षेत्र नहीं)';

  @override
  String get venuesNoRegionLabel => 'वेन्यूज़ (कोई क्षेत्र नहीं)';

  @override
  String get resetPasswordTooltip => 'पासवर्ड रीसेट करें';

  @override
  String get addVenueMenuItem => 'वेन्यू जोड़ें';

  @override
  String get assignRegionalManagerMenuItem => 'क्षेत्रीय प्रबंधक असाइन करें';

  @override
  String get reassignRegionalManagerMenuItem =>
      'क्षेत्रीय प्रबंधक पुनः असाइन करें';

  @override
  String get noRegionalManagerYetText => 'अभी तक कोई क्षेत्रीय प्रबंधक नहीं';

  @override
  String get noVenuesInRegionText =>
      'इस क्षेत्र में अभी तक कोई वेन्यू नहीं है।';

  @override
  String get noVenueManagerYetText => 'अभी तक कोई वेन्यू प्रबंधक नहीं';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'क्षेत्रीय प्रबंधक असाइन करें - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'खाता अब सक्रिय है। $name को उनके साइन-इन विवरण दें - वे लीडरशिप एक्सेस का उपयोग करते हैं।';
  }

  @override
  String emailColonLabel(String email) {
    return 'ईमेल: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'अस्थायी पासवर्ड: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'यह तुरंत $name का मौजूदा पासवर्ड अमान्य कर देता है। तुम्हें आगे देने के लिए एक नया अस्थायी पासवर्ड मिलेगा।';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  वेन्यू प्रबंधक';
  }

  @override
  String get noSignedInUserError => 'कोई साइन-इन उपयोगकर्ता नहीं मिला।';

  @override
  String get customCategoryTitleLabel => 'कस्टम श्रेणी शीर्षक';

  @override
  String get approvalNoteLabel => 'अनुमोदन / ड्यू-डिलिजेंस नोट (वैकल्पिक)';

  @override
  String get supplierManagementTitle => 'आपूर्तिकर्ता प्रबंधन';

  @override
  String get noSuppliersAddedYetText =>
      'अभी तक कोई आपूर्तिकर्ता नहीं जोड़ा गया।';

  @override
  String get inactiveStandaloneLabel => '(निष्क्रिय)';

  @override
  String get changeApprovalStatusMenuItem => 'अनुमोदन स्थिति बदलें';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'विवरण संपादित करें - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'अनुमोदन स्थिति बदलें - $name';
  }

  @override
  String get newVenueTypeTitle => 'नया वेन्यू प्रकार';

  @override
  String get renameOrganisationTitle => 'कंपनी का नाम बदलें';

  @override
  String get resetSetupCodeTitle => 'सेटअप कोड रीसेट करें?';

  @override
  String get resetSetupCodeConfirmText =>
      'यह इस वेन्यू का उपयोग करने वाले हर टैबलेट को तब तक डिस्कनेक्ट कर देगा जब तक उन्हें नया कोड नहीं दिया जाता। जारी रखें?';

  @override
  String get resetCodeButton => 'कोड रीसेट करें';

  @override
  String get createNewVenueTitle => 'नया वेन्यू बनाएं';

  @override
  String get multiSiteSupportPartialText =>
      'मल्टी-साइट समर्थन आंशिक है: उपकरण, स्टाफ और कार्य सूचियां अभी तक वेन्यू के अनुसार फ़िल्टर नहीं की गई हैं, इसलिए दूसरे वेन्यू के दैनिक उपयोग को अभी पूरी तरह समर्थित नहीं किया गया है। एक बनाना सुरक्षित है, लेकिन जब तक यह नहीं बन जाता, तुम इस वेन्यू और मूल वेन्यू का डेटा साझा सूचियों में मिला हुआ देखोगे।';

  @override
  String get createButton => 'बनाएं';

  @override
  String get venueDetailsTitle => 'वेन्यू विवरण';

  @override
  String get billingLabel => 'बिलिंग';

  @override
  String get billingSubtitleText => 'प्लान, स्थिति, डायरेक्ट डेबिट';

  @override
  String get activeLabel => 'सक्रिय';

  @override
  String get setAsActiveButton => 'सक्रिय के रूप में सेट करें';

  @override
  String get tabletSetupCodeTitle => 'टैबलेट सेटअप कोड';

  @override
  String get tabletSetupCodeExplanation =>
      'इसे एक बार नए टैबलेट पर दर्ज करें ताकि वह इस वेन्यू की स्टाफ सूची दिखा सके।';

  @override
  String get generateCodeButton => 'कोड जनरेट करें';

  @override
  String get venueTypeSectionTitle => 'वेन्यू प्रकार';

  @override
  String get renamePresetTitle => 'प्रीसेट का नाम बदलें';

  @override
  String get noTaskTemplatesExistYetText =>
      'अभी तक कोई कार्य टेम्पलेट मौजूद नहीं है।';

  @override
  String get addTaskToPresetTitle => 'प्रीसेट में कार्य जोड़ें';

  @override
  String get taskFieldLabel => 'कार्य';

  @override
  String get defaultFrequencyLabel => 'डिफ़ॉल्ट आवृत्ति';

  @override
  String get noPresetsYetText => 'अभी तक कोई प्रीसेट नहीं।';

  @override
  String get createPresetButton => 'प्रीसेट बनाएं';

  @override
  String get presetVerificationBannerText =>
      'कार्य सीमाएं शोध की गई हैं और स्रोत सहित हैं (प्रत्येक कार्य के निर्देशों में [LAW]/[FSA]/[BEST] टैग की गई हैं) लेकिन अभी तक किसी योग्य खाद्य सुरक्षा पेशेवर द्वारा हस्ताक्षरित नहीं हैं। सत्यापित होने तक इन्हें कानूनी रूप से आधिकारिक न मानें।';

  @override
  String get equipmentPresetsSectionTitle => 'उपकरण प्रीसेट';

  @override
  String get sectionPresetsSectionTitle => 'अनुभाग प्रीसेट';

  @override
  String get addTaskButton => 'कार्य जोड़ें';

  @override
  String get newPresetSectionTitle => 'नया प्रीसेट';

  @override
  String get sectionSegmentOptionalLabel => 'अनुभाग / सेगमेंट (वैकल्पिक)';

  @override
  String get setEquipmentOrSectionHint =>
      'एक उपकरण प्रकार या एक अनुभाग सेट करें (कम से कम एक)।';

  @override
  String equipmentTypeFallback(String id) {
    return 'उपकरण प्रकार #$id';
  }

  @override
  String taskFallback(String id) {
    return 'कार्य #$id';
  }

  @override
  String get departmentCategoryKitchen => 'रसोई';

  @override
  String get departmentCategoryFrontOfHouse => 'फ्रंट ऑफ हाउस';

  @override
  String get departmentCategoryBar => 'बार';

  @override
  String get departmentCategoryManagement => 'प्रबंधन';

  @override
  String get departmentCategoryMaintenance => 'रखरखाव';

  @override
  String get departmentCategoryHousekeeping => 'हाउसकीपिंग';

  @override
  String get departmentCategoryReception => 'रिसेप्शन';

  @override
  String get departmentCategorySecurity => 'सुरक्षा';

  @override
  String get addDepartmentButton => 'विभाग जोड़ें';

  @override
  String get departmentManagementTitle => 'विभाग प्रबंधन';

  @override
  String get noDepartmentsAddedYetText => 'अभी तक कोई विभाग नहीं जोड़ा गया।';

  @override
  String get noTeamsYetText => 'अभी तक कोई टीम नहीं';

  @override
  String get editMenuItem => 'संपादित करें';

  @override
  String get addTeamButton => 'टीम जोड़ें';

  @override
  String editDepartmentTitle(String name) {
    return 'संपादित करें - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'टीम जोड़ें - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'नाम बदलें - $name';
  }

  @override
  String teamCountLabel(int count) {
    return '$count टीमें';
  }

  @override
  String get documentCategoryPolicy => 'नीति';

  @override
  String get documentCategoryCertificate => 'प्रमाणपत्र';

  @override
  String get documentCategoryProcedure => 'प्रक्रिया';

  @override
  String get documentCategoryEhoReport => 'EHO रिपोर्ट';

  @override
  String get addDocumentTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get noExpiryDateText => 'कोई समाप्ति तिथि नहीं';

  @override
  String get setExpiryButton => 'समाप्ति निर्धारित करें';

  @override
  String get couldNotOpenFileText => 'यह फ़ाइल नहीं खोली जा सकी।';

  @override
  String get documentCentreTitle => 'दस्तावेज़ केंद्र';

  @override
  String get validLabel => 'मान्य';

  @override
  String get expiringSoonLabel => 'जल्द समाप्त होने वाला';

  @override
  String get expiredLabel => 'समाप्त';

  @override
  String get allFilterLabel => 'सभी';

  @override
  String get noDocumentsYetText => 'अभी तक कोई दस्तावेज़ नहीं।';

  @override
  String get openMenuItem => 'खोलें';

  @override
  String expiresOnLabel(String date) {
    return '$date को समाप्त होता है';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'कोई प्लान चयनित नहीं';

  @override
  String get codeNotRecognisedText => 'वह कोड पहचाना नहीं गया।';

  @override
  String get couldNotReachServerText => 'सर्वर तक नहीं पहुंचा जा सका।';

  @override
  String get discountAppliedText => 'डिस्काउंट कोड लागू किया गया।';

  @override
  String get couldNotOpenBrowserText => 'ब्राउज़र नहीं खोला जा सका';

  @override
  String get noSubscriptionFoundText =>
      'इस कंपनी के लिए कोई सदस्यता नहीं मिली।';

  @override
  String get discountAppliedBadge => 'छूट लागू';

  @override
  String get directDebitSetUpText =>
      'इस कंपनी के लिए डायरेक्ट डेबिट सेट अप है।';

  @override
  String get directDebitNotSetUpText =>
      'तुमने अभी तक डायरेक्ट डेबिट सेट अप नहीं किया है। तुम्हें GoCardless पर ले जाया जाएगा - VenuRite तुम्हारे बैंक विवरण सीधे कभी नहीं देखता।';

  @override
  String get discountCodeOptionalLabel => 'डिस्काउंट कोड (वैकल्पिक)';

  @override
  String get discountCodeHintText =>
      'क्या तुम्हारे पास \'Friends\' कोड है? इसे यहां दर्ज करो';

  @override
  String get setUpDirectDebitButton => 'डायरेक्ट डेबिट सेट करें';

  @override
  String get freeAccessCodeTitle => 'मुफ्त-पहुंच कोड';

  @override
  String get freeAccessActiveText =>
      'इस कंपनी के लिए मुफ्त पहुंच सक्रिय है - कोई डायरेक्ट डेबिट या कार्ड भुगतान आवश्यक नहीं।';

  @override
  String get freeAccessPromptText =>
      'क्या तुम्हारे पास मुफ्त-पहुंच कोड है? भुगतान सेट किए बिना पूरा ऐप उपयोग करने के लिए इसे यहां दर्ज करो।';

  @override
  String get redeemCodeButton => 'कोड रिडीम करें';

  @override
  String get onTrialText => 'ट्रायल पर';

  @override
  String get paymentFailedGraceText =>
      'हाल ही में एक भुगतान विफल हुआ। कृपया अपना डायरेक्ट डेबिट अपडेट करो - इस छूट अवधि के दौरान पहुंच जारी रहती है।';

  @override
  String get directDebitCancelledRestrictedText =>
      'तुम्हारा डायरेक्ट डेबिट रद्द कर दिया गया था। बिलिंग फिर से सेट होने तक पहुंच केवल पढ़ने तक सीमित है।';

  @override
  String get paymentOverdueRestrictedText =>
      'भुगतान बहुत लंबे समय से बकाया है। इसका समाधान होने तक पहुंच केवल पढ़ने तक सीमित है।';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'बिलिंग विवरण लोड नहीं हो सका: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '£$price/महीना ($units शाखाएं बिल की गईं)';
  }

  @override
  String onTrialUntilText(String date) {
    return '$date तक ट्रायल पर';
  }

  @override
  String get reportedIssuesTitle => 'रिपोर्ट की गई समस्याएं';

  @override
  String get noDeliveriesLoggedText =>
      'इस अवधि में इस आपूर्तिकर्ता के लिए कोई डिलीवरी दर्ज नहीं की गई।';

  @override
  String get scorecardCategoriesExplanation =>
      'नीचे दी गई प्रत्येक श्रेणी स्वतंत्र रूप से गिनी जाती है - एक डिलीवरी एक से अधिक पंक्ति में दिखाई दे सकती है (जैसे देर से और क्षतिग्रस्त दोनों)।';

  @override
  String get rejectedOutrightLabel => 'पूरी तरह अस्वीकृत';

  @override
  String get acceptedPartiallyLabel => 'आंशिक रूप से स्वीकृत';

  @override
  String get reportedIssuesExplanation =>
      'इस आपूर्तिकर्ता के खिलाफ रिपोर्ट की गई आपूर्ति-समस्या के मुद्दे - ऊपर दिए गए डिलीवरी स्कोरकार्ड से एक अलग लॉग, इसमें मिलाया नहीं गया।';

  @override
  String deliveryScorecardTitle(int count) {
    return 'डिलीवरी स्कोरकार्ड ($count डिलीवरी)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'नाम गायब है';

  @override
  String get missingJobTitleError => 'पद गायब है';

  @override
  String get pinMustBe4DigitsError =>
      'पिन बिल्कुल 4 अंकों का होना चाहिए (या खाली छोड़ें)';

  @override
  String get bulkStaffImportTitle => 'बल्क स्टाफ आयात';

  @override
  String get csvColumnsInstructionsText =>
      'CSV कॉलम: नाम, पद, भूमिका स्तर, नौकरी भूमिका (वैकल्पिक), पिन (वैकल्पिक)। हेडर पंक्ति ठीक है - यह स्वचालित रूप से पहचानी जाती है। तुम्हारे लिए एक जनरेट करने के लिए पिन खाली छोड़ें।';

  @override
  String get chooseCsvFileButton => 'CSV फ़ाइल चुनें';

  @override
  String get chooseDifferentFileButton => 'एक अलग फ़ाइल चुनें';

  @override
  String get noteDownPinsText =>
      ' इस स्क्रीन को छोड़ने से पहले नीचे प्रत्येक पिन नोट कर लें।';

  @override
  String get importingEllipsisLabel => 'आयात हो रहा है...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'भूमिका स्तर इनमें से एक होना चाहिए: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'तुम्हें $tier खाता बनाने की अनुमति नहीं है';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'नौकरी भूमिका इनमें से एक होनी चाहिए: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'उदाहरण: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - $count पंक्तियां मिलीं';
  }

  @override
  String needFixingSuffix(int count) {
    return ', $count को ठीक करने की ज़रूरत है';
  }

  @override
  String createdCountLabel(int count) {
    return '$count बनाए गए';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count विफल';
  }

  @override
  String importStaffCountButton(int count) {
    return '$count स्टाफ सदस्यों को आयात करें';
  }

  @override
  String rowNumberFallback(int number) {
    return 'पंक्ति $number';
  }

  @override
  String jobTitleTierLabel(String jobTitle, String tier) {
    return '$jobTitle - $tier';
  }

  @override
  String pinSuffixLabel(String pin) {
    return ' - पिन: $pin';
  }

  @override
  String get trainingLevel2FoodHygiene => 'स्तर 2 खाद्य स्वच्छता और सुरक्षा';

  @override
  String get trainingAllergenAwareness => 'एलर्जन जागरूकता';

  @override
  String get trainingCoshh =>
      'COSHH (स्वास्थ्य के लिए खतरनाक पदार्थों का नियंत्रण)';

  @override
  String get trainingFireSafety => 'अग्नि सुरक्षा';

  @override
  String get trainingManualHandling => 'मैनुअल हैंडलिंग';

  @override
  String get trainingFirstAid => 'कार्यस्थल पर प्राथमिक चिकित्सा';

  @override
  String get trainingInduction => 'इंडक्शन पूर्ण';

  @override
  String get itemFieldLabel => 'आइटम';

  @override
  String get customItemTitleLabel => 'कस्टम आइटम शीर्षक';

  @override
  String get expiryNoneLabel => 'समाप्ति: कोई नहीं';

  @override
  String get clearExpiryTooltip => 'समाप्ति साफ़ करें';

  @override
  String get certificateReferenceLabel => 'प्रमाणपत्र संदर्भ (वैकल्पिक)';

  @override
  String get certificateReferenceHint => 'जैसे प्रमाणपत्र संख्या, प्रदाता';

  @override
  String get noTrainingRecordsYetText => 'अभी तक कोई प्रशिक्षण रिकॉर्ड नहीं।';

  @override
  String get addRecordButton => 'रिकॉर्ड जोड़ें';

  @override
  String get currentLabel => 'वर्तमान';

  @override
  String get supersededLabel => '(प्रतिस्थापित)';

  @override
  String get noExpiryLabel => 'कोई समाप्ति नहीं';

  @override
  String addTrainingRecordTitle(String name) {
    return 'प्रशिक्षण रिकॉर्ड जोड़ें - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'पूर्ण: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'समाप्ति: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'प्रशिक्षण रिकॉर्ड - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    return 'पूरा इतिहास ($count पुराने रिकॉर्ड)';
  }

  @override
  String completedDateLabel(String date) {
    return '$date को पूर्ण';
  }

  @override
  String certRefLabel(String ref) {
    return 'संदर्भ: $ref';
  }

  @override
  String get twoFactorNowOnText => 'टू-फैक्टर प्रमाणीकरण अब चालू है।';

  @override
  String get turnOffTwoFactorTitle => 'टू-फैक्टर प्रमाणीकरण बंद करें?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'यह खाता फिर से केवल पासवर्ड के साथ साइन इन करेगा।';

  @override
  String get turnOffButton => 'बंद करें';

  @override
  String get twoFactorAuthTitle => 'टू-फैक्टर प्रमाणीकरण';

  @override
  String get twoFactorOnText => 'इस खाते के लिए टू-फैक्टर प्रमाणीकरण चालू है।';

  @override
  String get twoFactorOffText =>
      'टू-फैक्टर प्रमाणीकरण बंद है - इस वरिष्ठ खाते पर सुरक्षा की एक अतिरिक्त परत के लिए इसे जोड़ें।';

  @override
  String get enableTwoFactorButton => 'टू-फैक्टर प्रमाणीकरण सक्षम करें';

  @override
  String get scanAuthenticatorText =>
      'इसे अपने ऑथेंटिकेटर ऐप (Google Authenticator, Authy, आदि) से स्कैन करें, फिर दिखाया गया 6 अंकों का कोड दर्ज करें।';

  @override
  String get cantScanManualEntryText =>
      'स्कैन नहीं कर सकते? इस कोड को मैन्युअल रूप से दर्ज करें:';

  @override
  String get requiredFieldError => 'आवश्यक';

  @override
  String get joinExistingCompanyTitle => 'मौजूदा कंपनी से जुड़ें';

  @override
  String get enterInviteCodeText =>
      'तुम्हारे मैनेजर द्वारा दिया गया आमंत्रण कोड दर्ज करो।';

  @override
  String get inviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get yourNameLabel => 'तुम्हारा नाम';

  @override
  String get yourEmailLabel => 'तुम्हारा ईमेल';

  @override
  String get enterValidEmailError => 'एक मान्य ईमेल दर्ज करो';

  @override
  String get choosePasswordLabel => 'पासवर्ड चुनो';

  @override
  String get joinButton => 'जुड़ें';

  @override
  String get youreInSignInText =>
      'तुम अंदर हो। अपने ईमेल और अभी चुने गए पासवर्ड से लॉग इन करो।';

  @override
  String get newBranchNameTitle => 'नई शाखा का नाम';

  @override
  String get renameBranchTitle => 'शाखा का नाम बदलें';

  @override
  String get branchManagerNameTitle => 'शाखा प्रबंधक का नाम';

  @override
  String get accountCreatedTitle => 'खाता बनाया गया';

  @override
  String get giveNameAndPinText =>
      'इस व्यक्ति को उनका नाम (लॉगिन स्क्रीन पर टैप करने के लिए) और यह पिन दें।';

  @override
  String get branchesTitle => 'शाखाएं';

  @override
  String get noRegionSetText =>
      'तुम्हारे खाते में कोई क्षेत्र सेट नहीं है - अपने डायरेक्टर से संपर्क करो।';

  @override
  String get noBranchesInRegionText =>
      'तुम्हारे क्षेत्र में अभी तक कोई शाखा नहीं है।';

  @override
  String get addBranchManagerMenuItem => 'शाखा प्रबंधक जोड़ें';

  @override
  String nameColonLabel(String name) {
    return 'नाम: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'पिन: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'चयनित साक्ष्य हटाएं?';

  @override
  String get deleteButton => 'हटाएं';

  @override
  String get photoEvidenceTitle => 'फोटो साक्ष्य';

  @override
  String get onThisDeviceLabel => 'इस डिवाइस पर';

  @override
  String get deletingFreesSpaceText =>
      'हटाने से डिवाइस की जगह भी खाली होती है। निर्यात की गई EHO PDF में पहले से ही अपनी प्रतियां हैं और प्रभावित नहीं होंगी।';

  @override
  String get noEvidencePhotosYetText => 'अभी तक कोई साक्ष्य फोटो नहीं।';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'यह इस डिवाइस से $count फ़ोटो ($bytes) को स्थायी रूप से हटा देता है। पहले से निर्यात की गई PDF प्रभावित नहीं होंगी। इसे वापस नहीं किया जा सकता।';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count साक्ष्य फ़ोटो · कुल $bytes';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return '$count चयनित हटाएं ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'टीम सदस्य जोड़ें';

  @override
  String get createsTapNamePinAccountText =>
      'तुम्हारे अपने वेन्यू के लिए टैप-नाम + पिन खाता बनाता है।';

  @override
  String get createAccountButton => 'खाता बनाएं';

  @override
  String get shiftLogTitle => 'शिफ्ट लॉग';

  @override
  String get noClockInsYetText => 'अभी तक कोई क्लॉक-इन दर्ज नहीं किया गया।';

  @override
  String get stillClockedInText => 'अभी भी क्लॉक-इन';

  @override
  String clockInLabel(String time) {
    return 'अंदर: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'बाहर: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '$hours घं $minutes मि';
  }

  @override
  String get inviteCreatedTitle => 'आमंत्रण बनाया गया';

  @override
  String get orShareCodeText =>
      'या यह कोड साझा करो - वे इसे \"मौजूदा कंपनी से जुड़ें\" स्क्रीन पर दर्ज करेंगे:';

  @override
  String shareInviteExpiresText(int days) {
    return 'इसे शामिल होने वाले व्यक्ति के साथ साझा करो - यह एक बार काम करता है और $days दिनों में समाप्त हो जाता है।';
  }

  @override
  String get contactVenuRiteTitle => 'VenuRite से संपर्क करें';

  @override
  String get contactVenuRiteIntroText =>
      'चाहे तुम एक बड़ा समूह हो जिसे सेटअप में मदद चाहिए, या बस कोई सवाल हो - हमें मदद करने में खुशी होगी।';

  @override
  String get emailUsButton => 'हमें ईमेल करें';

  @override
  String taskCountOverdueLabel(int count) {
    return '$count कार्य लंबित';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    return '$count स्टाफ सदस्यों में';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count और स्टाफ सदस्य';
  }

  @override
  String failCountLabel(int count) {
    return '$count विफलता';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count अधूरे';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    return '$count समस्याएं उठाई गईं';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'शिफ्ट सारांश - $name';
  }

  @override
  String get faqQ1 => 'मेरा लॉग कौन देख सकता है?';

  @override
  String get faqA1 =>
      'तुम्हारा मैनेजर और तुम्हारे वेन्यू में उनसे ऊपर कोई भी वह कार्य देख सकता है जो तुम पूरा करते हो। किसी नामित व्यक्ति को कभी भी रेटेड स्कोर या लीग टेबल नहीं दिखाई जाती - केवल यह सादा सूची कि उन्होंने क्या और कब किया।';

  @override
  String get faqQ2 =>
      'अगर मैं अपनी शिफ्ट के दौरान कोई कार्य चूक जाऊं तो क्या होगा?';

  @override
  String get faqA2 =>
      'इसे विफलता के रूप में नहीं, बल्कि अधूरा दर्ज किया जाता है - शिफ्ट के बीच में छोड़ा गया कार्य एक अपेक्षित, अनुमत व्यवहार है, बस इसे कभी छिपाया नहीं जाता। तुम्हारा मैनेजर इसे अपनी अलग, विशिष्ट स्थिति के रूप में देखता है।';

  @override
  String get faqQ3 => 'क्या मैं वापस जाकर छोड़ा हुआ कार्य पूरा कर सकता हूं?';

  @override
  String get faqA3 =>
      'हां, तुम्हारी शिफ्ट खत्म होने से पहले किसी भी समय - यह तुम्हारे कार्य सूची में तब तक उपलब्ध रहता है जब तक तुम इसे पूरा नहीं करते या तुम्हारी शिफ्ट खत्म नहीं होती।';

  @override
  String get faqQ4 =>
      'अगर मैं कोई जांच में विफल हो जाऊं (जैसे फ्रिज बहुत गर्म है) तो क्या करूं?';

  @override
  String get faqA4 =>
      'इसे विफलता के रूप में दर्ज करो, तुमने जो सुधारात्मक कार्रवाई की (या इसकी रिपोर्ट की) उसे रिकॉर्ड करो, और मांगे जाने पर एक फोटो जोड़ो। यह वास्तव में इसी के लिए सिस्टम है - एक सुधार के साथ दर्ज विफलता एक निरीक्षक के लिए सफलता की कहानी है, तुम्हारे लिए समस्या नहीं।';

  @override
  String get faqQ5 => 'क्या मुझे लॉगिन से अलग क्लॉक-इन और क्लॉक-आउट करना होगा?';

  @override
  String get faqA5 =>
      'नहीं - तुम्हारी शिफ्ट की शुरुआत में अपने पिन से लॉगिन करना ही तुम्हारा क्लॉक-इन है। समाप्त करते समय \'शिफ्ट समाप्त करें\' का उपयोग करो, जो तुम्हें वह सब भी दिखाता है जो तुम्हें अभी भी पूरा करना है।';

  @override
  String get faqQ6 => 'मैंने एक समस्या उठाई - उसका क्या होता है?';

  @override
  String get faqA6 =>
      'यह तुम्हारे मैनेजर के पास जाती है (या समय पर संभाला न जाए तो आगे एस्केलेट होती है)। तुम \"मेरी उठाई गई समस्याएं\" से कभी भी इसकी स्थिति देख सकते हो।';

  @override
  String get troubleQ1 => 'मेरा पिन काम नहीं कर रहा';

  @override
  String get troubleA1 =>
      'दोबारा जांचो कि तुम पहले अपना नाम टैप कर रहे हो, फिर पिन दर्ज कर रहे हो - सही नाम पर गलत पिन एक स्पष्ट अस्वीकृति संदेश देता है। अगर फिर भी काम न करे, तो मैनेजर से कहो कि वे जांचें कि तुम्हारा खाता सक्रिय है और जरूरत पड़ने पर तुम्हारा पिन रीसेट करें।';

  @override
  String get troubleQ2 => 'मेरी सूची से एक कार्य गायब है जो मुझे होना चाहिए था';

  @override
  String get troubleA2 =>
      'अपने मैनेजर से कहो कि वे कार्य असाइन करें में जांचें कि यह तुम्हारी भूमिका/अनुभाग को सौंपा गया है। कार्य केवल उन भूमिकाओं और विभागों के लिए दिखाई देते हैं जिनके लिए उन्हें चालू किया गया है।';

  @override
  String get troubleQ3 => 'ऐप मुझे फोटो नहीं लेने दे रहा';

  @override
  String get troubleA3 =>
      'सुनिश्चित करो कि ऐप के पास कैमरा अनुमति है (अपनी डिवाइस सेटिंग्स जांचो)। विंडोज़ पर, अगर कोई कैमरा नहीं मिलता, तो इसके बजाय तुम्हें फाइल पिकर दिया जाएगा।';

  @override
  String get troubleQ4 =>
      'मैं जांच सबमिट नहीं कर सकता / सबमिट दबाने पर कुछ नहीं होता';

  @override
  String get troubleA4 =>
      'ऐसा तब हो सकता है जब तुम्हारे संगठन के खाते को बिलिंग ध्यान की जरूरत हो - अगर ऐसा है तो तुम्हें स्पष्ट संदेश दिखाई देगा। अन्यथा, जांचो कि हर आवश्यक फ़ील्ड (किसी भी फोटो सहित) भरा गया है।';

  @override
  String get troubleQ5 => 'ऐप अटका हुआ / फ्रीज़ लग रहा है';

  @override
  String get troubleA5 =>
      'इसे बंद करके फिर से खोलने की कोशिश करो। तुम्हारे अंतिम पूर्ण किए गए कार्य तक की प्रगति हमेशा सहेजी जाती रहती है, इसलिए पहले से सबमिट किया गया कुछ भी नहीं खोता।';

  @override
  String get troubleQ6 => 'मुझे कल जैसे कार्य नहीं दिख रहे';

  @override
  String get troubleA6 =>
      'यह अपेक्षित है अगर तुम्हारे शेड्यूल में तदर्थ कार्य, या समय विंडो से जुड़े कार्य शामिल हैं - वे केवल तब दिखाई देते हैं जब देय हों। अगर कुछ वास्तव में गलत लगे तो अपने मैनेजर से पूछो।';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - $date से लंबित';
  }

  @override
  String get uploadCertificateDocumentButton => 'प्रमाणपत्र फ़ोटो अपलोड करें';

  @override
  String get certificateDocumentUploadedLabel => 'प्रमाणपत्र अपलोड हो गया';

  @override
  String get viewCertificateDocumentTooltip => 'प्रमाणपत्र दस्तावेज़ देखें';

  @override
  String get certificateUploadFailed =>
      'प्रमाणपत्र अपलोड नहीं हो सका। कृपया पुनः प्रयास करें।';

  @override
  String get certificationRequirementsTitle => 'प्रमाणन आवश्यकताएं';

  @override
  String get certificationRequirementsFloorNotice =>
      'कुछ प्रमाणपत्र कुछ भूमिकाओं के लिए हमेशा आवश्यक होते हैं और यहां हटाए नहीं जा सकते (जैसे, खाद्य प्रबंधन भूमिकाओं के लिए हमेशा लेवल 2 फूड हाइजीन और एलर्जन अवेयरनेस आवश्यक है)। आप नीचे अतिरिक्त आवश्यकताएं जोड़ सकते हैं।';

  @override
  String get noExtraCertificationRequirementsText =>
      'अभी तक कोई अतिरिक्त आवश्यकता नहीं जोड़ी गई।';

  @override
  String get addRequirementButton => 'आवश्यकता जोड़ें';

  @override
  String get addCertificationRequirementTitle => 'प्रमाणन आवश्यकता जोड़ें';

  @override
  String get removeCertificationRequirementTitle => 'इस आवश्यकता को हटाएं?';

  @override
  String get removeCertificationRequirementBody =>
      'इस भूमिका के कर्मचारियों को अब शेड्यूल होने के लिए इस प्रमाणपत्र की आवश्यकता नहीं होगी। इससे हमेशा आवश्यक प्रमाणपत्रों पर कोई असर नहीं पड़ता।';

  @override
  String get removeButton => 'हटाएं';

  @override
  String get cannotClaimShiftTitle => 'आप अभी इस शिफ्ट को नहीं ले सकते';

  @override
  String missingCertificationsMessage(String certs) {
    return 'इस भूमिका के लिए निम्नलिखित आवश्यक हैं, जो गुम या समाप्त हो चुके हैं: $certs। इन्हें नवीनीकृत करने के बारे में अपने मैनेजर से पूछें।';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return '$name को यह शिफ्ट नहीं सौंपी जा सकती';
  }

  @override
  String get allergenCelery => 'अजवाइन';

  @override
  String get allergenGluten => 'ग्लूटेन युक्त अनाज';

  @override
  String get allergenCrustaceans => 'क्रस्टेशियन';

  @override
  String get allergenEggs => 'अंडे';

  @override
  String get allergenFish => 'मछली';

  @override
  String get allergenLupin => 'ल्यूपिन';

  @override
  String get allergenMilk => 'दूध';

  @override
  String get allergenMolluscs => 'मोलस्क';

  @override
  String get allergenMustard => 'सरसों';

  @override
  String get allergenTreeNuts => 'मेवे';

  @override
  String get allergenPeanuts => 'मूंगफली';

  @override
  String get allergenSesame => 'तिल के बीज';

  @override
  String get allergenSoya => 'सोया';

  @override
  String get allergenSulphites => 'सल्फर डाइऑक्साइड और सल्फाइट्स';

  @override
  String get allergenStatusContains => 'इसमें है';

  @override
  String get allergenStatusMayContain => 'हो सकता है';

  @override
  String get menuManagementTitle => 'मेनू और एलर्जन';

  @override
  String get addDishButton => 'व्यंजन जोड़ें';

  @override
  String get addDishTitle => 'एक व्यंजन जोड़ें';

  @override
  String get dishNameLabel => 'व्यंजन का नाम';

  @override
  String get dishCategoryLabel => 'श्रेणी (वैकल्पिक)';

  @override
  String get noDishesYetText => 'अभी तक कोई व्यंजन नहीं जोड़ा गया।';

  @override
  String get draftLabel => 'ड्राफ्ट';

  @override
  String get addIngredientTitle => 'सामग्री जोड़ें';

  @override
  String get ingredientNameLabel => 'सामग्री का नाम';

  @override
  String get addButton => 'जोड़ें';

  @override
  String get addIngredientButton => 'सामग्री जोड़ें';

  @override
  String get ingredientsHeading => 'सामग्री';

  @override
  String get suggestedAllergensHeading => 'सुझाए गए एलर्जन (अभी प्रकाशित नहीं)';

  @override
  String get publishedAllergensHeading => 'प्रकाशित एलर्जन';

  @override
  String get noAllergensIdentifiedText =>
      'वर्तमान सामग्री से कोई एलर्जन नहीं पाया गया।';

  @override
  String get reviewAllergensTitle =>
      'प्रकाशित करने से पहले एलर्जन की समीक्षा करें';

  @override
  String get allergenStatusNone => 'कोई नहीं';

  @override
  String get approveButton => 'स्वीकृत करें और प्रकाशित करें';

  @override
  String get reviewAndApproveButton => 'समीक्षा करें और स्वीकृत करें';

  @override
  String get reviewAndReapproveButton => 'समीक्षा करें और पुनः स्वीकृत करें';

  @override
  String get allergenMatrixTitle => 'एलर्जन मैट्रिक्स';

  @override
  String get allergenMatrixLegend => 'संकेत';

  @override
  String get noApprovedDishesYetText =>
      'अभी तक कोई व्यंजन स्वीकृत नहीं हुआ। मेनू और एलर्जन में व्यंजनों की समीक्षा और स्वीकृति के लिए मैनेजर से कहें।';

  @override
  String get exportAsPdfButton => 'PDF के रूप में निर्यात करें';

  @override
  String get allergenMatrixSubtitle =>
      'ग्राहक तक पहुंचने से पहले व्यंजन में क्या है, जांच लें';

  @override
  String get assignmentRejectedMessage =>
      'यह असाइनमेंट अस्वीकृत कर दिया गया। कृपया कर्मचारी की भूमिका और प्रमाणपत्र जांचें और पुनः प्रयास करें।';

  @override
  String get sopTemplateCleaningSchedule => 'सफाई अनुसूची';

  @override
  String get sopTemplateAllergenControl => 'एलर्जन नियंत्रण';

  @override
  String get sopTemplateDeliveryAndStorage => 'डिलीवरी और भंडारण';

  @override
  String get sopTemplatePersonalHygiene => 'व्यक्तिगत स्वच्छता';

  @override
  String get sopTemplatePestControl => 'कीट नियंत्रण';

  @override
  String get generateSopTitle => 'एसओपी दस्तावेज़ बनाएं';

  @override
  String get sopGenerationDisclaimer =>
      'यह सामान्य यूके खाद्य सुरक्षा प्रथाओं का उपयोग करके AI द्वारा तैयार एक प्रक्रिया दस्तावेज़ का पहला मसौदा बनाता है। यह केवल एक शुरुआती बिंदु है - इसे लाइव दस्तावेज़ के रूप में सहेजने से पहले ध्यान से पढ़ें और अपने स्थान के लिए विशिष्ट किसी भी चीज़ को संपादित करें।';

  @override
  String get sopTemplateFieldLabel => 'दस्तावेज़ प्रकार';

  @override
  String get sopExtraContextLabel => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get sopExtraContextHint =>
      'जैसे विशिष्ट उपकरण, कर्मचारी भूमिकाएं, या शामिल करने के लिए नियम';

  @override
  String get generatingText => 'बनाया जा रहा है...';

  @override
  String get generateDraftButton => 'मसौदा बनाएं';

  @override
  String get documentTitleLabel => 'दस्तावेज़ शीर्षक';

  @override
  String get reviewAndEditDraftLabel => 'मसौदे की समीक्षा करें और संपादित करें';

  @override
  String get saveAsDocumentButton => 'दस्तावेज़ केंद्र में सहेजें';

  @override
  String get generateWithAiButton => 'AI से बनाएं';

  @override
  String get shiftPeriodsTitle => 'शिफ्ट अवधि';

  @override
  String get shiftPeriodsDescription =>
      'दिन को 2 या 3 अवधियों में विभाजित करें (जैसे सुबह/दोपहर/रात)। रोटा कैलेंडर और ऑटो-असाइन इनका उपयोग समय के अनुसार फ़िल्टर और योजना बनाने के लिए करते हैं।';

  @override
  String shiftPeriodCountOption(int count) {
    return '$count अवधियां';
  }

  @override
  String get shiftPeriodNameLabel => 'अवधि का नाम';

  @override
  String get shiftPeriodStartsLabel => 'शुरू होता है';

  @override
  String get shiftPeriodEndsLabel => 'समाप्त होता है';

  @override
  String get shiftPeriodsSavedMessage => 'शिफ्ट अवधि सहेजी गई';

  @override
  String shiftPeriodsSaveFailedMessage(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get shiftPeriodDefaultDay => 'दिन';

  @override
  String get shiftPeriodDefaultNight => 'रात';

  @override
  String get shiftPeriodDefaultMorning => 'सुबह';

  @override
  String get shiftPeriodDefaultAfternoon => 'दोपहर';

  @override
  String get rotaWeekTitle => 'रोटा कैलेंडर';

  @override
  String get rosterAddonNotEnabledText =>
      'इस साइट के लिए शिफ्ट और रोटा प्रबंधन अभी सक्षम नहीं है।';

  @override
  String get rotaTodayButton => 'आज';

  @override
  String get rotaFilterPeriodLabel => 'अवधि';

  @override
  String get rotaFilterAllLabel => 'सभी';

  @override
  String get rotaFilterDepartmentLabel => 'विभाग';

  @override
  String get rotaFilterPersonLabel => 'व्यक्ति';

  @override
  String get rotaUnassignedRowLabel => 'असाइन नहीं किया गया';

  @override
  String get setUpShiftPeriodsFirstText =>
      'पहले शिफ्ट अवधि सेट करें (शिफ्ट अवधि स्क्रीन)।';

  @override
  String get addStaffingRequirementTitle => 'स्टाफिंग आवश्यकता जोड़ें';

  @override
  String get anyDepartmentLabel => 'कोई भी विभाग';

  @override
  String get unknownDepartmentLabel => 'अज्ञात विभाग';

  @override
  String get anyRoleLabel => 'कोई भी भूमिका';

  @override
  String get staffNeededLabel => 'आवश्यक स्टाफ';

  @override
  String get standbyNeededLabel => 'आवश्यक स्टैंडबाय';

  @override
  String shiftsGeneratedMessage(int count) {
    return 'उस सप्ताह के लिए $count शिफ्ट बनाई गईं।';
  }

  @override
  String shiftGenerationFailedMessage(String error) {
    return 'विफल: $error';
  }

  @override
  String plusStandbyCountLabel(int count) {
    return ' + $count स्टैंडबाय';
  }

  @override
  String get masterRotaSettingsTitle => 'मास्टर रोटा सेटिंग्स';

  @override
  String get masterRotaSettingsDescription =>
      'परिभाषित करें कि प्रत्येक दिन/अवधि/विभाग या भूमिका के लिए कितने कर्मचारी (और स्टैंडबाय) चाहिए, फिर एक सप्ताह के लिए वास्तविक शिफ्ट एक साथ बनाएं।';

  @override
  String get noRequirementsYetText => 'अभी तक कोई आवश्यकता सेट नहीं की गई।';

  @override
  String get generateThisWeekButton => 'इस सप्ताह के लिए बनाएं';

  @override
  String get generateNextWeekButton => 'अगले सप्ताह के लिए बनाएं';

  @override
  String get rotaFilterRoleLabel => 'भूमिका';

  @override
  String get rotaStaffViewLabel => 'स्टाफ दृश्य';

  @override
  String get rotaSlotsViewLabel => 'स्लॉट दृश्य';

  @override
  String get rotaSlotDetailTitle => 'इस शिफ्ट में कौन है';

  @override
  String get rotaAssignedLabel => 'नियुक्त';

  @override
  String get rotaStandbyLabel => 'स्टैंडबाय';

  @override
  String get rotaNoneAssignedText => 'अभी तक कोई नहीं';

  @override
  String rotaUnfilledCountText(int count) {
    return 'अभी भी $count चाहिए';
  }

  @override
  String get daysOffRequestedMessage => 'छुट्टी के दिन अनुरोधित किए गए।';

  @override
  String get bookDaysOffToggleLabel => 'इसके बजाय छुट्टी बुक करें';

  @override
  String get submitDaysOffButton => 'छुट्टी सबमिट करें';

  @override
  String get alreadyRequestedOffText => 'पहले से अनुरोधित';

  @override
  String get noShiftsThisPeriodText => 'कोई शिफ्ट नहीं';

  @override
  String get youAreStandbyText => 'आप स्टैंडबाय हैं';

  @override
  String get youAreAssignedText => 'आप इस शिफ्ट पर हैं';

  @override
  String get joinStandbyButton => 'स्टैंडबाय में शामिल हों';

  @override
  String get shiftFullText => 'पूर्ण';

  @override
  String get rotaClaimCalendarTitle => 'शिफ्ट लें (कैलेंडर)';

  @override
  String get rotaMonthTitle => 'रोटा माह दृश्य';

  @override
  String rotaMonthShiftCountText(int count) {
    return '$count शिफ्ट';
  }

  @override
  String get fairAutoAssignTitle => 'निष्पक्ष स्वचालित असाइनमेंट';

  @override
  String get fairAutoAssignDescription =>
      'शामिल करने के लिए शिफ्ट और स्टाफ चुनें, फिर पुष्टि करने से पहले एक निष्पक्ष, स्पष्ट स्वचालित असाइनमेंट का पूर्वावलोकन करें।';

  @override
  String get selectShiftsLabel => 'शामिल करने के लिए खुली शिफ्ट';

  @override
  String get selectStaffLabel => 'शामिल करने के लिए स्टाफ';

  @override
  String get noOpenShiftsThisWeekText => 'इस सप्ताह कोई खुली शिफ्ट नहीं है।';

  @override
  String get selectAllLabel => 'सभी चुनें';

  @override
  String get previewAutoAssignButton =>
      'स्वचालित असाइनमेंट का पूर्वावलोकन करें';

  @override
  String get noShiftsOrStaffSelectedText =>
      'कृपया कम से कम एक शिफ्ट और एक स्टाफ सदस्य चुनें।';

  @override
  String get fairAutoAssignPreviewTitle => 'असाइनमेंट पूर्वावलोकन';

  @override
  String get unfilledShiftLabel => 'खाली';

  @override
  String get confirmAssignmentsButton => 'असाइनमेंट की पुष्टि करें';

  @override
  String assignmentsConfirmedMessage(int count) {
    return '$count शिफ्ट असाइन की गईं।';
  }

  @override
  String fairAutoAssignSummaryText(int filled, int total) {
    return 'आपके चयन से $total में से $filled शिफ्ट भरी जा सकती हैं।';
  }

  @override
  String get unlockFeeChargedMessage =>
      'संपर्क अनलॉक किया गया - 79p शुल्क लिया गया।';

  @override
  String get unlockFeeNotChargedMessage =>
      'संपर्क अनलॉक किया गया। 79p शुल्क नहीं लिया जा सका (कोई सक्रिय डायरेक्ट डेबिट नहीं) - इसे बिल नहीं किया गया।';

  @override
  String get reportBugTitle => 'बग की रिपोर्ट करें';

  @override
  String get reportBugSubtitle =>
      'VenuRite को किसी ऐसी चीज़ के बारे में बताएं जो काम नहीं कर रही';

  @override
  String get reportBugIntroText =>
      'क्या ऐप में कुछ टूटा हुआ या भ्रमित करने वाला मिला? हमें बताएं, हम इसे देखेंगे।';

  @override
  String get reportBugRequiresAccountText =>
      'बग रिपोर्टिंग के लिए साइन-इन कंपनी खाता आवश्यक है।';

  @override
  String get bugReportTitleLabel => 'क्या गलत हुआ?';

  @override
  String get bugReportDescriptionLabel => 'हमें और बताएं';

  @override
  String get submitBugReportButton => 'रिपोर्ट सबमिट करें';

  @override
  String get bugReportSubmittedMessage =>
      'धन्यवाद - आपकी रिपोर्ट VenuRite को भेज दी गई है।';

  @override
  String get bugReportFailedMessage =>
      'आपकी रिपोर्ट नहीं भेजी जा सकी। कृपया पुनः प्रयास करें।';

  @override
  String get shiftVerificationQueueTitle => 'शिफ्ट सत्यापन';

  @override
  String get shiftPhotoConsentTitle => 'शिफ्ट फोटो जांच';

  @override
  String get shiftPhotoConsentBody =>
      'यह वेन्यू शिफ्ट शुरू और खत्म होने पर एक त्वरित फोटो लेता है ताकि पुष्टि हो सके कि वास्तव में किसने क्लॉक-इन किया। यदि आप नहीं चाहते, तो कोई बात नहीं: आपका सुपरवाइज़र आपकी शिफ्ट के समय की पुष्टि करेगा।';

  @override
  String get declinePhotoButton => 'नहीं धन्यवाद';

  @override
  String get allowPhotoButton => 'फोटो की अनुमति दें';

  @override
  String get shiftVerificationNotEnabledText =>
      'इस वेन्यू के लिए शिफ्ट सत्यापन फोटो चालू नहीं हैं।';

  @override
  String get noPendingVerificationsText =>
      'अभी सत्यापन के लिए कुछ भी लंबित नहीं है।';

  @override
  String pendingClockInLabel(String time) {
    return '$time क्लॉक-इन - कोई फोटो नहीं';
  }

  @override
  String pendingClockOutLabel(String time) {
    return '$time क्लॉक-आउट - कोई फोटो नहीं';
  }

  @override
  String get confirmHappenedButton => 'पुष्टि करें कि ऐसा हुआ';

  @override
  String get shiftPhotoRetentionDaysTitle => 'फोटो कितने समय तक रखें?';

  @override
  String get daysLabel => 'दिन';

  @override
  String get shiftVerificationPhotosSectionTitle => 'शिफ्ट सत्यापन फोटो';

  @override
  String get shiftVerificationPhotosExplanation =>
      'शिफ्ट शुरू/खत्म होने पर एक त्वरित फोटो धोखाधड़ी को रोकती है। स्टाफ मना कर सकता है - तब सुपरवाइज़र शिफ्ट सत्यापित करेगा।';

  @override
  String get enableShiftVerificationPhotosLabel =>
      'शिफ्ट शुरू/खत्म होने पर फोटो आवश्यक करें';

  @override
  String shiftPhotoRetentionDaysLabel(int days) {
    return 'फोटो $days दिनों तक रखी जाती हैं';
  }

  @override
  String get changeLabel => 'बदलें';
}
