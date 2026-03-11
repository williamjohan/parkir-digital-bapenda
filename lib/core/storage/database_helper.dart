import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern agar koneksi DB tidak berlipat ganda
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Nama Tabel
  static const String tableTransactions = 'transactions';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bapenda_parkir.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Mengeksekusi DDL (Data Definition Language) untuk membuat tabel 10 Kolom
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id_transaksi_lokal TEXT PRIMARY KEY,
        nominal INTEGER NOT NULL,
        plat_nomor TEXT NOT NULL,
        kategori_kendaraan TEXT NOT NULL,
        waktu_transaksi TEXT NOT NULL,
        status TEXT NOT NULL,
        id_jukir TEXT NOT NULL,
        nama_jukir TEXT NOT NULL,
        nop TEXT NOT NULL,
        foto_kendaraan TEXT NOT NULL
      )
    ''');
  }

  // --- FUNGSI CRUD DASAR UNTUK FASE SELANJUTNYA ---

  // 1. Fungsi Insert (Saat klik "Lanjut Bayar")
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      tableTransactions,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. Fungsi Update Status (Saat klik "OK" di layar QRIS)
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
}
