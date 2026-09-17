import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart' show RoleTier;

// Ad-hoc task path (2026-09-17) — the extensible mechanism. Adding a third
// kind later means adding one more class here and appending it to
// [adHocTaskKinds]; AdHocTaskScreen's chooser/template-picker iterate this
// list generically and never hard-code which kinds exist.
sealed class AdHocTaskKind {
  const AdHocTaskKind();

  String get label;

  /// Whether [template] belongs to this kind — used both to build the
  /// template picker and to decide whether this kind has anything to show
  /// at all for a given site (a kind with zero matches is hidden from the
  /// chooser, never offered as a dead option).
  bool matches(TaskTemplate template);
}

/// Deliveries — reuses `requiresSupplierSelection`, the same flag the
/// scheduled carousel already uses to show the delivery-detail form.
class DeliveryCheckKind extends AdHocTaskKind {
  const DeliveryCheckKind();

  @override
  String get label => 'Delivery check';

  @override
  bool matches(TaskTemplate template) => template.requiresSupplierSelection;
}

/// Cooking / reheating / cooling / spot temperature checks — any template
/// with a temperature unit. Deliberately broader than just the three named
/// scenarios (cooking/reheating/cooling): a genuinely ad-hoc "spot check"
/// on any temperature-reading template (e.g. an off-schedule fridge check)
/// is the same shape of thing and shouldn't need its own separate kind.
class TemperatureCheckKind extends AdHocTaskKind {
  const TemperatureCheckKind();

  @override
  String get label => 'Temperature check';

  @override
  bool matches(TaskTemplate template) =>
      template.unit == 'celsius' || template.unit == 'fahrenheit';
}

const adHocTaskKinds = <AdHocTaskKind>[
  DeliveryCheckKind(),
  TemperatureCheckKind(),
];

/// Templates already in use at this site (via some TaskSchedule referencing
/// their group, regardless of who it's assigned to) that also belong to
/// [kind] and are applicable to base tier — the "in use at this site, not
/// every global template" filter, applied generically for any kind.
List<TaskTemplate> templatesForKind(
  AdHocTaskKind kind,
  List<TaskTemplate> allTemplates,
  Set<int> siteTemplateGroupIds,
) {
  return allTemplates
      .where(
        (t) =>
            siteTemplateGroupIds.contains(t.templateGroupId) &&
            t.applicableRoleTiers.contains(RoleTier.base) &&
            kind.matches(t),
      )
      .toList();
}
