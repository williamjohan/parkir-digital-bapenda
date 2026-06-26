import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String namaJukir;
  final String nop;
  final String? namaObjekPajak;
  final RoleLoginDigitalParkir role;
  final VoidCallback? onPressed;

  const HomeHeaderWidget({
    super.key,
    required this.namaJukir,
    required this.nop,
    this.namaObjekPajak,
    required this.role,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (role != RoleLoginDigitalParkir.jukir) ...[
                Text(
                  "TS PARK",
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "BAPENDA KOTA SURABAYA",
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
              ],
              Text(
                "Hallo, $namaJukir !",
                style: AppTypography.heading1.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (role == RoleLoginDigitalParkir.jukir) ...[
                Text(
                  "NOP : $nop",
                  style: AppTypography.bodyRegular.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  namaObjekPajak ?? '',
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 16),
        Builder(
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }
}
