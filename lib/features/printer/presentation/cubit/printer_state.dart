part of 'printer_cubit.dart';

abstract class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object?> get props => [];
}

class PrinterInitial extends PrinterState {}

class PrinterLoading extends PrinterState {}

class PrinterLoaded extends PrinterState {
  final List<BluetoothDevice> devices;
  final BluetoothDevice? connectedDevice;

  const PrinterLoaded({required this.devices, this.connectedDevice});

  @override
  List<Object?> get props => [devices, connectedDevice];
}

class PrinterError extends PrinterState {
  final String message;
  final DateTime
  timestamp; // Memicu re-render meski pesan error sama berturut-turut

  PrinterError(this.message) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [message, timestamp];
}
