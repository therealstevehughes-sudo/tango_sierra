// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get personalSection => 'شخصي';

  @override
  String get languageSettingTitle => 'اللغة';

  @override
  String get languageSettingSubtitle =>
      'اختر اللغة التي تريد استخدام VenuRite بها.';

  @override
  String get languageUpdated => 'تم تحديث اللغة.';

  @override
  String get chooseLanguageTitle => 'اختر اللغة';

  @override
  String get languageDeviceScope =>
      'تُستخدم على هذا الجهاز قبل تسجيل دخول الموظفين.';

  @override
  String languageUserScope(String name) {
    return 'تم الحفظ لـ $name.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get done => 'تم';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get back => 'رجوع';

  @override
  String get enterPin => 'أدخل رقم PIN';

  @override
  String get leadershipAccess => 'وصول الإدارة';

  @override
  String get notOnThisList => 'لست في هذه القائمة؟ سجّل الدخول بطريقة أخرى';

  @override
  String errorLoadingStaff(String error) {
    return 'حدث خطأ أثناء تحميل الموظفين: $error';
  }

  @override
  String get incorrectPin => 'رقم PIN غير صحيح';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'محاولات خاطئة كثيرة. حاول مرة أخرى بعد $minutes دقيقة.';
  }

  @override
  String get accountNotFound => 'لم يتم العثور على الحساب';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get kitchenComplianceDoneRight => 'امتثال المطبخ، بوضوح وموثوقية';

  @override
  String get valuePointEhoReady =>
      'جاهز دائمًا للتفتيش الصحي - سجلات فورية بدل الاستعداد في آخر لحظة';

  @override
  String get valuePointHonestRecords =>
      'مصمم بحيث لا يمكن التلاعب بالنتائج - كل فحص له سجل موثوق';

  @override
  String get valuePointAuditExport =>
      'تصدير التدقيق بلمسة واحدة - قدّم للمفتش سجلًا حقيقيًا فورًا';

  @override
  String get howGetStarted => 'كيف تريد أن تبدأ؟';

  @override
  String get setUpMyBusiness => 'إعداد موقعي';

  @override
  String get teamAlreadyUses => 'فريقي يستخدم VenuRite بالفعل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get needHelpContact => 'تحتاج إلى مساعدة؟ تواصل مع VenuRite';

  @override
  String get signInAnotherWay => 'تسجيل الدخول بطريقة أخرى';

  @override
  String get deviceNotSetUp => 'لم يتم إعداد هذا الجهاز اللوحي بعد';

  @override
  String get askManagerSetupCode => 'اطلب من المدير رمز إعداد هذا الموقع.';

  @override
  String get setupCode => 'رمز الإعداد';

  @override
  String get connectTablet => 'توصيل هذا الجهاز اللوحي';

  @override
  String get couldNotReachServer => 'تعذر الاتصال بالخادم';

  @override
  String get stillStuckSetupCode =>
      'ما زلت غير قادر على المتابعة؟ يمكن للمدير العثور عليه في الإعدادات -> تفاصيل الموقع.';

  @override
  String get askQuestionTitle => 'اطرح سؤالًا';

  @override
  String get askQuestionLabel => 'ماذا تريد أن تعرف؟';

  @override
  String get askQuestionHint => 'مثال: ما درجة الحرارة المناسبة للثلاجة؟';

  @override
  String get ask => 'اسأل';

  @override
  String get aiQuestionLimitReached =>
      'تم الوصول إلى الحد الشهري لأسئلة الذكاء الاصطناعي';

  @override
  String get home => 'الرئيسية';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get endShift => 'إنهاء الوردية';

  @override
  String get workerHubPrompt => 'ماذا تريد أن تفعل؟';

  @override
  String get myScheduledTasks => 'مهامي المجدولة';

  @override
  String get doAdHocTask => 'تنفيذ مهمة فورية';

  @override
  String get logSomethingHappened => 'تسجيل شيء حدث للتو';

  @override
  String get claimShift => 'استلام وردية';

  @override
  String get requestDayOff => 'طلب يوم إجازة';

  @override
  String get thingsIReported => 'الأشياء التي أبلغت عنها';

  @override
  String shiftWelcome(String firstName) {
    return 'مرحبًا، $firstName';
  }

  @override
  String get shiftPlanIntro => 'هذا ما لديك في ورديتك:';

  @override
  String get startOfShift => 'بداية الوردية';

  @override
  String get duringYourShift => 'أثناء ورديتك';

  @override
  String get endOfShift => 'نهاية الوردية';

  @override
  String get shiftHandoverTitle => 'تسليم المناوبة';

  @override
  String get shiftHandoverNeedsAttention =>
      'لا يزال هذا يحتاج إلى انتباه المناوبة التالية';

  @override
  String get gotIt => 'فهمت';

  @override
  String get openIssues => 'مشاكل مفتوحة';

  @override
  String get flaggedEquipment => 'معدات تم الإبلاغ عنها';

  @override
  String get notYetDoneToday => 'لم يتم تنفيذها اليوم بعد';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get uploadFromFiles => 'رفع من الملفات';

  @override
  String get seeAllTasksTooltip => 'عرض جميع المهام';

  @override
  String get leaveBeforeFinishingTitle => 'الخروج قبل الانتهاء؟';

  @override
  String get leaveBeforeFinishingBody =>
      'بعض الفحوصات غير مكتملة. سيتم تسجيل ذلك. يمكنك العودة والانتهاء في أي وقت خلال هذه المناوبة.';

  @override
  String get enterValue => 'أدخل القيمة';

  @override
  String enterValueWithUnit(String unit) {
    return 'أدخل القيمة ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'النطاق الآمن: $min - $max';
  }

  @override
  String get errorNumericRequired => 'مطلوب قيمة رقمية صحيحة';

  @override
  String get errorSelectOption => 'يرجى اختيار خيار';

  @override
  String get errorNotesRequired => 'الملاحظات مطلوبة';

  @override
  String get errorPhotoRequired => 'الصورة مطلوبة';

  @override
  String get errorCorrectiveActionRequired =>
      'اختر كيفية التعامل مع الإجراء التصحيحي';

  @override
  String get myTasksTitle => 'مهامي';

  @override
  String get taskTitleFallback => 'المهمة';

  @override
  String get noTasksAssigned => 'لا توجد مهام مسندة بعد.';

  @override
  String get overdueLabel => 'متأخرة';

  @override
  String overdueSinceLabel(String date) {
    return 'متأخرة منذ $date';
  }

  @override
  String get withinRangePass => 'ضمن النطاق - ناجح';

  @override
  String get outsideRangeFail => 'خارج النطاق - راسب';

  @override
  String get selectOptionLabel => 'اختر خيارًا';

  @override
  String get notesLabel => 'الملاحظات';

  @override
  String get spotCheckPhotoNotice =>
      'فحص عشوائي لهذا اليوم - يلزم التقاط صورة هذه المرة للتأكيد من أن ذلك تم فعلاً.';

  @override
  String get photoAdded => 'تمت إضافة الصورة';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get passLabel => 'ناجح';

  @override
  String get failLabel => 'راسب';

  @override
  String get readingOutsideSafeRange => 'القراءة خارج النطاق الآمن';

  @override
  String get hereIsWhatToDo => 'إليك ما يجب فعله:';

  @override
  String get correctiveActionRequired => 'الإجراء التصحيحي مطلوب';

  @override
  String get iFixedIt => 'قمت بإصلاحه';

  @override
  String get reportedToManager => 'تم الإبلاغ للمدير';

  @override
  String get correctiveActionNoteLabel => 'ماذا فعلت؟ (اختياري)';

  @override
  String get managerWillBeNotified => 'سيتم إخطار المدير الخاص بك.';

  @override
  String get submitButton => 'إرسال';

  @override
  String availableFrom(String time) {
    return 'متاح من $time';
  }

  @override
  String get backToList => 'العودة إلى القائمة';

  @override
  String get skipComesBackLater => 'تخطي - سيعود لاحقًا';

  @override
  String get noAdHocTaskTypesSetUp =>
      'لم يتم إعداد أي أنواع مهام عشوائية في هذا الموقع بعد - اطلب من المدير تعيين نموذج فحص توصيل أو فحص درجة حرارة أولاً.';

  @override
  String get whatKindOfThing => 'ما نوع الشيء الذي تقوم به؟';

  @override
  String get notesOptionalLabel => 'ملاحظات (اختياري)';

  @override
  String get noteOptionalLabel => 'ملاحظة (اختياري)';

  @override
  String get temperatureCelsiusLabel => 'درجة الحرارة (°م)';

  @override
  String get submitLabel => 'إرسال';

  @override
  String get logReadingButton => 'تسجيل القراءة';

  @override
  String get loggedThanksMessage => 'تم التسجيل. شكرًا لتسجيل ذلك.';

  @override
  String get logAnotherAdHocTask => 'تسجيل مهمة عشوائية أخرى';

  @override
  String get deliveryCheckLabel => 'فحص التوصيل';

  @override
  String get temperatureCheckLabel => 'فحص درجة الحرارة';

  @override
  String get sessionSummaryTitle => 'ملخص المناوبة';

  @override
  String tasksCompletedCount(int count) {
    return 'المهام المكتملة: $count';
  }

  @override
  String get passedLabel => 'ناجح';

  @override
  String get failedLabel => 'راسب';

  @override
  String get triggersFailedTasks => 'المحفزات / المهام الراسبة';

  @override
  String get yourReliability => 'موثوقيتك';

  @override
  String get reliabilityExplanation =>
      'آخر 30 يومًا - الفحوصات المكتملة والمسجلة في الوقت المحدد. يُحتسب الفشل المسجل بنفس طريقة النجاح المسجل: هذا يقيس فقط ما إذا كنت قد قمت بالفحص ومتى.';

  @override
  String completedPercentChip(int percent) {
    return '$percent٪ مكتمل';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent٪ في الوقت المحدد';
  }

  @override
  String get sendSummaryToManager => 'أرسل هذا الملخص إلى مدير (اختياري)';

  @override
  String get noManagersSetUp => 'لم يتم إعداد أي مديرين بعد.';

  @override
  String get managerLabel => 'المدير';

  @override
  String get sentLabel => 'تم الإرسال';

  @override
  String get sendLabel => 'إرسال';

  @override
  String get leaveNoteForNextShift => 'اترك ملاحظة للمناوبة التالية (اختياري)';

  @override
  String get handoverNoteLabel => 'ملاحظة التسليم';

  @override
  String get doneLabel => 'تم';

  @override
  String get supplierOptionalLabel => 'المورد (اختياري)';

  @override
  String supplierWarningRecorded(String status) {
    return 'هذا المورد مُصنّف كـ $status - سيتم تسجيل الفحص رغم ذلك.';
  }

  @override
  String get reportProblemWithDelivery => 'الإبلاغ عن مشكلة في هذا التوصيل';

  @override
  String get temperatureOnArrivalLabel =>
      'درجة الحرارة عند الوصول (°م، اختياري)';

  @override
  String get problemsTickAnyApply => 'المشاكل (حدد كل ما ينطبق)';

  @override
  String get shortDeliveryLabel => 'توصيل ناقص';

  @override
  String get damagedStockLabel => 'بضاعة تالفة';

  @override
  String get lateDeliveryLabel => 'توصيل متأخر';

  @override
  String get qualityProblemLabel => 'مشكلة في الجودة';

  @override
  String get outcomeLabel => 'النتيجة';

  @override
  String get acceptedLabel => 'مقبول';

  @override
  String get rejectedLabel => 'مرفوض';

  @override
  String get partiallyAcceptedLabel => 'مقبول جزئيًا';

  @override
  String get noCameraFound => 'لم يتم العثور على كاميرا في هذا الجهاز.';

  @override
  String couldNotStartCamera(String error) {
    return 'تعذر تشغيل الكاميرا: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'تعذر تبديل الكاميرا: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'تعذر التقاط الصورة: $error';
  }

  @override
  String get switchCameraTooltip => 'تبديل الكاميرا';

  @override
  String get allTasksTitle => 'جميع المهام';

  @override
  String get otherSegmentLabel => 'أخرى';

  @override
  String get reorderTasksTitle => 'إعادة ترتيب المهام';

  @override
  String get ungroupedLabel => 'غير مجمّع';

  @override
  String get taskOrderSaved => 'تم حفظ ترتيب المهام.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'تعذر حفظ ترتيب المهام: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'لم يتم اختيار موقع بعد. حدد موقعًا نشطًا من تفاصيل الموقع قبل إعادة ترتيب المهام.';

  @override
  String get noActiveTasksToReorder =>
      'لا توجد مهام نشطة لإعادة ترتيبها بعد. قم بتعيين المهام أولاً، ثم عد إلى هنا لاختيار ترتيبها.';

  @override
  String get savingEllipsis => 'جارٍ الحفظ…';

  @override
  String get saveOrderLabel => 'حفظ الترتيب';

  @override
  String get moveUpTooltip => 'تحريك لأعلى';

  @override
  String get moveDownTooltip => 'تحريك لأسفل';

  @override
  String get accountRestrictedTitle => 'الحساب مقيّد';

  @override
  String get accountRestrictedBody =>
      'يحتاج الخصم المباشر لهذه المؤسسة إلى الانتباه قبل أن يمكن حفظ فحوصات جديدة. عملك لم يُفقد - يرجى إخبار مدير أو مدير تنفيذي لحل مشكلة الفوترة، ثم المحاولة مرة أخرى.';

  @override
  String get okLabel => 'موافق';

  @override
  String get troubleshootingTitle => 'استكشاف الأخطاء وإصلاحها';

  @override
  String get faqTitle => 'الأسئلة الشائعة';

  @override
  String get helpTitle => 'المساعدة';

  @override
  String get couldntReachAssistant => 'تعذر الوصول إلى المساعد';

  @override
  String get aiOfflineBody =>
      'المساعد الذكي غير متاح حاليًا - قد يكون السبب اتصالك أو أن الخدمة معطلة مؤقتًا. في هذه الأثناء، تغطي الأسئلة الشائعة واستكشاف الأخطاء أدناه معظم الأسئلة الشائعة، أو تواصل مع VenuRite مباشرة.';

  @override
  String get askQuestionSubtitle => 'احصل على إجابة واضحة بلغة بسيطة';

  @override
  String get faqSubtitle => 'أسئلة شائعة مع إجاباتها';

  @override
  String get troubleshootingSubtitle => 'هل هناك خلل؟ ابدأ من هنا';

  @override
  String get contactVenuriteTitle => 'تواصل مع VenuRite';

  @override
  String get contactVenuriteSubtitle => 'تواصل مباشرة';

  @override
  String get topTierViewTitle => 'عرض المستوى الأعلى';

  @override
  String get everythingsDone => 'تم كل شيء. عمل رائع.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مهام غير مكتملة:',
      one: 'مهمة واحدة غير مكتملة:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'العودة إلى المناوبة';

  @override
  String get finishShiftLabel => 'إنهاء المناوبة';
}
