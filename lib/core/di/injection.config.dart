// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/datasources/auth_remote_data_source_dummy.dart'
    as _i151;
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
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/i_home_repository.dart'
    as _i274;
import '../../features/home/domain/usecases/get_daily_vehicle_count_usecase.dart'
    as _i473;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/init/data/repositories/device_check_repository_impl.dart'
    as _i834;
import '../../features/init/domain/repositories/i_device_check_repository.dart'
    as _i515;
import '../../features/init/domain/usecases/check_device_readiness_usecase.dart'
    as _i232;
import '../../features/init/presentation/cubit/init_cubit.dart' as _i674;
import '../../features/payment/data/datasources/payment_remote_datasource.dart'
    as _i247;
import '../../features/payment/data/repositories/payment_repository_impl.dart'
    as _i265;
import '../../features/payment/domain/repositories/i_payment_repository.dart'
    as _i1004;
import '../../features/payment/domain/usecases/confirm_payment_usecase.dart'
    as _i393;
import '../../features/payment/domain/usecases/generate_qris_usecase.dart'
    as _i831;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
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
  gh.lazySingleton<_i247.IPaymentRemoteDataSource>(
    () => _i247.PaymentRemoteDataSourceImpl(),
  );
  gh.lazySingleton<_i515.IDeviceCheckRepository>(
    () => _i834.DeviceCheckRepositoryImpl(),
  );
  gh.lazySingleton<_i232.CheckDeviceReadinessUseCase>(
    () => _i232.CheckDeviceReadinessUseCase(gh<_i515.IDeviceCheckRepository>()),
  );
  gh.lazySingleton<_i437.IOcrLocalDataSource>(
    () => _i437.OcrLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i274.IHomeRepository>(() => _i76.HomeRepositoryImpl());
  gh.lazySingleton<_i107.IAuthRemoteDataSource>(
    () => _i151.AuthRemoteDataSourceDummyImpl(),
  );
  gh.factory<_i674.InitCubit>(
    () => _i674.InitCubit(
      checkDeviceReadinessUseCase: gh<_i232.CheckDeviceReadinessUseCase>(),
    ),
  );
  gh.lazySingleton<_i1042.ISecureStorageManager>(
    () => _i1042.SecureStorageManagerImpl(),
  );
  gh.lazySingleton<_i734.IOcrRepository>(
    () => _i419.OcrRepositoryImpl(gh<_i437.IOcrLocalDataSource>()),
  );
  gh.lazySingleton<_i342.ExtractLicensePlateUseCase>(
    () => _i342.ExtractLicensePlateUseCase(gh<_i734.IOcrRepository>()),
  );
  gh.lazySingleton<_i817.DioAuthInterceptor>(
    () => _i817.DioAuthInterceptor(gh<_i1042.ISecureStorageManager>()),
  );
  gh.lazySingleton<_i473.GetDailyVehicleCountUseCase>(
    () => _i473.GetDailyVehicleCountUseCase(gh<_i274.IHomeRepository>()),
  );
  gh.lazySingleton<_i589.IAuthRepository>(
    () => _i153.AuthRepositoryImpl(
      gh<_i107.IAuthRemoteDataSource>(),
      gh<_i1042.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i731.VehicleCaptureCubit>(
    () => _i731.VehicleCaptureCubit(gh<_i342.ExtractLicensePlateUseCase>()),
  );
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.provideDio(gh<_i817.DioAuthInterceptor>()),
  );
  gh.lazySingleton<_i1004.IPaymentRepository>(
    () => _i265.PaymentRepositoryImpl(
      gh<_i1042.ISecureStorageManager>(),
      gh<_i247.IPaymentRemoteDataSource>(),
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
  gh.factory<_i264.LoginCubit>(
    () => _i264.LoginCubit(gh<_i188.LoginUseCase>()),
  );
  gh.factory<_i9.HomeCubit>(
    () => _i9.HomeCubit(gh<_i473.GetDailyVehicleCountUseCase>()),
  );
  gh.lazySingleton<_i393.ConfirmPaymentUseCase>(
    () => _i393.ConfirmPaymentUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i831.GenerateQrisUseCase>(
    () => _i831.GenerateQrisUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i808.AppAuthCubit>(
    () => _i808.AppAuthCubit(
      gh<_i52.CheckAuthStatusUseCase>(),
      gh<_i48.LogoutUseCase>(),
    ),
  );
  gh.factory<_i513.PaymentCubit>(
    () => _i513.PaymentCubit(
      gh<_i831.GenerateQrisUseCase>(),
      gh<_i393.ConfirmPaymentUseCase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
