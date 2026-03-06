import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_back_handler.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/permission_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackHandler(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Parkir Digital Bapenda',
            style: AppTypography.heading2,
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Pilih Jenis Kendaraan',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih tipe kendaraan untuk menyesuaikan rasio kotak panduan kamera pemindai.',
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _VehicleCard(
                      title: 'Motor',
                      icon: Icons.two_wheeler,
                      onTap: () async {
                        final isGranted =
                            await PermissionUtils.requestCameraPermission(
                              context,
                            );

                        // 2. Jika diizinkan dan widget masih aktif, lakukan navigasi
                        if (isGranted && context.mounted) {
                          context.push('${AppRoutes.capture}/motor');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _VehicleCard(
                      title: 'Mobil',
                      icon: Icons.directions_car,
                      onTap: () async {
                        final isGranted =
                            await PermissionUtils.requestCameraPermission(
                              context,
                            );

                        // 2. Jika diizinkan dan widget masih aktif, lakukan navigasi
                        if (isGranted && context.mounted) {
                          context.push('${AppRoutes.capture}/mobil');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryLight.withValues(alpha: .3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.heading2),
          ],
        ),
      ),
    );
  }
}
