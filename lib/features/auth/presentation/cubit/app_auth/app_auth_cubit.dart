import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/auth/domain/usecases/auth_usecase.dart';
import 'package:parkir_digital_bapenda/features/profile/domain/usecases/profile_usecase.dart';
import '../../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import 'app_auth_state.dart';

@lazySingleton
class AppAuthCubit extends Cubit<AppAuthState> {
  final ProfileUseCase _profileUseCase;
  final AuthUseCase _authUseCase;

  AppAuthCubit(this._profileUseCase, this._authUseCase)
    : super(AppAuthInitial());

  Future<void> checkStatus({bool isFromSplash = false}) async {
    AppLogger.debug(">>> [AppAuthCubit] Mengecek status autentikasi...");

    if (isFromSplash) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (isClosed) return;

    try {
      // 1. Cek apakah Token JWT masih ada/valid di lokal
      final hasValidToken = await _authUseCase.checkAuthStatus();

      if (isClosed) return;

      if (!hasValidToken) {
        emit(AppUnauthenticated());
        return;
      }

      // 2. Ambil & Sinkronisasi Profil (Agar Role Terbaru Masuk ke Storage)
      final profileResult = await _profileUseCase.getProfileInfo();

      if (isClosed) return;
      bool isOnline = false;
      bool isProfileValid = false;

      await profileResult.fold(
        (failure) async {
          AppLogger.warning(
            ">>> [AppAuthCubit] Offline/Gagal sync profil: ${failure.message}",
          );

          // Cek fallback profil lokal
          final localProfile = await GetIt.instance<ISecureStorageManager>()
              .getJukirProfile();
          if (localProfile != null) {
            isProfileValid = true;
            isOnline = false; // Tandai bahwa kita sedang mode OFFLINE
          }
        },
        (userModel) async {
          AppLogger.debug(">>> [AppAuthCubit] Profil berhasil disinkronkan.");
          isProfileValid = true;
          isOnline = true; // Tandai bahwa kita ONLINE
        },
      );

      if (isClosed) return;

      // Jika profil lokal pun tidak ada, tendang ke Login
      if (!isProfileValid) {
        emit(AppUnauthenticated());
        return;
      }

      // 3. Verifikasi UUID Perangkat (Hanya dilakukan jika ONLINE)
      if (isOnline) {
        AppLogger.debug(
          ">>> [AppAuthCubit] Memverifikasi UUID perangkat ke server...",
        );
        final isDeviceValid = await _authUseCase.checkDeviceUuid();

        if (isClosed) return;

        if (!isDeviceValid) {
          AppLogger.error(
            ">>> [AppAuthCubit] UUID tidak cocok! Melakukan Force Logout.",
          );
          await _executeForceLogoutProcedure();
          return;
        }
      } else {
        AppLogger.debug(
          ">>> [AppAuthCubit] Mode Offline: Melewati pengecekan UUID server.",
        );
      }

      if (isClosed) return;
      emit(AppAuthenticated());
    } catch (e, stackTrace) {
      AppLogger.error(
        ">>> [AppAuthCubit] ERROR fatal di checkStatus",
        e,
        stackTrace,
      );
      if (isClosed) return;
      emit(AppUnauthenticated());
    }
  }

  /// Helper untuk merapikan kode logout agar Cubit tidak kepanjangan
  Future<void> _executeForceLogoutProcedure() async {
    final storage = GetIt.instance<ISecureStorageManager>();
    await storage.saveLogoutReason('DEVICE_MISMATCH');
    await storage.clearPasswordOnly();
    await _authUseCase.logout();

    if (isClosed) return;
    emit(AppUnauthenticated());
  }

  Future<void> forceLogout() async {
    await _authUseCase.logout();

    if (isClosed) return;
    emit(AppUnauthenticated());
  }
}
