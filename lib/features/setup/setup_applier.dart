import 'dart:math';

import '../../core/network/backend_rest_client.dart';
import '../../core/storage/app_database.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/repositories/department_repository.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/region_repository.dart';
import '../../shared/repositories/site_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../shared/repositories/user_repository.dart';
import 'setup_draft.dart';

/// A login to hand over at the end — shown once, never stored.
class SetupLogin {
  const SetupLogin({required this.name, this.pin, this.email, this.password});

  final String name;
  final String? pin;
  final String? email;
  final String? password;
}

/// Creates everything in a [SetupDraft] (2026-10-17). Every created id is
/// written into `draft.applied` and the draft saved as it goes, so if the
/// connection drops, pressing Create again carries on from there.
class SetupApplier {
  SetupApplier({
    required this.client,
    required this.sites,
    required this.regions,
    required this.departments,
    required this.equipment,
    required this.users,
    required this.provisioning,
    required this.templates,
    required this.schedules,
    required this.saveDraft,
  });

  final BackendRestClient client;
  final SiteRepository sites;
  final RegionRepository regions;
  final DepartmentRepository departments;
  final EquipmentRepository equipment;
  final UserRepository users;
  final TenantProvisioningRepository provisioning;
  final TaskTemplateRepository templates;
  final TaskScheduleRepository schedules;
  final Future<void> Function(SetupDraft draft) saveDraft;

  final _random = Random.secure();

  String _pin() => List.generate(4, (_) => _random.nextInt(10)).join();

  /// Runs the whole set-up. [onProgress] gets (done, total, label).
  Future<List<SetupLogin>> apply({
    required SetupDraft draft,
    required User me,
    required int organisationId,
    required void Function(int done, int total, String label) onProgress,
  }) async {
    final logins = <SetupLogin>[];
    final total =
        1 +
        draft.leaders.where((p) => !p.isEmpty).length +
        draft.regions.length * 2 +
        draft.branches.length * 5;
    var done = 0;
    void step(String label) => onProgress(++done, total, label);

    Future<void> save() => saveDraft(draft);

    // 1. You.
    if (draft.myJobTitle.trim().isNotEmpty &&
        draft.applied['me_title'] != draft.myJobTitle.trim()) {
      await client.update(
        'users',
        filter: 'id=eq.${me.id}',
        body: {'job_title': draft.myJobTitle.trim()},
      );
      draft.applied['me_title'] = draft.myJobTitle.trim();
      await save();
    }
    step(me.name);

    // 2. Head-office leaders: email logins.
    final leaders = draft.appliedMap('leaders');
    for (final p in draft.leaders.where((p) => !p.isEmpty)) {
      final email = p.email.trim().toLowerCase();
      if (email.isNotEmpty && !leaders.containsKey(email)) {
        final r = await provisioning.inviteSenior(
          email: email,
          name: p.name.trim(),
          roleTier: 'executive',
          organisationId: organisationId,
        );
        leaders[email] = r.localUserId;
        logins.add(
          SetupLogin(
            name: p.name,
            email: r.email,
            password: r.temporaryPassword,
          ),
        );
        await save();
      }
      step(p.name);
    }

    // 3. Regions and their managers.
    final regionIds = draft.appliedMap('regions');
    final managers = draft.appliedMap('region_managers');
    if (draft.multiSite == true && draft.useRegions) {
      for (final r in draft.regions.where((r) => r.name.trim().isNotEmpty)) {
        if (!regionIds.containsKey(r.key)) {
          final created = await regions.create(
            name: r.name.trim(),
            organisationId: organisationId,
          );
          regionIds[r.key] = created.id;
          await save();
        }
        step(r.name);
        final email = r.managerEmail.trim().toLowerCase();
        if (email.isNotEmpty && !managers.containsKey(r.key)) {
          final m = await provisioning.inviteSenior(
            email: email,
            name: r.managerName.trim().isEmpty ? email : r.managerName.trim(),
            roleTier: 'regional',
            organisationId: organisationId,
            regionId: regionIds[r.key] as int,
          );
          managers[r.key] = m.localUserId;
          logins.add(
            SetupLogin(
              name: r.managerName.trim().isEmpty ? email : r.managerName,
              email: m.email,
              password: m.temporaryPassword,
            ),
          );
          await save();
        }
        step(r.managerName);
      }
    }

    // 4. Branches. The first one takes over the venue made at sign-up.
    final branchIds = draft.appliedMap('branches');
    final existing = await sites.getForOrganisation(organisationId);
    final allTemplates = await templates.getAllCurrentVersions();
    final tagRows = await _templateVenueTags();
    final types = await equipment.getEquipmentTypes();
    final typeName = {for (final t in types) t.id: t.name};
    final frequencies = AppDatabase.libraryDefaultFrequencies;

    for (final b in draft.branches.where((b) => b.name.trim().isNotEmpty)) {
      // 4a. The venue itself.
      if (!branchIds.containsKey(b.key)) {
        final claimed = branchIds.values.toSet();
        final unused = existing.where((s) => !claimed.contains(s.id)).toList();
        int siteId;
        if (branchIds.isEmpty && existing.length == 1 && unused.isNotEmpty) {
          siteId = unused.first.id;
          await sites.rename(siteId, b.name.trim());
          await client.update(
            'sites',
            filter: 'id=eq.$siteId',
            body: {
              'address': b.address.trim().isEmpty ? null : b.address.trim(),
            },
          );
        } else {
          final created = await sites.create(
            name: b.name.trim(),
            address: b.address.trim().isEmpty ? null : b.address.trim(),
            organisationId: organisationId,
          );
          siteId = created.id;
        }
        branchIds[b.key] = siteId;
        await save();
      }
      final siteId = branchIds[b.key] as int;
      final regionId = b.regionKey == null
          ? null
          : regionIds[b.regionKey] as int?;
      if (regionId != null) await sites.setRegion(siteId, regionId);
      if (b.venueTypeIds.isNotEmpty) {
        await sites.setVenueTypeIds(siteId, b.venueTypeIds.toList());
      }
      step(b.name);

      // 4b. Sections.
      final deptIds = draft.appliedMap('departments_${b.key}');
      for (final d in b.departments.where((d) => d.trim().isNotEmpty)) {
        if (deptIds.containsKey(d)) continue;
        final created = await departments.create(
          name: d.trim(),
          siteId: siteId,
        );
        deptIds[d] = created.id;
        await save();
      }
      step(b.name);

      // 4c. Equipment: "Fridge 1", "Fridge 2", ...
      final equipIds = draft.appliedMap('equipment_${b.key}');
      for (final e in b.equipment.entries) {
        for (var n = 1; n <= e.value; n++) {
          final k = '${e.key}:$n';
          if (equipIds.containsKey(k)) continue;
          final base = typeName[e.key] ?? 'Equipment';
          final created = await equipment.create(
            name: e.value == 1 ? base : '$base $n',
            equipmentTypeId: e.key,
            siteId: siteId,
          );
          equipIds[k] = created.id;
          await save();
        }
      }
      step(b.name);

      // 4d. Staff with PINs.
      final staffIds = draft.appliedMap('staff_${b.key}');
      for (var i = 0; i < b.staff.length; i++) {
        final s = b.staff[i];
        if (s.name.trim().isEmpty || staffIds.containsKey('$i')) continue;
        final pin = _pin();
        final user = await users.createStaffMember(
          name: s.name.trim(),
          jobTitle: jobRoleDisplayName(s.jobRole),
          roleTier: s.tier,
          jobRole: s.jobRole,
          pin: pin,
          siteId: siteId,
        );
        staffIds['$i'] = user.id;
        logins.add(SetupLogin(name: '${s.name} (${b.name})', pin: pin));
        await save();
      }
      step(b.name);

      // 4e. Checks from the library, each given to one person.
      if (draft.appliedMap('tasks')[b.key] != true && b.segments.isNotEmpty) {
        final people = <({int id, JobRole role, RoleTier tier})>[
          for (var i = 0; i < b.staff.length; i++)
            if (staffIds['$i'] case final int id)
              (id: id, role: b.staff[i].jobRole, tier: b.staff[i].tier),
        ];
        final instancesByType = <int, List<int>>{};
        for (final e in equipIds.entries) {
          final typeId = int.parse(e.key.split(':').first);
          instancesByType.putIfAbsent(typeId, () => []).add(e.value as int);
        }
        final turn = <JobRole?, int>{};
        int assignee(JobRole? role) {
          final matching = role == null
              ? <({int id, JobRole role, RoleTier tier})>[]
              : people.where((p) => p.role == role).toList();
          final pool = matching.isNotEmpty
              ? matching
              : people
                    .where(
                      (p) =>
                          roleTierRank(p.tier) >=
                          roleTierRank(RoleTier.supervisor),
                    )
                    .toList();
          if (pool.isEmpty && people.isEmpty) return me.id;
          final list = pool.isEmpty ? people : pool;
          final n = turn[role] = (turn[role] ?? -1) + 1;
          return list[n % list.length].id;
        }

        for (final t in allTemplates.where(
          (t) => b.segments.contains(t.segment),
        )) {
          if (!_suits(t, b, tagRows)) continue;
          final frequency =
              ScheduleFrequency.values.asNameMap()[frequencies[t.title]] ??
              ScheduleFrequency.daily;
          final targets = t.equipmentTypeId == null
              ? <int?>[null]
              : (instancesByType[t.equipmentTypeId] ?? const <int>[]);
          for (final instance in targets) {
            await schedules.assign(
              taskTemplateGroupId: t.templateGroupId,
              assignedUserId: assignee(t.jobRole),
              equipmentInstanceId: instance,
              frequency: frequency,
              assignedByUserId: me.id,
              siteId: siteId,
            );
          }
        }
        draft.appliedMap('tasks')[b.key] = true;
        await save();
      }
      step(b.name);
    }
    return logins;
  }

  /// template group id -> venue type ids it's tagged with (untagged = any).
  Future<Map<int, Set<int>>> _templateVenueTags() async {
    try {
      final rows = await client.select(
        'task_template_venue_types',
        query: 'select=task_template_group_id,venue_type_id',
      );
      final out = <int, Set<int>>{};
      for (final r in rows) {
        out
            .putIfAbsent(r['task_template_group_id'] as int, () => {})
            .add(r['venue_type_id'] as int);
      }
      return out;
    } catch (_) {
      return const {};
    }
  }

  bool _suits(TaskTemplate t, DraftBranch b, Map<int, Set<int>> tags) {
    final tagged = tags[t.templateGroupId];
    if (tagged == null || tagged.isEmpty || b.venueTypeIds.isEmpty) return true;
    return tagged.intersection(b.venueTypeIds).isNotEmpty;
  }
}
