import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/permission/i_permission_service.dart';
import '../../../../core/services/printer/i_printer_service.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../transaction_history/data/models/history_item_model.dart';
import 'printer_state.dart'; // Import file state freezed

@injectable
class PrinterCubit extends Cubit<PrinterState> {
  final IPrinterService _printerService;
  final ISecureStorageManager _secureStorage;
  final IPermissionService _permissionService;

  StreamSubscription<BtcDevice>? _discoverySub;
  StreamSubscription<BtcDevice?>? _connectionSub;
  StreamSubscription<bool>? _bluetoothStateSub;

  Timer? _discoveryTimer;
  bool? _lastBluetoothOn;

  PrinterCubit(
    this._printerService,
    this._secureStorage,
    this._permissionService,
  ) : super(const PrinterState.initial()) {
    _connectionSub = _printerService.connectionChanges.listen((device) {
      if (isClosed) return;
      state.maybeMap(
        loaded: (s) => emit(s.copyWith(connectedDevice: device)),
        orElse: () {},
      );
    });

    _bluetoothStateSub = _printerService.bluetoothStateChanges.listen((isOn) {
      if (isClosed) return;
      final wasOn = _lastBluetoothOn;
      _lastBluetoothOn = isOn;

      if (wasOn == false && isOn) {
        scanDevices();
        return;
      }

      if (wasOn != true || isOn) return;

      _discoveryTimer?.cancel();
      _discoverySub?.cancel();
      _printerService.stopDiscovery();

      state.maybeMap(
        loaded: (s) => emit(
          s.copyWith(
            connectedDevice: null,
            isLoading: false,
            isScanning: false,
          ),
        ),
        orElse: () {},
      );

      emit(PrinterState.bluetoothOffRequiresAction(timestamp: DateTime.now()));
    });
  }

  Future<bool> checkBluetoothOn() async {
    final bluetoothOn = await _printerService.isBluetoothOn;
    if (isClosed) return false;
    if (!bluetoothOn) {
      emit(PrinterState.bluetoothOffRequiresAction(timestamp: DateTime.now()));
      return false;
    }
    return true;
  }

  Future<void> refreshPairedDevices() async {
    try {
      final granted = await checkAndRequestPermissions();
      if (!granted || isClosed) return;

      final bluetoothOn = await checkBluetoothOn();
      if (!bluetoothOn || isClosed) return;

      final devices = await _printerService.getPairedDevices();
      if (isClosed) return;

      final savedMac = await _secureStorage.getPrinterMacAddress();
      if (isClosed) return;

      emit(
        PrinterState.loaded(
          devices: devices,
          discoveredDevices: state.maybeMap(
            loaded: (s) => s.discoveredDevices,
            orElse: () => [],
          ),
          connectedDevice: _printerService.connectedDevice,
          savedMacAddress: savedMac,
          isScanning: state.maybeMap(
            loaded: (s) => s.isScanning,
            orElse: () => false,
          ),
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error("Gagal refresh daftar printer", e, stackTrace);
      if (isClosed) return;
      emit(
        PrinterState.error(
          message: "Gagal memuat ulang daftar perangkat.",
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  Future<bool> checkAndRequestPermissions() async {
    try {
      final status = await _permissionService.requestPermission(
        AppPermissionType.bluetooth,
      );
      if (isClosed) return false;

      if (status == AppPermissionStatus.granted) return true;

      emit(PrinterState.permissionRequiresAction(timestamp: DateTime.now()));
      return false;
    } catch (e, stackTrace) {
      AppLogger.error("Exception saat mengecek permission", e, stackTrace);
      if (isClosed) return false;
      emit(
        PrinterState.error(
          message: "Terjadi kesalahan sistem saat meminta izin.",
          timestamp: DateTime.now(),
        ),
      );
      return false;
    }
  }

  Future<void> scanDevices() async {
    state.maybeMap(
      loaded: (s) => emit(s.copyWith(isLoading: true)),
      orElse: () => emit(const PrinterState.loading()),
    );

    try {
      final granted = await checkAndRequestPermissions();
      if (!granted || isClosed) return;

      final bluetoothOn = await checkBluetoothOn();
      if (!bluetoothOn || isClosed) return;

      final devices = await _printerService.getPairedDevices();
      if (isClosed) return;

      final savedMac = await _secureStorage.getPrinterMacAddress();
      if (isClosed) return;

      emit(
        PrinterState.loaded(
          devices: devices,
          connectedDevice: _printerService.connectedDevice,
          savedMacAddress: savedMac,
          isLoading: false,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error("Gagal scan printer", e, stackTrace);
      if (isClosed) return;
      emit(
        PrinterState.error(
          message: "Gagal memindai perangkat Bluetooth.",
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  Future<void> startScanning() async {
    final granted = await checkAndRequestPermissions();
    if (!granted || isClosed) return;

    final bluetoothOn = await checkBluetoothOn();
    if (!bluetoothOn || isClosed) return;

    final List<BtcDevice> existingDevices = state.maybeMap(
      loaded: (s) => s.devices,
      orElse: () => <BtcDevice>[],
    );

    final devicesToUse = existingDevices.isEmpty
        ? await _printerService.getPairedDevices()
        : existingDevices;
    if (isClosed) return;

    final savedMac = await _secureStorage.getPrinterMacAddress();
    if (isClosed) return;

    emit(
      PrinterState.loaded(
        devices: devicesToUse,
        discoveredDevices: const [],
        connectedDevice: _printerService.connectedDevice,
        savedMacAddress: savedMac, // 🚀 SUPAI KE STATE UI
        isScanning: true,
      ),
    );

    await _discoverySub?.cancel();
    _discoverySub = _printerService.discoveryResults.listen((device) {
      if (isClosed) return;
      state.maybeMap(
        loaded: (s) {
          final alreadyKnown =
              s.discoveredDevices.any((d) => d.address == device.address) ||
              s.devices.any((d) => d.address == device.address);
          if (!alreadyKnown) {
            emit(
              s.copyWith(discoveredDevices: [...s.discoveredDevices, device]),
            );
          }
        },
        orElse: () {},
      );
    });

    await _printerService.startDiscovery();
    if (isClosed) return;

    _discoveryTimer?.cancel();
    _discoveryTimer = Timer(const Duration(seconds: 12), stopScanning);
  }

  Future<void> stopScanning() async {
    _discoveryTimer?.cancel();
    await _discoverySub?.cancel();
    await _printerService.stopDiscovery();

    if (isClosed) return;
    state.maybeMap(
      loaded: (s) => emit(s.copyWith(isScanning: false)),
      orElse: () {},
    );
  }

  Future<bool> printReceipt(HistoryItemModel transaction) async {
    try {
      final granted = await checkAndRequestPermissions();
      if (!granted || isClosed) return false;

      final bluetoothOn = await checkBluetoothOn();
      if (!bluetoothOn || isClosed) return false;

      if (!_printerService.isConnected) {
        final savedMacAddress = await _secureStorage.getPrinterMacAddress();
        if (isClosed) return false;

        if (savedMacAddress != null && savedMacAddress.isNotEmpty) {
          final pairedDevices = await _printerService.getPairedDevices();
          if (isClosed) return false;

          try {
            final targetDevice = pairedDevices.firstWhere(
              (d) => d.address == savedMacAddress,
            );
            await _printerService.connect(targetDevice);
            if (isClosed) return false;
          } catch (_) {
            /* Printer tidak ditemukan di paired devices */
          }
        }
      }

      if (!_printerService.isConnected) {
        if (isClosed) return false;
        emit(
          PrinterState.error(
            message:
                "Belum ada perangkat printer yang terhubung. Pastikan printer dalam kondisi MENYALA.",
            timestamp: DateTime.now(),
          ),
        );
        return false;
      }

      final success = await _printerService.printReceipt(transaction);
      if (isClosed) return false;

      if (!success) {
        emit(
          PrinterState.error(
            message:
                "Gagal mencetak karcis. Pastikan kertas tersedia atau printer dalam kondisi baik.",
            timestamp: DateTime.now(),
          ),
        );
        return false;
      }

      return true;
    } catch (e) {
      AppLogger.error("🖨️ [Print] Terjadi kesalahan fatal: $e");
      if (isClosed) return false;
      emit(
        PrinterState.error(
          message: "Terjadi kesalahan sistem saat mencoba mencetak.",
          timestamp: DateTime.now(),
        ),
      );
      return false;
    }
  }

  Future<void> connectDevice(BtcDevice device) async {
    final bluetoothOn = await checkBluetoothOn();
    if (!bluetoothOn || isClosed) return;

    state.maybeMap(
      loaded: (s) => emit(s.copyWith(isLoading: true)),
      orElse: () {},
    );

    final success = await _printerService.connect(device);
    if (isClosed) return;

    if (success) {
      // Simpan ke Local Storage
      await _secureStorage.savePrinterMacAddress(device.address);
      if (isClosed) return;
      AppLogger.debug(
        "🖨️ MAC Address ${device.address} resmi tersimpan di aplikasi!",
      );

      state.maybeMap(
        loaded: (s) {
          final updatedDevices =
              s.devices.any((d) => d.address == device.address)
              ? s.devices
              : [...s.devices, device];

          emit(
            s.copyWith(
              devices: updatedDevices,
              discoveredDevices: s.discoveredDevices
                  .where((d) => d.address != device.address)
                  .toList(),
              savedMacAddress: device.address,
              isLoading: false,
            ),
          );
        },
        orElse: () {},
      );
    } else {
      emit(
        PrinterState.error(
          message:
              'Gagal terhubung ke ${device.displayName}. Pastikan printer menyala.',
          timestamp: DateTime.now(),
        ),
      );
      refreshPairedDevices();
    }
  }

  Future<void> disconnect() async {
    await _printerService.disconnect();
    await _secureStorage.clearPrinterMacAddress();

    if (isClosed) return;
    state.maybeMap(
      loaded: (s) =>
          emit(s.copyWith(connectedDevice: null, savedMacAddress: null)),
      orElse: () {},
    );
  }

  Future<void> openAppSettings() async {
    await _permissionService.openSettings();
  }

  Future<void> openBluetoothSettings() async {
    await _permissionService.openBluetoothSettings();
  }

  @override
  Future<void> close() {
    _discoveryTimer?.cancel();
    _discoverySub?.cancel();
    _connectionSub?.cancel();
    _bluetoothStateSub?.cancel();
    return super.close();
  }
}
