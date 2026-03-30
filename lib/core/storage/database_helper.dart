// lib/core/storage/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  static const String tableTransactions = 'transactions';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bapenda_parkir.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // [PERBAIKAN]: Naik versi ke 2, dan tambahkan onUpgrade
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // [PERBAIKAN SKEMA BARU]
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id_transaksi_lokal TEXT PRIMARY KEY,
        nominal INTEGER NOT NULL,
        plat_nomor TEXT, 
        kategori_kendaraan TEXT NOT NULL,
        waktu_transaksi TEXT NOT NULL,
        status TEXT NOT NULL,
        id_jukir TEXT NOT NULL,
        nama_jukir TEXT NOT NULL,
        nop TEXT NOT NULL,
        foto_kendaraan TEXT, 
        mode_plat INTEGER NOT NULL,
        is_sync INTEGER NOT NULL DEFAULT 0
      )
    ''');
    // Keterangan: plat_nomor dan foto_kendaraan sudah TIDAK memiliki 'NOT NULL'
  }

  // [SCRIPT MIGRASI OTOMATIS]
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Karena SQLite tidak mendukung ALTER COLUMN DROP NOT NULL,
      // kita harus merename tabel lama, membuat tabel baru, dan memindahkan isinya.
      await db.execute(
        'ALTER TABLE $tableTransactions RENAME TO tmp_transactions',
      );

      await _createDB(db, newVersion);

      // Pindahkan data lama. Set default mode_plat = 1 (Pakai Plat) dan is_sync = 0.
      await db.execute('''
        INSERT INTO $tableTransactions(id_transaksi_lokal, nominal, plat_nomor, kategori_kendaraan, waktu_transaksi, status, id_jukir, nama_jukir, nop, foto_kendaraan, mode_plat, is_sync)
        SELECT id_transaksi_lokal, nominal, plat_nomor, kategori_kendaraan, waktu_transaksi, status, id_jukir, nama_jukir, nop, foto_kendaraan, 1, 0
        FROM tmp_transactions
      ''');

      await db.execute('DROP TABLE tmp_transactions');
    }
  }

  // --- FUNGSI CRUD DASAR ---

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      tableTransactions,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTransactionStatus(
    String idTransaksi,
    String newStatus,
  ) async {
    final db = await instance.database;
    return await db.update(
      tableTransactions,
      {'status': newStatus},
      where: 'id_transaksi_lokal = ?',
      whereArgs: [idTransaksi],
    );
  }

  // [FUNGSI BARU]: Update status sinkronisasi menjadi 1 (Sukses dikirim ke BE)
  Future<int> markTransactionAsSynced(String idTransaksi) async {
    final db = await instance.database;
    return await db.update(
      tableTransactions,
      {'is_sync': 1},
      where: 'id_transaksi_lokal = ?',
      whereArgs: [idTransaksi],
    );
  }

  Future<Map<String, int>> getDailyVehicleCount() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT kategori_kendaraan, COUNT(*) as total
      FROM transactions 
      WHERE status IN ('PAID_OFFLINE', 'FREE_OFFLINE') AND substr(waktu_transaksi, 1, 10) = ?
      GROUP BY kategori_kendaraan
      ''',
      [today],
    );

    int motorCount = 0;
    int mobilCount = 0;

    for (var row in result) {
      final kategori = row['kategori_kendaraan'].toString().toLowerCase();
      if (kategori == 'motor') motorCount = row['total'] as int;
      if (kategori == 'mobil') mobilCount = row['total'] as int;
    }

    return {'motor': motorCount, 'mobil': mobilCount};
  }

  // [PERBAIKAN]: Fungsi ini sekarang melihat is_sync == 0, bukan sekadar status.
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions() async {
    final db = await instance.database;
    return await db.query(
      tableTransactions,
      // Kita ambil semua yang belum tersinkronisasi, asalkan transaksi itu sudah SELESAI di HP
      where: 'is_sync = ? AND status IN (?, ?)',
      whereArgs: [0, 'PAID_OFFLINE', 'FREE_OFFLINE'],
    );
  }

  Future<int> deleteTransaction(String idTransaksi) async {
    final db = await instance.database;
    return await db.delete(
      tableTransactions,
      where: 'id_transaksi_lokal = ?',
      whereArgs: [idTransaksi],
    );
  }
}
