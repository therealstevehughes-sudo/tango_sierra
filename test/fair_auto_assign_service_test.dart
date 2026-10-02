import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/roster/fair_auto_assign_service.dart';
import 'package:venurite/shared/models/job_role.dart';
import 'package:venurite/shared/models/off_day_request.dart';
import 'package:venurite/shared/models/shift.dart';
import 'package:venurite/shared/models/training_item.dart';
import 'package:venurite/shared/models/training_record.dart';
import 'package:venurite/shared/models/user.dart';

User _user(int id, {String name = 'Staff'}) => User(
  id: id,
  name: '$name $id',
  jobTitle: 'Team Member',
  roleTier: RoleTier.base,
);

Shift _shift(
  int id, {
  required DateTime startsAt,
  required DateTime endsAt,
  int? claimedByUserId,
  String? roleRequired,
}) => Shift(
  id: id,
  siteId: 1,
  startsAt: startsAt,
  endsAt: endsAt,
  status: claimedByUserId == null ? ShiftStatus.open : ShiftStatus.assigned,
  claimedByUserId: claimedByUserId,
  createdByUserId: 1,
  createdAt: DateTime(2026, 1, 1),
  roleRequired: roleRequired,
);

// Covers every job role's required-certification floor (see
// systemRequiredCertifications) regardless of which role a test user ends
// up with, so a test only fails on the constraint it's actually checking.
List<TrainingRecord> _validRecordsFor(int userId) => [
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

void main() {
  final monday9to5 = (
    start: DateTime(2026, 10, 5, 9),
    end: DateTime(2026, 10, 5, 17),
  );

  group('computeFairAutoAssignProposals', () {
    test('assigns an open shift to the only certified-eligible candidate', () {
      final alice = _user(1, name: 'Alice');
      final bob = _user(2, name: 'Bob');
      final shift = _shift(
        100,
        startsAt: monday9to5.start,
        endsAt: monday9to5.end,
      );

      final proposals = computeFairAutoAssignProposals(
        candidateShifts: [shift],
        candidateStaff: [alice, bob],
        allExistingShiftsForSite: [],
        offDayRequestsForSite: [],
        trainingRecordsByUserId: {
          alice.id: _validRecordsFor(alice.id),
          // Bob has no training records at all -> missing floor certs.
          bob.id: [],
        },
        siteCertAdditions: [],
      );

      expect(proposals, hasLength(1));
      expect(proposals.first.isFilled, isTrue);
      expect(proposals.first.user!.id, alice.id);
    });

    test('never proposes a double-booked candidate', () {
      final alice = _user(1, name: 'Alice');
      final newShift = _shift(
        101,
        startsAt: monday9to5.start,
        endsAt: monday9to5.end,
      );
      // Alice is already assigned to an overlapping existing shift.
      final existing = _shift(
        99,
        startsAt: DateTime(2026, 10, 5, 8),
        endsAt: DateTime(2026, 10, 5, 12),
        claimedByUserId: alice.id,
      );

      final proposals = computeFairAutoAssignProposals(
        candidateShifts: [newShift],
        candidateStaff: [alice],
        allExistingShiftsForSite: [existing],
        offDayRequestsForSite: [],
        trainingRecordsByUserId: {alice.id: _validRecordsFor(alice.id)},
        siteCertAdditions: [],
      );

      expect(proposals, hasLength(1));
      expect(proposals.first.isFilled, isFalse);
      expect(proposals.first.reason, contains('No eligible candidate'));
    });

    test('never proposes a candidate with a non-denied day-off request', () {
      final alice = _user(1, name: 'Alice');
      final shift = _shift(
        102,
        startsAt: monday9to5.start,
        endsAt: monday9to5.end,
      );
      final offDay = OffDayRequest(
        id: 1,
        siteId: 1,
        userId: alice.id,
        requestedDate: DateTime(2026, 10, 5),
        status: OffDayRequestStatus.approved,
        createdAt: DateTime(2026, 1, 1),
      );

      final proposals = computeFairAutoAssignProposals(
        candidateShifts: [shift],
        candidateStaff: [alice],
        allExistingShiftsForSite: [],
        offDayRequestsForSite: [offDay],
        trainingRecordsByUserId: {alice.id: _validRecordsFor(alice.id)},
        siteCertAdditions: [],
      );

      expect(proposals.first.isFilled, isFalse);
    });

    test('respects a shift role requirement as a hard constraint', () {
      final chef = _user(1, name: 'Chef');
      final porter = _user(2, name: 'Porter');
      final chefWithRole = User(
        id: chef.id,
        name: chef.name,
        jobTitle: 'Chef',
        roleTier: RoleTier.base,
        jobRole: JobRole.chefCook,
      );
      final porterWithRole = User(
        id: porter.id,
        name: porter.name,
        jobTitle: 'Porter',
        roleTier: RoleTier.base,
        jobRole: JobRole.kitchenPorter,
      );
      final shift = _shift(
        103,
        startsAt: monday9to5.start,
        endsAt: monday9to5.end,
        roleRequired: 'chefCook',
      );

      final proposals = computeFairAutoAssignProposals(
        candidateShifts: [shift],
        candidateStaff: [chefWithRole, porterWithRole],
        allExistingShiftsForSite: [],
        offDayRequestsForSite: [],
        trainingRecordsByUserId: {
          chefWithRole.id: _validRecordsFor(chefWithRole.id),
          porterWithRole.id: _validRecordsFor(porterWithRole.id),
        },
        siteCertAdditions: [],
      );

      expect(proposals.first.user!.id, chefWithRole.id);
    });

    test(
      'picks whoever has the fewest hours assigned so far this run',
      () {
        final alice = _user(1, name: 'Alice');
        final bob = _user(2, name: 'Bob');
        // Two identical, non-overlapping shifts on different days — both
        // staff are eligible for both, so the second shift should go to
        // whoever didn't get the first one.
        final shiftA = _shift(
          104,
          startsAt: DateTime(2026, 10, 5, 9),
          endsAt: DateTime(2026, 10, 5, 17),
        );
        final shiftB = _shift(
          105,
          startsAt: DateTime(2026, 10, 6, 9),
          endsAt: DateTime(2026, 10, 6, 17),
        );

        final proposals = computeFairAutoAssignProposals(
          candidateShifts: [shiftA, shiftB],
          candidateStaff: [alice, bob],
          allExistingShiftsForSite: [],
          offDayRequestsForSite: [],
          trainingRecordsByUserId: {
            alice.id: _validRecordsFor(alice.id),
            bob.id: _validRecordsFor(bob.id),
          },
          siteCertAdditions: [],
        );

        expect(proposals, hasLength(2));
        final assignedIds = proposals.map((p) => p.user!.id).toSet();
        expect(assignedIds, {alice.id, bob.id});
      },
    );

    test(
      'assigns the hardest-to-fill shift correctly regardless of input order',
      () {
        final alice = _user(1, name: 'Alice');
        final bob = _user(2, name: 'Bob');
        // Shift X: only Alice is role-eligible. Shift Y: both are eligible.
        final shiftEasy = _shift(
          106,
          startsAt: DateTime(2026, 10, 5, 9),
          endsAt: DateTime(2026, 10, 5, 17),
        );
        final shiftHard = _shift(
          107,
          startsAt: DateTime(2026, 10, 6, 9),
          endsAt: DateTime(2026, 10, 6, 17),
          roleRequired: 'chefCook',
        );
        final aliceChef = User(
          id: alice.id,
          name: alice.name,
          jobTitle: 'Chef',
          roleTier: RoleTier.base,
          jobRole: JobRole.chefCook,
        );

        // Easy shift listed first in the input — the algorithm must still
        // reserve Alice for the hard shift, not spend her on the easy one
        // just because it was given first.
        final proposals = computeFairAutoAssignProposals(
          candidateShifts: [shiftEasy, shiftHard],
          candidateStaff: [aliceChef, bob],
          allExistingShiftsForSite: [],
          offDayRequestsForSite: [],
          trainingRecordsByUserId: {
            aliceChef.id: _validRecordsFor(aliceChef.id),
            bob.id: _validRecordsFor(bob.id),
          },
          siteCertAdditions: [],
        );

        final hardProposal = proposals.firstWhere(
          (p) => p.shift.id == shiftHard.id,
        );
        expect(hardProposal.isFilled, isTrue);
        expect(hardProposal.user!.id, aliceChef.id);
      },
    );
  });
}
