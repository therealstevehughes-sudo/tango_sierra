enum RoleTier { staff, manager }

class User {
  final int id;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;

  const User({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
  });
}
