import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class PaymentCountdownTimer extends StatelessWidget {
  final Duration duration;
  final VoidCallback? onTimeout;

  const PaymentCountdownTimer({
    super.key,
    this.duration = const Duration(minutes: 5),
    this.onTimeout,
  });

  @override
  Widget build(BuildContext context) {
    // TweenAnimationBuilder sangat optimal untuk UI timer
    // Karena hanya me-rebuild widget di dalam builder ini saja setiap detiknya.
    return TweenAnimationBuilder<Duration>(
      duration: duration,
      tween: Tween(begin: duration, end: Duration.zero),
      onEnd: onTimeout,
      builder: (context, value, child) {
        final minutes = value.inMinutes;
        final seconds = value.inSeconds % 60;

        // Semantic Rule: Merah jika sisa waktu 60 detik atau kurang
        final isWarning = value.inSeconds <= 60;

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
                  fontWeight: FontWeight.w600, // Menambahkan ketegasan visual
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
