import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_page_transitions_builder.dart';
import 'package:parkir_digital_bapenda/core/utils/bapenda_https_overrides.dart';
import 'core/di/injection.dart';
import 'core/network/network_cubit.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import 'features/printer/presentation/cubit/printer_cubit.dart';
import 'features/update/presentation/cubit/check_update_cubit.dart';
import 'features/update/presentation/cubit/check_update_state.dart';
import 'features/update/presentation/widgets/force_update_overlay_card.dart';
import 'features/update/presentation/widgets/force_update_playstore_card.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      // 1. MUTLAK: Binding dipanggil DI DALAM zona yang sama dengan runApp
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = BapendaHttpOverrides();

      // 2. Pasang global error handler PALING AWAL, sebelum langkah bootstrap
      //    lain yang bisa gagal (dotenv/date-formatting/Firebase). Kalau dipasang
      //    belakangan dan salah satu langkah itu throw, handler ini tidak pernah
      //    aktif dan crash setelahnya tidak akan ke-report ke Crashlytics.
      FlutterError.onError = (errorDetails) {
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        }
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
        return true;
      };

      // 3. DEFENSIVE INITIALIZATION (dotenv, date formatting, Firebase)
      try {
        final String envFileName = switch (appFlavor) {
          'demo' => '.env.demo',
          'jukir' => '.env.jukir',
          _ => '.env',
        };

        await dotenv.load(fileName: envFileName);
        await initializeDateFormatting('id_ID', null);
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e, stackTrace) {
        debugPrint("⚠️ BOOTSTRAP DEGRADED (Non-Fatal): $e");
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
        }
      }

      // 4. Dependency Injection — WAJIB di-await, jangan sampai runApp()
      //    jalan sebelum semua registrasi GetIt selesai.
      try {
        await configureDependencies();
      } catch (e, stackTrace) {
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: true);
        }
        // Jangan biarkan app hang tanpa UI di splash screen native.
        // Tampilkan fallback screen supaya user tahu harus restart app.
        runApp(const _BootstrapFailedApp());
        return;
      }

      // 5. RUN APP DI DALAM ZONA YANG SAMA DENGAN BINDINGS
      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint("❌ UNCAUGHT ISOLATE EXCEPTION: $error");
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      }
    },
  );
}

/// Fallback screen jika Dependency Injection gagal total saat bootstrap.
/// Mencegah aplikasi "diam" tanpa UI di splash screen native selamanya.
class _BootstrapFailedApp extends StatelessWidget {
  const _BootstrapFailedApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                SizedBox(height: 16),
                Text(
                  'Gagal memuat aplikasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Silakan tutup dan buka kembali aplikasi. Jika masalah berlanjut, hubungi admin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appAuthCubit = locator<AppAuthCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppAuthCubit>(
          lazy: false,
          create: (_) => appAuthCubit..checkStatus(isFromSplash: true),
        ),
        BlocProvider<NetworkCubit>(create: (_) => locator<NetworkCubit>()),

        BlocProvider<CheckUpdateCubit>(
          lazy: false,
          create: (_) => locator<CheckUpdateCubit>()..checkNow(),
        ),

        BlocProvider<PrinterCubit>(create: (_) => locator<PrinterCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Parkir Digital Bapenda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
          useMaterial3: true,
          fontFamily: 'Poppins',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: PbSlidePageTransitionsBuilder(),
              TargetPlatform.iOS: PbSlidePageTransitionsBuilder(),
            },
          ),
        ),
        routerConfig: AppRouter.getRouter(appAuthCubit),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: SafeArea(
              child: Stack(
                children: [
                  // 1. Aplikasi Utama (GoRouter Navigation)
                  child ?? const SizedBox.shrink(),

                  // 2. Banner No Internet
                  BlocBuilder<NetworkCubit, NetworkState>(
                    builder: (context, state) {
                      if (state is NetworkDisconnected) {
                        return const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: GlobalNoInternetBanner(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // 3. FORCE UPDATE OVERLAY (Mengunci Total Layar)
                  BlocBuilder<CheckUpdateCubit, CheckUpdateState>(
                    builder: (context, state) {
                      if (state is CheckUpdateAvailable &&
                          state.update.isForceUpdate) {
                        return Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.85),
                            alignment: Alignment.center,
                            child: appFlavor == 'playstore'
                                ? ForceUpdatePlaystoreCard(update: state.update)
                                : ForceUpdateOverlayCard(update: state.update),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GlobalNoInternetBanner extends StatelessWidget {
  const GlobalNoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red.shade600,
      elevation: 4,
      child: const SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Koneksi internet terputus',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
