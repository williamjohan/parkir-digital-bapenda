import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../../../features/transaction_history/data/models/history_item_model.dart';

abstract class IPrinterService {
  /// Mengambil daftar printer yang sudah di-pair (bawaan Android)
  Future<List<BluetoothDevice>> getPairedDevices();

  /// Membuka koneksi paksa (bypass RFCOMM) ke printer
  Future<bool> connect(BluetoothDevice device);

  /// Memutus koneksi printer
  Future<void> disconnect();

  /// Mengecek apakah printer sedang terhubung
  Future<bool> get isConnected;

  /// 🚀 TAMBAHKAN INI: Mengecek apakah Bluetooth HP aktif
  Future<bool> get isBluetoothOn;

  /// Mencetak karcis menggunakan data transaksi
  Future<bool> printReceipt(
    HistoryItemModel transaction,
    // String deviceId,
    // Map<String, dynamic> profile,
  );
}
