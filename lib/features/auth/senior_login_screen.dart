import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import 'pin_entry.dart';

/// Leadership Access (Sprint 031) — the private entry point for
/// regional/executive accounts, reached via the discreet lock icon on the
/// main login screen (they're deliberately hidden from that shared,
/// walk-up staff list, per Sub-sprint 3 and reinforced in Sub-sprint 5's
/// Assign Tasks exclusion).
///
/// This is an INTERIM mechanism, not real secure sign-in — it reuses the
/// exact same PIN-hash check (`UserRepository.authenticate()`) every other
/// account already goes through, so the credential check itself is real,
/// but there's no email requirement, no 2FA, and identity-selection isn't
/// confidential (anyone who finds the icon sees the senior users' names,
/// even without their PIN). The on-screen banner says so explicitly —
/// deliberately not hidden in a tooltip, since this is the one thing on
/// this screen that must not be mistaken for finished security work. Real
/// email + 2FA sign-in needs the backend (parked, see PROJECT_BIBLE).
class SeniorLoginScreen extends ConsumerStatefulWidget {
  const SeniorLoginScreen({super.key});

  @override
  ConsumerState<SeniorLoginScreen> createState() => _SeniorLoginScreenState();
}

class _SeniorLoginScreenState extends ConsumerState<SeniorLoginScreen> {
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

  void backToList() {
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

    // This screen was reached via Navigator.push, so it sits on top of the
    // nav stack — setting currentUserProvider only changes what
    // MaterialApp.home *should* be, it doesn't retroactively unwind an
    // already-pushed route. Without popping back to root, the app would
    // silently stay on this now-inert screen instead of showing the
    // rebuilt home (TopScreen). Same pushed-screen-over-reactive-home
    // pattern as Sprint 013's end-of-session summary screen.
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffDirectoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leadership Access')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: selectedUser == null
              ? staffAsync.when(
                  data: (staff) =>
                      _LeadershipList(staff: staff, onSelect: selectUser),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text('Error loading staff: $err')),
                )
              : PinEntry(
                  user: selectedUser!,
                  controller: pinController,
                  error: error,
                  submitting: submitting,
                  onSubmit: submitPin,
                  onBack: backToList,
                ),
        ),
      ),
    );
  }
}

class _LeadershipList extends StatelessWidget {
  const _LeadershipList({required this.staff, required this.onSelect});

  final List<User> staff;
  final ValueChanged<User> onSelect;

  @override
  Widget build(BuildContext context) {
    final leadership = staff
        .where(
          (u) =>
              u.roleTier == RoleTier.regional ||
              u.roleTier == RoleTier.executive,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.caution,
          child: Text(
            'Regional & Director sign-in. Interim PIN access — secure '
            'email & 2FA sign-in coming soon.',
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: leadership.isEmpty
              ? const Center(
                  child: Text('No regional/director accounts set up yet.'),
                )
              : ListView.separated(
                  itemCount: leadership.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = leadership[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        user.name,
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(user.jobTitle),
                      onTap: () => onSelect(user),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
