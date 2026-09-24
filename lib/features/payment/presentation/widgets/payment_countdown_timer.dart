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

// 🚀 WidgetsBindingObserver untuk memantau lifecycle (Background/Foreground)
class _PaymentCountdownTimerState extends State<PaymentCountdownTimer>
    with WidgetsBindingObserver {
  late DateTime _targetAbsoluteEndTime;
  late Duration _syncedRemainingTime;
  Duration _currentDisplayTime = Duration.zero;

  final Stopwatch _foregroundStopwatch = Stopwatch();
  Timer? _timer;

  // BARU: guard idempoten — tanpa ini, onTimeout bisa terpanggil
  // berkali-kali kalau user resume app berulang kali SETELAH timer
  // sebenarnya sudah habis (mis. lock-unlock HP setelah waktu pembayaran
  // lewat). didChangeAppLifecycleState tetap men-trigger _evaluateTick()
  // di setiap resume tanpa tahu apakah timeout sudah pernah "ditembak"
  // sebelumnya.
  bool _timeoutFired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Daftarkan observer

    // 1. Set jangkar absolut di masa depan
    _targetAbsoluteEndTime = DateTime.now().add(widget.duration);
    _syncedRemainingTime = widget.duration;
    _currentDisplayTime = widget.duration;

    // 2. Mulai jam internal yang kebal manipulasi (Monotonic)
    _foregroundStopwatch.start();
    _startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Kalau timeout sudah pernah ditembak, tidak perlu resync/evaluate
    // lagi — timer ini sudah "selesai tugasnya", resume berikutnya tidak
    // relevan lagi buat widget ini.
    if (state == AppLifecycleState.resumed && !_timeoutFired) {
      // 🚀 THE HYBRID SYNC: Terjadi setiap kali app kembali dari background
      _syncWithAbsoluteWallClock();
      _evaluateTick(); // Paksa update UI instan tanpa menunggu detik berikutnya
    }
  }

  void _syncWithAbsoluteWallClock() {
    final now = DateTime.now();
    if (now.isBefore(_targetAbsoluteEndTime)) {
      // Hitung sisa waktu aktual di dunia nyata
      _syncedRemainingTime = _targetAbsoluteEndTime.difference(now);
    } else {
      _syncedRemainingTime = Duration.zero;
    }
    // Reset stopwatch internal karena kita baru saja mendapat jangkar waktu baru
    _foregroundStopwatch.reset();
    _foregroundStopwatch.start();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _evaluateTick();
    });
  }

  void _evaluateTick() {
    if (!mounted) return;

    // Kurangi waktu tersinkronisasi terakhir dengan durasi stopwatch yang berjalan
    final remaining = _syncedRemainingTime - _foregroundStopwatch.elapsed;

    if (remaining.inSeconds > 0) {
      setState(() {
        _currentDisplayTime = remaining;
      });
    } else {
      _timer?.cancel();
      _foregroundStopwatch.stop();

      setState(() {
        _currentDisplayTime = Duration.zero;
      });

      // BARU: hanya panggil onTimeout sekali, walau _evaluateTick()
      // sempat terpanggil lagi belakangan (mis. dari resume berikutnya
      // sebelum guard di didChangeAppLifecycleState sempat mengecek).
      if (!_timeoutFired) {
        _timeoutFired = true;
        widget.onTimeout?.call();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Wajib cabut observer
    _timer?.cancel();
    _foregroundStopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _currentDisplayTime.inMinutes;
    final seconds = _currentDisplayTime.inSeconds % 60;

    final isWarning = _currentDisplayTime.inSeconds <= 60;

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
