import '../../core/storage/app_database.dart';
import '../../core/utils/pin_hasher.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAll();
  Future<User?> authenticate({required int userId, required String pin});
}

class DriftUserRepository implements UserRepository {
  DriftUserRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<User>> getAll() async {
    final rows = await _db.select(_db.users).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<User?> authenticate({
    required int userId,
    required String pin,
  }) async {
    final query = _db.select(_db.users)..where((u) => u.id.equals(userId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    if (hashPin(pin, row.pinSalt) != row.pinHash) return null;

    return _toModel(row);
  }

  User _toModel(UserEntity row) {
    return User(
      id: row.id,
      name: row.name,
      jobTitle: row.jobTitle,
      roleTier: RoleTier.values.byName(row.roleTier),
    );
  }
}
