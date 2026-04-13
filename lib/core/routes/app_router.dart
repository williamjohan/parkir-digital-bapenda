import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/transaction/page/transaction_page.dart';
import '../../features/transaction/cubit/transaction_cubit.dart'; // Sesuaikan path jika namanya berbeda
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/cubit/transaction_history_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/pages/transaction_history_page.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/printer/presentation/cubit/printer_cubit.dart';
import '../../features/printer/presentation/screen/printer_settings_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/capture_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static GoRouter? _router;

  static GoRouter getRouter(AppAuthCubit appAuthCubit) {
    if (_router != null) {
      return _router!;
    }

    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      observers: [ChuckerFlutter.navigatorObserver],
      refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),
      redirect: (context, state) {
        final authState = appAuthCubit.state;
        final path = state.uri.path;

        final isGoingToLogin = path == AppRoutes.login;
        final isGoingToSplash = path == AppRoutes.splash;

        if (authState is AppAuthInitial) return null;

        if (authState is AppUnauthenticated) {
          if (!isGoingToLogin && !isGoingToSplash) return AppRoutes.login;
        }

        if (authState is AppAuthenticated) {
          if (isGoingToLogin || isGoingToSplash) return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<InitCubit>(),
            child: const SplashPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<HomeCubit>(),
            child: const HomePage(),
          ),
        ),

        // 🚀 [PERBAIKAN 1]: Rute Kamera Super Bersih! Tidak bawa parameter apa-apa.
        GoRoute(
          path: AppRoutes.capture,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<VehicleCaptureCubit>(),
              child: const CapturePage(), // Tanpa parameter
            );
          },
        ),

        // 🚀 [PERBAIKAN 2]: Rute QuickPark DIMUSNAHKAN! (Dihapus dari sini)
        GoRoute(
          path: AppRoutes.payment,
          builder: (context, state) {
            final args = state.extra as PaymentPageArgs;
            return PaymentPage(args: args);
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<ProfileCubit>(),
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) {
            final initialDate = state.extra as DateTime?;
            return BlocProvider(
              create: (_) => locator<TransactionHistoryCubit>(),
              child: TransactionHistoryPage(initialDate: initialDate),
            );
          },
        ),

        // 🚀 [PERBAIKAN 3]: Menyuntikkan Cubit ke Halaman Transaction
        GoRoute(
          path: AppRoutes.transaction,
          builder: (context, state) {
            // 🚀 [PERBAIKAN]: Tangkap data yang dikirim dari layar sebelumnya
            // Jika tidak ada data yang dikirim, default-nya adalah false (Aman)
            final isFree = state.extra as bool? ?? false;

            return BlocProvider(
              create: (_) => locator<TransactionCubit>(),
              child: TransactionPage(isFree: isFree),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.printerSettings,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<PrinterCubit>(),
            child: const PrinterSettingsPage(),
          ),
        ),
      ],
    );

    return _router!;
  }
}
