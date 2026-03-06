// lib/core/routes/app_router.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/persentation/cubit/home_cubit.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../../features/vehicle_capture/domain/entities/vehicle_category.dart';
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/capture_page.dart';
import '../../features/home/persentation/pages/home_page.dart';
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

      // Rute Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => locator<HomeCubit>(), // Inject HomeCubit!
            child: const HomePage(),
          );
        },
      ),

      // Rute Capture dengan path parameter /:category
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
            child: const CapturePage(), // Gunakan CapturePage asli!
          );
        },
      ),
    ],
  );
}
