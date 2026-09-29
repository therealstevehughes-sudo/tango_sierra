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
}
