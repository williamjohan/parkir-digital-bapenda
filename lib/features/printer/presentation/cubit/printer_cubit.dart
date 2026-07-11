import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
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

  StreamSubscription<BtcDevice>? _discoverySub;
  StreamSubscription<BtcDevice?>? _connectionSub;
  StreamSubscription<bool>? _bluetoothStateSub; // 🚀 BARU
  bool? _lastBluetoothOn;

  PrinterCubit(this._printerService, this._secureStorage)
    : super(PrinterInitial()) {
    // 🚀 Auto-sync state setiap kali status koneksi berubah di level service,
    // termasuk saat printer disconnect sendiri di luar kontrol UI, ATAU saat
    // cubit ini instance baru (misal karena factory injection) tapi service
    // singleton-nya masih punya koneksi aktif dari sebelumnya.
    _connectionSub = _printerService.connectionChanges.listen((device) {
      final s = state;
      if (s is PrinterLoaded) {
        emit(
          PrinterLoaded(
            devices: s.devices,
            discoveredDevices: s.discoveredDevices,
            connectedDevice: device,
            isLoading: s.isLoading,
            isScanning: s.isScanning,
          ),
        );
      }
    });

    _bluetoothStateSub = _printerService.bluetoothStateChanges.listen((isOn) {
      final wasOn = _lastBluetoothOn;
      _lastBluetoothOn = isOn;

      if (wasOn == false && isOn) {
        AppLogger.debug('>>> [PRINTER] Bluetooth aktif lagi, auto-refresh.');
        scanDevices();
        return;
      }
      // Abaikan kalau ini bukan transisi ON->OFF (misal event pertama saat
      // subscribe, atau Bluetooth balik nyala lagi).
      if (wasOn != true || isOn) return;

      AppLogger.debug(
        '>>> [PRINTER] Bluetooth HP dimatiin user di tengah proses.',
      );

      _discoverySub?.cancel();
      _printerService.stopDiscovery();

      final s = state;
      if (s is PrinterLoaded) {
        emit(
          PrinterLoaded(
            devices: s.devices,
            discoveredDevices: s.discoveredDevices,
            connectedDevice: null,
            isLoading: false,
            isScanning: false,
          ),
        );
      }
      emit(PrinterBluetoothOffRequiresAction());
    });
  }

  Future<bool> checkBluetoothOn() async {
    final bluetoothOn = await _printerService.isBluetoothOn;
    if (!bluetoothOn) {
      emit(PrinterBluetoothOffRequiresAction());
      return false;
    }
    return true;
  }

  Future<void> refreshPairedDevices() async {
    final currentState = state;
    try {
      final granted = await checkAndRequestPermissions();
      if (!granted) return;

      final bluetoothOn = await _printerService.isBluetoothOn;
      if (!bluetoothOn) {
        emit(PrinterBluetoothOffRequiresAction());
        return;
      }

      final devices = await _printerService.getPairedDevices();
      if (isClosed) return;

      emit(
        PrinterLoaded(
          devices: devices,
          discoveredDevices: currentState is PrinterLoaded
              ? currentState.discoveredDevices
              : const [],
          connectedDevice: _printerService.connectedDevice,
          isScanning: currentState is PrinterLoaded && currentState.isScanning,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error("Gagal refresh daftar printer", e, stackTrace);
      if (isClosed) return;
      emit(PrinterError("Gagal memuat ulang daftar perangkat."));
      if (currentState is PrinterLoaded) {
        emit(
          PrinterLoaded(
            devices: currentState.devices,
            discoveredDevices: currentState.discoveredDevices,
            connectedDevice: currentState.connectedDevice,
          ),
        );
      }
    }
  }

  Future<bool> checkAndRequestPermissions() async {
    final currentState = state;
    try {
      final status = await PermissionUtils.requestBluetoothPermission();

      if (status == BluetoothPermissionStatus.granted) {
        AppLogger.debug("Izin lengkap diberikan.");
        return true;
      }

      if (status == BluetoothPermissionStatus.permanentlyDenied ||
          status == BluetoothPermissionStatus.denied) {
        AppLogger.error("Izin Bluetooth/Lokasi ditolak atau tidak lengkap.");
        emit(PrinterPermissionRequiresAction());
        _restoreLoadedState(currentState);
        return false;
      }

      AppLogger.error("Status permission error.");
      emit(PrinterError("Gagal memeriksa izin perangkat."));
      _restoreLoadedState(currentState);
      return false;
    } catch (e, stackTrace) {
      AppLogger.error("Exception saat mengecek permission", e, stackTrace);
      emit(PrinterError("Terjadi kesalahan sistem saat meminta izin."));
      _restoreLoadedState(currentState);
      return false;
    }
  }

  Future<void> scanDevices() async {
    final currentState = state;
    AppLogger.debug("========== SCAN DEVICES ==========");

    if (currentState is PrinterLoaded) {
      emit(
        PrinterLoaded(
          devices: currentState.devices,
          discoveredDevices: currentState.discoveredDevices,
          connectedDevice: currentState.connectedDevice,
          isLoading: true,
          isScanning: currentState.isScanning,
        ),
      );
    } else {
      emit(PrinterLoading());
    }

    try {
      final granted = await checkAndRequestPermissions();
      if (!granted) return;

      final bluetoothOn = await _printerService.isBluetoothOn;
      if (!bluetoothOn) {
        _restoreLoadedState(currentState);
        emit(PrinterBluetoothOffRequiresAction());
        return;
      }

      final devices = await _printerService.getPairedDevices();
      AppLogger.debug("Jumlah device ditemukan : ${devices.length}");

      if (isClosed) return;

      emit(
        PrinterLoaded(
          devices: devices,
          // 🚀 Diambil LANGSUNG dari service, bukan ditebak lewat MAC tersimpan.
          connectedDevice: _printerService.connectedDevice,
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
          connectedDevice: _printerService.connectedDevice,
          isLoading: false,
        ),
      );
      emit(PrinterError("Gagal memindai perangkat Bluetooth."));
    }
  }

  // =========================================================================
  // 🚀 DISCOVERY: cari perangkat baru di sekitar (belum tentu paired)
  // =========================================================================
  Future<void> startScanning() async {
    final currentState = state;

    final granted = await checkAndRequestPermissions();
    if (!granted) return;

    final bluetoothOn = await _printerService.isBluetoothOn;
    if (!bluetoothOn) {
      emit(PrinterBluetoothOffRequiresAction());
      return;
    }

    final existingDevices = currentState is PrinterLoaded
        ? currentState.devices
        : await _printerService.getPairedDevices();
    final existingConnected = currentState is PrinterLoaded
        ? currentState.connectedDevice
        : _printerService.connectedDevice;

    emit(
      PrinterLoaded(
        devices: existingDevices,
        discoveredDevices: const [],
        connectedDevice: existingConnected,
        isScanning: true,
      ),
    );

    await _discoverySub?.cancel();
    _discoverySub = _printerService.discoveryResults.listen((device) {
      final s = state;
      if (s is! PrinterLoaded) return;
      final alreadyKnown =
          s.discoveredDevices.any((d) => d.address == device.address) ||
          s.devices.any((d) => d.address == device.address);
      if (alreadyKnown) return;

      emit(
        PrinterLoaded(
          devices: s.devices,
          discoveredDevices: [...s.discoveredDevices, device],
          connectedDevice: s.connectedDevice,
          isScanning: s.isScanning,
        ),
      );
    });

    await _printerService.startDiscovery();

    // Discovery classic Bluetooth di Android biasanya auto-stop ~12 detik,
    // kasih auto-stop di app juga biar isScanning kebalik dengan benar.
    Future.delayed(const Duration(seconds: 12), stopScanning);
  }

  Future<void> stopScanning() async {
    await _discoverySub?.cancel();
    await _printerService.stopDiscovery();
    if (isClosed) return;
    final s = state;
    if (s is PrinterLoaded) {
      emit(
        PrinterLoaded(
          devices: s.devices,
          discoveredDevices: s.discoveredDevices,
          connectedDevice: s.connectedDevice,
          isScanning: false,
        ),
      );
    }
  }

  // =========================================================================
  // 🖨️ Manual Print Receipt — TANPA fallback tebak-tebakan lagi
  // =========================================================================
  Future<bool> printReceipt(HistoryItemModel transaction) async {
    final currentState = state;
    try {
      final granted = await checkAndRequestPermissions();
      if (!granted) return false;

      final bluetoothOn = await _printerService.isBluetoothOn;
      if (!bluetoothOn) {
        emit(PrinterBluetoothOffRequiresAction());
        _restoreLoadedState(currentState);
        return false;
      }

      // Sumber kebenaran: langsung dari service.
      if (!_printerService.isConnected) {
        final savedMacAddress = await _secureStorage.getPrinterMacAddress();
        if (savedMacAddress != null && savedMacAddress.isNotEmpty) {
          final pairedDevices = await _printerService.getPairedDevices();
          BtcDevice? targetDevice;
          for (var device in pairedDevices) {
            if (device.address == savedMacAddress) {
              targetDevice = device;
              break;
            }
          }
          if (targetDevice != null) {
            await _printerService.connect(targetDevice);
          }
        }
      }

      if (!_printerService.isConnected) {
        emit(
          PrinterError(
            "Belum ada perangkat printer yang terhubung. Pastikan printer dalam kondisi MENYALA.",
          ),
        );
        _restoreLoadedState(currentState);
        return false;
      }

      // Sinkronkan UI kalau ternyata sebelumnya belum sinkron — TANPA nebak.
      if (currentState is! PrinterLoaded ||
          currentState.connectedDevice?.address !=
              _printerService.connectedDevice?.address) {
        final pairedDevices = await _printerService.getPairedDevices();
        emit(
          PrinterLoaded(
            devices: pairedDevices,
            connectedDevice: _printerService.connectedDevice,
          ),
        );
      }

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

  Future<void> connectDevice(BtcDevice device) async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    final bluetoothOn = await _printerService.isBluetoothOn;
    if (!bluetoothOn) {
      emit(PrinterBluetoothOffRequiresAction());
      return;
    }

    emit(
      PrinterLoaded(
        devices: currentState.devices,
        discoveredDevices: currentState.discoveredDevices,
        connectedDevice: currentState.connectedDevice,
        isLoading: true,
      ),
    );

    final success = await _printerService.connect(device);
    if (isClosed) return;

    if (success) {
      await _secureStorage.savePrinterMacAddress(device.address);
      AppLogger.debug("🖨️ MAC Address ${device.address} tersimpan!");

      final updatedDevices =
          currentState.devices.any((d) => d.address == device.address)
          ? currentState.devices
          : [...currentState.devices, device];

      emit(
        PrinterLoaded(
          devices: updatedDevices,
          discoveredDevices: currentState.discoveredDevices
              .where((d) => d.address != device.address)
              .toList(),
          connectedDevice: device,
        ),
      );
    } else {
      final bluetoothStillOn = await _printerService.isBluetoothOn;
      if (!bluetoothStillOn) return;
      emit(
        PrinterError(
          'Gagal terhubung ke ${device.displayName}. Pastikan printer menyala.',
        ),
      );
      emit(
        PrinterLoaded(
          devices: currentState.devices,
          discoveredDevices: currentState.discoveredDevices,
        ),
      );
    }
  }

  Future<void> disconnect() async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    await _printerService.disconnect();
    await _secureStorage.clearPrinterMacAddress();

    if (isClosed) return;
    emit(
      PrinterLoaded(
        devices: currentState.devices,
        discoveredDevices: currentState.discoveredDevices,
        connectedDevice: null,
      ),
    );
  }

  void _restoreLoadedState(PrinterState currentState) {
    if (currentState is PrinterLoaded) {
      emit(
        PrinterLoaded(
          devices: currentState.devices,
          discoveredDevices: currentState.discoveredDevices,
          connectedDevice: currentState.connectedDevice,
          isLoading: false,
          isScanning: currentState.isScanning,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _discoverySub?.cancel();
    _connectionSub?.cancel();
    _bluetoothStateSub?.cancel();
    return super.close();
  }
}
