part of 'printer_cubit.dart';

abstract class PrinterState extends Equatable {
  const PrinterState();
  @override
  List<Object?> get props => [];
}

class PrinterInitial extends PrinterState {}

class PrinterLoading extends PrinterState {}

class PrinterLoaded extends PrinterState {
  final List<BtcDevice> devices;
  final List<BtcDevice>
  discoveredDevices; // 🚀 hasil scan realtime, belum tentu paired
  final BtcDevice? connectedDevice;
  final bool isLoading;
  final bool isScanning; // 🚀 status discovery lagi jalan atau nggak

  const PrinterLoaded({
    required this.devices,
    this.discoveredDevices = const [],
    this.connectedDevice,
    this.isLoading = false,
    this.isScanning = false,
  });

  @override
  List<Object?> get props => [
    devices,
    discoveredDevices,
    connectedDevice,
    isLoading,
    isScanning,
  ];
}

class PrinterError extends PrinterState {
  final String message;
  final DateTime timestamp;
  PrinterError(this.message) : timestamp = DateTime.now();
  @override
  List<Object?> get props => [message, timestamp];
}

class PrinterPermissionRequiresAction extends PrinterState {
  final DateTime timestamp;
  PrinterPermissionRequiresAction() : timestamp = DateTime.now();
  @override
  List<Object?> get props => [timestamp];
}

// 🚀 STATE BARU: minta UI munculin modal "Bluetooth belum aktif"
class PrinterBluetoothOffRequiresAction extends PrinterState {
  final DateTime timestamp;
  PrinterBluetoothOffRequiresAction() : timestamp = DateTime.now();
  @override
  List<Object?> get props => [timestamp];
}
