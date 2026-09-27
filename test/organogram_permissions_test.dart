// Organogram permission helpers (2026-09-27) -- canChangeTier/canDeactivate/
// canMoveDepartment are the real outrank rules behind both the branch
// organogram and the retrofitted Staff Management actions. Pure functions,
// easy to get subtly wrong (off-by-one on "at or above own rank"), so
// covered directly rather than only exercised indirectly through a screen.
import 'package:flutter_application_1/shared/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canChangeTier', () {
    test('blocks acting on a peer (same tier)', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.supervisor,
          targetTier: RoleTier.supervisor,
          newTier: RoleTier.base,
        ),
        isFalse,
      );
    });

    test('blocks acting on a superior', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.supervisor,
          targetTier: RoleTier.venueManager,
          newTier: RoleTier.base,
        ),
        isFalse,
      );
    });

    test('allows acting on a subordinate, demoting within own rank', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.supervisor,
          newTier: RoleTier.base,
        ),
        isTrue,
      );
    });

    test('blocks promoting a subordinate to the acting user\'s own rank', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.base,
          newTier: RoleTier.venueManager,
        ),
        isFalse,
      );
    });

    test('blocks promoting a subordinate above the acting user\'s own rank', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.base,
          newTier: RoleTier.regional,
        ),
        isFalse,
      );
    });

    test('allows promoting a subordinate to one rank below the acting user', () {
      expect(
        canChangeTier(
          actingTier: RoleTier.regional,
          targetTier: RoleTier.base,
          newTier: RoleTier.venueManager,
        ),
        isTrue,
      );
    });
  });

  group('canDeactivate', () {
    test('blocks deactivating a peer', () {
      expect(
        canDeactivate(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.venueManager,
        ),
        isFalse,
      );
    });

    test('blocks deactivating a superior', () {
      expect(
        canDeactivate(
          actingTier: RoleTier.base,
          targetTier: RoleTier.executive,
        ),
        isFalse,
      );
    });

    test('allows deactivating a subordinate', () {
      expect(
        canDeactivate(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.base,
        ),
        isTrue,
      );
    });
  });

  group('canMoveDepartment', () {
    test('allows acting on a peer (own rank included, unlike tier/deactivate)', () {
      expect(
        canMoveDepartment(
          actingTier: RoleTier.supervisor,
          targetTier: RoleTier.supervisor,
        ),
        isTrue,
      );
    });

    test('blocks acting on a superior', () {
      expect(
        canMoveDepartment(
          actingTier: RoleTier.base,
          targetTier: RoleTier.supervisor,
        ),
        isFalse,
      );
    });

    test('allows acting on a subordinate', () {
      expect(
        canMoveDepartment(
          actingTier: RoleTier.venueManager,
          targetTier: RoleTier.base,
        ),
        isTrue,
      );
    });
  });
}
