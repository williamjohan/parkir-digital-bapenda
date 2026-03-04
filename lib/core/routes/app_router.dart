// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';

// Import UI dan Cubit baru kita
import '../../features/vehicle_capture/domain/entities/vehicle_category.dart';
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/home_page.dart';

import '../di/injection.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
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

      // Rute Home Sungguhan
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),

      // Rute Capture dengan path parameter /:category
      GoRoute(
        path: '${AppRoutes.capture}/:category',
        builder: (context, state) {
          // 1. Tangkap parameter dari URL
          final categoryString = state.pathParameters['category'];

          // 2. Ubah string menjadi Enum
          final category = categoryString == 'mobil'
              ? VehicleCategory.mobil
              : VehicleCategory.motor;

          // 3. Inject Cubit dan langsung panggil selectVehicle sesuai pilihan jukir
          return BlocProvider(
            create: (_) =>
                locator<VehicleCaptureCubit>()..selectVehicle(category),
            child: Scaffold(
              appBar: AppBar(title: Text('Kamera: ${category.name}')),
              body: Center(
                child: Text('Layar Kamera $categoryString Segera Hadir!'),
              ),
            ),
          );
        },
      ),
    ],
  );
}
