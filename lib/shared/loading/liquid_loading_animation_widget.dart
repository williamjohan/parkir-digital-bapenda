import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/constants/app_asset_constant.dart';
import '../../core/design_system/tokens/app_colors.dart';

class LiquidLoadingWidget extends StatefulWidget {
  final double size;
  final double durationSeconds;

  const LiquidLoadingWidget({
    super.key,
    this.size = 120, // Ukuran default
    this.durationSeconds = 3.0, // Lama waktu mengisi sampai penuh
  });

  @override
  State<LiquidLoadingWidget> createState() => _LiquidLoadingWidgetState();
}

class _LiquidLoadingWidgetState extends State<LiquidLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk Gerakan Gelombang (Kiri-Kanan)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Kecepatan ombak
    )..repeat(); // Ulang terus selamanya

    // 2. Controller untuk Tinggi Air (Bawah ke Atas)
    _fillController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.durationSeconds * 1000).toInt()),
    )..repeat(); // Ulang pengisian dari kosong ke penuh
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // ===============================================
          // LAYER 1: BACKGROUND (LOGO KOSONG / ABU-ABU)
          // ===============================================
          // Ini adalah "Wadah" yang diam
          Image.asset(
            AppAssetImages.logosurabayasiloute,
            width: widget.size,
            height: widget.size,
            // color: Colors.grey.withValues(alpha: 1), // Warna wadah pudar
            fit: BoxFit.contain,
          ),

          // ===============================================
          // LAYER 2: FOREGROUND (AIR ORANYE)
          // ===============================================
          // Ini adalah logo oranye yang kita potong (Clip) bentuk ombak
          AnimatedBuilder(
            animation: Listenable.merge([_waveController, _fillController]),
            builder: (context, child) {
              return ClipPath(
                // Jurus Rahasia: Custom Clipper untuk bikin bentuk ombak
                clipper: WaveClipper(
                  wavePhase: _waveController.value, // Posisi gerak ombak
                  fillLevel:
                      _fillController.value, // Ketinggian air (0.0 - 1.0)
                ),
                child: Image.asset(
                  AppAssetImages.logosurabayasiloute,
                  width: widget.size,
                  height: widget.size,
                  color: AppColors.background, // Warna Air (Orange)
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// RUMUS MATEMATIKA OMBAK (JANGAN PUSING, INI TEMPLATE AJA)
// ==========================================================
class WaveClipper extends CustomClipper<Path> {
  final double wavePhase; // 0.0 - 1.0 (Gerakan horizontal)
  final double fillLevel; // 0.0 - 1.0 (Ketinggian air)

  WaveClipper({required this.wavePhase, required this.fillLevel});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Konfigurasi Ombak
    // Semakin tinggi fillLevel, ombak semakin tenang (biar pas penuh gak jelek)
    final double waveHeight = (1 - fillLevel) * 10.0; // Tinggi gejolak ombak
    const double waveFrequency = 2.0; // Berapa banyak gundukan

    // Titik Y dasar air (Bergerak dari bawah ke atas)
    // fillLevel 0 = size.height (Bawah)
    // fillLevel 1 = 0 (Atas)
    final double baseHeight = size.height * (1 - fillLevel);

    path.moveTo(0, baseHeight);

    // Loop menggambar garis sinus (Gelombang) dari kiri ke kanan
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight +
            math.sin(
                  (i / size.width * 2 * math.pi * waveFrequency) +
                      (wavePhase * 2 * math.pi),
                ) *
                waveHeight,
      );
    }

    // Tutup path ke bawah agar jadi area tertutup
    path.lineTo(size.width, size.height); // Pojok Kanan Bawah
    path.lineTo(0, size.height); // Pojok Kiri Bawah
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) {
    // Render ulang setiap ada perubahan animasi
    return wavePhase != oldClipper.wavePhase ||
        fillLevel != oldClipper.fillLevel;
  }
}
