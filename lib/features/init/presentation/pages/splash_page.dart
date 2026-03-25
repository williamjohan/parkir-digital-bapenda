// lib/features/init/presentation/pages/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/init_cubit.dart';
import '../cubit/init_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger pengecekan otomatis saat halaman pertama kali dirender
    context.read<InitCubit>().checkDeviceReadiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<InitCubit, InitState>(
        listener: (context, state) {
          // Listener khusus untuk aksi satu kali (navigasi, snackbar)
          if (state is InitSuccess) {
            // Logika Smart Gatekeeper
            if (state.isLoggedIn) {
              context.go(AppRoutes.home); // Punya token? Langsung Home!
            } else {
              context.go(AppRoutes.login); // Kosong? Lempar ke Login.
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity, // Pastikan mengambil tinggi penuh layar
              child: Stack(
                children: [
                  // --- BLOK LOGO (Tengah Absolut) ---
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Kolom hanya setinggi kontennya
                      children: [
                        const Icon(
                          Icons.local_parking,
                          size: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Parkir Digital\nBapenda',
                          textAlign: TextAlign.center,
                          style: AppTypography.heading1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- BLOK STATUS (Mentok Bawah) ---
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      // Jarak aman dari dasar layar (aman untuk layar notch/home indicator)
                      padding: const EdgeInsets.only(
                        bottom: 48.0,
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Sangat penting agar tidak memenuhi layar
                        children: [
                          if (state is InitLoading || state is InitInitial) ...[
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Memeriksa kesiapan perangkat...',
                              style: AppTypography.bodyRegular.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ] else if (state is InitError) ...[
                            // Mitigasi Risiko: Jika perangkat gagal memenuhi syarat
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.error,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyRegular.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  PbPrimaryButton(
                                    text: 'Coba Lagi',
                                    onPressed: () {
                                      context
                                          .read<InitCubit>()
                                          .checkDeviceReadiness();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
