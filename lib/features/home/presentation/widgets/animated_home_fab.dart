import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/pb_permission_gate.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routes/app_routes.dart';

class AnimatedHomeFab extends StatefulWidget {
  final dynamic currentRole;
  final bool isFree;
  final bool isDemoMode;
  final VoidCallback onReload;
  final bool? isEnableBuatLaporan;

  const AnimatedHomeFab({
    super.key,
    required this.currentRole,
    required this.isFree,
    required this.isDemoMode,
    required this.onReload,
    this.isEnableBuatLaporan,
  });

  @override
  State<AnimatedHomeFab> createState() => _AnimatedHomeFabState();
}

class _AnimatedHomeFabState extends State<AnimatedHomeFab>
    with TickerProviderStateMixin {
  // Teks kembali ke versi awal karena hanya akan dilihat oleh Pengawas
  final List<String> _hintTexts = ['Buat Laporan', 'Check Qris nya'];
  int _currentIndex = 0;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

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

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.05), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.05), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    // Tetap jalankan animasi di background (tidak masalah karena widgetnya di-hide)
    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    await Future.delayed(const Duration(seconds: 1));

    while (mounted) {
      await _slideController.forward();
      if (!mounted) break;

      _shakeController.reset();
      await _shakeController.forward();
      _shakeController.reset();
      await _shakeController.forward();

      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;

      await _slideController.reverse();
      if (!mounted) break;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _hintTexts.length;
      });

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
    // Cek role user
    final bool isPengawas =
        widget.currentRole == RoleLoginDigitalParkir.pengawas;

    // Definisikan tombol berdasarkan role
    final Widget mainButton = isPengawas
        ? SpeedDial(
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
                onTap: () async {
                  if (widget.isEnableBuatLaporan != true) {
                    PbStatusSnackbar.show(
                      context,
                      message:
                          'Silahkan check-in terlebih dahulu sebelum membuat laporan',
                      isError: true,
                    );
                    return;
                  }

                  final result = await context.pushNamed<bool>(
                    AppRoutes.addLaporanPelanggaran,
                  );

                  if (result == true) {
                    widget.onReload();
                  }
                },
              ),
              if (widget.currentRole != RoleLoginDigitalParkir.pengawas)
                SpeedDialChild(
                  child: const Icon(Icons.receipt_long_outlined),
                  label: 'Buat Transaksi',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  labelBackgroundColor: Colors.white,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  onTap: () async {
                    final result = await context.pushNamed(
                      AppRoutes.transaction,
                      extra: {
                        'isFree': widget.isFree,
                        'isDemoMode': widget.isDemoMode,
                      },
                    );
                    if (result == true) {
                      widget.onReload();
                    }
                  },
                ),
            ],
          )
        : FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            elevation: 4,
            onPressed: () async {
              final result = await context.pushNamed(
                AppRoutes.transaction,
                extra: {
                  'isFree': widget.isFree,
                  'isDemoMode': widget.isDemoMode,
                },
              );
              if (result == true) {
                widget.onReload();
              }
            },
            child: const Icon(Icons.add),
          );

    return PbPermissionGate(
      allowedRoles: const [
        RoleLoginDigitalParkir.jukir,
        RoleLoginDigitalParkir.bapenda,
        RoleLoginDigitalParkir.pengawas,
      ],
      currentRole: widget.currentRole,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 💡 HANYA TAMPILKAN TEKS ANIMASI JIKA DIA PENGAWAS
          if (isPengawas)
            ClipRect(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _hintTexts[_currentIndex],
                          style: AppTypography.heading1.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        RotationTransition(
                          turns: _shakeAnimation,
                          child: Text(
                            ' ?',
                            style: AppTypography.heading1.copyWith(
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Tombol Utama (SpeedDial atau FAB biasa)
          mainButton,
        ],
      ),
    );
  }
}
