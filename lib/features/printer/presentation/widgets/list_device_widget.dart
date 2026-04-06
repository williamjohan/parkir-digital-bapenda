// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class ListDeviceWidget extends StatelessWidget {
//   final List<BluetoothDevice> devices;
//   final Function(BluetoothDevice) onTap;

//   const ListDeviceWidget({
//     super.key,
//     required this.devices,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (devices.isEmpty) {
//       return const Center(child: Text("Tidak ada device"));
//     }

//     return ListView.builder(
//       itemCount: devices.length,
//       itemBuilder: (context, index) {
//         final d = devices[index];

//         return ListTile(
//           leading: const Icon(Icons.bluetooth),
//           title: Text(d.name ?? "Unknown Device"),
//           subtitle: Text(d.address),
//           trailing: d.isBonded
//               ? const Text("Paired", style: TextStyle(color: Colors.green))
//               : const Text("Baru", style: TextStyle(color: Colors.orange)),
//           onTap: () => onTap(d),
//         );
//       },
//     );
//   }
// }
