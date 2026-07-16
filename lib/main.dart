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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = BapendaHttpOverrides();
  final String envFileName = switch (appFlavor) {
    'demo' => '.env.demo',
    'jukir' => '.env.jukir',
    _ => '.env',
  };
  await dotenv.load(fileName: envFileName);
  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  configureDependencies();
  runApp(const MyApp());
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
                  // Karena berada di Stack paling atas, dia menutupi seluruh aplikasi
                  // Tanpa perlu showDialog, tanpa Navigator, 100% anti-crash!
                  BlocBuilder<CheckUpdateCubit, CheckUpdateState>(
                    builder: (context, state) {
                      if (state is CheckUpdateAvailable &&
                          state.update.isForceUpdate) {
                        return Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(
                              alpha: 0.85,
                            ), // Backdrop gelap
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
