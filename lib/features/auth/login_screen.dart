import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/greeting.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_background.dart';
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
      body: Stack(
        children: [
          // Visual pass follow-up (2026-09-22, direct user request after
          // trying it on the two hub screens) — same faint (10%) section
          // background, no jobRole context yet at this pre-login screen
          // so it just defaults to the kitchen photo.
          const SectionBackground(jobRole: null),
          SafeArea(
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
                  // floating text/logo directly on the background. Padding
                  // tightened (2026-09-17 follow-up) — the branding block was
                  // still too prominent relative to the staff cards below.
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        BrandHeader(branding: defaultBranding),
                        // Discreet entry point for regional/executive sign-in
                        // (Sprint 031) — deliberately unlabeled and muted so it
                        // doesn't read as an action worth noticing on a shared
                        // store device. Moved here (2026-09-17 follow-up) from
                        // its own row above the search card, to the right of
                        // the branding — there's real spare room in this card's
                        // corner, and removing its own row lets everything
                        // below move up.
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.muted,
                            ),
                            iconSize: 20,
                            tooltip: 'Leadership Access',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SeniorLoginScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
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
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, stack) =>
                                err is DeviceNotPairedException
                                ? const _DevicePairingPrompt()
                                : Center(
                                    child: Text('Error loading staff: $err'),
                                  ),
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
                        child: const Text(
                          'Not on this list? Sign in another way',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sprint 042 (First-Open Experience, 2026-09-21) — replaces the old
/// plain "Welcome to VenuRite" screen. A brand new device's very first
/// impression should re-affirm the pitch, not just name the product —
/// per the user's own spec: one value screen (not a carousel), three
/// short proof points, one "Get started" button leading to the fork
/// below. Shares nothing with `_SignInAnotherWayScreen` (reached via the
/// persistent link on a device that already has staff, Sprint 034
/// decision #4) — that path skips straight to `_ForkScreen`, since a
/// returning user reaching it via that link has already seen the pitch.
class _FreshInstallEntry extends StatelessWidget {
  const _FreshInstallEntry();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ResponsiveContent(
          maxWidth: 440,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visual pass (2026-09-22) — a flat headline + plain icon
              // rows read as sterile per direct user feedback. This hero
              // photo + Fraunces headline card is the same treatment used
              // on the splash screen and the sign-up wizard, so a fresh
              // install's first three screens now feel like one considered
              // moment instead of a plain form.
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/kitchen.png',
                        fit: BoxFit.cover,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.tealInk.withValues(alpha: 0.15),
                              AppColors.tealInk.withValues(alpha: 0.82),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Kitchen compliance, done right',
                            style: const TextStyle(
                              fontFamily: 'Fraunces',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 1.15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _ValuePoint(
                icon: Icons.verified_outlined,
                text:
                    'Always EHO-ready - real-time compliance, not a '
                    'once-a-year scramble',
              ),
              const SizedBox(height: 12),
              const _ValuePoint(
                icon: Icons.shield_outlined,
                text:
                    "Built so results can't be gamed - every check is "
                    'honest, every record stands up',
              ),
              const SizedBox(height: 12),
              const _ValuePoint(
                icon: Icons.picture_as_pdf_outlined,
                text:
                    'One-tap audit export - hand an inspector a real '
                    'record, instantly',
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const _ForkScreen()),
                ),
                child: const Text('Get started'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValuePoint extends StatelessWidget {
  const _ValuePoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.tealTint,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.teal, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

/// Sprint 042 — the 2-way split the user asked for, replacing the old
/// 3-equal-button `_AccountEntryOptions`: "Set up my business" (a buyer
/// starting fresh) vs. "My team already uses VenuRite" (staff joining an
/// existing company). "Contact VenuRite" and "Sign in" are both real,
/// necessary paths but not first-choice ones — demoted to small text
/// links underneath so they don't compete with the two primary buttons,
/// same demotion "Already have an account? Sign in" already had before
/// this pass.
class _ForkScreen extends StatelessWidget {
  const _ForkScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get started')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 380,
            alignment: Alignment.center,
            child: const _ForkContent(),
          ),
        ),
      ),
    );
  }
}

class _ForkContent extends StatelessWidget {
  const _ForkContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'How would you like to get started?',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Fraunces',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CompanyOnboardingWizardScreen(),
            ),
          ),
          child: const Text('Set up my business'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JoinCompanyScreen()),
          ),
          child: const Text('My team already uses VenuRite'),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            ),
            child: const Text('Already have an account? Sign in'),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactVenuRiteScreen()),
            ),
            child: const Text('Need help? Contact VenuRite'),
          ),
        ),
      ],
    );
  }
}

/// Sprint 034 decision #4 — the persistent entry point on a device that
/// already has walk-up staff (so the fork isn't only reachable when the
/// local staff list happens to be empty). Reached via a small,
/// always-visible link on the walk-up screen, not a disruptive
/// first-thing-shown replacement — the walk-up grid stays the primary,
/// zero-extra-tap experience for returning staff on a shared kitchen
/// tablet. Goes straight to the fork, skipping the value screen — a
/// returning device has already seen the pitch.
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
            child: const _ForkContent(),
          ),
        ),
      ),
    );
  }
}

/// Device pairing (2026-09-20) — shown in place of the walk-up staff grid
/// when this tablet hasn't yet been given its venue's setup code (backend
/// mode only; see `staffDirectoryProvider`'s doc comment for why the
/// roster genuinely can't load without it). Deliberately its own full-
/// screen state, not a small inline box on top of an empty list — a blank
/// staff grid reads as "broken," not "needs setup," to someone who has
/// never seen this before.
class _DevicePairingPrompt extends ConsumerStatefulWidget {
  const _DevicePairingPrompt();

  @override
  ConsumerState<_DevicePairingPrompt> createState() =>
      _DevicePairingPromptState();
}

class _DevicePairingPromptState extends ConsumerState<_DevicePairingPrompt> {
  final _controller = TextEditingController();
  String? _error;
  bool _submitting = false;
  int _failedAttempts = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await pairDevice(ref, code);
      // No further action needed — invalidating staffDirectoryProvider
      // inside pairDevice() re-triggers this same build with the roster
      // now loading successfully.
    } on DevicePairingException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
        _failedAttempts++;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not reach the server';
        _submitting = false;
        _failedAttempts++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveContent(
        maxWidth: 380,
        alignment: Alignment.center,
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.tablet_mac, size: 40, color: AppColors.muted),
              const SizedBox(height: 16),
              Text(
                "This tablet isn't set up yet",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "Ask a manager for this venue's setup code.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                enabled: !_submitting,
                onSubmitted: (_) => _connect(),
                decoration: InputDecoration(
                  labelText: 'Setup code',
                  errorText: _error,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submitting ? null : _connect,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Connect this tablet'),
              ),
              if (_failedAttempts >= 3) ...[
                const SizedBox(height: 16),
                Text(
                  'Still stuck? A manager can find this in '
                  'Settings → Venue Details.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ],
            ],
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
        // Login-screen warmth pass (2026-09-17), rebalanced (2026-09-17
        // follow-up) — this block was reading as the screen's main event
        // (a tall, generously padded card) when the staff cards below are
        // what people actually came here to tap. Kept the same card
        // styling (still warm, still bounded) but shrunk it to a slim,
        // secondary top element: tighter padding, a smaller heading style,
        // a denser search field, and a smaller gap to the staff list —
        // proportion fix only, nothing removed.
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                timeAwareGreeting(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 2),
              Text(
                "Who are you?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
