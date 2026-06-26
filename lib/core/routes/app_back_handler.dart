import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design_system/components/pb_status_snackbar.dart';
import '../utils/app_lifecycle_utils.dart';
import '../utils/app_logger.dart';

class AppBackHandler extends StatefulWidget {
  final Widget child;

  const AppBackHandler({super.key, required this.child});

  @override
  State<AppBackHandler> createState() => _AppBackHandlerState();
}

class _AppBackHandlerState extends State<AppBackHandler>
    with WidgetsBindingObserver {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    AppLogger.warning('>>> LOW-LEVEL ENGINE: TOMBOL BACK DITEKAN! <<<');

    final router = GoRouter.of(context);

    if (router.canPop()) {
      router.pop();
      return true;
    }

    final now = DateTime.now();
    if (_lastBackPressTime != null) {
      final diff = now.difference(_lastBackPressTime!);
      if (diff < const Duration(milliseconds: 300)) {
        return true;
      }
    }
    final isWarningState =
        _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2);
    _lastBackPressTime = now;

    if (isWarningState) {
      AppLifecycleUtils.sendToBackground();
      return true;
    }

    if (mounted) {
      PbStatusSnackbar.show(
        context,
        message: 'Tekan kembali sekali lagi untuk keluar dari aplikasi',
        isError: false,
        customIcon: Icons.info_outline,
        duration: const Duration(seconds: 2),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
