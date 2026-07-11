import 'package:flutter/material.dart';

// 🚀 Sesuaikan path import ini dengan struktur folder Anda
import '../../../../core/enums/app_enums.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbPermissionDialog extends StatelessWidget {
  final AppPermissionType type;
  final AppPermissionStatus status;
  final VoidCallback onActionPressed;
  final VoidCallback? onCancelPressed;

  const PbPermissionDialog({
    super.key,
    required this.type,
    required this.status,
    required this.onActionPressed,
    this.onCancelPressed,
  });

  /// 🚀 METHOD PEMANGGIL STATIS (Bersih & Terstandarisasi)
  static Future<void> show(
    BuildContext context, {
    required AppPermissionType type,
    required AppPermissionStatus status,
    required VoidCallback onActionPressed,
    VoidCallback? onCancelPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Memaksa user membuat keputusan (anti-dead end)
      builder: (_) => PbPermissionDialog(
        type: type,
        status: status,
        onActionPressed: onActionPressed,
        onCancelPressed: onCancelPressed,
      ),
    );
  }

  // ===========================================================================
  // 🧠 LOGIKA MAPPING VISUAL DINAMIS (Single Source of UI Truth)
  // ===========================================================================

  IconData get _icon {
    switch (type) {
      case AppPermissionType.camera:
        return Icons.photo_camera_rounded;
      case AppPermissionType.location:
        return Icons.location_on_rounded;
      case AppPermissionType.locationService:
        return Icons.gps_off_rounded; // Ikon khusus GPS mati
      case AppPermissionType.notification:
        return Icons.notifications_active_rounded;
      case AppPermissionType.storage:
        return Icons.folder_rounded;
      case AppPermissionType.photos:
        return Icons.photo_library_rounded;
      case AppPermissionType.microphone:
        return Icons.mic_rounded;
      case AppPermissionType.bluetooth:
        return Icons.bluetooth_rounded;
    }
  }

  String get _title {
    switch (type) {
      case AppPermissionType.locationService:
        return "GPS Belum Aktif";
      case AppPermissionType.camera:
        return "Izin Kamera Dibutuhkan";
      case AppPermissionType.location:
        return "Izin Lokasi Dibutuhkan";
      case AppPermissionType.notification:
        return "Izin Notifikasi Dibutuhkan";
      case AppPermissionType.storage:
        return "Izin Penyimpanan Dibutuhkan";
      case AppPermissionType.photos:
        return "Izin Galeri Dibutuhkan";
      case AppPermissionType.microphone:
        return "Izin Mikrofon Dibutuhkan";
      case AppPermissionType.bluetooth:
        return "Izin Bluetooth Dibutuhkan";
    }
  }

  String get _description {
    switch (type) {
      case AppPermissionType.locationService:
        return "Silakan aktifkan GPS terlebih dahulu agar sistem dapat mencatat lokasi presisi transaksi parkir.";
      case AppPermissionType.bluetooth:
        return "Aktifkan izin Bluetooth dan Perangkat Sekitar agar aplikasi dapat mencari dan terhubung ke printer thermal.";
      case AppPermissionType.camera:
        return "Aktifkan izin kamera agar aplikasi dapat memindai QR Code dan memfoto bukti transaksi.";
      case AppPermissionType.location:
        return "Aktifkan izin lokasi agar sistem dapat mendeteksi titik koordinat penugasan Anda.";
      default:
        return "Aktifkan izin ini agar fitur aplikasi dapat berjalan dengan optimal tanpa gangguan teknis.";
    }
  }

  String get _buttonText {
    // 🚀 Evaluasi teks tombol secara dinamis berdasarkan status dari Cubit!
    return status == AppPermissionStatus.permanentlyDenied
        ? "Buka Pengaturan"
        : "Izinkan Akses";
  }

  // ===========================================================================
  // 🎨 RENDER UI (Mempertahankan Desain Elegan dengan Modern Flutter Syntax)
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .12),
              blurRadius: 40,
              offset: const Offset(0, 18),
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Icon badge with soft glow ---
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: .16),
                      AppColors.primary.withValues(alpha: .06),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .18),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Icon(_icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 22),

              // --- Title ---
              Text(
                _title,
                textAlign: TextAlign.center,
                style: AppTypography.heading4.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),

              // --- Description ---
              Text(
                _description,
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // --- Primary CTA (Solid & Elevated) ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    onActionPressed(); // Eksekusi callback alur dari Cubit
                  },
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: AppColors.primary.withValues(alpha: .35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ).copyWith(
                        elevation: WidgetStateProperty.resolveWith(
                          (states) =>
                              states.contains(WidgetState.pressed) ? 0 : 6,
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withValues(alpha: .08),
                        ),
                      ),
                  child: Text(
                    _buttonText,
                    style: AppTypography.bodyRegular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- Secondary action (Quiet Text Button) ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    if (onCancelPressed != null) {
                      onCancelPressed!(); // Eksekusi callback cancel jika ada
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    overlayColor: AppColors.primary.withValues(alpha: .05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Nanti",
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
