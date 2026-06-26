import 'package:app_settings/app_settings.dart' as external_settings;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class ListDeviceWidget extends StatelessWidget {
  final List<BluetoothDevice> devices;
  final BluetoothDevice? connectedDevice;
  final bool isLoading;
  final Function(BluetoothDevice) onConnect;

  const ListDeviceWidget({
    super.key,
    required this.devices,
    required this.connectedDevice,
    required this.isLoading,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return devices.isEmpty
        ? SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _buildEmptyState(context),
            ),
          )
        : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final isThisConnected =
                  connectedDevice?.address == device.address;

              return ListTile(
                leading: Icon(
                  Icons.bluetooth,
                  color: isThisConnected ? AppColors.success : Colors.grey,
                ),
                title: Text(
                  device.name ?? 'Unknown Device',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(device.address ?? ''),
                trailing: isThisConnected
                    ? const Icon(Icons.check_circle, color: AppColors.success)
                    : ElevatedButton(
                        onPressed: isLoading ? null : () => onConnect(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Konek'),
                      ),
              );
            },
          );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Printer Tidak Ditemukan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pastikan printer dalam keadaan menyala dan sudah di-pairing di menu Bluetooth HP Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await external_settings.AppSettings.openAppSettings(
                type: external_settings.AppSettingsType.bluetooth,
              );
            },
            icon: const Icon(Icons.settings_bluetooth),
            label: const Text("Buka Pengaturan Bluetooth"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
