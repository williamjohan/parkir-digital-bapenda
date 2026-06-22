// lib/core/storage/database_helper.dart

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabaseHelper2 {
  DatabaseHelper2();

  static Database? _database;

  static const String dbName = 'surabaya_tax.db';
  // 🚀 1. NAIKKAN VERSI: Dari 2 menjadi 3
  static const int dbVersion = 3;

  static const String tableNopList = 'nop_list';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // 🚀 2. DAFTARKAN FUNGSI MIGRASI
    );
  }

  /// Dijalankan HANYA untuk User yang baru pertama kali install aplikasi
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNopList (
        nop TEXT PRIMARY KEY,
        nama_op TEXT NOT NULL,
        alamat_op TEXT NOT NULL,
        is_digital INTEGER NOT NULL DEFAULT 0,
        pungut_tarif INTEGER NOT NULL DEFAULT 0,
        uptb INTEGER NOT NULL DEFAULT 0,
        kdCamat TEXT NOT NULL,
        nmCamat TEXT NOT NULL,
        kdLurah TEXT NOT NULL,
        nmLurah TEXT NOT NULL
      )
    ''');
  }

  /// 🚀 3. FUNGSI MIGRASI: Dijalankan untuk User lama yang melakukan update aplikasi
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Jika user berasal dari versi 1 dan update ke versi 2 (atau lebih)
    if (oldVersion < 3) {
      // Injeksi kolom baru ke tabel yang sudah ada tanpa menghapus data mereka
      await db.execute('''
        ALTER TABLE $tableNopList 
        ADD COLUMN uptb INTEGER NOT NULL DEFAULT 0;
        ADD COLUMN kdCamat TEXT NOT NULL;
        ADD COLUMN nmCamat TEXT NOT NULL;
        ADD COLUMN kdLurah TEXT NOT NULL;
        ADD COLUMN nmLurah TEXT NOT NULL;
      ''');
    }
    // Jika nanti ada versi 3, tambahkan: if (oldVersion < 3) { ... }
  }

  /// Hapus seluruh NOP lama lalu insert yang baru
  Future<void> saveNopList(List<Map<String, dynamic>> nopList) async {
    final db = await database;

    final batch = db.batch();

    batch.delete(tableNopList);

    for (final item in nopList) {
      // 🚀 THE CASTING FIX: Menangani data dari Mapper dengan sangat aman
      // Jika dari mapper sudah int, pakai langsung. Jika masih bool, konversi.
      final isDigitalVal = item['is_digital'];
      final int isDigitalInt = (isDigitalVal is bool)
          ? (isDigitalVal ? 1 : 0)
          : (isDigitalVal as int? ?? 0);

      batch.insert(tableNopList, {
        'nop': item['nop'],
        'nama_op': item['nama_op'],
        'alamat_op': item['alamat_op'],
        'is_digital': isDigitalInt,
        'pungut_tarif': item['pungut_tarif'] ?? 0, // 🚀 MASUKKAN DATA BARU
        'uptb': item['uptb'] ?? 0,
        'kdCamat': item['kdCamat'],
        'nmCamat': item['nmCamat'],
        'kdLurah': item['kdLurah'],
        'nmLurah': item['nmLurah'],
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

  Future<List<Map<String, dynamic>>> getNopListByTarif(String tarif) async {
    final db = await database;
    return await db.query(
      tableNopList,
      where: 'pungut_tarif = $tarif',
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
