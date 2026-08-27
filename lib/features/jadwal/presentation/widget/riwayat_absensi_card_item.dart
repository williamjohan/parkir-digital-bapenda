import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class RiwayatAbsensiCard extends StatelessWidget {
  final ObjekPengawasanEntity record;
  const RiwayatAbsensiCard({super.key, required this.record});

  bool get _sudahCheckOut {
    final jam = record.jamCheckOut;
    if (jam == null || jam.trim().isEmpty) return false;

    if (jam == '00:00' || jam == '00:00:00') return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          _buildSessionBlock(
            label: 'Check In',
            time: record.jamCheckIn,
            shift: record.shiftCheckIn,
            icon: Icons.login_rounded,
            iconColor: AppColors.info,
            jumlahMotor: record.motorCheckIn,
            jumlahMobil: record.mobilCheckIn,
            instrumen: record.instrumenCheckIn,
            belumAdaText: 'Data instrumen tidak tersedia',
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),

          _buildSessionBlock(
            label: 'Check Out',
            time: _sudahCheckOut ? (record.jamCheckOut ?? '--:--') : '--:--',

            shift: _sudahCheckOut ? record.shiftCheckOut : null,

            icon: Icons.logout_rounded,
            iconColor: _sudahCheckOut ? AppColors.warning : AppColors.textHint,

            jumlahMotor: _sudahCheckOut ? record.motorCheckOut : null,
            jumlahMobil: _sudahCheckOut ? record.mobilCheckOut : null,
            instrumen: _sudahCheckOut ? record.instrumenCheckOut : null,

            belumAdaText: _sudahCheckOut
                ? 'Data instrumen tidak tersedia'
                : 'Belum melakukan check out',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.storefront_rounded,
            size: 21,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.namaNop,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NOP: ${record.nop}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionBlock({
    required String label,
    required String time,
    required String? shift,
    required IconData icon,
    required Color iconColor,
    required int? jumlahMotor,
    required int? jumlahMobil,
    required List<InstrumenTersediaEntity>? instrumen,
    required String belumAdaText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              const Spacer(),
              if (shift != null && shift.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // Latar putih solid agar kontras
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule_rounded, size: 12, color: iconColor),
                      const SizedBox(width: 4),
                      Text(
                        'Pengawasan Ke - $shift',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color:
                              iconColor, // Warna teks mengikuti warna tema blok (Info/Warning)
                          letterSpacing:
                              0.5, // Sedikit renggang agar lebih formal
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVehicleChip(
                  Icons.two_wheeler_rounded,
                  jumlahMotor,
                  'Motor',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildVehicleChip(
                  Icons.directions_car_rounded,
                  jumlahMobil,
                  'Mobil',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'ALAT SAAT ${label.toUpperCase()}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          (instrumen == null || instrumen.isEmpty)
              ? Text(
                  belumAdaText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                )
              : _buildInstrumenChips(instrumen),
        ],
      ),
    );
  }

  Widget _buildVehicleChip(IconData icon, int? count, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            count?.toString() ?? '-',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumenChips(List<InstrumenTersediaEntity> instrumen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const columns = 3;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: instrumen
              .map(
                (i) => SizedBox(
                  width: itemWidth,
                  child: _buildInstrumenChip(i.nama, i.tersedia),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildInstrumenChip(String label, bool tersedia) {
    final color = tersedia ? AppColors.success : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: tersedia
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: tersedia
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            tersedia ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 15,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
