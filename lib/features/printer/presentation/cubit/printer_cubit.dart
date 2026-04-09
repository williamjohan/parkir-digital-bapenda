import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/printer/i_printer_service.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

part 'printer_state.dart';

@injectable
class PrinterCubit extends Cubit<PrinterState> {
  final IPrinterService _printerService;

  PrinterCubit(this._printerService) : super(PrinterInitial());

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

    emit(PrinterLoading());

    final success = await _printerService.connect(device);

    // 🚀 GEMBOK PENGAMAN SEBELUM EMIT
    if (isClosed) return;

    if (success) {
      emit(
        PrinterLoaded(devices: currentState.devices, connectedDevice: device),
      );
    } else {
      emit(
        PrinterError(
          'Gagal terhubung ke ${device.name}. Pastikan printer menyala.',
        ),
      );
      emit(PrinterLoaded(devices: currentState.devices)); // Kembalikan list
    }
  }

  // 3. Putuskan koneksi
  Future<void> disconnect() async {
    final currentState = state;
    if (currentState is! PrinterLoaded) return;

    await _printerService.disconnect();

    // 🚀 GEMBOK PENGAMAN
    if (isClosed) return;

    emit(PrinterLoaded(devices: currentState.devices, connectedDevice: null));
  }

  // 4. 🚀 Print Karcis (Pipa parameter sudah SEMPURNA)
  Future<bool> printReceipt(
    HistoryItemModel transaction,
    String deviceId,
    Map<String, dynamic> profile,
  ) async {
    // Fungsi ini aman karena tidak memanggil emit() di dalamnya.
    // Dia hanya melempar tugas ke Service dan mengembalikan true/false.
    final success = await _printerService.printReceipt(
      transaction,
      deviceId,
      profile,
    );

    return success;
  }
}
