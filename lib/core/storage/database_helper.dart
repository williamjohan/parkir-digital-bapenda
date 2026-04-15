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

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 🚀 [SKEMA FINAL]: Bersih, ramping, dan 100% sesuai API Bapenda terbaru
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id_transaksi_lokal TEXT PRIMARY KEY,
        nominal INTEGER NOT NULL,
        plat_nomor TEXT, 
        kategori_kendaraan TEXT NOT NULL,
        metode_pembayaran TEXT NOT NULL, 
        waktu_transaksi TEXT NOT NULL,
        status TEXT NOT NULL,
        id_jukir TEXT NOT NULL,
        nama_jukir TEXT NOT NULL,
        -- 🚀 KOLOM 'nop' RESMI DIMUSNAHKAN DARI SINI
        foto_kendaraan TEXT, 
        mode_plat INTEGER NOT NULL,
        is_sync INTEGER NOT NULL DEFAULT 0,
        latitude TEXT, 
        longitude TEXT,
        no_kartu_kue TEXT
      )
    ''');
  }

  // [SCRIPT MIGRASI OTOMATIS]
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Migrasi V1 -> V2 (Biarkan utuh)
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableTransactions RENAME TO tmp_transactions',
      );
      await _createDB(db, newVersion);
      await db.execute('''
        INSERT INTO $tableTransactions(id_transaksi_lokal, nominal, plat_nomor, kategori_kendaraan, waktu_transaksi, status, id_jukir, nama_jukir, nop, foto_kendaraan, mode_plat, is_sync)
        SELECT id_transaksi_lokal, nominal, plat_nomor, kategori_kendaraan, waktu_transaksi, status, id_jukir, nama_jukir, nop, foto_kendaraan, 1, 0
        FROM tmp_transactions
      ''');
      await db.execute('DROP TABLE tmp_transactions');
    }

    // Migrasi V2 -> V3 (GPS)
    if (oldVersion == 2) {
      await db.execute(
        'ALTER TABLE $tableTransactions ADD COLUMN latitude TEXT',
      );
      await db.execute(
        'ALTER TABLE $tableTransactions ADD COLUMN longitude TEXT',
      );
    }

    // Migrasi V3 -> V4 (SAM Card)
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE $tableTransactions ADD COLUMN no_kartu_kue TEXT',
      );
    }

    // 🚀 [MIGRASI BARU: V4 ke V5] (Metode Pembayaran)
    if (oldVersion < 5) {
      // Kita beri nilai DEFAULT 'UNKNOWN' agar data transaksi lama tidak error / null
      await db.execute(
        'ALTER TABLE $tableTransactions ADD COLUMN metode_pembayaran TEXT NOT NULL DEFAULT "UNKNOWN"',
      );
    }
  }

  // --- FUNGSI CRUD DASAR TETAP SAMA ---
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

    // 🚀 [PENJAGA GERBANG]: Jangan biarkan status pembayaran dirusak!
    if (newStatus == 'SYNCED') {
      // Abaikan secara paksa! Gunakan updateSyncStatus atau markTransactionAsSynced.
      return 0;
    }

    final Map<String, dynamic> updateData = {'status': newStatus};
    return await db.update(
      tableTransactions,
      updateData,
      where: 'id_transaksi_lokal = ?',
      whereArgs: [idTransaksi],
    );
  }

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
      WHERE substr(waktu_transaksi, 1, 10) = ?
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

  Future<List<Map<String, dynamic>>> getUnsyncedTransactions() async {
    final db = await instance.database;
    return await db.query(
      tableTransactions,
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

  Future<Map<String, num>> getUnsyncedDailySummary() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT kategori_kendaraan, COUNT(*) as total, SUM(nominal) as total_nominal
      FROM $tableTransactions 
      WHERE substr(waktu_transaksi, 1, 10) = ? AND is_sync = 0
      GROUP BY kategori_kendaraan
      ''',
      [today],
    );

    int motorCount = 0;
    int mobilCount = 0;
    double totalNominal = 0.0;

    for (var row in result) {
      final kategori = row['kategori_kendaraan'].toString().toLowerCase();
      final count = row['total'] as int;
      final nominal = (row['total_nominal'] ?? 0).toDouble();

      if (kategori == 'motor') motorCount = count;
      if (kategori == 'mobil') mobilCount = count;
      totalNominal += nominal;
    }

    return {'motor': motorCount, 'mobil': mobilCount, 'nominal': totalNominal};
  }

  Future<List<Map<String, dynamic>>> getRecentTransactions(int limit) async {
    final db = await instance.database;
    return await db.query(
      tableTransactions,
      orderBy: 'waktu_transaksi DESC', // Urutkan dari yang paling baru
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getTodayRecentTransactions(
    int limit,
  ) async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    return await db.query(
      tableTransactions,
      where: 'substr(waktu_transaksi, 1, 10) = ?',
      whereArgs: [today],
      orderBy: 'waktu_transaksi DESC',
      limit: limit,
    );
  }
}
