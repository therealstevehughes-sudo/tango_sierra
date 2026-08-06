import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../utils/pin_hasher.dart';

part 'app_database.g.dart';

@DataClassName('TaskSubmissionEntity')
class TaskSubmissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskTitle => text()();
  TextColumn get status => text()();
  TextColumn get completedBy => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get numericValue => text().nullable()();
  BoolColumn get photoAttached =>
      boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  // Traceability back to what this submission actually fulfilled, added when
  // the carousel was wired to real schedules/templates instead of a
  // hardcoded queue (Sprint 010). Nullable: older rows predate this link.
  IntColumn get taskScheduleId => integer().nullable()();
  IntColumn get taskTemplateGroupId => integer().nullable()();
  IntColumn get equipmentInstanceId =>
      integer().nullable().references(EquipmentInstances, #id)();
  TextColumn get customFieldValuesJson => text().nullable()();
  // Added for reliable session-boundary queries (Sprint 013) — completedBy
  // is only a formatted display string, not a real reference.
  IntColumn get completedByUserId =>
      integer().nullable().references(Users, #id)();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('UserEntity')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get jobTitle => text()();
  TextColumn get roleTier => text()();
  TextColumn get pinHash => text()();
  TextColumn get pinSalt => text()();
  TextColumn get preferredTemperatureUnit =>
      text().withDefault(const Constant('celsius'))();
  // Nullable at the SQL level only (ALTER TABLE can't retroactively enforce
  // NOT NULL against existing rows) — beforeOpen backfills every row to a
  // real site, and application code treats this as required.
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  // Reflects the most recent deactivation event and is deliberately
  // preserved on reactivation (not cleared) — staff deactivation is more
  // HR/compliance-sensitive than equipment retirement, so "when/who last
  // deactivated this person" stays on record even after they're brought
  // back, rather than disappearing the moment `active` flips true again.
  DateTimeColumn get deactivatedAt => dateTime().nullable()();
  IntColumn get deactivatedByUserId =>
      integer().nullable().references(Users, #id)();
}

@DataClassName('EquipmentTypeEntity')
class EquipmentTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('LegalLimitReferenceEntity')
class LegalLimitReferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  RealColumn get legalMin => real().nullable()();
  RealColumn get legalMax => real().nullable()();
  TextColumn get unit => text()();
  // Sprint 030: which of [LAW]/[FSA]/[BEST] this figure is, sourced from
  // HORECA_TASK_LIBRARY.md, so nobody mistakes a best-practice figure for a
  // legal one. Compile-time default 'fsa' (the middle-weight, not
  // over-claiming legal status) — existing rows corrected explicitly to
  // their real basis by the schemaVersion 23 migration and by
  // _seedTaskLibraryReferenceData, not left on the default.
  TextColumn get basis => text().withDefault(const Constant('fsa'))();
  // Nullable, unpopulated this sprint — no UI exists yet to set these.
  // Forward-compatible groundwork for a future sprint's professional
  // sign-off action: every limit loaded from the research doc still needs a
  // qualified food-safety professional to review it before real deployment.
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  IntColumn get verifiedByUserId =>
      integer().nullable().references(Users, #id)();
}

@DataClassName('TaskTemplateEntity')
class TaskTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateGroupId => integer()();
  IntColumn get versionNumber => integer()();
  IntColumn get previousVersionId =>
      integer().nullable().references(TaskTemplates, #id)();
  TextColumn get title => text()();
  TextColumn get segment => text()();
  TextColumn get applicableRoleTiers => text()();
  TextColumn get method => text()();
  BoolColumn get requiresPhoto =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get requiresNotes =>
      boolean().withDefault(const Constant(false))();
  TextColumn get customFieldsJson => text().nullable()();
  RealColumn get minLimit => real().nullable()();
  RealColumn get maxLimit => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get legalLimitCategory => text().nullable()();
  BoolColumn get isCritical => boolean().withDefault(const Constant(false))();
  BoolColumn get requiresCorrectiveActionOnFail =>
      boolean().withDefault(const Constant(false))();
  TextColumn get fixInstructions => text().nullable()();
  IntColumn get equipmentTypeId =>
      integer().nullable().references(EquipmentTypes, #id)();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get createdByUserId =>
      integer().nullable().references(Users, #id)();
  // Real 3-level priority (Sprint 023), nullable — existing rows predate
  // this field and can't be reconstructed from `isCritical` without
  // guessing whether a non-critical row was "high" or "standard". Left
  // null on migration; TaskTemplate.effectivePriority provides the
  // isCritical-derived fallback for those rows. isCritical itself is
  // untouched and still authoritative for any existing reader.
  TextColumn get priority => text().nullable()();
}

@DataClassName('AreaEntity')
class Areas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('EquipmentInstanceEntity')
class EquipmentInstances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get equipmentTypeId =>
      integer().references(EquipmentTypes, #id)();
  IntColumn get areaId => integer().nullable().references(Areas, #id)();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

@DataClassName('TaskScheduleEntity')
class TaskSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Not a real FK: templateGroupId has no unique constraint on TaskTemplates
  // (it's a denormalized grouping key shared across version rows), so this
  // is a soft reference resolved at the application layer, not the DB layer.
  IntColumn get taskTemplateGroupId => integer()();
  IntColumn get assignedUserId => integer().references(Users, #id)();
  IntColumn get equipmentInstanceId =>
      integer().nullable().references(EquipmentInstances, #id)();
  TextColumn get frequency => text()();
  TextColumn get customFrequencyDetail => text().nullable()();
  IntColumn get assignedByUserId => integer().references(Users, #id)();
  DateTimeColumn get assignedAt => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('ShiftHandoverNoteEntity')
class ShiftHandoverNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get authorUserId => integer().references(Users, #id)();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('SessionSummaryEntity')
class SessionSummaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffUserId => integer().references(Users, #id)();
  // Denormalized, matching TaskSubmissions.completedBy's existing pattern —
  // avoids a join just to render a name in the manager's inbox.
  TextColumn get staffName => text()();
  IntColumn get sentToManagerId => integer().references(Users, #id)();
  IntColumn get passCount => integer()();
  IntColumn get failCount => integer()();
  TextColumn get failedTaskTitlesJson => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  BoolColumn get acknowledged =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('NotificationRuleEntity')
class NotificationRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ruleGroupId => integer()();
  IntColumn get versionNumber => integer()();
  IntColumn get previousVersionId =>
      integer().nullable().references(NotificationRules, #id)();
  // Not a real FK, same reasoning as TaskSchedules.taskTemplateGroupId: a
  // grouping key shared across template version rows, not a unique column.
  // Null means "any task fail", not scoped to one template.
  IntColumn get taskTemplateGroupId => integer().nullable()();
  TextColumn get targetRoleTier => text().nullable()();
  IntColumn get targetUserId => integer().nullable().references(Users, #id)();
  BoolColumn get channelPush =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get channelEmail =>
      boolean().withDefault(const Constant(false))();
  IntColumn get setByUserId => integer().references(Users, #id)();
  TextColumn get setByTier => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  // Nullable by design, not just migration necessity — null means "applies
  // org-wide across every site", same pattern as taskTemplateGroupId above.
  // Pre-existing (Sprint 014) rules stay null on migration rather than being
  // backfilled to one site, preserving their original org-wide meaning.
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
}

@DataClassName('TriggerNotificationEntity')
class TriggerNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  // The specific rule VERSION that fired, not the ruleGroupId — preserves
  // exactly what config was in effect at the time, even if the rule is
  // edited (a new version) later.
  IntColumn get notificationRuleId =>
      integer().references(NotificationRules, #id)();
  IntColumn get taskSubmissionId =>
      integer().references(TaskSubmissions, #id)();
  IntColumn get recipientUserId => integer().references(Users, #id)();
  TextColumn get message => text()();
  IntColumn get siteId => integer().references(Sites, #id)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get acknowledged =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
  // Denormalized from the firing rule at creation time (Sprint 022) — null
  // means the firing rule targeted a specific person, non-null means it
  // targeted that role tier. Lets the escalation sweep decide whether this
  // notification has "nowhere further up" to escalate to (top) without a
  // repository lookup back to the rule, which may since have a newer
  // version. Pre-existing rows stay null on migration, which is treated as
  // escalate-eligible — the conservative default for legacy data.
  TextColumn get originTargetRoleTier => text().nullable()();
  // Set once this notification has triggered an escalation, so the
  // escalation sweep never double-escalates the same notification.
  DateTimeColumn get escalatedAt => dateTime().nullable()();
}

@DataClassName('ThirdPartyContactEntity')
class ThirdPartyContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get company => text().nullable()();
  TextColumn get specialty => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
  // Null means visible org-wide, same pattern as NotificationRules.siteId.
  IntColumn get siteId => integer().nullable().references(Sites, #id)();
  IntColumn get createdByUserId => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

@DataClassName('OrganisationEntity')
class Organisations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('SiteEntity')
class Sites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get organisationId =>
      integer().references(Organisations, #id)();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// A named "standard task set" (Sprint 026) — a manager-curated grouping of
// task templates tied to an equipment type and/or a section/segment, so
// adding a fryer offers its standard tasks in one action instead of
// hand-building each. Not versioned (not in ARCHITECTURE_LOCK's Versioning
// Rule list — it's a curation convenience, not audit-sensitive config) and
// org-wide (no siteId), matching TaskTemplate/EquipmentType's unscoped
// status. At least one of equipmentTypeId / segment is set, validated in
// the repository.
@DataClassName('TaskPresetEntity')
class TaskPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get equipmentTypeId =>
      integer().nullable().references(EquipmentTypes, #id)();
  TextColumn get segment => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get createdByUserId =>
      integer().nullable().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('TaskPresetItemEntity')
class TaskPresetItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get presetId => integer().references(TaskPresets, #id)();
  // Soft reference (not a real FK), same as TaskSchedule.taskTemplateGroupId:
  // a grouping key shared across a template's version rows, resolved at the
  // application layer — so a later template edit applies automatically.
  IntColumn get taskTemplateGroupId => integer()();
  // The frequency this task defaults to when the preset is applied, stored
  // as ScheduleFrequency.name (same as TaskSchedules.frequency).
  TextColumn get defaultFrequency => text()();
  TextColumn get defaultCustomFrequencyDetail => text().nullable()();
}

// A venue "type" (Sprint 029) — e.g. Café, Fine Dining, Hotel — used to
// filter which tasks/presets/equipment are offered at setup. Per
// HORECA_EQUIPMENT_AND_VENUES.md Part B's own recommendation, this is a
// tagging aid, not a hard lockout: a café that happens to have a fryer can
// still add fryer tasks manually. Fixed seeded list (idempotent
// always-ensured, same pattern as EquipmentTypes) plus a "Something else..."
// inline-create escape hatch, matching EquipmentType precedent. No active/
// retire flag, also matching EquipmentType.
@DataClassName('VenueTypeEntity')
class VenueTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

// A site can have more than one venue type (e.g. a gastropub is kitchen +
// bar), so this is many-to-many rather than a single column on Sites. Wired
// to real UI this sprint (Venue Details screen).
@DataClassName('SiteVenueTypeEntity')
class SiteVenueTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get siteId => integer().references(Sites, #id)();
  IntColumn get venueTypeId => integer().references(VenueTypes, #id)();
}

// Schema + repository method only this sprint — no seeded tag data and no
// filtering UI wired in yet. There's no sourced per-equipment venue-type
// data, only broad segment-level guidance in Part B, so tagging individual
// equipment types is deferred until that's available.
@DataClassName('EquipmentTypeVenueTypeEntity')
class EquipmentTypeVenueTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get equipmentTypeId =>
      integer().references(EquipmentTypes, #id)();
  IntColumn get venueTypeId => integer().references(VenueTypes, #id)();
}

// Schema + repository method only this sprint, same reasoning as
// EquipmentTypeVenueTypes above — deferred until real per-preset venue-type
// data exists.
@DataClassName('TaskPresetVenueTypeEntity')
class TaskPresetVenueTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get presetId => integer().references(TaskPresets, #id)();
  IntColumn get venueTypeId => integer().references(VenueTypes, #id)();
}

// Schema + repository method only this sprint, deliberately unwired and
// unpopulated — prepared for Build Order item 4 (loading the real
// HORECA_TASK_LIBRARY.md task library) to populate later. Keyed on
// taskTemplateGroupId, a soft reference (not a real FK), same pattern as
// TaskSchedules.taskTemplateGroupId: templateGroupId has no unique
// constraint on TaskTemplates since it's shared across a template's version
// rows, so this is resolved at the application layer, not the DB layer.
@DataClassName('TaskTemplateVenueTypeEntity')
class TaskTemplateVenueTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskTemplateGroupId => integer()();
  IntColumn get venueTypeId => integer().references(VenueTypes, #id)();
}

// A single row from HORECA_TASK_LIBRARY.md, pre-mapped to TaskTemplate's
// fields (Sprint 030). `roleTiers`/`method`/`frequency` store the exact
// RoleTier.name/ScheduleFrequency.name values used elsewhere in the schema,
// not display labels.
class _LibraryTask {
  final String title;
  final String segment;
  final String method;
  final String priority;
  final String? equipmentTypeName;
  final List<String> roleTiers;
  final double? minLimit;
  final double? maxLimit;
  final String? unit;
  final String? legalLimitCategory;
  final String? fixInstructions;
  final String frequency;

  const _LibraryTask({
    required this.title,
    required this.segment,
    required this.method,
    required this.priority,
    this.equipmentTypeName,
    required this.roleTiers,
    this.minLimit,
    this.maxLimit,
    this.unit,
    this.legalLimitCategory,
    this.fixInstructions,
    required this.frequency,
  });
}

// A generated TaskPreset (Sprint 030): tasks with an equipment type bundle
// into that equipment's preset; tasks without one bundle into their
// segment's preset instead — so no task appears in two presets.
class _LibraryPreset {
  final String name;
  final String? equipmentTypeName;
  final String? segment;
  final List<String> itemTitles;

  const _LibraryPreset({
    required this.name,
    this.equipmentTypeName,
    this.segment,
    required this.itemTitles,
  });
}

@DriftDatabase(
  tables: [
    TaskSubmissions,
    Users,
    EquipmentTypes,
    LegalLimitReferences,
    TaskTemplates,
    Areas,
    EquipmentInstances,
    TaskSchedules,
    ShiftHandoverNotes,
    SessionSummaries,
    NotificationRules,
    Organisations,
    Sites,
    TriggerNotifications,
    ThirdPartyContacts,
    TaskPresets,
    TaskPresetItems,
    VenueTypes,
    SiteVenueTypes,
    EquipmentTypeVenueTypes,
    TaskPresetVenueTypes,
    TaskTemplateVenueTypes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 23;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(users);
      }
      if (from < 3) {
        // Two-tier (staff/manager) -> three-tier (top/mid/base) role rename.
        await (update(
          users,
        )..where((u) => u.roleTier.equals('staff'))).write(
          const UsersCompanion(roleTier: Value('base')),
        );
        await (update(
          users,
        )..where((u) => u.roleTier.equals('manager'))).write(
          const UsersCompanion(roleTier: Value('mid')),
        );
      }
      if (from < 4) {
        await m.createTable(equipmentTypes);
        await m.createTable(legalLimitReferences);
        await m.createTable(taskTemplates);
      }
      if (from < 5) {
        await m.createTable(areas);
        await m.createTable(equipmentInstances);
      }
      if (from < 6) {
        await m.createTable(taskSchedules);
      }
      if (from < 7) {
        await m.addColumn(taskSubmissions, taskSubmissions.taskScheduleId);
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.taskTemplateGroupId,
        );
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.equipmentInstanceId,
        );
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.customFieldValuesJson,
        );
        await m.addColumn(users, users.preferredTemperatureUnit);
      }
      if (from < 8) {
        await m.addColumn(
          taskSubmissions,
          taskSubmissions.completedByUserId,
        );
        await m.createTable(shiftHandoverNotes);
        await m.createTable(sessionSummaries);
      }
      if (from < 9) {
        await m.createTable(notificationRules);
      }
      if (from < 10) {
        await m.createTable(organisations);
        await m.createTable(sites);
      }
      if (from < 11) {
        await m.addColumn(users, users.siteId);
        await m.addColumn(areas, areas.siteId);
        await m.addColumn(equipmentInstances, equipmentInstances.siteId);
      }
      if (from < 12) {
        await m.addColumn(taskSchedules, taskSchedules.siteId);
        await m.addColumn(taskSubmissions, taskSubmissions.siteId);
      }
      if (from < 13) {
        await m.addColumn(shiftHandoverNotes, shiftHandoverNotes.siteId);
        await m.addColumn(sessionSummaries, sessionSummaries.siteId);
        // notificationRules.siteId intentionally gets no backfill — see the
        // column's doc comment. Existing rows stay null (org-wide).
        await m.addColumn(notificationRules, notificationRules.siteId);
      }
      if (from < 14) {
        await m.createTable(triggerNotifications);
      }
      if (from < 15) {
        await m.createTable(thirdPartyContacts);
      }
      if (from < 16) {
        await m.addColumn(equipmentInstances, equipmentInstances.active);
      }
      if (from < 17) {
        await m.addColumn(
          triggerNotifications,
          triggerNotifications.originTargetRoleTier,
        );
        await m.addColumn(
          triggerNotifications,
          triggerNotifications.escalatedAt,
        );
      }
      if (from < 18) {
        await m.addColumn(taskTemplates, taskTemplates.priority);
      }
      if (from < 19) {
        await m.addColumn(users, users.active);
        await m.addColumn(users, users.deactivatedAt);
        await m.addColumn(users, users.deactivatedByUserId);
      }
      if (from < 20) {
        await m.createTable(taskPresets);
        await m.createTable(taskPresetItems);
      }
      if (from < 21) {
        // Three-tier (top/mid/base) -> five-tier (base/supervisor/
        // venueManager/regional/executive) remap (Sprint 027). Default
        // mapping: mid->venueManager, top->executive — the closer of each
        // pair's two plausible new homes; correctable per-user afterward
        // via UserRepository.changeRoleTier(). Every place RoleTier is
        // persisted as a string needs the same remap, not just Users.
        await (update(users)..where((u) => u.roleTier.equals('mid'))).write(
          const UsersCompanion(roleTier: Value('venueManager')),
        );
        await (update(users)..where((u) => u.roleTier.equals('top'))).write(
          const UsersCompanion(roleTier: Value('executive')),
        );
        await (update(
          notificationRules,
        )..where((r) => r.targetRoleTier.equals('mid'))).write(
          const NotificationRulesCompanion(
            targetRoleTier: Value('venueManager'),
          ),
        );
        await (update(
          notificationRules,
        )..where((r) => r.targetRoleTier.equals('top'))).write(
          const NotificationRulesCompanion(
            targetRoleTier: Value('executive'),
          ),
        );
        await (update(
          notificationRules,
        )..where((r) => r.setByTier.equals('mid'))).write(
          const NotificationRulesCompanion(setByTier: Value('venueManager')),
        );
        await (update(
          notificationRules,
        )..where((r) => r.setByTier.equals('top'))).write(
          const NotificationRulesCompanion(setByTier: Value('executive')),
        );
        await (update(
          triggerNotifications,
        )..where((t) => t.originTargetRoleTier.equals('mid'))).write(
          const TriggerNotificationsCompanion(
            originTargetRoleTier: Value('venueManager'),
          ),
        );
        await (update(
          triggerNotifications,
        )..where((t) => t.originTargetRoleTier.equals('top'))).write(
          const TriggerNotificationsCompanion(
            originTargetRoleTier: Value('executive'),
          ),
        );
        // applicableRoleTiers is a comma-joined list (e.g. "base,mid"), not
        // a single value, so it needs a read-modify-write per row rather
        // than a WHERE-equals UPDATE.
        final allTemplates = await select(taskTemplates).get();
        for (final row in allTemplates) {
          final tiers = row.applicableRoleTiers
              .split(',')
              .map((t) {
                if (t == 'mid') return 'venueManager';
                if (t == 'top') return 'executive';
                return t;
              })
              .join(',');
          if (tiers != row.applicableRoleTiers) {
            await (update(
              taskTemplates,
            )..where((t) => t.id.equals(row.id))).write(
              TaskTemplatesCompanion(applicableRoleTiers: Value(tiers)),
            );
          }
        }
      }
      if (from < 22) {
        await m.createTable(venueTypes);
        await m.createTable(siteVenueTypes);
        await m.createTable(equipmentTypeVenueTypes);
        await m.createTable(taskPresetVenueTypes);
        await m.createTable(taskTemplateVenueTypes);
      }
      if (from < 23) {
        await m.addColumn(legalLimitReferences, legalLimitReferences.basis);
        await m.addColumn(
          legalLimitReferences,
          legalLimitReferences.verifiedAt,
        );
        await m.addColumn(
          legalLimitReferences,
          legalLimitReferences.verifiedByUserId,
        );
        // The 3 pre-existing rows all get the compile-time default ('fsa')
        // from the addColumn above — correct their real basis explicitly
        // rather than leaving fridge/hot-hold mislabelled as guidance when
        // they're actually law. Matches HORECA_TASK_LIBRARY.md's sourcing
        // note exactly.
        await (update(
          legalLimitReferences,
        )..where((r) => r.category.equals('fridge_temp'))).write(
          const LegalLimitReferencesCompanion(basis: Value('law')),
        );
        await (update(
          legalLimitReferences,
        )..where((r) => r.category.equals('freezer_temp'))).write(
          const LegalLimitReferencesCompanion(basis: Value('fsa')),
        );
        await (update(
          legalLimitReferences,
        )..where((r) => r.category.equals('hot_hold_temp'))).write(
          const LegalLimitReferencesCompanion(basis: Value('law')),
        );
      }
    },
    beforeOpen: (details) async {
      // Runs first — user seeding below needs a real site id to seed into.
      final defaultSiteId = await _ensureDefaultOrganisationAndSite();

      final existingUsers = await select(users).get();
      if (existingUsers.isEmpty) {
        await _seedUsers(defaultSiteId);
      }

      // Always ensured (not gated on "table empty"), so an existing install
      // that only has the original 3 equipment types picks up the rest too.
      await _ensureExpandedEquipmentTypes();

      // Always ensured, same pattern as equipment types above.
      await _ensureVenueTypes();

      final existingLegalLimits = await select(legalLimitReferences).get();
      if (existingLegalLimits.isEmpty) {
        await _seedTaskLibraryReferenceData();
      }

      // One illustrative preset so the feature is demonstrable before the
      // real task library (Sprint 027) populates presets for real. Gated on
      // the presets table being empty.
      final existingPresets = await select(taskPresets).get();
      if (existingPresets.isEmpty) {
        await _seedExamplePreset();
      }

      // Always ensured (checked by title/name, not gated on "table empty")
      // — Sprint 030, Build Order item 4, Cluster A (Food Safety & Temp,
      // Allergen Management, Personal Hygiene & PPE, Refrigeration & Cold
      // Storage equipment condition — HORECA_TASK_LIBRARY.md segments 1-4).
      await _seedTaskLibraryClusterA();

      // Cluster B (Sprint 030 follow-up): Segments 5-6 — Cooking Line
      // Equipment, Wash-up/Dishwash. Same always-ensured pattern.
      await _seedTaskLibraryClusterB();

      // Cluster C (Sprint 030 follow-up): Segments 7-10 — Cleaning &
      // Sanitation, Cleaning Chemicals & Consumables, Dry & Ambient
      // Storage, Deliveries & Goods In. Same always-ensured pattern.
      await _seedTaskLibraryClusterC();

      // Cluster D (Sprint 030 follow-up): Segments 11-14 — Utilities &
      // Safety, Waste & Pest Control, Preventive Maintenance, Stock
      // Control. Same always-ensured pattern.
      await _seedTaskLibraryClusterD();

      // Cluster E (Sprint 030 follow-up): Segments 15-17 — Opening
      // Procedures, Closing Procedures, Service Readiness. Same
      // always-ensured pattern.
      await _seedTaskLibraryClusterE();

      // Cluster F (Sprint 030 follow-up, FINAL CLUSTER): Segments 18-21 —
      // Front of House / Service, Bar & Beverage, Hotel-Specific,
      // Management & Compliance Oversight. Completes Build Order item 4.
      await _seedTaskLibraryClusterF();

      // Idempotent — safe on every open. Only touches rows left over from
      // before siteId existed (nothing to do on a fresh install).
      await _backfillSiteIds(defaultSiteId);
    },
  );

  Future<void> _seedUsers(int siteId) async {
    await _insertSeedUser(
      name: 'Steve Hughes',
      jobTitle: 'Kitchen Porter',
      roleTier: 'base',
      pin: '1111',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Aisha Khan',
      jobTitle: 'Line Chef',
      roleTier: 'base',
      pin: '2222',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Marta Nowak',
      jobTitle: 'Prep Chef',
      roleTier: 'base',
      pin: '3333',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Lewis Grant',
      jobTitle: 'Sous Chef',
      roleTier: 'base',
      pin: '4444',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Elena Petrov',
      jobTitle: 'Commis Chef',
      roleTier: 'base',
      pin: '5555',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Samir Ali',
      jobTitle: 'Grill Chef',
      roleTier: 'base',
      pin: '6666',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Priya Shah',
      jobTitle: 'Duty Manager',
      roleTier: 'supervisor',
      pin: '8888',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Jordan Blake',
      jobTitle: 'Head Chef / Kitchen Manager',
      roleTier: 'venueManager',
      pin: '9999',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Marcus Webb',
      jobTitle: 'Regional Manager',
      roleTier: 'regional',
      pin: '5678',
      siteId: siteId,
    );
    await _insertSeedUser(
      name: 'Alex Rivera',
      jobTitle: 'Director / MD',
      roleTier: 'executive',
      pin: '7777',
      siteId: siteId,
    );
  }

  Future<void> _insertSeedUser({
    required String name,
    required String jobTitle,
    required String roleTier,
    required String pin,
    required int siteId,
  }) {
    final salt = generateSalt();
    return into(users).insert(
      UsersCompanion.insert(
        name: name,
        jobTitle: jobTitle,
        roleTier: roleTier,
        pinHash: hashPin(pin, salt),
        pinSalt: salt,
        siteId: Value(siteId),
      ),
    );
  }

  // Original 18: derived from the real venue checklist ("Full check
  // list.docx") plus the original 3 test rows — realistic commercial-
  // kitchen equipment coverage, not an exhaustive catalogue.
  //
  // Sprint 028 expansion (below the original 18): from
  // HORECA_EQUIPMENT_AND_VENUES.md Part A, covering the ALL-HoReCa target
  // market's gaps (beverage, prep machinery, bakery, cold-storage
  // variants, wash-up, ventilation/safety, non-refrigerated storage) that
  // the original checklist-derived 18 didn't need. Two of the doc's own
  // "Bold = likely already in your 18" / "(NEW)" markings didn't match
  // the real list on inspection — "Walk-in freezer" was marked (NEW) but
  // is already in the original 18 (skipped here, not duplicated); "Display
  // / serve-over fridge" was marked bold/existing but isn't actually
  // present (added here as "Serve-Over Fridge"). Names condensed to
  // Title Case with no slashes/parentheses, matching the existing list's
  // style — e.g. "Prep/counter fridge (refrigerated prep table /
  // saladette)" -> "Prep Fridge".
  //
  // Managers can still add anything missing via the wizard's
  // "Something else..." option.
  static const _expandedEquipmentTypeNames = [
    'Fridge',
    'Freezer',
    'Hot-hold unit',
    'Blast Chiller',
    'Walk-in Fridge',
    'Walk-in Freezer',
    'Fryer',
    'Oven',
    'Grill',
    'Salamander',
    'Hob',
    'Rotisserie',
    'Kebab Machine',
    'Bain-marie',
    'Steamer',
    'Dishwasher',
    'Ice Machine',
    'Prep Station',
    // Cold storage / refrigeration
    'Prep Fridge',
    'Undercounter Fridge',
    'Serve-Over Fridge',
    'Refrigerated Display Case',
    'Back-Bar Fridge',
    'Gelato Dipping Cabinet',
    // Cooking — hot line
    'Deck Oven',
    'Conveyor Oven',
    'Pizza Oven',
    'Griddle',
    'Pressure Fryer',
    'Bratt Pan',
    'Boiling Pan',
    'Wok Range',
    'Microwave',
    'Sous-Vide Bath',
    'Induction Hob',
    // Holding / warming
    'Heated Gantry',
    'Proving Cabinet',
    'Soup Kettle',
    // Prep / processing
    'Food Processor',
    'Planetary Mixer',
    'Slicer',
    'Mincer',
    'Dough Sheeter',
    'Blender',
    'Vacuum Packer',
    // Wash-up / warewashing
    'Glasswasher',
    'Conveyor Dishwasher',
    'Pot Wash Sink',
    'Hand-Wash Sink',
    // Beverage
    'Coffee Machine',
    'Filter Brewer',
    'Post-Mix System',
    'Cellar Cooler',
    'Keg System',
    'Water Boiler',
    'Juicer',
    'Slush Machine',
    // Ventilation / utilities / safety
    'Extraction Canopy',
    'Grease Trap',
    'Gas Interlock System',
    'Fire Suppression System',
    // Storage (non-refrigerated)
    'Dry Store Area',
    'Chemical Store',
  ];

  Future<void> _ensureExpandedEquipmentTypes() async {
    final existingNames = (await select(
      equipmentTypes,
    ).get()).map((row) => row.name).toSet();

    for (final name in _expandedEquipmentTypeNames) {
      if (!existingNames.contains(name)) {
        await into(
          equipmentTypes,
        ).insert(EquipmentTypesCompanion.insert(name: name));
      }
    }
  }

  // 12 core venue types from HORECA_EQUIPMENT_AND_VENUES.md Part B. Fixed
  // list (not manager-editable/retirable), matching EquipmentType — managers
  // can add a custom type via the "Something else..." escape hatch on the
  // tagging UI instead.
  static const _venueTypeNames = [
    'Quick Service (QSR)',
    'Fast Casual',
    'Casual Dining',
    'Fine Dining',
    'Café',
    'Bakery / Patisserie',
    'Bar / Pub',
    'Gastropub',
    'Hotel',
    'Contract / Institutional Catering',
    'Event / Mobile / Street Food',
    'Dark / Ghost Kitchen',
  ];

  Future<void> _ensureVenueTypes() async {
    final existingNames = (await select(
      venueTypes,
    ).get()).map((row) => row.name).toSet();

    for (final name in _venueTypeNames) {
      if (!existingNames.contains(name)) {
        await into(venueTypes).insert(VenueTypesCompanion.insert(name: name));
      }
    }
  }

  Future<void> _seedTaskLibraryReferenceData() async {
    final fridgeType = await (select(
      equipmentTypes,
    )..where((t) => t.name.equals('Fridge'))).getSingle();

    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'fridge_temp',
        legalMax: const Value(8.0),
        unit: 'celsius',
        basis: const Value('law'),
      ),
    );
    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'freezer_temp',
        legalMax: const Value(-18.0),
        unit: 'celsius',
        basis: const Value('fsa'),
      ),
    );
    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: 'hot_hold_temp',
        legalMin: const Value(63.0),
        unit: 'celsius',
        basis: const Value('law'),
      ),
    );

    final templateId = await into(taskTemplates).insert(
      TaskTemplatesCompanion.insert(
        templateGroupId: 0,
        versionNumber: 1,
        title: 'Check Fridge Temperature',
        segment: 'food_safety',
        applicableRoleTiers: 'base',
        // 'data_photo' = the checklist's "Data + Photo" method (Sprint 023
        // vocabulary reconciliation) — a numeric reading plus required photo.
        method: 'data_photo',
        requiresPhoto: const Value(true),
        minLimit: const Value(2.0),
        maxLimit: const Value(8.0),
        unit: const Value('celsius'),
        legalLimitCategory: const Value('fridge_temp'),
        isCritical: const Value(true),
        priority: const Value('critical'),
        requiresCorrectiveActionOnFail: const Value(true),
        fixInstructions: const Value(
          'Move stock to a working fridge and contact management immediately.',
        ),
        equipmentTypeId: Value(fridgeType.id),
        createdAt: DateTime.now(),
      ),
    );
    await (update(
      taskTemplates,
    )..where((t) => t.id.equals(templateId))).write(
      TaskTemplatesCompanion(templateGroupId: Value(templateId)),
    );
  }

  // One illustrative preset ("Standard Fridge Tasks") wrapping the seeded
  // fridge-temperature template — mirrors this project's precedent of one
  // small demonstrable example per foundational sprint (Sprint 003's demo
  // staff, Sprint 007's one template). Skips silently if the seeded fridge
  // type or template isn't present, rather than assuming they are.
  Future<void> _seedExamplePreset() async {
    final fridgeType = await (select(
      equipmentTypes,
    )..where((t) => t.name.equals('Fridge'))).getSingleOrNull();
    if (fridgeType == null) return;

    final fridgeTemplate = await (select(
      taskTemplates,
    )..where((t) => t.title.equals('Check Fridge Temperature'))).getSingleOrNull();
    if (fridgeTemplate == null) return;

    final presetId = await into(taskPresets).insert(
      TaskPresetsCompanion.insert(
        name: 'Standard Fridge Tasks',
        equipmentTypeId: Value(fridgeType.id),
        createdAt: DateTime.now(),
      ),
    );
    await into(taskPresetItems).insert(
      TaskPresetItemsCompanion.insert(
        presetId: presetId,
        taskTemplateGroupId: fridgeTemplate.templateGroupId,
        defaultFrequency: 'daily',
      ),
    );
  }

  // Maps HORECA_TASK_LIBRARY.md segments to which of the 12 seeded venue
  // types their tasks are tagged with (Sprint 030). Per
  // HORECA_EQUIPMENT_AND_VENUES.md Part B's applicability matrix: Personal
  // Hygiene/PPE is check-marked for every matrix column (genuinely
  // universal); Food Safety & Temp and Allergen include a "sometimes" (~)
  // for Bar/Pub, which still counts as tagged since tags are a
  // default-offering aid, not a lockout (a café that happens to have a
  // fryer can still add fryer tasks manually — the same logic applies in
  // reverse). Refrigeration & Cold Storage (equipment condition) has no
  // separate matrix row, so it's aliased to Food Safety & Temp's row — same
  // working area. Cluster A's 4 segments all resolve to all 12 venue types,
  // so this cluster produces no differentiation between venue types — that
  // is expected, not a bug. Filtering value shows up starting with more
  // venue-specific clusters (Bar & Beverage, Hotel-Specific, Fryer/Oil,
  // Front of House).
  // Sprint 030 Cluster B: all 12 venue types except 'Event / Mobile / Street
  // Food'. Confirmed before building — the matrix gives Fryer/Oil (segment
  // 5.1) a stricter row (explicit ✗ for Bar/Pub) than general Cooking Line
  // Equipment (5.2/5.3, only "sometimes" for Bar/Pub), but per the agreed
  // simpler default, all of segment 5 (including fryer/oil) uses ONE tag
  // set — the more permissive "Cooking line equip" row — rather than
  // splitting the segment. Event/Mobile/Street Food is excluded from both
  // `cooking_line_equipment` and `washup_dishwash` per the agreed reading of
  // this venue type's reduced subset (food safety, hygiene, cleaning,
  // deliveries, waste only) — confirmed rather than assumed, since the
  // matrix itself marks Wash-up as universal and this required a real
  // interpretive call.
  static const _clusterBVenueTypeNames = [
    'Quick Service (QSR)',
    'Fast Casual',
    'Casual Dining',
    'Fine Dining',
    'Café',
    'Bakery / Patisserie',
    'Bar / Pub',
    'Gastropub',
    'Hotel',
    'Contract / Institutional Catering',
    'Dark / Ghost Kitchen',
  ];

  // Sprint 030 Cluster C: both `cleaning_sanitation` and `deliveries_goods_in`
  // are fully universal in the matrix (✓ across every column, no ~ or ✗ at
  // all) — all 12. `cleaning_chemicals` has no separate matrix row; per two
  // decisions confirmed before building: Event/Mobile/Street Food IS tagged
  // for it (chemicals are tightly coupled to the cleaning tasks already in
  // its reduced subset, unlike the looser fryer/wash-up pairings), so
  // `cleaning_chemicals` also gets all 12. `dry_ambient_storage` (also no
  // matrix row) keeps Event/Mobile/Street Food excluded — confirmed to stay
  // within the venue type's originally-defined reduced subset, consistent
  // with the doc's own "compact, portable" framing — so it reuses
  // `_clusterBVenueTypeNames` (11 of 12).
  // Sprint 030 Cluster D: `utilities_safety`, `waste_pest_control`, and
  // `stock_control` all get all 12 — `waste_pest_control` because "waste"
  // was explicitly named in Event/Mobile/Street Food's original reduced
  // subset (no ambiguity); `utilities_safety` and `stock_control` per two
  // decisions confirmed before building (utilities: the doc's own venue
  // description names "handwash challenges" for this venue type, which is
  // literally part of this segment; stock control: closely related to
  // deliveries, already in scope, and universal in practice).
  // `preventive_maintenance` (also no separate matrix row) keeps
  // Event/Mobile/Street Food excluded — confirmed as a fixed-premises
  // compliance concept (certificates/contracted inspections tied to a
  // location) that doesn't naturally fit a mobile/temporary setup, and it
  // wasn't in the original subset — reuses `_clusterBVenueTypeNames`.
  // Sprint 030 Cluster F: `front_of_house` excludes both Dark/Ghost Kitchen
  // (mechanical — matches the already-established "QSR/Restaurant minus FOH
  // and Bar" derivation, the first time that exclusion actually applies)
  // and Event/Mobile/Street Food (confirmed before building — a mobile
  // setup doesn't typically have a "dining area" or "customer toilets" in
  // the traditional sense). 10 of 12.
  static const _clusterFFrontOfHouseVenueTypeNames = [
    'Quick Service (QSR)',
    'Fast Casual',
    'Casual Dining',
    'Fine Dining',
    'Café',
    'Bakery / Patisserie',
    'Bar / Pub',
    'Gastropub',
    'Hotel',
    'Contract / Institutional Catering',
  ];

  // `bar_beverage`: QSR and Bakery are hard-excluded by the matrix's own
  // explicit ✗; Dark/Ghost Kitchen excluded per the established "minus Bar"
  // derivation; Event/Mobile/Street Food excluded, confirmed before
  // building (cellar/keg/optics infrastructure doesn't fit a typical mobile
  // setup — the least ambiguous of this cluster's Event/Mobile calls). 8 of
  // 12: Fast Casual and Gastropub still tagged via their union derivation
  // (Fast Casual = QSR∪Restaurant, Restaurant is tagged; Gastropub =
  // Restaurant∪Bar, both tagged).
  static const _clusterFBarBeverageVenueTypeNames = [
    'Fast Casual',
    'Casual Dining',
    'Fine Dining',
    'Café',
    'Bar / Pub',
    'Gastropub',
    'Hotel',
    'Contract / Institutional Catering',
  ];

  // `hotel_specific`: the matrix marks every column except Hotel itself as
  // an explicit ✗ — the most restrictive row in the whole doc. All 4
  // derived venue types clearly don't apply either (none reduce to Hotel).
  // Mechanically unambiguous, not a judgment call. 1 of 12.
  static const _clusterFHotelSpecificVenueTypeNames = ['Hotel'];

  static const _segmentVenueTypeNames = <String, List<String>>{
    'food_safety': _venueTypeNames,
    'allergen': _venueTypeNames,
    'personal_hygiene_ppe': _venueTypeNames,
    'refrigeration_cold_storage': _venueTypeNames,
    'cooking_line_equipment': _clusterBVenueTypeNames,
    'washup_dishwash': _clusterBVenueTypeNames,
    'cleaning_sanitation': _venueTypeNames,
    'cleaning_chemicals': _venueTypeNames,
    'dry_ambient_storage': _clusterBVenueTypeNames,
    'deliveries_goods_in': _venueTypeNames,
    'utilities_safety': _venueTypeNames,
    'waste_pest_control': _venueTypeNames,
    'preventive_maintenance': _clusterBVenueTypeNames,
    'stock_control': _venueTypeNames,
    // Sprint 030 Cluster E: `opening_procedures`, `closing_procedures`, and
    // `service_readiness` have no matrix row and weren't named in
    // Event/Mobile/Street Food's original reduced subset — confirmed before
    // building to include it anyway, since these are operational/temporal
    // concepts (opening, closing, prepping for service) relevant to any
    // venue with a trading day or service period, including mobile ones.
    // All three get all 12.
    'opening_procedures': _venueTypeNames,
    'closing_procedures': _venueTypeNames,
    'service_readiness': _venueTypeNames,
    'front_of_house': _clusterFFrontOfHouseVenueTypeNames,
    'bar_beverage': _clusterFBarBeverageVenueTypeNames,
    'hotel_specific': _clusterFHotelSpecificVenueTypeNames,
    // Sprint 030 Cluster F: `management_compliance_oversight` has no matrix
    // row; confirmed before building to include Event/Mobile/Street Food —
    // compliance oversight (EHO readiness, staff training, food safety
    // review) applies to any food business regardless of size or format,
    // arguably more universal than the operational segments already
    // included. All 12.
    'management_compliance_oversight': _venueTypeNames,
  };

  // Cluster A (Sprint 030): HORECA_TASK_LIBRARY.md Segments 1-4 — Food
  // Safety & Temperature Control, Allergen Management, Personal Hygiene &
  // PPE, Refrigeration & Cold Storage (equipment condition). 36 tasks.
  //
  // Field mapping notes:
  // - `Base`/`Mid` role tags map to `[base]` / `[supervisor, venueManager]`
  //   respectively (agreed default — paired groups matching Sprint 027's
  //   ManagerScreen grouping, not a single-tier collapse).
  // - Method vocabulary gained two values this sprint: `data` (plain
  //   numeric reading, no tick/photo) and `data_note` (unused in Cluster A
  //   itself, added now for later clusters).
  // - Frequency vocabulary gained `twoXDaily`, `perService`, `monthly`.
  // - Where the source gives both a [LAW]/[FSA] hard limit and a secondary
  //   "target" figure (e.g. fridge 8°C legal max + 5°C FSA target), only
  //   the primary hard limit becomes the structured minLimit/maxLimit; the
  //   secondary target and its basis tag are folded into `fixInstructions`
  //   text, since the schema has no concept of a second, softer threshold.
  // - Cooked/reheated core temperature and the cooling log are genuinely
  //   temperature-AND-time limits (e.g. "70°C for 2 min"); this app only
  //   captures a single Data reading, so only the temperature threshold is
  //   structured — the time component is explained in `fixInstructions`,
  //   not enforced. A known, disclosed simplification, not new to this
  //   sprint (the app has never modeled duration-at-temperature).
  // - England/Wales/NI figures are stored as the real limit where England
  //   and Scotland diverge (reheat, high-risk cooking core); Scotland's
  //   stricter [LAW] figure is noted in `fixInstructions` text only — there
  //   is no jurisdiction concept in the schema (accepted limitation, agreed
  //   in the Sprint 030 plan).
  // - "Display/serve-over fridge temperature"'s equipment is mapped to the
  //   more specific "Serve-Over Fridge" type (added in Sprint 028
  //   specifically anticipating this task) rather than the source's terser
  //   "Fridge" tag in its equipment column — a judgment call favoring the
  //   task's own title over the column's shorthand, not a literal
  //   transcription.
  static const _clusterATasks = [
    // 1.1 Refrigeration temperatures
    _LibraryTask(
      title: 'Fridge temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'fridge_temp',
      fixInstructions:
          'Legal max 8°C [LAW]; FSA target 5°C [FSA]. Move stock to a '
          'working fridge and contact management immediately if exceeded.',
      frequency: 'threeXDaily',
    ),
    _LibraryTask(
      title: 'Freezer temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Freezer',
      roleTiers: ['base'],
      maxLimit: -18.0,
      unit: 'celsius',
      legalLimitCategory: 'freezer_temp',
      fixInstructions:
          'FSA standard: freezer should read -18°C or below [FSA]. Check '
          'door seal and consider moving stock if above.',
      frequency: 'twoXDaily',
    ),
    _LibraryTask(
      title: 'Walk-in cold room temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Walk-in Fridge',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'fridge_temp',
      fixInstructions:
          'Legal max 8°C [LAW]; FSA target 5°C [FSA]. Move stock to a '
          'working unit and contact management immediately if exceeded.',
      frequency: 'threeXDaily',
    ),
    _LibraryTask(
      title: 'Blast chiller cycle temperature',
      segment: 'food_safety',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Blast Chiller',
      roleTiers: ['base'],
      fixInstructions:
          'Part of the cooked-to-chilled cooling process — see the Cooling '
          'log task for the 90-minute rule [FSA].',
      frequency: 'perUse',
    ),
    _LibraryTask(
      title: 'Display/serve-over fridge temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Serve-Over Fridge',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'fridge_temp',
      fixInstructions:
          'Legal max 8°C [LAW]; FSA target 5°C [FSA]. Move stock to a '
          'working fridge and contact management immediately if exceeded.',
      frequency: 'perService',
    ),
    // 1.2 Cooking, reheating & cooling
    _LibraryTask(
      title: 'Cooked food core temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      roleTiers: ['base'],
      minLimit: 70.0,
      unit: 'celsius',
      legalLimitCategory: 'cooked_core_temp',
      fixInstructions:
          'Core must reach 70°C for 2 min, or equivalent e.g. 75°C for 30s '
          '[FSA]. Scotland: 75°C/30s required by law for high-risk foods '
          '[LAW]. This app records a single reading, not time-at-'
          'temperature — use a calibrated probe and confirm the hold time '
          'manually.',
      frequency: 'perBatch',
    ),
    _LibraryTask(
      title: 'Reheated food core temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      roleTiers: ['base'],
      minLimit: 70.0,
      unit: 'celsius',
      legalLimitCategory: 'reheated_core_temp',
      fixInstructions:
          'England/Wales/NI: reheat to approximately 70°C for 2 min [FSA]. '
          'Scotland: 82°C required by law [LAW]. This app records a single '
          'reading, not time-at-temperature.',
      frequency: 'perBatch',
    ),
    _LibraryTask(
      title: 'Hot-holding temperature',
      segment: 'food_safety',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Bain-marie',
      roleTiers: ['base'],
      minLimit: 63.0,
      unit: 'celsius',
      legalLimitCategory: 'hot_hold_temp',
      fixInstructions:
          'Must hold at 63°C or above [LAW]. Below 63°C, a single 2-hour '
          'time-control window applies before food must be discarded or '
          'used.',
      frequency: 'twoXPerService',
    ),
    _LibraryTask(
      title: 'Cooling log (cooked to chilled)',
      segment: 'food_safety',
      method: 'data_tick',
      priority: 'critical',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'cooling_temp',
      fixInstructions:
          "Must cool from cooked to below 8°C within 90 minutes [FSA] (the "
          "'90-minute rule').",
      frequency: 'perBatch',
    ),
    _LibraryTask(
      title: 'Reheat-once verification',
      segment: 'food_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      fixInstructions:
          '[FSA] guidance: reheat food once only — do not reheat leftovers '
          'a second time.',
      frequency: 'perBatch',
    ),
    _LibraryTask(
      title: 'Probe calibration check',
      segment: 'food_safety',
      method: 'data_tick',
      priority: 'high',
      roleTiers: ['base'],
      fixInstructions:
          '[BEST] Check probe reads 0°C in melting ice and 100°C in '
          'boiling water, both within ±1°C. No UK legal figure — an '
          'industry best-practice calibration check.',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Probe sanitised between uses',
      segment: 'food_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perUse',
    ),
    // 1.3 Date marking & rotation
    _LibraryTask(
      title: 'Use-by / best-before date check',
      segment: 'food_safety',
      method: 'tick_note',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'FIFO stock rotation',
      segment: 'food_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Opened-product date labelling',
      segment: 'food_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      fixInstructions: '[FSA] Date-mark products on opening.',
      frequency: 'perUse',
    ),
    _LibraryTask(
      title: 'Controlled defrost log',
      segment: 'food_safety',
      method: 'data_tick',
      priority: 'high',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'defrost_temp',
      fixInstructions:
          '[FSA] Thaw under refrigeration so the product stays at or below '
          '8°C throughout.',
      frequency: 'perUse',
    ),
    // Segment 2 — Allergen Management
    _LibraryTask(
      title: 'Allergen matrix current & accessible',
      segment: 'allergen',
      method: 'tick',
      priority: 'critical',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          "[LAW] Must cover all 14 legally-defined allergens (Food "
          "Information Regulations / Natasha's Law).",
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Allergen review on new/changed dishes',
      segment: 'allergen',
      method: 'note',
      priority: 'critical',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'eventBased',
    ),
    _LibraryTask(
      title: "PPDS labelling correct (Natasha's Law)",
      segment: 'allergen',
      method: 'tick_photo',
      priority: 'critical',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[LAW] Pre-packed for direct sale (PPDS) items need a full '
          "ingredient list with the 14 allergens emphasised (Natasha's "
          'Law).',
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Separate allergen prep area/equipment',
      segment: 'allergen',
      method: 'tick',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'perUse',
    ),
    _LibraryTask(
      title: 'Allergen-free order verified end-to-end',
      segment: 'allergen',
      method: 'tick_note',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'eventBased',
    ),
    _LibraryTask(
      title: 'Purple allergen boards/cloths used',
      segment: 'allergen',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perUse',
    ),
    _LibraryTask(
      title: 'Staff allergen briefing',
      segment: 'allergen',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'perShift',
    ),
    // Segment 3 — Personal Hygiene & PPE
    _LibraryTask(
      title: 'Handwashing on entry / between tasks',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Clean uniform / apron',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Hair covering / beard net',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'No jewellery / false nails',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Fitness-to-work / illness declaration',
      segment: 'personal_hygiene_ppe',
      method: 'tick_note',
      priority: 'critical',
      roleTiers: ['base'],
      fixInstructions:
          '[FSA] Staff must be symptom-free for 48 hours before returning '
          'to work after vomiting/diarrhoea illness.',
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Cuts covered (blue plaster)',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Gloves available & changed appropriately',
      segment: 'personal_hygiene_ppe',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    // Segment 4 — Refrigeration & Cold Storage (equipment condition)
    _LibraryTask(
      title: 'Fridge door seal intact',
      segment: 'refrigeration_cold_storage',
      method: 'tick',
      priority: 'high',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Freezer ice build-up check',
      segment: 'refrigeration_cold_storage',
      method: 'tick_note',
      priority: 'standard',
      equipmentTypeName: 'Freezer',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Walk-in shelving clean & sound',
      segment: 'refrigeration_cold_storage',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Walk-in Fridge',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Condenser / vents dust-free',
      segment: 'refrigeration_cold_storage',
      method: 'tick_photo',
      priority: 'standard',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'Fridge/freezer alarm functioning',
      segment: 'refrigeration_cold_storage',
      method: 'tick',
      priority: 'high',
      equipmentTypeName: 'Fridge',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Not overloaded (airflow)',
      segment: 'refrigeration_cold_storage',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
  ];

  // Equipment-tagged tasks bundle into that equipment's preset; tasks
  // without an equipment tag bundle into their segment's preset instead.
  // Distinct names from Sprint 026's "Standard Fridge Tasks" so the two
  // coexist rather than colliding on the by-name idempotency check (agreed
  // — the old illustrative example is left in place, not retired).
  static const _clusterAPresets = [
    _LibraryPreset(
      name: 'Fridge Tasks',
      equipmentTypeName: 'Fridge',
      itemTitles: [
        'Fridge temperature',
        'Fridge door seal intact',
        'Condenser / vents dust-free',
        'Fridge/freezer alarm functioning',
        'Not overloaded (airflow)',
      ],
    ),
    _LibraryPreset(
      name: 'Freezer Tasks',
      equipmentTypeName: 'Freezer',
      itemTitles: ['Freezer temperature', 'Freezer ice build-up check'],
    ),
    _LibraryPreset(
      name: 'Walk-in Fridge Tasks',
      equipmentTypeName: 'Walk-in Fridge',
      itemTitles: [
        'Walk-in cold room temperature',
        'Walk-in shelving clean & sound',
      ],
    ),
    _LibraryPreset(
      name: 'Blast Chiller Tasks',
      equipmentTypeName: 'Blast Chiller',
      itemTitles: ['Blast chiller cycle temperature'],
    ),
    _LibraryPreset(
      name: 'Serve-Over Fridge Tasks',
      equipmentTypeName: 'Serve-Over Fridge',
      itemTitles: ['Display/serve-over fridge temperature'],
    ),
    _LibraryPreset(
      name: 'Bain-marie Tasks',
      equipmentTypeName: 'Bain-marie',
      itemTitles: ['Hot-holding temperature'],
    ),
    _LibraryPreset(
      name: 'Food Safety Tasks',
      segment: 'food_safety',
      itemTitles: [
        'Cooked food core temperature',
        'Reheated food core temperature',
        'Cooling log (cooked to chilled)',
        'Reheat-once verification',
        'Probe calibration check',
        'Probe sanitised between uses',
        'Use-by / best-before date check',
        'FIFO stock rotation',
        'Opened-product date labelling',
        'Controlled defrost log',
      ],
    ),
    _LibraryPreset(
      name: 'Allergen Management Tasks',
      segment: 'allergen',
      itemTitles: [
        'Allergen matrix current & accessible',
        'Allergen review on new/changed dishes',
        "PPDS labelling correct (Natasha's Law)",
        'Separate allergen prep area/equipment',
        'Allergen-free order verified end-to-end',
        'Purple allergen boards/cloths used',
        'Staff allergen briefing',
      ],
    ),
    _LibraryPreset(
      name: 'Personal Hygiene & PPE Tasks',
      segment: 'personal_hygiene_ppe',
      itemTitles: [
        'Handwashing on entry / between tasks',
        'Clean uniform / apron',
        'Hair covering / beard net',
        'No jewellery / false nails',
        'Fitness-to-work / illness declaration',
        'Cuts covered (blue plaster)',
        'Gloves available & changed appropriately',
      ],
    ),
  ];

  Future<void> _ensureLegalLimitReference({
    required String category,
    double? minLimit,
    double? maxLimit,
    required String unit,
    required String basis,
  }) async {
    final existing = await (select(
      legalLimitReferences,
    )..where((r) => r.category.equals(category))).getSingleOrNull();
    if (existing != null) return;

    await into(legalLimitReferences).insert(
      LegalLimitReferencesCompanion.insert(
        category: category,
        legalMin: Value(minLimit),
        legalMax: Value(maxLimit),
        unit: unit,
        basis: Value(basis),
      ),
    );
  }

  Future<void> _seedTaskLibraryClusterA() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    await _ensureLegalLimitReference(
      category: 'cooked_core_temp',
      minLimit: 70.0,
      unit: 'celsius',
      basis: 'fsa',
    );
    await _ensureLegalLimitReference(
      category: 'reheated_core_temp',
      minLimit: 70.0,
      unit: 'celsius',
      basis: 'fsa',
    );
    await _ensureLegalLimitReference(
      category: 'cooling_temp',
      maxLimit: 8.0,
      unit: 'celsius',
      basis: 'fsa',
    );
    await _ensureLegalLimitReference(
      category: 'defrost_temp',
      maxLimit: 8.0,
      unit: 'celsius',
      basis: 'fsa',
    );

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterATasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    // Re-read fresh so presets can look up every task's templateGroupId,
    // whether it was just created above or already existed from a prior
    // partial run.
    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterATasks) task.title: task.frequency,
    };
    final existingPresetNames = (await select(
      taskPresets,
    ).get()).map((row) => row.name).toSet();

    for (final preset in _clusterAPresets) {
      if (existingPresetNames.contains(preset.name)) continue;

      final equipmentTypeId = preset.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[preset.equipmentTypeName];

      final presetId = await into(taskPresets).insert(
        TaskPresetsCompanion.insert(
          name: preset.name,
          equipmentTypeId: Value(equipmentTypeId),
          segment: Value(preset.segment),
          createdAt: DateTime.now(),
        ),
      );

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        await into(taskPresetItems).insert(
          TaskPresetItemsCompanion.insert(
            presetId: presetId,
            taskTemplateGroupId: groupId,
            defaultFrequency: frequency,
          ),
        );

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      for (final vtId in memberVenueTypeIds) {
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  // Cluster B (Sprint 030 follow-up): HORECA_TASK_LIBRARY.md Segments 5-6 —
  // Cooking Line Equipment (5.1 Fryer & Oil, 5.2 Ovens/Grills/Hobs/Other,
  // 5.3 Mechanical & Safety) and Wash-up/Dishwash. 22 tasks. Same field
  // mapping approach as Cluster A.
  //
  // No new method or frequency vocabulary gaps this cluster — every value
  // used (data, data_photo, data_tick, tick, tick_photo; daily, weekly,
  // perShift, perService, asNeeded) already exists from Cluster A.
  //
  // Equipment-mapping judgment calls, consistent with Cluster A's
  // Serve-Over Fridge precedent (task title's specific subject overrides a
  // blank or generic column tag when a matching seeded type exists):
  // - "Extraction canopy filters clean" (column blank) -> Extraction Canopy
  // - "Gas interlock / emergency cut-off test" (column blank) -> Gas
  //   Interlock System
  // - "Glasswasher functioning & dosed" (column says "Dishwasher", title
  //   names Glasswasher specifically) -> Glasswasher
  // Where the title names TWO distinct equipment concepts and the column
  // tags only one, the literal column tag is followed rather than guessing
  // which is meant — "Rotisserie / kebab machine..." stays Rotisserie only
  // (not also Kebab Machine); "Grill / salamander..." stays Grill only (not
  // also Salamander).
  //
  // Two new numeric limits this cluster, both [BEST] (no UK legal limit
  // exists for either): fryer oil temperature/TPM, dishwasher wash/rinse
  // temperature.
  static const _clusterBTasks = [
    // 5.1 Fryer & oil
    _LibraryTask(
      title: 'Oil temperature',
      segment: 'cooking_line_equipment',
      method: 'data_photo',
      priority: 'high',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      maxLimit: 180.0,
      unit: 'celsius',
      legalLimitCategory: 'fryer_oil_temp',
      fixInstructions:
          '[BEST] Typical fryer oil operating temperature is up to 180°C. '
          'No UK legal limit — industry best practice.',
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Oil quality (TPM/colour)',
      segment: 'cooking_line_equipment',
      method: 'data_tick',
      priority: 'high',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      maxLimit: 24.0,
      unit: 'percent',
      legalLimitCategory: 'fryer_oil_tpm',
      fixInstructions:
          '[BEST] No UK legal limit. Discard oil at approximately 24-27% '
          'TPM (total polar materials) — an industry best-practice '
          'benchmark, not a legal figure.',
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Oil filtering / polishing',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Oil change & log',
      segment: 'cooking_line_equipment',
      method: 'data_tick',
      priority: 'standard',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      frequency: 'asNeeded',
    ),
    _LibraryTask(
      title: 'Fryer deep clean',
      segment: 'cooking_line_equipment',
      method: 'tick_photo',
      priority: 'standard',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Oil usage log',
      segment: 'cooking_line_equipment',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Fryer',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // 5.2 Ovens / grills / hobs / other
    _LibraryTask(
      title: 'Oven working temperature',
      segment: 'cooking_line_equipment',
      method: 'data',
      priority: 'standard',
      equipmentTypeName: 'Oven',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Combi self-clean run',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Oven',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Grill / salamander clean & working',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Grill',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Hob / burner ignition & flame',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'high',
      equipmentTypeName: 'Hob',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Rotisserie / kebab machine temp & clean',
      segment: 'cooking_line_equipment',
      method: 'data_tick',
      priority: 'high',
      equipmentTypeName: 'Rotisserie',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Steamer descale',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Steamer',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Extraction canopy filters clean',
      segment: 'cooking_line_equipment',
      method: 'tick_photo',
      priority: 'high',
      equipmentTypeName: 'Extraction Canopy',
      roleTiers: ['base'],
      fixInstructions:
          '[BEST] Grease build-up in extraction ductwork is a significant '
          'fire risk — clean on schedule regardless of visible soiling.',
      frequency: 'weekly',
    ),
    // 5.3 Mechanical & safety
    _LibraryTask(
      title: 'Gas interlock / emergency cut-off test',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'critical',
      equipmentTypeName: 'Gas Interlock System',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Equipment guard / cut-out intact',
      segment: 'cooking_line_equipment',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    // Segment 6 — Wash-up / Dishwash
    _LibraryTask(
      title: 'Dishwasher wash temperature',
      segment: 'washup_dishwash',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Dishwasher',
      roleTiers: ['base'],
      minLimit: 55.0,
      maxLimit: 65.0,
      unit: 'celsius',
      legalLimitCategory: 'dishwasher_wash_temp',
      fixInstructions:
          '[BEST] Typical dishwasher wash temperature is 55-65°C. No UK '
          'legal limit — industry best practice for effective washing.',
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Dishwasher rinse temperature',
      segment: 'washup_dishwash',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Dishwasher',
      roleTiers: ['base'],
      minLimit: 82.0,
      unit: 'celsius',
      legalLimitCategory: 'dishwasher_rinse_temp',
      fixInstructions:
          '[BEST] Rinse at 82°C or above for a sanitising effect. No UK '
          'legal limit — industry best practice.',
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Detergent / rinse-aid levels',
      segment: 'washup_dishwash',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Dishwasher',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Dishwasher filter cleaned',
      segment: 'washup_dishwash',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Dishwasher',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Glasswasher functioning & dosed',
      segment: 'washup_dishwash',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Glasswasher',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Pot-wash sanitiser strength',
      segment: 'washup_dishwash',
      method: 'data_tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Air-dry (no tea-towel drying)',
      segment: 'washup_dishwash',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
  ];

  // Same equipment-tagged-vs-segment-tagged preset rule as Cluster A. Single-
  // item presets (Grill/Hob/Rotisserie/Steamer/Extraction Canopy/Gas
  // Interlock System/Glasswasher Tasks) are expected — matches Cluster A's
  // precedent (Blast Chiller/Serve-Over Fridge/Bain-marie Tasks were also
  // single-item.
  static const _clusterBPresets = [
    _LibraryPreset(
      name: 'Fryer Tasks',
      equipmentTypeName: 'Fryer',
      itemTitles: [
        'Oil temperature',
        'Oil quality (TPM/colour)',
        'Oil filtering / polishing',
        'Oil change & log',
        'Fryer deep clean',
        'Oil usage log',
      ],
    ),
    _LibraryPreset(
      name: 'Oven Tasks',
      equipmentTypeName: 'Oven',
      itemTitles: ['Oven working temperature', 'Combi self-clean run'],
    ),
    _LibraryPreset(
      name: 'Grill Tasks',
      equipmentTypeName: 'Grill',
      itemTitles: ['Grill / salamander clean & working'],
    ),
    _LibraryPreset(
      name: 'Hob Tasks',
      equipmentTypeName: 'Hob',
      itemTitles: ['Hob / burner ignition & flame'],
    ),
    _LibraryPreset(
      name: 'Rotisserie Tasks',
      equipmentTypeName: 'Rotisserie',
      itemTitles: ['Rotisserie / kebab machine temp & clean'],
    ),
    _LibraryPreset(
      name: 'Steamer Tasks',
      equipmentTypeName: 'Steamer',
      itemTitles: ['Steamer descale'],
    ),
    _LibraryPreset(
      name: 'Extraction Canopy Tasks',
      equipmentTypeName: 'Extraction Canopy',
      itemTitles: ['Extraction canopy filters clean'],
    ),
    _LibraryPreset(
      name: 'Gas Interlock System Tasks',
      equipmentTypeName: 'Gas Interlock System',
      itemTitles: ['Gas interlock / emergency cut-off test'],
    ),
    _LibraryPreset(
      name: 'Dishwasher Tasks',
      equipmentTypeName: 'Dishwasher',
      itemTitles: [
        'Dishwasher wash temperature',
        'Dishwasher rinse temperature',
        'Detergent / rinse-aid levels',
        'Dishwasher filter cleaned',
      ],
    ),
    _LibraryPreset(
      name: 'Glasswasher Tasks',
      equipmentTypeName: 'Glasswasher',
      itemTitles: ['Glasswasher functioning & dosed'],
    ),
    _LibraryPreset(
      name: 'Cooking Line Equipment Tasks',
      segment: 'cooking_line_equipment',
      itemTitles: ['Equipment guard / cut-out intact'],
    ),
    _LibraryPreset(
      name: 'Wash-up Tasks',
      segment: 'washup_dishwash',
      itemTitles: ['Pot-wash sanitiser strength', 'Air-dry (no tea-towel drying)'],
    ),
  ];

  Future<void> _seedTaskLibraryClusterB() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    await _ensureLegalLimitReference(
      category: 'fryer_oil_temp',
      maxLimit: 180.0,
      unit: 'celsius',
      basis: 'best',
    );
    await _ensureLegalLimitReference(
      category: 'fryer_oil_tpm',
      maxLimit: 24.0,
      unit: 'percent',
      basis: 'best',
    );
    await _ensureLegalLimitReference(
      category: 'dishwasher_wash_temp',
      minLimit: 55.0,
      maxLimit: 65.0,
      unit: 'celsius',
      basis: 'best',
    );
    await _ensureLegalLimitReference(
      category: 'dishwasher_rinse_temp',
      minLimit: 82.0,
      unit: 'celsius',
      basis: 'best',
    );

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterBTasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterBTasks) task.title: task.frequency,
    };
    final existingPresetNames = (await select(
      taskPresets,
    ).get()).map((row) => row.name).toSet();

    for (final preset in _clusterBPresets) {
      if (existingPresetNames.contains(preset.name)) continue;

      final equipmentTypeId = preset.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[preset.equipmentTypeName];

      final presetId = await into(taskPresets).insert(
        TaskPresetsCompanion.insert(
          name: preset.name,
          equipmentTypeId: Value(equipmentTypeId),
          segment: Value(preset.segment),
          createdAt: DateTime.now(),
        ),
      );

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        await into(taskPresetItems).insert(
          TaskPresetItemsCompanion.insert(
            presetId: presetId,
            taskTemplateGroupId: groupId,
            defaultFrequency: frequency,
          ),
        );

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      for (final vtId in memberVenueTypeIds) {
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  // Cluster C (Sprint 030 follow-up): HORECA_TASK_LIBRARY.md Segments 7-10 —
  // Cleaning & Sanitation, Cleaning Chemicals & Consumables, Dry & Ambient
  // Storage, Deliveries & Goods In. 28 tasks. Same field mapping approach as
  // Clusters A/B.
  //
  // No new method or frequency vocabulary gaps this cluster — every value
  // used (tick, tick_photo, tick_note, data, data_photo, data_tick, note,
  // multi; daily, weekly, perShift, perUse, perDelivery) already exists.
  //
  // Equipment-mapping notes:
  // - "Dry store temperature / humidity" (column blank) -> Dry Store Area,
  //   the same "blank column, one unambiguous seeded type named in the
  //   title" pattern as Cluster B's Extraction Canopy/Gas Interlock System.
  // - "Slicer / mincer strip-down clean" (column blank) -> left unmapped
  //   (equipmentTypeId null), a new sub-case of the established "don't
  //   guess between two named options" rule: unlike Extraction Canopy, the
  //   title names TWO real seeded types (Slicer, Mincer) with no signal
  //   preferring one, so — consistent with how Cluster B kept "Rotisserie /
  //   kebab machine" and "Grill / salamander" literal — this stays
  //   unmapped rather than guessing which one.
  // - "Prep surfaces cleaned & sanitised" (column blank) -> also left
  //   unmapped. "Prep surfaces" reads as a general food-contact-surface
  //   concept, not obviously the same thing as the seeded "Prep Station"
  //   equipment type (a specific workstation unit) — mapping it there would
  //   be guessing at an equivalence the source doesn't state.
  //
  // Two new [FSA] limits, both delivery temperature checks (mirrors the
  // existing fridge/freezer temp categories but scoped to goods-in, since
  // an item can be in-spec on the shelf but out-of-spec on arrival).
  static const _clusterCTasks = [
    // 7.1 Food-contact surfaces & equipment
    _LibraryTask(
      title: 'Prep surfaces cleaned & sanitised',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'critical',
      roleTiers: ['base'],
      fixInstructions:
          "[BEST] Contact/dwell time varies per product and sanitiser — "
          "follow the product label's stated contact time. No single UK "
          "legal figure.",
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Chopping boards colour-coded & sound',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Slicer / mincer strip-down clean',
      segment: 'cleaning_sanitation',
      method: 'tick_photo',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'perUse',
    ),
    _LibraryTask(
      title: 'Can opener blade clean',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Ice machine clean & descaled',
      segment: 'cleaning_sanitation',
      method: 'tick_photo',
      priority: 'high',
      equipmentTypeName: 'Ice Machine',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    // 7.2 Floors, walls, drains
    _LibraryTask(
      title: 'Kitchen floor cleaned',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Drains / gullies cleared',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Walls / splashbacks wiped',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Bin areas cleaned',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // 7.3 Schedule verification (Due Diligence evidence)
    _LibraryTask(
      title: 'Deep clean checklist',
      segment: 'cleaning_sanitation',
      method: 'multi',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Cleaning schedule signed off',
      segment: 'cleaning_sanitation',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'daily',
    ),
    // Segment 8 — Cleaning Chemicals & Consumables
    _LibraryTask(
      title: 'Sanitiser in stock & in date',
      segment: 'cleaning_chemicals',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      fixInstructions:
          '[BEST] Sanitiser should be BS EN 1276/13697 compliant '
          '(bactericidal/fungicidal standards). No UK legal limit — a '
          'recognised industry standard, not statute.',
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Degreaser in stock',
      segment: 'cleaning_chemicals',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Blue roll / paper towel stocked',
      segment: 'cleaning_chemicals',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'COSHH sheets present & chemicals labelled',
      segment: 'cleaning_chemicals',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[LAW] COSHH (Control of Substances Hazardous to Health) data '
          'sheets must be present and chemicals correctly labelled — a '
          'legal requirement.',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Chemical dilution / dosing correct',
      segment: 'cleaning_chemicals',
      method: 'data_tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // Segment 9 — Dry & Ambient Storage
    _LibraryTask(
      title: 'Dry store temperature / humidity',
      segment: 'dry_ambient_storage',
      method: 'data',
      priority: 'standard',
      equipmentTypeName: 'Dry Store Area',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Stock off floor / on shelving',
      segment: 'dry_ambient_storage',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Open dry goods sealed & dated',
      segment: 'dry_ambient_storage',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'No damaged / bloated / infested packaging',
      segment: 'dry_ambient_storage',
      method: 'tick_note',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // Segment 10 — Deliveries & Goods In
    _LibraryTask(
      title: 'Chilled goods temp on arrival',
      segment: 'deliveries_goods_in',
      method: 'data_photo',
      priority: 'critical',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'delivery_chilled_temp',
      fixInstructions:
          '[FSA] Chilled deliveries should read 8°C or below on arrival, '
          'aiming for 5°C. Reject if significantly above.',
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Frozen goods temp on arrival',
      segment: 'deliveries_goods_in',
      method: 'data_photo',
      priority: 'critical',
      roleTiers: ['base'],
      maxLimit: -18.0,
      unit: 'celsius',
      legalLimitCategory: 'delivery_frozen_temp',
      fixInstructions:
          '[FSA] Frozen deliveries should read approximately -18°C on '
          'arrival. Reject if the product shows signs of '
          'softening/thawing.',
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Vehicle / driver hygiene',
      segment: 'deliveries_goods_in',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Packaging intact',
      segment: 'deliveries_goods_in',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Use-by dates acceptable',
      segment: 'deliveries_goods_in',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Reconciled to order/invoice',
      segment: 'deliveries_goods_in',
      method: 'tick_note',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Rejected items logged',
      segment: 'deliveries_goods_in',
      method: 'note',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perDelivery',
    ),
    _LibraryTask(
      title: 'Supplier traceability captured',
      segment: 'deliveries_goods_in',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[LAW] One-step-back traceability (know where each '
          'ingredient/batch came from) is a legal requirement.',
      frequency: 'perDelivery',
    ),
  ];

  static const _clusterCPresets = [
    _LibraryPreset(
      name: 'Ice Machine Tasks',
      equipmentTypeName: 'Ice Machine',
      itemTitles: ['Ice machine clean & descaled'],
    ),
    _LibraryPreset(
      name: 'Dry Store Area Tasks',
      equipmentTypeName: 'Dry Store Area',
      itemTitles: ['Dry store temperature / humidity'],
    ),
    _LibraryPreset(
      name: 'Cleaning & Sanitation Tasks',
      segment: 'cleaning_sanitation',
      itemTitles: [
        'Prep surfaces cleaned & sanitised',
        'Chopping boards colour-coded & sound',
        'Slicer / mincer strip-down clean',
        'Can opener blade clean',
        'Kitchen floor cleaned',
        'Drains / gullies cleared',
        'Walls / splashbacks wiped',
        'Bin areas cleaned',
        'Deep clean checklist',
        'Cleaning schedule signed off',
      ],
    ),
    _LibraryPreset(
      name: 'Cleaning Chemicals Tasks',
      segment: 'cleaning_chemicals',
      itemTitles: [
        'Sanitiser in stock & in date',
        'Degreaser in stock',
        'Blue roll / paper towel stocked',
        'COSHH sheets present & chemicals labelled',
        'Chemical dilution / dosing correct',
      ],
    ),
    _LibraryPreset(
      name: 'Dry & Ambient Storage Tasks',
      segment: 'dry_ambient_storage',
      itemTitles: [
        'Stock off floor / on shelving',
        'Open dry goods sealed & dated',
        'No damaged / bloated / infested packaging',
      ],
    ),
    _LibraryPreset(
      name: 'Deliveries & Goods In Tasks',
      segment: 'deliveries_goods_in',
      itemTitles: [
        'Chilled goods temp on arrival',
        'Frozen goods temp on arrival',
        'Vehicle / driver hygiene',
        'Packaging intact',
        'Use-by dates acceptable',
        'Reconciled to order/invoice',
        'Rejected items logged',
        'Supplier traceability captured',
      ],
    ),
  ];

  Future<void> _seedTaskLibraryClusterC() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    await _ensureLegalLimitReference(
      category: 'delivery_chilled_temp',
      maxLimit: 8.0,
      unit: 'celsius',
      basis: 'fsa',
    );
    await _ensureLegalLimitReference(
      category: 'delivery_frozen_temp',
      maxLimit: -18.0,
      unit: 'celsius',
      basis: 'fsa',
    );

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterCTasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterCTasks) task.title: task.frequency,
    };
    final existingPresetNames = (await select(
      taskPresets,
    ).get()).map((row) => row.name).toSet();

    for (final preset in _clusterCPresets) {
      if (existingPresetNames.contains(preset.name)) continue;

      final equipmentTypeId = preset.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[preset.equipmentTypeName];

      final presetId = await into(taskPresets).insert(
        TaskPresetsCompanion.insert(
          name: preset.name,
          equipmentTypeId: Value(equipmentTypeId),
          segment: Value(preset.segment),
          createdAt: DateTime.now(),
        ),
      );

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        await into(taskPresetItems).insert(
          TaskPresetItemsCompanion.insert(
            presetId: presetId,
            taskTemplateGroupId: groupId,
            defaultFrequency: frequency,
          ),
        );

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      for (final vtId in memberVenueTypeIds) {
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  // Cluster D (Sprint 030 follow-up): HORECA_TASK_LIBRARY.md Segments 11-14
  // — Utilities & Safety, Waste & Pest Control, Preventive Maintenance,
  // Stock Control. 23 tasks.
  //
  // No new method vocabulary gaps — `data_note` (added in Cluster A but
  // unused until now) is used for the first time by "Wastage / spoilage
  // log". No new frequency values needed: "Per visit" (pest control
  // contractor visit) maps to `eventBased`, per the original Sprint 030
  // plan's already-agreed folding of Per order/Per menu change/Per visit
  // into that one value (not a new gap — those three were always meant to
  // share it).
  //
  // First task in the library tagged `Top` ("Gas safety certificate in
  // date") — confirmed before building: `Top` maps to
  // `[regional, executive]`, mirroring the already-established
  // `Mid`→`[supervisor, venueManager]` default's pairing to Sprint 027's
  // screen groupings (Top pairs to the TopScreen grouping the same way).
  //
  // Equipment-mapping notes: "Hand-wash sinks stocked" (column blank, title
  // unambiguous) → Hand-Wash Sink, same established pattern. "Extraction/
  // duct professional clean in date" (column blank, title names the same
  // underlying equipment as Cluster B's "Extraction canopy filters clean")
  // → Extraction Canopy — the first case of two different tasks across
  // clusters mapping to the same equipment type's preset, which already
  // exists from Cluster B. Handled by extending the preset-seeding loop
  // below to add a missing item to an already-existing preset rather than
  // skip it outright — the previous by-name-skip-if-exists logic would
  // otherwise have silently dropped this task from any preset. Not a new
  // judgment call, a necessary, mechanical extension of the existing
  // "equipment-tagged tasks bundle into that equipment's preset" rule to a
  // case that hadn't come up before (the target preset predating this
  // cluster). "PAT / electrical inspection in date" and "Gas safety
  // certificate in date" are left unmapped — both are venue-wide compliance
  // checks (PAT covers all electrical equipment generally; the gas
  // certificate covers the overall gas installation, not the Gas Interlock
  // System specifically), not a single named equipment instance.
  static const _clusterDTasks = [
    // Segment 11 — Utilities & Safety
    _LibraryTask(
      title: 'Hot water at sinks',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Hand-wash sinks stocked',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'critical',
      equipmentTypeName: 'Hand-Wash Sink',
      roleTiers: ['base'],
      fixInstructions:
          '[LAW] A dedicated hand-wash basin, separate from food prep/'
          'wash-up sinks, is a legal requirement.',
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Fire exits clear & unlocked',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'critical',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[LAW] Fire exits must be kept clear and unlocked at all times '
          'during operating hours.',
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Fire extinguishers in place & in date',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'First aid kit stocked',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Lighting functional',
      segment: 'utilities_safety',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Gas / electrical no visible faults',
      segment: 'utilities_safety',
      method: 'tick_note',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // Segment 12 — Waste & Pest Control
    _LibraryTask(
      title: 'General waste removed & bins clean',
      segment: 'waste_pest_control',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Food waste segregated',
      segment: 'waste_pest_control',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Used cooking oil stored / collected',
      segment: 'waste_pest_control',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      fixInstructions:
          '[LAW] Used cooking oil must go to a licensed waste carrier.',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Pest activity check (droppings/gnaw/nest)',
      segment: 'waste_pest_control',
      method: 'tick_note',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Fly killer / bait stations working',
      segment: 'waste_pest_control',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'External bin area secure & clean',
      segment: 'waste_pest_control',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Pest control contract visit log',
      segment: 'waste_pest_control',
      method: 'note',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'eventBased',
    ),
    // Segment 13 — Preventive Maintenance
    _LibraryTask(
      title: 'Equipment fault log reviewed',
      segment: 'preventive_maintenance',
      method: 'note',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Scheduled servicing up to date',
      segment: 'preventive_maintenance',
      method: 'tick_note',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'PAT / electrical inspection in date',
      segment: 'preventive_maintenance',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'Extraction/duct professional clean in date',
      segment: 'preventive_maintenance',
      method: 'tick',
      priority: 'high',
      equipmentTypeName: 'Extraction Canopy',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[BEST] Regular professional extraction/duct cleaning reduces '
          'fire risk and supports insurance compliance. No single UK '
          'legal figure for frequency.',
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'Gas safety certificate in date',
      segment: 'preventive_maintenance',
      method: 'tick',
      priority: 'high',
      roleTiers: ['regional', 'executive'],
      fixInstructions:
          '[LAW] A valid Gas Safety Certificate (Gas Safety Regs) is a '
          'legal requirement for gas installations.',
      frequency: 'monthly',
    ),
    // Segment 14 — Stock Control
    _LibraryTask(
      title: 'Stock count / par levels',
      segment: 'stock_control',
      method: 'data_tick',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Wastage / spoilage log',
      segment: 'stock_control',
      method: 'data_note',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Low-stock reorder flagged',
      segment: 'stock_control',
      method: 'note',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'High-value stock reconciled',
      segment: 'stock_control',
      method: 'data',
      priority: 'standard',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
  ];

  // "Extraction Canopy Tasks" reuses the preset Cluster B already created —
  // handled by the preset-seeding loop below, not by declaring it here
  // again (which would just be skipped by the by-name check).
  static const _clusterDPresets = [
    _LibraryPreset(
      name: 'Hand-Wash Sink Tasks',
      equipmentTypeName: 'Hand-Wash Sink',
      itemTitles: ['Hand-wash sinks stocked'],
    ),
    _LibraryPreset(
      name: 'Extraction Canopy Tasks',
      equipmentTypeName: 'Extraction Canopy',
      itemTitles: ['Extraction/duct professional clean in date'],
    ),
    _LibraryPreset(
      name: 'Utilities & Safety Tasks',
      segment: 'utilities_safety',
      itemTitles: [
        'Hot water at sinks',
        'Fire exits clear & unlocked',
        'Fire extinguishers in place & in date',
        'First aid kit stocked',
        'Lighting functional',
        'Gas / electrical no visible faults',
      ],
    ),
    _LibraryPreset(
      name: 'Waste & Pest Control Tasks',
      segment: 'waste_pest_control',
      itemTitles: [
        'General waste removed & bins clean',
        'Food waste segregated',
        'Used cooking oil stored / collected',
        'Pest activity check (droppings/gnaw/nest)',
        'Fly killer / bait stations working',
        'External bin area secure & clean',
        'Pest control contract visit log',
      ],
    ),
    _LibraryPreset(
      name: 'Preventive Maintenance Tasks',
      segment: 'preventive_maintenance',
      itemTitles: [
        'Equipment fault log reviewed',
        'Scheduled servicing up to date',
        'PAT / electrical inspection in date',
        'Gas safety certificate in date',
      ],
    ),
    _LibraryPreset(
      name: 'Stock Control Tasks',
      segment: 'stock_control',
      itemTitles: [
        'Stock count / par levels',
        'Wastage / spoilage log',
        'Low-stock reorder flagged',
        'High-value stock reconciled',
      ],
    ),
  ];

  Future<void> _seedTaskLibraryClusterD() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterDTasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterDTasks) task.title: task.frequency,
    };

    // Unlike Clusters A/B/C, a preset here can already exist from an
    // earlier cluster (Extraction Canopy Tasks, from Cluster B) — so this
    // loop resolves-or-creates the preset by name, then adds any of this
    // cluster's items it doesn't already have (checked by templateGroupId,
    // not just skipped), and only adds venue-type tags it doesn't already
    // carry. Safe to rerun: every step below is itself idempotent.
    for (final preset in _clusterDPresets) {
      final existingPreset = await (select(
        taskPresets,
      )..where((p) => p.name.equals(preset.name))).getSingleOrNull();

      final int presetId;
      if (existingPreset != null) {
        presetId = existingPreset.id;
      } else {
        final equipmentTypeId = preset.equipmentTypeName == null
            ? null
            : equipmentTypeIdByName[preset.equipmentTypeName];
        presetId = await into(taskPresets).insert(
          TaskPresetsCompanion.insert(
            name: preset.name,
            equipmentTypeId: Value(equipmentTypeId),
            segment: Value(preset.segment),
            createdAt: DateTime.now(),
          ),
        );
      }

      final existingItemGroupIds = (await (select(
        taskPresetItems,
      )..where((i) => i.presetId.equals(presetId))).get())
          .map((i) => i.taskTemplateGroupId)
          .toSet();

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        if (!existingItemGroupIds.contains(groupId)) {
          await into(taskPresetItems).insert(
            TaskPresetItemsCompanion.insert(
              presetId: presetId,
              taskTemplateGroupId: groupId,
              defaultFrequency: frequency,
            ),
          );
        }

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      final existingPresetVenueTypeIds = (await (select(
        taskPresetVenueTypes,
      )..where((j) => j.presetId.equals(presetId))).get())
          .map((j) => j.venueTypeId)
          .toSet();
      for (final vtId in memberVenueTypeIds) {
        if (existingPresetVenueTypeIds.contains(vtId)) continue;
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  // Cluster E (Sprint 030 follow-up): HORECA_TASK_LIBRARY.md Segments 15-17
  // — Opening Procedures, Closing Procedures, Service Readiness. 13 tasks.
  //
  // No new method, frequency, or role-tier vocabulary this cluster — every
  // value used already existed.
  //
  // "Hot-hold / bain-marie pre-heated" reuses the existing `hot_hold_temp`
  // legal limit category (same ≥63°C [LAW] figure Cluster A's "Hot-holding
  // temperature" already uses) rather than a new category — it's the same
  // real-world legal threshold, just checked at a different moment (before
  // service starts, not during it).
  //
  // Two preset merges into existing presets from Cluster A, per the same
  // pattern Cluster D established for Extraction Canopy Tasks: "Hot-hold /
  // bain-marie pre-heated" → Bain-marie Tasks (currently 1 item), "Service
  // fridges stocked & at temp" → Fridge Tasks (currently 5 items). Handled
  // by the same resolve-or-create preset loop Cluster D introduced.
  static const _clusterETasks = [
    // Segment 15 — Opening Procedures
    _LibraryTask(
      title: 'Opening checklist complete',
      segment: 'opening_procedures',
      method: 'multi',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'All refrigeration temps at open',
      segment: 'opening_procedures',
      method: 'data',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Equipment switched on & warmed',
      segment: 'opening_procedures',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'No overnight pest / leak / fault',
      segment: 'opening_procedures',
      method: 'tick_note',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // Segment 16 — Closing Procedures
    _LibraryTask(
      title: 'Closing checklist complete',
      segment: 'closing_procedures',
      method: 'multi',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Equipment safely off',
      segment: 'closing_procedures',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Perishables stored / covered / dated',
      segment: 'closing_procedures',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Final clean-down',
      segment: 'closing_procedures',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Premises secured / alarm set',
      segment: 'closing_procedures',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'daily',
    ),
    // Segment 17 — Service Readiness
    _LibraryTask(
      title: 'Mise en place complete',
      segment: 'service_readiness',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Hot-hold / bain-marie pre-heated',
      segment: 'service_readiness',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Bain-marie',
      roleTiers: ['base'],
      minLimit: 63.0,
      unit: 'celsius',
      legalLimitCategory: 'hot_hold_temp',
      fixInstructions: 'Must reach 63°C or above before service begins [LAW].',
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Specials / allergen info briefed',
      segment: 'service_readiness',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Service fridges stocked & at temp',
      segment: 'service_readiness',
      method: 'data',
      priority: 'high',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      frequency: 'perService',
    ),
  ];

  // "Bain-marie Tasks" and "Fridge Tasks" reuse presets Cluster A already
  // created — handled by the resolve-or-create preset loop below, not by
  // declaring them as new (which would just be skipped by a plain by-name
  // check without the merge logic Cluster D introduced).
  static const _clusterEPresets = [
    _LibraryPreset(
      name: 'Bain-marie Tasks',
      equipmentTypeName: 'Bain-marie',
      itemTitles: ['Hot-hold / bain-marie pre-heated'],
    ),
    _LibraryPreset(
      name: 'Fridge Tasks',
      equipmentTypeName: 'Fridge',
      itemTitles: ['Service fridges stocked & at temp'],
    ),
    _LibraryPreset(
      name: 'Opening Procedures Tasks',
      segment: 'opening_procedures',
      itemTitles: [
        'Opening checklist complete',
        'All refrigeration temps at open',
        'Equipment switched on & warmed',
        'No overnight pest / leak / fault',
      ],
    ),
    _LibraryPreset(
      name: 'Closing Procedures Tasks',
      segment: 'closing_procedures',
      itemTitles: [
        'Closing checklist complete',
        'Equipment safely off',
        'Perishables stored / covered / dated',
        'Final clean-down',
        'Premises secured / alarm set',
      ],
    ),
    _LibraryPreset(
      name: 'Service Readiness Tasks',
      segment: 'service_readiness',
      itemTitles: [
        'Mise en place complete',
        'Specials / allergen info briefed',
      ],
    ),
  ];

  Future<void> _seedTaskLibraryClusterE() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterETasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterETasks) task.title: task.frequency,
    };

    // Same resolve-or-create-then-merge preset loop Cluster D introduced —
    // needed here too, since Bain-marie Tasks and Fridge Tasks both already
    // exist from Cluster A. Safe to rerun: every step is idempotent.
    for (final preset in _clusterEPresets) {
      final existingPreset = await (select(
        taskPresets,
      )..where((p) => p.name.equals(preset.name))).getSingleOrNull();

      final int presetId;
      if (existingPreset != null) {
        presetId = existingPreset.id;
      } else {
        final equipmentTypeId = preset.equipmentTypeName == null
            ? null
            : equipmentTypeIdByName[preset.equipmentTypeName];
        presetId = await into(taskPresets).insert(
          TaskPresetsCompanion.insert(
            name: preset.name,
            equipmentTypeId: Value(equipmentTypeId),
            segment: Value(preset.segment),
            createdAt: DateTime.now(),
          ),
        );
      }

      final existingItemGroupIds = (await (select(
        taskPresetItems,
      )..where((i) => i.presetId.equals(presetId))).get())
          .map((i) => i.taskTemplateGroupId)
          .toSet();

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        if (!existingItemGroupIds.contains(groupId)) {
          await into(taskPresetItems).insert(
            TaskPresetItemsCompanion.insert(
              presetId: presetId,
              taskTemplateGroupId: groupId,
              defaultFrequency: frequency,
            ),
          );
        }

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      final existingPresetVenueTypeIds = (await (select(
        taskPresetVenueTypes,
      )..where((j) => j.presetId.equals(presetId))).get())
          .map((j) => j.venueTypeId)
          .toSet();
      for (final vtId in memberVenueTypeIds) {
        if (existingPresetVenueTypeIds.contains(vtId)) continue;
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  // Cluster F (Sprint 030 follow-up, FINAL CLUSTER): HORECA_TASK_LIBRARY.md
  // Segments 18-21 — Front of House / Service, Bar & Beverage,
  // Hotel-Specific, Management & Compliance Oversight. 28 tasks. Completes
  // Build Order item 4.
  //
  // No new method, frequency, or role-tier vocabulary — every value used
  // (including `note_photo`, part of the original 8-value vocabulary since
  // Sprint 023 but not actually used by any task until now) already
  // existed.
  //
  // Two `LegalLimitReference` categories reused from Cluster A (`hot_hold_
  // temp` for hot buffet/breakfast buffet/banqueting hot-hold; `fridge_temp`
  // for cold buffet display) — same real-world legal figures, checked at
  // different service moments. Two genuinely new categories: `cellar_temp`
  // (11-13°C cask ale target, [BEST]) and `buffet_out_of_temp_time` (max 4
  // hours, [FSA]) — the latter is a duration limit, not a temperature one;
  // `unit: 'hours'` is used since the schema's unit column is free text.
  // "Breakfast buffet temperatures" combines a hot AND cold threshold in
  // one task (hot ≥63°C / cold ≤8°C) — left structurally unlimited (no
  // single min/max pair fits both), with both figures explained in
  // `fixInstructions` instead, same treatment as Cluster E's "All
  // refrigeration temps at open".
  //
  // Equipment-mapping judgment calls, extending the established "task
  // title's specific subject overrides a generic column tag" rule (first
  // used for Serve-Over Fridge in Cluster A): "Cellar / keg temperature"
  // (column says the generic "Fridge") → Cellar Cooler, the purpose-built
  // seeded type. "Beer line cleaning" and "Post-mix / soda gun cleaned"
  // (both blank columns, titles unambiguous) → Keg System and Post-Mix
  // System respectively, the established blank-column pattern.
  //
  // Three preset merges into existing presets from Clusters A/E: "Hot
  // buffet display temperature", "Breakfast buffet temperatures", and
  // "Banqueting / function hot-hold log" all map to Bain-marie, whose
  // preset already has 2 items (from Clusters A and E) — the first
  // three-way merge into a single preset across three different clusters.
  // "Cold buffet display temperature" maps to Fridge, merging a 7th item
  // into that preset. Both handled by the resolve-or-create-then-merge
  // preset loop Cluster D introduced.
  static const _clusterFTasks = [
    // Segment 18 — Front of House / Service
    _LibraryTask(
      title: 'Dining area cleaned & set',
      segment: 'front_of_house',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Tables / condiments sanitised',
      segment: 'front_of_house',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Customer toilets checked & stocked',
      segment: 'front_of_house',
      method: 'tick_note',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'twoXPerService',
    ),
    _LibraryTask(
      title: 'Allergen requests relayed to kitchen',
      segment: 'front_of_house',
      method: 'tick_note',
      priority: 'critical',
      roleTiers: ['base'],
      frequency: 'eventBased',
    ),
    _LibraryTask(
      title: 'Coffee machine cleaned & backflushed',
      segment: 'front_of_house',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Coffee Machine',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Hot buffet display temperature',
      segment: 'front_of_house',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Bain-marie',
      roleTiers: ['base'],
      minLimit: 63.0,
      unit: 'celsius',
      legalLimitCategory: 'hot_hold_temp',
      fixInstructions: 'Must hold at 63°C or above [LAW].',
      frequency: 'twoXPerService',
    ),
    _LibraryTask(
      title: 'Cold buffet display temperature',
      segment: 'front_of_house',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Fridge',
      roleTiers: ['base'],
      maxLimit: 8.0,
      unit: 'celsius',
      legalLimitCategory: 'fridge_temp',
      fixInstructions: 'Legal max 8°C [LAW].',
      frequency: 'twoXPerService',
    ),
    _LibraryTask(
      title: 'Buffet out-of-temperature time log',
      segment: 'front_of_house',
      method: 'data_tick',
      priority: 'critical',
      roleTiers: ['base'],
      maxLimit: 4.0,
      unit: 'hours',
      legalLimitCategory: 'buffet_out_of_temp_time',
      fixInstructions:
          '[FSA] Food on cold display without temperature control has a '
          'maximum single 4-hour window before it must be discarded or '
          'returned to refrigeration.',
      frequency: 'perService',
    ),
    // Segment 19 — Bar & Beverage
    _LibraryTask(
      title: 'Cellar / keg temperature',
      segment: 'bar_beverage',
      method: 'data',
      priority: 'standard',
      equipmentTypeName: 'Cellar Cooler',
      roleTiers: ['base'],
      minLimit: 11.0,
      maxLimit: 13.0,
      unit: 'celsius',
      legalLimitCategory: 'cellar_temp',
      fixInstructions:
          '[BEST] Cask ale cellar temperature target 11-13°C. No UK legal '
          'limit — industry best practice.',
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Beer line cleaning',
      segment: 'bar_beverage',
      method: 'tick_note',
      priority: 'high',
      equipmentTypeName: 'Keg System',
      roleTiers: ['base'],
      fixInstructions:
          '[BEST] Clean beer lines every 7 days. No UK legal requirement — '
          'industry best practice.',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Ice well / scoop hygiene',
      segment: 'bar_beverage',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Post-mix / soda gun cleaned',
      segment: 'bar_beverage',
      method: 'tick',
      priority: 'standard',
      equipmentTypeName: 'Post-Mix System',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Glassware condition (no chips)',
      segment: 'bar_beverage',
      method: 'tick',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    _LibraryTask(
      title: 'Optics / measures verified',
      segment: 'bar_beverage',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      fixInstructions:
          '[LAW] Optics and measures must be accurate and calibrated per '
          'the Weights & Measures Act.',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Open wine / vermouth dated',
      segment: 'bar_beverage',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    // Segment 20 — Hotel-Specific
    _LibraryTask(
      title: 'Breakfast buffet temperatures',
      segment: 'hotel_specific',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Bain-marie',
      roleTiers: ['base'],
      fixInstructions:
          '[LAW] Hot sections must hold ≥63°C; cold sections must hold '
          '≤8°C. Record whichever section applies.',
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Room service tray temp on dispatch',
      segment: 'hotel_specific',
      method: 'data',
      priority: 'high',
      roleTiers: ['base'],
      frequency: 'eventBased',
    ),
    _LibraryTask(
      title: 'Minibar stock & date check',
      segment: 'hotel_specific',
      method: 'tick_note',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Banqueting / function hot-hold log',
      segment: 'hotel_specific',
      method: 'data_photo',
      priority: 'critical',
      equipmentTypeName: 'Bain-marie',
      roleTiers: ['base'],
      minLimit: 63.0,
      unit: 'celsius',
      legalLimitCategory: 'hot_hold_temp',
      fixInstructions: 'Must hold at 63°C or above [LAW].',
      frequency: 'perService',
    ),
    _LibraryTask(
      title: 'Guest allergen request (rooms)',
      segment: 'hotel_specific',
      method: 'note',
      priority: 'critical',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'eventBased',
    ),
    _LibraryTask(
      title: 'Poolside / satellite bar hygiene',
      segment: 'hotel_specific',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['base'],
      frequency: 'perShift',
    ),
    // Segment 21 — Management & Compliance Oversight
    _LibraryTask(
      title: 'Daily compliance review / sign-off',
      segment: 'management_compliance_oversight',
      method: 'tick_note',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'Weekly food safety walk-round',
      segment: 'management_compliance_oversight',
      method: 'note_photo',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'Corrective actions closed out',
      segment: 'management_compliance_oversight',
      method: 'note',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      frequency: 'daily',
    ),
    _LibraryTask(
      title: 'SFBB / HACCP diary reviewed',
      segment: 'management_compliance_oversight',
      method: 'tick',
      priority: 'high',
      roleTiers: ['supervisor', 'venueManager'],
      fixInstructions:
          '[FSA] The SFBB/HACCP diary itself should be formally reviewed '
          'on a 4-weekly cycle (this check confirms review has happened).',
      frequency: 'weekly',
    ),
    _LibraryTask(
      title: 'EHO / audit readiness check',
      segment: 'management_compliance_oversight',
      method: 'multi',
      priority: 'high',
      roleTiers: ['regional', 'executive'],
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'Staff training records current',
      segment: 'management_compliance_oversight',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['regional', 'executive'],
      fixInstructions:
          '[BEST] Level 2 Food Hygiene certification is the commonly '
          'expected baseline. No single UK legal minimum training level '
          'specified in law.',
      frequency: 'monthly',
    ),
    _LibraryTask(
      title: 'Supplier approval / due diligence',
      segment: 'management_compliance_oversight',
      method: 'tick',
      priority: 'standard',
      roleTiers: ['regional', 'executive'],
      frequency: 'monthly',
    ),
  ];

  // "Bain-marie Tasks" and "Fridge Tasks" reuse presets from Clusters A/E —
  // handled by the resolve-or-create-then-merge preset loop below.
  static const _clusterFPresets = [
    _LibraryPreset(
      name: 'Coffee Machine Tasks',
      equipmentTypeName: 'Coffee Machine',
      itemTitles: ['Coffee machine cleaned & backflushed'],
    ),
    _LibraryPreset(
      name: 'Bain-marie Tasks',
      equipmentTypeName: 'Bain-marie',
      itemTitles: [
        'Hot buffet display temperature',
        'Breakfast buffet temperatures',
        'Banqueting / function hot-hold log',
      ],
    ),
    _LibraryPreset(
      name: 'Fridge Tasks',
      equipmentTypeName: 'Fridge',
      itemTitles: ['Cold buffet display temperature'],
    ),
    _LibraryPreset(
      name: 'Cellar Cooler Tasks',
      equipmentTypeName: 'Cellar Cooler',
      itemTitles: ['Cellar / keg temperature'],
    ),
    _LibraryPreset(
      name: 'Keg System Tasks',
      equipmentTypeName: 'Keg System',
      itemTitles: ['Beer line cleaning'],
    ),
    _LibraryPreset(
      name: 'Post-Mix System Tasks',
      equipmentTypeName: 'Post-Mix System',
      itemTitles: ['Post-mix / soda gun cleaned'],
    ),
    _LibraryPreset(
      name: 'Front of House Tasks',
      segment: 'front_of_house',
      itemTitles: [
        'Dining area cleaned & set',
        'Tables / condiments sanitised',
        'Customer toilets checked & stocked',
        'Allergen requests relayed to kitchen',
        'Buffet out-of-temperature time log',
      ],
    ),
    _LibraryPreset(
      name: 'Bar & Beverage Tasks',
      segment: 'bar_beverage',
      itemTitles: [
        'Ice well / scoop hygiene',
        'Glassware condition (no chips)',
        'Optics / measures verified',
        'Open wine / vermouth dated',
      ],
    ),
    _LibraryPreset(
      name: 'Hotel-Specific Tasks',
      segment: 'hotel_specific',
      itemTitles: [
        'Room service tray temp on dispatch',
        'Minibar stock & date check',
        'Guest allergen request (rooms)',
        'Poolside / satellite bar hygiene',
      ],
    ),
    _LibraryPreset(
      name: 'Management & Compliance Oversight Tasks',
      segment: 'management_compliance_oversight',
      itemTitles: [
        'Daily compliance review / sign-off',
        'Weekly food safety walk-round',
        'Corrective actions closed out',
        'SFBB / HACCP diary reviewed',
        'EHO / audit readiness check',
        'Staff training records current',
        'Supplier approval / due diligence',
      ],
    ),
  ];

  Future<void> _seedTaskLibraryClusterF() async {
    final equipmentTypeIdByName = {
      for (final row in await select(equipmentTypes).get())
        row.name: row.id,
    };
    final venueTypeIdByName = {
      for (final row in await select(venueTypes).get()) row.name: row.id,
    };

    await _ensureLegalLimitReference(
      category: 'cellar_temp',
      minLimit: 11.0,
      maxLimit: 13.0,
      unit: 'celsius',
      basis: 'best',
    );
    await _ensureLegalLimitReference(
      category: 'buffet_out_of_temp_time',
      maxLimit: 4.0,
      unit: 'hours',
      basis: 'fsa',
    );

    final existingTitles = (await select(
      taskTemplates,
    ).get()).map((row) => row.title).toSet();

    for (final task in _clusterFTasks) {
      if (existingTitles.contains(task.title)) continue;

      final equipmentTypeId = task.equipmentTypeName == null
          ? null
          : equipmentTypeIdByName[task.equipmentTypeName];

      final insertedId = await into(taskTemplates).insert(
        TaskTemplatesCompanion.insert(
          templateGroupId: 0,
          versionNumber: 1,
          title: task.title,
          segment: task.segment,
          applicableRoleTiers: task.roleTiers.join(','),
          method: task.method,
          requiresPhoto: Value(task.method.contains('photo')),
          requiresNotes: Value(task.method.contains('note')),
          minLimit: Value(task.minLimit),
          maxLimit: Value(task.maxLimit),
          unit: Value(task.unit),
          legalLimitCategory: Value(task.legalLimitCategory),
          isCritical: Value(task.priority == 'critical'),
          priority: Value(task.priority),
          requiresCorrectiveActionOnFail: Value(task.priority == 'critical'),
          fixInstructions: Value(task.fixInstructions),
          equipmentTypeId: Value(equipmentTypeId),
          createdAt: DateTime.now(),
        ),
      );
      await (update(
        taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );

      final venueTypeNames = _segmentVenueTypeNames[task.segment] ?? const [];
      for (final vtName in venueTypeNames) {
        final vtId = venueTypeIdByName[vtName];
        if (vtId == null) continue;
        await into(taskTemplateVenueTypes).insert(
          TaskTemplateVenueTypesCompanion.insert(
            taskTemplateGroupId: insertedId,
            venueTypeId: vtId,
          ),
        );
      }
    }

    final templateGroupIdByTitle = {
      for (final row in await select(taskTemplates).get())
        row.title: row.templateGroupId,
    };
    final frequencyByTitle = {
      for (final task in _clusterFTasks) task.title: task.frequency,
    };

    // Same resolve-or-create-then-merge preset loop introduced in Cluster D
    // and reused in Cluster E. Safe to rerun: every step is idempotent.
    for (final preset in _clusterFPresets) {
      final existingPreset = await (select(
        taskPresets,
      )..where((p) => p.name.equals(preset.name))).getSingleOrNull();

      final int presetId;
      if (existingPreset != null) {
        presetId = existingPreset.id;
      } else {
        final equipmentTypeId = preset.equipmentTypeName == null
            ? null
            : equipmentTypeIdByName[preset.equipmentTypeName];
        presetId = await into(taskPresets).insert(
          TaskPresetsCompanion.insert(
            name: preset.name,
            equipmentTypeId: Value(equipmentTypeId),
            segment: Value(preset.segment),
            createdAt: DateTime.now(),
          ),
        );
      }

      final existingItemGroupIds = (await (select(
        taskPresetItems,
      )..where((i) => i.presetId.equals(presetId))).get())
          .map((i) => i.taskTemplateGroupId)
          .toSet();

      final memberVenueTypeIds = <int>{};
      for (final title in preset.itemTitles) {
        final groupId = templateGroupIdByTitle[title];
        final frequency = frequencyByTitle[title];
        if (groupId == null || frequency == null) continue;

        if (!existingItemGroupIds.contains(groupId)) {
          await into(taskPresetItems).insert(
            TaskPresetItemsCompanion.insert(
              presetId: presetId,
              taskTemplateGroupId: groupId,
              defaultFrequency: frequency,
            ),
          );
        }

        final taggedRows = await (select(
          taskTemplateVenueTypes,
        )..where((j) => j.taskTemplateGroupId.equals(groupId))).get();
        memberVenueTypeIds.addAll(taggedRows.map((r) => r.venueTypeId));
      }

      final existingPresetVenueTypeIds = (await (select(
        taskPresetVenueTypes,
      )..where((j) => j.presetId.equals(presetId))).get())
          .map((j) => j.venueTypeId)
          .toSet();
      for (final vtId in memberVenueTypeIds) {
        if (existingPresetVenueTypeIds.contains(vtId)) continue;
        await into(taskPresetVenueTypes).insert(
          TaskPresetVenueTypesCompanion.insert(
            presetId: presetId,
            venueTypeId: vtId,
          ),
        );
      }
    }
  }

  Future<int> _ensureDefaultOrganisationAndSite() async {
    final existingSites = await select(sites).get();
    if (existingSites.isNotEmpty) return existingSites.first.id;

    final organisationId = await into(organisations).insert(
      OrganisationsCompanion.insert(
        name: 'My Organisation',
        createdAt: DateTime.now(),
      ),
    );
    return into(sites).insert(
      SitesCompanion.insert(
        organisationId: organisationId,
        name: 'Main Site',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _backfillSiteIds(int siteId) async {
    await (update(users)..where((u) => u.siteId.isNull())).write(
      UsersCompanion(siteId: Value(siteId)),
    );
    await (update(areas)..where((a) => a.siteId.isNull())).write(
      AreasCompanion(siteId: Value(siteId)),
    );
    await (update(
      equipmentInstances,
    )..where((e) => e.siteId.isNull())).write(
      EquipmentInstancesCompanion(siteId: Value(siteId)),
    );
    await (update(
      taskSchedules,
    )..where((s) => s.siteId.isNull())).write(
      TaskSchedulesCompanion(siteId: Value(siteId)),
    );
    await (update(
      taskSubmissions,
    )..where((t) => t.siteId.isNull())).write(
      TaskSubmissionsCompanion(siteId: Value(siteId)),
    );
    await (update(
      shiftHandoverNotes,
    )..where((n) => n.siteId.isNull())).write(
      ShiftHandoverNotesCompanion(siteId: Value(siteId)),
    );
    await (update(
      sessionSummaries,
    )..where((s) => s.siteId.isNull())).write(
      SessionSummariesCompanion(siteId: Value(siteId)),
    );
    // notificationRules is deliberately excluded — see that column's doc
    // comment. Pre-existing rows stay null (org-wide), not backfilled.
  }

  // Safe to run while the app holds the live connection open — VACUUM INTO
  // produces a complete, consistent, compacted snapshot without touching
  // the live file or risking a half-written WAL.
  Future<void> backupTo(String destinationPath) async {
    await customStatement('VACUUM INTO ?', [destinationPath]);
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kitchen_control_db');
  }
}
