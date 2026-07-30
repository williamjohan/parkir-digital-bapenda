import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../../../features/transaction_history/data/models/history_item_model.dart';

abstract class IPrinterService {
  /// Perangkat yang sudah paired (bawaan OS)
  Future<List<BtcDevice>> getPairedDevices();

  /// Mulai/berhenti cari perangkat BARU di sekitar (belum tentu paired)
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Stream<BtcDevice> get discoveryResults;

  Future<bool> connect(BtcDevice device);
  Future<void> disconnect();

  /// Diambil dari koneksi aktif yang kita pegang sendiri — bukan tebakan lagi.
  bool get isConnected;
  BtcDevice? get connectedDevice;

  /// Notifikasi real-time tiap kali status koneksi berubah,
  /// termasuk kalau printer disconnect sendiri (mati/keluar jangkauan).
  Stream<BtcDevice?> get connectionChanges;

  Future<bool> get isBluetoothOn;
  Stream<bool> get bluetoothStateChanges;

  Future<bool> printReceipt(HistoryItemModel transaction);

  void dispose();
}
