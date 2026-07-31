enum RoleTier { top, mid, base }

enum TemperatureUnit { celsius, fahrenheit }

class User {
  final int id;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;
  final TemperatureUnit preferredTemperatureUnit;

  const User({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    this.preferredTemperatureUnit = TemperatureUnit.celsius,
  });
}
