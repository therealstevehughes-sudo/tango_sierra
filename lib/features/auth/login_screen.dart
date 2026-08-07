import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  User? selectedUser;
  final TextEditingController pinController = TextEditingController();
  String? error;
  bool submitting = false;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  void selectUser(User user) {
    setState(() {
      selectedUser = user;
      pinController.clear();
      error = null;
    });
  }

  void backToStaffList() {
    setState(() {
      selectedUser = null;
      pinController.clear();
      error = null;
    });
  }

  Future<void> submitPin() async {
    final user = selectedUser;
    if (user == null) return;

    setState(() {
      error = null;
      submitting = true;
    });

    final repository = ref.read(userRepositoryProvider);
    final authenticated = await repository.authenticate(
      userId: user.id,
      pin: pinController.text.trim(),
    );

    if (!mounted) return;

    if (authenticated == null) {
      setState(() {
        error = "Incorrect PIN";
        submitting = false;
      });
      return;
    }

    ref.read(currentUserProvider.notifier).state = authenticated;
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffDirectoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: selectedUser == null
              ? staffAsync.when(
                  data: (staff) =>
                      _StaffList(staff: staff, onSelect: selectUser),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text('Error loading staff: $err')),
                )
              : _PinEntry(
                  user: selectedUser!,
                  controller: pinController,
                  error: error,
                  submitting: submitting,
                  onSubmit: submitPin,
                  onBack: backToStaffList,
                ),
        ),
      ),
    );
  }
}

class _StaffList extends StatelessWidget {
  const _StaffList({required this.staff, required this.onSelect});

  final List<User> staff;
  final ValueChanged<User> onSelect;

  @override
  Widget build(BuildContext context) {
    // Visual/UX pass, Sub-sprint 3: regional/executive accounts are
    // deliberately excluded from this shared, walk-up staff list — senior
    // tiers aren't meant to be visible/selectable on a shared store device.
    // They currently have no other way to log in from this screen; that's
    // an accepted gap until a separate private-auth mechanism exists, not
    // a bug. Filtered here rather than in `staffDirectoryProvider` itself,
    // since that provider otherwise means "all active staff" and has no
    // other consumer today — conflating it with this screen's own
    // login-visibility rule would be a surprise for any future reuse.
    final kitchenStaff = staff
        .where((u) => u.roleTier == RoleTier.base)
        .toList();
    final supervisorsAndManagers = staff
        .where(
          (u) =>
              u.roleTier == RoleTier.supervisor ||
              u.roleTier == RoleTier.venueManager,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          "Who are you?",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              if (kitchenStaff.isNotEmpty) ...[
                const SectionHeader(title: 'Kitchen Staff'),
                ...kitchenStaff.map(
                  (user) => _StaffTile(user: user, onTap: () => onSelect(user)),
                ),
                const SizedBox(height: 16),
              ],
              if (supervisorsAndManagers.isNotEmpty) ...[
                const SectionHeader(title: 'Supervisors & Managers'),
                ...supervisorsAndManagers.map(
                  (user) => _StaffTile(user: user, onTap: () => onSelect(user)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile({required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Name prominent, job title smaller underneath — two separate Text
    // widgets, so the title can never wrap mid-word into the name's line.
    // `dense: true` is what actually makes this tighter than the old
    // 56dp+-tall button-per-person layout, for scanning a 30+ person roster.
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text(
        user.name,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(user.jobTitle),
    );
  }
}

class _PinEntry extends StatelessWidget {
  const _PinEntry({
    required this.user,
    required this.controller,
    required this.error,
    required this.submitting,
    required this.onSubmit,
    required this.onBack,
  });

  final User user;
  final TextEditingController controller;
  final String? error;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(labelText: "Enter PIN"),
        ),
        const SizedBox(height: 20),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StatusBadge(kind: StatusKind.critical, label: error!),
          ),
        PrimaryActionButton(
          label: "LOGIN",
          onPressed: submitting ? null : onSubmit,
        ),
        TextButton(onPressed: onBack, child: const Text("Back")),
      ],
    );
  }
}
