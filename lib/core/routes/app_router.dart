// lib/core/routes/app_router.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart'; // Sesuaikan path
import '../../features/home/persentation/cubit/home_cubit.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../../features/vehicle_capture/domain/entities/vehicle_category.dart';
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/capture_page.dart';
import '../../features/home/persentation/pages/home_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  // Kita ubah menjadi function/getter agar bisa menerima instance AppAuthCubit
  static GoRouter getRouter(AppAuthCubit appAuthCubit) {
    return GoRouter(
      initialLocation: AppRoutes.splash,

      // 1. TELINGA ROUTER: GoRouter akan bereaksi tiap kali state AppAuthCubit berubah!
      refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),

      // 2. SATPAM RUTE (THE BOUNCER): Logic interceptor perpindahan halaman
      redirect: (context, state) {
        final authState = appAuthCubit.state;

        final isGoingToLogin = state.matchedLocation == AppRoutes.login;
        final isGoingToSplash = state.matchedLocation == AppRoutes.splash;

        // Kondisi A: Aplikasi baru buka, biarkan di Splash Screen dulu
        if (authState is AppAuthInitial) {
          return null;
        }

        // Kondisi B: Jukir TIDAK punya akses (Token basi / belum login)
        if (authState is AppUnauthenticated) {
          // Kalau dia coba-coba akses /home atau /capture, TENDANG ke /login!
          if (!isGoingToLogin && !isGoingToSplash) {
            return AppRoutes.login;
          }
        }

        // Kondisi C: Jukir PUNYA akses (Sudah login / token valid)
        if (authState is AppAuthenticated) {
          // Kalau dia nyasar balik ke halaman /login atau /splash, ARAHKAN ke /home!
          if (isGoingToLogin || isGoingToSplash) {
            return AppRoutes.home;
          }
        }

        // Tidak ada pelanggaran, silakan lewat
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

            return BlocProvider(
              create: (_) =>
                  locator<VehicleCaptureCubit>()..selectVehicle(category),
              child: const CapturePage(),
            );
          },
        ),
      ],
    );
  }
}
