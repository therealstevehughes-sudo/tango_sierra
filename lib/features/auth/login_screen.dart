import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Who are you?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: staff.length,
            itemBuilder: (context, index) {
              final user = staff[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => onSelect(user),
                  child: Text("${user.name} (${user.jobTitle})"),
                ),
              );
            },
          ),
        ),
      ],
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
          style: const TextStyle(fontSize: 22),
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
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
        ElevatedButton(
          onPressed: submitting ? null : onSubmit,
          child: const Text("LOGIN"),
        ),
        TextButton(onPressed: onBack, child: const Text("Back")),
      ],
    );
  }
}
