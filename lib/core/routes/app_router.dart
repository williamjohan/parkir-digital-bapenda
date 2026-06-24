import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/domain/entities/dashboard_op_entity.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/cubit/dashboard_op_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/screen/dashboard_op_screen.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/sub_features/detail_rekap_jenis_pembayaran_op/presentation/detail_rekap_jenis_pembayaran_screen.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/pages/search_op_page.dart';
import '../../features/home/presentation/cubit/search_op/search_op_cubit.dart';
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
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart';
import '../../features/vehicle_capture/presentation/pages/capture_page.dart';
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
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<HomeCubit>(),
            child: const HomePage(),
          ),
        ),
        // GoRoute(
        //   path: AppRoutes.searchObjekPajak,
        //   name: AppRoutes.searchObjekPajak,
        //   builder: (context, state) {
        //     final role = state.extra as RoleLoginDigitalParkir;

        //     return BlocProvider(
        //       create: (_) => locator<SearchOpCubit>(),
        //       child: SearchOpPage(role: role),
        //     );
        //   },
        // ),
        GoRoute(
          path: AppRoutes.searchObjekPajak,
          name: AppRoutes.searchObjekPajak,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            final role = extra?['role'] as RoleLoginDigitalParkir;

            final opType = extra?['opType'] as SearchOpType?;

            return BlocProvider(
              create: (_) => locator<SearchOpCubit>(),
              child: SearchOpPage(role: role, opType: opType),
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
          path: AppRoutes.detailRekapJenisPembayaran,
          name: AppRoutes.detailRekapJenisPembayaran,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            final data = extra?['data'] as List<SofEntity>;
            return DetailRekapJenisPembayaranScreen(data: data);
          },
        ),
        GoRoute(
          path: AppRoutes.capture,
          name: AppRoutes.capture,
          builder: (context, state) => BlocProvider(
            create: (_) => locator<VehicleCaptureCubit>(),
            child: const CapturePage(),
          ),
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

            return BlocProvider(
              create: (_) => locator<TransactionHistoryCubit>(),
              child: TransactionHistoryPage(
                initialDate: initialDate,
                isFree: isFree,
                nop: nop,
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
