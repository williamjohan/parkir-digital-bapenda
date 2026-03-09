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
    // A. Tarik Sang Jenderal dari GetIt (Service Locator)
    final appAuthCubit = locator<AppAuthCubit>();

    // B. Bungkus aplikasi dengan BlocProvider Global
    return BlocProvider(
      // Menggunakan cascade operator (..) untuk langsung menyuruh Jenderal
      // mengecek isi brankas detik pertama kali aplikasi dibuka!
      create: (_) => appAuthCubit..checkStatus(),

      child: MaterialApp.router(
        title: 'Parkir Digital Bapenda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Kita sinkronkan dengan Design System token yang sudah kita buat
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        // C. Masukkan Sang Jenderal ke dalam Router agar dia bisa menjadi Satpam Rute!
        routerConfig: AppRouter.getRouter(appAuthCubit),
      ),
    );
  }
}
