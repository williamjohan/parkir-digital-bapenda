// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// import '../widgets/list_device_widget.dart';

// class PrinterDeviceScreen extends StatefulWidget {
//   const PrinterDeviceScreen({super.key});

//   @override
//   State<PrinterDeviceScreen> createState() => _PrinterDeviceScreenState();
// }

// class _PrinterDeviceScreenState extends State<PrinterDeviceScreen> {
//   final Map<String, BluetoothDevice> devicesMap = {};
//   StreamSubscription<BluetoothDiscoveryResult>? _discoveryStream;

//   bool isScanning = false;
//   bool _isDisposed = false; // 🔥 FLAG PENTING

//   @override
//   void initState() {
//     super.initState();
//     initBluetooth();
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     _discoveryStream?.cancel();
//     super.dispose();
//   }

//   /// 🔥 SAFE SETSTATE (ANTI CRASH)
//   void safeSetState(VoidCallback fn) {
//     if (mounted && !_isDisposed) {
//       setState(fn);
//     }
//   }

//   /// 🔥 INIT
//   Future<void> initBluetooth() async {
//     await _ensureBluetoothEnabled();
//     await _loadBondedDevices();

//     // auto scan
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!_isDisposed) startScan();
//     });
//   }

//   /// 🔥 Ensure Bluetooth ON
//   Future<void> _ensureBluetoothEnabled() async {
//     bool isOn = await FlutterBluetoothSerial.instance.isEnabled ?? false;

//     if (!isOn) {
//       await FlutterBluetoothSerial.instance.requestEnable();
//     }
//   }

//   /// 🔥 Load paired devices
//   Future<void> _loadBondedDevices() async {
//     final bonded = await FlutterBluetoothSerial.instance.getBondedDevices();

//     for (var d in bonded) {
//       devicesMap[d.address] = d;
//     }

//     safeSetState(() {});
//   }

//   /// 🔥 START SCAN
//   void startScan() {
//     if (isScanning) return;

//     safeSetState(() => isScanning = true);

//     _discoveryStream = FlutterBluetoothSerial.instance.startDiscovery().listen((
//       result,
//     ) {
//       if (_isDisposed) return;

//       final device = result.device;
//       devicesMap[device.address] = device;

//       safeSetState(() {});
//     });

//     _discoveryStream!.onDone(() {
//       if (_isDisposed) return;

//       safeSetState(() => isScanning = false);
//     });
//   }

//   /// 🔥 STOP SCAN
//   void _stopScan() {
//     _discoveryStream?.cancel();
//     _discoveryStream = null;

//     safeSetState(() => isScanning = false);
//   }

//   /// 🔥 CONNECT TEST
//   Future<void> connect(BluetoothDevice device) async {
//     try {
//       await BluetoothConnection.toAddress(device.address);

//       if (_isDisposed) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Connected ke ${device.name}")));
//     } catch (e) {
//       if (_isDisposed) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Gagal connect")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final devices = devicesMap.values.toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Device Bluetooth"),
//         actions: [
//           isScanning
//               ? IconButton(onPressed: _stopScan, icon: const Icon(Icons.stop))
//               : IconButton(
//                   onPressed: startScan,
//                   icon: const Icon(Icons.replay_outlined),
//                 ),
//         ],
//       ),
//       body: ListDeviceWidget(devices: devices, onTap: connect),
//       floatingActionButton: isScanning
//           ? const Padding(
//               padding: EdgeInsets.all(16),
//               child: CircularProgressIndicator(),
//             )
//           : null,
//     );
//   }
// }
