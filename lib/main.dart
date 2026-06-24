import 'dart:io';
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
import 'features/parking_transaction/persentation/cubit/sync_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = BapendaHttpOverrides();
  final String envFileName = appFlavor == 'demo' ? '.env.demo' : '.env.prod';
  await dotenv.load(fileName: envFileName);
  await initializeDateFormatting('id_ID', null);
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

        BlocProvider<SyncCubit>(create: (_) => locator<SyncCubit>()),
        BlocProvider<NetworkCubit>(create: (_) => locator<NetworkCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Parkir Digital Bapenda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
          useMaterial3: true,
          fontFamily: 'Poppins',
          pageTransitionsTheme: const PageTransitionsTheme(
            // [PERBAIKAN]: Wajib tambahkan deklarasi tipe Map ini secara eksplisit!
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
                  child ?? const SizedBox.shrink(),
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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Koneksi internet terputus',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
