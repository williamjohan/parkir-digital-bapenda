import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/profile/domain/usecases/profile_usecase.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../domain/usecases/check_device_uuid_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import 'app_auth_state.dart';

@lazySingleton
class AppAuthCubit extends Cubit<AppAuthState> {
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogoutUseCase _logout;
  final ProfileUseCase _profileUseCase;
  final CheckDeviceUuidUseCase _checkDeviceUuid;

  AppAuthCubit(
    this._checkAuthStatus,
    this._logout,
    this._profileUseCase,
    this._checkDeviceUuid,
  ) : super(AppAuthInitial());

  /// Dipanggil saat Splash Screen muncul ATAU setelah Login sukses
  Future<void> checkStatus({bool isFromSplash = false}) async {
    AppLogger.debug(">>> [AppAuthCubit] Mengecek status autentikasi...");

    if (isFromSplash) {
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      final hasValidToken = await _checkAuthStatus();

      AppLogger.debug(">>> [AppAuthCubit] Hasil cek token: $hasValidToken");

      if (!hasValidToken) {
        emit(AppUnauthenticated());
        return;
      }
      AppLogger.debug(">>> [AppAuthCubit] Memverifikasi UUID perangkat...");

      final isDeviceValid = await _checkDeviceUuid();

      AppLogger.debug(">>> [AppAuthCubit] Hasil cek UUID: $isDeviceValid");

      if (!isDeviceValid) {
        AppLogger.error(
          ">>> [AppAuthCubit] UUID perangkat tidak cocok dengan server. Logout paksa.",
        );

        final storage = GetIt.instance<ISecureStorageManager>();
        await storage.saveLogoutReason('DEVICE_MISMATCH');
        await storage.clearPasswordOnly();

        await _logout();

        emit(AppUnauthenticated());
        return;
      }
      AppLogger.debug(">>> [AppAuthCubit] UUID valid, sinkronisasi profil...");

      final profileResult = await _profileUseCase.getProfileInfo();

      await profileResult.fold(
        (failure) async {
          AppLogger.error(
            ">>> [AppAuthCubit] Gagal sinkronisasi profil: ${failure.message}",
          );

          final localProfile = await GetIt.instance<ISecureStorageManager>()
              .getJukirProfile();

          if (localProfile != null) {
            AppLogger.debug(">>> [AppAuthCubit] Menggunakan profil lokal.");

            emit(AppAuthenticated());
          } else {
            AppLogger.error(">>> [AppAuthCubit] Profil lokal tidak ditemukan.");

            emit(AppUnauthenticated());
          }
        },
        (userModel) async {
          AppLogger.debug(
            ">>> [AppAuthCubit] Profil berhasil disinkronkan: ${userModel.namaUser}",
          );

          emit(AppAuthenticated());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(">>> [AppAuthCubit] ERROR checkStatus", e, stackTrace);

      emit(AppUnauthenticated());
    }
  }

  /// Dipanggil jika token basi, atau Jukir klik tombol Logout
  Future<void> forceLogout() async {
    await _logout(); // Bersihkan brankas (Token & Profil)
    emit(AppUnauthenticated()); // Tendang ke halaman Login
  }
}
