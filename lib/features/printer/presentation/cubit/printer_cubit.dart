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

  // =========================================================================
  // 🚀 METHOD MANDIRI: Cek & Minta Permission dari Mana Saja (Termasuk Drawer)
  // =========================================================================
  // 🚀 PERBAIKAN: Hapus parameter BuildContext
  Future<bool> checkAndRequestPermissions() async {
    final currentState = state;
    try {
      final status = await PermissionUtils.requestBluetoothPermission();

      if (status == BluetoothPermissionStatus.granted) {
        AppLogger.debug("Permission granted via checkAndRequestPermissions");
        return true;
      }

      if (status == BluetoothPermissionStatus.permanentlyDenied) {
        AppLogger.error("Permission Bluetooth ditolak permanen.");
        emit(
          PrinterPermissionRequiresAction(),
        ); // 🚀 Emit state khusus untuk memanggil Dialog
        _restoreLoadedState(currentState);
        return false;
      }

      // Jika ditolak biasa / error
      AppLogger.error("Permission Bluetooth ditolak.");
      emit(PrinterError("Permission Bluetooth belum diberikan."));
      _restoreLoadedState(currentState);
      return false;
    } catch (e, stackTrace) {
      AppLogger.error("Gagal mengecek permission", e, stackTrace);
      emit(PrinterError("Gagal memeriksa izin perangkat."));
      _restoreLoadedState(currentState);
      return false;
    }
  }

  // =========================================================================
  // 🖨️ METHOD: Scan Devices (Menjadi lebih ringkas dan bersih)
  // =========================================================================
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
      // 🔄 Menggunakan fungsi cek permission mandiri
      final granted = await checkAndRequestPermissions();
      if (!granted) return; // Berhenti jika tidak diizinkan

      // Cek apakah Bluetooth HP Aktif
      final bluetoothOn = await _printerService.isBluetoothOn;
      if (!bluetoothOn) {
        emit(
          PrinterLoaded(
            devices: currentState is PrinterLoaded ? currentState.devices : [],
            connectedDevice: currentState is PrinterLoaded
                ? currentState.connectedDevice
                : null,
            isLoading: false,
          ),
        );
        emit(
          PrinterError(
            "Bluetooth HP Anda mati. Silakan aktifkan Bluetooth terlebih dahulu.",
          ),
        );
        return;
      }

      final devices = await _printerService.getPairedDevices();
      AppLogger.debug("Jumlah device ditemukan : ${devices.length}");

      final isConnected = await _printerService.isConnected;
      BluetoothDevice? connectedDevice;

      // Cari device berdasarkan MAC Address yang tersimpan
      if (isConnected && devices.isNotEmpty) {
        final savedMacAddress = await _secureStorage.getPrinterMacAddress();

        if (savedMacAddress != null && savedMacAddress.isNotEmpty) {
          for (var device in devices) {
            if (device.address == savedMacAddress) {
              connectedDevice = device;
              break;
            }
          }
        }
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

  // =========================================================================
  // 🖨️ METHOD: Manual Print Receipt (Tombol cetak karcis di halaman riwayat)
  // =========================================================================
  Future<bool> printReceipt(HistoryItemModel transaction) async {
    final currentState = state;

    try {
      // 🔄 Menggunakan fungsi cek permission mandiri
      final granted = await checkAndRequestPermissions();
      if (!granted) return false; // Berhenti jika tidak diizinkan

      // Cek apakah Bluetooth HP Aktif
      final bluetoothOn = await _printerService.isBluetoothOn;
      if (!bluetoothOn) {
        emit(
          PrinterError(
            "Bluetooth HP Anda mati. Silakan aktifkan Bluetooth terlebih dahulu.",
          ),
        );
        _restoreLoadedState(currentState);
        return false;
      }

      // Pengecekan Mandiri: Ambil status koneksi aktual langsung dari hardware/service
      bool isConnected = await _printerService.isConnected;

      // PEMULIHAN STATE OTOMATIS (Self-Healing)
      if (isConnected &&
          (currentState is! PrinterLoaded ||
              currentState.connectedDevice == null)) {
        final savedMacAddress = await _secureStorage.getPrinterMacAddress();
        final pairedDevices = await _printerService.getPairedDevices();
        BluetoothDevice? connectedDevice;

        if (savedMacAddress != null && savedMacAddress.isNotEmpty) {
          for (var device in pairedDevices) {
            if (device.address == savedMacAddress) {
              connectedDevice = device;
              break;
            }
          }
        }

        // Sinkronkan kembali state Cubit agar tidak bernilai null/initial lagi
        emit(
          PrinterLoaded(
            devices: pairedDevices,
            connectedDevice:
                connectedDevice ??
                (pairedDevices.isNotEmpty ? pairedDevices.first : null),
            isLoading: false,
          ),
        );
      }
      // AUTO-CONNECT OTOMATIS
      else if (!isConnected) {
        final savedMacAddress = await _secureStorage.getPrinterMacAddress();
        if (savedMacAddress != null && savedMacAddress.isNotEmpty) {
          final pairedDevices = await _printerService.getPairedDevices();
          BluetoothDevice? targetDevice;
          for (var device in pairedDevices) {
            if (device.address == savedMacAddress) {
              targetDevice = device;
              break;
            }
          }

          if (targetDevice != null) {
            final connectSuccess = await _printerService.connect(targetDevice);
            if (connectSuccess) {
              isConnected = true;
              emit(
                PrinterLoaded(
                  devices: pairedDevices,
                  connectedDevice: targetDevice,
                  isLoading: false,
                ),
              );
            }
          }
        }
      }

      // Jika setelah diusahakan maksimal lewat dua cara di atas tetap tidak terhubung
      if (!isConnected) {
        emit(
          PrinterError(
            "Belum ada perangkat printer yang terhubung. Pastikan printer dalam kondisi MENYALA.",
          ),
        );
        _restoreLoadedState(currentState);
        return false;
      }

      // Jalankan proses cetak jika validasi koneksi aktual berhasil dilewati
      final success = await _printerService.printReceipt(transaction);
      if (!success) {
        emit(
          PrinterError(
            "Gagal mencetak karcis. Pastikan kertas tersedia atau printer dalam kondisi baik.",
          ),
        );
        _restoreLoadedState(currentState);
        return false;
      }

      return true;
    } catch (e) {
      AppLogger.error("🖨️ [Print] Terjadi kesalahan fatal: $e");
      emit(PrinterError("Terjadi kesalahan sistem saat mencoba mencetak."));
      _restoreLoadedState(currentState);
      return false;
    }
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    // Kondisi 1: Cek Bluetooth HP Aktif sebelum melakukan koneksi manual
    final bluetoothOn = await _printerService.isBluetoothOn;
    if (!bluetoothOn) {
      emit(
        PrinterError(
          "Bluetooth HP Anda mati. Silakan aktifkan Bluetooth terlebih dahulu.",
        ),
      );
      return;
    }

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

  /// Helper untuk mengembalikan ke Loaded state agar data perangkat di UI tidak ter-clear saat melempar error
  void _restoreLoadedState(PrinterState currentState) {
    if (currentState is PrinterLoaded) {
      emit(
        PrinterLoaded(
          devices: currentState.devices,
          connectedDevice: currentState.connectedDevice,
          isLoading: false,
        ),
      );
    }
  }
}
