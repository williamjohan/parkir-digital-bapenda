import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/payment/presentation/widgets/timer_widget.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardQrisWidget extends StatefulWidget {
  final String url;
  final String objekPajak;
  final String idTransaksi;
  final int durasi;
  final VoidCallback? onFinish;

  const CardQrisWidget({
    super.key,
    required this.url,
    required this.objekPajak,
    required this.idTransaksi,
    required this.durasi,
    this.onFinish,
  });

  @override
  State<CardQrisWidget> createState() => _CardQrisWidgetState();
}

class _CardQrisWidgetState extends State<CardQrisWidget> {
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
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/qris_logo.png",
                  // width: 100,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/gpn_logo.png",
                  // width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(20),
              // border: Border.all(color: AppColors.warning, width: 0.5),
            ),
            child: Image.memory(base64Decode(widget.url), fit: BoxFit.cover),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider(color: AppColors.border)),
              SizedBox(width: 8),
              TimerWidget(durasi: widget.durasi, onFinish: widget.onFinish),
              SizedBox(width: 8),
              Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          SizedBox(height: 20),
          Text(widget.objekPajak, style: AppTypography.heading5),
          Text("ID : ${widget.idTransaksi}", style: AppTypography.caption),
        ],
      ),
    );
  }
}
