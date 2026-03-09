import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

class LoginBackgroundWidget extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;
  final bool isHidden;

  const LoginBackgroundWidget({
    super.key,
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
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.6),
            AppColors.primary.withOpacity(0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        image: DecorationImage(
          image: const AssetImage("assets/images/loginscreen.png"),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Image.asset(
                      "assets/images/city_of_heroes.png",
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
              const Text(
                "Nikmati kemudahan parkir digital dengan aplikasi resmi dari Bapenda Surabaya.",
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),

              // GROUP TOMBOL (Login & Register)
              // Kita bungkus Column ini dengan AnimatedOpacity
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
                        onPressed: isHidden ? null : onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
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

                    // 2. TOMBOL REGISTER (Secondary - Outlined/Transparan)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: isHidden ? null : onRegisterPressed,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Daftar Akun Baru",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
