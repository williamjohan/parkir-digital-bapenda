import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../domain/entities/jadwal_entity.dart';

class JadwalCardItem extends StatelessWidget {
  final JadwalEntity jadwal;

  const JadwalCardItem({super.key, required this.jadwal});

  @override
  Widget build(BuildContext context) {
    // 🚀 LOGIKA WARNA & TANGGAL (Sesuai Entity Baru)
    final Color indicatorColor = jadwal.isLibur
        ? AppColors.error
        : AppColors.primary;

    // Safety check agar tidak crash jika hariNama kosong/kurang dari 3 huruf
    final String hariPendek = jadwal.hariNama.length >= 3
        ? jadwal.hariNama.substring(0, 3).toUpperCase()
        : jadwal.hariNama.toUpperCase();

    // Format angka hari (contoh: '7' menjadi '07')
    final String tanggal = jadwal.hari.toString().padLeft(2, '0');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            //  SEGMEN KIRI: Indikator Tanggal & Warna
            // ==========================================
            Container(
              width: 70,
              decoration: BoxDecoration(
                color: indicatorColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hariPendek, // Menggunakan properti dari Entity
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: indicatorColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tanggal, // Menggunakan properti dari Entity
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: indicatorColor,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 🚀 SEGMEN KANAN: Detail Jadwal & Kehadiran
            // ==========================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: jadwal.isLibur
                    ? _buildHolidayState()
                    : _buildWorkingState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI State jika Hari Kerja
  Widget _buildWorkingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Jadwal Shift
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeBlock(
              label: 'Jam Masuk',
              time: jadwal.jamMasuk.isNotEmpty ? jadwal.jamMasuk : '--:--',
              icon: Icons.login,
              iconColor: AppColors.info,
            ),
            _buildTimeBlock(
              label: 'Jam Pulang',
              time: jadwal.jamPulang.isNotEmpty ? jadwal.jamPulang : '--:--',
              icon: Icons.logout,
              iconColor: AppColors.warning,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: AppColors.border, height: 1),
        ),
        // Baris Aktual Absensi
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeBlock(
              label: 'Check In',
              time: jadwal.jamCheckIn.isNotEmpty ? jadwal.jamCheckIn : '--:--',
              isActual: true,
            ),
            _buildTimeBlock(
              label: 'Check Out',
              time: jadwal.jamCheckOut.isNotEmpty
                  ? jadwal.jamCheckOut
                  : '--:--',
              isActual: true,
            ),
          ],
        ),
      ],
    );
  }

  // UI State jika Hari Libur
  Widget _buildHolidayState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, color: AppColors.error, size: 28),
          SizedBox(height: 8),
          Text(
            'HARI LIBUR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.error,
              letterSpacing: 1.2,
            ),
          ),
          // Note: keteranganLibur dihapus karena tidak ada di JadwalEntity Anda.
        ],
      ),
    );
  }

  // Micro-component untuk blok waktu
  Widget _buildTimeBlock({
    required String label,
    required String time,
    IconData? icon,
    Color? iconColor,
    bool isActual = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: isActual ? 14 : 13,
            fontWeight: isActual ? FontWeight.bold : FontWeight.w600,
            color: (isActual && time != '--:--')
                ? AppColors.textPrimary
                : AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
