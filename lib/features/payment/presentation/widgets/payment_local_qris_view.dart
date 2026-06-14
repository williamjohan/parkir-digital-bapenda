import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

/// Widget stateless yang menampilkan QRIS statis dari local image file.
/// Tidak ada timer / polling — menunggu SignalR dari backend.
class PaymentLocalQrisView extends StatelessWidget {
  final String imagePath;
  final String kategoriKendaraan;

  // TODO: tambahkan callback ini saat SignalR sudah tersambung
  // final VoidCallback? onCheckStatus;

  const PaymentLocalQrisView({
    super.key,
    required this.imagePath,
    required this.kategoriKendaraan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // ── Header Info Kendaraan ────────────────────────────────────────
          _InfoBadge(label: 'Jenis Kendaraan', value: kategoriKendaraan),
          const SizedBox(height: 24),

          // ── Card QRIS ────────────────────────────────────────────────────
          _QrisCard(imagePath: imagePath),
          const SizedBox(height: 20),

          // ── Instruksi ────────────────────────────────────────────────────
          const _InstruksiPembayaran(),
          const SizedBox(height: 16),

          // ── Disclaimer ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFFF9A825),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Transaksi akan tercatat otomatis setelah pembayaran berhasil diverifikasi oleh sistem.',
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF795548),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TODO: Tombol cek status manual (aktifkan saat SignalR siap)
          // const SizedBox(height: 16),
          // OutlinedButton.icon(
          //   onPressed: onCheckStatus,
          //   icon: const Icon(Icons.refresh_rounded, size: 18),
          //   label: const Text('Cek Status Pembayaran'),
          // ),
        ],
      ),
    );
  }
}

// ─── SUB-WIDGET ───────────────────────────────────────────────────────────────

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.directions_car_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.heading6.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrisCard extends StatelessWidget {
  final String imagePath;

  const _QrisCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header Card ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'SCAN UNTUK MEMBAYAR',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Gunakan aplikasi mobile banking / dompet digital',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // ── QR Image ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imagePath),
                width: 220,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const _QrisImageError(),
              ),
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'QRIS Resmi Pemerintah Daerah',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrisImageError extends StatelessWidget {
  const _QrisImageError();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: AppColors.border,
          ),
          const SizedBox(height: 8),
          Text(
            'Gambar QRIS tidak dapat dimuat',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InstruksiPembayaran extends StatelessWidget {
  const _InstruksiPembayaran();

  static const _steps = [
    'Buka aplikasi mobile banking atau dompet digital Anda',
    'Pilih menu Scan QR / QRIS',
    'Arahkan kamera ke kode QRIS di atas',
    'Periksa detail dan konfirmasi pembayaran',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.list_alt_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Cara Pembayaran',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._steps.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8, top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
