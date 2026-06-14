// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i52;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart'
    as _i808;
import '../../features/auth/presentation/cubit/login/login_cubit.dart' as _i264;
import '../../features/home/data/datasources/i_summary_remote_datasource.dart'
    as _i64;
import '../../features/home/data/datasources/i_tarif_remote_datasource.dart'
    as _i59;
import '../../features/home/data/datasources/summary_remote_datasource_impl.dart'
    as _i172;
import '../../features/home/data/datasources/tarif_remote_datasource_impl.dart'
    as _i565;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/i_home_repository.dart'
    as _i274;
import '../../features/home/domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart'
    as _i421;
import '../../features/home/domain/usecases/get_hybrid_tarif_usecase.dart'
    as _i1057;
import '../../features/home/domain/usecases/get_recent_transaction_usecase.dart'
    as _i77;
import '../../features/home/domain/usecases/get_weekly_chart_usecase.dart'
    as _i33;
import '../../features/home/domain/usecases/sync_tarif_usecase.dart' as _i770;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/init/data/repositories/device_check_repository_impl.dart'
    as _i834;
import '../../features/init/domain/repositories/i_device_check_repository.dart'
    as _i515;
import '../../features/init/domain/usecases/check_device_readiness_usecase.dart'
    as _i232;
import '../../features/init/presentation/cubit/init_cubit.dart' as _i674;
import '../../features/parking_transaction/data/datasources/i_parking_transaction_local_datasource.dart'
    as _i92;
import '../../features/parking_transaction/data/datasources/i_parking_transaction_remote_datasource.dart'
    as _i461;
import '../../features/parking_transaction/data/datasources/parking_transaction_local_datasource_impl.dart'
    as _i462;
import '../../features/parking_transaction/data/datasources/parking_transaction_remote_datasource_impl.dart'
    as _i798;
import '../../features/parking_transaction/data/repositories/parking_transaction_repository_impl.dart'
    as _i14;
import '../../features/parking_transaction/domain/repositories/i_parking_transaction_repository.dart'
    as _i1054;
import '../../features/parking_transaction/domain/usecases/save_parking_transaction_usecase.dart'
    as _i512;
import '../../features/parking_transaction/domain/usecases/sync_parking_transactions_usecase.dart'
    as _i785;
import '../../features/parking_transaction/domain/usecases/update_parking_status_usecase.dart'
    as _i269;
import '../../features/parking_transaction/persentation/cubit/parking_transaction_cubit.dart'
    as _i877;
import '../../features/parking_transaction/persentation/cubit/sync_cubit.dart'
    as _i420;
import '../../features/payment/data/datasources/payment_remote_datasource.dart'
    as _i247;
import '../../features/payment/data/datasources/qris_signalr_datasource.dart'
    as _i57;
import '../../features/payment/data/repositories/payment_repository_impl.dart'
    as _i265;
import '../../features/payment/domain/repositories/i_payment_repository.dart'
    as _i1004;
import '../../features/payment/domain/usecases/check_payment_status_usecase.dart'
    as _i191;
import '../../features/payment/domain/usecases/generate_qris_usecase.dart'
    as _i831;
import '../../features/payment/domain/usecases/stop_monitoring_payment_usecase.dart'
    as _i907;
import '../../features/payment/domain/usecases/watch_payment_status_usecase.dart'
    as _i232;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
import '../../features/printer/presentation/cubit/printer_cubit.dart' as _i377;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i847;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/i_profile_repository.dart'
    as _i879;
import '../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i965;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/transaction/cubit/transaction_cubit.dart' as _i629;
import '../../features/transaction_history/data/datasources/transaction_history_remote_datasource.dart'
    as _i896;
import '../../features/transaction_history/data/repositories/transaction_history_repository_impl.dart'
    as _i19;
import '../../features/transaction_history/domain/repositories/i_transaction_history_repository.dart'
    as _i502;
import '../../features/transaction_history/domain/usecases/get_transaction_history_usecase.dart'
    as _i732;
import '../../features/transaction_history/presentation/cubit/transaction_history_cubit.dart'
    as _i753;
import '../../features/update/data/datasources/update_remote_datasource.dart'
    as _i1051;
import '../../features/update/data/repositories/update_repository_impl.dart'
    as _i121;
import '../../features/update/domain/repositories/i_update_repository.dart'
    as _i280;
import '../../features/update/domain/usecases/check_update_usecase.dart'
    as _i506;
import '../../features/update/presentation/cubit/check_update_cubit.dart'
    as _i1020;
import '../../features/vehicle_capture/data/datasources/ocr_local_data_source.dart'
    as _i437;
import '../../features/vehicle_capture/data/repositories/ocr_repository_impl.dart'
    as _i419;
import '../../features/vehicle_capture/domain/repositories/i_ocr_repository.dart'
    as _i734;
import '../../features/vehicle_capture/domain/usecases/extract_license_plate_usecase.dart'
    as _i342;
import '../../features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart'
    as _i731;
import '../network/dio_auth_interceptor.dart' as _i817;
import '../network/network_cubit.dart' as _i11;
import '../services/image/i_image_service.dart' as _i37;
import '../services/image/image_service_impl.dart' as _i81;
import '../services/location/app_location_services_impl.dart' as _i35;
import '../services/location/i_app_location_service.dart' as _i988;
import '../services/printer/bluetooth_printer_service_impl.dart' as _i291;
import '../services/printer/i_printer_service.dart' as _i1003;
import '../storage/secure_storage_manager.dart' as _i1042;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
  gh.lazySingleton<_i57.QrisSignalRDatasource>(
    () => _i57.QrisSignalRDatasource(),
  );
  gh.lazySingleton<_i515.IDeviceCheckRepository>(
    () => _i834.DeviceCheckRepositoryImpl(),
  );
  gh.lazySingleton<_i232.CheckDeviceReadinessUseCase>(
    () => _i232.CheckDeviceReadinessUseCase(gh<_i515.IDeviceCheckRepository>()),
  );
  gh.lazySingleton<_i37.IImageService>(() => _i81.ImageServiceImpl());
  gh.lazySingleton<_i437.IOcrLocalDataSource>(
    () => _i437.OcrLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i1003.IPrinterService>(
    () => _i291.BluetoothPrinterServiceImpl(),
  );
  gh.lazySingleton<_i1042.ISecureStorageManager>(
    () => _i1042.SecureStorageManagerImpl(),
  );
  gh.lazySingleton<_i734.IOcrRepository>(
    () => _i419.OcrRepositoryImpl(gh<_i437.IOcrLocalDataSource>()),
  );
  gh.lazySingleton<_i988.IAppLocationService>(
    () => _i35.AppLocationServiceImpl(gh<_i1042.ISecureStorageManager>()),
  );
  gh.lazySingleton<_i342.ExtractLicensePlateUseCase>(
    () => _i342.ExtractLicensePlateUseCase(gh<_i734.IOcrRepository>()),
  );
  gh.lazySingleton<_i817.DioAuthInterceptor>(
    () => _i817.DioAuthInterceptor(gh<_i1042.ISecureStorageManager>()),
  );
  gh.lazySingleton<_i11.NetworkCubit>(
    () => _i11.NetworkCubit(gh<_i895.Connectivity>()),
  );
  gh.factory<_i731.VehicleCaptureCubit>(
    () => _i731.VehicleCaptureCubit(
      gh<_i342.ExtractLicensePlateUseCase>(),
      gh<_i37.IImageService>(),
    ),
  );
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.provideDio(gh<_i817.DioAuthInterceptor>()),
  );
  gh.lazySingleton<_i59.ITarifRemoteDataSource>(
    () => _i565.TarifRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i92.IParkingTransactionLocalDataSource>(
    () => _i462.ParkingTransactionLocalDataSourceImpl(gh<_i37.IImageService>()),
  );
  gh.lazySingleton<_i896.ITransactionHistoryRemoteDataSource>(
    () => _i896.TransactionHistoryRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.factory<_i377.PrinterCubit>(
    () => _i377.PrinterCubit(
      gh<_i1003.IPrinterService>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i1051.IUpdateRemoteDataSource>(
    () => _i1051.UpdateRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i107.IAuthRemoteDataSource>(
    () => _i107.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i502.ITransactionHistoryRepository>(
    () => _i19.TransactionHistoryRepositoryImpl(
      gh<_i896.ITransactionHistoryRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i247.IPaymentRemoteDataSource>(
    () => _i247.PaymentRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.factory<_i674.InitCubit>(
    () => _i674.InitCubit(
      checkDeviceReadinessUseCase: gh<_i232.CheckDeviceReadinessUseCase>(),
      secureStorageManager: gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i847.IProfileRemoteDataSource>(
    () => _i847.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i879.IProfileRepository>(
    () => _i334.ProfileRepositoryImpl(
      gh<_i847.IProfileRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i64.ISummaryRemoteDataSource>(
    () => _i172.SummaryRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i77.GetRecentTransactionsUseCase>(
    () => _i77.GetRecentTransactionsUseCase(
      gh<_i896.ITransactionHistoryRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i732.GetTransactionHistoryUseCase>(
    () => _i732.GetTransactionHistoryUseCase(
      gh<_i502.ITransactionHistoryRepository>(),
    ),
  );
  gh.lazySingleton<_i280.IUpdateRepository>(
    () => _i121.UpdateRepositoryImpl(gh<_i1051.IUpdateRemoteDataSource>()),
  );
  gh.lazySingleton<_i589.IAuthRepository>(
    () => _i153.AuthRepositoryImpl(
      gh<_i107.IAuthRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i461.IParkingTransactionRemoteDataSource>(
    () => _i798.ParkingTransactionRemoteDataSourceImpl(
      gh<_i361.Dio>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i52.CheckAuthStatusUseCase>(
    () => _i52.CheckAuthStatusUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i188.LoginUseCase>(
    () => _i188.LoginUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i48.LogoutUseCase>(
    () => _i48.LogoutUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i506.CheckUpdateUseCase>(
    () => _i506.CheckUpdateUseCase(gh<_i280.IUpdateRepository>()),
  );
  gh.lazySingleton<_i965.GetProfileUseCase>(
    () => _i965.GetProfileUseCase(gh<_i879.IProfileRepository>()),
  );
  gh.lazySingleton<_i274.IHomeRepository>(
    () => _i76.HomeRepositoryImpl(
      gh<_i59.ITarifRemoteDataSource>(),
      gh<_i64.ISummaryRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i1004.IPaymentRepository>(
    () => _i265.PaymentRepositoryImpl(
      gh<_i247.IPaymentRemoteDataSource>(),
      gh<_i57.QrisSignalRDatasource>(),
    ),
  );
  gh.factory<_i753.TransactionHistoryCubit>(
    () => _i753.TransactionHistoryCubit(
      gh<_i732.GetTransactionHistoryUseCase>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i808.AppAuthCubit>(
    () => _i808.AppAuthCubit(
      gh<_i52.CheckAuthStatusUseCase>(),
      gh<_i48.LogoutUseCase>(),
      gh<_i965.GetProfileUseCase>(),
    ),
  );
  gh.factory<_i264.LoginCubit>(
    () => _i264.LoginCubit(gh<_i188.LoginUseCase>(), gh<_i808.AppAuthCubit>()),
  );
  gh.lazySingleton<_i421.GetHybridDashboardSummaryUseCase>(
    () => _i421.GetHybridDashboardSummaryUseCase(gh<_i274.IHomeRepository>()),
  );
  gh.lazySingleton<_i1057.GetHybridTarifUseCase>(
    () => _i1057.GetHybridTarifUseCase(gh<_i274.IHomeRepository>()),
  );
  gh.lazySingleton<_i33.GetWeeklyChartUseCase>(
    () => _i33.GetWeeklyChartUseCase(gh<_i274.IHomeRepository>()),
  );
  gh.lazySingleton<_i770.SyncTarifUseCase>(
    () => _i770.SyncTarifUseCase(gh<_i274.IHomeRepository>()),
  );
  gh.lazySingleton<_i191.CheckPaymentStatusUseCase>(
    () => _i191.CheckPaymentStatusUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i831.GenerateQrisUseCase>(
    () => _i831.GenerateQrisUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i907.StopMonitoringPaymentUseCase>(
    () => _i907.StopMonitoringPaymentUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i232.WatchPaymentStatusUseCase>(
    () => _i232.WatchPaymentStatusUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i1054.IParkingTransactionRepository>(
    () => _i14.ParkingTransactionRepositoryImpl(
      gh<_i92.IParkingTransactionLocalDataSource>(),
      gh<_i461.IParkingTransactionRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i1020.CheckUpdateCubit>(
    () => _i1020.CheckUpdateCubit(gh<_i506.CheckUpdateUseCase>()),
  );
  gh.factory<_i36.ProfileCubit>(
    () => _i36.ProfileCubit(
      gh<_i965.GetProfileUseCase>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i629.TransactionCubit>(
    () => _i629.TransactionCubit(
      gh<_i1057.GetHybridTarifUseCase>(),
      gh<_i988.IAppLocationService>(),
    ),
  );
  gh.factory<_i9.HomeCubit>(
    () => _i9.HomeCubit(
      gh<_i421.GetHybridDashboardSummaryUseCase>(),
      gh<_i77.GetRecentTransactionsUseCase>(),
      gh<_i33.GetWeeklyChartUseCase>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i512.SaveParkingTransactionUseCase>(
    () => _i512.SaveParkingTransactionUseCase(
      gh<_i1054.IParkingTransactionRepository>(),
    ),
  );
  gh.lazySingleton<_i269.UpdateParkingStatusUseCase>(
    () => _i269.UpdateParkingStatusUseCase(
      gh<_i1054.IParkingTransactionRepository>(),
    ),
  );
  gh.lazySingleton<_i785.SyncParkingTransactionsUseCase>(
    () => _i785.SyncParkingTransactionsUseCase(
      gh<_i1054.IParkingTransactionRepository>(),
      gh<_i461.IParkingTransactionRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i513.PaymentCubit>(
    () => _i513.PaymentCubit(
      gh<_i831.GenerateQrisUseCase>(),
      gh<_i232.WatchPaymentStatusUseCase>(),
      gh<_i191.CheckPaymentStatusUseCase>(),
      gh<_i907.StopMonitoringPaymentUseCase>(),
      gh<_i512.SaveParkingTransactionUseCase>(),
    ),
  );
  gh.factory<_i877.ParkingTransactionCubit>(
    () => _i877.ParkingTransactionCubit(
      gh<_i512.SaveParkingTransactionUseCase>(),
      gh<_i269.UpdateParkingStatusUseCase>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i420.SyncCubit>(
    () => _i420.SyncCubit(gh<_i785.SyncParkingTransactionsUseCase>()),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
