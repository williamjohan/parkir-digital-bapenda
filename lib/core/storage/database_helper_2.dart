// lib/core/storage/database_helper.dart

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabaseHelper2 {
  DatabaseHelper2();

  static Database? _database;

  static const String dbName = 'surabaya_tax.db';
  static const int dbVersion = 1;

  static const String tableNopList = 'nop_list';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNopList (
        nop TEXT PRIMARY KEY,
        nama_op TEXT NOT NULL,
        alamat_op TEXT NOT NULL,
        is_digital INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// Hapus seluruh NOP lama lalu insert yang baru
  Future<void> saveNopList(List<Map<String, dynamic>> nopList) async {
    final db = await database;

    final batch = db.batch();

    batch.delete(tableNopList);

    for (final item in nopList) {
      batch.insert(tableNopList, {
        'nop': item['nop'],
        'nama_op': item['nama_op'],
        'alamat_op': item['alamat_op'],
        // 'is_digital': (item['isDigital'] ?? false) ? 1 : 0, >>> salah
        'is_digital': (item['is_digital'] ?? false) ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  /// Ambil seluruh NOP
  Future<List<Map<String, dynamic>>> getNopList() async {
    final db = await database;

    return await db.query(tableNopList, orderBy: 'nama_op ASC');
  }

  /// Ambil NOP berdasarkan status digital
  Future<List<Map<String, dynamic>>> getNopListByIsDigital(
    bool isDigital,
  ) async {
    final db = await database;

    return await db.query(
      tableNopList,
      where: 'is_digital = ?',
      whereArgs: [isDigital ? 1 : 0],
      orderBy: 'nama_op ASC',
    );
  }

  /// Hapus semua data NOP
  Future<void> clearNopList() async {
    final db = await database;

    await db.delete(tableNopList);
  }

  /// Tutup database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
