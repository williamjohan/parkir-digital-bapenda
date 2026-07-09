import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../printer/presentation/cubit/printer_cubit.dart';

class HomeDrawer extends StatelessWidget {
  final bool isFree;
  final RoleLoginDigitalParkir role;
  final String? namaUPTB;

  const HomeDrawer({
    super.key,
    required this.isFree,
    required this.role,
    this.namaUPTB,
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
                      context.pushNamed(
                        AppRoutes.history,
                        extra: {'isFree': false},
                      );
                    } else {
                      context.pushNamed(
                        AppRoutes.searchObjekPajak,
                        extra: {'role': role},
                      );
                    }
                  },
                ),
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
                      Navigator.pop(context); // Tutup drawer
                      context.push(
                        AppRoutes.pendapatanDigital,
                        extra: namaUPTB,
                      );
                    },
                  ),
                ),

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
                // if (FeatureFlags.enablePrinterFeature)
                // ListTile(
                //   leading: const Icon(Icons.print),
                //   title: const Text('Pengaturan Printer'),
                //   onTap: () async {
                //     // 1. Tutup Drawer terlebih dahulu agar rapi
                //     Navigator.pop(context);

                //     // 2. Panggil fungsi cek permission yang baru saja kita pisah
                //     final isPermissionGranted = await context
                //         .read<PrinterCubit>()
                //         .checkAndRequestPermissions(context);

                //     // 3. Jika diizinkan, baru lakukan navigasi ke PrinterPage atau jalankan fungsi scan
                //     if (isPermissionGranted) {
                //       // Jalankan scan otomatis begitu masuk halaman (jika diinginkan)
                //       if (context.mounted) {
                //         context.read<PrinterCubit>().scanDevices(context);

                //         // Pindah ke halaman printer Anda, misal:
                //         Navigator.pushNamed(context, '/printer-page');
                //       }
                //     }
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.print),
                  title: const Text('Pengaturan Printer'),
                  onTap: () async {
                    // 1. Tangkap Cubit dan Context Halaman Utama (Safe Context) SEBELUM Drawer ditutup
                    final printerCubit = context.read<PrinterCubit>();
                    final safeContext = Navigator.of(
                      context,
                      rootNavigator: true,
                    ).context;

                    // 2. Tutup Drawer
                    Navigator.pop(context);

                    // 3. Panggil fungsi cek permission menggunakan safeContext yang masih hidup
                    final isPermissionGranted = await printerCubit
                        .checkAndRequestPermissions(safeContext);

                    // 4. Jika diizinkan, jalankan navigasi ke halaman pengaturan printer
                    if (isPermissionGranted) {
                      if (safeContext.mounted) {
                        // 🚀 PERBAIKAN: Gunakan safeContext untuk navigasi!
                        // (scanDevices dihapus dari sini karena di PrinterSettingsPage sudah otomatis dipanggil saat initState)
                        safeContext.pushNamed(AppRoutes.printerSetting);
                      }
                    }
                  },
                ),

                PbPermissionGate(
                  allowedRoles: const [RoleLoginDigitalParkir.pengawas],
                  currentRole:
                      role, // Menggunakan variabel 'role' yang disuplai dari State Cubit Anda
                  child: ListTile(
                    leading: const Icon(
                      Icons
                          .calendar_month_outlined, // Icon kalender yang bersih untuk representasi jadwal
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Jadwal & Kehadiran',
                      style: AppTypography.bodyRegular,
                    ),
                    onTap: () {
                      // 1. Tutup drawer terlebih dahulu agar tidak menghalangi transisi layar
                      Navigator.pop(context);

                      // 2. Navigasi ke layar Jadwal menggunakan pushNamed dari GoRouter
                      context.pushNamed(AppRoutes.jadwalKehadiran);
                    },
                  ),
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
