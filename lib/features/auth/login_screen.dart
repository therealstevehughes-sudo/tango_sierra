import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/greeting.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/pin_auth_outcome.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../onboarding/company_onboarding_wizard_screen.dart';
import '../onboarding/contact_venurite_screen.dart';
import '../onboarding/join_company_screen.dart';
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
              // Login-screen warmth pass (2026-09-17) — this card persists
              // through PIN entry too (it sits above the branch in this
              // Column, outside the staffAsync.when below), giving the
              // header a real visual boundary on the page instead of
              // floating text/logo directly on the background.
              AppCard(child: BrandHeader(branding: defaultBranding)),
              const SizedBox(height: 12),
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
              // Sprint 034 decision #4 — a persistent, always-visible way
              // into the 3-option account-entry screen (Create company /
              // Join company / Sign in) on a device that already has
              // walk-up staff, so it isn't only reachable when the local
              // staff list happens to be empty. Only shown alongside the
              // real staff grid (selectedUser == null, staff non-empty) —
              // it would just duplicate _FreshInstallEntry's own buttons
              // otherwise, and PIN entry has its own Back link already.
              if (selectedUser == null &&
                  staffAsync.maybeWhen(
                    data: (staff) => staff.isNotEmpty,
                    orElse: () => false,
                  ))
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _SignInAnotherWayScreen(),
                      ),
                    ),
                    child: const Text('Not on this list? Sign in another way'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phase C1b, redesigned 2026-09-14 (user's explicit first-launch spec) —
/// what a fresh (real) install shows: no staff yet, so the only ways
/// forward are the account-entry options below. Shares
/// `_AccountEntryOptions` with `_SignInAnotherWayScreen`, reached via the
/// persistent link on a device that already has staff (Sprint 034
/// decision #4 — added alongside the walk-up grid rather than replacing
/// its gating).
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
            const Center(child: VenuRiteMark()),
            const SizedBox(height: 24),
            Text(
              'Welcome to VenuRite',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 28),
            const _AccountEntryOptions(),
          ],
        ),
      ),
    );
  }
}

/// The first-launch account-entry actions, shared by `_FreshInstallEntry`
/// (a brand new device) and `_SignInAnotherWayScreen` (a device that
/// already has walk-up staff, reached via the persistent link). Three
/// equal-weight primary choices per the user's explicit spec, plus
/// "Sign in" demoted to a small secondary link underneath — for someone
/// who already has an account and is just opening the app on another
/// device, not someone joining or signing up fresh.
class _AccountEntryOptions extends StatelessWidget {
  const _AccountEntryOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CompanyOnboardingWizardScreen(),
            ),
          ),
          child: const Text('Sign up to VenuRite'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JoinCompanyScreen()),
          ),
          child: const Text('Join an existing company'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactVenuRiteScreen()),
          ),
          child: const Text('Contact VenuRite'),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            ),
            child: const Text('Already have an account? Sign in'),
          ),
        ),
      ],
    );
  }
}

/// Sprint 034 decision #4 — the persistent entry point on a device that
/// already has walk-up staff (so the 3-option screen isn't only reachable
/// when the local staff list happens to be empty). Reached via a small,
/// always-visible link on the walk-up screen, not a disruptive
/// first-thing-shown replacement — the walk-up grid stays the primary,
/// zero-extra-tap experience for returning staff on a shared kitchen
/// tablet.
class _SignInAnotherWayScreen extends StatelessWidget {
  const _SignInAnotherWayScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in another way')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 380,
            alignment: Alignment.center,
            child: const _AccountEntryOptions(),
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Discreet entry point for regional/executive sign-in (Sprint 031)
        // — deliberately unlabeled (no visible text, just the glyph) and
        // muted so it doesn't read as an action worth noticing on a shared
        // store device. A tooltip is fine since tooltips don't surface on
        // touch anyway, which is exactly who this needs to be invisible to.
        // Moved out of a Stack/Positioned (2026-09-17 warmth pass) — with
        // the greeting+heading+search now inside a bordered AppCard below,
        // a corner-Positioned icon would visually collide with the card's
        // own edge; a plain right-aligned row above the card keeps it just
        // as discreet with no overlap.
        Align(
          alignment: Alignment.topRight,
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
        // Login-screen warmth pass (2026-09-17) — greeting + heading +
        // search recomposed into one bounded card (was three loosely
        // spaced, uncontained pieces floating on the page background),
        // plus a small time-aware human touch above the question.
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                timeAwareGreeting(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 4),
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
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: isSearching
              ? _buildSearchResults(searchResults)
              : _buildGroupedList(kitchenStaff, supervisorsAndManagers),
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
          mainAxisExtent: 80,
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
          mainAxisExtent: 80,
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
    // Login-screen warmth pass (2026-09-17) — spacing, not a Divider: each
    // tile is now its own bordered card, so a line between them would just
    // double up on the tile's own border.
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
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
      if (i != users.length - 1) tiles.add(const SizedBox(height: 8));
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
    //
    // Login-screen warmth pass (2026-09-17) — wrapped in the app's warm
    // card visual language (white fill, soft warm border, rounded corners
    // — same DNA as AppCard) instead of a bare ListTile sitting directly
    // on the page, which read as a plain contact list. Not AppCard itself:
    // its page-level padding/margin defaults don't fit a compact grid
    // tile — this reuses the same tokens at a tighter scale.
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: ListTile(
            dense: true,
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
          ),
        ),
      ),
    );
  }
}
