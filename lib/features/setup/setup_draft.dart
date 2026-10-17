import '../../shared/models/job_role.dart';
import '../../shared/models/user.dart';

// Business Setup Wizard (2026-10-17, founder-approved top-down order): the
// whole set-up is drafted first and saved to the server after every step
// (so a director can stop and come back), then created in one go from the
// preview. `applied` remembers what already exists, so an interrupted
// "Create" carries on instead of making duplicates.

class DraftPerson {
  DraftPerson({this.name = '', this.email = ''});

  String name;
  String email;

  bool get isEmpty => name.trim().isEmpty && email.trim().isEmpty;

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  factory DraftPerson.fromJson(Map<String, dynamic> j) =>
      DraftPerson(name: j['name'] ?? '', email: j['email'] ?? '');
}

class DraftRegion {
  DraftRegion({
    required this.key,
    this.name = '',
    this.managerName = '',
    this.managerEmail = '',
  });

  final String key;
  String name;
  String managerName;
  String managerEmail;

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'manager_name': managerName,
    'manager_email': managerEmail,
  };

  factory DraftRegion.fromJson(Map<String, dynamic> j) => DraftRegion(
    key: j['key'],
    name: j['name'] ?? '',
    managerName: j['manager_name'] ?? '',
    managerEmail: j['manager_email'] ?? '',
  );
}

class DraftStaff {
  DraftStaff({
    this.name = '',
    this.jobRole = JobRole.chefCook,
    this.tier = RoleTier.base,
  });

  String name;
  JobRole jobRole;
  RoleTier tier;

  Map<String, dynamic> toJson() => {
    'name': name,
    'job_role': jobRole.name,
    'tier': tier.name,
  };

  factory DraftStaff.fromJson(Map<String, dynamic> j) => DraftStaff(
    name: j['name'] ?? '',
    jobRole: JobRole.values.asNameMap()[j['job_role']] ?? JobRole.chefCook,
    tier: RoleTier.values.asNameMap()[j['tier']] ?? RoleTier.base,
  );
}

class DraftBranch {
  DraftBranch({
    required this.key,
    this.regionKey,
    this.name = '',
    this.address = '',
    Set<int>? venueTypeIds,
    List<String>? departments,
    Map<int, int>? equipment,
    List<DraftStaff>? staff,
    Set<String>? segments,
    this.segmentsChosen = false,
  }) : venueTypeIds = venueTypeIds ?? {},
       departments = departments ?? ['Kitchen'],
       equipment = equipment ?? {},
       staff = staff ?? [],
       segments = segments ?? {};

  final String key;
  String? regionKey;
  String name;
  String address;
  Set<int> venueTypeIds;
  List<String> departments;

  /// Equipment type id -> how many.
  Map<int, int> equipment;
  List<DraftStaff> staff;

  /// Task library sections picked for this branch.
  Set<String> segments;

  /// False until the person has seen the tasks step for this branch (so
  /// the usual sections can be pre-ticked once, then left alone).
  bool segmentsChosen;

  Map<String, dynamic> toJson() => {
    'key': key,
    'region_key': regionKey,
    'name': name,
    'address': address,
    'venue_type_ids': venueTypeIds.toList(),
    'departments': departments,
    'equipment': {for (final e in equipment.entries) '${e.key}': e.value},
    'staff': [for (final s in staff) s.toJson()],
    'segments': segments.toList(),
    'segments_chosen': segmentsChosen,
  };

  factory DraftBranch.fromJson(Map<String, dynamic> j) => DraftBranch(
    key: j['key'],
    regionKey: j['region_key'],
    name: j['name'] ?? '',
    address: j['address'] ?? '',
    venueTypeIds: {
      for (final v in (j['venue_type_ids'] as List? ?? [])) v as int,
    },
    departments: [for (final d in (j['departments'] as List? ?? [])) '$d'],
    equipment: {
      for (final e in ((j['equipment'] as Map?) ?? {}).entries)
        int.parse('${e.key}'): e.value as int,
    },
    staff: [
      for (final s in (j['staff'] as List? ?? []))
        DraftStaff.fromJson(s as Map<String, dynamic>),
    ],
    segments: {for (final s in (j['segments'] as List? ?? [])) '$s'},
    segmentsChosen: j['segments_chosen'] == true,
  );
}

class SetupDraft {
  SetupDraft({
    this.step = 0,
    this.myJobTitle = '',
    List<DraftPerson>? leaders,
    this.multiSite,
    this.useRegions = false,
    List<DraftRegion>? regions,
    List<DraftBranch>? branches,
    Map<String, dynamic>? applied,
    this.counter = 0,
  }) : leaders = leaders ?? [],
       regions = regions ?? [],
       branches = branches ?? [],
       applied = applied ?? {};

  int step;
  String myJobTitle;
  List<DraftPerson> leaders;
  bool? multiSite;
  bool useRegions;
  List<DraftRegion> regions;
  List<DraftBranch> branches;

  /// What "Create" has already made: e.g. applied['branches'][key] = siteId.
  Map<String, dynamic> applied;
  int counter;

  String newKey(String prefix) => '$prefix${++counter}';

  Map<String, dynamic> appliedMap(String name) =>
      (applied[name] ??= <String, dynamic>{}) as Map<String, dynamic>;

  Map<String, dynamic> toJson() => {
    'v': 1,
    'step': step,
    'my_job_title': myJobTitle,
    'leaders': [for (final p in leaders) p.toJson()],
    'multi_site': multiSite,
    'use_regions': useRegions,
    'regions': [for (final r in regions) r.toJson()],
    'branches': [for (final b in branches) b.toJson()],
    'applied': applied,
    'counter': counter,
  };

  factory SetupDraft.fromJson(Map<String, dynamic> j) => SetupDraft(
    step: j['step'] as int? ?? 0,
    myJobTitle: j['my_job_title'] ?? '',
    leaders: [
      for (final p in (j['leaders'] as List? ?? []))
        DraftPerson.fromJson(p as Map<String, dynamic>),
    ],
    multiSite: j['multi_site'] as bool?,
    useRegions: j['use_regions'] == true,
    regions: [
      for (final r in (j['regions'] as List? ?? []))
        DraftRegion.fromJson(r as Map<String, dynamic>),
    ],
    branches: [
      for (final b in (j['branches'] as List? ?? []))
        DraftBranch.fromJson(b as Map<String, dynamic>),
    ],
    applied: Map<String, dynamic>.from(j['applied'] as Map? ?? {}),
    counter: j['counter'] as int? ?? 0,
  );

  /// Merge the AI's outline (setup-assistant) into the draft: adds what's
  /// new, never deletes what the person already entered.
  void mergeOutline(
    Map<String, dynamic> o,
    Map<String, int> venueTypeIdByName,
  ) {
    String s(Object? v) => v is String ? v.trim() : '';
    if (o['single_site'] == true) multiSite = false;
    if (o['single_site'] == false) multiSite = true;
    for (final l in (o['leaders'] as List? ?? []).whereType<Map>()) {
      final email = s(l['email']);
      final name = s(l['name']);
      if (name.isEmpty) continue;
      if (leaders.any(
        (p) => p.name == name || (email.isNotEmpty && p.email == email),
      )) {
        continue;
      }
      leaders.add(DraftPerson(name: name, email: email));
    }
    final regionKeyByName = {
      for (final r in regions) r.name.toLowerCase(): r.key,
    };
    for (final r in (o['regions'] as List? ?? []).whereType<Map>()) {
      final name = s(r['name']);
      if (name.isEmpty || regionKeyByName.containsKey(name.toLowerCase())) {
        continue;
      }
      final region = DraftRegion(
        key: newKey('r'),
        name: name,
        managerName: s(r['manager_name']),
        managerEmail: s(r['manager_email']),
      );
      regions.add(region);
      regionKeyByName[name.toLowerCase()] = region.key;
      useRegions = true;
      multiSite = true;
    }
    for (final b in (o['branches'] as List? ?? []).whereType<Map>()) {
      final name = s(b['name']);
      if (name.isEmpty ||
          branches.any((x) => x.name.toLowerCase() == name.toLowerCase())) {
        continue;
      }
      branches.add(
        DraftBranch(
          key: newKey('b'),
          name: name,
          address: s(b['address']),
          regionKey: regionKeyByName[s(b['region']).toLowerCase()],
          venueTypeIds: {
            for (final t in (b['venue_types'] as List? ?? []))
              ?venueTypeIdByName[s(t).toLowerCase()],
          },
          departments: [
            for (final d in (b['departments'] as List? ?? []))
              if (s(d).isNotEmpty) s(d),
          ].ifEmpty(['Kitchen']),
        ),
      );
    }
    if (branches.length > 1) multiSite = true;
  }
}

extension _IfEmpty on List<String> {
  List<String> ifEmpty(List<String> fallback) => isEmpty ? fallback : this;
}
