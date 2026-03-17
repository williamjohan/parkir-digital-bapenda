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

  // 3. Fungsi Ambil total kendaraan
  /// Mengambil total kendaraan (Motor & Mobil) yang sudah PAID HARI INI
  Future<Map<String, int>> getDailyVehicleCount() async {
    final db = await database;

    // Ambil tanggal hari ini dalam format YYYY-MM-DD
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Query efisien: Kelompokkan dan hitung langsung di level Database
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

  // 4. Fungsi Mengambil Transaksi yang Belum Terkirim (Gagal/Offline)
  // Asumsi: Saat offline, Anda menyimpan status = 'PENDING'
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions() async {
    final db = await instance.database;
    // Mengambil semua baris yang statusnya sesuai dengan kamus arsitektur baru kita
    return await db.query(
      tableTransactions,
      where: 'status IN (?, ?, ?)',
      whereArgs: ['PENDING_PAYMENT', 'PAID_OFFLINE', 'FREE_OFFLINE'],
    );
  }

  // 5. Fungsi Membersihkan Data (Cleanup) Setelah Sukses Kirim ke BE
  Future<int> deleteTransaction(String idTransaksi) async {
    final db = await instance.database;
    return await db.delete(
      tableTransactions,
      where: 'id_transaksi_lokal = ?',
      whereArgs: [idTransaksi],
    );
  }
}
