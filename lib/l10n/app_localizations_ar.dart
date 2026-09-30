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
  String get shortDeliveryLabel => 'تسليم ناقص';

  @override
  String get damagedStockLabel => 'بضاعة تالفة';

  @override
  String get lateDeliveryLabel => 'تسليم متأخر';

  @override
  String get qualityProblemLabel => 'مشكلة جودة';

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

  @override
  String get ehoAuditExportTitle => 'تصدير EHO / التدقيق';

  @override
  String get ehoExportDescription =>
      'يُنشئ ملف PDF لسجلات الامتثال لهذا الموقع للفترة الزمنية المحددة.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'اختر النطاق الزمني';

  @override
  String get tapToChooseDates => 'اضغط لاختيار تاريخ البداية والنهاية.';

  @override
  String get includeFullDetailedLog => 'تضمين السجل التفصيلي الكامل';

  @override
  String get fullLogSubtitle =>
      'معطل افتراضيًا - الملخص والاستثناءات أعلاه هي ما يراجعه المفتش فعليًا؛ يضيف هذا كل فحص فردي.';

  @override
  String get generateLabel => 'إنشاء';

  @override
  String get exportFailedTitle => 'فشل التصدير';

  @override
  String exportFailedBody(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String get exportCreatedTitle => 'تم إنشاء التصدير';

  @override
  String savedToLabel(String path) {
    return 'تم الحفظ في:\n$path';
  }

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get noVenueFound => 'لم يتم العثور على موقع.';

  @override
  String get allPermittedVenuesLast30Days =>
      'جميع المواقع المسموح بها · آخر 30 يومًا';

  @override
  String get last30Days => 'آخر 30 يومًا';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count راسب (30 يومًا)',
      one: 'راسب واحد (30 يومًا)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count متأخر';
  }

  @override
  String get venuesSectionTitle => 'المواقع';

  @override
  String get teamSectionTitle => 'الفريق';

  @override
  String get noStaffAtVenue => 'لا يوجد موظفون في هذا الموقع بعد.';

  @override
  String get notEnoughDataYet => 'بيانات غير كافية';

  @override
  String get venueFallbackLabel => 'الموقع';

  @override
  String get trendsTitle => 'الاتجاهات';

  @override
  String get trendNeedsHistory =>
      'بيانات الاتجاه: يلزم توفر 4 أسابيع على الأقل من السجل لإظهار اتجاه.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'الإنجاز الأسبوعي لكل موقع · آخر $weeks أسابيع';
  }

  @override
  String get allVenuesCombined => 'جميع المواقع مجتمعة';

  @override
  String get noVenuesYet => 'لا توجد مواقع بعد.';

  @override
  String get otherVenuesLabel => 'مواقع أخرى';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return 'تم تسجيل $completed من $total فحوصات';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'المنطقة رقم $id';
  }

  @override
  String get dashboardOverviewTitle => 'نظرة عامة على لوحة التحكم';

  @override
  String get gradedBarsOnTooltip => 'أشرطة تقييم لكل موظف: مفعّلة';

  @override
  String get gradedBarsOffTooltip => 'أشرطة تقييم لكل موظف: معطّلة';

  @override
  String get noBranchesToShow => 'لا توجد فروع لعرضها بعد.';

  @override
  String get supervisorNoScopeMessage =>
      'لم يتم تعيينك بعد إلى قسم أو فريق - اطلب من المدير إعداد ذلك في إدارة الموظفين قبل أن يكون لهذه اللوحة أي شيء تعرضه.';

  @override
  String get individualViewNotice =>
      'عرض فردي - للإشراف على المخاطر، وليس جدول ترتيب.';

  @override
  String get branchLabel => 'الفرع';

  @override
  String get allBranchesLabel => 'جميع الفروع';

  @override
  String get yourSectionLabel => 'قسمك';

  @override
  String get noneAssignedLabel => 'لم يُعيّن أي شيء';

  @override
  String get areaLabel => 'المنطقة';

  @override
  String get allAreasLabel => 'جميع المناطق';

  @override
  String get employeeLabel => 'الموظف';

  @override
  String get allEmployeesLabel => 'جميع الموظفين';

  @override
  String get monthLabel => 'شهر';

  @override
  String get weekLabel => 'أسبوع';

  @override
  String get dayLabel => 'يوم';

  @override
  String get noTaskActivityPeriod => 'لا يوجد نشاط مهام في هذه الفترة.';

  @override
  String get taskOverviewTitle => 'نظرة عامة على المهام';

  @override
  String get incidentsTitle => 'الحوادث';

  @override
  String get noIncidentsPeriod => 'لم يتم الإبلاغ عن أي حوادث في هذه الفترة.';

  @override
  String urgentCountLabel(int count) {
    return '$count عاجل';
  }

  @override
  String get tapForDetailsHint =>
      'اضغط على قسم لوني أو عنصر في المفتاح لمعرفة التفاصيل';

  @override
  String get employeeFallbackLabel => 'الموظف';

  @override
  String get plainLookupNotice =>
      'مجرد بحث بسيط، وليس درجة - لون الإنجاز وعلامات المشاكل لا يتم تقييمها هنا حسب الشخص أبدًا.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'المهام المكتملة ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'المشاكل المبلغ عنها ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'تم في الوقت المحدد (بدون مشاكل)';

  @override
  String get doneOnTimeIssuesLogged => 'تم في الوقت المحدد (تم تسجيل مشاكل)';

  @override
  String get doneEarlyLateNoIssues => 'تم مبكرًا/متأخرًا (بدون مشاكل)';

  @override
  String get doneEarlyLateIssuesLogged => 'تم مبكرًا/متأخرًا (تم تسجيل مشاكل)';

  @override
  String get notDoneLabel => 'لم يتم';

  @override
  String get resolvedLabel => 'تم الحل';

  @override
  String get unresolvedLabel => 'لم يُحل';

  @override
  String get escalatedLabel => 'تم التصعيد';

  @override
  String get urgentLabel => 'عاجل';

  @override
  String get signInFailed => 'فشل تسجيل الدخول';

  @override
  String get twoFactorRequiredNoFactor =>
      'التحقق بخطوتين مطلوب ولكن لم يتم العثور على أي عامل مصادقة.';

  @override
  String get couldNotVerifyCode => 'تعذر التحقق من هذا الرمز';

  @override
  String get codeDidntWork => 'هذا الرمز لم ينجح.';

  @override
  String get accountNotLinkedToStaff =>
      'هذا الحساب غير مرتبط بملف موظف بعد - تواصل مع المسؤول.';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get enterEmailForResetCode =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمزًا لإعادة تعيين كلمة المرور.';

  @override
  String get emailLabel => 'بريد إلكتروني';

  @override
  String get sendCodeButton => 'إرسال الرمز';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String sentCodeToEmail(String email) {
    return 'أرسلنا رمزًا إلى $email. أدخله أدناه مع كلمة المرور الجديدة.';
  }

  @override
  String get sixDigitCodeLabel => 'رمز مكون من 6 أرقام';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get twoFactorVerificationTitle => 'التحقق بخطوتين';

  @override
  String get enterAuthenticatorCode => 'أدخل الرمز من تطبيق المصادقة.';

  @override
  String get verifyButton => 'تحقق';

  @override
  String get regionalDirectorSignIn => 'تسجيل دخول المدير الإقليمي/التنفيذي.';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String get forgotPasswordLink => 'هل نسيت كلمة المرور؟';

  @override
  String get noBackendConfiguredPin =>
      'لا يوجد خادم خلفي مُهيأ لهذا التثبيت - سجّل الدخول باستخدام رمز PIN مثل أي شخص آخر.';

  @override
  String get noDirectorRegionalAccounts =>
      'لا توجد حسابات مدير/إقليمي على هذا الجهاز.';

  @override
  String get directorLabel => 'مدير تنفيذي';

  @override
  String get regionalManagerLabel => 'مدير إقليمي';

  @override
  String get whoAreYouTitle => 'من أنت؟';

  @override
  String get searchLabel => 'بحث';

  @override
  String get noMatchesLabel => 'لا توجد نتائج';

  @override
  String get leadershipSectionTitle => 'القيادة';

  @override
  String get kitchenStaffSectionTitle => 'طاقم المطبخ';

  @override
  String get chooseASectionTitle => 'اختر قسمًا';

  @override
  String get unassignedLabel => 'غير معيّن';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أشخاص',
      one: 'شخص واحد',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get welcomeToVenurite => 'مرحبًا بك في VenuRite';

  @override
  String get helpAssistantTooltip => 'المساعدة والمساعد';

  @override
  String get couldntLoadScreen => 'تعذر تحميل هذه الشاشة.';

  @override
  String get retryLabel => 'إعادة المحاولة';

  @override
  String get microphonePermissionDenied => 'تم رفض إذن الميكروفون.';

  @override
  String get couldntRecordTryAgain => 'تعذر التسجيل - حاول مرة أخرى.';

  @override
  String get couldntTranscribe => 'تعذر تفريغ ذلك.';

  @override
  String get couldntReachTranscriptionService =>
      'تعذر الوصول إلى خدمة تفريغ الصوت.';

  @override
  String get dictateANote => 'أملِ ملاحظة';

  @override
  String get stoppingSoonTapToStop => 'سيتوقف قريبًا - اضغط للتوقف الآن';

  @override
  String get stopLabel => 'إيقاف';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنبيهات',
      one: 'تنبيه واحد',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count غير مُقرة';
  }

  @override
  String get allAcknowledgedLabel => 'تم إقرار الكل';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'متأخر - غير مُقر منذ $minutes دقيقة';
  }

  @override
  String get escalatedToTopTier => 'تم التصعيد إلى المستوى الأعلى';

  @override
  String get acknowledgeLabel => 'إقرار';

  @override
  String get nothingInCategory => 'لا يوجد شيء في هذه الفئة.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'نظرة عامة على القيادة';

  @override
  String get photoEvidence => 'أدلة مصورة';

  @override
  String get staffManagement => 'إدارة الموظفين';

  @override
  String get addTeamMember => 'إضافة عضو فريق';

  @override
  String get shiftLog => 'سجل المناوبات';

  @override
  String get branchTeamStructure => 'هيكل فريق الفرع';

  @override
  String get departmentManagement => 'إدارة الأقسام';

  @override
  String get rosterBoard => 'لوحة الجدول الزمني';

  @override
  String get claimShifts => 'المطالبة بمناوبات';

  @override
  String get requestADayOff => 'طلب إجازة يوم';

  @override
  String get shiftFairnessReview => 'مراجعة عدالة المناوبات';

  @override
  String get venueDetails => 'تفاصيل الموقع';

  @override
  String get assignTasks => 'تعيين المهام';

  @override
  String get taskPresets => 'قوالب المهام';

  @override
  String get supplierManagement => 'إدارة الموردين';

  @override
  String get serviceProviders => 'مزودو الخدمة';

  @override
  String get notificationRules => 'قواعد الإشعارات';

  @override
  String get documentCentre => 'مركز المستندات';

  @override
  String get setupWizard => 'معالج الإعداد';

  @override
  String get organisationLabel => 'المؤسسة';

  @override
  String get branchesLabel => 'الفروع';

  @override
  String get homeLabel => 'الرئيسية';

  @override
  String get oversightLabel => 'الإشراف';

  @override
  String get problemsAndIssues => 'المشاكل والقضايا';

  @override
  String get twoFactorAuthentication => 'المصادقة الثنائية';

  @override
  String get backUpNow => 'احفظ نسخة احتياطية الآن';

  @override
  String get dailySection => 'يومي';

  @override
  String get insightsSection => 'التحليلات';

  @override
  String get peopleSection => 'الموظفون';

  @override
  String get rosterSection => 'الجدول الزمني';

  @override
  String get venueSetupSection => 'إعداد الموقع';

  @override
  String get companySection => 'الشركة';

  @override
  String get accountSection => 'الحساب';

  @override
  String get settingsLabel => 'الإعدادات';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent٪ مكتمل اليوم';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count موظف نشط';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count راسب اليوم',
      one: 'راسب واحد اليوم',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'عرض المدير';

  @override
  String showingScopeLabel(String scope) {
    return 'عرض: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'لم يتم تعيينك بعد إلى قسم أو فريق - اطلب من المدير إعداد ذلك في إدارة الموظفين قبل أن يكون لهذا السجل أي شيء يعرضه.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إدخالات',
      one: 'إدخال واحد',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count راسب',
      one: 'راسب واحد',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'لا توجد حالات راسبة';

  @override
  String get noCompletedTasksLoggedYet => 'لم يتم تسجيل أي مهام مكتملة بعد';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملخصات مناوبة',
      one: 'ملخص مناوبة واحد',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount ناجح / $failCount راسب';
  }

  @override
  String get workerFixedIt => 'قام الموظف بإصلاحه';

  @override
  String get noCorrectiveActionRecorded => 'لم يتم تسجيل أي إجراء تصحيحي';

  @override
  String get taskAlertFallback => 'تنبيه مهمة';

  @override
  String get loggedByLabel => 'سجّله';

  @override
  String get resultLabel => 'النتيجة';

  @override
  String get correctiveActionLabel => 'الإجراء التصحيحي';

  @override
  String get noteLabel => 'ملاحظة';

  @override
  String get closeLabel => 'إغلاق';

  @override
  String get notCompletedSuffix => '- لم يكتمل (انتهت المناوبة)';

  @override
  String get todayAllFails => 'اليوم + كل الحالات الراسبة';

  @override
  String byAxisLabel(String axis) {
    return 'حسب $axis';
  }

  @override
  String get nameAxisLabel => 'الاسم';

  @override
  String get dateAxisLabel => 'التاريخ';

  @override
  String get taskAxisLabel => 'المهمة';

  @override
  String get filterLabel => 'التصفية';

  @override
  String get filterByLabel => 'التصفية حسب:';

  @override
  String get clearFiltersLabel => 'مسح الفلاتر';

  @override
  String get staffLabel => 'الموظف';

  @override
  String get issueTypeComplaint => 'شكوى';

  @override
  String get issueTypeAccident => 'حادث';

  @override
  String get issueTypeIncident => 'واقعة';

  @override
  String get issueTypeSupplyProblem => 'مشكلة توريد';

  @override
  String get issueTypeVenueProblem => 'مشكلة في الموقع';

  @override
  String get issueTypeOther => 'أخرى';

  @override
  String get incorrectDeliveryLabel => 'توصيل غير صحيح';

  @override
  String get driverProblemLabel => 'مشكلة مع السائق';

  @override
  String get otherLabel => 'أخرى';

  @override
  String get whatKindOfThingHappened => 'ما نوع الأمر الذي حدث؟';

  @override
  String get whichOneLabel => 'أيهما؟';

  @override
  String get supplierLabel => 'المورد';

  @override
  String get whatWasWrongWithDelivery => 'ما الخطأ الذي حدث في التوصيل؟';

  @override
  String get receivedByLabel => 'استلمه';

  @override
  String get whichSectionOptional => 'ما القسم المعني؟ (اختياري)';

  @override
  String get noSectionLabel => 'بدون قسم';

  @override
  String get teamOptionalLabel => 'الفريق (اختياري)';

  @override
  String get noSpecificTeamLabel => 'لا فريق محدد';

  @override
  String get whatHappenedLabel => 'ماذا حدث؟';

  @override
  String get markAsUrgentLabel => 'وضع علامة عاجل';

  @override
  String get markUrgentSubtitle =>
      'يحتاج إلى اهتمام فوري، بغض النظر عن المدة التي يظل فيها دون حل';

  @override
  String get logItButton => 'سجّل ذلك';

  @override
  String get escalateToTitle => 'تصعيد إلى';

  @override
  String get sendToLabel => 'إرسال إلى';

  @override
  String get escalateButton => 'تصعيد';

  @override
  String get savedLabel => 'تم الحفظ.';

  @override
  String remindedMessage(String name) {
    return 'تم تذكير $name.';
  }

  @override
  String get couldNotSendReminder => 'تعذر إرسال التذكير.';

  @override
  String get viewSupplierScorecard => 'عرض بطاقة تقييم المورد';

  @override
  String raisedAtLabel(String date) {
    return 'تم الإبلاغ $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'تم التصعيد إلى: $name';
  }

  @override
  String get historyLabel => 'السجل';

  @override
  String get addAnUpdateLabel => 'إضافة تحديث';

  @override
  String get addProcessNoteButton => 'إضافة ملاحظة إجراء';

  @override
  String get resolveButton => 'حل';

  @override
  String get reopenThisIssueTitle => 'إعادة فتح هذه المشكلة';

  @override
  String get whyReopenLabel => 'لماذا يجب إعادة فتح هذا؟';

  @override
  String get reopenButton => 'إعادة فتح';

  @override
  String sentToLabel(String name) {
    return 'أُرسل إلى $name';
  }

  @override
  String get remindButton => 'تذكير';

  @override
  String get phaseRaisedLabel => 'تم الإبلاغ';

  @override
  String get phaseUpdateLabel => 'تحديث';

  @override
  String get phaseOutcomeLabel => 'النتيجة';

  @override
  String get allLabel => 'الكل';

  @override
  String get dateRangeLabel => 'النطاق الزمني';

  @override
  String get allDatesLabel => 'جميع التواريخ';

  @override
  String get typeLabel => 'النوع';

  @override
  String get anyTypeLabel => 'أي نوع';

  @override
  String get anyoneLabel => 'أي شخص';

  @override
  String staffFallback(String id) {
    return 'الموظف رقم $id';
  }

  @override
  String get nothingHereGoodSign => 'لا يوجد شيء هنا - هذه علامة جيدة.';

  @override
  String escalatedToNameLabel(String name) {
    return 'تم التصعيد إلى $name';
  }

  @override
  String get havenReportedYet => 'لم تُبلغ عن أي شيء بعد.';

  @override
  String get failsAndProblemsRegisterTitle => 'سجل الحالات الراسبة والمشاكل';

  @override
  String get taskProblemsTab => 'مشاكل المهام';

  @override
  String get issuesAndIncidentsTab => 'المشاكل والحوادث';

  @override
  String get failFilterLabel => 'راسب';

  @override
  String get reportedFilterLabel => 'تم الإبلاغ';

  @override
  String get notCompletedFilterLabel => 'غير مكتمل';

  @override
  String get abandonedLabel => 'متروك';

  @override
  String get noActionTakenLabel => 'لم يُتخذ أي إجراء';

  @override
  String get markResolvedButton => 'وضع علامة كمحلول';

  @override
  String get openLabel => 'مفتوح';

  @override
  String get enableRosterQuestion => 'تفعيل الجدول الزمني؟';

  @override
  String rosterQuoteBody(String amount) {
    return 'استنادًا إلى عدد موظفيك الحالي، سيضيف هذا $amount إلى الخصم المباشر الشهري، بدءًا من الدفعة القادمة.';
  }

  @override
  String get confirmAndEnable => 'تأكيد وتفعيل';

  @override
  String couldNotReachVenurite(String error) {
    return 'تعذر الوصول إلى VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts => 'دع الموظفين يطالبون بمناوباتهم الخاصة';

  @override
  String get rosterPitchBody =>
      'انشر المناوبات المفتوحة ودع الموظفين يختارونها بأنفسهم - لا مزيد من الاتصالات الهاتفية أو مجموعات واتساب عندما لا يستطيع أحدهم الحضور. يمكن للموظفين أيضًا طلب أيام إجازة، وأنت توافق أو ترفض من نفس المكان.';

  @override
  String get pricingLabel => 'التسعير';

  @override
  String get priceUnder10Staff =>
      '6 جنيه إسترليني/شهريًا لكل فرع بأقل من 10 موظفين';

  @override
  String get price10PlusStaff =>
      '10 جنيه إسترليني/شهريًا لكل فرع بـ 10 موظفين أو أكثر';

  @override
  String get addedToDirectDebitNote =>
      'يُضاف إلى الخصم المباشر الحالي - لا حاجة لطريقة دفع جديدة. سترى المبلغ الدقيق قبل التأكيد.';

  @override
  String get enableRosterButton => 'تفعيل الجدول الزمني';

  @override
  String get availableShiftsTitle => 'المناوبات المتاحة';

  @override
  String get shiftClaimingNotEnabled =>
      'المطالبة بالمناوبات غير مفعّلة بعد لهذا الموقع. اطلب من مديرك تفعيلها في الإعدادات.';

  @override
  String couldNotLoadShifts(String error) {
    return 'تعذر تحميل المناوبات: $error';
  }

  @override
  String get noShiftsPostedYet => 'لم يتم نشر أي مناوبات بعد.';

  @override
  String get someoneElseClaimedShift =>
      'قام شخص آخر للتو بالمطالبة بتلك المناوبة - عذرًا!';

  @override
  String get shiftClaimedMessage => 'تمت المطالبة بالمناوبة.';

  @override
  String get cancelThisShiftTitle => 'إلغاء هذه المناوبة؟';

  @override
  String get cancelShiftLateWarning =>
      '\n\nتبقى أقل من 24 ساعة على بدء المناوبة - الإلغاء الآن قد يؤثر على سجل موثوقيتك.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'لن تكون مسجلاً لهذه المناوبة بعد الآن.$warning';
  }

  @override
  String get keepShiftButton => 'احتفظ بالمناوبة';

  @override
  String get cancelShiftButton => 'إلغاء المناوبة';

  @override
  String get yourShiftRecordReliable => 'سجل مناوباتك: موثوق';

  @override
  String get yourShiftRecordNeedsImprovement => 'سجل مناوباتك: يحتاج إلى تحسين';

  @override
  String get yourShiftRecordBuilding => 'سجل مناوباتك: قيد البناء';

  @override
  String get claimLabel => 'المطالبة';

  @override
  String get claimedLabel => 'تمت المطالبة';

  @override
  String requestDateOffTitle(String date) {
    return 'طلب إجازة يوم $date';
  }

  @override
  String get reasonOptionalLabel => 'السبب (اختياري)';

  @override
  String get submitRequestButton => 'إرسال الطلب';

  @override
  String get offDayRequestsNotEnabled =>
      'طلبات أيام الإجازة غير مفعّلة بعد لهذا الموقع. اطلب من مديرك تفعيل الجدول الزمني في الإعدادات.';

  @override
  String get noOffDayRequestsYet => 'ليس لديك أي طلبات إجازة بعد.';

  @override
  String get yourRequestsLabel => 'طلباتك';

  @override
  String get approvedLabel => 'تمت الموافقة';

  @override
  String get deniedLabel => 'مرفوض';

  @override
  String get pendingLabel => 'قيد الانتظار';

  @override
  String get postAShiftTitle => 'نشر مناوبة';

  @override
  String get categoryHint => 'مثال: إصلاح التبريد، مكافحة الآفات';

  @override
  String get pickStartTime => 'اختر وقت البدء';

  @override
  String get pickEndTime => 'اختر وقت الانتهاء';

  @override
  String get postLabel => 'نشر';

  @override
  String get assignShiftToTitle => 'تعيين هذه المناوبة إلى';

  @override
  String get unknownLabel => 'غير معروف';

  @override
  String get shiftsTabLabel => 'المناوبات';

  @override
  String get offDayRequestsTabLabel => 'طلبات أيام الإجازة';

  @override
  String get rosterAddonNotEnabledManager =>
      'إضافة الجدول الزمني غير مفعّلة لهذا الموقع. فعّلها في الإعدادات > الشركة لبدء نشر المناوبات.';

  @override
  String get noShiftsTapPlus =>
      'لم يتم نشر أي مناوبات بعد. اضغط على + لإضافة واحدة.';

  @override
  String get openStatusLabel => 'مفتوحة';

  @override
  String get assignedStatusPrefix => 'معيّنة';

  @override
  String get claimedStatusPrefix => 'تمت المطالبة';

  @override
  String get assignDirectlyLabel => 'تعيين مباشر';

  @override
  String get removeClaimLabel => 'إزالة المطالبة';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'تعذر تحميل طلبات أيام الإجازة: $error';
  }

  @override
  String get noOffDayRequests => 'لا توجد طلبات إجازة.';

  @override
  String get approveLabel => 'موافقة';

  @override
  String get denyLabel => 'رفض';

  @override
  String get rosterAddonNotEnabledPlain =>
      'إضافة الجدول الزمني غير مفعّلة لهذا الموقع.';

  @override
  String get noActiveStaffVenue => 'لا يوجد موظفون نشطون في هذا الموقع بعد.';

  @override
  String get last90DaysAlphabetical =>
      'آخر 90 يومًا، حسب فئة المناوبة. أبجديًا - وليس ترتيبًا.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مناوبات',
      one: 'مناوبة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'لا توجد مناوبات في هذه الفترة.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'ينشئ هذا نسخة كاملة من قاعدة البيانات المحلية في مجلد المستندات لديك. نقلها إلى محرك أقراص USB أو مجلد متزامن مع السحابة لاحقًا هو خطوة يدوية منفصلة.';

  @override
  String get backupNameOptional => 'اسم النسخة الاحتياطية (اختياري)';

  @override
  String get backupNameHint => 'مثال: نسخة قبل التفتيش';

  @override
  String get backupCreatedTitle => 'تم إنشاء النسخة الاحتياطية';

  @override
  String get tierTeamMember => 'عضو الفريق';

  @override
  String get tierSupervisor => 'مشرف';

  @override
  String get tierManager => 'مدير';

  @override
  String get tierRegionalManager => 'مدير إقليمي';

  @override
  String get tierDirector => 'مدير تنفيذي';

  @override
  String get anyTaskFail => 'أي فشل في مهمة';

  @override
  String taskFailLabel(String title) {
    return 'فشل: $title';
  }

  @override
  String get taskFailTemplateStale => 'فشل مهمة (النموذج لم يعد حاليًا)';

  @override
  String get unknownUserLabel => 'مستخدم غير معروف';

  @override
  String tierSuffixLabel(String tier) {
    return 'مستوى $tier';
  }

  @override
  String get unsetLabel => 'غير محدد';

  @override
  String get pushChannelLabel => 'إشعار فوري';

  @override
  String get emailChannelLabel => 'بريد إلكتروني';

  @override
  String get inAppOnlyLabel => 'داخل التطبيق فقط';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'داخل التطبيق + $channels';
  }

  @override
  String get tierColumnTeam => 'الفريق';

  @override
  String get tierColumnSupv => 'مشرف';

  @override
  String get tierColumnMgr => 'مدير';

  @override
  String get tierColumnRegnl => 'إقليمي';

  @override
  String get tierColumnDir => 'تنفيذي';

  @override
  String get quickSetupSectionTitle => 'إعداد سريع: إشعارات فشل المهام';

  @override
  String get tickTierNotified =>
      'حدد المستوى الذي يتم إعلامه عند فشل مهمة معينة.';

  @override
  String get noTaskTemplatesSetUp => 'لم يتم إعداد أي قوالب مهام بعد.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'إعلام: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'تم التعيين بواسطة مستوى $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - غير نشط';

  @override
  String get deactivateButton => 'إلغاء التنشيط';

  @override
  String get reactivateButton => 'إعادة التنشيط';

  @override
  String get newRuleTitle => 'قاعدة جديدة';

  @override
  String get triggerLabel => 'المُحفّز';

  @override
  String get notifyLabel => 'إعلام';

  @override
  String get wholeRoleTierOption => 'مستوى دور كامل';

  @override
  String get specificPersonOption => 'شخص محدد';

  @override
  String get roleTierLabel => 'مستوى الدور';

  @override
  String get personLabel => 'الشخص';

  @override
  String get pushLabel => 'إشعار فوري';

  @override
  String get rulesInAppNotice =>
      'يتم عرض القواعد الآن داخل التطبيق فقط؛ لم يتم ربط التسليم عبر الإشعارات الفورية/البريد الإلكتروني بخادم بعد وسيُضاف في نسخة لاحقة.';

  @override
  String get saveRuleButton => 'حفظ القاعدة';

  @override
  String get addRuleButton => 'إضافة قاعدة';

  @override
  String get noNotificationRulesYet => 'لم يتم إعداد أي قواعد إشعارات بعد.';

  @override
  String get stepYourAccount => 'حسابك';

  @override
  String get stepCompanyDetails => 'تفاصيل الشركة';

  @override
  String get stepOrgStructure => 'هيكل المؤسسة';

  @override
  String get stepFirstVenue => 'أول موقع';

  @override
  String get stepStarterSetup => 'مجموعتك الأولية';

  @override
  String get stepSubscription => 'الاشتراك';

  @override
  String get stepPayment => 'الدفع';

  @override
  String get termsOfServiceTitle => 'شروط الخدمة';

  @override
  String get companySignupGenericError =>
      'حدث خطأ ما أثناء إنشاء شركتك. يرجى المحاولة مرة أخرى - إذا استمر حدوث ذلك، تواصل مع VenuRite.';

  @override
  String get directDebitStartError =>
      'لم نتمكن من بدء إعداد الخصم المباشر تلقائيًا - يمكنك القيام بذلك في أي وقت من الإعدادات بعد تسجيل الدخول.';

  @override
  String get continueButton => 'متابعة';

  @override
  String get creatingEllipsis => 'جارٍ الإنشاء...';

  @override
  String get startFreeTrialButton => 'ابدأ الفترة التجريبية المجانية';

  @override
  String get companyCreatedTitle => 'تم إنشاء الشركة';

  @override
  String get adminAccountIntro =>
      'لنقم بإعداد حسابك. ستكون مسؤول هذه الشركة على VenuRite، ويمكنك دعوة فريقك بمجرد الدخول.';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get lastNameLabel => 'اسم العائلة';

  @override
  String get passwordMinCharsHelper => '8 أحرف على الأقل';

  @override
  String get companyDetailsIntro => 'أخبرنا عن شركتك.';

  @override
  String get tradingCompanyNameLabel => 'الاسم التجاري / اسم الشركة';

  @override
  String get legalCompanyNameLabel => 'الاسم القانوني للشركة (اختياري)';

  @override
  String get legalCompanyNameHelper =>
      'اتركه فارغًا لاستخدام الاسم التجاري أعلاه';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get registeredAddressLabel => 'العنوان المسجل / التجاري (اختياري)';

  @override
  String get vatNumberLabel =>
      'رقم ضريبة القيمة المضافة / الرقم الضريبي (إن وجد)';

  @override
  String get billingContactEmailLabel =>
      'بريد التواصل الخاص بالفوترة (اختياري)';

  @override
  String get structureIntro =>
      'هكذا تنظم VenuRite شركتك. لست بحاجة لإعداد أي شيء الآن - هذا فقط لجعل الخطوة التالية منطقية.';

  @override
  String get structureYourCompanyLabel => 'شركتك';

  @override
  String get structureYourCompanySublabel => 'حساب واحد موحد وفاتورة واحدة';

  @override
  String get structureRegionsLabel => 'المناطق (اختياري)';

  @override
  String get structureRegionsSublabel =>
      'جمّع المواقع حسب الدولة أو المنطقة - تخطَّ هذا إذا لم تكن بحاجة إليه';

  @override
  String get structureVenuesLabel => 'المواقع';

  @override
  String get structureVenuesSublabel =>
      'موقع واحد اليوم، المئات لاحقًا - أضف المزيد في أي وقت';

  @override
  String get structureStaffLabel => 'الموظفون';

  @override
  String get structureStaffSublabel =>
      'فريق كل موقع، تتم دعوته بمجرد وجود الموقع';

  @override
  String get structureOutro =>
      'سنقوم بإعداد أول موقع لك بعد ذلك - يمكنك إضافة المناطق والمزيد من المواقع لاحقًا من داخل التطبيق.';

  @override
  String get wizardFirstVenueHeroTitle => 'لنضف أول موقع لك';

  @override
  String get addMoreVenuesLaterText => 'يمكنك إضافة المزيد من المواقع لاحقًا.';

  @override
  String get venueNameLabel => 'اسم الموقع';

  @override
  String get addressOptionalLabel => 'العنوان (اختياري)';

  @override
  String get regionAreaOptionalLabel => 'المنطقة / المنطقة الجغرافية (اختياري)';

  @override
  String get regionAreaHelper =>
      'مثال \"الرياض\" - مطلوب فقط إذا كان لديك (أو سيكون لديك) أكثر من موقع واحد';

  @override
  String get venueTypeOptionalLabel => 'نوع الموقع (اختياري)';

  @override
  String get venueTypeHelper =>
      'اختيار نوع يعرض لك مجموعة أولية جاهزة - للمهام والمعدات التي تعرف بالفعل أنك بحاجة إليها.';

  @override
  String get payoffSkippedText =>
      'لقد تخطيت اختيار نوع الموقع، لذا لا توجد مجموعة أولية لعرضها بعد - يمكنك إضافة المهام والمعدات بنفسك بمجرد الدخول.';

  @override
  String get payoffErrorText =>
      'تعذر تحميل المجموعة الأولية لهذا النوع من المواقع - يمكنك إضافة المهام والمعدات بنفسك بمجرد الدخول.';

  @override
  String get payoffHeroTitle => 'هذا هو امتثالك، جاهز للاستخدام';

  @override
  String get equipmentSectionLabel => 'المعدات';

  @override
  String get subscriptionBannerText =>
      'حساب شركة واحد، فاتورة موحدة واحدة - يُحتسب السعر لكل موقع، أبدًا لكل شخص.';

  @override
  String get subscriptionIntroText =>
      'كم عدد المواقع التي لديك اليوم، بما في ذلك المكتب الرئيسي إن وجد؟ ستقوم الآن بإعداد أول موقع لك فقط - يمكنك إضافة الباقي في أي وقت من داخل التطبيق.';

  @override
  String get perBranchPriceLabel => '39 جنيهًا إسترلينيًا/موقع/شهر';

  @override
  String get headOfficeIncludedLabel => '+ موقع مكتب رئيسي واحد (4+ مواقع)';

  @override
  String get discountCodeHint =>
      'هل لديك رمز خصم؟ يمكنك إدخاله عند إعداد الخصم المباشر.';

  @override
  String get trialBannerText =>
      'أنت تبدأ فترة تجريبية مجانية مدتها 14 يومًا - لا حاجة لبطاقة اليوم.';

  @override
  String get paymentStepIntro =>
      'سنطلب منك إعداد الدفع قبل انتهاء فترتك التجريبية، من الإعدادات داخل التطبيق. لن يتم خصم أي مبلغ الآن - فقط أخبرنا كيف تفضل الدفع.';

  @override
  String get cardPaymentTitle => 'الدفع بالبطاقة (Stripe)';

  @override
  String get cardPaymentSubtitle => 'بطاقة خصم/ائتمان، تُفوتر شهريًا أو سنويًا';

  @override
  String get directDebitTitle => 'الخصم المباشر (GoCardless)';

  @override
  String get directDebitSubtitle => 'دفع من بنك إلى بنك، لا حاجة لبطاقة';

  @override
  String get decideLaterButton => 'سأقرر لاحقًا';

  @override
  String get decideLaterSnackbar =>
      'لا مشكلة - يمكنك إعداد هذا في أي وقت من الإعدادات.';

  @override
  String get agreeToTermsPrefix => 'لقد قرأت ووافقت على ';

  @override
  String get successActivatedBanner =>
      'تم إعداد شركتك وأول موقع لك، وقد سجّلت الدخول.';

  @override
  String get successNotActivatedBanner =>
      'تم إعداد شركتك وأول موقع لك. سجّل الدخول ببريدك الإلكتروني وكلمة المرور التي اخترتها للتو.';

  @override
  String get directDebitSettingUp => 'جارٍ إعداد الخصم المباشر...';

  @override
  String get directDebitOpenedBrowser =>
      'لقد فتحنا متصفحك لإنهاء إعداد الخصم المباشر.';

  @override
  String get inviteYourTeamTitle => 'ادعُ فريقك';

  @override
  String get inviteYourTeamSubtitle =>
      'اختياري - أضف أي شخص في نوبة العمل الآن، أو تخطَّ ذلك وقم به لاحقًا من إدارة الموظفين.';

  @override
  String get jobTitleLabel => 'المسمى الوظيفي';

  @override
  String get tierFieldLabel => 'المستوى';

  @override
  String get addTeamMemberButton => 'إضافة عضو فريق';

  @override
  String get goToDashboardButton => 'الذهاب إلى لوحة التحكم';

  @override
  String get goToSignInButton => 'الذهاب إلى تسجيل الدخول';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - الخطوة $step من $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'اتركه فارغًا لاستخدام $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'ليس لدينا بعد مجموعة أولية جاهزة لـ $venueType - يمكنك إضافة المهام والمعدات بنفسك بمجرد الدخول.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks مهمة عبر $sectionCount أقسام و$equipmentCount أنواع معدات مُعدة مسبقًا لـ $venueType.';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks مهمة عبر $sectionCount أقسام مُعدة مسبقًا لـ $venueType.';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/شهريًا إجمالاً ($units مواقع مفوترة)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'الرمز السري: $pin';
  }

  @override
  String get jobRoleChefCook => 'طاهٍ/شيف';

  @override
  String get jobRoleKitchenPorter => 'عامل مطبخ';

  @override
  String get jobRoleFrontOfHouse => 'صالة الخدمة';

  @override
  String get jobRoleBar => 'البار';

  @override
  String get jobRoleManagement => 'الإدارة';

  @override
  String get jobRoleEveryone => 'الجميع';

  @override
  String get jobRoleMaintenance => 'الصيانة';

  @override
  String get jobRoleHousekeeping => 'التدبير المنزلي';

  @override
  String get jobRoleReception => 'الاستقبال';

  @override
  String get jobRoleSecurity => 'الأمن';

  @override
  String get segmentFoodSafety => 'سلامة الغذاء والتحكم في درجة الحرارة';

  @override
  String get segmentAllergen => 'إدارة مسببات الحساسية';

  @override
  String get segmentPersonalHygienePpe => 'النظافة الشخصية ومعدات الحماية';

  @override
  String get segmentRefrigerationColdStorage => 'التبريد والتخزين البارد';

  @override
  String get segmentCookingLineEquipment => 'معدات خط الطهي';

  @override
  String get segmentWashupDishwash => 'غسيل الأطباق';

  @override
  String get segmentCleaningSanitation => 'التنظيف والتعقيم';

  @override
  String get segmentCleaningChemicals => 'مواد التنظيف الكيميائية والمستهلكات';

  @override
  String get segmentDryAmbientStorage => 'التخزين الجاف وفي درجة حرارة الغرفة';

  @override
  String get segmentDeliveriesGoodsIn => 'التوصيل واستلام البضائع';

  @override
  String get segmentUtilitiesSafety => 'المرافق والسلامة';

  @override
  String get segmentWastePestControl => 'النفايات ومكافحة الآفات';

  @override
  String get segmentPreventiveMaintenance => 'الصيانة الوقائية (معدات المطبخ)';

  @override
  String get segmentStockControl => 'مراقبة المخزون';

  @override
  String get segmentOpeningProcedures => 'إجراءات الفتح';

  @override
  String get segmentClosingProcedures => 'إجراءات الإغلاق';

  @override
  String get segmentServiceReadiness => 'الجاهزية للخدمة';

  @override
  String get segmentFrontOfHouse => 'صالة الخدمة / الخدمة';

  @override
  String get segmentBarBeverage => 'البار والمشروبات';

  @override
  String get segmentHotelSpecific => 'خاص بالفندق';

  @override
  String get segmentManagementComplianceOversight =>
      'الإدارة والإشراف على الامتثال';

  @override
  String get segmentMaintenance => 'الصيانة';

  @override
  String get segmentHousekeeping => 'التدبير المنزلي';

  @override
  String get segmentReception => 'الاستقبال';

  @override
  String get segmentSecurity => 'الأمن';

  @override
  String get freqDaily => 'يوميًا';

  @override
  String get freqWeekly => 'أسبوعيًا';

  @override
  String get freqPerShift => 'لكل نوبة';

  @override
  String get freqThreeXDaily => '3 مرات يوميًا';

  @override
  String get freqTwoXDaily => 'مرتين يوميًا';

  @override
  String get freqPerBatch => 'لكل دفعة';

  @override
  String get freqPerDelivery => 'لكل توصيلة';

  @override
  String get freqPerUse => 'لكل استخدام';

  @override
  String get freqPerService => 'لكل خدمة';

  @override
  String get freqTwoXPerService => 'مرتين لكل خدمة';

  @override
  String get freqEventBased => 'حسب الحدث';

  @override
  String get freqAsNeeded => 'عند الحاجة';

  @override
  String get freqMonthly => 'شهريًا';

  @override
  String get freqCustom => 'مخصص';

  @override
  String get jobRoleFieldLabel => 'المسمى الوظيفي';

  @override
  String get pinFieldLabel => 'الرمز السري';

  @override
  String get addStaffMemberTitle => 'إضافة موظف';

  @override
  String get addLabel => 'إضافة';

  @override
  String get assignTasksTitle => 'تعيين المهام';

  @override
  String get noActiveSiteFoundError => 'لم يتم العثور على موقع نشط.';

  @override
  String get byPersonLabel => 'حسب الشخص';

  @override
  String get byTaskLabel => 'حسب المهمة';

  @override
  String get noEquipmentOfTypeSetUp => 'لا توجد معدات من هذا النوع مُعدة بعد.';

  @override
  String get applyButton => 'تطبيق';

  @override
  String get assignToTitle => 'تعيين إلى';

  @override
  String get noStaffMatchTiers =>
      'لا يوجد موظفون يطابقون المستوى (المستويات) التي تنطبق عليها هذه المهام.';

  @override
  String get assignButton => 'تعيين';

  @override
  String get showInstructionsTooltip => 'إظهار التعليمات';

  @override
  String get selectTasksToAssignLabel => 'اختر المهام للتعيين';

  @override
  String get taskPresetsSectionTitle => 'مجموعات المهام الجاهزة';

  @override
  String get showAllPresetsButton => 'إظهار جميع المجموعات الجاهزة';

  @override
  String get showTasksInGroupTooltip => 'إظهار المهام في هذه المجموعة';

  @override
  String get applyToMultipleButton => 'تطبيق على عدة أشخاص';

  @override
  String get addCustomTaskButton => 'إضافة مهمة مخصصة';

  @override
  String get customTaskSectionTitle => 'مهمة مخصصة';

  @override
  String get titleFieldLabel => 'العنوان';

  @override
  String get departmentSectionLabel => 'القسم / الشعبة';

  @override
  String get methodLabel => 'الطريقة';

  @override
  String get methodTick => 'علامة صح';

  @override
  String get methodData => 'بيانات';

  @override
  String get methodDataTick => 'بيانات + علامة صح';

  @override
  String get methodTickPhoto => 'علامة صح + صورة';

  @override
  String get methodDataPhoto => 'بيانات + صورة';

  @override
  String get methodNote => 'ملاحظة';

  @override
  String get methodDataNote => 'بيانات + ملاحظة';

  @override
  String get methodNotePhoto => 'ملاحظة + صورة';

  @override
  String get methodTickNote => 'علامة صح + ملاحظة';

  @override
  String get methodMulti => 'متعدد';

  @override
  String get requiresPhotoLabel => 'يتطلب صورة';

  @override
  String get requiresNotesLabel => 'يتطلب ملاحظات';

  @override
  String get minLimitLabel => 'الحد الأدنى';

  @override
  String get maxLimitLabel => 'الحد الأقصى';

  @override
  String get unitHintLabel => 'الوحدة (مثال: مئوية)';

  @override
  String get equipmentTypeOptionalLabel => 'نوع المعدات (اختياري)';

  @override
  String get noneLabel => 'لا شيء';

  @override
  String get priorityLabel => 'الأولوية';

  @override
  String get priorityCritical => 'حرجة';

  @override
  String get priorityHigh => 'عالية';

  @override
  String get priorityStandard => 'قياسية';

  @override
  String get requiresCorrectiveActionLabel => 'يتطلب إجراءً تصحيحيًا عند الفشل';

  @override
  String get fixInstructionsLabel => 'تعليمات الإصلاح';

  @override
  String get customFieldsJsonLabel => 'حقول مخصصة (JSON، اختياري)';

  @override
  String get extraFieldsSectionTitle => 'حقول إضافية (اختياري)';

  @override
  String get removeTooltip => 'إزالة';

  @override
  String get fieldLabelHint => 'تسمية الحقل (مثال: رقم أمر الشراء)';

  @override
  String get extraFieldTypeText => 'نص';

  @override
  String get extraFieldTypeNumber => 'رقم';

  @override
  String get extraFieldTypeDate => 'تاريخ';

  @override
  String get addFieldTooltip => 'إضافة حقل';

  @override
  String get saveCustomTaskButton => 'حفظ المهمة المخصصة';

  @override
  String get adHocLabel => 'عند الحاجة';

  @override
  String get timeAllocatedLabel => 'وقت مخصص';

  @override
  String get frequencyPrefixLabel => 'التكرار: ';

  @override
  String get atATimeLabel => 'في وقت محدد';

  @override
  String get fromStartOfShiftLabel => 'من بداية الوردية';

  @override
  String get fromClockInLabel => 'من تسجيل الحضور';

  @override
  String get availableFromEllipsis => 'متاح من…';

  @override
  String get untilEllipsis => 'حتى…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'تعيين المهام - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return 'تطبيق \"$name\" على أيهما؟';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'تم بالفعل تعيين جميع مهام $name';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    return 'تمت إضافة $count مهمة من $name';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'تطبيق \"$name\" على';
  }

  @override
  String assignTasksCountLabel(int count) {
    return 'تعيين $count مهمة للموظفين…';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return 'تمت إضافة $count تعيين عبر $staffCount موظف';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'القسم: $segment';
  }

  @override
  String taskCountLabel(int count) {
    return '$count مهمة';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'إظهار جميع الأدوار (الافتراضي: $jobRole فقط)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - لا توجد معدات مُعدة لهذا بعد';
  }

  @override
  String fromTimeLabel(String time) {
    return 'من $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'حتى $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return 'تم إنشاء $count تعيين$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' (تم تخطي $count - معينة بالفعل أو عدم تطابق في الدور)';
  }

  @override
  String get serviceProvidersTitle => 'مقدمو الخدمات';

  @override
  String get myProvidersTab => 'مقدمو خدماتي';

  @override
  String get findProviderTab => 'البحث عن مقدم خدمة';

  @override
  String get noBackendProviderNotice1 =>
      'يتطلب تصفح مقدمي الخدمات الذين تشاركهم أماكن أخرى تسجيل الدخول بحساب شركة حقيقي - لا يمكن أن يعمل هذا فقط من تسجيل الدخول التجريبي المحلي. جهات اتصالك الخاصة ضمن \"مقدمو خدماتي\" تعمل في كلتا الحالتين.';

  @override
  String get noBackendProviderNotice2 =>
      'سجّل الدخول عبر وصول القيادة بحساب شركة حقيقي لاستخدام هذا.';

  @override
  String get providerDisclaimerText =>
      'لا يقوم VenuRite بفحص أو المصادقة على أي مقدم خدمة مدرج. المراجعات من أماكن أخرى، وليست من VenuRite.';

  @override
  String get addProviderButton => 'إضافة مقدم خدمة';

  @override
  String get noProvidersYetText => 'لم تقم بإضافة أي مقدم خدمة بعد.';

  @override
  String get addServiceProviderDialogTitle => 'إضافة مقدم خدمة';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get phoneOptionalLabel => 'الهاتف (اختياري)';

  @override
  String get emailOptionalLabel => 'البريد الإلكتروني (اختياري)';

  @override
  String get notesOptionalPrivateLabel => 'ملاحظات (اختياري، خاصة بك)';

  @override
  String get happyToReviewShareLabel => 'يسعدني المراجعة والمشاركة';

  @override
  String get shareVisibilityExplanation =>
      'ستشاهد الأماكن الأخرى تقييماتك ومراجعاتك، مع تعتيم الاسم/جهة الاتصال حتى يتم فتحها.';

  @override
  String get rateThisProviderLabel => 'قيّم مقدم الخدمة هذا';

  @override
  String get priceRatingLabel => 'السعر';

  @override
  String get punctualityRatingLabel => 'الالتزام بالمواعيد';

  @override
  String get qualityRatingLabel => 'الجودة';

  @override
  String get availabilityRatingLabel => 'التوفر';

  @override
  String get reviewOptionalLabel => 'مراجعة (اختياري)';

  @override
  String get reviewHintText =>
      'صف تجربتك - يرجى عدم ذكر اسم النشاط التجاري أو تضمين تفاصيل الاتصال.';

  @override
  String get sessionExpiredMessage =>
      'انتهت صلاحية جلستك - يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get sharedWithOtherVenuesLabel => 'تمت مشاركته مع أماكن أخرى';

  @override
  String get privateLabel => 'خاص';

  @override
  String get rateReviewsButton => 'تقييم / مراجعات';

  @override
  String get searchByCategoryOrNameHint => 'البحث حسب الفئة أو الاسم';

  @override
  String get noContactsUnlockedThisMonth =>
      'لم يتم فتح أي جهة اتصال بعد هذا الشهر.';

  @override
  String get noSharedProvidersYetText =>
      'لا يوجد مقدمو خدمات مشتركون بعد - كن أول من يشارك واحدًا من \"مقدمو خدماتي.\"';

  @override
  String get noProvidersMatchSearchText => 'لا يوجد مقدم خدمة يطابق بحثك.';

  @override
  String get noRatingsYetText => 'لا توجد تقييمات بعد';

  @override
  String get hiddenUntilUnlockedText => 'مخفي حتى يتم فتحه';

  @override
  String get unnamedPlaceholder => '(بدون اسم)';

  @override
  String get readReviewsButton => 'قراءة المراجعات';

  @override
  String get unlockContactDetailsButton => 'فتح تفاصيل الاتصال';

  @override
  String get reviewsTitle => 'المراجعات';

  @override
  String get noReviewsYetText => 'لا توجد مراجعات بعد.';

  @override
  String get addYourRatingLabel => 'أضف تقييمك';

  @override
  String get submittingEllipsis => 'جارٍ الإرسال...';

  @override
  String get submitRatingButton => 'إرسال التقييم';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'يبدو أن مراجعتك تتضمن $found. يرجى إزالة تفاصيل الاتصال أو أسماء الأعمال قبل الإرسال.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'يبدو أن مراجعتك تتضمن $found. يرجى إزالة تفاصيل الاتصال أو أسماء الأعمال قبل الإرسال - تظل المراجعات مفيدة (وعادلة) عندما تصف التجربة، وليس من يجب الاتصال به مباشرة.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    return 'تم فتح $count جهة اتصال هذا الشهر.';
  }

  @override
  String priceValueLabel(String value) {
    return 'السعر $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'الالتزام بالمواعيد $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'الجودة $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'التوفر $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    return '$parts ($count مراجعة)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'السعر $price - الالتزام بالمواعيد $punctuality - الجودة $quality - التوفر $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'الهاتف: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'البريد الإلكتروني: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'منتجات طازجة';

  @override
  String get supplierCategoryMeatPoultry => 'لحوم ودواجن';

  @override
  String get supplierCategoryDairyEggs => 'ألبان وبيض';

  @override
  String get supplierCategoryFrozenGoods => 'بضائع مجمدة';

  @override
  String get supplierCategoryDryAmbientGoods =>
      'بضائع جافة وفي درجة حرارة الغرفة';

  @override
  String get supplierCategoryDrinksBeverages => 'مشروبات';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'مواد كيميائية ومستلزمات تنظيف';

  @override
  String get supplierCategoryEquipmentMaintenance => 'معدات وصيانة';

  @override
  String get supplierCategoryOther => 'أخرى';

  @override
  String get supplierStatusApproved => 'معتمد';

  @override
  String get supplierStatusPending => 'قيد الانتظار';

  @override
  String get supplierStatusSuspended => 'موقوف';

  @override
  String get addEquipmentTitle => 'إضافة معدات';

  @override
  String get venueSetupTitle => 'إعداد الموقع';

  @override
  String get nextButton => 'التالي';

  @override
  String get finishSetupButton => 'إنهاء الإعداد';

  @override
  String get renameAreaTitle => 'إعادة تسمية المنطقة';

  @override
  String get renameEquipmentTitle => 'إعادة تسمية المعدات';

  @override
  String get saveButton => 'حفظ';

  @override
  String get retireEquipmentTitle => 'سحب المعدات من الخدمة';

  @override
  String get retireEquipmentConfirmText =>
      'سيؤدي سحب هذه المعدات من الخدمة أيضًا إلى إلغاء تعيين أي مهام مسندة إليها حاليًا. يتم الاحتفاظ بسجل التقديمات السابقة. متابعة؟';

  @override
  String get retireButton => 'سحب من الخدمة';

  @override
  String get areasStepTitle => 'المناطق';

  @override
  String get areasStepIntro => 'أضف المناطق التشغيلية لهذا الموقع.';

  @override
  String get areaSuggestionKitchen => 'المطبخ';

  @override
  String get areaSuggestionStorage => 'التخزين';

  @override
  String get areaSuggestionReceiving => 'الاستلام';

  @override
  String get areaSuggestionFrontOfHouse => 'صالة الخدمة';

  @override
  String get areaNameLabel => 'اسم المنطقة';

  @override
  String get addAreaTooltip => 'إضافة منطقة';

  @override
  String get renameTooltip => 'إعادة تسمية';

  @override
  String get equipmentStepTitle => 'المعدات';

  @override
  String get equipmentStepIntro =>
      'أضف أمثلة معدات مسماة، مثل \"ثلاجة 1\"، \"ثلاجة 2\".';

  @override
  String get showAllEquipmentTypesButton => 'إظهار جميع أنواع المعدات';

  @override
  String get equipmentTypeLabel => 'نوع المعدات';

  @override
  String get somethingElseOption => 'شيء آخر...';

  @override
  String get newEquipmentTypeNameLabel => 'اسم نوع المعدات الجديد';

  @override
  String get confirmNewEquipmentTypeTooltip => 'تأكيد نوع المعدات الجديد';

  @override
  String get noAreasForDeptText =>
      'لا توجد مناطق مُعدة لقسمك بعد - لا يزال بالإمكان إضافة المعدات بدون واحدة.';

  @override
  String get noAreasAddOneText =>
      'لم تتم إضافة أي منطقة بعد - ارجع لإضافة واحدة.';

  @override
  String get equipmentNameLabel => 'اسم المعدات';

  @override
  String get equipmentNameHint =>
      'مثال: غرفة تبريد اللحوم، ثلاجة الحلويات، مقلاة البار';

  @override
  String get modelOptionalLabel => 'الطراز (اختياري)';

  @override
  String get serialNumberOptionalLabel => 'الرقم التسلسلي (اختياري)';

  @override
  String get retireTooltip => 'سحب من الخدمة';

  @override
  String get reactivateTooltip => 'إعادة التفعيل';

  @override
  String get unknownTypeLabel => 'نوع غير معروف';

  @override
  String get unknownAreaLabel => 'منطقة غير معروفة';

  @override
  String get staffStepTitle => 'الموظفون';

  @override
  String get staffStepIntro => 'أضف أعضاء الموظفين وعيّن مستوى دورهم.';

  @override
  String get addStaffMemberButton => 'إضافة عضو موظف';

  @override
  String get suppliersStepTitle => 'الموردون';

  @override
  String get suppliersStepIntro =>
      'أضف الموردين الذين يتعامل معهم هذا الموقع. تظهر علامات الموافقة في تصدير EHO - يتم إظهار الموردين الموقوفين للمديرين، وليس إخفاؤهم بصمت.';

  @override
  String get supplierNameLabel => 'اسم المورد';

  @override
  String get contactOptionalLabel => 'جهة الاتصال (اختياري)';

  @override
  String get phoneOrEmailHint => 'الهاتف أو البريد الإلكتروني';

  @override
  String get approvalStatusLabel => 'حالة الموافقة';

  @override
  String get addSupplierButton => 'إضافة مورد';

  @override
  String venueSetupStepTitle(int step) {
    return 'إعداد الموقع - الخطوة $step من 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'الطراز: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'الرقم التسلسلي: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (متقاعد)';
  }

  @override
  String get addEquipmentTooltip => 'إضافة معدات';

  @override
  String get newPinLabel => 'رمز سري جديد';

  @override
  String get editDetailsTitle => 'تعديل التفاصيل';

  @override
  String get sectionLabel => 'القسم';

  @override
  String get noSectionOption => 'بدون قسم';

  @override
  String get inactiveParenSuffix => ' (غير نشط)';

  @override
  String get noSpecificTeamOption => 'بدون فريق محدد';

  @override
  String get noSectionsSetupText =>
      'لا توجد أقسام مُعدة في هذا الموقع بعد - أضف واحدًا أولاً في إدارة الأقسام.';

  @override
  String get reportsToFieldLabel => 'يتبع إلى';

  @override
  String get notSetOption => 'غير محدد';

  @override
  String get deactivateStaffMemberTitle => 'إلغاء تفعيل الموظف';

  @override
  String get staffManagementTitle => 'إدارة الموظفين';

  @override
  String get addStaffTooltip => 'إضافة موظف';

  @override
  String get bulkImportTooltip => 'استيراد جماعي';

  @override
  String get deactivatedSuffixLabel => '(معطل)';

  @override
  String get moreActionsTooltip => 'المزيد من الإجراءات';

  @override
  String get changeTierMenuItem => 'تغيير المستوى';

  @override
  String get changeSectionMenuItem => 'تغيير القسم';

  @override
  String get assignSupervisionMenuItem => 'تعيين الإشراف';

  @override
  String get reportsToMenuItem => 'يتبع إلى';

  @override
  String get resetPinMenuItem => 'إعادة تعيين الرمز السري';

  @override
  String get trainingRecordsMenuItem => 'سجلات التدريب';

  @override
  String unknownUserIdFallback(String id) {
    return 'مستخدم #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'إعادة تعيين الرمز السري - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'تمت إعادة تعيين الرمز السري لـ $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'تغيير مستوى الدور - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'تغيير القسم - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'تعيين الإشراف - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'تم تحديث نطاق الإشراف لـ $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'يتبع إلى - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return 'لن يتمكن $name بعد الآن من تسجيل الدخول. سيتم إلغاء تعيين مهامه النشطة. لن يتأثر سجل تقديماته. يمكن التراجع عن هذا لاحقًا.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'يتبع إلى $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return 'في $date بواسطة $name';
  }

  @override
  String get darkModeLabel => 'الوضع الداكن';

  @override
  String get brandIdentityIntro =>
      'هوية علامة تجارية واحدة، مشتركة على مستوى الشركة - تنطبق على كل موقع، وليس لكل موقع على حدة.';

  @override
  String get companyNameLabel => 'اسم الشركة';

  @override
  String get companyLogoLabel => 'شعار الشركة';

  @override
  String get chooseLogoButton => 'اختيار الشعار';

  @override
  String get changeLogoButton => 'تغيير الشعار';

  @override
  String get brandColourLabel => 'لون العلامة التجارية';

  @override
  String get customHexColourLabel => 'لون سداسي عشري مخصص';

  @override
  String get enterValidHexColourError => 'أدخل لونًا سداسيًا عشريًا صالحًا';

  @override
  String get contactPhoneLabel => 'هاتف التواصل';

  @override
  String get contactEmailLabel => 'بريد التواصل الإلكتروني';

  @override
  String get savingEllipsisLabel => 'جارٍ الحفظ...';

  @override
  String get saveBrandingButton => 'حفظ الهوية';

  @override
  String get brandingSavedMessage => 'تم حفظ الهوية';

  @override
  String get customSwatchTooltip => 'مخصص';

  @override
  String get rosterAddonTitle =>
      'نوبات/جدول الموظفين (+6-10 جنيه إسترليني/موقع/شهر)';

  @override
  String get rosterAddonSubtitle =>
      'دع الموظفين يرون النوبات المفتوحة ويطلبونها بأنفسهم - يقوم المدير بنشر النوبات، ويختارها الموظفون. 6 جنيهات إسترلينية/شهر لكل موقع أقل من 10 موظفين، و10 جنيهات إسترلينية/شهر لـ 10 أو أكثر.';

  @override
  String get enableRosterTitle => 'تفعيل الجدول؟';

  @override
  String get confirmButton => 'تأكيد';

  @override
  String get clearDemoDataTitle => 'مسح بيانات العرض التوضيحي؟';

  @override
  String get clearDemoDataConfirmText =>
      'سيؤدي هذا إلى حذف كل موظف وفرع وقسم تجريبي نهائيًا، وتسجيل خروجك. لا يمكن التراجع عن هذا.';

  @override
  String get clearEverythingButton => 'مسح كل شيء';

  @override
  String get clearDemoDataCardTitle => 'مسح بيانات العرض التوضيحي';

  @override
  String get clearDemoDataCardBody =>
      'أزل كل موظف وفرع وقسم تجريبي حتى تتمكن من إعداد بياناتك الخاصة من الصفر.';

  @override
  String get clearDemoDataButton => 'مسح بيانات العرض التوضيحي';

  @override
  String get temperatureUnitLabel => 'وحدة درجة الحرارة';

  @override
  String get celsiusLabel => 'مئوية (°C)';

  @override
  String get fahrenheitLabel => 'فهرنهايت (°F)';

  @override
  String get comingSoonLabel => 'قريبًا';

  @override
  String get presetColorOceanTeal => 'أزرق محيطي';

  @override
  String get presetColorNavy => 'كحلي';

  @override
  String get presetColorIndigo => 'نيلي';

  @override
  String get presetColorSlate => 'أردوازي';

  @override
  String get presetColorPlum => 'خوخي غامق';

  @override
  String get presetColorForest => 'أخضر غابي';

  @override
  String get presetColorUmber => 'عنبري';

  @override
  String get presetColorCharcoal => 'فحمي';

  @override
  String couldNotGetPriceError(String error) {
    return 'تعذر الحصول على السعر: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'بناءً على عدد موظفيك الحالي، سيضيف هذا $amount إلى الخصم المباشر الشهري الخاص بك.';
  }

  @override
  String get departmentLabel => 'القسم';

  @override
  String get noDepartmentOption => 'بدون قسم';

  @override
  String get removeAnywayButton => 'إزالة على أي حال';

  @override
  String get branchTeamStructureTitle => 'هيكل فريق الفرع';

  @override
  String get noStaffAtBranchText => 'لا يوجد موظفون في هذا الفرع بعد.';

  @override
  String get changeManagerMenuItem => 'تغيير المدير';

  @override
  String get moveDepartmentMenuItem => 'نقل القسم/الفريق';

  @override
  String get editJobTitleMenuItem => 'تعديل المسمى الوظيفي';

  @override
  String get removeFromBranchMenuItem => 'إزالة من هذا الفرع';

  @override
  String changeManagerTitle(String name) {
    return 'تغيير المدير - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'نقل القسم/الفريق - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'تغيير المستوى - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'تعديل المسمى الوظيفي - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'إزالة $name من هذا الفرع';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return 'لن يتمكن $name بعد الآن من تسجيل الدخول. يمكن التراجع عن هذا لاحقًا.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    return 'يتبع حاليًا $count شخص لـ $name: $names. ستؤدي إزالة $name إلى تركهم بدون تعيين حتى تتم إعادة تعيينهم.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'أعد تعيينهم بدلاً من ذلك إلى مدير $name نفسه';
  }

  @override
  String reportsCountBadge(int count) {
    return '$count تابع';
  }

  @override
  String get regionalManagerAssignedTitle => 'تم تعيين المدير الإقليمي';

  @override
  String get noOrganisationOnSessionError => 'لا توجد شركة في هذه الجلسة.';

  @override
  String get newRegionNameTitle => 'اسم المنطقة الجديدة';

  @override
  String get renameRegionTitle => 'إعادة تسمية المنطقة';

  @override
  String get renameVenueTitle => 'إعادة تسمية الموقع';

  @override
  String get newVenueNameTitle => 'اسم الموقع الجديد';

  @override
  String get doneButton => 'تم';

  @override
  String get resetPasswordQuestionTitle => 'إعادة تعيين كلمة المرور؟';

  @override
  String get resetButton => 'إعادة تعيين';

  @override
  String get passwordResetTitle => 'تمت إعادة تعيين كلمة المرور';

  @override
  String get giveNewTempPasswordText =>
      'أعطِ هذا الشخص كلمة مروره المؤقتة الجديدة.';

  @override
  String get organisationTitle => 'الشركة';

  @override
  String get headOfficeLabel => 'المكتب الرئيسي';

  @override
  String get addRegionMenuItem => 'إضافة منطقة';

  @override
  String get addVenueNoRegionMenuItem => 'إضافة موقع (بدون منطقة)';

  @override
  String get venuesNoRegionLabel => 'المواقع (بدون منطقة)';

  @override
  String get resetPasswordTooltip => 'إعادة تعيين كلمة المرور';

  @override
  String get addVenueMenuItem => 'إضافة موقع';

  @override
  String get assignRegionalManagerMenuItem => 'تعيين مدير إقليمي';

  @override
  String get reassignRegionalManagerMenuItem => 'إعادة تعيين مدير إقليمي';

  @override
  String get noRegionalManagerYetText => 'لا يوجد مدير إقليمي بعد';

  @override
  String get noVenuesInRegionText => 'لا توجد مواقع في هذه المنطقة بعد.';

  @override
  String get noVenueManagerYetText => 'لا يوجد مدير موقع بعد';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'تعيين مدير إقليمي - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'الحساب نشط الآن. أعطِ $name بيانات تسجيل الدخول الخاصة به - يستخدم وصول القيادة.';
  }

  @override
  String emailColonLabel(String email) {
    return 'البريد الإلكتروني: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'كلمة المرور المؤقتة: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'سيؤدي هذا إلى إبطال كلمة مرور $name الحالية فورًا. ستحصل على كلمة مرور مؤقتة جديدة لتسليمها.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  مدير الموقع';
  }

  @override
  String get noSignedInUserError => 'لم يتم العثور على مستخدم مسجل الدخول.';

  @override
  String get customCategoryTitleLabel => 'عنوان فئة مخصص';

  @override
  String get approvalNoteLabel => 'ملاحظة الموافقة / العناية الواجبة (اختياري)';

  @override
  String get supplierManagementTitle => 'إدارة الموردين';

  @override
  String get noSuppliersAddedYetText => 'لم تتم إضافة أي موردين بعد.';

  @override
  String get inactiveStandaloneLabel => '(غير نشط)';

  @override
  String get changeApprovalStatusMenuItem => 'تغيير حالة الموافقة';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'تعديل التفاصيل - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'تغيير حالة الموافقة - $name';
  }

  @override
  String get newVenueTypeTitle => 'نوع موقع جديد';

  @override
  String get renameOrganisationTitle => 'إعادة تسمية الشركة';

  @override
  String get resetSetupCodeTitle => 'إعادة تعيين رمز الإعداد؟';

  @override
  String get resetSetupCodeConfirmText =>
      'سيؤدي هذا إلى قطع الاتصال بكل جهاز لوحي يستخدم هذا الموقع حاليًا حتى يحصل على الرمز الجديد. متابعة؟';

  @override
  String get resetCodeButton => 'إعادة تعيين الرمز';

  @override
  String get createNewVenueTitle => 'إنشاء موقع جديد';

  @override
  String get multiSiteSupportPartialText =>
      'دعم المواقع المتعددة جزئي: لم تتم تصفية المعدات والموظفين وقوائم المهام حسب الموقع بعد، لذا فإن الاستخدام اليومي لموقع ثانٍ غير مدعوم بالكامل بعد. إنشاء واحد آمن، لكنك سترى بيانات هذا الموقع والموقع الأصلي مختلطة في القوائم المشتركة حتى يتم بناء ذلك.';

  @override
  String get createButton => 'إنشاء';

  @override
  String get venueDetailsTitle => 'تفاصيل الموقع';

  @override
  String get billingLabel => 'الفوترة';

  @override
  String get billingSubtitleText => 'الخطة، الحالة، الخصم المباشر';

  @override
  String get activeLabel => 'نشط';

  @override
  String get setAsActiveButton => 'تعيين كنشط';

  @override
  String get tabletSetupCodeTitle => 'رمز إعداد الجهاز اللوحي';

  @override
  String get tabletSetupCodeExplanation =>
      'أدخل هذا مرة واحدة على جهاز لوحي جديد حتى يتمكن من عرض قائمة موظفي هذا الموقع.';

  @override
  String get generateCodeButton => 'إنشاء رمز';

  @override
  String get venueTypeSectionTitle => 'نوع الموقع';

  @override
  String get renamePresetTitle => 'إعادة تسمية المجموعة الجاهزة';

  @override
  String get noTaskTemplatesExistYetText => 'لا توجد قوالب مهام بعد.';

  @override
  String get addTaskToPresetTitle => 'إضافة مهمة إلى المجموعة الجاهزة';

  @override
  String get taskFieldLabel => 'المهمة';

  @override
  String get defaultFrequencyLabel => 'التكرار الافتراضي';

  @override
  String get noPresetsYetText => 'لا توجد مجموعات جاهزة بعد.';

  @override
  String get createPresetButton => 'إنشاء مجموعة جاهزة';

  @override
  String get presetVerificationBannerText =>
      'تم البحث في حدود المهام وتوثيقها (موسومة بـ [LAW]/[FSA]/[BEST] في تعليمات كل مهمة) لكن لم يتم اعتمادها بعد من قبل أخصائي سلامة غذائية مؤهل. لا تعاملها كحجة قانونية حتى يتم التحقق منها.';

  @override
  String get equipmentPresetsSectionTitle => 'مجموعات المعدات الجاهزة';

  @override
  String get sectionPresetsSectionTitle => 'مجموعات الأقسام الجاهزة';

  @override
  String get addTaskButton => 'إضافة مهمة';

  @override
  String get newPresetSectionTitle => 'مجموعة جاهزة جديدة';

  @override
  String get sectionSegmentOptionalLabel => 'القسم / الشعبة (اختياري)';

  @override
  String get setEquipmentOrSectionHint =>
      'حدد نوع معدات أو قسمًا (واحد على الأقل).';

  @override
  String equipmentTypeFallback(String id) {
    return 'نوع المعدات #$id';
  }

  @override
  String taskFallback(String id) {
    return 'المهمة #$id';
  }

  @override
  String get departmentCategoryKitchen => 'المطبخ';

  @override
  String get departmentCategoryFrontOfHouse => 'صالة الخدمة';

  @override
  String get departmentCategoryBar => 'البار';

  @override
  String get departmentCategoryManagement => 'الإدارة';

  @override
  String get departmentCategoryMaintenance => 'الصيانة';

  @override
  String get departmentCategoryHousekeeping => 'التدبير المنزلي';

  @override
  String get departmentCategoryReception => 'الاستقبال';

  @override
  String get departmentCategorySecurity => 'الأمن';

  @override
  String get addDepartmentButton => 'إضافة قسم';

  @override
  String get departmentManagementTitle => 'إدارة الأقسام';

  @override
  String get noDepartmentsAddedYetText => 'لم تتم إضافة أي قسم بعد.';

  @override
  String get noTeamsYetText => 'لا توجد فرق بعد';

  @override
  String get editMenuItem => 'تعديل';

  @override
  String get addTeamButton => 'إضافة فريق';

  @override
  String editDepartmentTitle(String name) {
    return 'تعديل - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'إضافة فريق - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'إعادة تسمية - $name';
  }

  @override
  String teamCountLabel(int count) {
    return '$count فريق';
  }

  @override
  String get documentCategoryPolicy => 'سياسة';

  @override
  String get documentCategoryCertificate => 'شهادة';

  @override
  String get documentCategoryProcedure => 'إجراء';

  @override
  String get documentCategoryEhoReport => 'تقرير EHO';

  @override
  String get addDocumentTitle => 'إضافة مستند';

  @override
  String get noExpiryDateText => 'بدون تاريخ انتهاء';

  @override
  String get setExpiryButton => 'تعيين تاريخ الانتهاء';

  @override
  String get couldNotOpenFileText => 'تعذر فتح هذا الملف.';

  @override
  String get documentCentreTitle => 'مركز المستندات';

  @override
  String get validLabel => 'صالح';

  @override
  String get expiringSoonLabel => 'ينتهي قريبًا';

  @override
  String get expiredLabel => 'منتهي الصلاحية';

  @override
  String get allFilterLabel => 'الكل';

  @override
  String get noDocumentsYetText => 'لا توجد مستندات بعد.';

  @override
  String get openMenuItem => 'فتح';

  @override
  String expiresOnLabel(String date) {
    return 'تنتهي في $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'لم يتم اختيار خطة';

  @override
  String get codeNotRecognisedText => 'لم يتم التعرف على هذا الرمز.';

  @override
  String get couldNotReachServerText => 'تعذر الوصول إلى الخادم.';

  @override
  String get discountAppliedText => 'تم تطبيق رمز الخصم.';

  @override
  String get couldNotOpenBrowserText => 'تعذر فتح المتصفح';

  @override
  String get noSubscriptionFoundText => 'لم يتم العثور على اشتراك لهذه الشركة.';

  @override
  String get discountAppliedBadge => 'تم تطبيق الخصم';

  @override
  String get directDebitSetUpText => 'الخصم المباشر مُعد لهذه الشركة.';

  @override
  String get directDebitNotSetUpText =>
      'لم تقم بإعداد الخصم المباشر بعد. سيتم نقلك إلى GoCardless - لا يرى VenuRite تفاصيل حسابك المصرفي مباشرة أبدًا.';

  @override
  String get discountCodeOptionalLabel => 'رمز الخصم (اختياري)';

  @override
  String get discountCodeHintText => 'هل لديك رمز \'Friends\'؟ أدخله هنا';

  @override
  String get setUpDirectDebitButton => 'إعداد الخصم المباشر';

  @override
  String get freeAccessCodeTitle => 'رمز الوصول المجاني';

  @override
  String get freeAccessActiveText =>
      'الوصول المجاني نشط لهذه الشركة - لا حاجة لخصم مباشر أو دفع بالبطاقة.';

  @override
  String get freeAccessPromptText =>
      'هل لديك رمز وصول مجاني؟ أدخله هنا لاستخدام التطبيق الكامل دون إعداد الدفع.';

  @override
  String get redeemCodeButton => 'استرداد الرمز';

  @override
  String get onTrialText => 'في الفترة التجريبية';

  @override
  String get paymentFailedGraceText =>
      'فشلت عملية دفع حديثة. يرجى تحديث الخصم المباشر الخاص بك - يستمر الوصول خلال فترة السماح هذه.';

  @override
  String get directDebitCancelledRestrictedText =>
      'تم إلغاء الخصم المباشر الخاص بك. الوصول مقيد بالقراءة فقط حتى يتم إعداد الفوترة مرة أخرى.';

  @override
  String get paymentOverdueRestrictedText =>
      'تأخر الدفع لفترة طويلة جدًا. الوصول مقيد بالقراءة فقط حتى يتم حل هذا الأمر.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'تعذر تحميل تفاصيل الفوترة: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price جنيه إسترليني/شهريًا ($units مواقع مفوترة)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'في الفترة التجريبية حتى $date';
  }

  @override
  String get reportedIssuesTitle => 'المشاكل المبلغ عنها';

  @override
  String get noDeliveriesLoggedText =>
      'لا توجد عمليات تسليم مسجلة لهذا المورد في هذه الفترة.';

  @override
  String get scorecardCategoriesExplanation =>
      'تُحتسب كل فئة أدناه بشكل مستقل - يمكن أن يظهر التسليم في أكثر من صف واحد (مثال: متأخر وتالف معًا).';

  @override
  String get rejectedOutrightLabel => 'مرفوض بالكامل';

  @override
  String get acceptedPartiallyLabel => 'مقبول جزئيًا';

  @override
  String get reportedIssuesExplanation =>
      'مشاكل التوريد المبلغ عنها ضد هذا المورد - سجل منفصل عن بطاقة أداء التسليم أعلاه، وغير مدمج معه.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'بطاقة أداء التسليم ($count عمليات تسليم)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }
}
