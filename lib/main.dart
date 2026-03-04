import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'persentation/features/bayar/bayar_screen.dart';

void main() async {
  // 1. Setup Wajib
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load Environment Variables
  await dotenv.load(fileName: ".env");

  // 3. Jalankan App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulasi Parkir Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Warna utama sesuai tombol Pay Now (Biru)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5566FF)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      // LANGSUNG KE TUJUAN UTAMA
      home: const BayarScreen(),
    );
  }
}
