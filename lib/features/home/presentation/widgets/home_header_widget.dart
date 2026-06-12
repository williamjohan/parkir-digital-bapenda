import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String namaJukir;
  final String nop;
  final String? namaLokasi;

  const HomeHeaderWidget({
    super.key,
    required this.namaJukir,
    required this.nop,
    this.namaLokasi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hallo, $namaJukir !",
              style: AppTypography.heading1.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "NOP : $nop",
              style: AppTypography.bodyRegular.copyWith(color: Colors.white),
            ),
            Text(
              namaLokasi ?? '',
              style: AppTypography.bodySemiBold.copyWith(color: Colors.white),
            ),
          ],
        ),

        // tombol menu
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
