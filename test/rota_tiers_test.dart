// Rota tiers (2026-10-17): who books shifts, supervisor-level shifts, and
// auto-assign filling supervisor places first.
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/roster/fair_auto_assign_service.dart';
import 'package:venurite/shared/models/shift.dart';
import 'package:venurite/shared/models/training_item.dart';
import 'package:venurite/shared/models/training_record.dart';
import 'package:venurite/shared/models/user.dart';

User _user(int id, RoleTier tier, {bool? books}) => User(
  id: id,
  name: 'Person $id',
  jobTitle: 'Team Member',
  roleTier: tier,
  booksShiftsSetting: books,
);

Shift _shift(int id, {String? minTier, int hour = 9}) => Shift(
  id: id,
  siteId: 1,
  // Separate days, so nobody is ever double-booked by accident.
  startsAt: DateTime(2026, 10, 5 + id % 20, hour),
  endsAt: DateTime(2026, 10, 5 + id % 20, hour + 8),
  status: ShiftStatus.open,
  createdByUserId: 1,
  createdAt: DateTime(2026, 1, 1),
  minTier: minTier,
);

List<TrainingRecord> _valid(int userId) => [
  for (final itemType in TrainingItemType.values)
    TrainingRecord(
      id: null,
      userId: userId,
      siteId: 1,
      itemType: itemType,
      completedAt: DateTime(2026, 1, 1),
      expiresAt: DateTime(2030, 1, 1),
      signedOffByUserId: 1,
      createdAt: DateTime(2026, 1, 1),
    ),
];

List<FairAssignProposal> _run(List<Shift> shifts, List<User> staff) =>
    computeFairAutoAssignProposals(
      candidateShifts: shifts,
      candidateStaff: staff,
      allExistingShiftsForSite: const [],
      offDayRequestsForSite: const [],
      trainingRecordsByUserId: {for (final u in staff) u.id: _valid(u.id)},
      siteCertAdditions: const [],
    );

void main() {
  test('default: staff and supervisors book shifts, managers do not', () {
    expect(_user(1, RoleTier.base).booksShifts, isTrue);
    expect(_user(1, RoleTier.supervisor).booksShifts, isTrue);
    expect(_user(1, RoleTier.venueManager).booksShifts, isFalse);
    expect(_user(1, RoleTier.executive).booksShifts, isFalse);
  });

  test("the manager's setting wins over the default", () {
    expect(_user(1, RoleTier.base, books: false).booksShifts, isFalse);
    expect(_user(1, RoleTier.venueManager, books: true).booksShifts, isTrue);
  });

  test('a supervisor shift needs a supervisor or above', () {
    final sup = _shift(1, minTier: 'supervisor');
    expect(tierCanWorkShift(RoleTier.base, sup), isFalse);
    expect(tierCanWorkShift(RoleTier.supervisor, sup), isTrue);
    expect(tierCanWorkShift(RoleTier.venueManager, sup), isTrue);
    expect(tierCanWorkShift(RoleTier.base, _shift(2)), isTrue);
  });

  test('auto-assign never gives a supervisor shift to base staff', () {
    final proposals = _run(
      [_shift(1, minTier: 'supervisor')],
      [_user(10, RoleTier.base)],
    );
    expect(proposals.single.isFilled, isFalse);
  });

  test('auto-assign skips people who are off the rota', () {
    final proposals = _run(
      [_shift(1)],
      [_user(10, RoleTier.base, books: false)],
    );
    expect(proposals.single.isFilled, isFalse);
  });

  test('supervisor shifts are filled first, so the supervisor is not '
      'used up on an ordinary shift at the same time', () {
    // Same time slot and one supervisor: both shifts have exactly one
    // eligible person, so without the rule the ordinary shift (listed
    // first) would take the supervisor and leave no supervisor on.
    final ordinary = _shift(1, hour: 18);
    final supShift = Shift(
      id: 2,
      siteId: 1,
      startsAt: ordinary.startsAt,
      endsAt: ordinary.endsAt,
      status: ShiftStatus.open,
      createdByUserId: 1,
      createdAt: DateTime(2026, 1, 1),
      minTier: 'supervisor',
    );
    final supervisor = _user(20, RoleTier.supervisor);
    final proposals = _run([ordinary, supShift], [supervisor]);
    final byShift = {for (final p in proposals) p.shift.id: p.user?.id};
    expect(byShift[2], supervisor.id);
    expect(byShift[1], isNull);
  });
}
