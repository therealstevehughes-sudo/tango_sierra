import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/pin_auth_outcome.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../onboarding/company_onboarding_wizard_screen.dart';
import 'pin_entry.dart';
import 'senior_login_screen.dart';

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
    final outcome = await repository.authenticate(
      userId: user.id,
      pin: pinController.text.trim(),
      useBackendAuth: ref.read(backendAuthEnabledProvider),
    );

    if (!mounted) return;

    switch (outcome) {
      case PinAuthSuccess(:final user, :final accessToken):
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(currentSessionTokenProvider.notifier).state = accessToken;
      case PinAuthIncorrect():
        setState(() {
          error = "Incorrect PIN";
          submitting = false;
        });
      case PinAuthLocked(:final lockedUntil):
        final minutesLeft =
            lockedUntil.difference(DateTime.now()).inMinutes + 1;
        setState(() {
          error = "Too many wrong attempts. Try again in $minutesLeft min.";
          submitting = false;
        });
      case PinAuthNotFound():
        setState(() {
          error = "Account not found";
          submitting = false;
        });
      case PinAuthError(:final message):
        setState(() {
          error = message;
          submitting = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffDirectoryProvider);
    // Branding (2026-09-13): pre-auth, so there's no site/branch context
    // yet — the app logo plus the default organisation's client branding
    // (logo/name) when a Director has set it. The branch name appears
    // post-login on tier-home instead.
    final defaultBranding = ref
        .watch(brandingConfigProvider)
        .maybeWhen(data: (config) => config, orElse: () => null);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Screen-level column: fills the full available height so the
          // staff list below keeps bounded height (it uses Expanded). The
          // header is a fixed-height top block; the content scroll area
          // takes the rest — same bounded-height contract the child had
          // as a direct ResponsiveContent child before branding.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BrandHeader(branding: defaultBranding),
              const SizedBox(height: 24),
              Expanded(
                child: selectedUser == null
                    ? staffAsync.when(
                        data: (staff) => staff.isEmpty
                            ? const _FreshInstallEntry()
                            : ResponsiveContent(
                                // Wider max so the staff grid has room for
                                // multiple columns; the grid itself decides
                                // column count from available width.
                                maxWidth: 960,
                                alignment: Alignment.topCenter,
                                child: _StaffList(
                                  staff: staff,
                                  onSelect: selectUser,
                                ),
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error loading staff: $err')),
                      )
                    : ResponsiveContent(
                        // PIN entry stays the familiar narrow centered
                        // width on every screen size (its own layout is a
                        // single column by design).
                        maxWidth: 480,
                        alignment: Alignment.center,
                        child: PinEntry(
                          user: selectedUser!,
                          controller: pinController,
                          error: error,
                          submitting: submitting,
                          onSubmit: submitPin,
                          onBack: backToStaffList,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phase C1b — what a fresh (real) install shows: no staff yet, so the
/// only ways forward are creating a company or, if you were invited,
/// signing in via Leadership Access. This is the effective "Sign in / Set
/// up a company" choice screen (decision #1) — no separate widget needed,
/// it's just what LoginScreen becomes when the staff list is empty.
class _FreshInstallEntry extends StatelessWidget {
  const _FreshInstallEntry();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveContent(
        maxWidth: 380,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to VenuRite',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Set up your company to get started, or sign in if you were '
              'invited.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CompanyOnboardingWizardScreen(),
                ),
              ),
              child: const Text('Set up a new company'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
              ),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffList extends StatefulWidget {
  const _StaffList({required this.staff, required this.onSelect});

  final List<User> staff;
  final ValueChanged<User> onSelect;

  @override
  State<_StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<_StaffList> {
  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() => query = searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Visual/UX pass, Sub-sprint 3: regional/executive accounts are
    // deliberately excluded from this shared, walk-up staff list — senior
    // tiers aren't meant to be visible/selectable on a shared store device.
    // Filtered here rather than in `staffDirectoryProvider` itself, since
    // that provider otherwise means "all active staff" and has no other
    // consumer today — conflating it with this screen's own login-visibility
    // rule would be a surprise for any future reuse. The search box below
    // filters this same already-excluded set, so a hidden-tier name can
    // never surface through a search match either. Their own way in is the
    // discreet lock icon below, which opens Leadership Access (Sprint 031)
    // — an interim PIN-only flow, not full secure sign-in (see that screen).
    final kitchenStaff = widget.staff
        .where((u) => u.roleTier == RoleTier.base)
        .toList();
    final supervisorsAndManagers = widget.staff
        .where(
          (u) =>
              u.roleTier == RoleTier.supervisor ||
              u.roleTier == RoleTier.venueManager,
        )
        .toList();

    final isSearching = query.isNotEmpty;
    final searchResults = isSearching
        ? [
            ...kitchenStaff,
            ...supervisorsAndManagers,
          ].where((u) => u.name.toLowerCase().contains(query)).toList()
        : const <User>[];

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              "Who are you?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isSearching
                  ? _buildSearchResults(searchResults)
                  : _buildGroupedList(kitchenStaff, supervisorsAndManagers),
            ),
          ],
        ),
        // Discreet entry point for regional/executive sign-in (Sprint 031)
        // — deliberately unlabeled (no visible text, just the glyph) and
        // muted so it doesn't read as an action worth noticing on a shared
        // store device. A tooltip is fine since tooltips don't surface on
        // touch anyway, which is exactly who this needs to be invisible to.
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.lock_outline, color: AppColors.muted),
            iconSize: 20,
            tooltip: 'Leadership Access',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedList(
    List<User> kitchenStaff,
    List<User> supervisorsAndManagers,
  ) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (kitchenStaff.isNotEmpty) ...[
          const SectionHeader(title: 'Kitchen Staff'),
          const SizedBox(height: 8),
          _sectionGrid(kitchenStaff),
          const SizedBox(height: 20),
        ],
        if (supervisorsAndManagers.isNotEmpty) ...[
          const SectionHeader(title: 'Supervisors & Managers'),
          const SizedBox(height: 8),
          _sectionGrid(supervisorsAndManagers),
        ],
      ],
    );
  }

  // One section's tiles, either as a compact single column (phone) or an
  // auto-adapting grid (2 columns at 600-959dp, 3 at 960dp+).
  Widget _sectionGrid(List<User> users) {
    if (!isCompactWidth(context)) {
      return GridView.builder(
        shrinkWrap: true, // inside the outer ListView — its own height
        physics: const NeverScrollableScrollPhysics(), // is its content
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          mainAxisExtent: 72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) => _StaffTile(
          user: users[index],
          onTap: () => widget.onSelect(users[index]),
        ),
      );
    }
    return Column(children: _tilesWithDividers(users));
  }

  Widget _buildSearchResults(List<User> results) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          'No matches',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    if (!isCompactWidth(context)) {
      return GridView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          mainAxisExtent: 72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) => _StaffTile(
          user: results[index],
          onTap: () => widget.onSelect(results[index]),
        ),
      );
    }
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) => _StaffTile(
        user: results[index],
        onTap: () => widget.onSelect(results[index]),
      ),
    );
  }

  List<Widget> _tilesWithDividers(List<User> users) {
    final tiles = <Widget>[];
    for (var i = 0; i < users.length; i++) {
      tiles.add(
        _StaffTile(user: users[i], onTap: () => widget.onSelect(users[i])),
      );
      if (i != users.length - 1) tiles.add(const Divider());
    }
    return tiles;
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
    // The teal initial-avatar restores the accent colour on the actual
    // tappable element after the plain grouped list read as undesigned.
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.tealTint,
        foregroundColor: AppColors.tealInk,
        child: Text(
          user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
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
