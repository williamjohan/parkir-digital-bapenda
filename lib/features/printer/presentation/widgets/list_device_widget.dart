import 'package:app_settings/app_settings.dart' as external_settings;
import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class ListDeviceWidget extends StatelessWidget {
  final List<BtcDevice> devices;
  final List<BtcDevice> discoveredDevices;
  final BtcDevice? connectedDevice;
  final bool isLoading;
  final bool isScanning;
  final Function(BtcDevice) onConnect;

  const ListDeviceWidget({
    super.key,
    required this.devices,
    this.discoveredDevices = const [],
    required this.connectedDevice,
    required this.isLoading,
    this.isScanning = false,
    required this.onConnect,
  });

  // 🚀 BARU: di atas jumlah ini, section "Perangkat Tersimpan" auto-collapse
  static const int _collapseThreshold = 4;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty && discoveredDevices.isEmpty && !isScanning) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: _buildEmptyState(context),
        ),
      );
    }

    final hasManyPaired = devices.length > _collapseThreshold;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // 🚀 GANTI: hasil scan ditaruh PALING ATAS kalau lagi aktif nyari
        // atau ada hasil — ini fokus utama user saat ini.
        if (isScanning || discoveredDevices.isNotEmpty) ...[
          _buildSectionHeader(
            'Perangkat Baru Ditemukan',
            count: discoveredDevices.isNotEmpty
                ? discoveredDevices.length
                : null,
            icon: Icons.bluetooth_searching_rounded,
          ),
          if (discoveredDevices.isEmpty && isScanning)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mencari perangkat di sekitar...',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...discoveredDevices.map(_buildTile),
          const SizedBox(height: 6),
        ],

        // 🚀 GANTI: kalau paired-nya banyak, dibungkus ExpansionTile
        // (collapsed) biar hasil scan di atas nggak ketimbun.
        if (devices.isNotEmpty)
          if (hasManyPaired)
            _buildCollapsiblePairedSection(context)
          else ...[
            _buildSectionHeader(
              'Perangkat Tersimpan',
              count: devices.length,
              icon: Icons.bluetooth_connected_rounded,
            ),
            ...devices.map(_buildTile),
          ],

        const SizedBox(height: 8),
      ],
    );
  }

  // 🚀 BARU
  Widget _buildCollapsiblePairedSection(BuildContext context) {
    final isConnectedInPaired =
        connectedDevice != null &&
        devices.any((d) => d.address == connectedDevice!.address);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // Kalau device yang lagi konek ada di list ini, buka default
        // biar user langsung liat status-nya tanpa perlu expand manual.
        initiallyExpanded: isConnectedInPaired,
        tilePadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Icon(
              Icons.bluetooth_connected_rounded,
              size: 14,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              'Perangkat Tersimpan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
                fontSize: 12,
                letterSpacing: .3,
              ),
            ),
            const SizedBox(width: 6),
            _buildCountBadge(devices.length),
          ],
        ),
        children: devices.map(_buildTile).toList(),
      ),
    );
  }

  // 🚀 GANTI: header sekarang bisa nampilin count badge + icon kecil
  Widget _buildSectionHeader(String text, {int? count, IconData? icon}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
                fontSize: 12,
                letterSpacing: .3,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              _buildCountBadge(count),
            ],
          ],
        ),
      );

  // 🚀 BARU
  Widget _buildCountBadge(int count) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      '$count',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
      ),
    ),
  );

  // 🚀 GANTI: dari ListTile polos jadi card custom
  Widget _buildTile(BtcDevice device) {
    final isThisConnected = connectedDevice?.address == device.address;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isThisConnected
            ? AppColors.success.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isThisConnected
              ? AppColors.success.withValues(alpha: 0.35)
              : Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: isThisConnected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isThisConnected
                    ? [
                        AppColors.success,
                        AppColors.success.withValues(alpha: 0.75),
                      ]
                    : [
                        AppColors.primary.withValues(alpha: 0.14),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
              ),
            ),
            child: Icon(
              isThisConnected ? Icons.print_rounded : Icons.bluetooth_rounded,
              color: isThisConnected ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  device.address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          isThisConnected
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Aktif',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => onConnect(device),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Konek',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // 🚀 GANTI: icon badge gradient, senada PermissionRequiredDialog
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: .14),
                  AppColors.primary.withValues(alpha: .05),
                ],
              ),
            ),
            child: const Icon(
              Icons.bluetooth_searching_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Printer Tidak Ditemukan',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan "Cari Perangkat Baru" untuk mencari printer di sekitar, atau pastikan printer sudah di-pairing di menu Bluetooth HP Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              height: 1.5,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () async {
                await external_settings.AppSettings.openAppSettings(
                  type: external_settings.AppSettingsType.bluetooth,
                );
              },
              icon: const Icon(Icons.settings_bluetooth_rounded, size: 18),
              label: const Text("Buka Pengaturan Bluetooth"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
