import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class PaymentCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onTimeout;

  const PaymentCountdownTimer({
    super.key,
    this.duration = const Duration(minutes: 5),
    this.onTimeout,
  });

  @override
  State<PaymentCountdownTimer> createState() => _PaymentCountdownTimerState();
}

class _PaymentCountdownTimerState extends State<PaymentCountdownTimer> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        // Memicu aksi timeout dengan aman
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;

    // Semantic Rule: Merah jika sisa waktu 60 detik atau kurang
    final isWarning = _remainingTime.inSeconds <= 60;

    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWarning ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: isWarning ? Colors.red.shade700 : Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            'Sisa Waktu: $formattedTime',
            style: AppTypography.bodyRegular.copyWith(
              color: isWarning ? Colors.red.shade700 : Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
