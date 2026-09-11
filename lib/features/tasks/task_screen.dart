import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/utils/unit_conversion.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/user_title.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import 'end_of_session_summary_screen.dart';
import 'task_controller.dart';
import 'task_model.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  late final TaskController controller;
  bool loading = true;
  // Fail-safe (Sprint 031, Sub-sprint C follow-up): true when this screen
  // was reached with no logged-in user — `controller` is never initialized
  // in that case. This is the guard for the *class* of bug the popUntil
  // fixes the *trigger* for: even if some future push path reaches this
  // screen with a null user, build() must never crash the whole app on it
  // (the old bare `ref.read(currentUserProvider)!` did exactly that) — it
  // fails safe back to the login route instead.
  bool _userMissing = false;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController correctiveNoteController =
      TextEditingController();

  String result = "PASS";
  String? selectedChoice;

  // Corrective-action redesign (Sprint 031, Sub-sprint 4): 'fixed' or
  // 'reported' — replaces the old single "completed" checkbox, which forced
  // a worker to tick something they often couldn't actually do themselves.
  String? correctiveActionOutcome;
  bool photoTaken = false;

  // Supplier register + traceability (Sprint 031, finalized beta build
  // order item 4, Sub-sprint B). Optional — never blocks submission (same
  // "never block the kitchen running" principle as the approval-status
  // warning below): a worker can't refuse a delivery already at the door.
  List<Supplier> suppliers = [];
  int? selectedSupplierId;

  String? error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    if (user == null) {
      // Fail safe rather than crash — see _userMissing's doc comment.
      // Bails out to the root route on the next frame; app.dart's reactive
      // routing already shows LoginScreen once currentUserProvider is null.
      _userMissing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      });
      return;
    }
    controller = TaskController(
      ref.read(taskSubmissionRepositoryProvider),
      ref.read(taskScheduleRepositoryProvider),
      ref.read(taskTemplateRepositoryProvider),
      ref.read(equipmentRepositoryProvider),
      user,
      ref.read(notificationRuleRepositoryProvider),
      ref.read(triggerNotificationRepositoryProvider),
      ref.read(userRepositoryProvider),
      ref.read(problemRegisterRepositoryProvider),
    );
    numberController.addListener(_onFormChanged);
    notesController.addListener(_onFormChanged);
    _load();
  }

  Future<void> _load() async {
    await controller.loadTasks();

    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      final allSuppliers = await ref
          .read(supplierRepositoryProvider)
          .getForSite(currentUser.siteId!);
      suppliers = allSuppliers.where((s) => s.active).toList();
    }

    if (!mounted) return;
    setState(() => loading = false);

    final handoverRepo = ref.read(shiftHandoverRepositoryProvider);
    final latestNote = currentUser?.siteId == null
      ? null
      : await handoverRepo.getLatestForSite(currentUser!.siteId!);
    if (!mounted || latestNote == null) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Handover Notes'),
        content: Text(latestNote.note),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_onFormChanged);
    notesController.removeListener(_onFormChanged);
    numberController.dispose();
    notesController.dispose();
    correctiveNoteController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  // Visual/UX pass, Sub-sprint 3: Log Out is now always visible in the app
  // bar on every state of this screen (previously only the empty-task
  // state had a way out at all) — a small, secondary-styled action so it
  // doesn't compete with SUBMIT as the screen's one primary action.
  //
  // Exit behaviour (Sprint 031, Sub-sprint B): this is the ONLY exit path
  // from this screen. Originally true because TaskScreen was always
  // MaterialApp.home, never pushed — no longer the case since the tier
  // home screen (Build Order item 5, Sub-sprint A) reaches this screen via
  // Navigator.push for supervisor+ tiers, which would otherwise add a real
  // back arrow bypassing this exact confirmation. Kept true on purpose:
  // every AppBar below sets `automaticallyImplyLeading: false` and the
  // Scaffold is wrapped in `PopScope(canPop: false)`, so Log out stays the
  // only way out rather than reopening this already-audited logic to a
  // second, unconfirmed exit path.
  // Navigation-consistency pass (Sprint 031): the standalone "Manager View"
  // eye icon that used to live here is gone — Oversight is now a
  // ManagementDrawer item (see build()'s drawer:), reachable the same way
  // from every non-base screen instead of a TaskScreen-only shortcut.
  List<Widget> _appBarActions() {
    return [
      TextButton.icon(
        onPressed: _confirmLogOut,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Log out'),
      ),
    ];
  }

  // Natural full completion (the last task submitted) already routes
  // through EndOfSessionSummaryScreen and logs out from there — this only
  // ever fires for an EARLY exit, while tasks remain.
  Future<void> _confirmLogOut() async {
    if (controller.hasRemainingTasks) {
      final leave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Leave before finishing?'),
          content: const Text(
            "Some checks aren't complete. This will be recorded. You can "
            "return and finish anytime this shift.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log Out'),
            ),
          ],
        ),
      );
      if (leave != true) return;

      await controller.logRemainingAsNotCompleted();
    }

    if (!mounted) return;
    // Pop to root before nulling currentUserProvider (Sprint 031, Sub-sprint
    // C follow-up) — this screen is reachable via Navigator.push since
    // Sub-sprint A, so without this a pushed TaskScreen stayed mounted
    // underneath after logout while MaterialApp.home reactively swapped to
    // LoginScreen. Same push-vs-reactive-home bug class already fixed for
    // SeniorLoginScreen's login flow, mirrored here for logout.
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(currentUserProvider.notifier).state = null;
  }

  bool get _displayInFahrenheit {
    final task = controller.getCurrentTask();
    final currentUser = ref.read(currentUserProvider);
    return task.unit == 'celsius' &&
        currentUser?.preferredTemperatureUnit == TemperatureUnit.fahrenheit;
  }

  String get _numericFieldLabel {
    final task = controller.getCurrentTask();
    if (task.unit == null) return "Enter value";
    final unitLabel = _displayInFahrenheit
        ? '°F'
        : (task.unit == 'celsius' ? '°C' : task.unit!);
    return "Enter value ($unitLabel)";
  }

  double? get _numberInTemplateUnit {
    final parsed = double.tryParse(numberController.text.trim());
    if (parsed == null) return null;
    return _displayInFahrenheit ? fahrenheitToCelsius(parsed) : parsed;
  }

  String? get _derivedResultFromNumber {
    final task = controller.getCurrentTask();
    if (!task.hasNumericRange) return null;
    final value = _numberInTemplateUnit;
    if (value == null) return null;
    final withinRange = value >= task.minLimit! && value <= task.maxLimit!;
    return withinRange ? "PASS" : "FAIL";
  }

  String get effectiveResult {
    final task = controller.getCurrentTask();
    if (task.hasNumericRange) {
      return _derivedResultFromNumber ?? "PASS";
    }
    return result;
  }

  // Flags, never blocks (Sprint 031, finalized beta build order item 4,
  // Sub-sprint B) — a worker can't refuse a delivery already at the door,
  // so an unapproved supplier is surfaced for manager visibility, not
  // gated behind it.
  String? get _selectedSupplierWarning {
    if (selectedSupplierId == null) return null;
    Supplier? selected;
    for (final s in suppliers) {
      if (s.id == selectedSupplierId) {
        selected = s;
        break;
      }
    }
    if (selected == null || selected.approvalStatus == SupplierApprovalStatus.approved) {
      return null;
    }
    return 'This supplier is marked '
        '${supplierApprovalStatusLabel(selected.approvalStatus)} — the '
        'check will still be recorded.';
  }

  String? get _rangeWarning {
    final task = controller.getCurrentTask();
    if (!task.hasNumericRange) return null;
    if (_derivedResultFromNumber != "FAIL") return null;
    return task.fixInstructions ?? "Reading is outside the safe range.";
  }

  bool get canSubmit {
    final task = controller.getCurrentTask();

    // Belt-and-braces: the locked branch of build() returns an entirely
    // separate Scaffold with no SUBMIT button reachable at all, but this
    // stays as a safety net against a future refactor merging the paths.
    if (task.isLocked) return false;
    if (task.hasNumericRange && _numberInTemplateUnit == null) {
      return false;
    }
    if (task.hasChoice && selectedChoice == null) {
      return false;
    }
    if (task.requiresNotes && notesController.text.trim().isEmpty) {
      return false;
    }
    if (task.requiresPhoto && !photoTaken) {
      return false;
    }
    if (task.requiresCorrectiveActionOnFail &&
        effectiveResult == "FAIL" &&
        correctiveActionOutcome == null) {
      return false;
    }

    return true;
  }

  Future<void> validateAndSubmit() async {
    final task = controller.getCurrentTask();

    setState(() {
      error = null;
    });

    if (task.hasNumericRange && _numberInTemplateUnit == null) {
      setState(() => error = "A valid numeric value is required");
      return;
    }

    if (task.hasChoice && selectedChoice == null) {
      setState(() => error = "Please select an option");
      return;
    }

    if (task.requiresNotes && notesController.text.trim().isEmpty) {
      setState(() => error = "Notes required");
      return;
    }

    if (task.requiresPhoto && !photoTaken) {
      setState(() => error = "Photo required");
      return;
    }

    if (task.requiresCorrectiveActionOnFail &&
        effectiveResult == "FAIL" &&
        correctiveActionOutcome == null) {
      setState(() => error = "Choose how the corrective action was handled");
      return;
    }

    await submitTask();
  }

  Future<void> submitTask() async {
    final task = controller.getCurrentTask();
    final numericValue = _numberInTemplateUnit;

    await controller.logTaskSubmission(
      task: task,
      status: effectiveResult,
      numericValue: numericValue?.toString(),
      photoAttached: photoTaken,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      customFieldValuesJson: selectedChoice == null
          ? null
          : jsonEncode({'selected': selectedChoice}),
      correctiveActionOutcome: correctiveActionOutcome,
      correctiveActionNote: correctiveNoteController.text.trim().isEmpty
          ? null
          : correctiveNoteController.text.trim(),
      supplierId: selectedSupplierId,
    );

    if (!mounted) return;

    final hasNext = controller.nextTask();

    if (hasNext) {
      setState(() {
        numberController.clear();
        notesController.clear();
        correctiveNoteController.clear();
        result = "PASS";
        selectedChoice = null;
        correctiveActionOutcome = null;
        photoTaken = false;
        selectedSupplierId = null;
        error = null;
      });
    } else {
      final stats = await controller.buildSessionStats();
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EndOfSessionSummaryScreen(stats: stats),
        ),
      );

      if (!mounted) return;

      // Same pop-before-null fix as _confirmLogOut — this auto-logout on
      // full session completion is reachable via this pushed TaskScreen
      // too, since Sub-sprint A.
      Navigator.of(context).popUntil((route) => route.isFirst);
      ref.read(currentUserProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userMissing) {
      // `controller` was never initialized — see _userMissing's doc
      // comment. Nothing below this may touch `controller`.
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUser = ref.watch(currentUserProvider);
    // Navigation-consistency pass (Sprint 031): the drawer is base-tier's
    // one deliberate exception — a Kitchen Porter still just sees tasks +
    // Log out, no menu, per the Staff Task Screen Rule's minimalism.
    final drawer = currentUser != null && currentUser.roleTier != RoleTier.base
        ? ManagementDrawer(title: 'My Tasks', onLogout: _confirmLogOut)
        : null;
    // automaticallyImplyLeading: false (below, kept from Sub-sprint A's
    // back-arrow suppression) also hides the drawer's own auto-hamburger,
    // so it needs an explicit leading button whenever a drawer exists.
    final drawerLeading = drawer == null
        ? null
        : Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          );

    if (!controller.hasTasks) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: drawerLeading,
            title: currentUser != null
                ? UserTitle(user: currentUser)
                : const Text("Task"),
            actions: _appBarActions(),
          ),
          drawer: drawer,
          body: const Center(child: Text("No tasks assigned yet.")),
        ),
      );
    }

    final task = controller.getCurrentTask();

    // Time-windowed tasks (Sprint 031, Sub-sprint C): an entirely separate,
    // simplified Scaffold — not a conditional branch woven into the full
    // input/PASS-FAIL/corrective-action tree below, which is unreachable
    // while locked anyway. Visible, never hidden (same principle as
    // overdue/FAILs), but not actionable.
    if (task.isLocked) {
      return _buildLockedScaffold(context, task, currentUser, drawer, drawerLeading);
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: drawerLeading,
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text("Task"),
        actions: _appBarActions(),
      ),
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Corrective-action redesign (Sprint 031, Sub-sprint 4): the body
        // was never wrapped in a scroll view — fine when the corrective-
        // action block was one badge + one line + one checkbox, but the
        // new prominent fixInstructions card + two-path row is taller, and
        // on a shorter window (or a long fixInstructions string) the fixed
        // Column overflowed at the bottom. SingleChildScrollView fixes it;
        // the Spacer-pinned-to-bottom SUBMIT button is gone with it — it
        // now sits naturally after the last content block instead, same
        // pattern already used on the end-of-session summary screen.
        //
        // Responsive foundation: wrapped in ResponsiveContent (wider than
        // the 480 default — this screen's two-button PASS/FAIL row and
        // fix-instructions card want more breathing room than a plain
        // list/form does) so the form doesn't stretch edge-to-edge on a
        // tablet-landscape or desktop window. The scroll view itself
        // already protects narrow phone widths from overflowing.
        child: ResponsiveContent(
          maxWidth: 560,
          child: SingleChildScrollView(
          child: Column(
            children: [
              // Visual/UX pass, Sub-sprint 3: task title + inputs grouped in
              // one AppCard (Layout Rule's "consistent card structure"),
              // scoped narrowly to the content itself — PASS/FAIL, warnings,
              // and SUBMIT stay outside as the screen's action zone.
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskTitleHeader(task: task),
                    if (task.isOverdue) ...[
                      const SizedBox(height: 8),
                      StatusBadge(
                        kind: StatusKind.overdue,
                        label: task.overdueSince == null
                            ? 'Overdue'
                            : 'Overdue since ${formatDate(task.overdueSince!)}',
                      ),
                    ],
                    if (task.guidanceText != null &&
                        task.guidanceText!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      AppBanner(
                        kind: BannerKind.info,
                        child: Text(task.guidanceText!),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (task.hasNumericRange)
                      TextField(
                        controller: numberController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: _numericFieldLabel,
                        ),
                      ),
                    if (task.hasNumericRange && _numberInTemplateUnit != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: StatusBadge(
                          kind: _derivedResultFromNumber == "PASS"
                              ? StatusKind.pass
                              : StatusKind.critical,
                          label: _derivedResultFromNumber == "PASS"
                              ? "Within range — PASS"
                              : "Outside range — FAIL",
                        ),
                      ),
                    if (task.hasChoice)
                      DropdownButtonFormField<String>(
                        initialValue: selectedChoice,
                        decoration: const InputDecoration(
                          labelText: "Select option",
                        ),
                        items: task.choiceOptions!
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedChoice = value);
                        },
                      ),
                    if (task.requiresNotes)
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(labelText: "Notes"),
                      ),
                    if (task.requiresPhoto)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => photoTaken = true);
                          },
                          child: Text(photoTaken ? "Photo Added" : "Add Photo"),
                        ),
                      ),
                    if (task.requiresSupplierSelection) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: selectedSupplierId,
                        decoration: const InputDecoration(
                          labelText: 'Supplier (optional)',
                        ),
                        items: suppliers
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedSupplierId = value);
                        },
                      ),
                      if (_selectedSupplierWarning != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: AppBanner(
                            kind: BannerKind.caution,
                            child: Text(_selectedSupplierWarning!),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // PASS/FAIL as an equal-width segmented pair, not two competing
              // buttons — large touch targets for wet hands, and colour is
              // never the only signal (icon + word always accompany it).
              if (!task.hasNumericRange)
                Row(
                  children: [
                    Expanded(
                      child: _ResultOption(
                        label: 'PASS',
                        icon: Icons.check_circle_outline,
                        color: AppColors.pass,
                        bgColor: AppColors.passBg,
                        selected: result == 'PASS',
                        onTap: () => setState(() => result = 'PASS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResultOption(
                        label: 'FAIL',
                        icon: Icons.cancel_outlined,
                        color: AppColors.critical,
                        bgColor: AppColors.criticalBg,
                        selected: result == 'FAIL',
                        onTap: () => setState(() => result = 'FAIL'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (_rangeWarning != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_rangeWarning!, textAlign: TextAlign.center),
                ),
              // Corrective-action redesign (Sprint 031, Sub-sprint 4): fix
              // instructions promoted to a prominent, unmissable card (not
              // fine print), and the old single "completed" checkbox —
              // which blocked a worker behind something they often couldn't
              // actually do themselves — replaced with two recorded paths.
              // Neither is a silent skip; SUBMIT still requires picking one.
              if (task.requiresCorrectiveActionOnFail &&
                  effectiveResult == "FAIL")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const StatusBadge(
                      kind: StatusKind.critical,
                      label: 'Corrective action required',
                    ),
                    if (task.fixInstructions != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.criticalBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.critical),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Here's what to do:",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: AppColors.critical),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.fixInstructions!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ResultOption(
                            label: 'I fixed it',
                            icon: Icons.build_circle_outlined,
                            color: AppColors.pass,
                            bgColor: AppColors.passBg,
                            selected: correctiveActionOutcome == 'fixed',
                            onTap: () => setState(
                              () => correctiveActionOutcome = 'fixed',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ResultOption(
                            label: 'Reported to manager',
                            icon: Icons.campaign_outlined,
                            color: AppColors.teal,
                            bgColor: AppColors.tealTint,
                            selected: correctiveActionOutcome == 'reported',
                            onTap: () => setState(
                              () => correctiveActionOutcome = 'reported',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (correctiveActionOutcome == 'fixed') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: correctiveNoteController,
                        decoration: const InputDecoration(
                          labelText: 'What did you do? (optional)',
                        ),
                      ),
                    ],
                    if (correctiveActionOutcome == 'reported') ...[
                      const SizedBox(height: 12),
                      Text(
                        'Your manager will be notified.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: "SUBMIT",
                  icon: Icons.check,
                  onPressed: canSubmit ? validateAndSubmit : null,
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }

  // Time-windowed tasks (Sprint 031, Sub-sprint C). HONEST LIMIT: enforced
  // against the device clock (DateTime.now(), via ResolvedTask.isLocked),
  // fakeable until a backend provides trusted server time — raises the
  // bar against casual cheating, not tamper-proof.
  Widget _buildLockedScaffold(
    BuildContext context,
    ResolvedTask task,
    User? currentUser,
    Widget? drawer,
    Widget? drawerLeading,
  ) {
    final start = task.windowStartMinutes!;
    final startTime = TimeOfDay(hour: start ~/ 60, minute: start % 60);

    return PopScope(
      canPop: false,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: drawerLeading,
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text("Task"),
        actions: _appBarActions(),
      ),
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Responsive foundation: same treatment as the main task body above.
        child: ResponsiveContent(
          maxWidth: 560,
          child: SingleChildScrollView(
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskTitleHeader(task: task),
                    // A task can be both overdue (an earlier period was
                    // missed) and locked (today's window hasn't opened
                    // yet) at the same time — shown here too rather than
                    // hidden, same "never silently disappear" principle.
                    if (task.isOverdue) ...[
                      const SizedBox(height: 8),
                      StatusBadge(
                        kind: StatusKind.overdue,
                        label: task.overdueSince == null
                            ? 'Overdue'
                            : 'Overdue since ${formatDate(task.overdueSince!)}',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppBanner(
                kind: BannerKind.caution,
                child: Text('Available from ${startTime.format(context)}'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: 'Skip — comes back later',
                  icon: Icons.skip_next,
                  onPressed: () => setState(() => controller.skipLockedTask()),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }
}

// Instance-name prominence (2026-09-06) — when a task is tied to a specific
// piece of equipment, that instance's name leads as its own bold, accent-
// coloured line above the task title, rather than trailing indistinctly
// inside one plain string. Compliance-critical: with 2+ of the same
// equipment type at a venue, this is the one piece of text that tells a
// worker which physical unit they're looking at.
class _TaskTitleHeader extends StatelessWidget {
  const _TaskTitleHeader({required this.task});

  final ResolvedTask task;

  @override
  Widget build(BuildContext context) {
    final instanceName = task.equipmentInstanceName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (instanceName != null) ...[
          Text(
            instanceName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.teal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

/// One half of the PASS/FAIL segmented pair — large touch target, and
/// colour is never the only signal: icon + word are always present, even
/// unselected (muted, not just absent), per DESIGN_SYSTEM_LOCK's
/// Accessibility Rule.
class _ResultOption extends StatelessWidget {
  const _ResultOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? bgColor : AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : AppColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? color : AppColors.muted, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              // Responsive foundation: on a narrow phone, half-width labels
              // like "Reported to manager" can wrap to two lines — centered
              // so that reads as intentional rather than accidentally
              // left-aligned within a centered icon column.
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? color : AppColors.muted,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
