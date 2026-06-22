import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

/// Widget yang menampilkan QRIS (Statis/Dinamis/File) + aksi download ke galeri.
class PaymentLocalQrisView extends StatefulWidget {
  // 🚀 PERUBAHAN: Bukan lagi String path, melainkan langsung menerima Widget QR
  final Widget qrWidget;
  final String kategoriKendaraan;

  const PaymentLocalQrisView({
    super.key,
    required this.qrWidget,
    required this.kategoriKendaraan,
  });

  @override
  State<PaymentLocalQrisView> createState() => _PaymentLocalQrisViewState();
}

class _PaymentLocalQrisViewState extends State<PaymentLocalQrisView> {
  // 🚀 Key untuk membungkus _QrisCard agar bisa di-capture jadi gambar
  final GlobalKey _qrisCardKey = GlobalKey();
  bool _isDownloading = false;
  // 🚀 Flag khusus untuk menyembunyikan icon download saat proses capture,
  // supaya icon tidak ikut nampang di hasil gambar yang disimpan.
  bool _isCapturing = false;

  Future<void> _downloadQris() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      // 1. Sembunyikan icon download dulu, lalu tunggu 1 frame
      //    supaya perubahan UI benar-benar ter-render sebelum di-capture.
      setState(() => _isCapturing = true);
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _qrisCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Gagal menemukan tampilan QRIS');
      }

      // 2. Capture jadi image dengan pixelRatio lebih tinggi untuk kualitas bagus
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      // 3. Tampilkan kembali icon download segera setelah capture selesai
      if (mounted) setState(() => _isCapturing = false);

      if (byteData == null) {
        throw Exception('Gagal memproses gambar QRIS');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 4. Cek & minta akses galeri (gal handle permission internally)
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw Exception('Akses galeri ditolak');
        }
      }

      // 5. Simpan ke galeri dengan nama file yang jelas
      final fileName =
          'QRIS_${widget.kategoriKendaraan.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

      await Gal.putImageBytes(pngBytes, name: fileName);

      if (!mounted) return;
      _showSnackBar('QRIS berhasil disimpan ke galeri', isError: false);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal menyimpan QRIS: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isCapturing = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _InfoBadge(label: 'Jenis Kendaraan', value: widget.kategoriKendaraan),
          const SizedBox(height: 24),
          // 🚀 Bungkus _QrisCard dengan RepaintBoundary agar bisa di-screenshot
          RepaintBoundary(
            key: _qrisCardKey,
            child: _QrisCard(
              qrWidget: widget.qrWidget,
              isDownloading: _isDownloading,
              isCapturing: _isCapturing,
              onDownloadTap: _downloadQris,
            ),
          ),
          const SizedBox(height: 20),
          const _InstruksiPembayaran(),
          const SizedBox(height: 16),
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
  final Widget qrWidget; // 🚀 Menerima Widget
  final bool isDownloading;
  final bool isCapturing;
  final VoidCallback onDownloadTap;

  const _QrisCard({
    required this.qrWidget,
    required this.isDownloading,
    required this.isCapturing,
    required this.onDownloadTap,
  });

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // 🚀 Tampilkan Widget QR di sini (ukurannya akan dikunci dari PaymentPage)
              child: qrWidget,
            ),
          ),
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
                const SizedBox(width: 6),
                // 🚀 Tombol download QRIS sebagai gambar ke galeri.
                // Disembunyikan total saat isCapturing=true agar tidak ikut
                // muncul di hasil gambar yang disimpan ke galeri.
                isCapturing
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: isDownloading ? null : onDownloadTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: isDownloading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.download_rounded,
                                  size: 22,
                                  color: AppColors.primary,
                                ),
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
