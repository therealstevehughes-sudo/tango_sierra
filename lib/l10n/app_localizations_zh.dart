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

  @override
  String get supplierOptionalLabel => '供应商(可选)';

  @override
  String supplierWarningRecorded(String status) {
    return '该供应商标记为$status - 此次检查仍将被记录。';
  }

  @override
  String get reportProblemWithDelivery => '报告此次送货的问题';

  @override
  String get temperatureOnArrivalLabel => '到货温度 (°C,可选)';

  @override
  String get problemsTickAnyApply => '问题(勾选所有适用项)';

  @override
  String get shortDeliveryLabel => '短缺送货';

  @override
  String get damagedStockLabel => '货物损坏';

  @override
  String get lateDeliveryLabel => '送货延迟';

  @override
  String get qualityProblemLabel => '质量问题';

  @override
  String get outcomeLabel => '结果';

  @override
  String get acceptedLabel => '已接受';

  @override
  String get rejectedLabel => '已拒绝';

  @override
  String get partiallyAcceptedLabel => '部分接受';

  @override
  String get noCameraFound => '此设备上未找到摄像头。';

  @override
  String couldNotStartCamera(String error) {
    return '无法启动摄像头: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return '无法切换摄像头: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return '无法拍照: $error';
  }

  @override
  String get switchCameraTooltip => '切换摄像头';

  @override
  String get allTasksTitle => '所有任务';

  @override
  String get otherSegmentLabel => '其他';

  @override
  String get reorderTasksTitle => '重新排序任务';

  @override
  String get ungroupedLabel => '未分组';

  @override
  String get taskOrderSaved => '任务顺序已保存。';

  @override
  String couldNotSaveTaskOrder(String error) {
    return '无法保存任务顺序: $error';
  }

  @override
  String get noVenueSelectedReorder => '尚未选择场所。请先在场所详情中设置活动场所,再重新排序任务。';

  @override
  String get noActiveTasksToReorder => '尚无可重新排序的活动任务。请先分配任务,然后返回此处选择其顺序。';

  @override
  String get savingEllipsis => '正在保存…';

  @override
  String get saveOrderLabel => '保存顺序';

  @override
  String get moveUpTooltip => '上移';

  @override
  String get moveDownTooltip => '下移';

  @override
  String get accountRestrictedTitle => '账户受限';

  @override
  String get accountRestrictedBody =>
      '该机构的直接借记需要处理后才能保存新的检查。您的工作不会丢失 - 请告知经理或董事解决账单问题,然后重试。';

  @override
  String get okLabel => '确定';

  @override
  String get troubleshootingTitle => '故障排查';

  @override
  String get faqTitle => '常见问题';

  @override
  String get helpTitle => '帮助';

  @override
  String get couldntReachAssistant => '无法连接到助手';

  @override
  String get aiOfflineBody =>
      'AI助手目前无法访问 - 可能是您的网络连接问题,也可能是服务暂时中断。与此同时,下方的常见问题和故障排查涵盖了大多数常见疑问,或直接联系VenuRite。';

  @override
  String get askQuestionSubtitle => '用简单易懂的语言获取直接答案';

  @override
  String get faqSubtitle => '常见问题及解答';

  @override
  String get troubleshootingSubtitle => '遇到问题?从这里开始';

  @override
  String get contactVenuriteTitle => '联系VenuRite';

  @override
  String get contactVenuriteSubtitle => '直接联系我们';

  @override
  String get topTierViewTitle => '高层视图';

  @override
  String get everythingsDone => '全部完成。干得好。';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个任务未完成:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => '返回班次';

  @override
  String get finishShiftLabel => '结束班次';

  @override
  String get ehoAuditExportTitle => 'EHO/审计导出';

  @override
  String get ehoExportDescription => '为所选日期范围生成该场所合规记录的PDF。';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => '选择日期范围';

  @override
  String get tapToChooseDates => '点击选择开始和结束日期。';

  @override
  String get includeFullDetailedLog => '包含完整详细日志';

  @override
  String get fullLogSubtitle => '默认关闭 - 上方的摘要和例外情况是检查员实际审查的内容;此选项会添加每一项检查记录。';

  @override
  String get generateLabel => '生成';

  @override
  String get exportFailedTitle => '导出失败';

  @override
  String exportFailedBody(String error) {
    return '导出失败: $error';
  }

  @override
  String get exportCreatedTitle => '导出已创建';

  @override
  String savedToLabel(String path) {
    return '已保存至:\n$path';
  }

  @override
  String get dashboardTitle => '仪表盘';

  @override
  String get noVenueFound => '未找到场所。';

  @override
  String get allPermittedVenuesLast30Days => '所有授权场所 · 过去30天';

  @override
  String get last30Days => '过去30天';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项未通过(30天)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count 项逾期';
  }

  @override
  String get venuesSectionTitle => '场所';

  @override
  String get teamSectionTitle => '团队';

  @override
  String get noStaffAtVenue => '此场所尚无员工。';

  @override
  String get notEnoughDataYet => '数据不足';

  @override
  String get venueFallbackLabel => '场所';

  @override
  String get trendsTitle => '趋势';

  @override
  String get trendNeedsHistory => '趋势数据:需要至少4周的历史记录才能显示趋势。';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return '各场所每周完成率 · 最近$weeks周';
  }

  @override
  String get allVenuesCombined => '所有场所合计';

  @override
  String get noVenuesYet => '尚无场所。';

  @override
  String get otherVenuesLabel => '其他场所';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '已记录 $total 项检查中的 $completed 项';
  }

  @override
  String regionFallbackLabel(int id) {
    return '区域 #$id';
  }

  @override
  String get dashboardOverviewTitle => '仪表盘概览';

  @override
  String get gradedBarsOnTooltip => '按员工评分条:开启';

  @override
  String get gradedBarsOffTooltip => '按员工评分条:关闭';

  @override
  String get noBranchesToShow => '尚无分店可显示。';

  @override
  String get supervisorNoScopeMessage =>
      '您尚未被分配到某个部门或团队 - 请在此仪表盘显示任何内容之前,请经理在员工管理中进行设置。';

  @override
  String get individualViewNotice => '个人视图 - 用于风险监督,而非排行榜。';

  @override
  String get branchLabel => '分店';

  @override
  String get allBranchesLabel => '所有分店';

  @override
  String get yourSectionLabel => '您的部门';

  @override
  String get noneAssignedLabel => '未分配';

  @override
  String get areaLabel => '区域';

  @override
  String get allAreasLabel => '所有区域';

  @override
  String get employeeLabel => '员工';

  @override
  String get allEmployeesLabel => '所有员工';

  @override
  String get monthLabel => '月';

  @override
  String get weekLabel => '周';

  @override
  String get dayLabel => '日';

  @override
  String get noTaskActivityPeriod => '此期间没有任务活动。';

  @override
  String get taskOverviewTitle => '任务概览';

  @override
  String get incidentsTitle => '事件';

  @override
  String get noIncidentsPeriod => '此期间未报告任何事件。';

  @override
  String urgentCountLabel(int count) {
    return '$count 项紧急';
  }

  @override
  String get tapForDetailsHint => '点击颜色区块或图例项目查看详情';

  @override
  String get employeeFallbackLabel => '员工';

  @override
  String get plainLookupNotice => '这只是简单查询,不是评分 - 完成度颜色和问题标签在此绝不会针对个人评分。';

  @override
  String tasksCompletedCountParens(int count) {
    return '已完成任务($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return '已报告问题($count)';
  }

  @override
  String get doneOnTimeNoIssues => '按时完成(无问题)';

  @override
  String get doneOnTimeIssuesLogged => '按时完成(已记录问题)';

  @override
  String get doneEarlyLateNoIssues => '提前/延迟完成(无问题)';

  @override
  String get doneEarlyLateIssuesLogged => '提前/延迟完成(已记录问题)';

  @override
  String get notDoneLabel => '未完成';

  @override
  String get resolvedLabel => '已解决';

  @override
  String get unresolvedLabel => '未解决';

  @override
  String get escalatedLabel => '已升级';

  @override
  String get urgentLabel => '紧急';

  @override
  String get signInFailed => '登录失败';

  @override
  String get twoFactorRequiredNoFactor => '需要双重验证,但未找到验证方式。';

  @override
  String get couldNotVerifyCode => '无法验证该代码';

  @override
  String get codeDidntWork => '该代码无效。';

  @override
  String get accountNotLinkedToStaff => '此账户尚未关联员工档案 - 请联系管理员。';

  @override
  String get resetPasswordTitle => '重置密码';

  @override
  String get enterEmailForResetCode => '输入您的电子邮件,我们将发送重置密码的验证码。';

  @override
  String get emailLabel => '电子邮件';

  @override
  String get sendCodeButton => '发送验证码';

  @override
  String get backToSignIn => '返回登录';

  @override
  String sentCodeToEmail(String email) {
    return '我们已将验证码发送至 $email。请在下方输入验证码及新密码。';
  }

  @override
  String get sixDigitCodeLabel => '6位验证码';

  @override
  String get newPasswordLabel => '新密码';

  @override
  String get resetPasswordButton => '重置密码';

  @override
  String get twoFactorVerificationTitle => '双重验证';

  @override
  String get enterAuthenticatorCode => '输入身份验证器应用中的代码。';

  @override
  String get verifyButton => '验证';

  @override
  String get regionalDirectorSignIn => '区域经理与董事登录。';

  @override
  String get passwordLabel => '密码';

  @override
  String get signInButton => '登录';

  @override
  String get forgotPasswordLink => '忘记密码?';

  @override
  String get noBackendConfiguredPin => '此安装未配置后端 - 请像其他人一样使用PIN登录。';

  @override
  String get noDirectorRegionalAccounts => '此设备上没有董事/区域经理账户。';

  @override
  String get directorLabel => '董事';

  @override
  String get regionalManagerLabel => '区域经理';

  @override
  String get whoAreYouTitle => '你是谁?';

  @override
  String get searchLabel => '搜索';

  @override
  String get noMatchesLabel => '没有匹配结果';

  @override
  String get leadershipSectionTitle => '领导层';

  @override
  String get kitchenStaffSectionTitle => '厨房员工';

  @override
  String get chooseASectionTitle => '选择一个部门';

  @override
  String get unassignedLabel => '未分配';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get welcomeToVenurite => '欢迎使用 VenuRite';

  @override
  String get helpAssistantTooltip => '帮助与助手';

  @override
  String get couldntLoadScreen => '无法加载此页面。';

  @override
  String get retryLabel => '重试';

  @override
  String get microphonePermissionDenied => '麦克风权限被拒绝。';

  @override
  String get couldntRecordTryAgain => '无法录音 - 请重试。';

  @override
  String get couldntTranscribe => '无法转录该内容。';

  @override
  String get couldntReachTranscriptionService => '无法连接转录服务。';

  @override
  String get dictateANote => '口述备注';

  @override
  String get stoppingSoonTapToStop => '即将停止 - 点击立即停止';

  @override
  String get stopLabel => '停止';

  @override
  String get somethingWentWrong => '出了点问题';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条警报',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count 条未确认';
  }

  @override
  String get allAcknowledgedLabel => '全部已确认';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return '逾期 - 已 $minutes 分钟未确认';
  }

  @override
  String get escalatedToTopTier => '已升级至最高层';

  @override
  String get acknowledgeLabel => '确认';

  @override
  String get nothingInCategory => '此类别中没有内容。';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title($count)';
  }

  @override
  String get leadershipOverview => '领导层概览';

  @override
  String get photoEvidence => '照片证据';

  @override
  String get staffManagement => '员工管理';

  @override
  String get addTeamMember => '添加团队成员';

  @override
  String get shiftLog => '班次记录';

  @override
  String get branchTeamStructure => '分店团队结构';

  @override
  String get departmentManagement => '部门管理';

  @override
  String get rosterBoard => '排班表';

  @override
  String get claimShifts => '认领班次';

  @override
  String get requestADayOff => '申请休假';

  @override
  String get shiftFairnessReview => '排班公平性审查';

  @override
  String get venueDetails => '场所详情';

  @override
  String get assignTasks => '分配任务';

  @override
  String get taskPresets => '任务预设';

  @override
  String get supplierManagement => '供应商管理';

  @override
  String get serviceProviders => '服务提供商';

  @override
  String get notificationRules => '通知规则';

  @override
  String get documentCentre => '文档中心';

  @override
  String get setupWizard => '设置向导';

  @override
  String get organisationLabel => '组织';

  @override
  String get branchesLabel => '分店';

  @override
  String get homeLabel => '主页';

  @override
  String get oversightLabel => '监督';

  @override
  String get problemsAndIssues => '问题与事项';

  @override
  String get twoFactorAuthentication => '双重身份验证';

  @override
  String get backUpNow => '立即备份';

  @override
  String get dailySection => '日常';

  @override
  String get insightsSection => '洞察';

  @override
  String get peopleSection => '人员';

  @override
  String get rosterSection => '排班';

  @override
  String get venueSetupSection => '场所设置';

  @override
  String get companySection => '公司';

  @override
  String get accountSection => '账户';

  @override
  String get settingsLabel => '设置';

  @override
  String percentCompletedTodayChip(int percent) {
    return '今天已完成 $percent%';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count 名在职员工';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '今天 $count 项未通过',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => '经理视图';

  @override
  String showingScopeLabel(String scope) {
    return '显示: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      '您尚未被分配到某个部门或团队 - 请先让经理在员工管理中进行设置,再来查看此日志。';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条记录',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项未通过',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => '无未通过项';

  @override
  String get noCompletedTasksLoggedYet => '尚未记录任何已完成的任务';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 份班次总结',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount 通过 / $failCount 未通过';
  }

  @override
  String get workerFixedIt => '员工已修复';

  @override
  String get noCorrectiveActionRecorded => '未记录纠正措施';

  @override
  String get taskAlertFallback => '任务警报';

  @override
  String get loggedByLabel => '记录人';

  @override
  String get resultLabel => '结果';

  @override
  String get correctiveActionLabel => '纠正措施';

  @override
  String get noteLabel => '备注';

  @override
  String get closeLabel => '关闭';

  @override
  String get notCompletedSuffix => '- 未完成(班次已结束)';

  @override
  String get todayAllFails => '今天 + 所有未通过';

  @override
  String byAxisLabel(String axis) {
    return '按$axis';
  }

  @override
  String get nameAxisLabel => '姓名';

  @override
  String get dateAxisLabel => '日期';

  @override
  String get taskAxisLabel => '任务';

  @override
  String get filterLabel => '筛选';

  @override
  String get filterByLabel => '筛选方式:';

  @override
  String get clearFiltersLabel => '清除筛选';

  @override
  String get staffLabel => '员工';

  @override
  String get issueTypeComplaint => '投诉';

  @override
  String get issueTypeAccident => '事故';

  @override
  String get issueTypeIncident => '事件';

  @override
  String get issueTypeSupplyProblem => '供应问题';

  @override
  String get issueTypeVenueProblem => '场所问题';

  @override
  String get issueTypeOther => '其他';

  @override
  String get incorrectDeliveryLabel => '错误送货';

  @override
  String get driverProblemLabel => '司机问题';

  @override
  String get otherLabel => '其他';

  @override
  String get whatKindOfThingHappened => '发生了什么类型的事情?';

  @override
  String get whichOneLabel => '哪一个?';

  @override
  String get supplierLabel => '供应商';

  @override
  String get whatWasWrongWithDelivery => '送货出了什么问题?';

  @override
  String get receivedByLabel => '接收人';

  @override
  String get whichSectionOptional => '这是关于哪个部门的?(可选)';

  @override
  String get noSectionLabel => '无部门';

  @override
  String get teamOptionalLabel => '团队(可选)';

  @override
  String get noSpecificTeamLabel => '无特定团队';

  @override
  String get whatHappenedLabel => '发生了什么?';

  @override
  String get markAsUrgentLabel => '标记为紧急';

  @override
  String get markUrgentSubtitle => '无论未解决多长时间都需要立即处理';

  @override
  String get logItButton => '记录';

  @override
  String get escalateToTitle => '升级至';

  @override
  String get sendToLabel => '发送至';

  @override
  String get escalateButton => '升级';

  @override
  String get savedLabel => '已保存。';

  @override
  String remindedMessage(String name) {
    return '已提醒 $name。';
  }

  @override
  String get couldNotSendReminder => '无法发送提醒。';

  @override
  String get viewSupplierScorecard => '查看供应商记分卡';

  @override
  String raisedAtLabel(String date) {
    return '报告于 $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return '已升级至: $name';
  }

  @override
  String get historyLabel => '历史记录';

  @override
  String get addAnUpdateLabel => '添加更新';

  @override
  String get addProcessNoteButton => '添加处理备注';

  @override
  String get resolveButton => '解决';

  @override
  String get reopenThisIssueTitle => '重新打开此问题';

  @override
  String get whyReopenLabel => '为什么应该重新打开?';

  @override
  String get reopenButton => '重新打开';

  @override
  String sentToLabel(String name) {
    return '已发送至 $name';
  }

  @override
  String get remindButton => '提醒';

  @override
  String get phaseRaisedLabel => '已报告';

  @override
  String get phaseUpdateLabel => '更新';

  @override
  String get phaseOutcomeLabel => '结果';

  @override
  String get allLabel => '全部';

  @override
  String get dateRangeLabel => '日期范围';

  @override
  String get allDatesLabel => '所有日期';

  @override
  String get typeLabel => '类型';

  @override
  String get anyTypeLabel => '任何类型';

  @override
  String get anyoneLabel => '任何人';

  @override
  String staffFallback(String id) {
    return '员工 #$id';
  }

  @override
  String get nothingHereGoodSign => '这里什么都没有 - 这是个好现象。';

  @override
  String escalatedToNameLabel(String name) {
    return '已升级至 $name';
  }

  @override
  String get havenReportedYet => '您还没有报告任何内容。';

  @override
  String get failsAndProblemsRegisterTitle => '未通过与问题登记册';

  @override
  String get taskProblemsTab => '任务问题';

  @override
  String get issuesAndIncidentsTab => '问题与事件';

  @override
  String get failFilterLabel => '未通过';

  @override
  String get reportedFilterLabel => '已上报';

  @override
  String get notCompletedFilterLabel => '未完成';

  @override
  String get abandonedLabel => '已放弃';

  @override
  String get noActionTakenLabel => '未采取行动';

  @override
  String get markResolvedButton => '标记为已解决';

  @override
  String get openLabel => '开放';

  @override
  String get enableRosterQuestion => '启用排班功能?';

  @override
  String rosterQuoteBody(String amount) {
    return '根据您目前的员工人数,这将在您的每月直接借记中增加 $amount,从下次付款开始。';
  }

  @override
  String get confirmAndEnable => '确认并启用';

  @override
  String couldNotReachVenurite(String error) {
    return '无法连接到VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts => '让员工自行认领班次';

  @override
  String get rosterPitchBody =>
      '发布空缺班次,让员工自行认领 - 不再需要打电话或使用WhatsApp群组来找人顶班。员工也可以申请休假,您可以在同一个地方批准或拒绝。';

  @override
  String get pricingLabel => '定价';

  @override
  String get priceUnder10Staff => '每分店每月6英镑(员工少于10人)';

  @override
  String get price10PlusStaff => '每分店每月10英镑(员工10人及以上)';

  @override
  String get addedToDirectDebitNote => '将添加到您现有的直接借记中 - 无需新的付款方式。确认前您将看到确切金额。';

  @override
  String get enableRosterButton => '启用排班';

  @override
  String get availableShiftsTitle => '可选班次';

  @override
  String get shiftClaimingNotEnabled => '此场所尚未启用班次认领功能。请经理在设置中启用。';

  @override
  String couldNotLoadShifts(String error) {
    return '无法加载班次: $error';
  }

  @override
  String get noShiftsPostedYet => '尚未发布任何班次。';

  @override
  String get someoneElseClaimedShift => '抱歉,该班次刚被其他人认领了!';

  @override
  String get shiftClaimedMessage => '已认领班次。';

  @override
  String get cancelThisShiftTitle => '取消此班次?';

  @override
  String get cancelShiftLateWarning => '\n\n距离班次开始不足24小时 - 现在取消可能会影响您的可靠性记录。';

  @override
  String willNoLongerBeClaimed(String warning) {
    return '您将不再被认领此班次。$warning';
  }

  @override
  String get keepShiftButton => '保留班次';

  @override
  String get cancelShiftButton => '取消班次';

  @override
  String get yourShiftRecordReliable => '您的班次记录:可靠';

  @override
  String get yourShiftRecordNeedsImprovement => '您的班次记录:需要改进';

  @override
  String get yourShiftRecordBuilding => '您的班次记录:正在建立';

  @override
  String get claimLabel => '认领';

  @override
  String get claimedLabel => '已认领';

  @override
  String requestDateOffTitle(String date) {
    return '申请 $date 休假';
  }

  @override
  String get reasonOptionalLabel => '原因(可选)';

  @override
  String get submitRequestButton => '提交申请';

  @override
  String get offDayRequestsNotEnabled => '此场所尚未启用休假申请功能。请经理在设置中启用排班。';

  @override
  String get noOffDayRequestsYet => '您还没有任何休假申请。';

  @override
  String get yourRequestsLabel => '您的申请';

  @override
  String get approvedLabel => '已批准';

  @override
  String get deniedLabel => '已拒绝';

  @override
  String get pendingLabel => '待处理';

  @override
  String get postAShiftTitle => '发布班次';

  @override
  String get categoryHint => '类别(例如开店、关店)';

  @override
  String get pickStartTime => '选择开始时间';

  @override
  String get pickEndTime => '选择结束时间';

  @override
  String get postLabel => '发布';

  @override
  String get assignShiftToTitle => '将此班次分配给';

  @override
  String get unknownLabel => '未知';

  @override
  String get shiftsTabLabel => '班次';

  @override
  String get offDayRequestsTabLabel => '休假申请';

  @override
  String get rosterAddonNotEnabledManager =>
      '此场所尚未启用排班附加功能。请在设置 > 公司中启用以开始发布班次。';

  @override
  String get noShiftsTapPlus => '尚未发布任何班次。点击 + 添加一个。';

  @override
  String get openStatusLabel => '空缺';

  @override
  String get assignedStatusPrefix => '已分配';

  @override
  String get claimedStatusPrefix => '已认领';

  @override
  String get assignDirectlyLabel => '直接分配';

  @override
  String get removeClaimLabel => '移除认领';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return '无法加载休假申请: $error';
  }

  @override
  String get noOffDayRequests => '没有休假申请。';

  @override
  String get approveLabel => '批准';

  @override
  String get denyLabel => '拒绝';

  @override
  String get rosterAddonNotEnabledPlain => '此场所尚未启用排班附加功能。';

  @override
  String get noActiveStaffVenue => '此场所尚无在职员工。';

  @override
  String get last90DaysAlphabetical => '最近90天,按班次类别。按字母顺序排列 - 非排名。';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个班次',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => '此期间没有班次。';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      '这将在您的文档文件夹中创建本地数据库的完整副本。之后将其移动到U盘或云同步文件夹是单独的手动步骤。';

  @override
  String get backupNameOptional => '备份名称(可选)';

  @override
  String get backupNameHint => '例如:检查前备份';

  @override
  String get backupCreatedTitle => '备份已创建';

  @override
  String get tierTeamMember => '团队成员';

  @override
  String get tierSupervisor => '主管';

  @override
  String get tierManager => '经理';

  @override
  String get tierRegionalManager => '区域经理';

  @override
  String get tierDirector => '董事';

  @override
  String get anyTaskFail => '任何任务未通过';

  @override
  String taskFailLabel(String title) {
    return '未通过:$title';
  }

  @override
  String get taskFailTemplateStale => '任务未通过(模板已不是最新版本)';

  @override
  String get unknownUserLabel => '未知用户';

  @override
  String tierSuffixLabel(String tier) {
    return '$tier 级别';
  }

  @override
  String get unsetLabel => '未设置';

  @override
  String get pushChannelLabel => '推送';

  @override
  String get emailChannelLabel => '电子邮件';

  @override
  String get inAppOnlyLabel => '仅应用内';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return '应用内 + $channels';
  }

  @override
  String get tierColumnTeam => '团队';

  @override
  String get tierColumnSupv => '主管';

  @override
  String get tierColumnMgr => '经理';

  @override
  String get tierColumnRegnl => '区域';

  @override
  String get tierColumnDir => '董事';

  @override
  String get quickSetupSectionTitle => '快速设置:每任务未通过通知';

  @override
  String get tickTierNotified => '勾选当特定任务未通过时应通知哪个级别。';

  @override
  String get noTaskTemplatesSetUp => '尚未设置任何任务模板。';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return '通知:$target($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return '由 $tier 级别设置';
  }

  @override
  String get inactiveSuffixLabel => ' - 未启用';

  @override
  String get deactivateButton => '停用';

  @override
  String get reactivateButton => '重新启用';

  @override
  String get newRuleTitle => '新规则';

  @override
  String get triggerLabel => '触发条件';

  @override
  String get notifyLabel => '通知';

  @override
  String get wholeRoleTierOption => '整个角色级别';

  @override
  String get specificPersonOption => '特定人员';

  @override
  String get roleTierLabel => '角色级别';

  @override
  String get personLabel => '人员';

  @override
  String get pushLabel => '推送';

  @override
  String get rulesInAppNotice => '规则目前仅在应用内显示;推送/电子邮件传送尚未连接到后端,将在以后的版本中添加。';

  @override
  String get saveRuleButton => '保存规则';

  @override
  String get addRuleButton => '添加规则';

  @override
  String get noNotificationRulesYet => '尚未设置任何通知规则。';

  @override
  String get stepYourAccount => '你的账户';

  @override
  String get stepCompanyDetails => '公司详情';

  @override
  String get stepOrgStructure => '组织架构';

  @override
  String get stepFirstVenue => '首个场所';

  @override
  String get stepStarterSetup => '你的初始设置';

  @override
  String get stepSubscription => '订阅';

  @override
  String get stepPayment => '付款';

  @override
  String get termsOfServiceTitle => '服务条款';

  @override
  String get companySignupGenericError =>
      '创建你的公司时出了点问题。请重试 - 如果问题持续发生,请联系 VenuRite。';

  @override
  String get directDebitStartError => '我们无法自动启动直接借记设置 - 登录后你可以随时在设置中完成此操作。';

  @override
  String get continueButton => '继续';

  @override
  String get creatingEllipsis => '创建中...';

  @override
  String get startFreeTrialButton => '开始免费试用';

  @override
  String get companyCreatedTitle => '公司已创建';

  @override
  String get adminAccountIntro =>
      '让我们设置你的账户。你将成为该公司在 VenuRite 上的管理员,进入后即可邀请你的团队。';

  @override
  String get firstNameLabel => '名字';

  @override
  String get lastNameLabel => '姓氏';

  @override
  String get passwordMinCharsHelper => '至少 8 个字符';

  @override
  String get companyDetailsIntro => '告诉我们关于你公司的信息。';

  @override
  String get tradingCompanyNameLabel => '商业/公司名称';

  @override
  String get legalCompanyNameLabel => '公司法定名称(可选)';

  @override
  String get legalCompanyNameHelper => '留空则使用上面的商业名称';

  @override
  String get countryLabel => '国家';

  @override
  String get registeredAddressLabel => '注册/营业地址(可选)';

  @override
  String get vatNumberLabel => '增值税/税号(如适用)';

  @override
  String get billingContactEmailLabel => '账单联系邮箱(可选)';

  @override
  String get structureIntro =>
      '这是 VenuRite 组织你公司的方式。你现在不需要设置任何东西 - 这只是为了让下一步更容易理解。';

  @override
  String get structureYourCompanyLabel => '你的公司';

  @override
  String get structureYourCompanySublabel => '一个整合账户和账单';

  @override
  String get structureRegionsLabel => '地区(可选)';

  @override
  String get structureRegionsSublabel => '按国家或区域对场所分组 - 如果不需要可跳过';

  @override
  String get structureVenuesLabel => '场所';

  @override
  String get structureVenuesSublabel => '今天一个场所,以后数百个 - 随时可以添加更多';

  @override
  String get structureStaffLabel => '员工';

  @override
  String get structureStaffSublabel => '每个场所的团队,场所建立后即可邀请';

  @override
  String get structureOutro => '接下来我们将设置你的首个场所 - 你可以在应用内稍后添加地区和更多场所。';

  @override
  String get wizardFirstVenueHeroTitle => '让我们添加你的首个场所';

  @override
  String get addMoreVenuesLaterText => '你可以稍后添加更多场所。';

  @override
  String get venueNameLabel => '场所名称';

  @override
  String get addressOptionalLabel => '地址(可选)';

  @override
  String get regionAreaOptionalLabel => '地区/区域(可选)';

  @override
  String get regionAreaHelper => '例如\"北京\" - 仅当你有(或将有)多个场所时才需要';

  @override
  String get venueTypeOptionalLabel => '场所类型(可选)';

  @override
  String get venueTypeHelper => '选择一个类型会为你展示一套现成的初始设置 - 涵盖你已知需要的任务和设备。';

  @override
  String get payoffSkippedText =>
      '你跳过了场所类型的选择,因此暂时没有初始设置可以展示 - 进入后你可以自行添加任务和设备。';

  @override
  String get payoffErrorText => '无法加载此场所类型的初始设置 - 进入后你可以自行添加任务和设备。';

  @override
  String get payoffHeroTitle => '这是你的合规套装,随时可用';

  @override
  String get equipmentSectionLabel => '设备';

  @override
  String get subscriptionBannerText => '一个公司账户,一份整合账单 - 按场所计费,绝不按人头计费。';

  @override
  String get subscriptionIntroText =>
      '你今天有多少个场所,包括总部(如果有的话)?你现在只会设置首个场所 - 其余的可以随时在应用内添加。';

  @override
  String get perBranchPriceLabel => '39英镑/场所/月';

  @override
  String get headOfficeIncludedLabel => '+ 1 个总部场所(4个以上场所时)';

  @override
  String get discountCodeHint => '有折扣码吗?你可以在设置直接借记时输入。';

  @override
  String get trialBannerText => '你正在开始 14 天免费试用 - 今天无需信用卡。';

  @override
  String get paymentStepIntro =>
      '我们会在试用期结束前,请你在应用内的设置中完成付款设置。现在不会产生任何费用 - 只需告诉我们你偏好的付款方式。';

  @override
  String get cardPaymentTitle => '银行卡支付(Stripe)';

  @override
  String get cardPaymentSubtitle => '借记卡/信用卡,按月或按年计费';

  @override
  String get directDebitTitle => '直接借记(GoCardless)';

  @override
  String get directDebitSubtitle => '银行对银行付款,无需银行卡';

  @override
  String get decideLaterButton => '稍后再决定';

  @override
  String get decideLaterSnackbar => '没问题 - 你可以随时在设置中完成此操作。';

  @override
  String get agreeToTermsPrefix => '我已阅读并同意';

  @override
  String get successActivatedBanner => '你的公司和首个场所已设置完成,你已登录。';

  @override
  String get successNotActivatedBanner => '你的公司和首个场所已设置完成。请使用你的邮箱和刚刚选择的密码登录。';

  @override
  String get directDebitSettingUp => '正在设置直接借记...';

  @override
  String get directDebitOpenedBrowser => '我们已打开你的浏览器以完成直接借记设置。';

  @override
  String get inviteYourTeamTitle => '邀请你的团队';

  @override
  String get inviteYourTeamSubtitle => '可选 - 添加当前正在当班的人员,或跳过并稍后在员工管理中完成。';

  @override
  String get jobTitleLabel => '职位';

  @override
  String get tierFieldLabel => '级别';

  @override
  String get addTeamMemberButton => '添加团队成员';

  @override
  String get goToDashboardButton => '前往仪表板';

  @override
  String get goToSignInButton => '前往登录';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - 第 $step 步,共 $total 步';
  }

  @override
  String billingContactEmailHelper(String email) {
    return '留空则使用 $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return '我们目前还没有针对 $venueType 的预设初始设置 - 进入后你可以自行添加任务和设备。';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '已为 $venueType 设置了 $sectionCount 个板块共 $totalTasks 项任务和 $equipmentCount 种设备类型。';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '已为 $venueType 设置了 $sectionCount 个板块共 $totalTasks 项任务。';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/月 总计(计费 $units 个场所)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN 码:$pin';
  }

  @override
  String get jobRoleChefCook => '厨师/主厨';

  @override
  String get jobRoleKitchenPorter => '厨房杂工';

  @override
  String get jobRoleFrontOfHouse => '前厅';

  @override
  String get jobRoleBar => '吧台';

  @override
  String get jobRoleManagement => '管理层';

  @override
  String get jobRoleEveryone => '所有人';

  @override
  String get jobRoleMaintenance => '维护';

  @override
  String get jobRoleHousekeeping => '客房清洁';

  @override
  String get jobRoleReception => '前台';

  @override
  String get jobRoleSecurity => '安保';

  @override
  String get segmentFoodSafety => '食品安全与温度控制';

  @override
  String get segmentAllergen => '过敏原管理';

  @override
  String get segmentPersonalHygienePpe => '个人卫生与防护装备';

  @override
  String get segmentRefrigerationColdStorage => '制冷与冷藏储存';

  @override
  String get segmentCookingLineEquipment => '烹饪线设备';

  @override
  String get segmentWashupDishwash => '洗碗区';

  @override
  String get segmentCleaningSanitation => '清洁与卫生';

  @override
  String get segmentCleaningChemicals => '清洁化学品与耗材';

  @override
  String get segmentDryAmbientStorage => '干货与常温储存';

  @override
  String get segmentDeliveriesGoodsIn => '送货与收货';

  @override
  String get segmentUtilitiesSafety => '设施与安全';

  @override
  String get segmentWastePestControl => '废物与虫害控制';

  @override
  String get segmentPreventiveMaintenance => '预防性维护(厨房设备)';

  @override
  String get segmentStockControl => '库存控制';

  @override
  String get segmentOpeningProcedures => '开店程序';

  @override
  String get segmentClosingProcedures => '关店程序';

  @override
  String get segmentServiceReadiness => '服务准备';

  @override
  String get segmentFrontOfHouse => '前厅/服务';

  @override
  String get segmentBarBeverage => '吧台与饮品';

  @override
  String get segmentHotelSpecific => '酒店专属';

  @override
  String get segmentManagementComplianceOversight => '管理与合规监督';

  @override
  String get segmentMaintenance => '维护';

  @override
  String get segmentHousekeeping => '客房清洁';

  @override
  String get segmentReception => '前台';

  @override
  String get segmentSecurity => '安保';

  @override
  String get freqDaily => '每天';

  @override
  String get freqWeekly => '每周';

  @override
  String get freqPerShift => '每班次';

  @override
  String get freqThreeXDaily => '每天3次';

  @override
  String get freqTwoXDaily => '每天2次';

  @override
  String get freqPerBatch => '每批次';

  @override
  String get freqPerDelivery => '每次送货';

  @override
  String get freqPerUse => '每次使用';

  @override
  String get freqPerService => '每次服务';

  @override
  String get freqTwoXPerService => '每次服务2次';

  @override
  String get freqEventBased => '按事件';

  @override
  String get freqAsNeeded => '按需';

  @override
  String get freqMonthly => '每月';

  @override
  String get freqCustom => '自定义';

  @override
  String get jobRoleFieldLabel => '工作角色';

  @override
  String get pinFieldLabel => 'PIN 码';

  @override
  String get addStaffMemberTitle => '添加员工';

  @override
  String get addLabel => '添加';

  @override
  String get assignTasksTitle => '分配任务';

  @override
  String get noActiveSiteFoundError => '未找到活动场所。';

  @override
  String get byPersonLabel => '按人员';

  @override
  String get byTaskLabel => '按任务';

  @override
  String get noEquipmentOfTypeSetUp => '此类型的设备尚未设置。';

  @override
  String get applyButton => '应用';

  @override
  String get assignToTitle => '分配给';

  @override
  String get noStaffMatchTiers => '没有员工符合这些任务适用的级别。';

  @override
  String get assignButton => '分配';

  @override
  String get showInstructionsTooltip => '显示说明';

  @override
  String get selectTasksToAssignLabel => '选择要分配的任务';

  @override
  String get taskPresetsSectionTitle => '任务预设组';

  @override
  String get showAllPresetsButton => '显示所有预设组';

  @override
  String get showTasksInGroupTooltip => '显示此组中的任务';

  @override
  String get applyToMultipleButton => '批量应用';

  @override
  String get addCustomTaskButton => '添加自定义任务';

  @override
  String get customTaskSectionTitle => '自定义任务';

  @override
  String get titleFieldLabel => '标题';

  @override
  String get departmentSectionLabel => '部门/板块';

  @override
  String get methodLabel => '方法';

  @override
  String get methodTick => '打勾';

  @override
  String get methodData => '数据';

  @override
  String get methodDataTick => '数据 + 打勾';

  @override
  String get methodTickPhoto => '打勾 + 照片';

  @override
  String get methodDataPhoto => '数据 + 照片';

  @override
  String get methodNote => '备注';

  @override
  String get methodDataNote => '数据 + 备注';

  @override
  String get methodNotePhoto => '备注 + 照片';

  @override
  String get methodTickNote => '打勾 + 备注';

  @override
  String get methodMulti => '多项';

  @override
  String get requiresPhotoLabel => '需要照片';

  @override
  String get requiresNotesLabel => '需要备注';

  @override
  String get minLimitLabel => '最小限值';

  @override
  String get maxLimitLabel => '最大限值';

  @override
  String get unitHintLabel => '单位(例如摄氏度)';

  @override
  String get equipmentTypeOptionalLabel => '设备类型(可选)';

  @override
  String get noneLabel => '无';

  @override
  String get priorityLabel => '优先级';

  @override
  String get priorityCritical => '紧急';

  @override
  String get priorityHigh => '高';

  @override
  String get priorityStandard => '标准';

  @override
  String get requiresCorrectiveActionLabel => '失败时需要纠正措施';

  @override
  String get fixInstructionsLabel => '纠正说明';

  @override
  String get customFieldsJsonLabel => '自定义字段(JSON,可选)';

  @override
  String get extraFieldsSectionTitle => '附加字段(可选)';

  @override
  String get removeTooltip => '移除';

  @override
  String get fieldLabelHint => '字段标签(例如订单号)';

  @override
  String get extraFieldTypeText => '文本';

  @override
  String get extraFieldTypeNumber => '数字';

  @override
  String get extraFieldTypeDate => '日期';

  @override
  String get addFieldTooltip => '添加字段';

  @override
  String get saveCustomTaskButton => '保存自定义任务';

  @override
  String get adHocLabel => '临时安排';

  @override
  String get timeAllocatedLabel => '已分配时间';

  @override
  String get frequencyPrefixLabel => '频率:';

  @override
  String get atATimeLabel => '在特定时间';

  @override
  String get fromStartOfShiftLabel => '从班次开始';

  @override
  String get fromClockInLabel => '从打卡开始';

  @override
  String get availableFromEllipsis => '开始时间…';

  @override
  String get untilEllipsis => '结束时间…';

  @override
  String assignTasksForStaffTitle(String name) {
    return '分配任务 - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return '将\"$name\"应用到哪一个?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return '\"$name\"的所有任务均已分配';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    return '已从\"$name\"添加 $count 项任务';
  }

  @override
  String applyPresetToTitle(String name) {
    return '将\"$name\"应用到';
  }

  @override
  String assignTasksCountLabel(int count) {
    return '将 $count 项任务分配给员工…';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return '已为 $staffCount 名员工添加 $count 项分配';
  }

  @override
  String presetSectionPrefix(String segment) {
    return '板块:$segment';
  }

  @override
  String taskCountLabel(int count) {
    return '$count 项任务';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return '显示所有角色(默认仅显示:$jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - 尚未为此设置设备';
  }

  @override
  String fromTimeLabel(String time) {
    return '从 $time';
  }

  @override
  String untilTimeLabel(String time) {
    return '至 $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return '已创建 $count 项分配$skippedNote。';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' (已跳过 $count 个 - 已分配或角色不匹配)';
  }
}
