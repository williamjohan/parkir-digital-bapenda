import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parkir_digital_bapenda/features/parking_transaction/persentation/cubit/sync_cubit.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        // 1. Jenderal Auth (Dipertahankan)
        BlocProvider<AppAuthCubit>(
          lazy: false,
          create: (_) => appAuthCubit..checkStatus(isFromSplash: true),
        ),

        BlocProvider<SyncCubit>(create: (_) => locator<SyncCubit>()),
      ],
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
