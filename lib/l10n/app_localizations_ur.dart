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

  @override
  String get allTasksTitle => 'تمام کام';

  @override
  String get otherSegmentLabel => 'دیگر';

  @override
  String get reorderTasksTitle => 'کاموں کو دوبارہ ترتیب دیں';

  @override
  String get ungroupedLabel => 'غیر گروپ شدہ';

  @override
  String get taskOrderSaved => 'کام کی ترتیب محفوظ کر لی گئی۔';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'کام کی ترتیب محفوظ نہیں ہو سکی: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'ابھی تک کوئی مقام منتخب نہیں کیا گیا۔ کاموں کو دوبارہ ترتیب دینے سے پہلے مقام کی تفصیلات سے ایک فعال مقام سیٹ کریں۔';

  @override
  String get noActiveTasksToReorder =>
      'ابھی تک دوبارہ ترتیب دینے کے لیے کوئی فعال کام نہیں ہیں۔ پہلے کام تفویض کریں، پھر ان کی ترتیب منتخب کرنے کے لیے یہاں واپس آئیں۔';

  @override
  String get savingEllipsis => 'محفوظ ہو رہا ہے…';

  @override
  String get saveOrderLabel => 'ترتیب محفوظ کریں';

  @override
  String get moveUpTooltip => 'اوپر منتقل کریں';

  @override
  String get moveDownTooltip => 'نیچے منتقل کریں';

  @override
  String get accountRestrictedTitle => 'اکاؤنٹ محدود ہے';

  @override
  String get accountRestrictedBody =>
      'نئی جانچیں محفوظ ہونے سے پہلے اس ادارے کے ڈائریکٹ ڈیبٹ پر توجہ درکار ہے۔ آپ کا کام ضائع نہیں ہوا - براہ کرم کسی منیجر یا ڈائریکٹر کو بلنگ حل کرنے کے لیے بتائیں، پھر دوبارہ کوشش کریں۔';

  @override
  String get okLabel => 'ٹھیک ہے';

  @override
  String get troubleshootingTitle => 'مسئلہ حل کرنا';

  @override
  String get faqTitle => 'عمومی سوالات';

  @override
  String get helpTitle => 'مدد';

  @override
  String get couldntReachAssistant => 'معاون سے رابطہ نہیں ہو سکا';

  @override
  String get aiOfflineBody =>
      'AI معاون فی الحال قابل رسائی نہیں ہے - یہ آپ کا کنیکشن ہو سکتا ہے، یا سروس عارضی طور پر بند ہو سکتی ہے۔ اس دوران، نیچے دیے گئے عمومی سوالات اور مسئلہ حل کرنا سب سے عام سوالات کا احاطہ کرتے ہیں، یا براہ راست VenuRite سے رابطہ کریں۔';

  @override
  String get askQuestionSubtitle => 'سادہ زبان میں براہ راست جواب حاصل کریں';

  @override
  String get faqSubtitle => 'عمومی سوالات، جوابات کے ساتھ';

  @override
  String get troubleshootingSubtitle =>
      'کچھ کام نہیں کر رہا؟ یہاں سے شروع کریں';

  @override
  String get contactVenuriteTitle => 'VenuRite سے رابطہ کریں';

  @override
  String get contactVenuriteSubtitle => 'براہ راست رابطہ کریں';

  @override
  String get topTierViewTitle => 'اعلیٰ سطحی منظر';

  @override
  String get everythingsDone => 'سب کچھ ہو گیا۔ بہترین کام۔';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کام مکمل نہیں ہوئے:',
      one: '1 کام مکمل نہیں ہوا:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'شفٹ پر واپس جائیں';

  @override
  String get finishShiftLabel => 'شفٹ ختم کریں';

  @override
  String get ehoAuditExportTitle => 'EHO / آڈٹ ایکسپورٹ';

  @override
  String get ehoExportDescription =>
      'منتخب تاریخ کی حد کے لیے اس مقام کے تعمیل ریکارڈز کی PDF بناتا ہے۔';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'تاریخ کی حد منتخب کریں';

  @override
  String get tapToChooseDates =>
      'شروع اور اختتامی تاریخ منتخب کرنے کے لیے ٹیپ کریں۔';

  @override
  String get includeFullDetailedLog => 'مکمل تفصیلی لاگ شامل کریں';

  @override
  String get fullLogSubtitle =>
      'پہلے سے غیر فعال - اوپر دیا گیا خلاصہ اور استثنیات وہی ہیں جن کا انسپکٹر جائزہ لیتا ہے؛ یہ ہر انفرادی جانچ کو شامل کرتا ہے۔';

  @override
  String get generateLabel => 'بنائیں';

  @override
  String get exportFailedTitle => 'ایکسپورٹ ناکام';

  @override
  String exportFailedBody(String error) {
    return 'ایکسپورٹ ناکام: $error';
  }

  @override
  String get exportCreatedTitle => 'ایکسپورٹ بن گئی';

  @override
  String savedToLabel(String path) {
    return 'یہاں محفوظ کیا گیا:\n$path';
  }

  @override
  String get dashboardTitle => 'ڈیش بورڈ';

  @override
  String get noVenueFound => 'کوئی مقام نہیں ملا۔';

  @override
  String get allPermittedVenuesLast30Days =>
      'تمام اجازت یافتہ مقامات · پچھلے 30 دن';

  @override
  String get last30Days => 'پچھلے 30 دن';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فیل (30 دن)',
      one: '1 فیل (30 دن)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count زائد المیعاد';
  }

  @override
  String get venuesSectionTitle => 'مقامات';

  @override
  String get teamSectionTitle => 'ٹیم';

  @override
  String get noStaffAtVenue => 'اس مقام پر ابھی تک کوئی عملہ نہیں ہے۔';

  @override
  String get notEnoughDataYet => 'ناکافی ڈیٹا';

  @override
  String get venueFallbackLabel => 'مقام';

  @override
  String get trendsTitle => 'رجحانات';

  @override
  String get trendNeedsHistory =>
      'رجحان کا ڈیٹا: رجحان دکھانے کے لیے کم از کم 4 ہفتوں کی تاریخ درکار ہے۔';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'فی مقام ہفتہ وار تکمیل · پچھلے $weeks ہفتے';
  }

  @override
  String get allVenuesCombined => 'تمام مقامات مجموعی طور پر';

  @override
  String get noVenuesYet => 'ابھی تک کوئی مقام نہیں۔';

  @override
  String get otherVenuesLabel => 'دیگر مقامات';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$total میں سے $completed جانچیں درج کی گئیں';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'علاقہ #$id';
  }

  @override
  String get dashboardOverviewTitle => 'ڈیش بورڈ کا جائزہ';

  @override
  String get gradedBarsOnTooltip => 'فی ملازم گریڈڈ بارز: آن';

  @override
  String get gradedBarsOffTooltip => 'فی ملازم گریڈڈ بارز: آف';

  @override
  String get noBranchesToShow => 'ابھی تک دکھانے کے لیے کوئی برانچ نہیں۔';

  @override
  String get supervisorNoScopeMessage =>
      'آپ کو ابھی تک کسی سیکشن یا ٹیم کو تفویض نہیں کیا گیا - اس ڈیش بورڈ میں کچھ دکھانے سے پہلے کسی منیجر سے اسٹاف مینجمنٹ میں یہ سیٹ کرنے کو کہیں۔';

  @override
  String get individualViewNotice =>
      'انفرادی منظر - رسک نگرانی کے لیے، لیگ ٹیبل نہیں۔';

  @override
  String get branchLabel => 'برانچ';

  @override
  String get allBranchesLabel => 'تمام برانچز';

  @override
  String get yourSectionLabel => 'آپ کا سیکشن';

  @override
  String get noneAssignedLabel => 'کچھ تفویض نہیں کیا گیا';

  @override
  String get areaLabel => 'علاقہ';

  @override
  String get allAreasLabel => 'تمام علاقے';

  @override
  String get employeeLabel => 'ملازم';

  @override
  String get allEmployeesLabel => 'تمام ملازمین';

  @override
  String get monthLabel => 'مہینہ';

  @override
  String get weekLabel => 'ہفتہ';

  @override
  String get dayLabel => 'دن';

  @override
  String get noTaskActivityPeriod => 'اس مدت میں کوئی کام کی سرگرمی نہیں۔';

  @override
  String get taskOverviewTitle => 'کام کا جائزہ';

  @override
  String get incidentsTitle => 'واقعات';

  @override
  String get noIncidentsPeriod => 'اس مدت میں کوئی واقعہ رپورٹ نہیں ہوا۔';

  @override
  String urgentCountLabel(int count) {
    return '$count فوری';
  }

  @override
  String get tapForDetailsHint =>
      'تفصیلات کے لیے کسی رنگ سیکشن یا لیجنڈ اندراج پر ٹیپ کریں';

  @override
  String get employeeFallbackLabel => 'ملازم';

  @override
  String get plainLookupNotice =>
      'یہ صرف ایک سادہ تلاش ہے، اسکور نہیں - تکمیل کا رنگ اور مسئلے کے ٹیگز یہاں کبھی بھی فی شخص گریڈ نہیں کیے جاتے۔';

  @override
  String tasksCompletedCountParens(int count) {
    return 'مکمل شدہ کام ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'اٹھائے گئے مسائل ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'وقت پر مکمل (کوئی مسئلہ نہیں)';

  @override
  String get doneOnTimeIssuesLogged => 'وقت پر مکمل (مسائل درج)';

  @override
  String get doneEarlyLateNoIssues => 'جلدی/دیر سے مکمل (کوئی مسئلہ نہیں)';

  @override
  String get doneEarlyLateIssuesLogged => 'جلدی/دیر سے مکمل (مسائل درج)';

  @override
  String get notDoneLabel => 'مکمل نہیں ہوا';

  @override
  String get resolvedLabel => 'حل شدہ';

  @override
  String get unresolvedLabel => 'غیر حل شدہ';

  @override
  String get escalatedLabel => 'آگے بڑھایا گیا';

  @override
  String get urgentLabel => 'فوری';

  @override
  String get signInFailed => 'سائن ان ناکام';

  @override
  String get twoFactorRequiredNoFactor =>
      'دو مرحلہ تصدیق درکار ہے لیکن کوئی طریقہ نہیں ملا۔';

  @override
  String get couldNotVerifyCode => 'وہ کوڈ تصدیق نہیں ہو سکا';

  @override
  String get codeDidntWork => 'وہ کوڈ کام نہیں کیا۔';

  @override
  String get accountNotLinkedToStaff =>
      'یہ اکاؤنٹ ابھی تک کسی اسٹاف پروفائل سے منسلک نہیں - ایڈمن سے رابطہ کریں۔';

  @override
  String get resetPasswordTitle => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get enterEmailForResetCode =>
      'اپنا ای میل درج کریں اور ہم آپ کو پاس ورڈ ری سیٹ کرنے کے لیے ایک کوڈ بھیجیں گے۔';

  @override
  String get emailLabel => 'ای میل';

  @override
  String get sendCodeButton => 'کوڈ بھیجیں';

  @override
  String get backToSignIn => 'سائن ان پر واپس جائیں';

  @override
  String sentCodeToEmail(String email) {
    return 'ہم نے $email پر ایک کوڈ بھیجا ہے۔ اسے اپنے نئے پاس ورڈ کے ساتھ نیچے درج کریں۔';
  }

  @override
  String get sixDigitCodeLabel => '6 ہندسوں کا کوڈ';

  @override
  String get newPasswordLabel => 'نیا پاس ورڈ';

  @override
  String get resetPasswordButton => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get twoFactorVerificationTitle => 'دو مرحلہ تصدیق';

  @override
  String get enterAuthenticatorCode => 'اپنی آتھینٹیکیٹر ایپ سے کوڈ درج کریں۔';

  @override
  String get verifyButton => 'تصدیق کریں';

  @override
  String get regionalDirectorSignIn => 'علاقائی اور ڈائریکٹر سائن ان۔';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String get signInButton => 'سائن ان کریں';

  @override
  String get forgotPasswordLink => 'پاس ورڈ بھول گئے؟';

  @override
  String get noBackendConfiguredPin =>
      'اس تنصیب کے لیے کوئی بیک اینڈ کنفیگر نہیں ہے - باقی سب کی طرح PIN سے سائن ان کریں۔';

  @override
  String get noDirectorRegionalAccounts =>
      'اس ڈیوائس پر کوئی ڈائریکٹر/علاقائی اکاؤنٹ نہیں ہے۔';

  @override
  String get directorLabel => 'ڈائریکٹر';

  @override
  String get regionalManagerLabel => 'علاقائی منیجر';

  @override
  String get whoAreYouTitle => 'آپ کون ہیں؟';

  @override
  String get searchLabel => 'تلاش کریں';

  @override
  String get noMatchesLabel => 'کوئی نتیجہ نہیں ملا';

  @override
  String get leadershipSectionTitle => 'قیادت';

  @override
  String get kitchenStaffSectionTitle => 'کچن اسٹاف';

  @override
  String get chooseASectionTitle => 'ایک سیکشن منتخب کریں';

  @override
  String get unassignedLabel => 'غیر تفویض شدہ';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count افراد',
      one: '$count شخص',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'صبح بخیر';

  @override
  String get goodAfternoon => 'دوپہر بخیر';

  @override
  String get goodEvening => 'شام بخیر';

  @override
  String get welcomeToVenurite => 'VenuRite میں خوش آمدید';

  @override
  String get helpAssistantTooltip => 'مدد اور معاون';

  @override
  String get couldntLoadScreen => 'یہ اسکرین لوڈ نہیں ہو سکی۔';

  @override
  String get retryLabel => 'دوبارہ کوشش کریں';

  @override
  String get microphonePermissionDenied =>
      'مائیکروفون کی اجازت مسترد کر دی گئی۔';

  @override
  String get couldntRecordTryAgain => 'ریکارڈ نہیں ہو سکا - دوبارہ کوشش کریں۔';

  @override
  String get couldntTranscribe => 'اسے ٹرانسکرائب نہیں کیا جا سکا۔';

  @override
  String get couldntReachTranscriptionService =>
      'ٹرانسکرپشن سروس تک رسائی نہیں ہو سکی۔';

  @override
  String get dictateANote => 'نوٹ بولیں';

  @override
  String get stoppingSoonTapToStop =>
      'جلد بند ہو جائے گا - ابھی روکنے کے لیے ٹیپ کریں';

  @override
  String get stopLabel => 'روکیں';

  @override
  String get somethingWentWrong => 'کچھ غلط ہو گیا';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count الرٹس',
      one: '1 الرٹ',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count غیر تسلیم شدہ';
  }

  @override
  String get allAcknowledgedLabel => 'سب تسلیم شدہ';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'زائد المیعاد - $minutes منٹ سے غیر تسلیم شدہ';
  }

  @override
  String get escalatedToTopTier => 'اعلیٰ سطح پر بھیجا گیا';

  @override
  String get acknowledgeLabel => 'تسلیم کریں';

  @override
  String get nothingInCategory => 'اس زمرے میں کچھ نہیں ہے۔';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'قیادت کا جائزہ';

  @override
  String get photoEvidence => 'تصویری ثبوت';

  @override
  String get staffManagement => 'اسٹاف مینجمنٹ';

  @override
  String get addTeamMember => 'ٹیم ممبر شامل کریں';

  @override
  String get shiftLog => 'شفٹ لاگ';

  @override
  String get branchTeamStructure => 'برانچ ٹیم کا ڈھانچہ';

  @override
  String get departmentManagement => 'شعبہ جاتی انتظام';

  @override
  String get rosterBoard => 'روسٹر بورڈ';

  @override
  String get claimShifts => 'شفٹس کا دعویٰ کریں';

  @override
  String get requestADayOff => 'چھٹی کی درخواست دیں';

  @override
  String get shiftFairnessReview => 'شفٹ منصفانہ جائزہ';

  @override
  String get venueDetails => 'مقام کی تفصیلات';

  @override
  String get assignTasks => 'کام تفویض کریں';

  @override
  String get taskPresets => 'کام پری سیٹس';

  @override
  String get supplierManagement => 'سپلائر مینجمنٹ';

  @override
  String get serviceProviders => 'سروس فراہم کنندگان';

  @override
  String get notificationRules => 'اطلاع کے اصول';

  @override
  String get documentCentre => 'دستاویزات مرکز';

  @override
  String get setupWizard => 'سیٹ اپ وزرڈ';

  @override
  String get organisationLabel => 'ادارہ';

  @override
  String get branchesLabel => 'برانچز';

  @override
  String get homeLabel => 'ہوم';

  @override
  String get oversightLabel => 'نگرانی';

  @override
  String get problemsAndIssues => 'مسائل اور شکایات';

  @override
  String get twoFactorAuthentication => 'دو مرحلہ تصدیق';

  @override
  String get backUpNow => 'ابھی بیک اپ لیں';

  @override
  String get dailySection => 'روزانہ';

  @override
  String get insightsSection => 'بصیرت';

  @override
  String get peopleSection => 'افراد';

  @override
  String get rosterSection => 'روسٹر';

  @override
  String get venueSetupSection => 'مقام سیٹ اپ';

  @override
  String get companySection => 'کمپنی';

  @override
  String get accountSection => 'اکاؤنٹ';

  @override
  String get settingsLabel => 'ترتیبات';

  @override
  String percentCompletedTodayChip(int percent) {
    return 'آج $percent% مکمل';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count فعال عملہ';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آج $count فیل',
      one: 'آج 1 فیل',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'منیجر ویو';

  @override
  String showingScopeLabel(String scope) {
    return 'دکھایا جا رہا ہے: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'آپ کو ابھی تک کسی سیکشن یا ٹیم کو تفویض نہیں کیا گیا - اس لاگ میں کچھ دکھانے سے پہلے کسی منیجر سے اسٹاف مینجمنٹ میں یہ سیٹ کرنے کو کہیں۔';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اندراجات',
      one: '1 اندراج',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فیل',
      one: '1 فیل',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'کوئی فیل نہیں';

  @override
  String get noCompletedTasksLoggedYet =>
      'ابھی تک کوئی مکمل شدہ کام درج نہیں کیا گیا';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سیشن خلاصے',
      one: '1 سیشن خلاصہ',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount پاس / $failCount فیل';
  }

  @override
  String get workerFixedIt => 'ملازم نے اسے ٹھیک کیا';

  @override
  String get noCorrectiveActionRecorded => 'کوئی اصلاحی اقدام درج نہیں کیا گیا';

  @override
  String get taskAlertFallback => 'کام کی وارننگ';

  @override
  String get loggedByLabel => 'درج کنندہ';

  @override
  String get resultLabel => 'نتیجہ';

  @override
  String get correctiveActionLabel => 'اصلاحی اقدام';

  @override
  String get noteLabel => 'نوٹ';

  @override
  String get closeLabel => 'بند کریں';

  @override
  String get notCompletedSuffix => '- مکمل نہیں ہوا (شفٹ ختم)';

  @override
  String get todayAllFails => 'آج + تمام فیل';

  @override
  String byAxisLabel(String axis) {
    return '$axis کے مطابق';
  }

  @override
  String get nameAxisLabel => 'نام';

  @override
  String get dateAxisLabel => 'تاریخ';

  @override
  String get taskAxisLabel => 'کام';

  @override
  String get filterLabel => 'فلٹر';

  @override
  String get filterByLabel => 'فلٹر کریں:';

  @override
  String get clearFiltersLabel => 'فلٹرز صاف کریں';

  @override
  String get staffLabel => 'عملہ';

  @override
  String get issueTypeComplaint => 'شکایت';

  @override
  String get issueTypeAccident => 'حادثہ';

  @override
  String get issueTypeIncident => 'واقعہ';

  @override
  String get issueTypeSupplyProblem => 'سپلائی کا مسئلہ';

  @override
  String get issueTypeVenueProblem => 'مقام کا مسئلہ';

  @override
  String get issueTypeOther => 'دیگر';

  @override
  String get incorrectDeliveryLabel => 'غلط ڈیلیوری';

  @override
  String get driverProblemLabel => 'ڈرائیور کا مسئلہ';

  @override
  String get otherLabel => 'دیگر';

  @override
  String get whatKindOfThingHappened => 'کس قسم کی چیز ہوئی؟';

  @override
  String get whichOneLabel => 'کون سا؟';

  @override
  String get supplierLabel => 'سپلائر';

  @override
  String get whatWasWrongWithDelivery => 'ڈیلیوری میں کیا خرابی تھی؟';

  @override
  String get receivedByLabel => 'وصول کنندہ';

  @override
  String get whichSectionOptional => 'یہ کس سیکشن کے بارے میں ہے؟ (اختیاری)';

  @override
  String get noSectionLabel => 'کوئی سیکشن نہیں';

  @override
  String get teamOptionalLabel => 'ٹیم (اختیاری)';

  @override
  String get noSpecificTeamLabel => 'کوئی مخصوص ٹیم نہیں';

  @override
  String get whatHappenedLabel => 'کیا ہوا؟';

  @override
  String get markAsUrgentLabel => 'فوری کے طور پر نشان زد کریں';

  @override
  String get markUrgentSubtitle =>
      'یہ کتنی دیر سے حل طلب ہے اس سے قطع نظر فوری توجہ درکار ہے';

  @override
  String get logItButton => 'درج کریں';

  @override
  String get escalateToTitle => 'اسے بھیجیں';

  @override
  String get sendToLabel => 'انہیں بھیجیں';

  @override
  String get escalateButton => 'آگے بڑھائیں';

  @override
  String get savedLabel => 'محفوظ ہو گیا۔';

  @override
  String remindedMessage(String name) {
    return '$name کو یاد دلایا گیا۔';
  }

  @override
  String get couldNotSendReminder => 'یاد دہانی نہیں بھیجی جا سکی۔';

  @override
  String get viewSupplierScorecard => 'سپلائر اسکور کارڈ دیکھیں';

  @override
  String raisedAtLabel(String date) {
    return '$date کو درج کیا گیا';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'آگے بڑھایا گیا: $name';
  }

  @override
  String get historyLabel => 'تاریخ';

  @override
  String get addAnUpdateLabel => 'اپڈیٹ شامل کریں';

  @override
  String get addProcessNoteButton => 'پروسیس نوٹ شامل کریں';

  @override
  String get resolveButton => 'حل کریں';

  @override
  String get reopenThisIssueTitle => 'اس مسئلے کو دوبارہ کھولیں';

  @override
  String get whyReopenLabel => 'اسے دوبارہ کیوں کھولا جانا چاہیے؟';

  @override
  String get reopenButton => 'دوبارہ کھولیں';

  @override
  String sentToLabel(String name) {
    return '$name کو بھیجا گیا';
  }

  @override
  String get remindButton => 'یاد دہانی';

  @override
  String get phaseRaisedLabel => 'درج کیا گیا';

  @override
  String get phaseUpdateLabel => 'اپڈیٹ';

  @override
  String get phaseOutcomeLabel => 'نتیجہ';

  @override
  String get allLabel => 'تمام';

  @override
  String get dateRangeLabel => 'تاریخ کی حد';

  @override
  String get allDatesLabel => 'تمام تاریخیں';

  @override
  String get typeLabel => 'قسم';

  @override
  String get anyTypeLabel => 'کوئی بھی قسم';

  @override
  String get anyoneLabel => 'کوئی بھی';

  @override
  String staffFallback(String id) {
    return 'عملہ #$id';
  }

  @override
  String get nothingHereGoodSign => 'یہاں کچھ نہیں ہے - یہ اچھی علامت ہے۔';

  @override
  String escalatedToNameLabel(String name) {
    return '$name کو آگے بڑھایا گیا';
  }

  @override
  String get havenReportedYet => 'آپ نے ابھی تک کچھ رپورٹ نہیں کیا۔';

  @override
  String get failsAndProblemsRegisterTitle => 'فیل اور مسائل رجسٹر';

  @override
  String get taskProblemsTab => 'کام کے مسائل';

  @override
  String get issuesAndIncidentsTab => 'مسائل اور واقعات';

  @override
  String get failFilterLabel => 'فیل';

  @override
  String get reportedFilterLabel => 'رپورٹ کیا گیا';

  @override
  String get notCompletedFilterLabel => 'مکمل نہیں ہوا';

  @override
  String get abandonedLabel => 'ترک شدہ';

  @override
  String get noActionTakenLabel => 'کوئی کارروائی نہیں کی گئی';

  @override
  String get markResolvedButton => 'حل شدہ کے طور پر نشان زد کریں';

  @override
  String get openLabel => 'کھلا';

  @override
  String get enableRosterQuestion => 'روسٹر فعال کریں؟';

  @override
  String rosterQuoteBody(String amount) {
    return 'آپ کی موجودہ اسٹاف تعداد کی بنیاد پر، یہ آپ کے ماہانہ ڈائریکٹ ڈیبٹ میں $amount شامل کرے گا، جو آپ کی اگلی ادائیگی سے شروع ہوگا۔';
  }

  @override
  String get confirmAndEnable => 'تصدیق کریں اور فعال کریں';

  @override
  String couldNotReachVenurite(String error) {
    return 'VenuRite تک رسائی نہیں ہو سکی: $error';
  }

  @override
  String get letStaffClaimShifts => 'اسٹاف کو اپنی شفٹس خود دعویٰ کرنے دیں';

  @override
  String get rosterPitchBody =>
      'کھلی شفٹس پوسٹ کریں اور اسٹاف کو خود انہیں اٹھانے دیں - جب کوئی نہیں آ سکتا تو فون کرنے یا واٹس ایپ گروپ کی ضرورت نہیں۔ اسٹاف چھٹی کے دن کی درخواست بھی دے سکتا ہے، اور آپ اسی جگہ سے منظور یا مسترد کر سکتے ہیں۔';

  @override
  String get pricingLabel => 'قیمتیں';

  @override
  String get priceUnder10Staff => '10 سے کم اسٹاف والی برانچ کے لیے £6/ماہ';

  @override
  String get price10PlusStaff => '10 یا زیادہ اسٹاف والی برانچ کے لیے £10/ماہ';

  @override
  String get addedToDirectDebitNote =>
      'آپ کے موجودہ ڈائریکٹ ڈیبٹ میں شامل کیا گیا - کسی نئے ادائیگی کے طریقے کی ضرورت نہیں۔ تصدیق سے پہلے آپ کو صحیح رقم نظر آئے گی۔';

  @override
  String get enableRosterButton => 'روسٹر فعال کریں';

  @override
  String get availableShiftsTitle => 'دستیاب شفٹس';

  @override
  String get shiftClaimingNotEnabled =>
      'اس مقام کے لیے شفٹ کا دعویٰ ابھی فعال نہیں ہے۔ اپنے منیجر سے ترتیبات میں اسے فعال کرنے کو کہیں۔';

  @override
  String couldNotLoadShifts(String error) {
    return 'شفٹس لوڈ نہیں ہو سکیں: $error';
  }

  @override
  String get noShiftsPostedYet => 'ابھی تک کوئی شفٹ پوسٹ نہیں کی گئی۔';

  @override
  String get someoneElseClaimedShift =>
      'کسی اور نے ابھی وہ شفٹ دعویٰ کر لی - معذرت!';

  @override
  String get shiftClaimedMessage => 'شفٹ دعویٰ کر لی گئی۔';

  @override
  String get cancelThisShiftTitle => 'اس شفٹ کو منسوخ کریں؟';

  @override
  String get cancelShiftLateWarning =>
      '\n\nشفٹ شروع ہونے میں 24 گھنٹے سے کم وقت باقی ہے - ابھی منسوخ کرنے سے آپ کے اعتماد کے ریکارڈ پر اثر پڑ سکتا ہے۔';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'اب آپ اس شفٹ کے لیے دعویدار نہیں رہیں گے۔$warning';
  }

  @override
  String get keepShiftButton => 'شفٹ رکھیں';

  @override
  String get cancelShiftButton => 'شفٹ منسوخ کریں';

  @override
  String get yourShiftRecordReliable => 'آپ کا شفٹ ریکارڈ: قابل اعتماد';

  @override
  String get yourShiftRecordNeedsImprovement => 'آپ کا شفٹ ریکارڈ: بہتری درکار';

  @override
  String get yourShiftRecordBuilding =>
      'آپ کا شفٹ ریکارڈ: ٹریک ریکارڈ بن رہا ہے';

  @override
  String get claimLabel => 'دعویٰ کریں';

  @override
  String get claimedLabel => 'دعویٰ کر لیا گیا';

  @override
  String requestDateOffTitle(String date) {
    return '$date کی چھٹی کی درخواست دیں';
  }

  @override
  String get reasonOptionalLabel => 'وجہ (اختیاری)';

  @override
  String get submitRequestButton => 'درخواست جمع کروائیں';

  @override
  String get offDayRequestsNotEnabled =>
      'اس مقام کے لیے چھٹی کی درخواستیں ابھی فعال نہیں ہیں۔ اپنے منیجر سے ترتیبات میں روسٹر فعال کرنے کو کہیں۔';

  @override
  String get noOffDayRequestsYet =>
      'آپ کے پاس ابھی تک کوئی چھٹی کی درخواست نہیں ہے۔';

  @override
  String get yourRequestsLabel => 'آپ کی درخواستیں';

  @override
  String get approvedLabel => 'منظور شدہ';

  @override
  String get deniedLabel => 'مسترد شدہ';

  @override
  String get pendingLabel => 'زیر التوا';

  @override
  String get postAShiftTitle => 'شفٹ پوسٹ کریں';

  @override
  String get categoryHint => 'قسم (مثلاً کھولنا، بند کرنا)';

  @override
  String get pickStartTime => 'شروع کا وقت منتخب کریں';

  @override
  String get pickEndTime => 'اختتام کا وقت منتخب کریں';

  @override
  String get postLabel => 'پوسٹ کریں';

  @override
  String get assignShiftToTitle => 'اس شفٹ کو تفویض کریں';

  @override
  String get unknownLabel => 'نامعلوم';

  @override
  String get shiftsTabLabel => 'شفٹس';

  @override
  String get offDayRequestsTabLabel => 'چھٹی کی درخواستیں';

  @override
  String get rosterAddonNotEnabledManager =>
      'اس مقام کے لیے روسٹر ایڈ آن فعال نہیں ہے۔ شفٹس پوسٹ کرنا شروع کرنے کے لیے ترتیبات > کمپنی میں اسے فعال کریں۔';

  @override
  String get noShiftsTapPlus =>
      'ابھی تک کوئی شفٹ پوسٹ نہیں ہوئی۔ ایک شامل کرنے کے لیے + دبائیں۔';

  @override
  String get openStatusLabel => 'کھلی';

  @override
  String get assignedStatusPrefix => 'تفویض شدہ';

  @override
  String get claimedStatusPrefix => 'دعویٰ شدہ';

  @override
  String get assignDirectlyLabel => 'براہ راست تفویض کریں';

  @override
  String get removeClaimLabel => 'دعویٰ ہٹائیں';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'چھٹی کی درخواستیں لوڈ نہیں ہو سکیں: $error';
  }

  @override
  String get noOffDayRequests => 'کوئی چھٹی کی درخواست نہیں۔';

  @override
  String get approveLabel => 'منظور کریں';

  @override
  String get denyLabel => 'مسترد کریں';

  @override
  String get rosterAddonNotEnabledPlain =>
      'اس مقام کے لیے روسٹر ایڈ آن فعال نہیں ہے۔';

  @override
  String get noActiveStaffVenue => 'اس مقام پر ابھی تک کوئی فعال عملہ نہیں ہے۔';

  @override
  String get last90DaysAlphabetical =>
      'پچھلے 90 دن، شفٹ کیٹیگری کے مطابق۔ حروف تہجی کی ترتیب میں - درجہ بندی نہیں۔';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شفٹیں',
      one: '1 شفٹ',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'اس مدت میں کوئی شفٹ نہیں۔';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'یہ آپ کے دستاویزات فولڈر میں مقامی ڈیٹا بیس کی مکمل کاپی بناتا ہے۔ اسے بعد میں USB ڈرائیو یا کلاؤڈ سنک شدہ فولڈر میں منتقل کرنا ایک الگ دستی مرحلہ ہے۔';

  @override
  String get backupNameOptional => 'بیک اپ کا نام (اختیاری)';

  @override
  String get backupNameHint => 'مثلاً معائنے سے پہلے بیک اپ';

  @override
  String get backupCreatedTitle => 'بیک اپ بن گیا';

  @override
  String get tierTeamMember => 'ٹیم ممبر';

  @override
  String get tierSupervisor => 'سپروائزر';

  @override
  String get tierManager => 'منیجر';

  @override
  String get tierRegionalManager => 'علاقائی منیجر';

  @override
  String get tierDirector => 'ڈائریکٹر';

  @override
  String get anyTaskFail => 'کوئی بھی کام فیل';

  @override
  String taskFailLabel(String title) {
    return 'فیل: $title';
  }

  @override
  String get taskFailTemplateStale => 'کام فیل (ٹیمپلیٹ اب موجودہ نہیں ہے)';

  @override
  String get unknownUserLabel => 'نامعلوم صارف';

  @override
  String tierSuffixLabel(String tier) {
    return '$tier سطح';
  }

  @override
  String get unsetLabel => 'سیٹ نہیں';

  @override
  String get pushChannelLabel => 'پش';

  @override
  String get emailChannelLabel => 'ای میل';

  @override
  String get inAppOnlyLabel => 'صرف ایپ میں';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'ایپ میں + $channels';
  }

  @override
  String get tierColumnTeam => 'ٹیم';

  @override
  String get tierColumnSupv => 'سپر';

  @override
  String get tierColumnMgr => 'منیجر';

  @override
  String get tierColumnRegnl => 'علاقہ';

  @override
  String get tierColumnDir => 'ڈائر';

  @override
  String get quickSetupSectionTitle => 'فوری سیٹ اپ: فی کام فیل اطلاعات';

  @override
  String get tickTierNotified =>
      'منتخب کریں کہ کسی مخصوص کام کے فیل ہونے پر کس سطح کو مطلع کیا جائے۔';

  @override
  String get noTaskTemplatesSetUp =>
      'ابھی تک کوئی کام ٹیمپلیٹ سیٹ نہیں کیا گیا۔';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'مطلع کریں: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return '$tier سطح کی طرف سے سیٹ کیا گیا';
  }

  @override
  String get inactiveSuffixLabel => ' - غیر فعال';

  @override
  String get deactivateButton => 'غیر فعال کریں';

  @override
  String get reactivateButton => 'دوبارہ فعال کریں';

  @override
  String get newRuleTitle => 'نیا اصول';

  @override
  String get triggerLabel => 'محرک';

  @override
  String get notifyLabel => 'مطلع کریں';

  @override
  String get wholeRoleTierOption => 'پورا کردار کی سطح';

  @override
  String get specificPersonOption => 'ایک مخصوص شخص';

  @override
  String get roleTierLabel => 'کردار کی سطح';

  @override
  String get personLabel => 'شخص';

  @override
  String get pushLabel => 'پش';

  @override
  String get rulesInAppNotice =>
      'اصول اب ایپ میں دکھائے جاتے ہیں؛ پش/ای میل ترسیل ابھی بیک اینڈ سے منسلک نہیں ہے اور بعد کے سپرنٹ میں شامل کی جائے گی۔';

  @override
  String get saveRuleButton => 'اصول محفوظ کریں';

  @override
  String get addRuleButton => 'اصول شامل کریں';

  @override
  String get noNotificationRulesYet =>
      'ابھی تک کوئی اطلاع کا اصول سیٹ نہیں کیا گیا۔';
}
