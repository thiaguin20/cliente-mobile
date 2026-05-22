import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/customer.dart';

class ClientRepository {
  const ClientRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<List<Customer>> getAll({String query = ''}) async {
    final database = await _appDatabase.database;
    final trimmedQuery = query.trim();
    final rows = await database.query(
      'customers',
      where: trimmedQuery.isEmpty ? null : 'name LIKE ? OR phone LIKE ?',
      whereArgs: trimmedQuery.isEmpty
          ? null
          : ['%$trimmedQuery%', '%$trimmedQuery%'],
      orderBy: 'name ASC',
    );

    return rows.map(Customer.fromMap).toList(growable: false);
  }

  Future<Customer?> getById(int id) async {
    final database = await _appDatabase.database;
    final rows = await database.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Customer.fromMap(rows.first);
  }

  Future<int> insert(Customer customer) async {
    final database = await _appDatabase.database;
    return database.insert(
      'customers',
      customer.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> update(Customer customer) async {
    final database = await _appDatabase.database;
    await database.update(
      'customers',
      customer.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> delete(int id) async {
    final database = await _appDatabase.database;
    await database.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}
