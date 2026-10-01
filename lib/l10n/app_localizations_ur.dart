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
  String get shortDeliveryLabel => 'نامکمل ڈیلیوری';

  @override
  String get damagedStockLabel => 'خراب سٹاک';

  @override
  String get lateDeliveryLabel => 'دیر سے ڈیلیوری';

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
  String get venuesSectionTitle => 'وینیوز';

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
  String get categoryHint => 'جیسے ریفریجریشن مرمت، کیڑوں پر قابو';

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

  @override
  String get stepYourAccount => 'تمہارا اکاؤنٹ';

  @override
  String get stepCompanyDetails => 'کمپنی کی تفصیلات';

  @override
  String get stepOrgStructure => 'تنظیمی ڈھانچہ';

  @override
  String get stepFirstVenue => 'پہلا وینیو';

  @override
  String get stepStarterSetup => 'تمہارا ابتدائی سیٹ اپ';

  @override
  String get stepSubscription => 'سبسکرپشن';

  @override
  String get stepPayment => 'ادائیگی';

  @override
  String get termsOfServiceTitle => 'سروس کی شرائط';

  @override
  String get companySignupGenericError =>
      'تمہاری کمپنی بناتے وقت کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں - اگر یہ ہوتا رہے، تو VenuRite سے رابطہ کریں۔';

  @override
  String get directDebitStartError =>
      'ہم ڈائریکٹ ڈیبٹ سیٹ اپ خودکار طور پر شروع نہیں کر سکے - لاگ ان کرنے کے بعد تم یہ سیٹنگز سے کسی بھی وقت کر سکتے ہو۔';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get creatingEllipsis => 'بن رہا ہے...';

  @override
  String get startFreeTrialButton => 'مفت ٹرائل شروع کریں';

  @override
  String get companyCreatedTitle => 'کمپنی بن گئی';

  @override
  String get adminAccountIntro =>
      'چلو تمہارا اکاؤنٹ سیٹ کرتے ہیں۔ تم VenuRite پر اس کمپنی کے ایڈمن ہو گے، اور اندر آتے ہی اپنی ٹیم کو مدعو کر سکتے ہو۔';

  @override
  String get firstNameLabel => 'پہلا نام';

  @override
  String get lastNameLabel => 'آخری نام';

  @override
  String get passwordMinCharsHelper => 'کم از کم 8 حروف';

  @override
  String get companyDetailsIntro => 'ہمیں اپنی کمپنی کے بارے میں بتاؤ۔';

  @override
  String get tradingCompanyNameLabel => 'تجارتی / کمپنی کا نام';

  @override
  String get legalCompanyNameLabel => 'کمپنی کا قانونی نام (اختیاری)';

  @override
  String get legalCompanyNameHelper =>
      'اوپر دیے گئے تجارتی نام کو استعمال کرنے کے لیے خالی چھوڑیں';

  @override
  String get countryLabel => 'ملک';

  @override
  String get registeredAddressLabel => 'رجسٹرڈ / کاروباری پتہ (اختیاری)';

  @override
  String get vatNumberLabel => 'ویٹ / ٹیکس نمبر (اگر لاگو ہو)';

  @override
  String get billingContactEmailLabel => 'بلنگ رابطہ ای میل (اختیاری)';

  @override
  String get structureIntro =>
      'یہ ہے کہ VenuRite تمہاری کمپنی کو کیسے منظم کرتا ہے۔ ابھی تمہیں کچھ بھی سیٹ کرنے کی ضرورت نہیں - یہ بس اگلے مرحلے کو سمجھنے کے قابل بنانے کے لیے ہے۔';

  @override
  String get structureYourCompanyLabel => 'تمہاری کمپنی';

  @override
  String get structureYourCompanySublabel => 'ایک مجتمع اکاؤنٹ اور بل';

  @override
  String get structureRegionsLabel => 'علاقے (اختیاری)';

  @override
  String get structureRegionsSublabel =>
      'وینیوز کو ملک یا علاقے کے مطابق گروپ کریں - ضرورت نہ ہو تو چھوڑ دیں';

  @override
  String get structureVenuesLabel => 'وینیوز';

  @override
  String get structureVenuesSublabel =>
      'آج ایک وینیو، بعد میں سیکڑوں - کبھی بھی مزید شامل کریں';

  @override
  String get structureStaffLabel => 'عملہ';

  @override
  String get structureStaffSublabel => 'ہر وینیو کی ٹیم، وینیو بننے پر مدعو';

  @override
  String get structureOutro =>
      'آگے ہم تمہارا پہلا وینیو سیٹ کریں گے - علاقے اور مزید وینیوز تم ایپ کے اندر سے بعد میں شامل کر سکتے ہو۔';

  @override
  String get wizardFirstVenueHeroTitle => 'چلو تمہارا پہلا وینیو شامل کرتے ہیں';

  @override
  String get addMoreVenuesLaterText =>
      'تم بعد میں مزید وینیوز شامل کر سکتے ہو۔';

  @override
  String get venueNameLabel => 'وینیو کا نام';

  @override
  String get addressOptionalLabel => 'پتہ (اختیاری)';

  @override
  String get regionAreaOptionalLabel => 'علاقہ / خطہ (اختیاری)';

  @override
  String get regionAreaHelper =>
      'جیسے \"لاہور\" - صرف اسی وقت ضروری جب تمہارے پاس ایک سے زیادہ وینیو ہوں (یا ہوں گے)';

  @override
  String get venueTypeOptionalLabel => 'وینیو کی قسم (اختیاری)';

  @override
  String get venueTypeHelper =>
      'ایک منتخب کرنے پر تمہیں ایک تیار ابتدائی سیٹ دکھائی دے گا - ان کاموں اور آلات کے لیے جن کی تمہیں پہلے سے ضرورت معلوم ہے۔';

  @override
  String get payoffSkippedText =>
      'تم نے وینیو کی قسم منتخب کرنا چھوڑ دیا، اس لیے ابھی دکھانے کے لیے کوئی ابتدائی سیٹ نہیں ہے - اندر آنے کے بعد تم خود کام اور آلات شامل کر سکتے ہو۔';

  @override
  String get payoffErrorText =>
      'اس وینیو کی قسم کے لیے ابتدائی سیٹ لوڈ نہیں ہو سکا - اندر آنے کے بعد تم خود کام اور آلات شامل کر سکتے ہو۔';

  @override
  String get payoffHeroTitle =>
      'یہ ہے تمہاری تعمیل کی تیاری، استعمال کے لیے تیار';

  @override
  String get equipmentSectionLabel => 'آلات';

  @override
  String get subscriptionBannerText =>
      'ایک کمپنی اکاؤنٹ، ایک مجتمع بل - فی وینیو قیمت، کبھی فی شخص نہیں۔';

  @override
  String get subscriptionIntroText =>
      'آج تمہارے پاس کتنے وینیو ہیں، ہیڈ آفس سمیت اگر ہے تو؟ ابھی تم صرف اپنا پہلا وینیو سیٹ کرو گے - باقی تم ایپ کے اندر سے کبھی بھی شامل کر سکتے ہو۔';

  @override
  String get perBranchPriceLabel => '39 پاؤنڈ/وینیو/مہینہ';

  @override
  String get headOfficeIncludedLabel => '+ 1 ہیڈ آفس وینیو (4+ وینیوز)';

  @override
  String get discountCodeHint =>
      'کیا تمہارے پاس ڈسکاؤنٹ کوڈ ہے؟ تم اسے ڈائریکٹ ڈیبٹ سیٹ کرتے وقت درج کر سکتے ہو۔';

  @override
  String get trialBannerText =>
      'تم 14 دن کا مفت ٹرائل شروع کر رہے ہو - آج کارڈ کی ضرورت نہیں۔';

  @override
  String get paymentStepIntro =>
      'ہم تمہارے ٹرائل ختم ہونے سے پہلے ادائیگی سیٹ کرنے کے لیے کہیں گے، ایپ کے اندر سیٹنگز سے۔ ابھی کچھ بھی چارج نہیں ہوتا - بس ہمیں بتاؤ کہ تم کیسے ادائیگی کرنا پسند کرو گے۔';

  @override
  String get cardPaymentTitle => 'کارڈ ادائیگی (Stripe)';

  @override
  String get cardPaymentSubtitle => 'ڈیبٹ/کریڈٹ کارڈ، ماہانہ یا سالانہ بل';

  @override
  String get directDebitTitle => 'ڈائریکٹ ڈیبٹ (GoCardless)';

  @override
  String get directDebitSubtitle => 'بینک سے بینک ادائیگی، کارڈ کی ضرورت نہیں';

  @override
  String get decideLaterButton => 'میں بعد میں فیصلہ کروں گا/گی';

  @override
  String get decideLaterSnackbar =>
      'کوئی مسئلہ نہیں - تم یہ سیٹنگز سے کسی بھی وقت سیٹ کر سکتے ہو۔';

  @override
  String get agreeToTermsPrefix => 'میں نے پڑھ لیا ہے اور اتفاق کرتا/کرتی ہوں ';

  @override
  String get successActivatedBanner =>
      'تمہاری کمپنی اور پہلا وینیو سیٹ ہو گئے ہیں، اور تم لاگ ان ہو۔';

  @override
  String get successNotActivatedBanner =>
      'تمہاری کمپنی اور پہلا وینیو سیٹ ہو گئے ہیں۔ اپنے ای میل اور ابھی منتخب کردہ پاس ورڈ سے لاگ ان کرو۔';

  @override
  String get directDebitSettingUp => 'ڈائریکٹ ڈیبٹ سیٹ ہو رہا ہے...';

  @override
  String get directDebitOpenedBrowser =>
      'ہم نے ڈائریکٹ ڈیبٹ سیٹ اپ مکمل کرنے کے لیے تمہارا براؤزر کھول دیا ہے۔';

  @override
  String get inviteYourTeamTitle => 'اپنی ٹیم کو مدعو کرو';

  @override
  String get inviteYourTeamSubtitle =>
      'اختیاری - ابھی شفٹ پر موجود کسی کو بھی شامل کرو، یا چھوڑ کر بعد میں اسٹاف مینجمنٹ سے یہ کرو۔';

  @override
  String get jobTitleLabel => 'عہدہ';

  @override
  String get tierFieldLabel => 'سطح';

  @override
  String get addTeamMemberButton => 'ٹیم رکن شامل کریں';

  @override
  String get goToDashboardButton => 'ڈیش بورڈ پر جائیں';

  @override
  String get goToSignInButton => 'لاگ ان پر جائیں';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - مرحلہ $step / $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return '$email استعمال کرنے کے لیے خالی چھوڑیں';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'ہمارے پاس ابھی $venueType کے لیے پہلے سے بنا ابتدائی سیٹ نہیں ہے - اندر آنے کے بعد تم خود کام اور آلات شامل کر سکتے ہو۔';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$venueType کے لیے $sectionCount حصوں میں $totalTasks کام اور $equipmentCount آلات کی اقسام پہلے سے سیٹ کی گئی ہیں۔';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$venueType کے لیے $sectionCount حصوں میں $totalTasks کام پہلے سے سیٹ کیے گئے ہیں۔';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/مہینہ کل ($units وینیوز بل کیے گئے)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'پن: $pin';
  }

  @override
  String get jobRoleChefCook => 'شیف/باورچی';

  @override
  String get jobRoleKitchenPorter => 'کچن پورٹر';

  @override
  String get jobRoleFrontOfHouse => 'فرنٹ آف ہاؤس';

  @override
  String get jobRoleBar => 'بار';

  @override
  String get jobRoleManagement => 'انتظامیہ';

  @override
  String get jobRoleEveryone => 'سب';

  @override
  String get jobRoleMaintenance => 'دیکھ بھال';

  @override
  String get jobRoleHousekeeping => 'ہاؤس کیپنگ';

  @override
  String get jobRoleReception => 'استقبالیہ';

  @override
  String get jobRoleSecurity => 'سیکیورٹی';

  @override
  String get segmentFoodSafety => 'خوراک کی حفاظت اور درجہ حرارت کنٹرول';

  @override
  String get segmentAllergen => 'الرجن مینجمنٹ';

  @override
  String get segmentPersonalHygienePpe => 'ذاتی صفائی اور پی پی ای';

  @override
  String get segmentRefrigerationColdStorage => 'ریفریجریشن اور کولڈ اسٹوریج';

  @override
  String get segmentCookingLineEquipment => 'کوکنگ لائن آلات';

  @override
  String get segmentWashupDishwash => 'برتن دھونا';

  @override
  String get segmentCleaningSanitation => 'صفائی اور صحت و صفائی';

  @override
  String get segmentCleaningChemicals =>
      'صفائی کیمیکل اور استعمال ہونے والی اشیاء';

  @override
  String get segmentDryAmbientStorage => 'خشک اور عام درجہ حرارت اسٹوریج';

  @override
  String get segmentDeliveriesGoodsIn => 'ڈیلیوری اور سامان کی وصولی';

  @override
  String get segmentUtilitiesSafety => 'سہولیات اور حفاظت';

  @override
  String get segmentWastePestControl => 'فضلہ اور کیڑوں کا کنٹرول';

  @override
  String get segmentPreventiveMaintenance => 'احتیاطی دیکھ بھال (کچن کا سامان)';

  @override
  String get segmentStockControl => 'اسٹاک کنٹرول';

  @override
  String get segmentOpeningProcedures => 'کھولنے کے طریقہ کار';

  @override
  String get segmentClosingProcedures => 'بند کرنے کے طریقہ کار';

  @override
  String get segmentServiceReadiness => 'سروس کی تیاری';

  @override
  String get segmentFrontOfHouse => 'فرنٹ آف ہاؤس / سروس';

  @override
  String get segmentBarBeverage => 'بار اور مشروبات';

  @override
  String get segmentHotelSpecific => 'ہوٹل کے لیے مخصوص';

  @override
  String get segmentManagementComplianceOversight =>
      'انتظام اور تعمیل کی نگرانی';

  @override
  String get segmentMaintenance => 'دیکھ بھال';

  @override
  String get segmentHousekeeping => 'ہاؤس کیپنگ';

  @override
  String get segmentReception => 'استقبالیہ';

  @override
  String get segmentSecurity => 'سیکیورٹی';

  @override
  String get freqDaily => 'روزانہ';

  @override
  String get freqWeekly => 'ہفتہ وار';

  @override
  String get freqPerShift => 'فی شفٹ';

  @override
  String get freqThreeXDaily => 'دن میں 3 بار';

  @override
  String get freqTwoXDaily => 'دن میں 2 بار';

  @override
  String get freqPerBatch => 'فی بیچ';

  @override
  String get freqPerDelivery => 'فی ڈیلیوری';

  @override
  String get freqPerUse => 'فی استعمال';

  @override
  String get freqPerService => 'فی سروس';

  @override
  String get freqTwoXPerService => 'فی سروس 2 بار';

  @override
  String get freqEventBased => 'ایونٹ پر مبنی';

  @override
  String get freqAsNeeded => 'ضرورت کے مطابق';

  @override
  String get freqMonthly => 'ماہانہ';

  @override
  String get freqCustom => 'کسٹم';

  @override
  String get jobRoleFieldLabel => 'ملازمت کا کردار';

  @override
  String get pinFieldLabel => 'پن';

  @override
  String get addStaffMemberTitle => 'اسٹاف رکن شامل کریں';

  @override
  String get addLabel => 'شامل کریں';

  @override
  String get assignTasksTitle => 'کام تفویض کریں';

  @override
  String get noActiveSiteFoundError => 'کوئی فعال وینیو نہیں ملا۔';

  @override
  String get byPersonLabel => 'شخص کے مطابق';

  @override
  String get byTaskLabel => 'کام کے مطابق';

  @override
  String get noEquipmentOfTypeSetUp =>
      'اس قسم کا کوئی سامان ابھی تک سیٹ نہیں کیا گیا۔';

  @override
  String get applyButton => 'لاگو کریں';

  @override
  String get assignToTitle => 'کسے تفویض کریں';

  @override
  String get noStaffMatchTiers =>
      'کوئی عملہ ان سطحوں سے میل نہیں کھاتا جن پر یہ کام لاگو ہوتے ہیں۔';

  @override
  String get assignButton => 'تفویض کریں';

  @override
  String get showInstructionsTooltip => 'ہدایات دکھائیں';

  @override
  String get selectTasksToAssignLabel => 'تفویض کے لیے کام منتخب کریں';

  @override
  String get taskPresetsSectionTitle => 'کام کے پری سیٹس';

  @override
  String get showAllPresetsButton => 'تمام پری سیٹس دکھائیں';

  @override
  String get showTasksInGroupTooltip => 'اس گروپ میں کام دکھائیں';

  @override
  String get applyToMultipleButton => 'کئی افراد پر لاگو کریں';

  @override
  String get addCustomTaskButton => 'کسٹم کام شامل کریں';

  @override
  String get customTaskSectionTitle => 'کسٹم کام';

  @override
  String get titleFieldLabel => 'عنوان';

  @override
  String get departmentSectionLabel => 'شعبہ / حصہ';

  @override
  String get methodLabel => 'طریقہ';

  @override
  String get methodTick => 'ٹک';

  @override
  String get methodData => 'ڈیٹا';

  @override
  String get methodDataTick => 'ڈیٹا + ٹک';

  @override
  String get methodTickPhoto => 'ٹک + تصویر';

  @override
  String get methodDataPhoto => 'ڈیٹا + تصویر';

  @override
  String get methodNote => 'نوٹ';

  @override
  String get methodDataNote => 'ڈیٹا + نوٹ';

  @override
  String get methodNotePhoto => 'نوٹ + تصویر';

  @override
  String get methodTickNote => 'ٹک + نوٹ';

  @override
  String get methodMulti => 'ملٹی';

  @override
  String get requiresPhotoLabel => 'تصویر درکار ہے';

  @override
  String get requiresNotesLabel => 'نوٹس درکار ہیں';

  @override
  String get minLimitLabel => 'کم از کم حد';

  @override
  String get maxLimitLabel => 'زیادہ سے زیادہ حد';

  @override
  String get unitHintLabel => 'یونٹ (مثلاً سیلسیس)';

  @override
  String get equipmentTypeOptionalLabel => 'سامان کی قسم (اختیاری)';

  @override
  String get noneLabel => 'کوئی نہیں';

  @override
  String get priorityLabel => 'ترجیح';

  @override
  String get priorityCritical => 'نازک';

  @override
  String get priorityHigh => 'زیادہ';

  @override
  String get priorityStandard => 'معیاری';

  @override
  String get requiresCorrectiveActionLabel =>
      'ناکامی پر اصلاحی کارروائی درکار ہے';

  @override
  String get fixInstructionsLabel => 'اصلاحی ہدایات';

  @override
  String get customFieldsJsonLabel => 'کسٹم فیلڈز (JSON، اختیاری)';

  @override
  String get extraFieldsSectionTitle => 'اضافی فیلڈز (اختیاری)';

  @override
  String get removeTooltip => 'ہٹائیں';

  @override
  String get fieldLabelHint => 'فیلڈ لیبل (مثلاً PO نمبر)';

  @override
  String get extraFieldTypeText => 'متن';

  @override
  String get extraFieldTypeNumber => 'نمبر';

  @override
  String get extraFieldTypeDate => 'تاریخ';

  @override
  String get addFieldTooltip => 'فیلڈ شامل کریں';

  @override
  String get saveCustomTaskButton => 'کسٹم کام محفوظ کریں';

  @override
  String get adHocLabel => 'فوری';

  @override
  String get timeAllocatedLabel => 'وقت مختص';

  @override
  String get frequencyPrefixLabel => 'تعدد: ';

  @override
  String get atATimeLabel => 'ایک مقررہ وقت پر';

  @override
  String get fromStartOfShiftLabel => 'شفٹ کے آغاز سے';

  @override
  String get fromClockInLabel => 'کلاک اِن سے';

  @override
  String get availableFromEllipsis => 'دستیاب…';

  @override
  String get untilEllipsis => 'تک…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'کام تفویض کریں - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return '\"$name\" کس پر لاگو کریں؟';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return '$name کے تمام کام پہلے سے تفویض کیے جا چکے ہیں';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    return '$name سے $count کام شامل کیے گئے';
  }

  @override
  String applyPresetToTitle(String name) {
    return '\"$name\" لاگو کریں';
  }

  @override
  String assignTasksCountLabel(int count) {
    return 'عملے کو $count کام تفویض کریں…';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return '$staffCount اسٹاف اراکین میں $count تفویضات شامل کی گئیں';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'حصہ: $segment';
  }

  @override
  String taskCountLabel(int count) {
    return '$count کام';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'تمام کردار دکھائیں (طے شدہ: صرف $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - اس کے لیے ابھی تک کوئی سامان سیٹ نہیں کیا گیا';
  }

  @override
  String fromTimeLabel(String time) {
    return '$time سے';
  }

  @override
  String untilTimeLabel(String time) {
    return '$time تک';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return '$count تفویضات بنائی گئیں$skippedNote۔';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count چھوڑے گئے - پہلے سے تفویض یا کردار عدم مطابقت)';
  }

  @override
  String get serviceProvidersTitle => 'سروس فراہم کنندگان';

  @override
  String get myProvidersTab => 'میرے فراہم کنندگان';

  @override
  String get findProviderTab => 'فراہم کنندہ تلاش کریں';

  @override
  String get noBackendProviderNotice1 =>
      'دیگر وینیوز کے مشترکہ فراہم کنندگان کو براؤز کرنے کے لیے حقیقی کمپنی اکاؤنٹ لاگ ان ہونا ضروری ہے - یہ صرف مقامی ڈیمو لاگ ان سے کام نہیں کر سکتا۔ \"میرے فراہم کنندگان\" کے تحت تمہارے اپنے رابطے دونوں طرح کام کرتے ہیں۔';

  @override
  String get noBackendProviderNotice2 =>
      'اسے استعمال کرنے کے لیے حقیقی کمپنی اکاؤنٹ کے ساتھ قیادت رسائی سے لاگ ان کرو۔';

  @override
  String get providerDisclaimerText =>
      'VenuRite کسی بھی فہرست میں شامل فراہم کنندہ کی جانچ یا توثیق نہیں کرتا۔ جائزے دیگر وینیوز سے ہیں، VenuRite سے نہیں۔';

  @override
  String get addProviderButton => 'فراہم کنندہ شامل کریں';

  @override
  String get noProvidersYetText =>
      'تم نے ابھی تک کوئی سروس فراہم کنندہ شامل نہیں کیا۔';

  @override
  String get addServiceProviderDialogTitle => 'سروس فراہم کنندہ شامل کریں';

  @override
  String get categoryLabel => 'قسم';

  @override
  String get phoneOptionalLabel => 'فون (اختیاری)';

  @override
  String get emailOptionalLabel => 'ای میل (اختیاری)';

  @override
  String get notesOptionalPrivateLabel => 'نوٹس (اختیاری، صرف تمہارے لیے نجی)';

  @override
  String get happyToReviewShareLabel =>
      'مجھے جائزہ لینے اور شیئر کرنے میں خوشی ہوگی';

  @override
  String get shareVisibilityExplanation =>
      'دیگر وینیوز تمہاری ریٹنگز اور جائزے دیکھیں گے، نام/رابطہ اس وقت تک دھندلا رہے گا جب تک وہ اسے ان لاک نہ کریں۔';

  @override
  String get rateThisProviderLabel => 'اس فراہم کنندہ کی درجہ بندی کریں';

  @override
  String get priceRatingLabel => 'قیمت';

  @override
  String get punctualityRatingLabel => 'وقت کی پابندی';

  @override
  String get qualityRatingLabel => 'معیار';

  @override
  String get availabilityRatingLabel => 'دستیابی';

  @override
  String get reviewOptionalLabel => 'جائزہ (اختیاری)';

  @override
  String get reviewHintText =>
      'اپنے تجربے کو بیان کرو - براہ کرم کاروبار کا نام نہ بتائیں یا رابطہ تفصیلات شامل نہ کریں۔';

  @override
  String get sessionExpiredMessage =>
      'تمہارا سیشن ختم ہو گیا ہے - براہ کرم دوبارہ لاگ ان کرو۔';

  @override
  String get sharedWithOtherVenuesLabel => 'دیگر وینیوز کے ساتھ شیئر کیا گیا';

  @override
  String get privateLabel => 'نجی';

  @override
  String get rateReviewsButton => 'درجہ بندی / جائزے';

  @override
  String get searchByCategoryOrNameHint => 'قسم یا نام سے تلاش کریں';

  @override
  String get noContactsUnlockedThisMonth =>
      'اس مہینے ابھی تک کوئی رابطہ ان لاک نہیں ہوا۔';

  @override
  String get noSharedProvidersYetText =>
      'ابھی تک کوئی مشترکہ فراہم کنندہ نہیں - \"میرے فراہم کنندگان\" سے ایک شیئر کرنے والے پہلے شخص بنو۔';

  @override
  String get noProvidersMatchSearchText =>
      'تمہاری تلاش سے کوئی فراہم کنندہ میل نہیں کھاتا۔';

  @override
  String get noRatingsYetText => 'ابھی تک کوئی درجہ بندی نہیں';

  @override
  String get hiddenUntilUnlockedText => 'ان لاک ہونے تک چھپا ہوا';

  @override
  String get unnamedPlaceholder => '(بلا نام)';

  @override
  String get readReviewsButton => 'جائزے پڑھیں';

  @override
  String get unlockContactDetailsButton => 'رابطہ تفصیلات ان لاک کریں';

  @override
  String get reviewsTitle => 'جائزے';

  @override
  String get noReviewsYetText => 'ابھی تک کوئی جائزہ نہیں۔';

  @override
  String get addYourRatingLabel => 'اپنی درجہ بندی شامل کریں';

  @override
  String get submittingEllipsis => 'جمع ہو رہا ہے...';

  @override
  String get submitRatingButton => 'درجہ بندی جمع کریں';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'تمہارے جائزے میں $found شامل لگتا ہے۔ جمع کرنے سے پہلے براہ کرم رابطہ تفصیلات یا کاروبار کے نام ہٹا دو۔';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'تمہارے جائزے میں $found شامل لگتا ہے۔ جمع کرنے سے پہلے براہ کرم رابطہ تفصیلات یا کاروبار کے نام ہٹا دو - جائزے تب مفید (اور منصفانہ) رہتے ہیں جب وہ تجربے کو بیان کریں، نہ کہ براہ راست کسے کال کریں۔';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    return 'اس مہینے $count رابطے ان لاک کیے گئے۔';
  }

  @override
  String priceValueLabel(String value) {
    return 'قیمت $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'وقت کی پابندی $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'معیار $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'دستیابی $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    return '$parts ($count جائزے)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'قیمت $price - وقت کی پابندی $punctuality - معیار $quality - دستیابی $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'فون: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'ای میل: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'تازہ پیداوار';

  @override
  String get supplierCategoryMeatPoultry => 'گوشت اور مرغی';

  @override
  String get supplierCategoryDairyEggs => 'ڈیری اور انڈے';

  @override
  String get supplierCategoryFrozenGoods => 'منجمد سامان';

  @override
  String get supplierCategoryDryAmbientGoods => 'خشک اور عام درجہ حرارت سامان';

  @override
  String get supplierCategoryDrinksBeverages => 'مشروبات';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'کیمیکل اور صفائی کا سامان';

  @override
  String get supplierCategoryEquipmentMaintenance => 'سامان اور دیکھ بھال';

  @override
  String get supplierCategoryOther => 'دیگر';

  @override
  String get supplierStatusApproved => 'منظور شدہ';

  @override
  String get supplierStatusPending => 'زیر التواء';

  @override
  String get supplierStatusSuspended => 'معطل';

  @override
  String get addEquipmentTitle => 'سامان شامل کریں';

  @override
  String get venueSetupTitle => 'وینیو سیٹ اپ';

  @override
  String get nextButton => 'اگلا';

  @override
  String get finishSetupButton => 'سیٹ اپ مکمل کریں';

  @override
  String get renameAreaTitle => 'علاقے کا نام تبدیل کریں';

  @override
  String get renameEquipmentTitle => 'سامان کا نام تبدیل کریں';

  @override
  String get saveButton => 'محفوظ کریں';

  @override
  String get retireEquipmentTitle => 'سامان ہٹائیں';

  @override
  String get retireEquipmentConfirmText =>
      'اس سامان کو ہٹانے سے اسے تفویض کردہ تمام کام بھی غیر تفویض ہو جائیں گے۔ پچھلی جمع کرانے کی تاریخ محفوظ رہتی ہے۔ جاری رکھیں؟';

  @override
  String get retireButton => 'ہٹائیں';

  @override
  String get areasStepTitle => 'علاقے';

  @override
  String get areasStepIntro => 'اس وینیو کے آپریشنل علاقے شامل کریں۔';

  @override
  String get areaSuggestionKitchen => 'باورچی خانہ';

  @override
  String get areaSuggestionStorage => 'ذخیرہ';

  @override
  String get areaSuggestionReceiving => 'وصولی';

  @override
  String get areaSuggestionFrontOfHouse => 'فرنٹ آف ہاؤس';

  @override
  String get areaNameLabel => 'علاقے کا نام';

  @override
  String get addAreaTooltip => 'علاقہ شامل کریں';

  @override
  String get renameTooltip => 'نام تبدیل کریں';

  @override
  String get equipmentStepTitle => 'سامان';

  @override
  String get equipmentStepIntro =>
      'نامزد سامان کی مثالیں شامل کریں، جیسے \"فریج 1\"، \"فریج 2\"۔';

  @override
  String get showAllEquipmentTypesButton => 'تمام سامان کی اقسام دکھائیں';

  @override
  String get equipmentTypeLabel => 'سامان کی قسم';

  @override
  String get somethingElseOption => 'کچھ اور...';

  @override
  String get newEquipmentTypeNameLabel => 'نئی سامان کی قسم کا نام';

  @override
  String get confirmNewEquipmentTypeTooltip => 'نئی سامان کی قسم کی تصدیق کریں';

  @override
  String get noAreasForDeptText =>
      'تمہارے شعبے کے لیے ابھی تک کوئی علاقہ سیٹ نہیں کیا گیا - سامان پھر بھی بغیر علاقے کے شامل کیا جا سکتا ہے۔';

  @override
  String get noAreasAddOneText =>
      'ابھی تک کوئی علاقہ شامل نہیں کیا گیا - ایک شامل کرنے کے لیے واپس جاؤ۔';

  @override
  String get equipmentNameLabel => 'سامان کا نام';

  @override
  String get equipmentNameHint => 'جیسے میٹ واک ان، ڈیزرٹ فریج، بار فرائر';

  @override
  String get modelOptionalLabel => 'ماڈل (اختیاری)';

  @override
  String get serialNumberOptionalLabel => 'سیریل نمبر (اختیاری)';

  @override
  String get retireTooltip => 'ہٹائیں';

  @override
  String get reactivateTooltip => 'دوبارہ فعال کریں';

  @override
  String get unknownTypeLabel => 'نامعلوم قسم';

  @override
  String get unknownAreaLabel => 'نامعلوم علاقہ';

  @override
  String get staffStepTitle => 'عملہ';

  @override
  String get staffStepIntro =>
      'اسٹاف اراکین شامل کریں اور ان کی کردار سطح تفویض کریں۔';

  @override
  String get addStaffMemberButton => 'اسٹاف رکن شامل کریں';

  @override
  String get suppliersStepTitle => 'سپلائرز';

  @override
  String get suppliersStepIntro =>
      'اس وینیو کے ساتھ کام کرنے والے سپلائرز شامل کریں۔ منظوری کے نشانات EHO ایکسپورٹ پر ظاہر ہوتے ہیں - معطل سپلائرز مینیجرز کو دکھائے جاتے ہیں، خاموشی سے چھپائے نہیں جاتے۔';

  @override
  String get supplierNameLabel => 'سپلائر کا نام';

  @override
  String get contactOptionalLabel => 'رابطہ (اختیاری)';

  @override
  String get phoneOrEmailHint => 'فون یا ای میل';

  @override
  String get approvalStatusLabel => 'منظوری کی حیثیت';

  @override
  String get addSupplierButton => 'سپلائر شامل کریں';

  @override
  String venueSetupStepTitle(int step) {
    return 'وینیو سیٹ اپ - مرحلہ $step / 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'ماڈل: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'سیریل نمبر: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (ریٹائرڈ)';
  }

  @override
  String get addEquipmentTooltip => 'سامان شامل کریں';

  @override
  String get newPinLabel => 'نیا پن';

  @override
  String get editDetailsTitle => 'تفصیلات میں ترمیم کریں';

  @override
  String get sectionLabel => 'حصہ';

  @override
  String get noSectionOption => 'کوئی حصہ نہیں';

  @override
  String get inactiveParenSuffix => ' (غیر فعال)';

  @override
  String get noSpecificTeamOption => 'کوئی مخصوص ٹیم نہیں';

  @override
  String get noSectionsSetupText =>
      'اس وینیو میں ابھی تک کوئی حصہ سیٹ نہیں کیا گیا - پہلے ڈیپارٹمنٹ مینجمنٹ میں ایک شامل کریں۔';

  @override
  String get reportsToFieldLabel => 'رپورٹ کرتا ہے';

  @override
  String get notSetOption => 'سیٹ نہیں';

  @override
  String get deactivateStaffMemberTitle => 'اسٹاف رکن غیر فعال کریں';

  @override
  String get staffManagementTitle => 'اسٹاف مینجمنٹ';

  @override
  String get addStaffTooltip => 'اسٹاف شامل کریں';

  @override
  String get bulkImportTooltip => 'بلک درآمد';

  @override
  String get deactivatedSuffixLabel => '(غیر فعال)';

  @override
  String get moreActionsTooltip => 'مزید کارروائیاں';

  @override
  String get changeTierMenuItem => 'سطح تبدیل کریں';

  @override
  String get changeSectionMenuItem => 'حصہ تبدیل کریں';

  @override
  String get assignSupervisionMenuItem => 'نگرانی تفویض کریں';

  @override
  String get reportsToMenuItem => 'رپورٹ کرتا ہے';

  @override
  String get resetPinMenuItem => 'پن ری سیٹ کریں';

  @override
  String get trainingRecordsMenuItem => 'تربیتی ریکارڈ';

  @override
  String unknownUserIdFallback(String id) {
    return 'صارف #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'پن ری سیٹ کریں - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return '$name کے لیے پن ری سیٹ کیا گیا';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'کردار کی سطح تبدیل کریں - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'حصہ تبدیل کریں - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'نگرانی تفویض کریں - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return '$name کے لیے نگرانی کا دائرہ اپ ڈیٹ کیا گیا';
  }

  @override
  String reportsToTitle(String name) {
    return 'رپورٹ کرتا ہے - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name اب لاگ ان نہیں کر سکیں گے۔ ان کے فعال کام کی تفویضات غیر تفویض ہو جائیں گی۔ ان کی جمع کرانے کی تاریخ متاثر نہیں ہوگی۔ اسے بعد میں واپس پلٹا جا سکتا ہے۔';
  }

  @override
  String reportsToSubtitle(String name) {
    return '$name کو رپورٹ کرتا ہے';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return '$date کو $name کی طرف سے';
  }

  @override
  String get darkModeLabel => 'ڈارک موڈ';

  @override
  String get brandIdentityIntro =>
      'ایک برانڈ شناخت، پوری کمپنی میں مشترکہ - ہر وینیو پر لاگو ہوتی ہے، فی سائٹ نہیں۔';

  @override
  String get companyNameLabel => 'کمپنی کا نام';

  @override
  String get companyLogoLabel => 'کمپنی لوگو';

  @override
  String get chooseLogoButton => 'لوگو منتخب کریں';

  @override
  String get changeLogoButton => 'لوگو تبدیل کریں';

  @override
  String get brandColourLabel => 'برانڈ کا رنگ';

  @override
  String get customHexColourLabel => 'کسٹم ہیکس رنگ';

  @override
  String get enterValidHexColourError => 'ایک درست ہیکس رنگ درج کریں';

  @override
  String get contactPhoneLabel => 'رابطہ فون';

  @override
  String get contactEmailLabel => 'رابطہ ای میل';

  @override
  String get savingEllipsisLabel => 'محفوظ ہو رہا ہے...';

  @override
  String get saveBrandingButton => 'برانڈنگ محفوظ کریں';

  @override
  String get brandingSavedMessage => 'برانڈنگ محفوظ ہو گئی';

  @override
  String get customSwatchTooltip => 'کسٹم';

  @override
  String get rosterAddonTitle => 'اسٹاف شفٹ/روسٹر (+£6-£10/برانچ/مہینہ)';

  @override
  String get rosterAddonSubtitle =>
      'اسٹاف کو خود کھلی شفٹیں دیکھنے اور لینے دیں - مینیجر شفٹیں پوسٹ کرتا ہے، اسٹاف انہیں چنتا ہے۔ 10 سے کم اسٹاف والی برانچ کے لیے £6/مہینہ، 10 یا زیادہ کے لیے £10/مہینہ۔';

  @override
  String get enableRosterTitle => 'روسٹر فعال کریں؟';

  @override
  String get confirmButton => 'تصدیق کریں';

  @override
  String get clearDemoDataTitle => 'ڈیمو ڈیٹا صاف کریں؟';

  @override
  String get clearDemoDataConfirmText =>
      'یہ ہر ڈیمو اسٹاف رکن، برانچ اور شعبے کو مستقل طور پر حذف کر دیتا ہے، اور تمہیں لاگ آؤٹ کر دیتا ہے۔ اسے واپس نہیں کیا جا سکتا۔';

  @override
  String get clearEverythingButton => 'سب کچھ صاف کریں';

  @override
  String get clearDemoDataCardTitle => 'ڈیمو ڈیٹا صاف کریں';

  @override
  String get clearDemoDataCardBody =>
      'ہر ڈیمو اسٹاف رکن، برانچ اور شعبہ ہٹاؤ تاکہ تم اپنا سیٹ اپ شروع سے کر سکو۔';

  @override
  String get clearDemoDataButton => 'ڈیمو ڈیٹا صاف کریں';

  @override
  String get temperatureUnitLabel => 'درجہ حرارت کی اکائی';

  @override
  String get celsiusLabel => 'سیلسیس (°C)';

  @override
  String get fahrenheitLabel => 'فارن ہائیٹ (°F)';

  @override
  String get comingSoonLabel => 'جلد آ رہا ہے';

  @override
  String get presetColorOceanTeal => 'اوشن ٹیل';

  @override
  String get presetColorNavy => 'نیوی';

  @override
  String get presetColorIndigo => 'انڈیگو';

  @override
  String get presetColorSlate => 'سلیٹ';

  @override
  String get presetColorPlum => 'پلم';

  @override
  String get presetColorForest => 'فارسٹ';

  @override
  String get presetColorUmber => 'امبر';

  @override
  String get presetColorCharcoal => 'چارکول';

  @override
  String couldNotGetPriceError(String error) {
    return 'قیمت حاصل نہیں ہو سکی: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'تمہارے موجودہ اسٹاف کی تعداد کی بنیاد پر، یہ تمہارے ماہانہ ڈائریکٹ ڈیبٹ میں $amount شامل کر دے گا۔';
  }

  @override
  String get departmentLabel => 'شعبہ';

  @override
  String get noDepartmentOption => 'کوئی شعبہ نہیں';

  @override
  String get removeAnywayButton => 'پھر بھی ہٹائیں';

  @override
  String get branchTeamStructureTitle => 'برانچ ٹیم کا ڈھانچہ';

  @override
  String get noStaffAtBranchText => 'اس برانچ میں ابھی تک کوئی اسٹاف نہیں ہے۔';

  @override
  String get changeManagerMenuItem => 'مینیجر تبدیل کریں';

  @override
  String get moveDepartmentMenuItem => 'شعبہ/ٹیم منتقل کریں';

  @override
  String get editJobTitleMenuItem => 'عہدہ ترمیم کریں';

  @override
  String get removeFromBranchMenuItem => 'اس برانچ سے ہٹائیں';

  @override
  String changeManagerTitle(String name) {
    return 'مینیجر تبدیل کریں - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'شعبہ/ٹیم منتقل کریں - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'سطح تبدیل کریں - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'عہدہ ترمیم کریں - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return '$name کو اس برانچ سے ہٹائیں';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name اب لاگ ان نہیں کر سکیں گے۔ اسے بعد میں واپس پلٹا جا سکتا ہے۔';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    return 'فی الحال $count لوگ $name کو رپورٹ کرتے ہیں: $names۔ $name کو ہٹانے سے وہ دوبارہ تفویض ہونے تک غیر تفویض رہیں گے۔';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'اس کے بجائے انہیں $name کے اپنے مینیجر کو دوبارہ تفویض کریں';
  }

  @override
  String reportsCountBadge(int count) {
    return '$count ماتحت';
  }

  @override
  String get regionalManagerAssignedTitle => 'علاقائی مینیجر تفویض ہو گیا';

  @override
  String get noOrganisationOnSessionError => 'اس سیشن میں کوئی کمپنی نہیں ہے۔';

  @override
  String get newRegionNameTitle => 'نیا علاقہ نام';

  @override
  String get renameRegionTitle => 'علاقے کا نام تبدیل کریں';

  @override
  String get renameVenueTitle => 'وینیو کا نام تبدیل کریں';

  @override
  String get newVenueNameTitle => 'نیا وینیو نام';

  @override
  String get doneButton => 'ہو گیا';

  @override
  String get resetPasswordQuestionTitle => 'پاس ورڈ ری سیٹ کریں؟';

  @override
  String get resetButton => 'ری سیٹ کریں';

  @override
  String get passwordResetTitle => 'پاس ورڈ ری سیٹ ہو گیا';

  @override
  String get giveNewTempPasswordText =>
      'اس شخص کو ان کا نیا عارضی پاس ورڈ دیں۔';

  @override
  String get organisationTitle => 'کمپنی';

  @override
  String get headOfficeLabel => 'ہیڈ آفس';

  @override
  String get addRegionMenuItem => 'علاقہ شامل کریں';

  @override
  String get addVenueNoRegionMenuItem => 'وینیو شامل کریں (کوئی علاقہ نہیں)';

  @override
  String get venuesNoRegionLabel => 'وینیوز (کوئی علاقہ نہیں)';

  @override
  String get resetPasswordTooltip => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get addVenueMenuItem => 'وینیو شامل کریں';

  @override
  String get assignRegionalManagerMenuItem => 'علاقائی مینیجر تفویض کریں';

  @override
  String get reassignRegionalManagerMenuItem =>
      'علاقائی مینیجر دوبارہ تفویض کریں';

  @override
  String get noRegionalManagerYetText => 'ابھی تک کوئی علاقائی مینیجر نہیں';

  @override
  String get noVenuesInRegionText => 'اس علاقے میں ابھی تک کوئی وینیو نہیں ہے۔';

  @override
  String get noVenueManagerYetText => 'ابھی تک کوئی وینیو مینیجر نہیں';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'علاقائی مینیجر تفویض کریں - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'اکاؤنٹ اب فعال ہے۔ $name کو ان کی سائن ان تفصیلات دیں - وہ قیادت رسائی استعمال کرتے ہیں۔';
  }

  @override
  String emailColonLabel(String email) {
    return 'ای میل: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'عارضی پاس ورڈ: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'یہ فوری طور پر $name کا موجودہ پاس ورڈ غیر فعال کر دیتا ہے۔ تمہیں آگے دینے کے لیے ایک نیا عارضی پاس ورڈ ملے گا۔';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  وینیو مینیجر';
  }

  @override
  String get noSignedInUserError => 'کوئی سائن ان صارف نہیں ملا۔';

  @override
  String get customCategoryTitleLabel => 'کسٹم قسم کا عنوان';

  @override
  String get approvalNoteLabel => 'منظوری / ڈیو ڈیلیجنس نوٹ (اختیاری)';

  @override
  String get supplierManagementTitle => 'سپلائر مینجمنٹ';

  @override
  String get noSuppliersAddedYetText =>
      'ابھی تک کوئی سپلائر شامل نہیں کیا گیا۔';

  @override
  String get inactiveStandaloneLabel => '(غیر فعال)';

  @override
  String get changeApprovalStatusMenuItem => 'منظوری کی حیثیت تبدیل کریں';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'تفصیلات میں ترمیم کریں - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'منظوری کی حیثیت تبدیل کریں - $name';
  }

  @override
  String get newVenueTypeTitle => 'نئی وینیو قسم';

  @override
  String get renameOrganisationTitle => 'کمپنی کا نام تبدیل کریں';

  @override
  String get resetSetupCodeTitle => 'سیٹ اپ کوڈ ری سیٹ کریں؟';

  @override
  String get resetSetupCodeConfirmText =>
      'یہ اس وینیو کو استعمال کرنے والے ہر ٹیبلیٹ کو اس وقت تک منقطع کر دے گا جب تک انہیں نیا کوڈ نہیں دیا جاتا۔ جاری رکھیں؟';

  @override
  String get resetCodeButton => 'کوڈ ری سیٹ کریں';

  @override
  String get createNewVenueTitle => 'نیا وینیو بنائیں';

  @override
  String get multiSiteSupportPartialText =>
      'ملٹی سائٹ سپورٹ جزوی ہے: سامان، اسٹاف اور کام کی فہرستیں ابھی تک وینیو کے مطابق فلٹر نہیں کی گئیں، اس لیے دوسرے وینیو کے روزمرہ استعمال کی ابھی مکمل حمایت نہیں ہے۔ ایک بنانا محفوظ ہے، لیکن جب تک یہ نہیں بنتا، تم اس وینیو اور اصل وینیو کا ڈیٹا مشترکہ فہرستوں میں ملا ہوا دیکھو گے۔';

  @override
  String get createButton => 'بنائیں';

  @override
  String get venueDetailsTitle => 'وینیو تفصیلات';

  @override
  String get billingLabel => 'بلنگ';

  @override
  String get billingSubtitleText => 'پلان، حیثیت، ڈائریکٹ ڈیبٹ';

  @override
  String get activeLabel => 'فعال';

  @override
  String get setAsActiveButton => 'فعال کے طور پر سیٹ کریں';

  @override
  String get tabletSetupCodeTitle => 'ٹیبلیٹ سیٹ اپ کوڈ';

  @override
  String get tabletSetupCodeExplanation =>
      'اسے ایک بار نئے ٹیبلیٹ پر درج کریں تاکہ یہ اس وینیو کی اسٹاف فہرست دکھا سکے۔';

  @override
  String get generateCodeButton => 'کوڈ بنائیں';

  @override
  String get venueTypeSectionTitle => 'وینیو کی قسم';

  @override
  String get renamePresetTitle => 'پری سیٹ کا نام تبدیل کریں';

  @override
  String get noTaskTemplatesExistYetText =>
      'ابھی تک کوئی کام کا سانچہ موجود نہیں ہے۔';

  @override
  String get addTaskToPresetTitle => 'پری سیٹ میں کام شامل کریں';

  @override
  String get taskFieldLabel => 'کام';

  @override
  String get defaultFrequencyLabel => 'طے شدہ تعدد';

  @override
  String get noPresetsYetText => 'ابھی تک کوئی پری سیٹ نہیں۔';

  @override
  String get createPresetButton => 'پری سیٹ بنائیں';

  @override
  String get presetVerificationBannerText =>
      'کام کی حدود تحقیق شدہ اور ماخذ کے ساتھ ہیں (ہر کام کی ہدایات میں [LAW]/[FSA]/[BEST] کا نشان لگایا گیا ہے) لیکن ابھی تک کسی مستند فوڈ سیفٹی پیشہ ور کی طرف سے منظور شدہ نہیں ہیں۔ تصدیق ہونے تک انہیں قانونی طور پر مستند نہ سمجھیں۔';

  @override
  String get equipmentPresetsSectionTitle => 'سامان کے پری سیٹس';

  @override
  String get sectionPresetsSectionTitle => 'حصے کے پری سیٹس';

  @override
  String get addTaskButton => 'کام شامل کریں';

  @override
  String get newPresetSectionTitle => 'نیا پری سیٹ';

  @override
  String get sectionSegmentOptionalLabel => 'حصہ / سیگمنٹ (اختیاری)';

  @override
  String get setEquipmentOrSectionHint =>
      'سامان کی قسم یا ایک حصہ سیٹ کریں (کم از کم ایک)۔';

  @override
  String equipmentTypeFallback(String id) {
    return 'سامان کی قسم #$id';
  }

  @override
  String taskFallback(String id) {
    return 'کام #$id';
  }

  @override
  String get departmentCategoryKitchen => 'باورچی خانہ';

  @override
  String get departmentCategoryFrontOfHouse => 'فرنٹ آف ہاؤس';

  @override
  String get departmentCategoryBar => 'بار';

  @override
  String get departmentCategoryManagement => 'انتظامیہ';

  @override
  String get departmentCategoryMaintenance => 'دیکھ بھال';

  @override
  String get departmentCategoryHousekeeping => 'ہاؤس کیپنگ';

  @override
  String get departmentCategoryReception => 'استقبالیہ';

  @override
  String get departmentCategorySecurity => 'سیکیورٹی';

  @override
  String get addDepartmentButton => 'شعبہ شامل کریں';

  @override
  String get departmentManagementTitle => 'شعبہ جاتی انتظام';

  @override
  String get noDepartmentsAddedYetText =>
      'ابھی تک کوئی شعبہ شامل نہیں کیا گیا۔';

  @override
  String get noTeamsYetText => 'ابھی تک کوئی ٹیم نہیں';

  @override
  String get editMenuItem => 'ترمیم کریں';

  @override
  String get addTeamButton => 'ٹیم شامل کریں';

  @override
  String editDepartmentTitle(String name) {
    return 'ترمیم کریں - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'ٹیم شامل کریں - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'نام تبدیل کریں - $name';
  }

  @override
  String teamCountLabel(int count) {
    return '$count ٹیمیں';
  }

  @override
  String get documentCategoryPolicy => 'پالیسی';

  @override
  String get documentCategoryCertificate => 'سرٹیفکیٹ';

  @override
  String get documentCategoryProcedure => 'طریقہ کار';

  @override
  String get documentCategoryEhoReport => 'EHO رپورٹ';

  @override
  String get addDocumentTitle => 'دستاویز شامل کریں';

  @override
  String get noExpiryDateText => 'کوئی میعاد ختم ہونے کی تاریخ نہیں';

  @override
  String get setExpiryButton => 'میعاد مقرر کریں';

  @override
  String get couldNotOpenFileText => 'یہ فائل نہیں کھولی جا سکی۔';

  @override
  String get documentCentreTitle => 'دستاویزات مرکز';

  @override
  String get validLabel => 'درست';

  @override
  String get expiringSoonLabel => 'جلد ختم ہونے والا';

  @override
  String get expiredLabel => 'ختم شدہ';

  @override
  String get allFilterLabel => 'تمام';

  @override
  String get noDocumentsYetText => 'ابھی تک کوئی دستاویز نہیں۔';

  @override
  String get openMenuItem => 'کھولیں';

  @override
  String expiresOnLabel(String date) {
    return '$date کو ختم ہوتا ہے';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'کوئی پلان منتخب نہیں';

  @override
  String get codeNotRecognisedText => 'وہ کوڈ تسلیم نہیں کیا گیا۔';

  @override
  String get couldNotReachServerText => 'سرور تک نہیں پہنچا جا سکا۔';

  @override
  String get discountAppliedText => 'ڈسکاؤنٹ کوڈ لاگو کیا گیا۔';

  @override
  String get couldNotOpenBrowserText => 'براؤزر نہیں کھولا جا سکا';

  @override
  String get noSubscriptionFoundText =>
      'اس کمپنی کے لیے کوئی سبسکرپشن نہیں ملی۔';

  @override
  String get discountAppliedBadge => 'رعایت لاگو';

  @override
  String get directDebitSetUpText => 'اس کمپنی کے لیے ڈائریکٹ ڈیبٹ سیٹ اپ ہے۔';

  @override
  String get directDebitNotSetUpText =>
      'تم نے ابھی تک ڈائریکٹ ڈیبٹ سیٹ اپ نہیں کیا۔ تمہیں GoCardless پر لے جایا جائے گا - VenuRite تمہارے بینک کی تفصیلات کبھی براہ راست نہیں دیکھتا۔';

  @override
  String get discountCodeOptionalLabel => 'ڈسکاؤنٹ کوڈ (اختیاری)';

  @override
  String get discountCodeHintText =>
      'کیا تمہارے پاس \'Friends\' کوڈ ہے؟ اسے یہاں درج کرو';

  @override
  String get setUpDirectDebitButton => 'ڈائریکٹ ڈیبٹ سیٹ کریں';

  @override
  String get freeAccessCodeTitle => 'مفت رسائی کوڈ';

  @override
  String get freeAccessActiveText =>
      'اس کمپنی کے لیے مفت رسائی فعال ہے - کوئی ڈائریکٹ ڈیبٹ یا کارڈ ادائیگی درکار نہیں۔';

  @override
  String get freeAccessPromptText =>
      'کیا تمہارے پاس مفت رسائی کوڈ ہے؟ ادائیگی سیٹ کیے بغیر مکمل ایپ استعمال کرنے کے لیے اسے یہاں درج کرو۔';

  @override
  String get redeemCodeButton => 'کوڈ ریڈیم کریں';

  @override
  String get onTrialText => 'ٹرائل پر';

  @override
  String get paymentFailedGraceText =>
      'حالیہ ادائیگی ناکام ہوگئی۔ براہ کرم اپنا ڈائریکٹ ڈیبٹ اپ ڈیٹ کرو - اس رعایتی مدت کے دوران رسائی جاری رہتی ہے۔';

  @override
  String get directDebitCancelledRestrictedText =>
      'تمہارا ڈائریکٹ ڈیبٹ منسوخ کر دیا گیا تھا۔ بلنگ دوبارہ سیٹ ہونے تک رسائی صرف پڑھنے تک محدود ہے۔';

  @override
  String get paymentOverdueRestrictedText =>
      'ادائیگی بہت طویل عرصے سے واجب الادا ہے۔ اس کے حل ہونے تک رسائی صرف پڑھنے تک محدود ہے۔';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'بلنگ کی تفصیلات لوڈ نہیں ہو سکیں: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '£$price/مہینہ ($units شاخیں بل کی گئیں)';
  }

  @override
  String onTrialUntilText(String date) {
    return '$date تک ٹرائل پر';
  }

  @override
  String get reportedIssuesTitle => 'رپورٹ شدہ مسائل';

  @override
  String get noDeliveriesLoggedText =>
      'اس مدت میں اس سپلائر کے لیے کوئی ڈیلیوری درج نہیں کی گئی۔';

  @override
  String get scorecardCategoriesExplanation =>
      'ذیل میں ہر قسم آزادانہ طور پر شمار ہوتی ہے - ایک ڈیلیوری ایک سے زیادہ قطار میں ظاہر ہو سکتی ہے (مثلاً دیر سے اور خراب دونوں)۔';

  @override
  String get rejectedOutrightLabel => 'مکمل طور پر مسترد';

  @override
  String get acceptedPartiallyLabel => 'جزوی طور پر قبول';

  @override
  String get reportedIssuesExplanation =>
      'اس سپلائر کے خلاف رپورٹ کیے گئے سپلائی کے مسائل - اوپر دیے گئے ڈیلیوری سکور کارڈ سے ایک الگ لاگ، اس میں شامل نہیں کیا گیا۔';

  @override
  String deliveryScorecardTitle(int count) {
    return 'ڈیلیوری سکور کارڈ ($count ڈیلیوریز)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'نام غائب ہے';

  @override
  String get missingJobTitleError => 'عہدہ غائب ہے';

  @override
  String get pinMustBe4DigitsError =>
      'پن بالکل 4 ہندسوں کا ہونا چاہیے (یا خالی چھوڑیں)';

  @override
  String get bulkStaffImportTitle => 'بلک اسٹاف درآمد';

  @override
  String get csvColumnsInstructionsText =>
      'CSV کالمز: نام، عہدہ، کردار کی سطح، ملازمت کا کردار (اختیاری)، پن (اختیاری)۔ ہیڈر قطار ٹھیک ہے - یہ خودکار طور پر پہچانی جاتی ہے۔ تمہارے لیے ایک بنانے کے لیے پن خالی چھوڑ دو۔';

  @override
  String get chooseCsvFileButton => 'CSV فائل منتخب کریں';

  @override
  String get chooseDifferentFileButton => 'ایک مختلف فائل منتخب کریں';

  @override
  String get noteDownPinsText =>
      ' اس اسکرین کو چھوڑنے سے پہلے ذیل میں ہر پن نوٹ کر لیں۔';

  @override
  String get importingEllipsisLabel => 'درآمد ہو رہا ہے...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'کردار کی سطح ان میں سے ایک ہونی چاہیے: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'تمہیں $tier اکاؤنٹ بنانے کی اجازت نہیں ہے';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'ملازمت کا کردار ان میں سے ایک ہونا چاہیے: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'مثال: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - $count قطاریں ملیں';
  }

  @override
  String needFixingSuffix(int count) {
    return '، $count کو درست کرنے کی ضرورت ہے';
  }

  @override
  String createdCountLabel(int count) {
    return '$count بنائے گئے';
  }

  @override
  String failedSuffixLabel(int count) {
    return '، $count ناکام';
  }

  @override
  String importStaffCountButton(int count) {
    return '$count اسٹاف اراکین درآمد کریں';
  }

  @override
  String rowNumberFallback(int number) {
    return 'قطار $number';
  }

  @override
  String jobTitleTierLabel(String jobTitle, String tier) {
    return '$jobTitle - $tier';
  }

  @override
  String pinSuffixLabel(String pin) {
    return ' - پن: $pin';
  }

  @override
  String get trainingLevel2FoodHygiene => 'لیول 2 فوڈ ہائجین اینڈ سیفٹی';

  @override
  String get trainingAllergenAwareness => 'الرجن آگاہی';

  @override
  String get trainingCoshh => 'COSHH (صحت کے لیے خطرناک مادوں کا کنٹرول)';

  @override
  String get trainingFireSafety => 'آگ کی حفاظت';

  @override
  String get trainingManualHandling => 'دستی ہینڈلنگ';

  @override
  String get trainingFirstAid => 'کام کی جگہ پر ابتدائی طبی امداد';

  @override
  String get trainingInduction => 'انڈکشن مکمل';

  @override
  String get itemFieldLabel => 'آئٹم';

  @override
  String get customItemTitleLabel => 'کسٹم آئٹم کا عنوان';

  @override
  String get expiryNoneLabel => 'میعاد: کوئی نہیں';

  @override
  String get clearExpiryTooltip => 'میعاد صاف کریں';

  @override
  String get certificateReferenceLabel => 'سرٹیفکیٹ حوالہ (اختیاری)';

  @override
  String get certificateReferenceHint => 'جیسے سرٹیفکیٹ نمبر، فراہم کنندہ';

  @override
  String get noTrainingRecordsYetText => 'ابھی تک کوئی تربیتی ریکارڈ نہیں۔';

  @override
  String get addRecordButton => 'ریکارڈ شامل کریں';

  @override
  String get currentLabel => 'موجودہ';

  @override
  String get supersededLabel => '(تبدیل شدہ)';

  @override
  String get noExpiryLabel => 'کوئی میعاد نہیں';

  @override
  String addTrainingRecordTitle(String name) {
    return 'تربیتی ریکارڈ شامل کریں - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'مکمل: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'میعاد: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'تربیتی ریکارڈ - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    return 'مکمل تاریخ ($count پرانے ریکارڈز)';
  }

  @override
  String completedDateLabel(String date) {
    return '$date کو مکمل';
  }

  @override
  String certRefLabel(String ref) {
    return 'حوالہ: $ref';
  }

  @override
  String get twoFactorNowOnText => 'ٹو فیکٹر توثیق اب فعال ہے۔';

  @override
  String get turnOffTwoFactorTitle => 'ٹو فیکٹر توثیق بند کریں؟';

  @override
  String get turnOffTwoFactorConfirmText =>
      'یہ اکاؤنٹ دوبارہ صرف پاس ورڈ کے ساتھ سائن ان کرے گا۔';

  @override
  String get turnOffButton => 'بند کریں';

  @override
  String get twoFactorAuthTitle => 'ٹو فیکٹر توثیق';

  @override
  String get twoFactorOnText => 'اس اکاؤنٹ کے لیے ٹو فیکٹر توثیق فعال ہے۔';

  @override
  String get twoFactorOffText =>
      'ٹو فیکٹر توثیق غیر فعال ہے - اس سینئر اکاؤنٹ پر تحفظ کی اضافی پرت کے لیے اسے شامل کریں۔';

  @override
  String get enableTwoFactorButton => 'ٹو فیکٹر توثیق فعال کریں';

  @override
  String get scanAuthenticatorText =>
      'اسے اپنی توثیق کنندہ ایپ (Google Authenticator، Authy، وغیرہ) سے اسکین کریں، پھر دکھایا گیا 6 ہندسوں کا کوڈ درج کریں۔';

  @override
  String get cantScanManualEntryText =>
      'اسکین نہیں کر سکتے؟ یہ کوڈ دستی طور پر درج کریں:';

  @override
  String get requiredFieldError => 'درکار';

  @override
  String get joinExistingCompanyTitle => 'موجودہ کمپنی میں شامل ہوں';

  @override
  String get enterInviteCodeText =>
      'وہ دعوتی کوڈ درج کرو جو تمہارے مینیجر نے دیا۔';

  @override
  String get inviteCodeLabel => 'دعوتی کوڈ';

  @override
  String get yourNameLabel => 'تمہارا نام';

  @override
  String get yourEmailLabel => 'تمہارا ای میل';

  @override
  String get enterValidEmailError => 'ایک درست ای میل درج کرو';

  @override
  String get choosePasswordLabel => 'پاس ورڈ منتخب کرو';

  @override
  String get joinButton => 'شامل ہوں';

  @override
  String get youreInSignInText =>
      'تم اندر ہو۔ اپنے ای میل اور ابھی منتخب کردہ پاس ورڈ سے لاگ ان کرو۔';

  @override
  String get newBranchNameTitle => 'نئی برانچ کا نام';

  @override
  String get renameBranchTitle => 'برانچ کا نام تبدیل کریں';

  @override
  String get branchManagerNameTitle => 'برانچ مینیجر کا نام';

  @override
  String get accountCreatedTitle => 'اکاؤنٹ بن گیا';

  @override
  String get giveNameAndPinText =>
      'اس شخص کو ان کا نام (لاگ ان اسکرین پر ٹیپ کرنے کے لیے) اور یہ پن دیں۔';

  @override
  String get branchesTitle => 'برانچیں';

  @override
  String get noRegionSetText =>
      'تمہارے اکاؤنٹ میں کوئی علاقہ سیٹ نہیں ہے - اپنے ڈائریکٹر سے رابطہ کرو۔';

  @override
  String get noBranchesInRegionText =>
      'تمہارے علاقے میں ابھی تک کوئی برانچ نہیں ہے۔';

  @override
  String get addBranchManagerMenuItem => 'برانچ مینیجر شامل کریں';

  @override
  String nameColonLabel(String name) {
    return 'نام: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'پن: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'منتخب شواہد حذف کریں؟';

  @override
  String get deleteButton => 'حذف کریں';

  @override
  String get photoEvidenceTitle => 'فوٹو شواہد';

  @override
  String get onThisDeviceLabel => 'اس ڈیوائس پر';

  @override
  String get deletingFreesSpaceText =>
      'حذف کرنے سے ڈیوائس کی جگہ بھی خالی ہوتی ہے۔ ایکسپورٹ شدہ EHO PDF میں پہلے سے ہی اپنی کاپیاں موجود ہیں اور متاثر نہیں ہوں گی۔';

  @override
  String get noEvidencePhotosYetText => 'ابھی تک کوئی شواہد فوٹو نہیں۔';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'یہ اس ڈیوائس سے $count تصاویر ($bytes) کو مستقل طور پر حذف کر دیتا ہے۔ پہلے سے ایکسپورٹ شدہ PDF متاثر نہیں ہوں گی۔ اسے واپس نہیں کیا جا سکتا۔';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count شواہد تصاویر · کل $bytes';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return '$count منتخب شدہ حذف کریں ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'ٹیم رکن شامل کریں';

  @override
  String get createsTapNamePinAccountText =>
      'تمہارے اپنے وینیو کے لیے ٹیپ نام + پن اکاؤنٹ بناتا ہے۔';

  @override
  String get createAccountButton => 'اکاؤنٹ بنائیں';

  @override
  String get shiftLogTitle => 'شفٹ لاگ';

  @override
  String get noClockInsYetText => 'ابھی تک کوئی کلاک ان درج نہیں ہوا۔';

  @override
  String get stillClockedInText => 'ابھی بھی کلاک ان';

  @override
  String clockInLabel(String time) {
    return 'اندر: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'باہر: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String get inviteCreatedTitle => 'دعوت نامہ بن گیا';

  @override
  String get orShareCodeText =>
      'یا یہ کوڈ شیئر کرو - وہ اسے \"موجودہ کمپنی میں شامل ہوں\" اسکرین پر درج کریں گے:';

  @override
  String shareInviteExpiresText(int days) {
    return 'اسے شامل ہونے والے شخص کے ساتھ شیئر کرو - یہ ایک بار کام کرتا ہے اور $days دنوں میں ختم ہو جاتا ہے۔';
  }

  @override
  String get contactVenuRiteTitle => 'VenuRite سے رابطہ کریں';

  @override
  String get contactVenuRiteIntroText =>
      'چاہے تم ایک بڑا گروپ ہو جسے سیٹ اپ میں مدد چاہیے، یا بس کوئی سوال ہو - ہمیں مدد کرنے میں خوشی ہوگی۔';

  @override
  String get emailUsButton => 'ہمیں ای میل کریں';

  @override
  String taskCountOverdueLabel(int count) {
    return '$count کام تاخیر کا شکار';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    return '$count اسٹاف اراکین میں';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count مزید اسٹاف اراکین';
  }

  @override
  String failCountLabel(int count) {
    return '$count ناکامی';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count نامکمل';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    return '$count مسائل اٹھائے گئے';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'شفٹ کا خلاصہ - $name';
  }

  @override
  String get faqQ1 => 'میرا لاگ کون دیکھ سکتا ہے؟';

  @override
  String get faqA1 =>
      'تمہارا مینیجر اور تمہارے وینیو میں ان سے اوپر کوئی بھی وہ کام دیکھ سکتا ہے جو تم مکمل کرتے ہو۔ کسی نامزد شخص کو کبھی بھی درجہ بند سکور یا لیگ ٹیبل نہیں دکھائی جاتی - صرف یہ سادہ فہرست کہ انہوں نے کیا اور کب کیا۔';

  @override
  String get faqQ2 =>
      'اگر میں اپنی شفٹ کے دوران کوئی کام چوک جاؤں تو کیا ہوگا؟';

  @override
  String get faqA2 =>
      'اسے ناکامی کے طور پر نہیں، بلکہ نامکمل کے طور پر درج کیا جاتا ہے - شفٹ کے درمیان چھوڑا گیا کام ایک متوقع، اجازت یافتہ رویہ ہے، بس اسے کبھی چھپایا نہیں جاتا۔ تمہارا مینیجر اسے اپنی الگ، مخصوص حیثیت کے طور پر دیکھتا ہے۔';

  @override
  String get faqQ3 => 'کیا میں واپس جا کر چھوڑا ہوا کام مکمل کر سکتا ہوں؟';

  @override
  String get faqA3 =>
      'ہاں، تمہاری شفٹ ختم ہونے سے پہلے کسی بھی وقت - یہ تمہاری کام کی فہرست میں اس وقت تک دستیاب رہتا ہے جب تک تم اسے مکمل نہیں کرتے یا تمہاری شفٹ ختم نہیں ہوتی۔';

  @override
  String get faqQ4 =>
      'اگر میں کوئی جانچ میں ناکام ہو جاؤں (جیسے فریج بہت گرم ہے) تو کیا کروں؟';

  @override
  String get faqA4 =>
      'اسے ناکامی کے طور پر درج کرو، تم نے جو اصلاحی کارروائی کی (یا اس کی اطلاع دی) اسے ریکارڈ کرو، اور مانگے جانے پر ایک تصویر شامل کرو۔ یہ بالکل اسی کے لیے نظام ہے - ایک اصلاح کے ساتھ درج ناکامی ایک انسپکٹر کے لیے کامیابی کی کہانی ہے، تمہارے لیے مسئلہ نہیں۔';

  @override
  String get faqQ5 => 'کیا مجھے لاگ ان سے الگ کلاک ان اور کلاک آؤٹ کرنا ہوگا؟';

  @override
  String get faqA5 =>
      'نہیں - تمہاری شفٹ کے آغاز میں اپنے پن سے لاگ ان کرنا ہی تمہارا کلاک ان ہے۔ ختم کرتے وقت \'شفٹ ختم کریں\' استعمال کرو، جو تمہیں وہ سب بھی دکھاتا ہے جو تمہیں ابھی بھی مکمل کرنا ہے۔';

  @override
  String get faqQ6 => 'میں نے ایک مسئلہ اٹھایا - اس کا کیا ہوتا ہے؟';

  @override
  String get faqA6 =>
      'یہ تمہارے مینیجر کے پاس جاتا ہے (یا وقت پر نہ نمٹایا جائے تو مزید بڑھ جاتا ہے)۔ تم \"میرے اٹھائے گئے مسائل\" سے کسی بھی وقت اس کی حیثیت دیکھ سکتے ہو۔';

  @override
  String get troubleQ1 => 'میرا پن کام نہیں کر رہا';

  @override
  String get troubleA1 =>
      'دوبارہ چیک کرو کہ تم پہلے اپنا نام ٹیپ کر رہے ہو، پھر پن درج کر رہے ہو - صحیح نام پر غلط پن ایک واضح مسترد پیغام دیتا ہے۔ اگر پھر بھی کام نہ کرے، تو مینیجر سے کہو کہ وہ چیک کریں کہ تمہارا اکاؤنٹ فعال ہے اور ضرورت پڑنے پر تمہارا پن دوبارہ ترتیب دیں۔';

  @override
  String get troubleQ2 =>
      'میری فہرست سے ایک کام غائب ہے جو مجھے ہونا چاہیے تھا';

  @override
  String get troubleA2 =>
      'اپنے مینیجر سے کہو کہ وہ کام تفویض کریں میں چیک کریں کہ یہ تمہارے کردار/حصے کو تفویض کیا گیا ہے۔ کام صرف ان کرداروں اور شعبوں کے لیے ظاہر ہوتے ہیں جن کے لیے انہیں فعال کیا گیا ہے۔';

  @override
  String get troubleQ3 => 'ایپ مجھے تصویر لینے نہیں دے رہی';

  @override
  String get troubleA3 =>
      'یقینی بناؤ کہ ایپ کے پاس کیمرے کی اجازت ہے (اپنی ڈیوائس کی سیٹنگز چیک کرو)۔ ونڈوز پر، اگر کوئی کیمرہ نہیں ملتا، تو اس کے بجائے تمہیں فائل پکر دیا جائے گا۔';

  @override
  String get troubleQ4 =>
      'میں جانچ جمع نہیں کروا سکتا / جمع کروائیں دبانے پر کچھ نہیں ہوتا';

  @override
  String get troubleA4 =>
      'ایسا اس وقت ہو سکتا ہے جب تمہاری تنظیم کے اکاؤنٹ کو بلنگ توجہ کی ضرورت ہو - اگر ایسا ہے تو تمہیں واضح پیغام نظر آئے گا۔ ورنہ، چیک کرو کہ ہر ضروری فیلڈ (کسی بھی تصویر سمیت) بھری گئی ہے۔';

  @override
  String get troubleQ5 => 'ایپ اٹکی ہوئی / منجمد لگ رہی ہے';

  @override
  String get troubleA5 =>
      'اسے بند کر کے دوبارہ کھولنے کی کوشش کرو۔ تمہاری آخری مکمل کام تک کی پیش رفت ہمیشہ محفوظ ہوتی رہتی ہے، اس لیے پہلے سے جمع کرایا گیا کچھ بھی ضائع نہیں ہوتا۔';

  @override
  String get troubleQ6 => 'مجھے کل جیسے کام نظر نہیں آ رہے';

  @override
  String get troubleA6 =>
      'یہ متوقع ہے اگر تمہارے شیڈول میں فوری کام، یا وقت کی کھڑکی سے جڑے کام شامل ہیں - وہ صرف اس وقت ظاہر ہوتے ہیں جب واجب الادا ہوں۔ اگر کچھ واقعی غلط لگے تو اپنے مینیجر سے پوچھو۔';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - $date سے تاخیر کا شکار';
  }

  @override
  String get uploadCertificateDocumentButton => 'سرٹیفکیٹ کی تصویر اپ لوڈ کریں';

  @override
  String get certificateDocumentUploadedLabel => 'سرٹیفکیٹ اپ لوڈ ہو گیا';

  @override
  String get viewCertificateDocumentTooltip => 'سرٹیفکیٹ دستاویز دیکھیں';

  @override
  String get certificateUploadFailed =>
      'سرٹیفکیٹ اپ لوڈ نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get certificationRequirementsTitle => 'سرٹیفیکیشن کی ضروریات';

  @override
  String get certificationRequirementsFloorNotice =>
      'کچھ سرٹیفیکیٹس مخصوص کرداروں کے لیے ہمیشہ ضروری ہوتے ہیں اور یہاں سے ہٹائے نہیں جا سکتے (مثلاً، کھانا سنبھالنے والے کرداروں کے لیے ہمیشہ لیول 2 فوڈ ہائیجین اور ایلرجن اویئرنیس درکار ہوتی ہے)۔ آپ نیچے اضافی ضروریات شامل کر سکتے ہیں۔';

  @override
  String get noExtraCertificationRequirementsText =>
      'ابھی تک کوئی اضافی ضرورت شامل نہیں کی گئی۔';

  @override
  String get addRequirementButton => 'ضرورت شامل کریں';

  @override
  String get addCertificationRequirementTitle =>
      'سرٹیفیکیشن کی ضرورت شامل کریں';

  @override
  String get removeCertificationRequirementTitle => 'اس ضرورت کو ہٹائیں؟';

  @override
  String get removeCertificationRequirementBody =>
      'اس کردار کے عملے کو شیڈول ہونے کے لیے اب اس سرٹیفیکیٹ کی ضرورت نہیں ہوگی۔ اس سے ہمیشہ درکار سرٹیفیکیٹس پر کوئی اثر نہیں پڑتا۔';

  @override
  String get removeButton => 'ہٹائیں';

  @override
  String get cannotClaimShiftTitle => 'آپ ابھی یہ شفٹ نہیں لے سکتے';

  @override
  String missingCertificationsMessage(String certs) {
    return 'اس کردار کے لیے درج ذیل درکار ہیں، جو غائب یا میعاد ختم ہیں: $certs۔ ان کی تجدید کے بارے میں اپنے مینیجر سے پوچھیں۔';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'یہ شفٹ $name کو تفویض نہیں کی جا سکتی';
  }

  @override
  String get allergenCelery => 'اجوائن';

  @override
  String get allergenGluten => 'گلوٹین والے اناج';

  @override
  String get allergenCrustaceans => 'کرسٹیشین';

  @override
  String get allergenEggs => 'انڈے';

  @override
  String get allergenFish => 'مچھلی';

  @override
  String get allergenLupin => 'لیوپن';

  @override
  String get allergenMilk => 'دودھ';

  @override
  String get allergenMolluscs => 'مولسک';

  @override
  String get allergenMustard => 'سرسوں';

  @override
  String get allergenTreeNuts => 'خشک میوہ جات';

  @override
  String get allergenPeanuts => 'مونگ پھلی';

  @override
  String get allergenSesame => 'تل کے بیج';

  @override
  String get allergenSoya => 'سویا';

  @override
  String get allergenSulphites => 'سلفر ڈائی آکسائیڈ اور سلفائٹس';

  @override
  String get allergenStatusContains => 'اس میں شامل ہے';

  @override
  String get allergenStatusMayContain => 'ممکنہ طور پر شامل ہو';

  @override
  String get menuManagementTitle => 'مینو اور الرجنز';

  @override
  String get addDishButton => 'ڈش شامل کریں';

  @override
  String get addDishTitle => 'ایک ڈش شامل کریں';

  @override
  String get dishNameLabel => 'ڈش کا نام';

  @override
  String get dishCategoryLabel => 'قسم (اختیاری)';

  @override
  String get noDishesYetText => 'ابھی تک کوئی ڈش شامل نہیں کی گئی۔';

  @override
  String get draftLabel => 'ڈرافٹ';

  @override
  String get addIngredientTitle => 'اجزاء شامل کریں';

  @override
  String get ingredientNameLabel => 'جزو کا نام';

  @override
  String get addButton => 'شامل کریں';

  @override
  String get addIngredientButton => 'جزو شامل کریں';

  @override
  String get ingredientsHeading => 'اجزاء';

  @override
  String get suggestedAllergensHeading =>
      'تجویز کردہ الرجنز (ابھی شائع نہیں ہوئے)';

  @override
  String get publishedAllergensHeading => 'شائع شدہ الرجنز';

  @override
  String get noAllergensIdentifiedText =>
      'موجودہ اجزاء سے کوئی الرجن شناخت نہیں ہوا۔';

  @override
  String get reviewAllergensTitle => 'شائع کرنے سے پہلے الرجنز کا جائزہ لیں';

  @override
  String get allergenStatusNone => 'کوئی نہیں';

  @override
  String get approveButton => 'منظور کریں اور شائع کریں';

  @override
  String get reviewAndApproveButton => 'جائزہ لیں اور منظور کریں';

  @override
  String get reviewAndReapproveButton => 'جائزہ لیں اور دوبارہ منظور کریں';

  @override
  String get allergenMatrixTitle => 'الرجن میٹرکس';

  @override
  String get allergenMatrixLegend => 'اشارہ';

  @override
  String get noApprovedDishesYetText =>
      'ابھی تک کوئی ڈش منظور نہیں ہوئی۔ مینیجر سے مینو اور الرجنز میں ڈشز کا جائزہ لینے اور منظور کرنے کے لیے کہیں۔';

  @override
  String get exportAsPdfButton => 'PDF کے طور پر برآمد کریں';

  @override
  String get allergenMatrixSubtitle =>
      'گاہک تک پہنچنے سے پہلے ڈش میں کیا ہے، چیک کریں';

  @override
  String get assignmentRejectedMessage =>
      'یہ تفویض مسترد کر دی گئی۔ براہ کرم عملے کے کردار اور سرٹیفیکیٹس چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get sopTemplateCleaningSchedule => 'صفائی شیڈول';

  @override
  String get sopTemplateAllergenControl => 'الرجن کنٹرول';

  @override
  String get sopTemplateDeliveryAndStorage => 'ترسیل اور ذخیرہ';

  @override
  String get sopTemplatePersonalHygiene => 'ذاتی صفائی';

  @override
  String get sopTemplatePestControl => 'کیڑوں پر قابو';

  @override
  String get generateSopTitle => 'ایس او پی دستاویز بنائیں';

  @override
  String get sopGenerationDisclaimer =>
      'یہ عمومی برطانوی فوڈ سیفٹی طریقوں کا استعمال کرتے ہوئے AI کا تیار کردہ طریقہ کار دستاویز کا پہلا مسودہ بناتا ہے۔ یہ صرف ایک نقطہ آغاز ہے - اسے لائیو دستاویز کے طور پر محفوظ کرنے سے پہلے احتیاط سے پڑھیں اور اپنے مقام سے متعلق کسی بھی چیز میں ترمیم کریں۔';

  @override
  String get sopTemplateFieldLabel => 'دستاویز کی قسم';

  @override
  String get sopExtraContextLabel => 'اضافی تفصیلات (اختیاری)';

  @override
  String get sopExtraContextHint =>
      'مثلاً مخصوص آلات، عملے کے کردار، یا شامل کرنے کے قواعد';

  @override
  String get generatingText => 'تیار کیا جا رہا ہے...';

  @override
  String get generateDraftButton => 'مسودہ بنائیں';

  @override
  String get documentTitleLabel => 'دستاویز کا عنوان';

  @override
  String get reviewAndEditDraftLabel => 'مسودے کا جائزہ لیں اور ترمیم کریں';

  @override
  String get saveAsDocumentButton => 'دستاویز مرکز میں محفوظ کریں';

  @override
  String get generateWithAiButton => 'AI سے بنائیں';

  @override
  String get shiftPeriodsTitle => 'شفٹ کے اوقات';

  @override
  String get shiftPeriodsDescription =>
      'دن کو 2 یا 3 اوقات میں تقسیم کریں (مثلاً صبح/دوپہر/رات)۔ روٹا کیلنڈر اور آٹو اسائن انہیں وقت کے مطابق فلٹر اور منصوبہ بندی کے لیے استعمال کرتے ہیں۔';

  @override
  String shiftPeriodCountOption(int count) {
    return '$count اوقات';
  }

  @override
  String get shiftPeriodNameLabel => 'وقت کا نام';

  @override
  String get shiftPeriodStartsLabel => 'شروع';

  @override
  String get shiftPeriodEndsLabel => 'ختم';

  @override
  String get shiftPeriodsSavedMessage => 'شفٹ کے اوقات محفوظ ہو گئے';

  @override
  String shiftPeriodsSaveFailedMessage(String error) {
    return 'محفوظ کرنے میں ناکام: $error';
  }

  @override
  String get shiftPeriodDefaultDay => 'دن';

  @override
  String get shiftPeriodDefaultNight => 'رات';

  @override
  String get shiftPeriodDefaultMorning => 'صبح';

  @override
  String get shiftPeriodDefaultAfternoon => 'دوپہر';

  @override
  String get rotaWeekTitle => 'روٹا کیلنڈر';

  @override
  String get rosterAddonNotEnabledText =>
      'اس سائٹ کے لیے شفٹ اور روٹا مینجمنٹ ابھی فعال نہیں ہے۔';

  @override
  String get rotaTodayButton => 'آج';

  @override
  String get rotaFilterPeriodLabel => 'مدت';

  @override
  String get rotaFilterAllLabel => 'تمام';

  @override
  String get rotaFilterDepartmentLabel => 'شعبہ';

  @override
  String get rotaFilterPersonLabel => 'شخص';

  @override
  String get rotaUnassignedRowLabel => 'غیر تفویض شدہ';

  @override
  String get setUpShiftPeriodsFirstText =>
      'پہلے شفٹ کے اوقات ترتیب دیں (شفٹ اوقات اسکرین)۔';

  @override
  String get addStaffingRequirementTitle => 'اسٹافنگ کی ضرورت شامل کریں';

  @override
  String get anyDepartmentLabel => 'کوئی بھی شعبہ';

  @override
  String get unknownDepartmentLabel => 'نامعلوم شعبہ';

  @override
  String get anyRoleLabel => 'کوئی بھی کردار';

  @override
  String get staffNeededLabel => 'درکار عملہ';

  @override
  String get standbyNeededLabel => 'درکار اسٹینڈ بائی';

  @override
  String shiftsGeneratedMessage(int count) {
    return 'اس ہفتے کے لیے $count شفٹیں بنائی گئیں۔';
  }

  @override
  String shiftGenerationFailedMessage(String error) {
    return 'ناکام: $error';
  }

  @override
  String plusStandbyCountLabel(int count) {
    return ' + $count اسٹینڈ بائی';
  }

  @override
  String get masterRotaSettingsTitle => 'ماسٹر روٹا کی ترتیبات';

  @override
  String get masterRotaSettingsDescription =>
      'بتائیں کہ ہر دن/مدت/شعبہ یا کردار کے لیے کتنا عملہ (اور اسٹینڈ بائی) درکار ہے، پھر ایک ہفتے کے لیے حقیقی شفٹیں ایک ساتھ بنائیں۔';

  @override
  String get noRequirementsYetText => 'ابھی تک کوئی ضرورت ترتیب نہیں دی گئی۔';

  @override
  String get generateThisWeekButton => 'اس ہفتے کے لیے بنائیں';

  @override
  String get generateNextWeekButton => 'اگلے ہفتے کے لیے بنائیں';

  @override
  String get rotaFilterRoleLabel => 'کردار';

  @override
  String get rotaStaffViewLabel => 'عملے کا منظر';

  @override
  String get rotaSlotsViewLabel => 'سلاٹس کا منظر';

  @override
  String get rotaSlotDetailTitle => 'اس شفٹ میں کون ہے';

  @override
  String get rotaAssignedLabel => 'تفویض شدہ';

  @override
  String get rotaStandbyLabel => 'اسٹینڈ بائی';

  @override
  String get rotaNoneAssignedText => 'ابھی تک کوئی نہیں';

  @override
  String rotaUnfilledCountText(int count) {
    return 'ابھی بھی $count درکار ہیں';
  }
}
