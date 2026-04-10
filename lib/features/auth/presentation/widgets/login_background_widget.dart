import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/constants/app_asset_constant.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class LoginBackgroundWidget extends StatelessWidget {
  final VoidCallback onActivateDevice;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;
  final bool isHidden;

  const LoginBackgroundWidget({
    super.key,
    required this.onActivateDevice,
    required this.onLoginPressed,
    required this.onRegisterPressed,
    required this.isHidden,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primary.withValues(alpha: 0.6),
            AppColors.primary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        image: const DecorationImage(
          // [PERBAIKAN]: Tambahkan const di sini
          image: AssetImage(AppAssetImages.loginscreen),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: SafeArea(
        // 🚀 [KUNCI ARSITEKTUR RESPONSIVE]:
        // Menggunakan LayoutBuilder agar UI otomatis menjadi Scrollable
        // HANYA JIKA layar HP pengguna terlalu kecil.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints
                      .maxHeight, // Paksa tinggi minimal selayar penuh
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Transform.translate(
                              offset: const Offset(-20, 0),
                              child: Image.asset(
                                AppAssetImages.cityOfHeroes,
                                height: 80,
                                color: Colors.white,
                              ),
                            ),
                            //logo lainnya
                          ],
                        ),

                        const Text(
                          "Sugeng Rawuh,",
                          style: TextStyle(
                            color: AppColors.background,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Parkir Digital Surabaya",
                          style: TextStyle(
                            color: AppColors.background,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Nikmati kemudahan parkir digital dengan aplikasi resmi dari Bapenda Surabaya.",
                          style: TextStyle(
                            color: AppColors.background,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Spacer akan mendorong tombol secara elastis ke paling bawah layar
                        const Spacer(),
                        const SizedBox(
                          height: 24,
                        ), // Jarak aman minimal sebelum tombol
                        // GROUP TOMBOL (Login & Register)
                        AnimatedOpacity(
                          opacity: isHidden ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              // 1. TOMBOL LOGIN (Primary - Putih)
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  // onPressed: isHidden ? null : onLoginPressed,
                                  onPressed: isHidden ? null : onLoginPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text(
                                    "Masuk Akun",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),
                            ],
                          ),
                        ),

                        // [PERBAIKAN]: Jarak kaku 50px diubah menjadi 24px agar lebih proporsional di semua layar
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
