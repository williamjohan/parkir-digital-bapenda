import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/payment/presentation/widgets/timer_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardQrisWidget extends StatefulWidget {
  final Uint8List imageBytes;
  final String objekPajak;
  final String idTransaksi;
  final int durasi;
  final VoidCallback? onFinish;

  const CardQrisWidget({
    super.key,
    required this.imageBytes,
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
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/qris_logo.png",
                  height: 30,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/gpn_logo.png",
                  height: 30,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
            decoration: BoxDecoration(color: Colors.white),
            child: Image.memory(
              width: 300,
              height: 300,
              widget.imageBytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null) {
                  return AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 300),
                    child: child,
                  );
                }

                return const QrShimmer();
              },
            ),
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
          SizedBox(height: 16),
          Text(widget.objekPajak, style: AppTypography.heading5),
          Text("ID : ${widget.idTransaksi}", style: AppTypography.caption),
        ],
      ),
    );
  }
}

class QrShimmer extends StatelessWidget {
  const QrShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 0),
      color: Colors.white,
      colorOpacity: 0.3,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
