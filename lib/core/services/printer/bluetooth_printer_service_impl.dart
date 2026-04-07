import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:injectable/injectable.dart';
import '../../../features/transaction_history/data/models/history_item_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/receipt_formatter.dart';
import 'i_printer_service.dart';

@LazySingleton(
  as: IPrinterService,
) // Gunakan ini jika Anda memakai package injectable
class BluetoothPrinterServiceImpl implements IPrinterService {
  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  @override
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      // Mengambil daftar device dari cache Android
      return await _bluetooth.getBondedDevices();
    } catch (e) {
      AppLogger.error('Gagal mengambil perangkat Bluetooth: $e');
      return [];
    }
  }

  @override
  Future<bool> get isConnected async {
    return await _bluetooth.isConnected ?? false;
  }

  @override
  Future<bool> connect(BluetoothDevice device) async {
    try {
      final connected = await isConnected;
      if (connected) {
        await disconnect(); // Putus yang lama sebelum konek yang baru
      }

      // 🚀 BYPASS ANDROID: Langsung tembak soket ke MAC Address device!
      await _bluetooth.connect(device);
      AppLogger.debug('>>> [PRINTER] Berhasil terhubung ke: ${device.name}');
      return true;
    } catch (e) {
      AppLogger.error('>>> [PRINTER ERROR] Gagal konek ke ${device.name}: $e');
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _bluetooth.disconnect();
      AppLogger.debug('>>> [PRINTER] Koneksi diputus.');
    } catch (e) {
      AppLogger.error('>>> [PRINTER ERROR] Gagal putus koneksi: $e');
    }
  }

  @override
  Future<bool> printReceipt(
    HistoryItemModel transaction,
    String deviceId,
  ) async {
    try {
      final connected = await isConnected;
      if (!connected) {
        AppLogger.error('>>> [PRINTER ERROR] Printer belum terhubung!');
        return false;
      }

      // 1. 🧠 Minta "Sang Penerjemah" merakit desain karcis menjadi Bytes
      final List<int> bytes = await ReceiptFormatter.generateBytes(
        transaction,
        deviceId,
      );

      // 2. 🚀 Minta "Sang Kurir" menembakkan Bytes ke Printer!
      // Kita pakai Uint8List karena ini format paling stabil untuk SPP Bluetooth
      await _bluetooth.writeBytes(Uint8List.fromList(bytes));

      AppLogger.debug('>>> [PRINTER SUCCESS] Karcis berhasil dicetak!');
      return true;
    } catch (e) {
      AppLogger.error('>>> [PRINTER ERROR] Gagal mencetak: $e');
      return false;
    }
  }
}
