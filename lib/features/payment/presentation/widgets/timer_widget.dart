import 'dart:async';
import 'package:flutter/widgets.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class TimerWidget extends StatefulWidget {
  final int durasi; // dalam menit
  final VoidCallback? onFinish; // action saat timer habis

  const TimerWidget({super.key, required this.durasi, this.onFinish});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int sisaWaktu;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    sisaWaktu = widget.durasi * 60;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (sisaWaktu > 0) {
        setState(() {
          sisaWaktu--;
        });
      } else {
        t.cancel();
        if (widget.onFinish != null) {
          widget.onFinish!(); // jalankan action saat timer habis
        }
      }
    });
  }

  String formatWaktu(int detik) {
    final menit = detik ~/ 60;
    final sisaDetik = detik % 60;

    return "$menit menit : $sisaDetik detik";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Masa berlaku : ", style: AppTypography.caption),
        Text(
          formatWaktu(sisaWaktu),
          style: AppTypography.caption.copyWith(color: AppColors.error),
        ),
      ],
    );
  }
}
