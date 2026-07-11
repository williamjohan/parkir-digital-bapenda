import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_state.freezed.dart';

@freezed
class PrinterState with _$PrinterState {
  const factory PrinterState.initial() = _Initial;

  const factory PrinterState.loading() = _Loading;

  const factory PrinterState.loaded({
    required List<BtcDevice> devices,
    @Default([]) List<BtcDevice> discoveredDevices,
    BtcDevice? connectedDevice,
    String? savedMacAddress,
    @Default(false) bool isLoading,
    @Default(false) bool isScanning,
  }) = _Loaded;

  const factory PrinterState.error({
    required String message,
    DateTime? timestamp,
  }) = _Error;

  const factory PrinterState.permissionRequiresAction({DateTime? timestamp}) =
      _PermissionRequiresAction;

  const factory PrinterState.bluetoothOffRequiresAction({DateTime? timestamp}) =
      _BluetoothOffRequiresAction;
}
