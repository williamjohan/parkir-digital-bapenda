// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

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

import '../../features/absensi/check_list_absensi/data/datasources/absensi_remote_datasource.dart'
    as _i606;
import '../../features/absensi/check_list_absensi/data/repositories/absensi_repository_impl.dart'
    as _i482;
import '../../features/absensi/check_list_absensi/domain/repositories/i_absensi_repository.dart'
    as _i263;
import '../../features/absensi/check_list_absensi/domain/usecases/absensi_usecase.dart'
    as _i708;
import '../../features/absensi/check_list_absensi/presentation/cubit/absensi_cubit.dart'
    as _i875;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i52;
import '../../features/auth/domain/usecases/check_device_uuid_usecase.dart'
    as _i127;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/cubit/app_auth/app_auth_cubit.dart'
    as _i808;
import '../../features/auth/presentation/cubit/login/login_cubit.dart' as _i264;
import '../../features/daftar_nop/data/datasources/daftar_nop_datasource.dart'
    as _i17;
import '../../features/daftar_nop/data/repositories/daftar_nop_repository_impl.dart'
    as _i66;
import '../../features/daftar_nop/domain/repositories/daftar_nop_repository.dart'
    as _i849;
import '../../features/daftar_nop/domain/usecases/daftar_nop_datasource.dart'
    as _i819;
import '../../features/daftar_nop/presentation/cubit/daftar_nop_cubit.dart'
    as _i915;
import '../../features/dashboard_op/dashboard_main/data/datasources/dashboard_op_datasource.dart'
    as _i905;
import '../../features/dashboard_op/dashboard_main/data/repositories/dashboard_op_repository_impl.dart'
    as _i606;
import '../../features/dashboard_op/dashboard_main/domain/repositories/dashboard_op_repository.dart'
    as _i23;
import '../../features/dashboard_op/dashboard_main/domain/usecases/dashboard_op_usecase.dart'
    as _i644;
import '../../features/dashboard_op/dashboard_main/presentation/cubit/dashboard_op_cubit.dart'
    as _i789;
import '../../features/dashboard_op/data_jukir/data/datasources/data_jukir_datasource.dart'
    as _i920;
import '../../features/dashboard_op/data_jukir/data/repositories/data_jukir_repository_impl.dart'
    as _i844;
import '../../features/dashboard_op/data_jukir/domain/repositories/data_jukir_repository.dart'
    as _i565;
import '../../features/dashboard_op/data_jukir/domain/usecases/data_jukir_usecase.dart'
    as _i835;
import '../../features/dashboard_op/data_jukir/presentation/cubit/data_jukir_cubit.dart'
    as _i402;
import '../../features/dashboard_op/detail_realisasi_op/data/datasources/detail_realisasi_op_datasources.dart'
    as _i676;
import '../../features/dashboard_op/detail_realisasi_op/data/repositories/detail_realisasi_op_impl.dart'
    as _i886;
import '../../features/dashboard_op/detail_realisasi_op/domain/repositories/detail_realisasi_op_repository.dart'
    as _i416;
import '../../features/dashboard_op/detail_realisasi_op/domain/usecases/get_detail_realisasi_op_usecase.dart'
    as _i709;
import '../../features/dashboard_op/detail_realisasi_op/presentation/cubit/detail_realisasi_op_cubit.dart'
    as _i468;
import '../../features/home/data/datasources/dashboard_summary_remote_datasource.dart'
    as _i535;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/i_home_repository.dart'
    as _i274;
import '../../features/home/domain/usecases/home_usecase.dart' as _i207;
import '../../features/home/presentation/cubit/home/home_cubit.dart' as _i273;
import '../../features/home/presentation/cubit/search_op/search_op_cubit.dart'
    as _i655;
import '../../features/init/data/repositories/device_check_repository_impl.dart'
    as _i834;
import '../../features/init/domain/repositories/i_device_check_repository.dart'
    as _i515;
import '../../features/init/domain/usecases/check_device_readiness_usecase.dart'
    as _i232;
import '../../features/init/presentation/cubit/init_cubit.dart' as _i674;
import '../../features/jadwal/data/datasources/jadwal_remote_datasource.dart'
    as _i595;
import '../../features/jadwal/data/repositories/jadwal_repository_impl.dart'
    as _i1061;
import '../../features/jadwal/domain/repositories/i_jadwal_repositories.dart'
    as _i394;
import '../../features/jadwal/domain/usecases/jadwal_usecase.dart' as _i853;
import '../../features/jadwal/presentation/cubit/jadwal_cubit.dart' as _i367;
import '../../features/payment/data/datasources/qris_signalr_datasource.dart'
    as _i57;
import '../../features/payment/data/repositories/payment_repository_impl.dart'
    as _i265;
import '../../features/payment/domain/repositories/i_payment_repository.dart'
    as _i1004;
import '../../features/payment/domain/usecases/payment_usecase.dart' as _i808;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
import '../../features/pendapatan_digital/presentation/cubit/pendapatan_digital_cubit.dart'
    as _i376;
import '../../features/pengawasan/data/datasources/pengawasan_datasource.dart'
    as _i926;
import '../../features/pengawasan/data/repositories/pengawasan_repository_impl.dart'
    as _i365;
import '../../features/pengawasan/domain/repositories/i_pengawasan_repository.dart'
    as _i165;
import '../../features/pengawasan/domain/usecases/pengawasan_usecase.dart'
    as _i437;
import '../../features/pengawasan/presentation/cubit/pengawasan_cubit.dart'
    as _i527;
import '../../features/printer/presentation/cubit/printer_cubit.dart' as _i377;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i847;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/i_profile_repository.dart'
    as _i879;
import '../../features/profile/domain/usecases/profile_usecase.dart' as _i996;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/realisasi/data/datasources/realisasi_remote_datasource.dart'
    as _i135;
import '../../features/realisasi/data/repositories/realisasi_repository_impl.dart'
    as _i407;
import '../../features/realisasi/domain/repositories/realisasi_repository.dart'
    as _i534;
import '../../features/realisasi/domain/usecases/get_realisasi_seluruh_op.dart'
    as _i425;
import '../../features/realisasi/presentation/cubit/realisasi_cubit.dart'
    as _i1069;
import '../../features/transaction/data/datasources/qris_remote_data_source.dart'
    as _i502;
import '../../features/transaction/data/repositories/data_jukir_repository_impl.dart'
    as _i527;
import '../../features/transaction/data/repositories/qris_repository_impl.dart'
    as _i718;
import '../../features/transaction/domain/repositories/data_jukir_repository.dart'
    as _i717;
import '../../features/transaction/domain/repositories/i_qris_repository.dart'
    as _i215;
import '../../features/transaction/domain/usecases/get_data_jukir_usecase.dart'
    as _i254;
import '../../features/transaction/domain/usecases/qris_usecase.dart' as _i718;
import '../../features/transaction/presentation/cubit/transaction_cubit.dart'
    as _i616;
import '../../features/transaction_history/data/datasources/transaction_history_remote_datasource.dart'
    as _i896;
import '../../features/transaction_history/data/repositories/transaction_history_repository_impl.dart'
    as _i19;
import '../../features/transaction_history/domain/repositories/i_transaction_history_repository.dart'
    as _i502;
import '../../features/transaction_history/domain/usecases/get_sof_usecase.dart'
    as _i259;
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
import '../network/connectivity_check_interceptor.dart' as _i344;
import '../network/dio_auth_interceptor.dart' as _i817;
import '../network/network_cubit.dart' as _i11;
import '../services/audio/i_audio_notification_service.dart' as _i827;
import '../services/image/i_image_service.dart' as _i37;
import '../services/image/image_service_impl.dart' as _i81;
import '../services/location/app_location_services_impl.dart' as _i35;
import '../services/location/i_app_location_service.dart' as _i988;
import '../services/permission/i_permission_service.dart' as _i164;
import '../services/permission/permission_service_impl.dart' as _i1018;
import '../services/printer/bluetooth_printer_service_impl.dart' as _i291;
import '../services/printer/i_printer_service.dart' as _i1003;
import '../storage/database_helper_2.dart' as _i654;
import '../storage/i_secure_storage_manager.dart' as _i1015;
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
  gh.lazySingleton<_i827.IAudioNotificationService>(
    () => registerModule.audioNotificationService,
  );
  gh.lazySingleton<_i654.DatabaseHelper2>(() => _i654.DatabaseHelper2());
  gh.lazySingleton<_i57.QrisSignalRDatasource>(
    () => _i57.QrisSignalRDatasource(),
  );
  gh.factory<_i655.SearchOpCubit>(
    () => _i655.SearchOpCubit(gh<_i654.DatabaseHelper2>()),
  );
  gh.lazySingleton<_i515.IDeviceCheckRepository>(
    () => _i834.DeviceCheckRepositoryImpl(),
  );
  gh.lazySingleton<_i232.CheckDeviceReadinessUseCase>(
    () => _i232.CheckDeviceReadinessUseCase(gh<_i515.IDeviceCheckRepository>()),
  );
  gh.lazySingleton<_i37.IImageService>(() => _i81.ImageServiceImpl());
  gh.lazySingleton<_i1003.IPrinterService>(
    () => _i291.BluetoothPrinterServiceImpl(),
  );
  gh.lazySingleton<_i1015.ISecureStorageManager>(
    () => _i1042.SecureStorageManagerImpl(),
  );
  gh.lazySingleton<_i164.IPermissionService>(
    () => _i1018.PermissionServiceImpl(),
  );
  gh.lazySingleton<_i344.ConnectivityCheckInterceptor>(
    () => _i344.ConnectivityCheckInterceptor(gh<_i895.Connectivity>()),
  );
  gh.lazySingleton<_i11.NetworkCubit>(
    () => _i11.NetworkCubit(gh<_i895.Connectivity>()),
  );
  gh.lazySingleton<_i817.DioAuthInterceptor>(
    () => _i817.DioAuthInterceptor(gh<_i1015.ISecureStorageManager>()),
  );
  gh.factory<_i674.InitCubit>(
    () => _i674.InitCubit(
      checkDeviceReadinessUseCase: gh<_i232.CheckDeviceReadinessUseCase>(),
      secureStorageManager: gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i1004.IPaymentRepository>(
    () => _i265.PaymentRepositoryImpl(
      gh<_i57.QrisSignalRDatasource>(),
      gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i377.PrinterCubit>(
    () => _i377.PrinterCubit(
      gh<_i1003.IPrinterService>(),
      gh<_i1015.ISecureStorageManager>(),
      gh<_i164.IPermissionService>(),
    ),
  );
  gh.lazySingleton<_i988.IAppLocationService>(
    () => _i35.AppLocationServiceImpl(gh<_i1015.ISecureStorageManager>()),
  );
  gh.factory<_i808.PaymentUseCase>(
    () => _i808.PaymentUseCase(gh<_i1004.IPaymentRepository>()),
  );
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.provideDio(gh<_i817.DioAuthInterceptor>()),
  );
  gh.lazySingleton<_i905.DashboardOpDatasource>(
    () => _i905.DashboardOpDatasourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i595.IJadwalRemoteDataSource>(
    () => _i595.JadwalRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i135.RealisasiRemoteDataSource>(
    () => _i135.RealisasiRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i107.IAuthRemoteDataSource>(
    () => _i107.AuthRemoteDataSourceImpl(
      gh<_i361.Dio>(),
      gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i896.ITransactionHistoryRemoteDataSource>(
    () => _i896.TransactionHistoryRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i17.DaftarNopDatasource>(
    () => _i17.DaftarNopDatasourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i849.DaftarNopRepository>(
    () => _i66.DaftarNopRepositoryImpl(gh<_i17.DaftarNopDatasource>()),
  );
  gh.lazySingleton<_i502.IQrisRemoteDataSource>(
    () => _i502.QrisRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i535.ISummaryRemoteDataSource>(
    () => _i535.SummaryRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i1051.IUpdateRemoteDataSource>(
    () => _i1051.UpdateRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i920.DataJukirDatasource>(
    () => _i920.DataJukirDatasourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i394.IJadwalRepository>(
    () => _i1061.JadwalRepositoryImpl(gh<_i595.IJadwalRemoteDataSource>()),
  );
  gh.lazySingleton<_i819.GetDaftarNopUsecase>(
    () => _i819.GetDaftarNopUsecase(gh<_i849.DaftarNopRepository>()),
  );
  gh.lazySingleton<_i606.IAbsensiRemoteDataSource>(
    () => _i606.AbsensiRemoteDataSourceImpl(
      gh<_i361.Dio>(),
      gh<_i37.IImageService>(),
    ),
  );
  gh.lazySingleton<_i847.IProfileRemoteDataSource>(
    () => _i847.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i926.PengawasanDatasource>(
    () => _i926.PengawasanDatasourceImpl(
      gh<_i361.Dio>(),
      gh<_i37.IImageService>(),
    ),
  );
  gh.lazySingleton<_i676.DetailRealisasiOpRemoteDataSource>(
    () => _i676.DetailRealisasiOpRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i565.DataJukirRepository>(
    () => _i844.DataJukirRepositoryImpl(gh<_i920.DataJukirDatasource>()),
  );
  gh.lazySingleton<_i534.RealisasiRepository>(
    () => _i407.RealisasiRepositoryImpl(gh<_i135.RealisasiRemoteDataSource>()),
  );
  gh.lazySingleton<_i280.IUpdateRepository>(
    () => _i121.UpdateRepositoryImpl(gh<_i1051.IUpdateRemoteDataSource>()),
  );
  gh.lazySingleton<_i589.IAuthRepository>(
    () => _i153.AuthRepositoryImpl(
      gh<_i107.IAuthRemoteDataSource>(),
      gh<_i1015.ISecureStorageManager>(),
      gh<_i654.DatabaseHelper2>(),
    ),
  );
  gh.lazySingleton<_i416.DetailRealisasiOpRepository>(
    () => _i886.DetailRealisasiOpRepositoryImpl(
      gh<_i676.DetailRealisasiOpRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i274.IHomeRepository>(
    () => _i76.HomeRepositoryImpl(gh<_i535.ISummaryRemoteDataSource>()),
  );
  gh.factory<_i506.CheckUpdateUseCase>(
    () => _i506.CheckUpdateUseCase(gh<_i280.IUpdateRepository>()),
  );
  gh.lazySingleton<_i717.DataJukirRepository>(
    () => _i527.DataJukirRepositoryImpl(gh<_i920.DataJukirDatasource>()),
  );
  gh.lazySingleton<_i879.IProfileRepository>(
    () => _i334.ProfileRepositoryImpl(
      gh<_i847.IProfileRemoteDataSource>(),
      gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i709.GetDetailRealisasiOpUseCase>(
    () => _i709.GetDetailRealisasiOpUseCase(
      gh<_i416.DetailRealisasiOpRepository>(),
    ),
  );
  gh.lazySingleton<_i23.DashboardOpRepository>(
    () => _i606.DashboardOpRepositoryImpl(gh<_i905.DashboardOpDatasource>()),
  );
  gh.lazySingleton<_i254.GetDataJukirUseCase>(
    () => _i254.GetDataJukirUseCase(gh<_i717.DataJukirRepository>()),
  );
  gh.lazySingleton<_i165.PengawasanRepository>(
    () => _i365.PengawasanRepositoryImpl(gh<_i926.PengawasanDatasource>()),
  );
  gh.factory<_i1020.CheckUpdateCubit>(
    () => _i1020.CheckUpdateCubit(gh<_i506.CheckUpdateUseCase>()),
  );
  gh.lazySingleton<_i52.CheckAuthStatusUseCase>(
    () => _i52.CheckAuthStatusUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i127.CheckDeviceUuidUseCase>(
    () => _i127.CheckDeviceUuidUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i188.LoginUseCase>(
    () => _i188.LoginUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i48.LogoutUseCase>(
    () => _i48.LogoutUseCase(gh<_i589.IAuthRepository>()),
  );
  gh.lazySingleton<_i835.GetDataJukirUseCase>(
    () => _i835.GetDataJukirUseCase(gh<_i565.DataJukirRepository>()),
  );
  gh.lazySingleton<_i996.ProfileUseCase>(
    () => _i996.ProfileUseCase(gh<_i879.IProfileRepository>()),
  );
  gh.lazySingleton<_i853.JadwalUseCase>(
    () => _i853.JadwalUseCase(gh<_i394.IJadwalRepository>()),
  );
  gh.lazySingleton<_i502.ITransactionHistoryRepository>(
    () => _i19.TransactionHistoryRepositoryImpl(
      gh<_i896.ITransactionHistoryRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i263.IAbsensiRepository>(
    () => _i482.AbsensiRepositoryImpl(
      remoteDataSource: gh<_i606.IAbsensiRemoteDataSource>(),
    ),
  );
  gh.factory<_i468.DetailRealisasiOpCubit>(
    () => _i468.DetailRealisasiOpCubit(gh<_i709.GetDetailRealisasiOpUseCase>()),
  );
  gh.lazySingleton<_i215.IQrisRepository>(
    () => _i718.QrisRepositoryImpl(
      gh<_i502.IQrisRemoteDataSource>(),
      gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.factory<_i425.GetRealisasiSeluruhOpUseCase>(
    () => _i425.GetRealisasiSeluruhOpUseCase(gh<_i534.RealisasiRepository>()),
  );
  gh.factory<_i367.JadwalCubit>(
    () => _i367.JadwalCubit(gh<_i853.JadwalUseCase>()),
  );
  gh.factory<_i915.DaftarNopCubit>(
    () => _i915.DaftarNopCubit(
      gh<_i819.GetDaftarNopUsecase>(),
      gh<_i654.DatabaseHelper2>(),
    ),
  );
  gh.lazySingleton<_i644.GetSummaryDashboardOpUsecase>(
    () => _i644.GetSummaryDashboardOpUsecase(gh<_i23.DashboardOpRepository>()),
  );
  gh.factory<_i36.ProfileCubit>(
    () => _i36.ProfileCubit(gh<_i996.ProfileUseCase>()),
  );
  gh.factory<_i402.DataJukirCubit>(
    () => _i402.DataJukirCubit(gh<_i254.GetDataJukirUseCase>()),
  );
  gh.lazySingleton<_i259.GetSofBreakdownUseCase>(
    () =>
        _i259.GetSofBreakdownUseCase(gh<_i502.ITransactionHistoryRepository>()),
  );
  gh.lazySingleton<_i732.GetTransactionHistoryUseCase>(
    () => _i732.GetTransactionHistoryUseCase(
      gh<_i502.ITransactionHistoryRepository>(),
    ),
  );
  gh.lazySingleton<_i437.AddPengawasanUsecase>(
    () => _i437.AddPengawasanUsecase(gh<_i165.PengawasanRepository>()),
  );
  gh.lazySingleton<_i437.GetLaporanPengawasanUsecase>(
    () => _i437.GetLaporanPengawasanUsecase(gh<_i165.PengawasanRepository>()),
  );
  gh.factory<_i789.DashboardOpCubit>(
    () => _i789.DashboardOpCubit(gh<_i644.GetSummaryDashboardOpUsecase>()),
  );
  gh.lazySingleton<_i718.QrisUsecase>(
    () => _i718.QrisUsecase(gh<_i215.IQrisRepository>()),
  );
  gh.factory<_i1069.RealisasiCubit>(
    () => _i1069.RealisasiCubit(gh<_i425.GetRealisasiSeluruhOpUseCase>()),
  );
  gh.factory<_i753.TransactionHistoryCubit>(
    () => _i753.TransactionHistoryCubit(
      gh<_i732.GetTransactionHistoryUseCase>(),
      gh<_i259.GetSofBreakdownUseCase>(),
      gh<_i1015.ISecureStorageManager>(),
    ),
  );
  gh.lazySingleton<_i708.AbsensiUsecase>(
    () => _i708.AbsensiUsecase(gh<_i263.IAbsensiRepository>()),
  );
  gh.lazySingleton<_i808.AppAuthCubit>(
    () => _i808.AppAuthCubit(
      gh<_i52.CheckAuthStatusUseCase>(),
      gh<_i48.LogoutUseCase>(),
      gh<_i996.ProfileUseCase>(),
      gh<_i127.CheckDeviceUuidUseCase>(),
    ),
  );
  gh.factory<_i527.PengawasanCubit>(
    () => _i527.PengawasanCubit(
      gh<_i437.AddPengawasanUsecase>(),
      gh<_i437.GetLaporanPengawasanUsecase>(),
      gh<_i164.IPermissionService>(),
      gh<_i988.IAppLocationService>(),
    ),
  );
  gh.factory<_i513.PaymentCubit>(
    () =>
        _i513.PaymentCubit(gh<_i718.QrisUsecase>(), gh<_i808.PaymentUseCase>()),
  );
  gh.factory<_i875.AbsensiCubit>(
    () => _i875.AbsensiCubit(
      gh<_i708.AbsensiUsecase>(),
      gh<_i164.IPermissionService>(),
      gh<_i988.IAppLocationService>(),
    ),
  );
  gh.lazySingleton<_i207.HomeUsecase>(
    () => _i207.HomeUsecase(
      gh<_i274.IHomeRepository>(),
      gh<_i502.ITransactionHistoryRepository>(),
    ),
  );
  gh.factory<_i376.PendapatanDigitalCubit>(
    () => _i376.PendapatanDigitalCubit(gh<_i207.HomeUsecase>()),
  );
  gh.factory<_i616.TransactionCubit>(
    () => _i616.TransactionCubit(gh<_i718.QrisUsecase>()),
  );
  gh.factory<_i264.LoginCubit>(
    () => _i264.LoginCubit(gh<_i188.LoginUseCase>(), gh<_i808.AppAuthCubit>()),
  );
  gh.factory<_i273.HomeCubit>(
    () => _i273.HomeCubit(
      gh<_i207.HomeUsecase>(),
      gh<_i1015.ISecureStorageManager>(),
      gh<_i718.QrisUsecase>(),
      gh<_i654.DatabaseHelper2>(),
      gh<_i996.ProfileUseCase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
