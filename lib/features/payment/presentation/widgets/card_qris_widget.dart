import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardQrisWidget extends StatelessWidget {
  final String url;
  final String objekPajak;
  final String idTransaksi;

  const CardQrisWidget({
    super.key,
    required this.url,
    required this.objekPajak,
    required this.idTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(60),
      padding: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60, right: 60, left: 60),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryDark, width: 0.5),
            ),
            child: PrettyQrView.data(
              data: url,
              errorCorrectLevel: QrErrorCorrectLevel.H,
              decoration: const PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(color: Color(0xFF111111)),
                image: PrettyQrDecorationImage(
                  image: AssetImage('assets/images/logosby.png'),
                  scale: 0.25,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider(color: AppColors.border)),
              SizedBox(width: 8),
              Text(
                "QRIS",
                style: AppTypography.heading3.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(width: 8),
              Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          SizedBox(height: 20),
          Text(objekPajak, style: AppTypography.heading5),
          Text("ID : $idTransaksi", style: AppTypography.caption),
        ],
      ),
    );
  }
}
