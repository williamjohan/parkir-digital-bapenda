import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_permission_gate.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';

class HomeDrawer extends StatelessWidget {
  final bool isFree;
  final RoleLoginDigitalParkir role;
  final String? namaUPTB;
  final Future<bool> Function()? onCheckOpBeforeRouting;

  const HomeDrawer({
    super.key,
    required this.isFree,
    required this.role,
    this.namaUPTB,
    this.onCheckOpBeforeRouting,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 14,
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
                Text(
                  "© Bapenda Kota Surabaya",
                  style: AppTypography.heading6.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    String versionText = "Version ...";

                    if (snapshot.hasData) {
                      versionText = "Version ${snapshot.data!.version}";
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                //Riwayat Transaksi atau Objek Pajak
                ListTile(
                  leading: Icon(
                    role == RoleLoginDigitalParkir.jukir
                        ? Icons.receipt_long
                        : Icons.store,
                    color: AppColors.textPrimary,
                  ),

                  title: Text(
                    (role == RoleLoginDigitalParkir.jukir ||
                            role == RoleLoginDigitalParkir.pengawas)
                        ? 'Riwayat Transaksi'
                        : 'Objek Pajak',
                    style: AppTypography.bodyRegular,
                  ),

                  onTap: () async {
                    Navigator.pop(context);

                    if (role == RoleLoginDigitalParkir.jukir ||
                        role == RoleLoginDigitalParkir.pengawas) {
                      if (!context.mounted) return;

                      context.pushNamed(
                        AppRoutes.history,
                        extra: {'isFree': false},
                      );
                    } else {
                      if (onCheckOpBeforeRouting != null) {
                        final canNavigate = await onCheckOpBeforeRouting!();

                        if (!context.mounted) return;

                        if (!canNavigate) return;
                      }

                      context.pushNamed(
                        AppRoutes.searchObjekPajak,
                        extra: {'role': role},
                      );
                    }
                  },
                ),

                //Pendapatan Digital
                PbPermissionGate(
                  allowedRoles: const [RoleLoginDigitalParkir.bapenda],
                  currentRole: role,
                  child: ListTile(
                    leading: const Icon(
                      Icons.money,
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Pendapatan Digital',
                      style: AppTypography.bodyRegular,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.pendapatanDigital,
                        extra: namaUPTB,
                      );
                    },
                  ),
                ),

                //Realisasi
                PbPermissionGate(
                  allowedRoles: const [RoleLoginDigitalParkir.bapenda],
                  currentRole: role,
                  child: ListTile(
                    leading: const Icon(
                      Icons.trending_up,
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Realisasi',
                      style: AppTypography.bodyRegular,
                    ),

                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(
                        AppRoutes.realisasiSeluruhOP,
                        extra: namaUPTB,
                      );
                    },
                  ),
                ),

                //PROFILE
                PbPermissionGate(
                  allowedRoles: const [
                    RoleLoginDigitalParkir.bapenda,
                    RoleLoginDigitalParkir.jukir,
                    RoleLoginDigitalParkir.wp,
                  ],
                  currentRole: role,
                  child: ListTile(
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
                ),

                //PENGATURAN PRINTER
                ListTile(
                  leading: const Icon(Icons.print),
                  title: const Text(
                    'Pengaturan Printer',
                    style: AppTypography.bodyRegular,
                  ),
                  onTap: () async {
                    context.pushNamed(AppRoutes.printerSetting);
                  },
                ),

                //Jadwal & Kehadiran
                PbPermissionGate(
                  allowedRoles: const [RoleLoginDigitalParkir.pengawas],
                  currentRole: role,
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Jadwal & Kehadiran',
                      style: AppTypography.bodyRegular,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(AppRoutes.jadwalKehadiran);
                    },
                  ),
                ),

                //Cek Pembaruan
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
                    Navigator.pop(context);
                    if (appFlavor == 'playstore') {
                      context.pushNamed(AppRoutes.updatePlaystore);
                    } else {
                      context.pushNamed(AppRoutes.update);
                    }
                  },
                ),
              ],
            ),
          ),
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
