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
}
