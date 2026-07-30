import 'package:app_settings/app_settings.dart' as external_settings;
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class DeviceEmptyState extends StatelessWidget {
  const DeviceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
