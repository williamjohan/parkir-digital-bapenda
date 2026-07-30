import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:injectable/injectable.dart';

import '../../../features/transaction_history/data/models/history_item_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/receipt_formatter.dart';
import 'i_printer_service.dart';

/// UUID standar Serial Port Profile — dipakai hampir semua printer thermal
/// Bluetooth Classic (sama seperti yang dipakai blue_thermal_printer dulu).
const _kSppUuid = '00001101-0000-1000-8000-00805F9B34FB';

@LazySingleton(as: IPrinterService)
class BluetoothPrinterServiceImpl implements IPrinterService {
  final FlutterClassicBluetooth _bluetooth = FlutterClassicBluetooth();

  BtcConnection? _activeConnection;
  BtcDevice? _connectedDevice;
  StreamSubscription? _inputSub;

  final _connectionChangesController = StreamController<BtcDevice?>.broadcast();

  StreamSubscription<BtcAdapterState>? _adapterStateSub;
  final _bluetoothStateController = StreamController<bool>.broadcast();

  BluetoothPrinterServiceImpl() {
    _adapterStateSub = _bluetooth.adapterState.listen(
      (state) {
        final isOn = state == BtcAdapterState.on;
        _bluetoothStateController.add(isOn);

        // Kalau Bluetooth HP dimatiin user langsung, anggap koneksi putus
        // seketika — jangan nunggu error/onDone dari socket yang bisa telat.
        if (!isOn && _activeConnection != null) {
          _handleDisconnected();
        }
      },
      onError: (e) {
        AppLogger.error('Gagal memantau status adapter Bluetooth: $e');
      },
    );
  }

  // 🚀 BARU
  @override
  Stream<bool> get bluetoothStateChanges => _bluetoothStateController.stream;

  @override
  Stream<BtcDevice?> get connectionChanges =>
      _connectionChangesController.stream;

  @override
  bool get isConnected => _activeConnection != null;

  @override
  BtcDevice? get connectedDevice => _connectedDevice;

  @override
  Future<List<BtcDevice>> getPairedDevices() async {
    try {
      return await _bluetooth.getPairedDevices();
    } catch (e) {
      AppLogger.error('Gagal mengambil perangkat Bluetooth: $e');
      return [];
    }
  }

  @override
  Stream<BtcDevice> get discoveryResults => _bluetooth.discoveryResults;

  @override
  Future<void> startDiscovery() async {
    try {
      final caps = await _bluetooth.getPlatformCapabilities();
      if (!caps.canDiscoverDevices) {
        AppLogger.error('Discovery tidak didukung di platform ini.');
        return;
      }
      await _bluetooth.startDiscovery();
    } catch (e) {
      AppLogger.error('Gagal memulai discovery: $e');
    }
  }

  @override
  Future<void> stopDiscovery() async {
    try {
      await _bluetooth.stopDiscovery();
    } catch (e) {
      AppLogger.error('Gagal menghentikan discovery: $e');
    }
  }

  @override
  Future<bool> get isBluetoothOn async {
    try {
      return await _bluetooth.isEnabled();
    } catch (e) {
      AppLogger.error('Gagal mengecek status Bluetooth HP: $e');
      return false;
    }
  }

  @override
  Future<bool> connect(BtcDevice device) async {
    // Pastikan koneksi lama BENERAN putus dulu (di-await penuh) sebelum
    // buka koneksi baru — ini yang kemarin jadi salah satu celah bug.
    if (_activeConnection != null) {
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    try {
      final connection = await _bluetooth.connect(
        address: device.address,
        uuid: _kSppUuid,
      );

      _activeConnection = connection;
      _connectedDevice = device;

      // Kalau printer disconnect sendiri (mati/keluar jangkauan), kita tau
      // secara real-time lewat stream ini, bukan nunggu dicek manual.
      _inputSub = connection.input.listen(
        (_) {},
        onError: (_) => _handleDisconnected(),
        onDone: _handleDisconnected,
      );

      _connectionChangesController.add(_connectedDevice);
      AppLogger.debug(
        '>>> [PRINTER] Berhasil terhubung ke: ${device.displayName}',
      );
      return true;
    } catch (e) {
      AppLogger.error(
        '>>> [PRINTER ERROR] Gagal konek ke ${device.displayName}: $e',
      );
      _activeConnection = null;
      _connectedDevice = null;
      return false;
    }
  }

  void _handleDisconnected() {
    _activeConnection = null;
    _connectedDevice = null;
    _connectionChangesController.add(null);
    AppLogger.debug('>>> [PRINTER] Koneksi terputus (terdeteksi otomatis).');
  }

  @override
  Future<void> disconnect() async {
    try {
      await _inputSub?.cancel();
      await _activeConnection?.finish();
    } catch (e) {
      AppLogger.error('>>> [PRINTER ERROR] Gagal putus koneksi: $e');
    } finally {
      _activeConnection = null;
      _connectedDevice = null;
      _connectionChangesController.add(null);
    }
  }

  @override
  Future<bool> printReceipt(HistoryItemModel transaction) async {
    final connection = _activeConnection;
    if (connection == null) {
      AppLogger.error('>>> [PRINTER ERROR] Printer belum terhubung!');
      return false;
    }
    try {
      final List<int> bytes = await ReceiptFormatter.generateBytes(transaction);
      await connection.output.add(Uint8List.fromList(bytes));
      AppLogger.debug('>>> [PRINTER SUCCESS] Karcis berhasil dicetak!');
      return true;
    } catch (e) {
      AppLogger.error('>>> [PRINTER ERROR] Gagal mencetak: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _inputSub?.cancel();
    _adapterStateSub?.cancel();
    _connectionChangesController.close();
    _bluetoothStateController.close();
  }
}
