// lib/features/home/presentation/widgets/home_drawer.dart
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/di/injection.dart';
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
            child: FutureBuilder<Map<String, dynamic>?>(
              future: locator<ISecureStorageManager>().getJukirProfile(),
              builder: (context, snapshot) {
                // Tampilkan loading kecil jika brankas sedang dibuka
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                // Ambil data dari brankas
                final String namaJukir =
                    snapshot.data?['namaUser'] ?? 'Juru Parkir';
                final String nop = snapshot.data?['nop'] ?? '-';
                final String lokasi =
                    snapshot.data?['namaObjekPajak'] ?? 'Bapenda Surabaya';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // [PERBAIKAN 1]: Menggunakan variabel namaJukir, bukan hardcode
                    Text(
                      namaJukir,
                      style: AppTypography.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NOP: $nop',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lokasi,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                );
              },
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
                  onTap: () => Navigator.pop(context),
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
                  onTap: () => Navigator.pop(context),
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
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: AppTypography.bodyRegular.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Tutup laci

              PbShowDialog.show(
                context,
                title: 'Konfirmasi Logout',
                description: 'Apakah Anda yakin ingin keluar dari aplikasi?',
                onConfirm: () {
                  // [PERBAIKAN 2]: Panggil langsung lewat Locator GetIt!
                  // Ini akan mengabaikan masalah "Context" pada Dialog.
                  locator<AppAuthCubit>().forceLogout();
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
