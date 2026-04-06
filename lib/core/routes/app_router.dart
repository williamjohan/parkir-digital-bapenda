// lib/core/routes/app_router.dart

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/printer/presentation/screen/printer_device_screen.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/cubit/transaction_history_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/pages/transaction_history_page.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../../features/parking_transaction/persentation/cubit/parking_transaction_cubit.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/printer/presentation/cubit/printer_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/quick_parking/presentation/pages/quick_park_page.dart';
import '../../features/vehicle_capture/domain/entities/vehicle_category.dart';
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/capture_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static GoRouter? _router;

  // Kita ubah menjadi function/getter agar bisa menerima instance AppAuthCubit
  static GoRouter getRouter(AppAuthCubit appAuthCubit) {
    if (_router != null) {
      return _router!;
    }
    // Jika belum ada, baru kita buat.
    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      observers: [ChuckerFlutter.navigatorObserver],
      refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),
      redirect: (context, state) {
        final authState = appAuthCubit.state;
        final path = state.uri.path;

        final isGoingToLogin = path == AppRoutes.login;
        final isGoingToSplash = path == AppRoutes.splash;

        if (authState is AppAuthInitial) {
          return null;
        }

        if (authState is AppUnauthenticated) {
          if (!isGoingToLogin && !isGoingToSplash) {
            return AppRoutes.login;
          }
        }

        if (authState is AppAuthenticated) {
          if (isGoingToLogin || isGoingToSplash) {
            return AppRoutes.home;
          }
        }

        return null;
      },

      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<InitCubit>(),
              child: const SplashPage(),
            );
          },
        ),

        // RUTE BARU: LOGIN
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) {
            // LoginScreen sudah menyediakan LoginCubit (Lokal) di dalamnya
            return const LoginScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<HomeCubit>(),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          path: '${AppRoutes.capture}/:category',
          builder: (context, state) {
            final categoryString = state.pathParameters['category'];
            final category = categoryString == 'mobil'
                ? VehicleCategory.mobil
                : VehicleCategory.motor;

            // [PERBAIKAN]: Gunakan MultiBlocProvider untuk 2 Jenderal!
            return MultiBlocProvider(
              providers: [
                // 1. Jenderal Mata (Yang mengurus Kamera & OCR)
                BlocProvider(
                  create: (_) =>
                      locator<VehicleCaptureCubit>()..selectVehicle(category),
                ),
                // 2. Jenderal Otak (Yang mengurus SQLite & Kompresi)
                BlocProvider(create: (_) => locator<ParkingTransactionCubit>()),
              ],
              child: const CapturePage(),
            );
          },
        ),
        GoRoute(
          path: '${AppRoutes.quickPark}/:category',
          builder: (context, state) {
            // 1. Tangkap parameter dari URL (motor/mobil)
            final categoryString = state.pathParameters['category'] ?? 'motor';

            // 2. [INJEKSI]: Halaman ini HANYA butuh Sang Otak (ParkingTransactionCubit)
            // Tidak butuh Jenderal Kamera!
            return BlocProvider(
              create: (_) => locator<ParkingTransactionCubit>(),
              child: QuickParkPage(kategoriKendaraan: categoryString),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.payment,
          builder: (context, state) {
            // Tangkap objek PaymentPageArgs dari property 'extra'
            final args = state.extra as PaymentPageArgs;
            return PaymentPage(args: args);
          },
        ),

        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<ProfileCubit>(),
              child: const ProfilePage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<TransactionHistoryCubit>(),
              child: const TransactionHistoryPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.printerSettings,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => locator<PrinterCubit>(),
              child: const PrinterDeviceScreen(),
            );
          },
        ),
      ],
    );

    return _router!;
  }
}
