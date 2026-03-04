// lib/core/routes/app_router.dart

import 'package:flutter/material.dart'; // Tambahkan ini untuk Scaffold dummy
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../di/injection.dart';
import 'app_routes.dart'; // Import kamus rute kita

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash, // Gunakan AppRoutes
    routes: [
      GoRoute(
        path: AppRoutes.splash, // Gunakan AppRoutes
        builder: (context, state) {
          return BlocProvider(
            create: (_) => locator<InitCubit>(),
            child: const SplashPage(),
          );
        },
      ),

      // DUMMY ROUTE: Agar navigasi sukses dites sebelum fitur Vehicle Capture dibuat
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home - Pilih Kendaraan')),
            body: const Center(child: Text('Halaman Home Berhasil Diload!')),
          );
        },
      ),
    ],
  );
}
