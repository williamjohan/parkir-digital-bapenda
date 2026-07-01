import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/domain/entities/dashboard_op_entity.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/cubit/dashboard_op_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/screen/dashboard_op_screen.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_rekap_jenis_pembayaran_op/presentation/detail_rekap_jenis_pembayaran_screen.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/presentation/cubit/data_jukir_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/presentation/screens/data_jukir_screen.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/pages/search_op_page.dart';
import 'package:parkir_digital_bapenda/features/pendapatan_digital/presentation/cubit/pendapatan_digital_cubit.dart';
import 'package:parkir_digital_bapenda/features/pendapatan_digital/presentation/pendapatan_digital_screen.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/screens/pengawasan_screen.dart';
import '../../features/daftar_nop/presentation/cubit/daftar_nop_cubit.dart';
import '../../features/daftar_nop/presentation/screens/daftar_nop_screen.dart';
import '../../features/dashboard_op/detail_realisasi_op/presentation/cubit/detail_realisasi_op_cubit.dart';
import '../../features/dashboard_op/detail_realisasi_op/presentation/screen/detail_realisasi_op_screen.dart';
import '../../features/home/presentation/cubit/search_op/search_op_cubit.dart';
import '../../features/jadwal/presentation/screens/jadwal_screen.dart';
import '../../features/realisasi/presentation/cubit/realisasi_cubit.dart';
import '../../features/realisasi/presentation/screens/realisasi_screen.dart';
import '../../features/transaction/presentation/page/transaction_page.dart';
import '../../features/transaction/presentation/cubit/transaction_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/cubit/transaction_history_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/pages/transaction_history_page.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../../features/auth/presentation/cubit/app_auth/app_auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/home/presentation/cubit/home/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/init/presentation/cubit/init_cubit.dart';
import '../../features/init/presentation/pages/splash_page.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/printer/presentation/cubit/printer_cubit.dart';
import '../../features/printer/presentation/screen/printer_settings_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/update/presentation/pages/update_page.dart';
import '../di/injection.dart';
import '../enums/app_enums.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static GoRouter? _router;

  static GoRouter getRouter(AppAuthCubit appAuthCubit) {
    if (_router != null) return _router!;

    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      observers: [ChuckerFlutter.navigatorObserver],
      refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),
      redirect: (context, state) {
        final authState = appAuthCubit.state;
        final path = state.uri.path;

        final isGoingToLogin = path == AppRoutes.login;
        final isGoingToSplash = path == AppRoutes.splash;

        if (authState is AppAuthInitial) return null;

        if (authState is AppUnauthenticated) {
          if (!isGoingToLogin && !isGoingToSplash) return AppRoutes.login;
        }

        if (authState is AppAuthenticated) {
          if (isGoingToLogin || isGoingToSplash) return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<InitCubit>(),
            child: const SplashPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.daftarNop,
          name: AppRoutes.daftarNop,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<DaftarNopCubit>(),
            child: const DaftarNopScreen(),
          ),
        ),
        // pengawas
        GoRoute(
          path: AppRoutes.laporanPelanggaran,
          name: AppRoutes.laporanPelanggaran,
          builder: (context, state) => const LaporanPelanggaranScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<HomeCubit>(),
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.searchObjekPajak,
          name: AppRoutes.searchObjekPajak,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            final role = extra?['role'] as RoleLoginDigitalParkir?;
            final opType = extra?['opType'] as SearchOpType?;

            if (role == null) {
              return const Scaffold(
                body: Center(child: Text('Role tidak ditemukan')),
              );
            }

            return BlocProvider(
              create: (_) => locator<SearchOpCubit>(),
              child: SearchOpPage(role: role, opType: opType),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.pendapatanDigital,
          name: AppRoutes.pendapatanDigital,
          builder: (context, state) {
            final namaUPTB = state.extra as String? ?? '';
            return BlocProvider(
              create: (context) =>
                  locator<PendapatanDigitalCubit>()..getSummary(),
              child: PendapatanDigitalScreen(namaUPTB: namaUPTB),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.dashboardObjekPajak,
          name: AppRoutes.dashboardObjekPajak,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final item = extra?['item'] as Map<String, dynamic>;
            return BlocProvider(
              create: (context) =>
                  locator<DashboardOpCubit>()
                    ..getSummaryDashboardOp(item['nop']),
              child: DashboardOpScreen(item: item),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.dataJukir,
          name: AppRoutes.dataJukir,
          builder: (context, state) {
            // final nop = state.extra as String? ?? '';

            final extra = state.extra as Map<String, dynamic>?;
            final item = extra?['item'] as Map<String, dynamic>;

            return BlocProvider(
              create: (context) =>
                  locator<DataJukirCubit>()..getDataJukir(item['nop']),
              child: DataJukirScreen(item: item),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.realisasiSeluruhOP,
          name: AppRoutes.realisasiSeluruhOP,
          builder: (context, state) {
            final namaUPTB = state.extra as String? ?? '';
            return BlocProvider(
              create: (_) => locator<RealisasiCubit>()..init(),
              child: RealisasiScreen(namaUPTB: namaUPTB),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.detailRealisasiObjekPajak,
          name: AppRoutes.detailRealisasiObjekPajak,
          builder: (context, state) {
            final nop = state.extra as String? ?? '';
            return BlocProvider(
              create: (context) => locator<DetailRealisasiOpCubit>()..init(nop),
              child: const DetailRealisasiOpPage(),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.detailRekapJenisPembayaran,
          name: AppRoutes.detailRekapJenisPembayaran,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            final data = extra?['data'] as List<SofEntity>;
            return DetailRekapJenisPembayaranScreen(data: data);
          },
        ),

        GoRoute(
          path: AppRoutes.payment,
          name: AppRoutes.payment,
          builder: (context, state) {
            final args = state.extra as PaymentPageArgs;
            return BlocProvider(
              create: (_) => locator<PaymentCubit>(),
              child: PaymentPage(args: args),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.jadwalKehadiran,
          name: AppRoutes.jadwalKehadiran,
          builder: (context, state) {
            return const JadwalScreen();

            /* // 🛠️ TODO (Fase Integrasi State Management):
            return BlocProvider(
              create: (_) => locator<JadwalCubit>(),
              child: const JadwalScreen(),
            );
            */
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profile,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<ProfileCubit>(),
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          name: AppRoutes.history,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final initialDate = extra?['initialDate'] as DateTime?;
            final isFree = extra?['isFree'] as bool? ?? false;
            final nop = extra?['nop'] as String?;
            final idDevice = extra?['idDevice'] as String?;

            return BlocProvider(
              create: (_) => locator<TransactionHistoryCubit>(),
              child: TransactionHistoryPage(
                initialDate: initialDate,
                isFree: isFree,
                nop: nop,
                idDevice: idDevice,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.transaction,
          name: AppRoutes.transaction,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            return BlocProvider(
              create: (_) => locator<TransactionCubit>(),
              child: TransactionPage(
                isFree: extra?['isFree'] ?? false,
                itemOP: extra?['itemOP'],
                isDemoMode: extra?['isDemoMode'] ?? false,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.printerSetting,
          name: AppRoutes.printerSetting,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<PrinterCubit>(),
            child: const PrinterSettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.update,
          name: AppRoutes.update,
          builder: (context, state) => const UpdatePage(),
        ),
      ],
    );

    return _router!;
  }
}
