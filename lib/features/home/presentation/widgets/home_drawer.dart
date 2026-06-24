// lib/features/home/presentation/widgets/home_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parkir_digital_bapenda/core/constants/feature_flag.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../cubit/home/home_cubit.dart';

class HomeDrawer extends StatelessWidget {
  final bool isFree;
  final RoleLoginDigitalParkir role;

  const HomeDrawer({super.key, required this.isFree, required this.role});

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
              bottom: 52,
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
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    // Beri nilai default saat Future masih berstatus 'loading'
                    String versionText = "Version ...";

                    if (snapshot.hasData) {
                      // Mengambil atribut "version" (misal: 1.0.0) dari pubspec.yaml
                      versionText = "Version ${snapshot.data!.version}";

                      // 💡 Opsional: Jika Anda juga ingin memunculkan Build Number (misal 1.0.0+2)
                      // versionText = "Version ${snapshot.data!.version}+${snapshot.data!.buildNumber}";
                    }

                    return Text(
                      versionText,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                      ),
                    );
                  },
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
                    Icons.store,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'Objek Pajak',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    if (role == RoleLoginDigitalParkir.jukir) {
                      context.pushNamed(
                        AppRoutes.history,
                        extra: {'isFree': true},
                      );
                    } else {
                      final result = await context.pushNamed(
                        AppRoutes.searchObjekPajak,
                        extra: {'role': RoleLoginDigitalParkir.bapenda},
                      );

                      if (result != null) {
                        await context.read<HomeCubit>().changeObjekPajak(
                          result as Map<String, dynamic>,
                        );
                      }
                    }
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
                if (FeatureFlags.enablePrinterFeature)
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
                      // context.push(AppRoutes.printerSetting);
                      context.goNamed(AppRoutes.printerSetting);
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.system_update_alt_rounded,
                    color: AppColors.textPrimary,
                  ),
                  title: const Text(
                    'Cek Pembaruan',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () {
                    Navigator.pop(context); // Tutup drawer
                    context.pushNamed(
                      AppRoutes.update,
                    ); // Arahkan ke rute update
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
