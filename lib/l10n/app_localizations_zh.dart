// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => '设置';

  @override
  String get personalSection => '个人';

  @override
  String get languageSettingTitle => '语言';

  @override
  String get languageSettingSubtitle => '选择你希望 VenuRite 使用的语言。';

  @override
  String get languageUpdated => '语言已更新。';

  @override
  String get chooseLanguageTitle => '选择语言';

  @override
  String get languageDeviceScope => '员工登录前，此设备将使用该语言。';

  @override
  String languageUserScope(String name) {
    return '已为 $name 保存。';
  }

  @override
  String get cancel => '取消';

  @override
  String get done => '完成';

  @override
  String get login => '登录';

  @override
  String get back => '返回';

  @override
  String get enterPin => '输入 PIN';

  @override
  String get leadershipAccess => '管理层访问';

  @override
  String get notOnThisList => '不在此列表中？使用其他方式登录';

  @override
  String errorLoadingStaff(String error) {
    return '加载员工时出错：$error';
  }

  @override
  String get incorrectPin => 'PIN 不正确';

  @override
  String tooManyWrongAttempts(int minutes) {
    return '错误尝试次数过多。请在 $minutes 分钟后重试。';
  }

  @override
  String get accountNotFound => '找不到账户';

  @override
  String get getStarted => '开始';

  @override
  String get kitchenComplianceDoneRight => '厨房合规，清晰可靠';

  @override
  String get valuePointEhoReady => '随时准备接受卫生检查 - 实时记录，不再临时补救';

  @override
  String get valuePointHonestRecords => '设计为无法操纵结果 - 每次检查都有可靠记录';

  @override
  String get valuePointAuditExport => '一键导出审计记录 - 立即向检查员提供真实记录';

  @override
  String get howGetStarted => '你想如何开始？';

  @override
  String get setUpMyBusiness => '设置我的场所';

  @override
  String get teamAlreadyUses => '我的团队已经在使用 VenuRite';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get needHelpContact => '需要帮助？联系 VenuRite';

  @override
  String get signInAnotherWay => '使用其他方式登录';

  @override
  String get deviceNotSetUp => '此平板尚未设置';

  @override
  String get askManagerSetupCode => '请向经理索取此场所的设置代码。';

  @override
  String get setupCode => '设置代码';

  @override
  String get connectTablet => '连接此平板';

  @override
  String get couldNotReachServer => '无法连接服务器';

  @override
  String get stillStuckSetupCode => '仍然无法继续？经理可在“设置 -> 场所详情”中找到它。';

  @override
  String get askQuestionTitle => '提问';

  @override
  String get askQuestionLabel => '你想了解什么？';

  @override
  String get askQuestionHint => '例如：冰箱温度应该是多少？';

  @override
  String get ask => '提问';

  @override
  String get aiQuestionLimitReached => '本月 AI 提问次数已达上限';

  @override
  String get home => '首页';

  @override
  String get logOut => '退出登录';

  @override
  String get endShift => '结束班次';

  @override
  String get workerHubPrompt => '你想做什么？';

  @override
  String get myScheduledTasks => '我的计划任务';

  @override
  String get doAdHocTask => '执行临时任务';

  @override
  String get logSomethingHappened => '记录刚发生的事情';

  @override
  String get claimShift => '认领班次';

  @override
  String get requestDayOff => '申请休假';

  @override
  String get thingsIReported => '我报告的事项';

  @override
  String shiftWelcome(String firstName) {
    return '欢迎，$firstName';
  }

  @override
  String get shiftPlanIntro => '你的班次安排如下：';

  @override
  String get startOfShift => '班次开始';

  @override
  String get duringYourShift => '班次期间';

  @override
  String get endOfShift => '班次结束';

  @override
  String get shiftHandoverTitle => '交接班';

  @override
  String get shiftHandoverNeedsAttention => '这项仍需要下一班的注意';

  @override
  String get gotIt => '知道了';

  @override
  String get openIssues => '未解决的问题';

  @override
  String get flaggedEquipment => '标记的设备';

  @override
  String get notYetDoneToday => '今天尚未完成';

  @override
  String get takePhoto => '拍照';

  @override
  String get uploadFromFiles => '从文件上传';

  @override
  String get seeAllTasksTooltip => '查看所有任务';

  @override
  String get leaveBeforeFinishingTitle => '要在完成前退出吗?';

  @override
  String get leaveBeforeFinishingBody => '部分检查尚未完成,这将被记录。您可以在本班次的任何时候返回并完成。';

  @override
  String get enterValue => '输入数值';

  @override
  String enterValueWithUnit(String unit) {
    return '输入数值 ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return '安全范围: $min - $max';
  }

  @override
  String get errorNumericRequired => '需要输入有效的数值';

  @override
  String get errorSelectOption => '请选择一个选项';

  @override
  String get errorNotesRequired => '需要填写备注';

  @override
  String get errorPhotoRequired => '需要拍照';

  @override
  String get errorCorrectiveActionRequired => '请选择纠正措施的处理方式';

  @override
  String get myTasksTitle => '我的任务';

  @override
  String get taskTitleFallback => '任务';

  @override
  String get noTasksAssigned => '暂无分配的任务。';

  @override
  String get overdueLabel => '已逾期';

  @override
  String overdueSinceLabel(String date) {
    return '自 $date 起逾期';
  }

  @override
  String get withinRangePass => '在范围内 - 通过';

  @override
  String get outsideRangeFail => '超出范围 - 未通过';

  @override
  String get selectOptionLabel => '选择一个选项';

  @override
  String get notesLabel => '备注';

  @override
  String get spotCheckPhotoNotice => '今日抽查 - 这次需要拍照以确认确实已完成。';

  @override
  String get photoAdded => '已添加照片';

  @override
  String get addPhoto => '添加照片';

  @override
  String get passLabel => '通过';

  @override
  String get failLabel => '未通过';

  @override
  String get readingOutsideSafeRange => '读数超出安全范围';

  @override
  String get hereIsWhatToDo => '应采取的措施:';

  @override
  String get correctiveActionRequired => '需要采取纠正措施';

  @override
  String get iFixedIt => '我已处理';

  @override
  String get reportedToManager => '已上报给经理';

  @override
  String get correctiveActionNoteLabel => '你做了什么?(可选)';

  @override
  String get managerWillBeNotified => '您的经理将收到通知。';

  @override
  String get submitButton => '提交';

  @override
  String availableFrom(String time) {
    return '$time 后可用';
  }

  @override
  String get backToList => '返回列表';

  @override
  String get skipComesBackLater => '跳过 - 稍后再来';

  @override
  String get noAdHocTaskTypesSetUp => '该站点尚未设置任何临时任务类型 - 请先让经理分配一个送货检查或温度检查模板。';

  @override
  String get whatKindOfThing => '您在做哪种类型的事情?';

  @override
  String get notesOptionalLabel => '备注(可选)';

  @override
  String get noteOptionalLabel => '备注(可选)';

  @override
  String get temperatureCelsiusLabel => '温度 (°C)';

  @override
  String get submitLabel => '提交';

  @override
  String get logReadingButton => '记录读数';

  @override
  String get loggedThanksMessage => '已记录,感谢您的记录。';

  @override
  String get logAnotherAdHocTask => '记录另一个临时任务';

  @override
  String get deliveryCheckLabel => '送货检查';

  @override
  String get temperatureCheckLabel => '温度检查';

  @override
  String get sessionSummaryTitle => '班次总结';

  @override
  String tasksCompletedCount(int count) {
    return '已完成任务: $count';
  }

  @override
  String get passedLabel => '通过';

  @override
  String get failedLabel => '未通过';

  @override
  String get triggersFailedTasks => '触发项 / 未通过的任务';

  @override
  String get yourReliability => '您的可靠性';

  @override
  String get reliabilityExplanation =>
      '过去30天 - 按时完成并记录的检查。已记录的未通过与已记录的通过计算方式相同:这仅衡量您是否以及何时进行了检查。';

  @override
  String completedPercentChip(int percent) {
    return '$percent% 已完成';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% 按时';
  }

  @override
  String get sendSummaryToManager => '将此总结发送给经理(可选)';

  @override
  String get noManagersSetUp => '尚未设置任何经理。';

  @override
  String get managerLabel => '经理';

  @override
  String get sentLabel => '已发送';

  @override
  String get sendLabel => '发送';

  @override
  String get leaveNoteForNextShift => '给下一班留言(可选)';

  @override
  String get handoverNoteLabel => '交接备注';

  @override
  String get doneLabel => '完成';
}
