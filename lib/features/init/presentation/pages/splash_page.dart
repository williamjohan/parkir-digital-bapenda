// lib/features/init/presentation/pages/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
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
            // TODO: Lakukan navigasi ke Home (Pilih Kendaraan)
            debugPrint('Perangkat Siap. Lanjut ke Home.');
          }
        },
        builder: (context, state) {
          // Builder khusus untuk merender ulang UI
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Placeholder Logo Aplikasi Bapenda
                  const Icon(
                    Icons.local_parking,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Parkir Digital\nBapenda',
                    textAlign: TextAlign.center,
                    style: AppTypography.heading1.copyWith(color: Colors.white),
                  ),
                  const Spacer(),

                  // Reactive UI berdasarkan State dari Cubit
                  if (state is InitLoading || state is InitInitial) ...[
                    const CircularProgressIndicator(color: Colors.white),
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
                          // Menggunakan komponen buatan kita sendiri
                          PbPrimaryButton(
                            text: 'Coba Lagi',
                            onPressed: () {
                              context.read<InitCubit>().checkDeviceReadiness();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
