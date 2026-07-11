import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'device_empty_view.dart';
import 'device_item_card.dart';
import 'printer_header.dart';

class ListDeviceWidget extends StatelessWidget {
  final List<BtcDevice> devices;
  final List<BtcDevice> discoveredDevices;
  final BtcDevice? connectedDevice;
  final String? savedMacAddress; // 🚀 TERIMA DARI SETTINGS PAGE
  final bool isLoading;
  final bool isScanning;
  final Function(BtcDevice) onConnect;

  const ListDeviceWidget({
    super.key,
    required this.devices,
    this.discoveredDevices = const [],
    required this.connectedDevice,
    this.savedMacAddress,
    required this.isLoading,
    this.isScanning = false,
    required this.onConnect,
  });

  static const int _collapseThreshold = 4;

  @override
  Widget build(BuildContext context) {
    // 🚀 1. FILTER SEGMEN 1: HANYA printer resmi yang tersimpan di database aplikasi
    final appTrustedDevices = devices.where((d) {
      return d.address == savedMacAddress;
    }).toList();

    // 🚀 2. FILTER SEGMEN 2: Bluetooth OS lain (TWS, dll) + Hasil scan realtime baru
    final otherAvailableDevices = [
      ...devices.where((d) => d.address != savedMacAddress),
      ...discoveredDevices,
    ];

    // 3. Tangani Empty State Total
    if (appTrustedDevices.isEmpty &&
        otherAvailableDevices.isEmpty &&
        !isScanning) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: const DeviceEmptyState(),
        ),
      );
    }

    final hasManyPaired = appTrustedDevices.length > _collapseThreshold;
    final isConnectedInPaired =
        connectedDevice != null &&
        appTrustedDevices.any((d) => d.address == connectedDevice!.address);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // =====================================================================
        // SEGMEN 1: PERANGKAT TERSIMPAN (APP TRUSTED ONLY)
        // =====================================================================
        if (appTrustedDevices.isNotEmpty)
          if (hasManyPaired)
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: isConnectedInPaired,
                tilePadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                childrenPadding: EdgeInsets.zero,
                title: GovernmentSectionHeader(
                  title: 'Printer Tersimpan',
                  count: appTrustedDevices.length, // 🚀 GUNAKAN APP TRUSTED
                  icon: Icons.bookmark_added_rounded,
                  color: const Color(0xFF1E3A8A), // Slate Blue
                ),
                children: appTrustedDevices
                    .map(
                      (device) => DeviceItemCard(
                        device: device,
                        isConnected: connectedDevice?.address == device.address,
                        isLoading: isLoading,
                        onConnect: () => onConnect(device),
                      ),
                    )
                    .toList(),
              ),
            )
          else ...[
            GovernmentSectionHeader(
              title: 'Printer Tersimpan',
              count: appTrustedDevices.length, // 🚀 GUNAKAN APP TRUSTED
              icon: Icons.bookmark_added_rounded,
              color: const Color(0xFF1E3A8A),
            ),
            ...appTrustedDevices.map(
              (device) => DeviceItemCard(
                device: device,
                isConnected: connectedDevice?.address == device.address,
                isLoading: isLoading,
                onConnect: () => onConnect(device),
              ),
            ),
          ],

        const SizedBox(height: 16),

        // =====================================================================
        // GOVERNMENT DIVIDER
        // =====================================================================
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Colors.blueGrey.shade800,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pastikan printer thermal menyala (ON) saat memindai perangkat baru.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        // =====================================================================
        // SEGMEN 2: PERANGKAT LAIN DI SEKITAR (OTHER BLUETOOTH & DISCOVERED)
        // =====================================================================
        if (isScanning || otherAvailableDevices.isNotEmpty) ...[
          GovernmentSectionHeader(
            title: 'Perangkat Lain & Discovery',
            count: otherAvailableDevices.length,
            icon: isScanning
                ? Icons.bluetooth_searching_rounded
                : Icons.bluetooth_rounded,
            color: AppColors.primary,
          ),

          if (otherAvailableDevices.isEmpty && isScanning)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Mencari perangkat di sekitar...',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...otherAvailableDevices.map(
              // 🚀 GUNAKAN OTHER AVAILABLE
              (device) => DeviceItemCard(
                device: device,
                isConnected: connectedDevice?.address == device.address,
                isLoading: isLoading,
                onConnect: () => onConnect(device),
              ),
            ),
        ],
      ],
    );
  }
}
