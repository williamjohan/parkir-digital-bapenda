// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/persentation/cubit/home_cubit.dart' as _i178;
import '../../features/init/data/repositories/device_check_repository_impl.dart'
    as _i834;
import '../../features/init/domain/repositories/i_device_check_repository.dart'
    as _i515;
import '../../features/init/domain/usecases/check_device_readiness_usecase.dart'
    as _i232;
import '../../features/init/presentation/cubit/init_cubit.dart' as _i674;
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

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i178.HomeCubit>(() => _i178.HomeCubit());
  gh.lazySingleton<_i515.IDeviceCheckRepository>(
    () => _i834.DeviceCheckRepositoryImpl(),
  );
  gh.lazySingleton<_i232.CheckDeviceReadinessUseCase>(
    () => _i232.CheckDeviceReadinessUseCase(gh<_i515.IDeviceCheckRepository>()),
  );
  gh.lazySingleton<_i437.IOcrLocalDataSource>(
    () => _i437.OcrLocalDataSourceImpl(),
  );
  gh.factory<_i674.InitCubit>(
    () => _i674.InitCubit(
      checkDeviceReadinessUseCase: gh<_i232.CheckDeviceReadinessUseCase>(),
    ),
  );
  gh.lazySingleton<_i734.IOcrRepository>(
    () => _i419.OcrRepositoryImpl(gh<_i437.IOcrLocalDataSource>()),
  );
  gh.lazySingleton<_i342.ExtractLicensePlateUseCase>(
    () => _i342.ExtractLicensePlateUseCase(gh<_i734.IOcrRepository>()),
  );
  gh.factory<_i731.VehicleCaptureCubit>(
    () => _i731.VehicleCaptureCubit(gh<_i342.ExtractLicensePlateUseCase>()),
  );
  return getIt;
}
