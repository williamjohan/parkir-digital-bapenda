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
    return Padding(
      // Padding ini sudah cukup, tindakan Anda men-comment padding di HomePage sudah benar!
      padding: const EdgeInsets.only(left: 16, right: 16, top: 29),
      child: SizedBox(
        height:
            85, // 🔥 KUNCI: Set tinggi fixed di sini (Silakan sesuaikan angkanya dengan desain figma, misal 80, 85, atau 90)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment
              .start, // Atur ke center jika ingin teks berada di tengah area secara vertikal
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .center, // Membantu teks tetap seimbang di tengah ruang SizedBox
                children: [
                  if (role != RoleLoginDigitalParkir.jukir) ...[
                    Text(
                      "TS PARK",
                      style: AppTypography.heading1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "BAPENDA KOTA SURABAYA",
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                      ),
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
            const SizedBox(width: 16),
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
        ),
      ),
    );
  }
}
