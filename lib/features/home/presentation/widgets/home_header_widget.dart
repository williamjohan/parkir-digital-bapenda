import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../cubit/home/home_state.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String namaJukir;
  final String? nop;
  final String? namaObjekPajak;
  final String? nmOpd;
  final String? namalokasi;
  final String? alamatObjekPengawasan;
  final RoleLoginDigitalParkir role;
  final HomeStatus status;
  final ShiftPengawasan? shift;
  final JenisPengawasan? jenis;
  final VoidCallback? onPressed;

  const HomeHeaderWidget({
    super.key,
    required this.status,
    required this.namaJukir,
    this.nop,
    this.nmOpd,
    this.namaObjekPajak,
    this.namalokasi,
    this.alamatObjekPengawasan,
    required this.role,
    this.shift,
    this.jenis,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚀 1. AREA UTAMA: GREETING & DRAWER BUTTON (Tinggi selalu konsisten)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TS PARK SURABAYA",
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Hallo, $namaJukir !",
                      style: AppTypography.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (role == RoleLoginDigitalParkir.pengawas)
                      Text(
                        "OPD : $nmOpd",
                        style: AppTypography.heading4.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildMenuButton(context),
            ],
          ),

          const SizedBox(height: 12),

          _buildDynamicRoleSection(),
        ],
      ),
    );
  }

  // Tombol Menu melingkar
  Widget _buildMenuButton(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  // Pengecekan Slot Dinamis
  Widget _buildDynamicRoleSection() {
    switch (role) {
      case RoleLoginDigitalParkir.jukir || RoleLoginDigitalParkir.jukircounter:
        return _buildJukirMetadataCard();
      case RoleLoginDigitalParkir.pengawas:
        return _buildPengawasActionCard();
      default:
        return _buildBapendaInstitutionalCard();
    }
  }

  // 🔹 SLOT 1: KARTU METADATA JUKIR (NOP, OP, Lokasi)
  Widget _buildJukirMetadataCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Text(
                "NOP : $nop",
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (namaObjekPajak != null && namaObjekPajak!.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.storefront_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    namaObjekPajak!,
                    style: AppTypography.bodySemiBold.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (namalokasi != null && namalokasi!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    namalokasi!,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 🔹 SLOT 2: KARTU AKSI PENGAWAS
  Widget _buildPengawasActionCard() {
    final bool isUnassigned = status == HomeStatus.needsSelection;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isUnassigned ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: isUnassigned ? _buildZeroStateHeader() : _buildAssignedHeader(),
    );
  }

  // 🔹 SLOT 3: KARTU INSTANSI BAPENDA (Default)
  Widget _buildBapendaInstitutionalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BAPENDA KOTA SURABAYA",
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Sistem Pengelolaan Parkir Digital",
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroStateHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Selamat Datang",
          style: AppTypography.heading6.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          "Mohon pilih Objek Pengawasan terlebih dahulu untuk mulai melakukan pengawasan.",
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 16),
        PbPrimaryButton(
          text: "Pilih Objek Pengawasan",
          variant: PbButtonVariant.secondaryLight,
          iconLeft: Icons.search,
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget _buildAssignedHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Objek Pengawasan : ${namaObjekPajak ?? '-'}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySemiBold.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "NOP : $nop",
          style: AppTypography.bodySemiBold.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          // Menampilkan label enum yang disuntikkan
          "Alamat : $alamatObjekPengawasan",
          style: AppTypography.bodySemiBold.copyWith(
            fontSize: 12,
            color: Colors.yellowAccent,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        PbPrimaryButton(
          text: "Ubah Objek Pengawasan",
          variant: PbButtonVariant.outlinedSecondaryLight,
          onPressed: onPressed,
          iconLeft: Icons.loop,
        ),
      ],
    );
  }
}
