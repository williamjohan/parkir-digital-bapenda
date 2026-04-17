import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/storage/secure_storage_manager.dart';
import '../../../../core/services/printer/i_printer_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

part 'printer_state.dart';

@injectable
class PrinterCubit extends Cubit<PrinterState> {
  final IPrinterService _printerService;
  final ISecureStorageManager _secureStorage;

  PrinterCubit(this._printerService, this._secureStorage)
    : super(PrinterInitial());

  // 1. Memindai perangkat Bluetooth di sekitar/yang sudah dipair
  Future<void> scanDevices() async {
    emit(PrinterLoading());
    try {
      final devices = await _printerService.getPairedDevices();
      final isConnected = await _printerService.isConnected;

      // 🚀 GEMBOK PENGAMAN: Cegah crash jika Jukir tutup halaman saat loading!
      if (isClosed) return;

      emit(
        PrinterLoaded(
          devices: devices,
          connectedDevice: isConnected ? devices.firstOrNull : null,
        ),
      );
    } catch (e) {
      if (isClosed) return; // 🚀 Gembok juga di catch!
      emit(PrinterError('Gagal memindai perangkat Bluetooth.'));
    }
  }

  // 2. Konek ke Printer yang dipilih Jukir
  Future<void> connectDevice(BluetoothDevice device) async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    emit(
      PrinterLoaded(
        devices: currentState.devices,
        connectedDevice: currentState.connectedDevice,
        isLoading: true,
      ),
    );

    final success = await _printerService.connect(device);

    if (isClosed) return;

    if (success) {
      if (device.address != null) {
        await _secureStorage.savePrinterMacAddress(device.address!);
        AppLogger.debug("🖨️ MAC Address ${device.address} tersimpan!");
      }

      emit(
        PrinterLoaded(devices: currentState.devices, connectedDevice: device),
      );
    } else {
      emit(
        PrinterError(
          'Gagal terhubung ke ${device.name}. Pastikan printer menyala.',
        ),
      );
      emit(PrinterLoaded(devices: currentState.devices));
    }
  }

  // 3. Putuskan koneksi
  Future<void> disconnect() async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    await _printerService.disconnect();

    // 🚀 HAPUS MAC ADDRESS DARI BRANKAS AGAR AUTO-PRINT BERHENTI!
    await _secureStorage.clearPrinterMacAddress();

    if (isClosed) return;

    emit(PrinterLoaded(devices: currentState.devices, connectedDevice: null));
  }

  // 4. Print Karcis
  Future<bool> printReceipt(
    HistoryItemModel transaction,
    String deviceId,
    Map<String, dynamic> profile,
  ) async {
    final success = await _printerService.printReceipt(
      transaction,
      deviceId,
      profile,
    );

    return success;
  }

  // 5. Auto connect & Silent Print
  Future<bool> autoConnectAndPrint(
    HistoryItemModel transaction,
    String deviceId,
    Map<String, dynamic> profile,
  ) async {
    try {
      final isConnected = await _printerService.isConnected;
      if (isConnected) {
        AppLogger.debug(
          "🖨️ [Auto-Print] Printer sudah terhubung. Langsung cetak!",
        );
        return await _printerService.printReceipt(
          transaction,
          deviceId,
          profile,
        );
      }

      final savedMacAddress = await _secureStorage.getPrinterMacAddress();
      if (savedMacAddress == null || savedMacAddress.isEmpty) {
        AppLogger.debug(
          "🖨️ [Auto-Print] Dibatalkan: Tidak ada Printer yang tersimpan.",
        );
        return false;
      }

      AppLogger.debug(
        "🖨️ [Auto-Print] Mencoba menyambung siluman ke MAC: $savedMacAddress...",
      );
      final pairedDevices = await _printerService.getPairedDevices();

      BluetoothDevice? targetDevice;
      for (var device in pairedDevices) {
        if (device.address == savedMacAddress) {
          targetDevice = device;
          break;
        }
      }

      if (targetDevice == null) {
        AppLogger.error(
          "🖨️ [Auto-Print] Gagal: MAC Address $savedMacAddress tidak ditemukan di daftar Paired Devices HP ini.",
        );
        return false;
      }

      // 4. Lakukan Silent Connect
      final connectSuccess = await _printerService.connect(targetDevice);
      if (!connectSuccess) {
        AppLogger.error(
          "🖨️ [Auto-Print] Gagal terhubung ke printer $savedMacAddress.",
        );
        return false;
      }

      // 5. Jika sukses nyambung, langsung tembak Karcis!
      AppLogger.debug("🖨️ [Auto-Print] Konek Siluman Sukses! Mencetak...");
      return await _printerService.printReceipt(transaction, deviceId, profile);
    } catch (e) {
      AppLogger.error("🖨️ [Auto-Print] Terjadi kesalahan fatal: $e");
      return false;
    }
  }
}
