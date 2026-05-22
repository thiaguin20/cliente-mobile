import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/service.dart';
import '../models/service_status.dart';

class ServiceRepository {
  const ServiceRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<List<ClientService>> getAll({
    String query = '',
    ServiceStatus? status,
    int? customerId,
  }) async {
    final database = await _appDatabase.database;
    final whereParts = <String>[];
    final whereArgs = <Object?>[];
    final trimmedQuery = query.trim();

    if (trimmedQuery.isNotEmpty) {
      whereParts.add('title LIKE ?');
      whereArgs.add('%$trimmedQuery%');
    }

    if (status != null) {
      whereParts.add('status = ?');
      whereArgs.add(status.key);
    }

    if (customerId != null) {
      whereParts.add('customer_id = ?');
      whereArgs.add(customerId);
    }

    final rows = await database.query(
      'services',
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'updated_at DESC',
    );

    return rows.map(ClientService.fromMap).toList(growable: false);
  }

  Future<int> insert(ClientService service) async {
    final database = await _appDatabase.database;
    return database.insert(
      'services',
      service.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> update(ClientService service) async {
    final database = await _appDatabase.database;
    await database.update(
      'services',
      service.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  Future<void> delete(int id) async {
    final database = await _appDatabase.database;
    await database.delete('services', where: 'id = ?', whereArgs: [id]);
  }
}
