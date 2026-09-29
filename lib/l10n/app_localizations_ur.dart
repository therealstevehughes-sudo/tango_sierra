// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get personalSection => 'ذاتی';

  @override
  String get languageSettingTitle => 'زبان';

  @override
  String get languageSettingSubtitle =>
      'وہ زبان منتخب کریں جس میں آپ VenuRite استعمال کرنا چاہتے ہیں.';

  @override
  String get languageUpdated => 'زبان اپ ڈیٹ ہو گئی.';

  @override
  String get chooseLanguageTitle => 'زبان منتخب کریں';

  @override
  String get languageDeviceScope =>
      'عملے کے سائن اِن کرنے سے پہلے اس ڈیوائس پر یہی زبان استعمال ہوگی.';

  @override
  String languageUserScope(String name) {
    return '$name کے لیے محفوظ کیا گیا.';
  }

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get done => 'مکمل';

  @override
  String get login => 'لاگ اِن';

  @override
  String get back => 'واپس';

  @override
  String get enterPin => 'PIN درج کریں';

  @override
  String get leadershipAccess => 'انتظامیہ کی رسائی';

  @override
  String get notOnThisList =>
      'اس فہرست میں نہیں؟ کسی اور طریقے سے سائن اِن کریں';

  @override
  String errorLoadingStaff(String error) {
    return 'عملہ لوڈ کرتے وقت خرابی: $error';
  }

  @override
  String get incorrectPin => 'غلط PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'بہت زیادہ غلط کوششیں. $minutes منٹ بعد دوبارہ کوشش کریں.';
  }

  @override
  String get accountNotFound => 'اکاؤنٹ نہیں ملا';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get kitchenComplianceDoneRight => 'کچن کمپلائنس، واضح اور قابل اعتماد';

  @override
  String get valuePointEhoReady =>
      'صحت کے معائنے کے لیے ہمیشہ تیار - آخری وقت کی بھاگ دوڑ نہیں، حقیقی وقت کے ریکارڈ';

  @override
  String get valuePointHonestRecords =>
      'ایسا بنایا گیا کہ نتائج سے چھیڑ چھاڑ نہ ہو سکے - ہر چیک کا قابل اعتماد ریکارڈ';

  @override
  String get valuePointAuditExport =>
      'ایک ٹیپ میں آڈٹ ایکسپورٹ - انسپکٹر کو فوراً حقیقی ریکارڈ دیں';

  @override
  String get howGetStarted => 'آپ کیسے شروع کرنا چاہیں گے؟';

  @override
  String get setUpMyBusiness => 'میرا مقام سیٹ اپ کریں';

  @override
  String get teamAlreadyUses => 'میری ٹیم پہلے سے VenuRite استعمال کرتی ہے';

  @override
  String get alreadyHaveAccount => 'پہلے سے اکاؤنٹ ہے؟ سائن اِن کریں';

  @override
  String get needHelpContact => 'مدد چاہیے؟ VenuRite سے رابطہ کریں';

  @override
  String get signInAnotherWay => 'کسی اور طریقے سے سائن اِن کریں';

  @override
  String get deviceNotSetUp => 'یہ ٹیبلٹ ابھی سیٹ اپ نہیں ہے';

  @override
  String get askManagerSetupCode =>
      'اس مقام کے سیٹ اپ کوڈ کے لیے مینیجر سے پوچھیں.';

  @override
  String get setupCode => 'سیٹ اپ کوڈ';

  @override
  String get connectTablet => 'اس ٹیبلٹ کو کنیکٹ کریں';

  @override
  String get couldNotReachServer => 'سرور سے رابطہ نہیں ہو سکا';

  @override
  String get stillStuckSetupCode =>
      'ابھی بھی آگے نہیں بڑھ پا رہے؟ مینیجر اسے Settings -> Venue Details میں تلاش کر سکتا ہے.';

  @override
  String get askQuestionTitle => 'سوال پوچھیں';

  @override
  String get askQuestionLabel => 'آپ کیا جاننا چاہتے ہیں؟';

  @override
  String get askQuestionHint => 'مثلاً: فریج کا درجہ حرارت کتنا ہونا چاہیے؟';

  @override
  String get ask => 'پوچھیں';

  @override
  String get aiQuestionLimitReached =>
      'اس مہینے AI سوالات کی حد پوری ہو گئی ہے';

  @override
  String get home => 'ہوم';

  @override
  String get logOut => 'لاگ آؤٹ';

  @override
  String get endShift => 'شفٹ ختم کریں';

  @override
  String get workerHubPrompt => 'آپ کیا کرنا چاہتے ہیں؟';

  @override
  String get myScheduledTasks => 'میرے طے شدہ کام';

  @override
  String get doAdHocTask => 'ایک ad-hoc کام کریں';

  @override
  String get logSomethingHappened => 'جو ابھی ہوا اسے درج کریں';

  @override
  String get claimShift => 'شفٹ لیں';

  @override
  String get requestDayOff => 'چھٹی کا دن مانگیں';

  @override
  String get thingsIReported => 'میری رپورٹ کی گئی باتیں';

  @override
  String shiftWelcome(String firstName) {
    return 'خوش آمدید، $firstName';
  }

  @override
  String get shiftPlanIntro => 'آپ کی شفٹ کے لیے یہ کام ہیں:';

  @override
  String get startOfShift => 'شفٹ کا آغاز';

  @override
  String get duringYourShift => 'آپ کی شفٹ کے دوران';

  @override
  String get endOfShift => 'شفٹ کا اختتام';

  @override
  String get shiftHandoverTitle => 'شفٹ ہینڈ اوور';

  @override
  String get shiftHandoverNeedsAttention =>
      'اس پر ابھی بھی اگلی شفٹ کی توجہ درکار ہے';

  @override
  String get gotIt => 'سمجھ گیا';

  @override
  String get openIssues => 'کھلے مسائل';

  @override
  String get flaggedEquipment => 'نشان زدہ آلات';

  @override
  String get notYetDoneToday => 'آج تک نہیں ہوا';

  @override
  String get takePhoto => 'تصویر لیں';

  @override
  String get uploadFromFiles => 'فائلوں سے اپ لوڈ کریں';

  @override
  String get seeAllTasksTooltip => 'تمام کام دیکھیں';

  @override
  String get leaveBeforeFinishingTitle => 'ختم کرنے سے پہلے باہر جائیں؟';

  @override
  String get leaveBeforeFinishingBody =>
      'کچھ جانچیں مکمل نہیں ہیں۔ اسے ریکارڈ کیا جائے گا۔ آپ اس شفٹ میں کسی بھی وقت واپس آ کر مکمل کر سکتے ہیں۔';

  @override
  String get enterValue => 'قدر درج کریں';

  @override
  String enterValueWithUnit(String unit) {
    return 'قدر درج کریں ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'محفوظ حد: $min - $max';
  }

  @override
  String get errorNumericRequired => 'ایک درست عددی قدر درکار ہے';

  @override
  String get errorSelectOption => 'براہ کرم ایک آپشن منتخب کریں';

  @override
  String get errorNotesRequired => 'نوٹس درکار ہیں';

  @override
  String get errorPhotoRequired => 'تصویر درکار ہے';

  @override
  String get errorCorrectiveActionRequired =>
      'منتخب کریں کہ اصلاحی اقدام کیسے کیا گیا';

  @override
  String get myTasksTitle => 'میرے کام';

  @override
  String get taskTitleFallback => 'کام';

  @override
  String get noTasksAssigned => 'ابھی تک کوئی کام تفویض نہیں کیا گیا۔';

  @override
  String get overdueLabel => 'زائد المیعاد';

  @override
  String overdueSinceLabel(String date) {
    return '$date سے زائد المیعاد';
  }

  @override
  String get withinRangePass => 'حد کے اندر - پاس';

  @override
  String get outsideRangeFail => 'حد سے باہر - فیل';

  @override
  String get selectOptionLabel => 'ایک آپشن منتخب کریں';

  @override
  String get notesLabel => 'نوٹس';

  @override
  String get spotCheckPhotoNotice =>
      'آج کی اچانک جانچ - اس بار یہ تصدیق کرنے کے لیے تصویر درکار ہے کہ یہ واقعی کیا گیا تھا۔';

  @override
  String get photoAdded => 'تصویر شامل کی گئی';

  @override
  String get addPhoto => 'تصویر شامل کریں';

  @override
  String get passLabel => 'پاس';

  @override
  String get failLabel => 'فیل';

  @override
  String get readingOutsideSafeRange => 'ریڈنگ محفوظ حد سے باہر ہے';

  @override
  String get hereIsWhatToDo => 'یہاں بتایا گیا ہے کہ کیا کرنا ہے:';

  @override
  String get correctiveActionRequired => 'اصلاحی اقدام درکار ہے';

  @override
  String get iFixedIt => 'میں نے اسے ٹھیک کر دیا';

  @override
  String get reportedToManager => 'منیجر کو مطلع کر دیا گیا';

  @override
  String get correctiveActionNoteLabel => 'آپ نے کیا کیا؟ (اختیاری)';

  @override
  String get managerWillBeNotified => 'آپ کے منیجر کو مطلع کیا جائے گا۔';

  @override
  String get submitButton => 'جمع کروائیں';

  @override
  String availableFrom(String time) {
    return '$time سے دستیاب';
  }

  @override
  String get backToList => 'فہرست پر واپس جائیں';

  @override
  String get skipComesBackLater => 'چھوڑیں - بعد میں واپس آئے گا';

  @override
  String get noAdHocTaskTypesSetUp =>
      'اس سائٹ پر ابھی تک کوئی فوری کام کی قسم سیٹ نہیں کی گئی - پہلے کسی منیجر سے ڈیلیوری چیک یا درجہ حرارت چیک ٹیمپلیٹ تفویض کرنے کو کہیں۔';

  @override
  String get whatKindOfThing => 'آپ کس قسم کا کام کر رہے ہیں؟';

  @override
  String get notesOptionalLabel => 'نوٹس (اختیاری)';

  @override
  String get noteOptionalLabel => 'نوٹ (اختیاری)';

  @override
  String get temperatureCelsiusLabel => 'درجہ حرارت (°C)';

  @override
  String get submitLabel => 'جمع کروائیں';

  @override
  String get logReadingButton => 'ریڈنگ درج کریں';

  @override
  String get loggedThanksMessage => 'درج کر لیا گیا۔ اسے ریکارڈ کرنے کا شکریہ۔';

  @override
  String get logAnotherAdHocTask => 'ایک اور فوری کام درج کریں';

  @override
  String get deliveryCheckLabel => 'ڈیلیوری چیک';

  @override
  String get temperatureCheckLabel => 'درجہ حرارت چیک';

  @override
  String get sessionSummaryTitle => 'شفٹ کا خلاصہ';

  @override
  String tasksCompletedCount(int count) {
    return 'مکمل شدہ کام: $count';
  }

  @override
  String get passedLabel => 'پاس';

  @override
  String get failedLabel => 'فیل';

  @override
  String get triggersFailedTasks => 'ٹرگرز / فیل کام';

  @override
  String get yourReliability => 'آپ کی وشوسنییتا';

  @override
  String get reliabilityExplanation =>
      'پچھلے 30 دن - بروقت مکمل اور درج کی گئی جانچیں۔ درج شدہ فیل کو درج شدہ پاس کی طرح ہی شمار کیا جاتا ہے: یہ صرف یہ ناپتا ہے کہ آپ نے جانچ کی یا نہیں اور کب کی۔';

  @override
  String completedPercentChip(int percent) {
    return '$percent% مکمل';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% بروقت';
  }

  @override
  String get sendSummaryToManager => 'یہ خلاصہ منیجر کو بھیجیں (اختیاری)';

  @override
  String get noManagersSetUp => 'ابھی تک کوئی منیجر سیٹ نہیں کیا گیا۔';

  @override
  String get managerLabel => 'منیجر';

  @override
  String get sentLabel => 'بھیج دیا گیا';

  @override
  String get sendLabel => 'بھیجیں';

  @override
  String get leaveNoteForNextShift => 'اگلی شفٹ کے لیے نوٹ چھوڑیں (اختیاری)';

  @override
  String get handoverNoteLabel => 'ہینڈ اوور نوٹ';

  @override
  String get doneLabel => 'مکمل';

  @override
  String get supplierOptionalLabel => 'سپلائر (اختیاری)';

  @override
  String supplierWarningRecorded(String status) {
    return 'یہ سپلائر $status کے طور پر نشان زد ہے - پھر بھی جانچ درج کی جائے گی۔';
  }

  @override
  String get reportProblemWithDelivery => 'اس ڈیلیوری میں مسئلے کی اطلاع دیں';

  @override
  String get temperatureOnArrivalLabel => 'آمد پر درجہ حرارت (°C، اختیاری)';

  @override
  String get problemsTickAnyApply => 'مسائل (جو بھی لاگو ہوں منتخب کریں)';

  @override
  String get shortDeliveryLabel => 'کم ڈیلیوری';

  @override
  String get damagedStockLabel => 'خراب شدہ سامان';

  @override
  String get lateDeliveryLabel => 'تاخیر سے ڈیلیوری';

  @override
  String get qualityProblemLabel => 'معیار کا مسئلہ';

  @override
  String get outcomeLabel => 'نتیجہ';

  @override
  String get acceptedLabel => 'قبول شدہ';

  @override
  String get rejectedLabel => 'مسترد شدہ';

  @override
  String get partiallyAcceptedLabel => 'جزوی طور پر قبول';

  @override
  String get noCameraFound => 'اس ڈیوائس پر کوئی کیمرہ نہیں ملا۔';

  @override
  String couldNotStartCamera(String error) {
    return 'کیمرہ شروع نہیں ہو سکا: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'کیمرہ تبدیل نہیں ہو سکا: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'تصویر نہیں لی جا سکی: $error';
  }

  @override
  String get switchCameraTooltip => 'کیمرہ تبدیل کریں';
}
