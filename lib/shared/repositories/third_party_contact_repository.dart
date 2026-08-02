import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/third_party_contact.dart';

abstract class ThirdPartyContactRepository {
  Future<List<ThirdPartyContact>> getAll();
  Future<ThirdPartyContact> create({
    required String name,
    String? company,
    String? specialty,
    String? phone,
    String? email,
    String? notes,
    int? siteId,
    required int createdByUserId,
  });
  Future<void> setActive(int id, bool active);
}

class DriftThirdPartyContactRepository implements ThirdPartyContactRepository {
  DriftThirdPartyContactRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<ThirdPartyContact>> getAll() async {
    final rows = await _db.select(_db.thirdPartyContacts).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<ThirdPartyContact> create({
    required String name,
    String? company,
    String? specialty,
    String? phone,
    String? email,
    String? notes,
    int? siteId,
    required int createdByUserId,
  }) async {
    if (phone == null && email == null) {
      throw ArgumentError(
        'A third-party contact must have a phone number or an email',
      );
    }

    final id = await _db
        .into(_db.thirdPartyContacts)
        .insert(
          ThirdPartyContactsCompanion.insert(
            name: name,
            company: Value(company),
            specialty: Value(specialty),
            phone: Value(phone),
            email: Value(email),
            notes: Value(notes),
            siteId: Value(siteId),
            createdByUserId: createdByUserId,
            createdAt: DateTime.now(),
          ),
        );
    final row = await (_db.select(
      _db.thirdPartyContacts,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await (_db.update(
      _db.thirdPartyContacts,
    )..where((t) => t.id.equals(id))).write(
      ThirdPartyContactsCompanion(active: Value(active)),
    );
  }

  ThirdPartyContact _toModel(ThirdPartyContactEntity row) {
    return ThirdPartyContact(
      id: row.id,
      name: row.name,
      company: row.company,
      specialty: row.specialty,
      phone: row.phone,
      email: row.email,
      notes: row.notes,
      siteId: row.siteId,
      createdByUserId: row.createdByUserId,
      createdAt: row.createdAt,
      active: row.active,
    );
  }
}
