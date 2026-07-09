import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/printer/i_printer_service.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

part 'printer_state.dart';

@injectable
class PrinterCubit extends Cubit<PrinterState> {
  final IPrinterService _printerService;
  final ISecureStorageManager _secureStorage;

  PrinterCubit(this._printerService, this._secureStorage)
    : super(PrinterInitial());

  Future<void> scanDevices() async {
    final currentState = state;

    AppLogger.debug("========== SCAN DEVICES ==========");

    if (currentState is PrinterLoaded) {
      emit(
        PrinterLoaded(
          devices: currentState.devices,
          connectedDevice: currentState.connectedDevice,
          isLoading: true,
        ),
      );
    } else {
      emit(PrinterLoading());
    }

    try {
      // Request permission terlebih dahulu
      final granted = await PermissionUtils.requestBluetoothPermission();

      if (!granted) {
        AppLogger.error("Permission Bluetooth ditolak.");

        emit(
          PrinterLoaded(
            devices: currentState is PrinterLoaded ? currentState.devices : [],
            connectedDevice: currentState is PrinterLoaded
                ? currentState.connectedDevice
                : null,
            isLoading: false,
          ),
        );

        emit(PrinterError("Permission Bluetooth belum diberikan."));

        return;
      }

      AppLogger.debug("Permission granted");

      final devices = await _printerService.getPairedDevices();

      AppLogger.debug("Jumlah device ditemukan : ${devices.length}");

      final isConnected = await _printerService.isConnected;

      BluetoothDevice? connectedDevice;

      if (isConnected && devices.isNotEmpty) {
        connectedDevice = devices.first;
      }

      if (isClosed) return;

      emit(
        PrinterLoaded(
          devices: devices,
          connectedDevice: connectedDevice,
          isLoading: false,
        ),
      );

      AppLogger.debug("Scan selesai");
    } catch (e, stackTrace) {
      AppLogger.error("Gagal scan printer", e, stackTrace);

      if (isClosed) return;

      emit(
        PrinterLoaded(
          devices: currentState is PrinterLoaded ? currentState.devices : [],
          connectedDevice: currentState is PrinterLoaded
              ? currentState.connectedDevice
              : null,
          isLoading: false,
        ),
      );

      emit(PrinterError("Gagal memindai perangkat Bluetooth."));
    }
  }
  // Future<void> scanDevices() async {
  //   final currentState = state;

  //   if (currentState is PrinterLoaded) {
  //     emit(
  //       PrinterLoaded(
  //         devices: currentState.devices,
  //         connectedDevice: currentState.connectedDevice,
  //         isLoading: true, // Beri sinyal loading saja
  //       ),
  //     );
  //   } else {
  //     emit(PrinterLoading());
  //   }

  //   try {
  //     await Future.delayed(const Duration(milliseconds: 1000));
  //     final devices = await _printerService.getPairedDevices();
  //     final isConnected = await _printerService.isConnected;

  //     if (isClosed) return;

  //     emit(
  //       PrinterLoaded(
  //         devices: devices,
  //         connectedDevice: isConnected ? devices.firstOrNull : null,
  //         isLoading: false, // Matikan sinyal loading
  //       ),
  //     );
  //   } catch (e) {
  //     if (isClosed) return;
  //     emit(PrinterError('Gagal memindai perangkat Bluetooth.'));
  //     if (currentState is PrinterLoaded) {
  //       emit(
  //         PrinterLoaded(
  //           devices: currentState.devices,
  //           connectedDevice: currentState.connectedDevice,
  //           isLoading: false,
  //         ),
  //       );
  //     }
  //   }
  // }

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

  Future<void> disconnect() async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    await _printerService.disconnect();
    await _secureStorage.clearPrinterMacAddress();

    if (isClosed) return;

    emit(PrinterLoaded(devices: currentState.devices, connectedDevice: null));
  }

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
      final connectSuccess = await _printerService.connect(targetDevice);
      if (!connectSuccess) {
        AppLogger.error(
          "🖨️ [Auto-Print] Gagal terhubung ke printer $savedMacAddress.",
        );
        return false;
      }
      AppLogger.debug("🖨️ [Auto-Print] Konek Siluman Sukses! Mencetak...");
      return await _printerService.printReceipt(transaction, deviceId, profile);
    } catch (e) {
      AppLogger.error("🖨️ [Auto-Print] Terjadi kesalahan fatal: $e");
      return false;
    }
  }
}
