import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class TimerWidget extends StatefulWidget {
  final int durasi;
  final VoidCallback? onFinish;

  const TimerWidget({super.key, required this.durasi, this.onFinish});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late DateTime _endTime; // 🚀 Waktu target kedaluwarsa absolut
  int _sisaWaktu = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(minutes: widget.durasi));
    _sisaWaktu = widget.durasi * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      final now = DateTime.now();
      if (now.isBefore(_endTime)) {
        setState(() {
          _sisaWaktu = _endTime.difference(now).inSeconds;
        });
      } else {
        t.cancel();
        if (widget.onFinish != null) {
          widget.onFinish!();
        }
      }
    });
  }

  String _formatWaktu(int detik) {
    final menit = detik ~/ 60;
    final sisaDetik = detik % 60;
    final formattedDetik = sisaDetik.toString().padLeft(2, '0');
    return "$menit menit : $formattedDetik detik";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Masa berlaku : ", style: AppTypography.caption),
        Text(
          _formatWaktu(_sisaWaktu),
          style: AppTypography.caption.copyWith(color: AppColors.error),
        ),
      ],
    );
  }
}
