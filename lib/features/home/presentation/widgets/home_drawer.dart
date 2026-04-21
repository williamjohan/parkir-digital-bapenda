// lib/features/home/presentation/widgets/home_drawer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // --- HEADER DRAWER (DINAMIS DARI BRANKAS) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PARKIR DIGITAL",
                  style: AppTypography.heading1.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Version 1.0.2",
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          // --- ITEM MENU ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'History Transaksi',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.history);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'Profile',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () {
                    Navigator.pop(context); // Tutup drawer
                    context.push(AppRoutes.profile);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.print,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'Printer Settings',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () {
                    Navigator.pop(context); // Tutup drawer
                    context.push(AppRoutes.printerSetting);
                  },
                ),
              ],
            ),
          ),

          // --- LOGOUT BUTTON ---
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            trailing: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: AppTypography.bodyRegular.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              final safeNavigator = Navigator.of(context, rootNavigator: true);
              final safeContext = safeNavigator.context;

              Navigator.pop(context);

              PbShowDialog.show(
                safeContext,
                showBtnKeluar: true,
                title: 'Konfirmasi Logout',
                description: 'Apakah Anda yakin ingin keluar dari aplikasi?',
                onConfirm: () async {
                  showDialog(
                    context: safeContext,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return const Center(child: AppLoadingWidget(size: 150));
                    },
                  );
                  await Future.delayed(const Duration(milliseconds: 800));
                  await locator<AppAuthCubit>().forceLogout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
