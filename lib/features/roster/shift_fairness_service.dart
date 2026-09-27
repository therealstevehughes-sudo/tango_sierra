import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/shift.dart';
import '../../shared/providers/auth_providers.dart' show userRepositoryProvider;
import '../../shared/providers/shift_providers.dart';
import '../../shared/repositories/shift_repository.dart';
import '../../shared/repositories/user_repository.dart';

// Shift fairness pattern review (R6, 2026-09-27) — mirrors this app's
// established anti-gaming convention exactly (see reliability_service.dart
// and dashboard_screen.dart's own doc comments): this is NEVER a ranked
// leaderboard. Every staff member is listed alphabetically, always — this
// exists to help a manager spot a DISTRIBUTION problem (e.g. "three people
// never get an opening shift"), not to compare individuals against each
// other. No numeric score is computed here at all, only per-category counts
// a manager reads as a bar, same visual language dashboard_screen.dart
// already uses for its own aggregate bars.
const _uncategorised = 'Uncategorised';

class StaffCategoryBreakdown {
  const StaffCategoryBreakdown({
    required this.userId,
    required this.userName,
    required this.countsByCategory,
  });

  final int userId;
  final String userName;
  // Category label -> kept-shift count in the lookback window. A person
  // with an empty map got nothing at all in the period — the exact case
  // this dashboard exists to surface.
  final Map<String, int> countsByCategory;

  int get total => countsByCategory.values.fold(0, (a, b) => a + b);
}

class SiteShiftFairnessSummary {
  const SiteShiftFairnessSummary({
    required this.categories,
    required this.staff,
  });

  // Every category label seen at this site in the window, sorted
  // alphabetically (Uncategorised last) — the fixed column set every
  // staff bar is measured against, so an empty category still reads as
  // "zero," not "not shown."
  final List<String> categories;
  // Alphabetical by name — never sorted by count. See file doc comment.
  final List<StaffCategoryBreakdown> staff;
}

class ShiftFairnessService {
  ShiftFairnessService(this._shiftRepository, this._userRepository);

  final ShiftRepository _shiftRepository;
  final UserRepository _userRepository;

  Future<SiteShiftFairnessSummary> computeForSite(
    int siteId, {
    Duration lookback = const Duration(days: 90),
  }) async {
    final since = DateTime.now().subtract(lookback);
    final shifts = await _shiftRepository.getForSite(siteId);
    final users = (await _userRepository.getForSite(
      siteId,
    )).where((u) => u.active).toList()..sort((a, b) => a.name.compareTo(b.name));

    final countsByUserId = <int, Map<String, int>>{
      for (final user in users) user.id: {},
    };
    final categorySet = <String>{};

    for (final shift in shifts) {
      final claimedBy = shift.claimedByUserId;
      if (claimedBy == null) continue;
      // Only kept shifts count toward the distribution — an open/cancelled
      // shift was never actually worked by anyone.
      if (shift.status != ShiftStatus.claimed &&
          shift.status != ShiftStatus.assigned &&
          shift.status != ShiftStatus.completed) {
        continue;
      }
      if (shift.startsAt.isBefore(since)) continue;

      final category = shift.category ?? _uncategorised;
      categorySet.add(category);
      final userCounts = countsByUserId.putIfAbsent(claimedBy, () => {});
      userCounts[category] = (userCounts[category] ?? 0) + 1;
    }

    final categories = categorySet.toList()..sort();
    if (categorySet.contains(_uncategorised)) {
      categories
        ..remove(_uncategorised)
        ..add(_uncategorised);
    }

    final staff = users
        .map(
          (user) => StaffCategoryBreakdown(
            userId: user.id,
            userName: user.name,
            countsByCategory: countsByUserId[user.id] ?? const {},
          ),
        )
        .toList();

    return SiteShiftFairnessSummary(categories: categories, staff: staff);
  }
}

final shiftFairnessServiceProvider = Provider<ShiftFairnessService>(
  (ref) => ShiftFairnessService(
    ref.watch(shiftRepositoryProvider),
    ref.watch(userRepositoryProvider),
  ),
);
