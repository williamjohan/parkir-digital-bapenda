import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/components/pb_permission_gate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routes/app_routes.dart';
// import sesuaikan dengan path project-mu
// import 'package:parkir_digital_bapenda/core/theme/app_colors.dart';
// import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
// import 'package:go_router/go_router.dart';

class AnimatedHomeFab extends StatefulWidget {
  final dynamic currentRole;

  const AnimatedHomeFab({super.key, required this.currentRole});

  @override
  State<AnimatedHomeFab> createState() => _AnimatedHomeFabState();
}

class _AnimatedHomeFabState extends State<AnimatedHomeFab>
    with TickerProviderStateMixin {
  // Teks utama, tanda "?" dipisah agar bisa digetarkan sendiri
  final List<String> _hintTexts = ['Buat Laporan', 'Check Qris nya'];

  int _currentIndex = 0;

  // Controller untuk animasi meluncur & muncul
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Controller khusus untuk animasi getar/goyang (?)
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animasi Slide & Fade (Durasi dibuat lebih smooth)
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Animasi muncul dari sudut kanan bawah (Offset 0.5, 0.5) menuju titik aslinya (Offset.zero)
    // Menggunakan curve easeOutBack agar ada sedikit efek membal (smooth) di akhir
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.5, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    // 2. Setup Animasi Goyang untuk tanda "?"
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Membuat urutan rotasi (kiri - kanan - tengah)
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.05), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.05), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    // Mulai siklus animasinya
    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    // Jeda awal saat halaman dimuat
    await Future.delayed(const Duration(seconds: 1));

    while (mounted) {
      // 1. Teks Meluncur Keluar
      await _slideController.forward();
      if (!mounted) break;

      // 2. Tanda "?" Bergoyang 2 kali untuk menarik perhatian user
      _shakeController.reset();
      await _shakeController.forward();
      _shakeController.reset();
      await _shakeController.forward();

      // 3. Tahan posisi selama 3 detik agar bisa dibaca
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;

      // 4. Teks Meluncur Masuk (Sembunyi ke arah kanan bawah)
      await _slideController.reverse();
      if (!mounted) break;

      // 5. Ganti teks selagi sembunyi
      setState(() {
        _currentIndex = (_currentIndex + 1) % _hintTexts.length;
      });

      // Jeda nafas sebelum teks baru muncul
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- WIDGET TEKS DENGAN ANIMASI ---
        ClipRect(
          // ClipRect memastikan teks yang belum keluar penuh tidak bocor posisinya
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Teks Utama (Government Style: Tegas, tidak miring, warna solid)
                    Text(
                      _hintTexts[_currentIndex],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            0.3, // Menambah spasi antar huruf sedikit agar rapi
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 2),
                    // Tanda Tanya dengan Animasi Getar
                    RotationTransition(
                      turns: _shakeAnimation,
                      child: const Text(
                        '?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // --- TOMBOL SPEED DIAL ASLI ---
        PbPermissionGate(
          allowedRoles: const [RoleLoginDigitalParkir.pengawas],
          currentRole: widget.currentRole,
          child: SpeedDial(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 14,
            spaceBetweenChildren: 14,
            elevation: 4,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.report_outlined),
                label: 'Buat Laporan',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 3,
                onTap: () {
                  context.pushNamed(AppRoutes.addLaporanPelanggaran);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.receipt_long_outlined),
                label: 'Buat Transaksi',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                labelBackgroundColor: Colors.white,
                backgroundColor:
                    AppColors.primary, // Ganti ke AppColors.primary
                foregroundColor: Colors.white,
                elevation: 3,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
