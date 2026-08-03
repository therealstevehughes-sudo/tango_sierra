enum RoleTier { top, mid, base }

enum TemperatureUnit { celsius, fahrenheit }

class User {
  final int id;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;
  final TemperatureUnit preferredTemperatureUnit;
  final int siteId;
  final bool active;
  final DateTime? deactivatedAt;
  final int? deactivatedByUserId;

  const User({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    this.preferredTemperatureUnit = TemperatureUnit.celsius,
    required this.siteId,
    this.active = true,
    this.deactivatedAt,
    this.deactivatedByUserId,
  });
}
