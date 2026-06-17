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
        alamat_op TEXT NOT NULL
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
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  /// Ambil seluruh NOP
  Future<List<Map<String, dynamic>>> getNopList() async {
    final db = await database;

    return await db.query(tableNopList, orderBy: 'nama_op ASC');
  }

  /// Ambil 1 NOP
  Future<Map<String, dynamic>?> getNopByNop(String nop) async {
    final db = await database;

    final result = await db.query(
      tableNopList,
      where: 'nop = ?',
      whereArgs: [nop],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first;
  }

  /// Hapus semua data NOP
  Future<void> clearNopList() async {
    final db = await database;

    await db.delete(tableNopList);
  }

  /// Insert/update satu NOP
  Future<void> saveNop(String nop, String namaOp, String alamatOp) async {
    final db = await database;

    await db.insert(tableNopList, {
      'nop': nop,
      'nama_op': namaOp,
      'alamat_op': alamatOp,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Tutup database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
