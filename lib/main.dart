import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';

void main() async {
  // 1. Setup Wajib Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load Environment Variables (WAJIB SEBELUM DI)
  // Agar waktu Dio dirakit, Base URL dari .env sudah tersedia di memori
  await dotenv.load(fileName: ".env");

  // 3. Inisialisasi Dependency Injection (Membangun Brankas, Dio, Cubit, dll)
  configureDependencies();

  // 4. Jalankan App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appAuthCubit = locator<AppAuthCubit>();

    return BlocProvider(
      // [TAMBAHAN WAJIB SANG ARSITEK]
      // Matikan sifat malas! Paksa Jenderal langsung bekerja detik itu juga.
      lazy: false,

      create: (_) => appAuthCubit..checkStatus(isFromSplash: true),
      child: MaterialApp.router(
        title: 'Parkir Digital Bapenda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        routerConfig: AppRouter.getRouter(appAuthCubit),
      ),
    );
  }
}
