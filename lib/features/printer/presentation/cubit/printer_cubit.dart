// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'printer_state.dart';

// class PrinterCubit extends Cubit<PrinterState> {
//   PrinterCubit() : super(const PrinterState());

//   StreamSubscription<BluetoothDiscoveryResult>? _discoveryStream;

//   /// INIT
//   Future<void> init() async {
//     await _ensureBluetoothEnabled();
//     await loadBondedDevices();

//     Future.delayed(const Duration(seconds: 1), () {
//       startScan();
//     });
//   }

//   /// Bluetooth ON
//   Future<void> _ensureBluetoothEnabled() async {
//     bool isOn = await FlutterBluetoothSerial.instance.isEnabled ?? false;

//     if (!isOn) {
//       await FlutterBluetoothSerial.instance.requestEnable();
//     }
//   }

//   /// Load paired
//   Future<void> loadBondedDevices() async {
//     final bonded = await FlutterBluetoothSerial.instance.getBondedDevices();

//     final newMap = Map<String, BluetoothDevice>.from(state.devices);

//     for (var d in bonded) {
//       newMap[d.address] = d;
//     }

//     emit(state.copyWith(devices: newMap));
//   }

//   /// START SCAN
//   void startScan() {
//     if (state.isScanning) return;

//     emit(state.copyWith(isScanning: true));

//     _discoveryStream = FlutterBluetoothSerial.instance.startDiscovery().listen((
//       result,
//     ) {
//       final device = result.device;

//       final newMap = Map<String, BluetoothDevice>.from(state.devices);
//       newMap[device.address] = device;

//       emit(state.copyWith(devices: newMap));
//     });

//     _discoveryStream!.onDone(() {
//       emit(state.copyWith(isScanning: false));
//     });
//   }

//   /// STOP SCAN
//   void stopScan() {
//     _discoveryStream?.cancel();
//     _discoveryStream = null;

//     emit(state.copyWith(isScanning: false));
//   }

//   /// CONNECT
//   Future<bool> connect(BluetoothDevice device) async {
//     try {
//       await BluetoothConnection.toAddress(device.address);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<void> close() {
//     _discoveryStream?.cancel();
//     return super.close();
//   }
// }
