// Business Setup Wizard (2026-10-17): the draft survives a save/reload,
// and the AI outline only adds — it never removes what was typed.
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/setup/setup_draft.dart';
import 'package:venurite/shared/models/job_role.dart';
import 'package:venurite/shared/models/user.dart';

void main() {
  test('round-trips through JSON', () {
    final d = SetupDraft(myJobTitle: 'Owner', multiSite: true, useRegions: true);
    final r = DraftRegion(key: d.newKey('r'), name: 'Kent');
    d.regions.add(r);
    d.branches.add(
      DraftBranch(
        key: d.newKey('b'),
        regionKey: r.key,
        name: 'The Bell',
        venueTypeIds: {7},
        equipment: {3: 2},
        staff: [DraftStaff(name: 'Sam', jobRole: JobRole.bar, tier: RoleTier.supervisor)],
        segments: {'bar_beverage'},
      ),
    );
    d.appliedMap('branches')['b2'] = 61;
    final back = SetupDraft.fromJson(d.toJson());
    expect(back.regions.single.name, 'Kent');
    final b = back.branches.single;
    expect(b.regionKey, r.key);
    expect(b.equipment, {3: 2});
    expect(b.staff.single.tier, RoleTier.supervisor);
    expect(back.applied['branches'], {'b2': 61});
    expect(back.newKey('b'), 'b3');
  });

  test('AI outline adds regions, branches and leaders without duplicates', () {
    final d = SetupDraft();
    d.branches.add(DraftBranch(key: d.newKey('b'), name: 'Pub 1 (Kent)'));
    d.mergeOutline({
      'single_site': false,
      'regions': [
        {'name': 'Kent', 'manager_name': 'Jo', 'manager_email': 'jo@example.com'},
      ],
      'branches': [
        {'name': 'Pub 1 (Kent)', 'region': 'Kent', 'venue_types': ['Bar / Pub']},
        {'name': 'Cafe in Brighton', 'venue_types': ['Café'], 'departments': []},
      ],
      'leaders': [
        {'name': 'Tom', 'email': 'tom@example.com'},
      ],
    }, {'bar / pub': 7, 'café': 5});
    expect(d.multiSite, isTrue);
    expect(d.useRegions, isTrue);
    expect(d.regions.single.managerEmail, 'jo@example.com');
    expect(d.branches.map((b) => b.name), ['Pub 1 (Kent)', 'Cafe in Brighton']);
    expect(d.branches.last.venueTypeIds, {5});
    expect(d.branches.last.departments, ['Kitchen']);
    expect(d.leaders.single.name, 'Tom');
  });
}
