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
  String get emailLabel => 'البريد الإلكتروني';

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
}
