import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _databaseName = 'cliente_mobile.db';
  static const _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
    );

    return _database!;
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        city TEXT NOT NULL,
        address TEXT NOT NULL,
        notes TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        start_date TEXT NOT NULL,
        expected_end_date TEXT,
        value REAL NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');
  }
}
