import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';

void main() async {
  // 1. Setup Wajib Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Dependency Injection (SANGAT PENTING)
  configureDependencies();

  // 3. Load Environment Variables
  await dotenv.load(fileName: ".env");

  // 4. Jalankan App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Gunakan .router untuk go_router
      title: 'Parkir Digital Bapenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Kita sinkronkan dengan Design System token yang sudah kita buat
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      routerConfig: AppRouter.router,
    );
  }
}
